// Windows-friendly compatibility helpers for the `multicast_dns` package.
//
// Two pain points the upstream library doesn't handle gracefully:
//
//   1. **`joinMulticast` on virtual adapters fails.** On Windows the
//      `MDnsClient.start()` loop iterates every NetworkInterface returned
//      by the default factory and calls `joinMulticast` on each one. If
//      *any* virtual adapter (Hyper-V "Default Switch", WSL "vEthernet",
//      VirtualBox/VMware host-only, Bluetooth PAN, OpenVPN tap) refuses
//      the multicast group, the call throws `errno = 10042
//      (WSAENOPROTOOPT)` and the whole scan dies before reaching real
//      Wi-Fi/Ethernet adapters.
//
//   2. **`reusePort: true` is not portable.** macOS and Linux accept it
//      via `SO_REUSEPORT`; Windows lacks the option entirely. The library
//      passes `true` unconditionally; the Dart `RawDatagramSocket.bind`
//      implementation silently drops the flag on Windows but other
//      backends might not.
//
// This module exports two helpers that callers (`MdnsDiscovery`,
// `MdnsSkappPeerDiscovery`) wire into `MDnsClient` so the WiFi-discovery
// flow doesn't blow up the moment the user has even one virtual NIC up.

import 'dart:io';

/// Builds the set of NetworkInterfaces that mDNS should attempt to bind
/// and `joinMulticast` against. Only interfaces with at least one
/// non-loopback, non-link-local address survive, and known-virtual
/// Windows adapter names (Hyper-V, WSL, VirtualBox, VMware, OpenVPN tap,
/// Bluetooth PAN) are excluded — these reliably reject the multicast
/// join on Windows and would crash the upstream `start()` loop.
///
/// The filter is conservative: when the name pattern doesn't match any
/// known-virtual adapter we still keep the interface, so a misnamed real
/// Ethernet card is preserved at the cost of one possibly-failing
/// multicast join. macOS and Linux are mostly unaffected (the regex
/// list happens to also drop "docker0" / "br-..." Linux bridges, which is
/// usually what we want for SmartKraft device discovery).
Future<Iterable<NetworkInterface>> mdnsSafeInterfaces(
    InternetAddressType type) async {
  final all = await NetworkInterface.list(
    includeLoopback: false,
    includeLinkLocal: false,
    type: type,
  );
  return all.where(_isLikelyPhysical);
}

bool _isLikelyPhysical(NetworkInterface i) {
  final n = i.name.toLowerCase();
  // Skip entries that don't carry a routable IPv4/IPv6.
  final hasRoutable = i.addresses.any((a) => !a.isLoopback && !a.isLinkLocal);
  if (!hasRoutable) return false;
  // Pattern blocklist for common virtual adapter names. Substring match
  // is enough here, the strings are stable across Windows / Linux distros.
  const blocked = [
    'loopback',
    'pseudo-interface',
    'hyper-v',
    'vethernet',
    'wsl',
    'virtualbox',
    'vmware',
    'vmnet',
    'tap-windows',
    'openvpn',
    'wireguard',
    'bluetooth',
    'docker',
    'tun',
  ];
  for (final pat in blocked) {
    if (n.contains(pat)) return false;
  }
  return true;
}

/// Robust [RawDatagramSocketFactory] for `MDnsClient`. Drops `reusePort`
/// (Windows lacks `SO_REUSEPORT`) and falls back to an ephemeral
/// `anyIPv4:0` bind if the requested address/port refuses — that lets a
/// best-effort socket still satisfy the library while the upstream
/// `joinMulticast` is short-circuited by [mdnsSafeInterfaces].
Future<RawDatagramSocket> mdnsSafeSocketFactory(
  dynamic host,
  int port, {
  bool reuseAddress = true,
  bool reusePort = true, // accepted for signature parity, ignored here
  int ttl = 255,
}) async {
  try {
    return await RawDatagramSocket.bind(
      host,
      port,
      reuseAddress: true,
      ttl: ttl,
    );
  } catch (_) {
    // The interface this socket would have served is virtual or busy;
    // hand back an ephemeral IPv4 socket so the rest of the start()
    // loop can complete. The mDNS responses we care about flow through
    // the primary adapter the OS already routes to.
    return RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      0,
      reuseAddress: true,
      ttl: ttl,
    );
  }
}
