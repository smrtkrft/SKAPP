// LAN discovery for SmartKraft devices via mDNS / DNS-SD.
//
// Each device's sk_mdns publishes a single `_skapp._tcp` instance whose
// instance name is its identity (e.g. "BF-A06TMFSQT"). We resolve that
// instance to the IPv4 address + port the device is listening on for
// the TCP NDJSON CLI transport.
//
// The lookup is one-shot (timeout-bounded) and meant to be run from
// deviceSessionProvider as a "do we have the device on WiFi?" probe
// before falling back to BLE.

import 'dart:async';
import 'dart:io';

import 'package:multicast_dns/multicast_dns.dart';

import '../network/mdns_compat.dart';

class MdnsDeviceEndpoint {
  MdnsDeviceEndpoint({
    required this.instance,
    required this.host,
    required this.port,
  });

  /// Bonjour instance name, equals the device identity (BF-...)
  final String instance;

  /// Resolved IPv4 address (string form).
  final String host;
  final int port;

  @override
  String toString() => '$instance@$host:$port';
}

class MdnsDiscovery {
  /// Resolve a single device by its identity (e.g. "BF-A06TMFSQT"). Returns
  /// null if no answer arrives within `timeout`.
  static Future<MdnsDeviceEndpoint?> resolveInstance(
    String instance, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final results = await scanAll(timeout: timeout);
    for (final r in results) {
      if (r.instance == instance) return r;
    }
    return null;
  }

  /// Sweep `_skapp._tcp.local` and return every reachable instance. Useful
  /// when the user is on the LAN and we want to populate the devices list
  /// even without a prior bond record.
  static Future<List<MdnsDeviceEndpoint>> scanAll({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    const name = '_skapp._tcp.local';
    final client = MDnsClient(
      rawDatagramSocketFactory: mdnsSafeSocketFactory,
    );

    final found = <String, MdnsDeviceEndpoint>{};
    try {
      // listenAddress IPv4'e kilitlenir, IPv6 multicast Windows'ta virtual
      // adapter'larda 10042 dökerek tüm tarama oturumunu öldürüyor.
      // interfacesFactory virtual NIC'leri (Hyper-V, WSL, VPN) eler.
      await client.start(
        listenAddress: InternetAddress.anyIPv4,
        interfacesFactory: mdnsSafeInterfaces,
      );
      final ptrStream = client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer(name),
      );

      // Each PTR record points at a specific instance. Behind it sits an
      // SRV (host+port) and an A record (IPv4 of the host).
      await for (final ptr
          in ptrStream.timeout(timeout, onTimeout: (sink) => sink.close())) {
        final instanceFqdn = ptr.domainName; // BF-A06TMFSQT._skapp._tcp.local
        final instanceShort = instanceFqdn.split('.').first;

        await for (final srv in client
            .lookup<SrvResourceRecord>(
              ResourceRecordQuery.service(instanceFqdn),
            )
            .timeout(timeout, onTimeout: (sink) => sink.close())) {
          await for (final a in client
              .lookup<IPAddressResourceRecord>(
                ResourceRecordQuery.addressIPv4(srv.target),
              )
              .timeout(timeout, onTimeout: (sink) => sink.close())) {
            found[instanceShort] = MdnsDeviceEndpoint(
              instance: instanceShort,
              host: a.address.address,
              port: srv.port,
            );
          }
        }
      }
    } finally {
      client.stop();
    }
    return found.values.toList();
  }
}
