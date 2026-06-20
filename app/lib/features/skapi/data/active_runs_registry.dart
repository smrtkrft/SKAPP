import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'run_handle.dart';

/// Per-peer cap. Mobile clients can have at most this many concurrent
/// runs against a single desktop before the next request is rejected
/// with HTTP 429. Three is enough for legitimate parallel script use
/// (toast + dialog + media-key) and small enough that a misbehaving
/// client cannot exhaust desktop resources.
const int kMaxRunsPerPeer = 3;

/// Per-peer sliding-window rate cap (güvenlik.md Madde 9). A peer may start
/// at most this many runs within any rolling 60-second window before the
/// next request is rejected with HTTP 429 `rate_limited`. Concurrency cap
/// ([kMaxRunsPerPeer]) bounds simultaneous load; this bounds burst/brute-
/// force frequency even when each run finishes instantly.
const int kMaxRunsPerMinute = 5;

const Duration _kRateWindow = Duration(minutes: 1);

/// One actively running script the desktop server is hosting on behalf
/// of a paired peer. Lives in [ActiveRunsRegistry] from the moment the
/// run endpoint registers it until the underlying process exits or the
/// cancel endpoint kills it.
class ActiveRun {
  ActiveRun({
    required this.runId,
    required this.peerUuid,
    required this.platform,
    required this.scriptId,
    required this.handle,
    required this.startedAt,
  });

  final String runId;
  final String peerUuid;
  final String platform;
  final String scriptId;
  final RunHandle handle;
  final DateTime startedAt;
}

/// Tracks every in-flight remote run. The server's run endpoint
/// registers a fresh entry per request; the cancel endpoint looks the
/// entry up by `runId` and asks the underlying [RunHandle] to send
/// SIGTERM. Per-peer concurrency caps live here too so the limit
/// check is colocated with the state it protects.
///
/// State is in-memory only. A listener restart drops everything, which
/// is the intended behaviour: a fresh server has no idea what was
/// running before, and stale registry entries would block new runs.
class ActiveRunsRegistry {
  final Map<String, ActiveRun> _byRunId = {};
  final Map<String, int> _countByPeer = {};

  /// Recent run-start timestamps per peer, for the sliding-window rate
  /// limit. Pruned to the active window on every [withinRateLimit] check.
  final Map<String, List<DateTime>> _recentStartsByPeer = {};

  int countFor(String peerUuid) => _countByPeer[peerUuid] ?? 0;

  bool canStart(String peerUuid) => countFor(peerUuid) < kMaxRunsPerPeer;

  /// True when [peerUuid] has started fewer than [kMaxRunsPerMinute] runs in
  /// the 60-second window ending at [now] (defaults to wall clock; injectable
  /// for tests). Prunes expired timestamps as a side effect so the map can't
  /// grow without bound for an active peer.
  bool withinRateLimit(String peerUuid, {DateTime? now}) {
    final t = now ?? DateTime.now();
    final cutoff = t.subtract(_kRateWindow);
    final list = _recentStartsByPeer[peerUuid];
    if (list == null) return true;
    list.removeWhere((ts) => ts.isBefore(cutoff));
    if (list.isEmpty) {
      _recentStartsByPeer.remove(peerUuid);
      return true;
    }
    return list.length < kMaxRunsPerMinute;
  }

  void register(ActiveRun run, {DateTime? now}) {
    _byRunId[run.runId] = run;
    _countByPeer[run.peerUuid] = (_countByPeer[run.peerUuid] ?? 0) + 1;
    // Rate-limit ledger: an admitted run counts toward the per-minute cap
    // even after it finishes (cleanup does NOT remove this timestamp — the
    // window is time-based, not concurrency-based).
    (_recentStartsByPeer[run.peerUuid] ??= []).add(now ?? DateTime.now());
  }

  ActiveRun? get(String runId) => _byRunId[runId];

  /// Drop the entry without sending a cancel signal. Called from the
  /// run endpoint's `onDone` callback once the underlying process has
  /// already exited on its own.
  void cleanup(String runId) {
    final entry = _byRunId.remove(runId);
    if (entry == null) return;
    final next = (_countByPeer[entry.peerUuid] ?? 1) - 1;
    if (next <= 0) {
      _countByPeer.remove(entry.peerUuid);
    } else {
      _countByPeer[entry.peerUuid] = next;
    }
  }

  /// Send SIGTERM to the matching run's underlying process. Returns
  /// `true` when the runId was known; `false` otherwise (404 path on
  /// the cancel endpoint). The entry stays in the registry until the
  /// run endpoint's done callback fires `cleanup`, so a duplicate
  /// cancel inside the kill grace window is a cheap no-op.
  bool cancel(String runId) {
    final entry = _byRunId[runId];
    if (entry == null) return false;
    entry.handle.cancel();
    return true;
  }
}

final activeRunsRegistryProvider = Provider<ActiveRunsRegistry>((ref) {
  return ActiveRunsRegistry();
});
