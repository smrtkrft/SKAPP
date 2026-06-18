import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'skapp_http_client.dart';
import 'skapp_peer_store.dart';

/// Polling interval for active probes. Same cadence as the mDNS browser
/// (30 s) so paired peers refresh their `lastSeen` + `developerModeEnabled`
/// at the same rhythm regardless of which discovery channel is live.
const Duration _kProbeInterval = Duration(seconds: 30);

/// Per-probe HTTP timeout. Generous to absorb brief Wi-Fi hand-offs;
/// shorter than the polling interval so a slow peer doesn't stack up
/// concurrent probes.
const Duration _kProbeTimeout = Duration(seconds: 5);

/// Periodically calls `/api/health` on every paired SKAPP peer and
/// updates `skappPeersProvider` with the result.
///
/// Why this exists in addition to the mDNS browser:
///   - mDNS only emits records while the app is foregrounded AND the
///     browser is active. On mobile, the browser is started by the
///     `MainShell` so it stays live, but a paired peer whose Wi-Fi just
///     came back online won't be announced again until its TTL refresh
///     window — minutes later in some implementations.
///   - mDNS carries no payload beyond service name + IP + port. We
///     can't learn whether the peer's Developer mode is on without an
///     HTTP probe, and the peer picker needs that flag to decide which
///     rows to disable.
///
/// This prober uses the same per-peer TLS-pinned `SkappHttpClient`, so
/// every probe doubles as a connectivity sanity check.
class SkappPeerHealthProber {
  SkappPeerHealthProber(this._ref);

  final Ref _ref;
  Timer? _timer;
  bool _started = false;
  bool _probing = false;

  /// Idempotent. Safe to call from `initState` on multiple widgets;
  /// only the first call starts the timer.
  void start() {
    if (_started) return;
    _started = true;
    debugPrint('[peer-health-prober] start (every ${_kProbeInterval.inSeconds}s)');
    // Fire one immediate probe so the UI has fresh data on first paint
    // instead of waiting 30 s.
    unawaited(_probeAll());
    _timer = Timer.periodic(_kProbeInterval, (_) => unawaited(_probeAll()));
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _started = false;
  }

  Future<void> _probeAll() async {
    if (_probing) return;
    _probing = true;
    try {
      final peers = _ref.read(skappPeersProvider);
      if (peers.isEmpty) return;
      final client = _ref.read(skappHttpClientProvider);
      final store = _ref.read(skappPeersProvider.notifier);
      for (final peer in peers) {
        try {
          final health = await client.health(peer).timeout(_kProbeTimeout);
          // markSeen first so the peer shows online even if the dev-mode
          // flag couldn't be parsed for some reason.
          await store.markSeen(peer.uuid, peer.lastIp, DateTime.now().toUtc());
          final devMode = health.developerModeEnabled;
          if (devMode != null) {
            await store.updateHealth(peer.uuid,
                developerModeEnabled: devMode);
          }
        } on SkappPeerOfflineException {
          // Peer never had an IP. Skip silently — mDNS or a manual
          // re-pair will populate it later.
          continue;
        } catch (e) {
          debugPrint('[peer-health-prober] ${peer.uuid} probe failed: $e');
        }
      }
    } finally {
      _probing = false;
    }
  }
}

final skappPeerHealthProberProvider = Provider<SkappPeerHealthProber>((ref) {
  final prober = SkappPeerHealthProber(ref);
  ref.onDispose(prober.stop);
  return prober;
});
