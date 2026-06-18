import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cli/cli_client.dart';
import '../../../core/cli/cli_providers.dart';
import '../../../core/cli/cli_transport.dart';
import '../../../core/cli/secure_store_client.dart';
import '../../../core/ui/device_session_views.dart';

/// Inherited handle to the live CLI client and secure-store client for a
/// BF device.
///
/// Mounted by [BfHomeScreen] once the device session resolves; every
/// downstream BF screen (dashboard, api chain, settings, device info,
/// events, logs) reads the clients from here via `BfSession.of(context)`.
///
/// This was the contract the modular `DeviceModuleScope` provided
/// historically; with the move to monolithic device definitions we no
/// longer route through an interface package, but the same widget-tree
/// scoping pattern keeps sub-screens free of constructor wiring.
class BfSession extends InheritedWidget {
  const BfSession({
    super.key,
    required this.deviceId,
    required this.client,
    required this.secure,
    required this.transportKind,
    required super.child,
  });

  /// Persistent identity, e.g. `BF-A06TMFSQT`. Stable across the screen
  /// lifetime; used for context in CLI commands and analytics.
  final String deviceId;

  /// Authenticated, ready-to-send client over BLE or TCP. Already past
  /// the secure handshake when handed in here.
  final CliClient client;

  /// Wrapper around `secure.*` and `userdata.*` CLI commands. Rides the
  /// same authenticated client.
  final SecureStoreClient secure;

  /// Which physical transport this session is riding right now.
  /// Surfaced to the dashboard so the connection pill can show the truth
  /// (BLE / WiFi) instead of a hardcoded "BLE" label. Updates when the
  /// underlying provider rebuilds, the dashboard just reads it.
  final CliTransportKind transportKind;

  static BfSession of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<BfSession>();
    assert(
      scope != null,
      'BfSession not found, BF screen mounted outside BfHomeScreen.',
    );
    return scope!;
  }

  /// Push a child route under this session's scope.
  ///
  /// Navigator.push, MaterialApp Navigator root'una yeni route ekler.
  /// BfSession bir InheritedWidget olduğu için yeni route'lar bu
  /// scope'un dışına düşer, `BfSession.of(ctx)` null döner ve
  /// bootstrap'ta NPE atar (sub-screen "spinner sonsuz"). Bu helper
  /// route'u BfSession ile sarar.
  ///
  /// **Snapshot DEĞİL, provider'a ABONE.** Eski sürüm parent'tan
  /// `client/secure` snapshot alıyordu; transport düşüp provider
  /// yeniden çalıştığında (auto-invalidate veya manuel refresh) yeni
  /// route eski/ölü client'a sımsıkı tutunuyordu. Sub-screen'de
  /// `userdata.*` çağrıları sessizce timeout'a düşüyordu, Notebook'un
  /// "açılmıyor" semptomu işte bu. Şimdi her pushed route kendi
  /// Consumer'ını kuruyor, deviceSessionProvider değiştiğinde BfSession
  /// otomatik tazeleniyor; child'ın State'i (TextField içeriği vs.)
  /// InheritedWidget değişimi karşısında korunuyor.
  static Future<T?> push<T>(BuildContext context, Widget child) {
    final deviceId = BfSession.of(context).deviceId;
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (_) => _BfSessionRouteGate(
          deviceId: deviceId,
          child: child,
        ),
      ),
    );
  }

  /// Push a BF sub-route from a context that is NOT inside a BfSession
  /// scope (typically SKAPI tab's "+ Yeni Aksiyon" or "Cihaza yükle" CTA).
  /// Functionally identical to [push] but takes `deviceId` directly
  /// instead of reading it from an inherited session.
  static Future<T?> pushForDevice<T>({
    required BuildContext context,
    required String deviceId,
    required Widget child,
  }) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (_) => _BfSessionRouteGate(
          deviceId: deviceId,
          child: child,
        ),
      ),
    );
  }

  @override
  bool updateShouldNotify(BfSession old) =>
      client != old.client ||
      secure != old.secure ||
      deviceId != old.deviceId ||
      transportKind != old.transportKind;
}

/// Sub-screen route'larını ayakta tutan reactive scope.
///
/// `BfSession.push` tarafından kullanılır. `deviceSessionProvider` ve
/// `secureStoreProvider` aboneliği route ömrü boyunca aktif kalır;
/// her invalidate sonrası BfSession yeni client/secure ile yeniden
/// kurulur ve InheritedWidget değişim sinyali sub-screen'e ulaşır.
///
/// Loading: cihaz yeniden bağlanırken kısa bir spinner. Error: bağlantı
/// kalıcı olarak kopmuş, kullanıcı geri dönmeli.
class _BfSessionRouteGate extends ConsumerWidget {
  const _BfSessionRouteGate({
    required this.deviceId,
    required this.child,
  });

  final String deviceId;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(deviceSessionProvider(deviceId));
    final secureAsync = ref.watch(secureStoreProvider(deviceId));

    return sessionAsync.when(
      loading: () => const DeviceSessionLoading(),
      error: (e, _) => DeviceSessionError(deviceId: deviceId, error: e),
      data: (session) => secureAsync.when(
        loading: () => const DeviceSessionLoading(),
        error: (e, _) => DeviceSessionError(deviceId: deviceId, error: e),
        data: (secure) => BfSession(
          deviceId: deviceId,
          client: session.client,
          secure: secure,
          transportKind: session.transportKind,
          child: child,
        ),
      ),
    );
  }
}
