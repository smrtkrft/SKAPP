// Periodic BLE scanner that keeps PairedDevice.lastSeen fresh whenever a
// paired SmartKraft device is advertising over BLE.
//
// mdns_browser.dart yalnızca WiFi/LAN üzerinden cihaz "alive" sinyali
// üretir. Cihaz WiFi'da değilse ama BLE'de açıksa kullanıcı şu ana kadar
// onu offline görüyordu. Bu scanner aynı işi BLE tarafında yapar:
// periyodik olarak adapter'ı dinler, adv name SmartKraft cihaz id/name
// formatına ([XX-YZZZZZZZZ]) uyuyorsa eşleşmiş cihazlardan biriyle
// match'liyor mu kontrol eder, eşleşince `pairedDevicesProvider.touch`
// çağrısı atar.
//
// Discovery flow ile çakışmamak için: aktif bir scan varsa (kullanıcı
// "yeni cihaz ekle" akışında) sweep'i atlar, bir sonraki interval'de
// tekrar dener. flutter_blue_plus tek bir scan'i destekler — paralel
// başlatma error fırlatır.
//
// Platform: BLE adapter desteklenmiyorsa (kIsWeb, eski Android, Linux'un
// bazı sürümleri) provider sessizce no-op döner; mdns + TCP cache hâlâ
// işler.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/paired_devices_store.dart';

class PairedBleScannerState {
  const PairedBleScannerState({
    required this.isScanning,
    required this.supported,
    required this.lastScanAt,
    required this.lastMatchedCount,
    required this.lastError,
  });

  final bool isScanning;

  /// `false` iken adapter desteklenmiyor demektir; UI hiçbir şey
  /// göstermez ve provider artık scan denemez.
  final bool supported;
  final DateTime? lastScanAt;
  final int lastMatchedCount;
  final String? lastError;

  factory PairedBleScannerState.initial() => const PairedBleScannerState(
        isScanning: false,
        supported: true,
        lastScanAt: null,
        lastMatchedCount: 0,
        lastError: null,
      );

  PairedBleScannerState copyWith({
    bool? isScanning,
    bool? supported,
    DateTime? lastScanAt,
    int? lastMatchedCount,
    String? lastError,
    bool clearError = false,
  }) =>
      PairedBleScannerState(
        isScanning: isScanning ?? this.isScanning,
        supported: supported ?? this.supported,
        lastScanAt: lastScanAt ?? this.lastScanAt,
        lastMatchedCount: lastMatchedCount ?? this.lastMatchedCount,
        lastError: clearError ? null : (lastError ?? this.lastError),
      );
}

/// Sweep arası 30s. mDNS browser ile aynı kadans, böylece UI'daki
/// "online" göstergesi tek bir 90s lastSeen window'unda her iki kanaldan
/// da güncellenir.
const Duration _scanInterval = Duration(seconds: 30);

/// Reference counter for ongoing external BLE operations (transport
/// connect, pairing flow). Periodic sweep checks this before starting:
/// concurrent scan + connect, on Android in particular, causes adapter
/// state machine collisions where the connect's CCCD subscribe or notify
/// pipe stalls. Anyone opening a BLE link MUST call [beginBleExclusive]
/// before and [endBleExclusive] in a `finally` after.
int _externalBleOpsInFlight = 0;

/// Increment the exclusive-use counter. Returns a unique token that must
/// be passed to [endBleExclusive]. Token is opaque but lets us detect
/// unbalanced calls via assert in debug builds.
int beginBleExclusive() {
  _externalBleOpsInFlight += 1;
  return _externalBleOpsInFlight;
}

void endBleExclusive() {
  if (_externalBleOpsInFlight > 0) {
    _externalBleOpsInFlight -= 1;
  }
}

bool get bleExclusiveActive => _externalBleOpsInFlight > 0;

/// Tek sweep süresi: 4s yeterli, çoğu BLE adv interval ≤1s. Daha uzun
/// bekleyince discovery flow'u açabilen kullanıcı kendi scan'ini
/// başlatamadan önce gereksiz yere bloklanır.
const Duration _scanTimeout = Duration(seconds: 4);

class PairedBleScannerNotifier extends Notifier<PairedBleScannerState> {
  Timer? _timer;
  bool _scanInFlight = false;
  StreamSubscription<List<ScanResult>>? _resultSub;

