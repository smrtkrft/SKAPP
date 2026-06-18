// Keeps every paired BF's SYSTEM-kind endpoint in sync with the local
// SKAPP install's webhook URL.
//
// Triggers a sync run when:
//   - The bindings list changes (binding added / removed / enabled
//     toggled). If the device gains its first binding we register the
//     listener URL on it; if the last binding goes away we unregister.
//   - The paired-device list changes (a new device might immediately
//     have bindings copied from a template, or a device was just
//     unpaired and we tear down its slot best-effort).
//   - Network identity changes (port, bearer rotation — bearer is not
//     used by the bond-signed webhook, but a port change definitely
//     changes the URL).
//
// Sync semantics:
//   - "Has at least one enabled binding for this device" → push
//     `api.system.add --url <listener-url>`.
//   - "Has zero bindings" → push `api.system.remove`.
//   - Idempotent on the BF side (upsert by peer_id), so spamming this
//     during rapid-fire UI toggles is safe.
//   - Devices that aren't currently reachable (offline, BLE/TCP both
//     fail) are skipped silently. The next session open re-runs sync,
//     so missed pushes self-heal once the device is back in range.
//
// Desktop-only: mobile and web have no HTTP listener (`SkappHttpServer.
// supported == false`), so there's no URL to publish. Calling start()
// on those platforms is a no-op.

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cli/cli_providers.dart';
import '../../../core/network/skapp_http_server.dart';
import '../../../core/storage/paired_devices_store.dart';
import '../../../core/system/network_identity_provider.dart';
import 'action_binding.dart';
import 'skapi_providers.dart';

/// Per-device snapshot of the SYSTEM endpoint sync state. Surfaced to
/// the UI so the user can tell whether SKAPP successfully wrote its
/// listener URL onto the BF (i.e., whether a sayım-bitti webhook will
/// actually reach this install).
enum SyncStatus {
  /// No paired-device + binding combination yet seen for this id.
  idle,
  /// SKAPP is currently pushing api.system.add or api.system.remove.
  pending,
  /// Last push succeeded — BF holds an up-to-date entry.
  ok,
  /// Last push failed — see [errorCode] / [errorReason]. Most common
  /// causes: cihaz offline, eski firmware (api.system.add bilinmiyor),
  /// slot havuzu dolu.
  failed,
  /// Sync explicitly removed the slot (no bindings left for this device).
  removed,
}

class SyncRecord {
  const SyncRecord({
    required this.status,
    this.errorCode,
    this.errorReason,
    this.updatedAt,
  });

  final SyncStatus status;
  final String? errorCode;
  final String? errorReason;
  final DateTime? updatedAt;

  static const idle = SyncRecord(status: SyncStatus.idle);

  SyncRecord copyWith({
    SyncStatus? status,
    String? errorCode,
    String? errorReason,
    DateTime? updatedAt,
  }) =>
      SyncRecord(
        status: status ?? this.status,
        errorCode: errorCode ?? this.errorCode,
        errorReason: errorReason ?? this.errorReason,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}

class SystemEndpointSyncStateNotifier
    extends Notifier<Map<String, SyncRecord>> {
  @override
  Map<String, SyncRecord> build() => const <String, SyncRecord>{};

  void set(String deviceId, SyncRecord record) {
    state = {...state, deviceId: record};
  }

  void clear(String deviceId) {
    final next = {...state};
    next.remove(deviceId);
    state = next;
  }
}

/// Riverpod handle. UI consumers (SKAPI Aksiyonlarım rows, BF dashboard
/// API zinciri summary) watch this to render per-device badges.
final systemEndpointSyncStateProvider = NotifierProvider<
    SystemEndpointSyncStateNotifier, Map<String, SyncRecord>>(
  SystemEndpointSyncStateNotifier.new,
);

class SystemEndpointSyncService {
  SystemEndpointSyncService(this._ref);

  final Ref _ref;

  // Coalesces rapid-fire trigger calls into a single sync run after a
  // short debounce. Without this a single binding edit can fan out into
  // 3–5 sync runs (paired-list re-emit, bindings re-emit, identity
  // re-emit), each opening a fresh CLI session.
  Timer? _debounce;
  bool _running = false;

