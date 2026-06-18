// Live system-state providers used by Settings (and anywhere else that needs
// to react to adapter / network changes).
//
// Bluetooth: surfaced from flutter_blue_plus' adapterState stream, filtered
// to drop the initial "unknown" so consumers don't briefly render an
// incorrect state on first frame.
//
// Connectivity: surfaced from connectivity_plus. We expose the raw list of
// active connectivity types so the UI can distinguish "WiFi" vs "mobile"
// vs "none" rather than collapsing everything to a single bool.

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bluetooth adapter on/off/turning-on/etc, refreshed live.
///
/// Initial value is [BluetoothAdapterState.unknown] for the brief moment
/// before the platform plugin reports the real state, UIs can treat
/// `unknown` as "still checking".
final bluetoothAdapterStateProvider =
    StreamProvider<BluetoothAdapterState>((ref) async* {
  yield BluetoothAdapterState.unknown;
  yield* FlutterBluePlus.adapterState;
});

/// Live list of active connectivity transports (wifi, mobile, ethernet,
/// none, ...). connectivity_plus 6 emits a list because a phone can be
/// on WiFi *and* mobile at the same time.
final connectivityStatusProvider =
    StreamProvider<List<ConnectivityResult>>((ref) async* {
  final c = Connectivity();
  // Emit current state immediately so the first frame doesn't render
  // an "unknown" label.
  yield await c.checkConnectivity();
  yield* c.onConnectivityChanged;
});

/// Convenience: true if any active transport is WiFi.
final isOnWifiProvider = Provider<bool>((ref) {
  final async = ref.watch(connectivityStatusProvider);
  return async.maybeWhen(
    data: (list) => list.contains(ConnectivityResult.wifi),
    orElse: () => false,
  );
});
