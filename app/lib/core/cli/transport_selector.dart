// TCP-cache → mDNS → BLE fallback chain, extracted from deviceSessionProvider
// for independent testability. Production code calls:
//
//   TransportSelector(ref: ref).selectAndConnect(deviceId)
//
// Tests inject [tcpClientFactory], [bleClientFactory] and [mdnsResolver] to
// avoid real sockets / BLE adapters while exercising the full selection logic.

import 'package:flutter/foundation.dart' show debugPrint, visibleForTesting;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ble/ble_service.dart';
import '../storage/paired_devices_store.dart';
import 'ble_transport.dart';
import 'bond_store.dart';
import 'cli_client.dart';
import 'cli_session.dart';
import 'cli_signer.dart';
import 'cli_transport.dart';
import 'mdns_discovery.dart';
import 'tcp_transport.dart';

class TransportSelector {
  TransportSelector({
    required this.ref,
    @visibleForTesting this.tcpClientFactory,
    @visibleForTesting this.bleClientFactory,
    @visibleForTesting this.mdnsResolver,
  });

  final Ref ref;

  /// Override for tests: returns a [CliClient] over a fake TCP transport
  /// without opening a real socket.
  @visibleForTesting
  final CliClient Function(String host, int port, List<int> token)?
      tcpClientFactory;

  /// Override for tests: returns a [CliClient] over a fake BLE transport
  /// without requiring a Bluetooth adapter.
  @visibleForTesting
  final CliClient Function(String deviceId, List<int> token)? bleClientFactory;

  /// Override for tests: replaces the live multicast-DNS sweep.
  @visibleForTesting
  final Future<MdnsDeviceEndpoint?> Function(
    String instance, {
    Duration? timeout,
  })? mdnsResolver;

  // All timeouts are named constants so tests can verify which path was taken
  // (the transport kind on the returned session) without needing to inspect
  // wall-clock behaviour.
  static const tcpCacheTimeout = Duration(seconds: 3);
  static const mdnsResolveTimeout = Duration(milliseconds: 1500);
  static const tcpFreshTimeout = Duration(seconds: 8);
  static const bleTimeout = Duration(seconds: 15);