  /// Faz C wiring — call once from MainShell. start() registers the
  /// provider listeners and kicks off an initial sync after a tick so
  /// existing paired devices line up with whatever bindings are already
  /// stored.
  void start() {
    if (!_supported) {
      debugPrint('[SYSEP] platform unsupported, sync disabled');
      return;
    }
    _ref.listen<List<ActionBinding>>(bindingsProvider, (prev, next) {
      _schedule(reason: 'bindings');
    });
    _ref.listen<List<PairedDevice>>(pairedDevicesProvider, (prev, next) {
      _schedule(reason: 'paired-list');
    });
    _ref.listen<NetworkIdentity>(networkIdentityProvider, (prev, next) {
      // Only the port matters for the URL; ignore name-only changes to
      // avoid bouncing the BF for cosmetic edits.
      if (prev?.port != next.port) {
        _schedule(reason: 'identity-port');
      }
    });
    _schedule(reason: 'initial');
  }

  /// Forces a sync run without waiting for the debounce window. Called
  /// after a device session opens so a freshly-online BF receives the
  /// current listener URL + a fresh time.set immediately, even if no
  /// bindings/paired/port event would otherwise schedule a run.
  ///
  /// Critical because BF firmware persists the SYSTEM URL in NVS — once
  /// a device booted with a stale URL (e.g. a previous SKAPP run picked
  /// the wrong NIC), only an explicit re-push can correct it. Reactive
  /// listeners alone don't fire when NICs change between SKAPP launches.
  Future<void> forceSync({required String reason}) async {
    if (!_supported) return;
    _debounce?.cancel();
    if (_running) return; // a sync is already mid-flight
    _running = true;
    try {
      await _runSync(reason: reason);
    } catch (e, st) {
      debugPrint('[SYSEP] forceSync failed: $e\n$st');
    } finally {
      _running = false;
    }
  }

