// Reset Pairings + Factory Reset orchestrator. Plan referansı:
// `~/.claude/plans/reset.md`. Storage cascade matrisi 12 katman:
// paired_devices, bindings, peer_tokens (index + secure), skapp_peers,
// bond.* (secure), app.peer_id (secure), network_identity (prefs +
// bearer secure), TLS cert (secure + fallback file), SharedPreferences
// genel, autostart registry (Windows), tray, app support custom files.
//
// Reset Pairings: paired+bondlar+peer_token+skapp_peer silinir;
// identity, settings, theme, notes KORUNUR.
// Factory Reset: Reset Pairings + identity/cert/autostart/app peer_id +
// SharedPreferences komple wipe + app support cleanup.
//
// Cascade'in adımları best-effort try/catch'le sarılır; hatalar
// ResetSummary.errors listesinde toplanır, kullanıcıya gösterilir.

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../cli/bond_store.dart';
import '../desktop_lifecycle/tray_lifecycle.dart';
import '../network/peer_tokens_provider.dart';
import '../network/skapp_http_server.dart';
import '../network/skapp_listener_service.dart';
import '../network/skapp_peer_store.dart';
import '../storage/paired_devices_store.dart';
import '../storage/preferences_provider.dart';
import '../system/network_identity_provider.dart';
import '../../features/skapi/data/skapi_providers.dart';

/// Reset operasyonu sonucu. UI bunu okur ve summary dialog'unu render
/// eder. `errors` boş ise temiz başarı; doluysa kullanıcıya "uyarılarla
/// tamamlandı" gösterilir (atomik fail yok, partial-success best-effort).
class ResetSummary {
  ResetSummary({
    required this.kind,
    this.pairedDevicesRemoved = 0,
    this.bindingsRemoved = 0,
    this.peerTokensRevoked = 0,
    this.skappPeersRemoved = 0,
    this.bondsCleared = 0,
    this.networkIdentityReset = false,
    this.tlsCertCleared = false,
    this.autostartUnregistered = false,
    List<String> errors = const [],
  }) : errors = List.unmodifiable(errors);

  final ResetKind kind;
  final int pairedDevicesRemoved;
  final int bindingsRemoved;
  final int peerTokensRevoked;
  final int skappPeersRemoved;
  final int bondsCleared;
  final bool networkIdentityReset;
  final bool tlsCertCleared;
  final bool autostartUnregistered;
  final List<String> errors;

  bool get hasErrors => errors.isNotEmpty;
}

enum ResetKind { pairings, factory }

class ResetService {
  ResetService(this._ref);
  final Ref _ref;

  /// Reset Pairings: cihaz bond'larını ve peer bağlantılarını siler.
  /// Identity, settings, theme, notes korunur.
  Future<ResetSummary> resetPairings() async {
    final errors = <String>[];

    // 1. Listener'ı durdur (varsa) → paired peer'larla aktif baglanti
    //    yetimlenmemis sekilde kapansın.
    await _runStep(errors, 'listener.stop', () async {
      final svc = _ref.read(skappListenerServiceProvider);
      await svc.stop();
    });

    // 2-3. Mevcut sayilari onceden okuyun (summary icin).
    final pairedBefore = _ref.read(pairedDevicesProvider).length;
    final bindingsBefore = _ref.read(bindingsProvider).length;
    final peersBefore = _ref.read(skappPeersProvider).length;

    int bondsCleared = 0;
    await _runStep(errors, 'bond.clearAll', () async {
      bondsCleared = await _ref.read(bondStoreProvider).clearAllBonds();
    });

    await _runStep(errors, 'peerTokens.revokeAll', () async {
      await _ref.read(peerTokensProvider.notifier).revokeAll();
    });

    await _runStep(errors, 'pairedDevices.clearAll', () async {
      await _ref.read(pairedDevicesProvider.notifier).clearAll();
    });

    await _runStep(errors, 'bindings.clearAll', () async {
      await _ref.read(bindingsProvider.notifier).clearAll();
    });

    await _runStep(errors, 'skappPeers.clearAll', () async {
      await _ref.read(skappPeersProvider.notifier).clearAll();
    });

    // Listener'ı geri ac (developerMode + supported gate'i icinde
    // start() zaten dogrulayacak).
    await _runStep(errors, 'listener.restart', () async {
      final svc = _ref.read(skappListenerServiceProvider);
      await svc.start();
    });

    return ResetSummary(
      kind: ResetKind.pairings,
      pairedDevicesRemoved: pairedBefore,
      bindingsRemoved: bindingsBefore,
      peerTokensRevoked: peersBefore,
      skappPeersRemoved: peersBefore,
      bondsCleared: bondsCleared,
      errors: errors,
    );
  }

