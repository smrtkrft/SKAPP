// BLE discovery service backed by flutter_blue_plus. Runs on real hardware;
// the discovery screen requests permissions and adapter readiness before
// calling startScan().

import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_model.dart';

/// Outcome of a permission/adapter readiness probe.
enum BleReadiness {
  ready,
  permissionsDenied,
  adapterOff,
  unsupported,
}

abstract class BleService {
  Stream<List<DiscoveredDevice>> get scanResults;

  /// Probe Bluetooth state without prompting the user. Used by the
  /// discovery screen on entry to decide whether to start scanning,
  /// request permissions, or show an "enable Bluetooth" hint.
  Future<BleReadiness> checkReadiness();

  Future<void> startScan();
  Future<void> stopScan();

  /// Resolve a discovered device id back to a flutter_blue_plus
  /// [BluetoothDevice] handle so transport code can connect.
  BluetoothDevice deviceFor(String id);
}

class RealBleService implements BleService {
  RealBleService();

  final _controller = StreamController<List<DiscoveredDevice>>.broadcast();
  final _devices = <String, DiscoveredDevice>{};
  StreamSubscription<List<ScanResult>>? _scanSub;

  @override
  Stream<List<DiscoveredDevice>> get scanResults => _controller.stream;

  @override
  Future<BleReadiness> checkReadiness() async {
    if (!await FlutterBluePlus.isSupported) {
      return BleReadiness.unsupported;
    }
    // adapterState.first can latch the initial 'unknown' value before the
    // platform plugin has had a chance to publish the real state. Wait
    // briefly for a *known* state, falling back to "off" so the UI gives
    // the user a clear next step rather than spinning forever.
    final state = await FlutterBluePlus.adapterState
        .firstWhere((s) => s != BluetoothAdapterState.unknown)
        .timeout(const Duration(seconds: 3),
            onTimeout: () => BluetoothAdapterState.off);
    if (state != BluetoothAdapterState.on) {
      return BleReadiness.adapterOff;
    }
    return BleReadiness.ready;
  }

  @override
  Future<void> startScan() async {
    _devices.clear();
    _controller.add(const []);

    await _scanSub?.cancel();
    _scanSub = FlutterBluePlus.scanResults.listen(
      _onScanResults,
      onError: (Object e, StackTrace st) {
        // Surface the error on the stream so the UI can react; the
        // discovery screen treats stream errors as a soft "no devices".
        _controller.addError(e, st);
      },
    );

    try {
      // No withServices filter, some Android BLE stacks strip the
      // service-UUID list from passive scan results, so a UUID-based
      // filter hides every device on those phones. Name-level filtering
      // happens in the UI (toggle in discovery screen) so it can be
      // turned off for diagnosis.
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 30),
      );
    } catch (e, st) {
      _controller.addError(e, st);
      rethrow;
    }
  }

  void _onScanResults(List<ScanResult> results) {
    var changed = false;
    for (final r in results) {
      final advName = r.advertisementData.advName;
      final platName = r.device.platformName;
      // Use whichever name is available; some stacks fill only one. Skip
      // truly anonymous beacons (no identifier at all), they would
      // crowd the list with row after row of "-".
      final name = advName.isNotEmpty
          ? advName
          : (platName.isNotEmpty ? platName : '');
      if (name.isEmpty) continue;

      final id = r.device.remoteId.str;
      final pairable = DiscoveredDevice.parsePairable(
        r.advertisementData.manufacturerData,
      );
      final next = DiscoveredDevice(
        id: id,
        name: name,
        rssi: r.rssi,
        pairable: pairable,
      );
      final prev = _devices[id];
      if (prev == null ||
          prev.name != next.name ||
          prev.rssi != next.rssi ||
          prev.pairable != next.pairable) {
        _devices[id] = next;
        changed = true;
      }
    }
    if (changed) {
      final list = _devices.values.toList()..sort((a, b) => b.rssi.compareTo(a.rssi));
      _controller.add(list);
    }
  }

  @override
  Future<void> stopScan() async {
    await _scanSub?.cancel();
    _scanSub = null;
    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }
  }

  @override
  BluetoothDevice deviceFor(String id) =>
      BluetoothDevice.fromId(id);
}

final bleServiceProvider = Provider<BleService>((ref) {
  final service = RealBleService();
  ref.onDispose(() => service.stopScan());
  return service;
});

final scanResultsProvider = StreamProvider<List<DiscoveredDevice>>((ref) {
  return ref.watch(bleServiceProvider).scanResults;
});
