// Periodic mDNS browser that keeps PairedDevice.lastSeen fresh whenever
// a paired SmartKraft device announces itself on `_skapp._tcp.local`.
//
// Phase 1 scope (per the plan + the no-fake-data rule):
//   - BROWSE only, never announce. Until the SKAPP HTTP listener exists
//     (Phase 2) we have no honest service to back an announcement with.
//   - Match-and-touch: announces from devices we don't know are ignored.
//     Discovery for "find a brand new device on the LAN" is a separate
//     flow (DiscoveryScreen) and not this browser's job.
//   - When BF firmware is not yet announcing (Phase 2 firmware work) the
//     scan returns empty, that is the correct signal, not an error.
//
// The browser is started by the SKAPI screen (which watches it) so it
// stays alive while the app is in the foreground; provider is non-
// autoDispose by virtue of being a regular Notifier.

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cli/mdns_discovery.dart';
import '../storage/paired_devices_store.dart';

class MdnsBrowserState {
  const MdnsBrowserState({
    required this.isScanning,
    required this.lastScanAt,
    required this.lastMatchedCount,
    required this.lastError,
  });

  /// Whether a scan is currently in flight. UI may show a faint indicator
  /// but should not block on this, scans are best-effort.
  final bool isScanning;

  /// When the most recent scan completed (success or empty result).
  final DateTime? lastScanAt;

  /// How many announcements in the last scan matched a paired device.
  /// Zero is normal until the firmware side starts broadcasting.
  final int lastMatchedCount;

  /// Last error message, if any. Surfaced for diagnostics; the browser
  /// keeps trying on the next interval regardless.
  final String? lastError;

  factory MdnsBrowserState.initial() => const MdnsBrowserState(
        isScanning: false,
        lastScanAt: null,
        lastMatchedCount: 0,
        lastError: null,
      );

  MdnsBrowserState copyWith({
    bool? isScanning,
    DateTime? lastScanAt,
    int? lastMatchedCount,
    String? lastError,
    bool clearError = false,
  }) =>
      MdnsBrowserState(
        isScanning: isScanning ?? this.isScanning,
        lastScanAt: lastScanAt ?? this.lastScanAt,
        lastMatchedCount: lastMatchedCount ?? this.lastMatchedCount,
        lastError: clearError ? null : (lastError ?? this.lastError),
      );
}

/// How often we re-sweep the LAN. Devices announce TXT/SRV records on a
/// short TTL but our coarse-grained "is this device alive on WiFi?" view
/// doesn't need to be tighter than this. 30s is the upper bound on how
/// long a stale TCP cache can hurt cold-start latency: after a sweep,
/// any matched device gets its lastIp/lastPort touched, so the next
/// connect attempt rides the cache fast-path again.
const Duration _scanInterval = Duration(seconds: 30);

/// Per-scan timeout passed down to MdnsDiscovery.scanAll. Short so a
/// noisy or unreachable LAN doesn't stall the next sweep.
const Duration _scanTimeout = Duration(seconds: 3);

class MdnsBrowserNotifier extends Notifier<MdnsBrowserState> {
  Timer? _timer;
  bool _scanInFlight = false;

  @override
  MdnsBrowserState build() {
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });
    // Kick off an immediate sweep so the first paired-device card has a
    // chance to flip to "seen" without waiting a full interval.
    Future.microtask(_scanOnce);
    _timer = Timer.periodic(_scanInterval, (_) => _scanOnce());
    return MdnsBrowserState.initial();
  }

  /// Run a single sweep. Public so the UI can offer a manual refresh later
  /// without exposing the timer.
  Future<void> scanNow() => _scanOnce();

  Future<void> _scanOnce() async {
    if (_scanInFlight) return;
    _scanInFlight = true;
    state = state.copyWith(isScanning: true, clearError: true);
    try {
      final results = await MdnsDiscovery.scanAll(timeout: _scanTimeout);
      final paired = ref.read(pairedDevicesProvider);
      // mDNS instance name == PairedDevice.name (SmartKraft identity), NOT
      // PairedDevice.id (BLE MAC). Build a name → id map so we can look
      // up the bond-store key from the announcement payload.
      final byName = {for (final d in paired) d.name: d.id};

      // Tüm touch'ları topla, hepsini bekle, sonra browser state'i
      // tek seferde update et. Önceki versiyon `unawaited` kullandığı
      // için browser state pairedDevicesProvider'dan ÖNCE güncelleniyor,
      // home/devices ekranları iki ardışık rebuild oluyordu (önce browser
      // changed, sonra paired changed). Aynı tick'te birleşik rebuild
      // daha temiz: önce paired update + bekle + sonra browser state.
      var matched = 0;
      final touches = <Future<void>>[];
      for (final endpoint in results) {
        final id = byName[endpoint.instance];
        if (id != null) {
          matched++;
          touches.add(
            ref.read(pairedDevicesProvider.notifier).touch(
                  id,
                  lastIp: endpoint.host,
                  lastPort: endpoint.port,
                ),
          );
        }
      }
      await Future.wait(touches);

      state = state.copyWith(
        isScanning: false,
        lastScanAt: DateTime.now(),
        lastMatchedCount: matched,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
        lastError: e.toString(),
      );
    } finally {
      _scanInFlight = false;
    }
  }
}

final mdnsBrowserProvider =
    NotifierProvider<MdnsBrowserNotifier, MdnsBrowserState>(
        MdnsBrowserNotifier.new);