  /// Tries TCP cache → mDNS fresh-resolve + TCP → BLE in order.
  ///
  /// Throws [BondMissingException] if no stored bond is found.
  /// Throws [PairingRequiredException] (re-throws from BLE) if the device
  /// reports it needs re-pairing — do NOT wrap this in
  /// [DeviceUnreachableException]; the caller's pairing flow depends on it.
  /// Throws [DeviceUnreachableException] when all three paths fail.
  Future<DeviceSession> selectAndConnect(String deviceId) async {
    final bondStore = ref.read(bondStoreProvider);
    final token = await bondStore.tokenFor(deviceId);
    if (token == null) throw BondMissingException(deviceId);

    // ID canonicalization: matchDeviceId handles exact-id, exact-name and
    // case-insensitive fallbacks (see paired_devices_store.dart). Falls back
    // to the raw deviceId as mDNS instance name when no PairedDevice matches.
    final paired = ref.read(pairedDevicesProvider).matchDeviceId(deviceId);
    final mdnsInstance = paired?.name ?? deviceId;
    if (paired == null) {
      debugPrint(
          '[session] WARN: no PairedDevice match for "$deviceId"; '
          'mdns resolve will try raw id as instance name');
    }

    final attempts = <String>[];

    // 1) TCP cache fast-path — tighter 3 s timeout so a stale cached IP
    //    fails fast; cache is also cleared on failure so the next cold-start
    //    skips the dead endpoint.
    if (paired != null && paired.lastIp != null) {
      final port = paired.lastPort ?? 8080;
      final s = await _attemptTcp(
        deviceId,
        paired.lastIp!,
        port,
        token,
        attempts,
        timeout: tcpCacheTimeout,
        clearCacheOnFail: true,
      );
      if (s != null) return s;
    } else {
      attempts.add("TCP cache: atlandı (paired record'da lastIp henüz yok)");
    }

    // 2) mDNS fresh-resolve → TCP with full 8 s timeout.
    MdnsDeviceEndpoint? ep;
    try {
      ep = await _resolveMdns(mdnsInstance, mdnsResolveTimeout);
    } catch (e) {
      attempts.add('mDNS resolve($mdnsInstance): $e');
    }
    if (ep == null) {
      attempts.add('mDNS resolve($mdnsInstance): cevap yok');
    } else {
      final s = await _attemptTcp(deviceId, ep.host, ep.port, token, attempts);
      if (s != null) return s;
    }

    // 3) BLE fallback — last resort; beginBleExclusive / endBleExclusive in
    //    paired_ble_scanner.dart are called by the scanner before this path
    //    to prevent concurrent BLE operations on Android.
    try {
      return await _openBle(deviceId, token);
    } catch (e) {
      if (e is PairingRequiredException) rethrow;
      attempts.add('BLE fallback: $e');
      throw DeviceUnreachableException(List.unmodifiable(attempts));
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers

  Future<MdnsDeviceEndpoint?> _resolveMdns(String instance, Duration timeout) {
    if (mdnsResolver != null) return mdnsResolver!(instance, timeout: timeout);
    return MdnsDiscovery.resolveInstance(instance, timeout: timeout);
  }

  CliClient _makeTcpClient(String host, int port, List<int> token) {
    if (tcpClientFactory != null) return tcpClientFactory!(host, port, token);
    return CliClient(
      TcpCliTransport(host: host, port: port, token: token),
      signer: CliSigner(token),
    );
  }

  CliClient _makeBleClient(String deviceId, List<int> token) {
    if (bleClientFactory != null) return bleClientFactory!(deviceId, token);
    final ble = ref.read(bleServiceProvider);
    final btDevice = ble.deviceFor(deviceId);
    return CliClient(
      BleCliTransport(device: btDevice, token: token),
      signer: CliSigner(token),
    );
  }

  Future<DeviceSession?> _attemptTcp(
    String deviceId,
    String host,
    int port,
    List<int> token,
    List<String> attempts, {
    Duration timeout = tcpFreshTimeout,
    bool clearCacheOnFail = false,
  }) async {
    final client = _makeTcpClient(host, port, token);

    try {
      await client.start().timeout(timeout);
    } catch (e) {
      debugPrint('[session] TCP open failed ($host:$port): $e');
      attempts.add('TCP $host:$port: $e');
      try {
        await client.stop();
      } catch (_) {}
      if (clearCacheOnFail) {
        try {
          await ref
              .read(pairedDevicesProvider.notifier)
              .clearLastEndpoint(deviceId);
        } catch (_) {}
      }
      return null;
    }

    try {
      await ref.read(pairedDevicesProvider.notifier).touch(
            deviceId,
            lastIp: host,
            lastPort: port,
          );
    } catch (_) {}

    final session = DeviceSession(
      deviceId: deviceId,
      client: client,
      transportKind: CliTransportKind.tcp,
    );
    _wireSessionLifetime(client, session);
    return session;
  }

  Future<DeviceSession> _openBle(String deviceId, List<int> token) async {
    final client = _makeBleClient(deviceId, token);

    try {
      await client.start().timeout(bleTimeout);
    } catch (e) {
      try {
        await client.stop();
      } catch (_) {}
      rethrow;
    }

    try {
      await ref.read(pairedDevicesProvider.notifier).touch(deviceId);
    } catch (_) {}

    final session = DeviceSession(
      deviceId: deviceId,
      client: client,
      transportKind: CliTransportKind.ble,
    );
    _wireSessionLifetime(client, session);
    return session;
  }

  /// Two-way Riverpod ↔ CliClient lifetime wiring.
  ///
  ///   1. Provider teardown (invalidate / app shutdown) → session.dispose()
  ///      → transport close.
  ///   2. Transport drop (device reboot, AP roam) → provider invalidates
  ///      itself so the next read opens a fresh session automatically.
  ///
  /// Called from both TCP and BLE success paths. The BLE exclusive lock
  /// (beginBleExclusive / endBleExclusive in paired_ble_scanner.dart) is
  /// managed by the scanner layer before this method is reached.
  void _wireSessionLifetime(CliClient client, DeviceSession session) {
    ref.onDispose(session.dispose);
    client.whenClosed.then((_) {
      // Wrap in microtask: whenClosed can fire during the current provider
      // build dispatch (e.g. transport closes immediately after connect);
      // deferring to a microtask avoids Riverpod re-entrancy and the
      // parallel-session race that caused BLE reconnect notify loss.
      Future.microtask(() {
        try {
          ref.invalidateSelf();
        } catch (_) {}
      });
    });
  }
}