  bool get _supported {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  void _schedule({required String reason}) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (_running) return; // single-flight
      _running = true;
      try {
        await _runSync(reason: reason);
      } catch (e, st) {
        debugPrint('[SYSEP] sync failed: $e\n$st');
      } finally {
        _running = false;
      }
    });
  }

  Future<void> _runSync({required String reason}) async {
    final url = await _resolveListenerUrl();
    if (url == null) {
      debugPrint('[SYSEP] no usable host IP, skip ($reason)');
      return;
    }
    final paired = _ref.read(pairedDevicesProvider);
    debugPrint('[SYSEP] sync $reason: ${paired.length} paired, url=$url');

    final stateNotifier =
        _ref.read(systemEndpointSyncStateProvider.notifier);

    for (final d in paired) {
      final wantRegistered =
          _ref.read(bindingsForDeviceProvider(d.id)).isNotEmpty;
      stateNotifier.set(
        d.id,
        SyncRecord(
          status: SyncStatus.pending,
          updatedAt: DateTime.now(),
        ),
      );
      try {
        // Open a session via the shared provider. Tight 5s timeout —
        // offline devices are expected and shouldn't block the sync.
        final session = await _ref
            .read(deviceSessionProvider(d.id).future)
            .timeout(const Duration(seconds: 5));
        if (wantRegistered) {
          // BF firmware has no SNTP. Without a valid wall clock, the
          // BF-side HMAC over `body\nts\nnonce` lands at SKAPP with
          // ts ≈ 0 and WebhookReceiver rejects the request as stale.
          // Push the laptop's clock first; firmware persists nothing
          // (volatile RTC), so we re-push every sync. Failure here is
          // soft — we still try api.system.add so the URL slot is
          // saved even on older firmware that lacks `time.set`.
          try {
            final epochSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
            // BF firmware (sk_baseline.c:474+482) reads the named arg
            // and runs `strtoll(unix_str, NULL, 10)` on it — the value
            // MUST be a string. Sending an integer caused
            // `sk_cli_arg_named` to return null (or strtoll to fail),
            // BF clock stayed at 0, and every webhook landed at SKAPP
            // with skew ≈ 56 years → "Stale or future-dated request".
            // Stringify explicitly to match the CLI parameter contract.
            final tr = await session.client.send(
              'time.set',
              args: {'unix': epochSec.toString()},
              timeout: const Duration(seconds: 4),
            );
            debugPrint('[SYSEP]   ${d.id}: time.set ok=${tr.ok} '
                'err=${tr.err}');
          } catch (e) {
            debugPrint('[SYSEP]   ${d.id}: time.set skip ($e)');
          }
          // Wipe ALL SYSTEM slots before re-adding ours. Reason: when
          // SKAPP is reinstalled (or secure storage is wiped) a fresh
          // peer_id is generated; the OLD peer_id's SYSTEM slot in BF's
          // NVS becomes orphaned — `api.system.remove` won't reach it
          // (per-peer ownership), but BF still fires that orphan URL on
          // every countdown, hits a 10s TCP timeout, and the user sees
          // "oops bağlantı yok" even though the new URL is correct.
          // `api.system.purge` is ownership-blind and clears the whole
          // SYSTEM bucket; we immediately follow with api.system.add so
          // our own slot is re-established. On older firmware lacking
          // this command the response is `unknown_command` — we ignore
          // and continue (worst case the orphan stays, same as before).
          try {
            final pr = await session.client.send(
              'api.system.purge',
              timeout: const Duration(seconds: 4),
            );
            debugPrint('[SYSEP]   ${d.id}: api.system.purge ok=${pr.ok} '
                'err=${pr.err}');
          } catch (e) {
            debugPrint('[SYSEP]   ${d.id}: api.system.purge skip ($e)');
          }
          final r = await session.client.send(
            'api.system.add',
            args: {'url': url},
            timeout: const Duration(seconds: 6),
          );
          debugPrint('[SYSEP]   ${d.id}: api.system.add ok=${r.ok} '
              'err=${r.err}');
          if (r.ok) {
            // Verify by reading the bucket back. Push response of "ok"
            // says BF accepted the call but doesn't say the slot was
            // actually persisted with the URL we sent (NVS commit issue,
            // CLI param swallow, etc.). On mismatch surface as failed
            // so the user sees something specific in the UI rather
            // than a misleading green badge that doesn't match reality.
            try {
              final verifyResp = await session.client.send(
                'api.endpoint.list',
                timeout: const Duration(seconds: 4),
              );
              final data = verifyResp.data;
              List<dynamic>? rawList;
              if (data is List) {
                rawList = data;
              } else if (data is Map && data['endpoints'] is List) {
                rawList = data['endpoints'] as List;
              }
              bool found = false;
              if (rawList != null) {
                for (final e in rawList) {
                  if (e is Map &&
                      (e['kind'] as String?)?.toLowerCase() == 'system' &&
                      e['url'] == url) {
                    found = true;
                    break;
                  }
                }
              }
              if (!found) {
                debugPrint('[SYSEP]   ${d.id}: api.system.add reported '
                    'ok but verify list does not contain url=$url');
                stateNotifier.set(
                  d.id,
                  SyncRecord(
                    status: SyncStatus.failed,
                    errorCode: '__sync_err_url_not_persisted',
                    errorReason: '__sync_err_url_not_persisted',
                    updatedAt: DateTime.now(),
                  ),
                );
                continue;
              }
            } catch (e) {
              // Verify-step failures don't undo the push: BF may simply
              // not have api.endpoint.list (very old firmware) or the
              // session may have hiccupped. Log but treat the push as
              // ok per the response.
              debugPrint('[SYSEP]   ${d.id}: verify list skip ($e)');
            }
            stateNotifier.set(
              d.id,
              SyncRecord(
                status: SyncStatus.ok,
                updatedAt: DateTime.now(),
              ),
            );
          } else {
            stateNotifier.set(
              d.id,
              SyncRecord(
                status: SyncStatus.failed,
                errorCode: r.err,
                errorReason: _explainErr(r.err),
                updatedAt: DateTime.now(),
              ),
            );
          }
        } else {
          final r = await session.client.send(
            'api.system.remove',
            timeout: const Duration(seconds: 6),
          );
          debugPrint('[SYSEP]   ${d.id}: api.system.remove ok=${r.ok} '
              'err=${r.err}');
          // Removed-or-already-absent counts as ok for UX.
          stateNotifier.set(
            d.id,
            SyncRecord(
              status: SyncStatus.removed,
              updatedAt: DateTime.now(),
            ),
          );
        }
      } catch (e) {
        debugPrint('[SYSEP]   ${d.id}: skip ($e)');
        stateNotifier.set(
          d.id,
          SyncRecord(
            status: SyncStatus.failed,
            errorCode: 'ERR_OFFLINE',
            errorReason: _explainOffline(e),
            updatedAt: DateTime.now(),
          ),
        );
      }
    }
  }

  /// Maps firmware error codes to canonical reason sentinels that the UI
  /// layer renders via AppLocalizations. Most common cases:
  ///   ERR_UNKNOWN_COMMAND  → cihazda eski firmware
  ///   ERR_NOT_FOUND        → bond mismatch (peer_id geçersiz)
  ///   ERR_INTERNAL+slots_full → 8 SYSTEM slot dolu
  ///
  /// Returns one of the `SyncErrReason.*` sentinels below, or the raw
  /// firmware code when there is no specific mapping. UI does the
  /// translation via [translateSyncErrReason].
  String _explainErr(String? code) {
    if (code == null) return SyncErrReason.unknown;
    if (code == 'ERR_UNKNOWN_COMMAND') return SyncErrReason.unknownCommand;
    if (code == 'ERR_NOT_AUTHENTICATED') return SyncErrReason.notAuthenticated;
    if (code == 'ERR_NOT_FOUND') return SyncErrReason.notFound;
    if (code == 'ERR_INTERNAL') return SyncErrReason.internal;
    return code;
  }

  String _explainOffline(Object e) {
    final s = e.toString();
    if (s.contains('TimeoutException')) {
      return SyncErrReason.timeout;
    }
    if (s.contains('No bond stored')) {
      return SyncErrReason.noBond;
    }
    if (s.contains('Bağlanılamadı') || s.contains('connect')) {
      return SyncErrReason.connect;
    }
    return s.length > 80 ? '${s.substring(0, 80)}…' : s;
  }

  /// Best-effort host IP discovery. Scans all active IPv4 interfaces and
  /// picks the one most likely reachable from a BF on the same Wi-Fi.
  /// Returns null if no usable interface is found.
  ///
  /// Scoring:
  ///  * Interface name match: Wi-Fi / Wireless / wlan* / en0-en9 → +60
  ///    Ethernet / Local Area Connection → +40
  ///    Virtualization (vEthernet, WSL, VMware, VirtualBox, vmnet) → -80
  ///    VPN tunnels (Tailscale, ZeroTier, Wireguard, tun*, tap*) → -60
  ///    Docker (docker, br-) → -70
  ///  * IP range: 192.168/16 → +30, 10/8 → +20, 172.16-31 → -10
  ///  * Loopback / link-local (169.254/16) → rejected outright.
  ///
  /// Best score wins; tie broken by interface enumeration order. Logged
  /// with selected score so the Settings card can later expose this.
  Future<String?> _resolveListenerUrl() async {
    final id = _ref.read(networkIdentityProvider);
    final server = _ref.read(skappHttpServerProvider);
    if (!server.supported) return null;

    try {
      final ifaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );

      String? bestIp;
      String? bestIface;
      int bestScore = -1 << 30;

      for (final iface in ifaces) {
        final nameScore = _scoreInterfaceName(iface.name);
        for (final addr in iface.addresses) {
          if (addr.isLoopback) continue;
          final ip = addr.address;
          if (ip.startsWith('169.254.')) continue;
          final ipScore = _scoreIp(ip);
          final total = nameScore + ipScore;
          if (total > bestScore) {
            bestScore = total;
            bestIp = ip;
            bestIface = iface.name;
          }
        }
      }

      if (bestIp != null) {
        // BF (ESP32) connects over PLAIN HTTP to the dedicated BF webhook
        // port (id.port + 1). The main id.port is HTTPS with a self-signed
        // cert that BF's esp_http_client (public CA bundle) can't validate,
        // so a plain-HTTP URL to id.port hit the TLS socket and BF reported
        // ERR_API_CONNECT. SkappHttpServer.bfWebhookPort exposes the actual
        // bound plain port; fall back to id.port + 1 if the server isn't up.
        final bfPort = server.bfWebhookPort ?? (id.port + 1);
        debugPrint('[SYSEP] picked $bestIp via "$bestIface" '
            '(score=$bestScore) bfPort=$bfPort');
        return 'http://$bestIp:$bfPort/api/events/incoming';
      }
    } catch (e) {
      debugPrint('[SYSEP] interface list failed: $e');
    }
    return null;
  }

  static int _scoreInterfaceName(String name) {
    final n = name.toLowerCase();
    // Virtualization / WSL / Hyper-V: very low priority. WSL adapter
    // (172.x) is a frequent dev-machine miss-pick on Windows.
    if (n.contains('vethernet') ||
        n.contains('hyper-v') ||
        n.contains('wsl') ||
        n.contains('vmware') ||
        n.contains('vbox') ||
        n.contains('virtualbox') ||
        n.contains('vmnet')) {
      return -80;
    }
    if (n.contains('docker') || n.startsWith('br-')) return -70;
    if (n.contains('tailscale') ||
        n.contains('zerotier') ||
        n.contains('wireguard') ||
        n.startsWith('tun') ||
        n.startsWith('tap') ||
        n.contains('utun')) {
      return -60;
    }
    // Real LAN interfaces.
    if (n.contains('wi-fi') ||
        n.contains('wifi') ||
        n.contains('wireless') ||
        n.startsWith('wlan') ||
        n.startsWith('wlp') ||
        // macOS Wi-Fi is en0 (rarely en1); first few en* most likely
        // physical NICs.
        RegExp(r'^en[0-9]$').hasMatch(n)) {
      return 60;
    }
    if (n.contains('ethernet') ||
        n.contains('local area connection') ||
        n.startsWith('eth') ||
        n.startsWith('enp') ||
        n.startsWith('ens')) {
      return 40;
    }
    return 0;
  }

  static int _scoreIp(String ip) {
    if (ip.startsWith('192.168.')) return 30;
    if (ip.startsWith('10.')) return 20;
    // 172.16-31 is private RFC1918 but also Docker overlay default. We
    // mildly penalise; positive interface name (Ethernet / Wi-Fi) still
    // wins overall.
    if (ip.startsWith('172.')) {
      final m = RegExp(r'^172\.(\d+)\.').firstMatch(ip);
      if (m != null) {
        final second = int.tryParse(m.group(1)!) ?? 0;
        if (second >= 16 && second <= 31) return -10;
      }
    }
    return 0;
  }

  void dispose() {
    _debounce?.cancel();
  }
}

