// SKAPP Desktop instance mDNS announcer.
//
// Publishes a single `_skappdesktop._tcp.local` service whose instance
// name == [NetworkIdentity.name]. Started by [SkappListenerService] when
// the local HTTP server is running, stopped when it isn't, restarted on
// name / port / token changes.
//
// Why a separate service type from `_skapp._tcp.local`:
//   * `_skapp._tcp` is reserved for SmartKraft devices (BF, LebensSpur)
//     announced by their own sk_mdns. Mixing SKAPP hosts in there would
//     poison `mdns_browser`'s name → paired-id lookup.
//   * iOS Info.plist already lists both types under `NSBonjourServices`
//     so no plist changes are required.
//
// Mobile / web are unsupported by design: there is no listener behind the
// announcement on those platforms. Calling `start()` is a no-op there,
// `supported` returns false, and the Settings card hides the listener
// row entirely.

import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsd/nsd.dart' as nsd;

import '../app_info/version_provider.dart';
import '../system/network_identity_provider.dart';
import 'skapp_http_server.dart';

class SkappMdnsAnnouncer {
  SkappMdnsAnnouncer(this._ref);

  final Ref _ref;

  nsd.Registration? _registration;
  String? _lastError;

  /// Last platform / runtime error message from a `start()` attempt, or
  /// null when the announcement is healthy. Surfaced for diagnostics; the
  /// service stays in a sane state regardless.
  String? get lastError => _lastError;

  bool get isAnnouncing => _registration != null;

  /// Desktop-only. Mobile / web hosts have no HTTP listener so an
  /// announcement would advertise a service that doesn't exist (the
  /// "no fake data" rule).
  bool get supported {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  Future<void> start() async {
    if (!supported || _registration != null) return;
    final id = _ref.read(networkIdentityProvider);

    // appVersion is loaded async at first launch; the announcer stays
    // resilient if it isn't ready yet (TXT record just omits version).
    String version;
    try {
      version = await _ref.read(appVersionProvider.future);
    } catch (_) {
      version = '';
    }

    try {
      // Faz B step 4: announce the TLS cert fingerprint so peers
      // discovering us via mDNS (not via QR) can still pin the cert
      // at handshake. Cert is set by `SkappHttpServer.start()` right
      // before this announcer runs; null only happens if the cert
      // load somehow failed but the listener was forced up anyway,
      // in which case we omit the field rather than poison the TXT
      // record with empty data.
      final cert = _ref.read(currentTlsCertProvider);
      _registration = await nsd.register(nsd.Service(
        name: id.name,
        type: '_skappdesktop._tcp',
        port: id.port,
        txt: <String, Uint8List?>{
          'uuid': Uint8List.fromList(utf8.encode(id.uuid)),
          if (version.isNotEmpty)
            'version': Uint8List.fromList(utf8.encode(version)),
          'platform': Uint8List.fromList(utf8.encode(_platformTag())),
          if (cert != null)
            'fp': Uint8List.fromList(utf8.encode(cert.fingerprintHex)),
        },
      ));
      _lastError = null;
    } catch (e) {
      // Common failure modes:
      //   * Windows host without Bonjour Service running (Windows 10/11
      //     default). User can install Bonjour Print Services and retry.
      //   * Linux host without Avahi (rare on desktops, common on slim
      //     servers).
      // Either way we keep the listener alive and surface the message.
      _registration = null;
      _lastError = e.toString();
      debugPrint('[mdns-announce] start failed: $e');
    }
  }

  Future<void> stop() async {
    final r = _registration;
    if (r == null) return;
    _registration = null;
    try {
      await nsd.unregister(r);
    } catch (e) {
      // Best-effort: a failed unregister doesn't leave us in a bad state
      // because the next start() will reuse a fresh Registration.
      debugPrint('[mdns-announce] unregister failed: $e');
    }
  }

  Future<void> restart() async {
    await stop();
    await start();
  }

  String _platformTag() {
    if (Platform.isWindows) return 'win';
    if (Platform.isMacOS) return 'mac';
    if (Platform.isLinux) return 'lx';
    return 'other';
  }
}

/// Long-lived announcer provider. Disposed with the container so a hot
/// restart unregisters cleanly.
final skappMdnsAnnouncerProvider = Provider<SkappMdnsAnnouncer>((ref) {
  final a = SkappMdnsAnnouncer(ref);
  ref.onDispose(a.stop);
  return a;
});