  /// Factory Reset: HER SEYI siler, app default state'e doner.
  /// Kullaniciya restart onerilir (cached in-memory state ve plugin
  /// handle'lari yenilenmesi icin).
  Future<ResetSummary> factoryReset() async {
    final errors = <String>[];

    // 1. Reset Pairings yap (paired + bond + peer + binding).
    final pairings = await resetPairings();
    errors.addAll(pairings.errors);

    // 2. Autostart registry entry'sini sil (Windows).
    bool autostartOk = false;
    await _runStep(errors, 'autostart.unregister', () async {
      autostartOk = await DesktopLifecycle.instance.unregisterAutostart();
    });

    // 3. Network identity'yi default'a dondur (yeni UUID + token).
    await _runStep(errors, 'networkIdentity.reset', () async {
      await _ref.read(networkIdentityProvider.notifier).resetToDefaults();
    });

    // 4. TLS cert'i temizle (bir sonraki listener start'ta yeniden uretilir).
    await _runStep(errors, 'tls.clear', () async {
      const storage = FlutterSecureStorage();
      await storage.delete(key: 'tls.cert.v1');
      await storage.delete(key: 'tls.key.v1');
      // Linux fallback path'i de temizle.
      try {
        final dir = await getApplicationSupportDirectory();
        final tlsDir = Directory('${dir.path}/skapp_tls');
        if (await tlsDir.exists()) {
          await tlsDir.delete(recursive: true);
        }
      } catch (e) {
        debugPrint('[reset] tls fallback dir delete failed: $e');
      }
      // Riverpod cache'inde aktif cert varsa invalidate (bir sonraki
      // listener start fresh cert yukler).
      _ref.invalidate(currentTlsCertProvider);
    });

    // 5. app.peer_id'yi sil (yeni install hissi).
    await _runStep(errors, 'bond.appPeerId.clear', () async {
      await _ref.read(bondStoreProvider).clearAppPeerId();
    });

    // 6. SKAPI overrides dizinini temizle (kullanici override script'leri).
    await _runStep(errors, 'appSupport.skapiOverrides.clear', () async {
      final dir = await getApplicationSupportDirectory();
      final overrides = Directory('${dir.path}/skapi/overrides');
      if (await overrides.exists()) {
        await overrides.delete(recursive: true);
      }
    });

    // 7. SharedPreferences komple wipe (theme, locale, channel, notes,
    //    favourites, developerMode dahil hepsi). Bu adim EN SON cunku
    //    yukaridaki step'ler hala prefs'e yaziyor olabilir; clear'dan
    //    sonra her sey geri default'a doner.
    //
    //    NOT: networkIdentityProvider state'i bellekte halen yeni
    //    default'tadir (step 3); clear sonrasinda persist edilmesi
    //    icin tekrar resetToDefaults'a gerek yok, bellek yeterli;
    //    bir sonraki app start'inda zaten ilk-acilis path'i tetiklenir.
    await _runStep(errors, 'sharedPreferences.clear', () async {
      final prefs = _ref.read(sharedPreferencesProvider);
      await prefs.clear();
    });

    return ResetSummary(
      kind: ResetKind.factory,
      pairedDevicesRemoved: pairings.pairedDevicesRemoved,
      bindingsRemoved: pairings.bindingsRemoved,
      peerTokensRevoked: pairings.peerTokensRevoked,
      skappPeersRemoved: pairings.skappPeersRemoved,
      bondsCleared: pairings.bondsCleared,
      networkIdentityReset: true,
      tlsCertCleared: true,
      autostartUnregistered: autostartOk,
      errors: errors,
    );
  }

  /// Adım wrapper: hatayi yakalar, etiket + mesajla `errors` listesine
  /// ekler. Bir adim duser ise diger adimlar yine calismaya devam eder
  /// (best-effort, atomik degil).
  Future<void> _runStep(
    List<String> errors,
    String label,
    Future<void> Function() action,
  ) async {
    try {
      await action();
      debugPrint('[reset] step ok: $label');
    } catch (e, st) {
      debugPrint('[reset] step failed: $label: $e\n$st');
      errors.add('$label: $e');
    }
  }
}

final resetServiceProvider = Provider<ResetService>((ref) {
  return ResetService(ref);
});

/// Helper: app desktop'ta mı (Reset/Factory Reset desktop-only kabul
/// edilmez ama autostart cleanup adımı no-op olur). Ayrıca platform
/// gate'ler tek tek ResetService içinde değil, çağıran UI'de değil,
/// service'in kendi adımlarında zaten korumayla yapılıyor.
bool get resetServiceSupportsAutostart {
  if (kIsWeb) return false;
  return Platform.isWindows; // mac/linux ileride
}
