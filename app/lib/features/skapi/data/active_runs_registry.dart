import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'run_handle.dart';

/// Per-peer cap. Mobile clients can have at most this many concurrent
/// runs against a single desktop before the next request is rejected
/// with HTTP 429. Three is enough for legitimate parallel script use
/// (toast + dialog + media-key) and small enough that a misbehaving
/// client cannot exhaust desktop resources.
const int kMaxRunsPerPeer = 3;

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

  int countFor(String peerUuid) => _countByPeer[peerUuid] ?? 0;

  bool canStart(String peerUuid) => countFor(peerUuid) < kMaxRunsPerPeer;

  void register(ActiveRun run) {
    _byRunId[run.runId] = run;
    _countByPeer[run.peerUuid] = (_countByPeer[run.peerUuid] ?? 0) + 1;
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