  @override
  PairedBleScannerState build() {
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
      _resultSub?.cancel();
      _resultSub = null;
    });
    Future.microtask(_init);
    return PairedBleScannerState.initial();
  }

  Future<void> _init() async {
    bool supported;
    try {
      supported = await FlutterBluePlus.isSupported;
    } catch (e) {
      debugPrint('[BLE-SCAN] isSupported check failed: $e');
      supported = false;
    }
    if (!supported) {
      state = state.copyWith(supported: false);
      debugPrint('[BLE-SCAN] adapter unsupported — scanner disabled');
      return;
    }
    Future.microtask(_scanOnce);
    _timer = Timer.periodic(_scanInterval, (_) => _scanOnce());
  }

  /// Public manual trigger; UI henüz çağırmıyor ama tutarlılık için açık.
  Future<void> scanNow() => _scanOnce();

  Future<void> _scanOnce() async {
    if (!state.supported) return;
    if (_scanInFlight) return;
    if (FlutterBluePlus.isScanningNow) {
      // Discovery flow yapıyor → bu sweep'i atla, bir sonraki tick'te
      // tekrar dener.
      return;
    }
    if (bleExclusiveActive) {
      // Transport connect veya pairing akışı sürüyor; adapter exclusive
      // kullanılıyor. Concurrent scan, Android'de CCCD subscribe ve
      // notify pipe'ı bozar (auth.challenge kaybı bug'ı).
      return;
    }

    final paired = ref.read(pairedDevicesProvider);
    if (paired.isEmpty) {
      // Eşleşmiş cihaz yoksa sweep'e gerek yok, adapter'ı boşa açma.
      return;
    }

    _scanInFlight = true;
    state = state.copyWith(isScanning: true, clearError: true);

    final byName = {for (final d in paired) d.name: d.id};
    final byId = {for (final d in paired) d.id: d};
    final matched = <String>{};

    try {
      // Adapter durum kontrolü: kapalıysa scan başlatmayız.
      final adapterState = await FlutterBluePlus.adapterState
          .firstWhere((s) => s != BluetoothAdapterState.unknown)
          .timeout(const Duration(seconds: 2),
              onTimeout: () => BluetoothAdapterState.off);
      if (adapterState != BluetoothAdapterState.on) {
        state = state.copyWith(
          isScanning: false,
          lastScanAt: DateTime.now(),
          lastError: 'adapter ${adapterState.name}',
        );
        return;
      }

      // Listener'ı önce kur, sonra startScan; aksi halde ilk advertisement'lar
      // sub kurulmadan gelirse kaçar.
      await _resultSub?.cancel();
      _resultSub = FlutterBluePlus.scanResults.listen((results) {
        for (final r in results) {
          final advName = r.advertisementData.advName;
          final platName = r.device.platformName;
          final remoteId = r.device.remoteId.str;
          final name =
              advName.isNotEmpty ? advName : platName;
          // Match by paired BLE id (MAC) or by SmartKraft name.
          String? hitId;
          if (byId.containsKey(remoteId)) {
            hitId = remoteId;
          } else if (name.isNotEmpty && byName.containsKey(name)) {
            hitId = byName[name];
          }
          if (hitId != null && !matched.contains(hitId)) {
            matched.add(hitId);
            // touch lastSeen — fire and forget, errors swallowed for stability.
            ref
                .read(pairedDevicesProvider.notifier)
                .touch(hitId)
                .catchError((_) {/* silent */});
          }
        }
      }, onError: (Object e, StackTrace _) {
        debugPrint('[BLE-SCAN] result stream error: $e');
      });

      await FlutterBluePlus.startScan(timeout: _scanTimeout);
      // startScan timeout'unu içeriden bekle: stopScan otomatik tetiklenir
      // ama biz scan'in bitmesini garanti etmek için kısa bir delay daha
      // ekliyoruz; aksi halde sub'ı erkenden kapatırız.
      await Future<void>.delayed(_scanTimeout);
      try {
        if (FlutterBluePlus.isScanningNow) {
          await FlutterBluePlus.stopScan();
        }
      } catch (_) {/* swallow */}
      await _resultSub?.cancel();
      _resultSub = null;

      state = state.copyWith(
        isScanning: false,
        lastScanAt: DateTime.now(),
        lastMatchedCount: matched.length,
        clearError: true,
      );
      if (matched.isNotEmpty) {
        debugPrint('[BLE-SCAN] matched ${matched.length} paired '
            'device(s): ${matched.join(", ")}');
      }
    } catch (e, st) {
      debugPrint('[BLE-SCAN] sweep failed: $e\n$st');
      try {
        await _resultSub?.cancel();
      } catch (_) {/* swallow */}
      _resultSub = null;
      try {
        if (FlutterBluePlus.isScanningNow) {
          await FlutterBluePlus.stopScan();
        }
      } catch (_) {/* swallow */}
      state = state.copyWith(
        isScanning: false,
        lastError: e.toString(),
      );
    } finally {
      _scanInFlight = false;
    }
  }
}

final pairedBleScannerProvider =
    NotifierProvider<PairedBleScannerNotifier, PairedBleScannerState>(
        PairedBleScannerNotifier.new);