/// Canonical error-reason sentinels emitted by [SystemEndpointSyncService].
/// UI layer uses these as opaque keys, mapping each to an
/// [AppLocalizations] entry. New codes added here must also gain an
/// `syncErr*` key in app_en.arb / app_tr.arb.
class SyncErrReason {
  static const unknownCommand = '__sync_err_unknown_command';
  static const notAuthenticated = '__sync_err_not_authenticated';
  static const notFound = '__sync_err_not_found';
  static const internal = '__sync_err_internal';
  static const unknown = '__sync_err_unknown';
  static const timeout = '__sync_err_timeout';
  static const noBond = '__sync_err_no_bond';
  static const connect = '__sync_err_connect';

  const SyncErrReason._();
}

/// Best-effort: resolve the listener URL the same way the sync service
/// would push it to the BF. Used by UI surfaces to show the user which
/// IP/port BF devices are being told to call back. Refreshed on every
/// watch — caller wraps with FutureProvider.autoDispose if needed.
Future<String?> resolveListenerUrlForUi(Ref ref) async {
  final id = ref.read(networkIdentityProvider);
  final server = ref.read(skappHttpServerProvider);
  if (!server.supported) return null;

  String? bestIp;
  int bestScore = -1 << 30;
  try {
    final ifaces = await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.IPv4,
    );
    for (final iface in ifaces) {
      final ns = SystemEndpointSyncService._scoreInterfaceName(iface.name);
      for (final addr in iface.addresses) {
        if (addr.isLoopback) continue;
        final ip = addr.address;
        if (ip.startsWith('169.254.')) continue;
        final total = ns + SystemEndpointSyncService._scoreIp(ip);
        if (total > bestScore) {
          bestScore = total;
          bestIp = ip;
        }
      }
    }
  } catch (_) {/* offline */}

  if (bestIp == null) return null;
  return 'http://$bestIp:${id.port}/api/events/incoming';
}

final currentListenerUrlProvider = FutureProvider<String?>((ref) {
  // Re-resolve when the listener port or running state changes.
  ref.watch(networkIdentityProvider);
  ref.watch(skappHttpServerRunningProvider);
  return resolveListenerUrlForUi(ref);
});

final systemEndpointSyncServiceProvider =
    Provider<SystemEndpointSyncService>((ref) {
  final svc = SystemEndpointSyncService(ref);
  ref.onDispose(svc.dispose);
  return svc;
});
