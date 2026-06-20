import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'remote_run_audit_log.dart';

/// Outcome of a single remote-run attempt against the desktop's HTTP
/// listener. Surfaces in the Settings → Advanced "Remote runs" card so
/// the desktop owner can see who triggered what, with what result.
enum RemoteRunOutcome {
  /// Process spawned successfully, exit code captured in [exitCode].
  /// Whether the script *itself* succeeded is encoded by `exitCode == 0`.
  completed,

  /// Server rejected the request before starting the process: 403
  /// (`pro_mode_disabled`, `not_remote_runnable`), 404 (script not
  /// found), 429 (concurrency cap), 400 (validation). Status code and
  /// short reason live in [statusCode] and [reason].
  rejected,

  /// Run was cancelled either by the peer (DELETE endpoint) or by the
  /// desktop owner (Stop button on the activity card, future). Exit
  /// code is preserved (PowerShell may return non-zero after SIGTERM).
  cancelled,
}

class RemoteRunActivity {
  const RemoteRunActivity({
    required this.when,
    required this.runId,
    required this.peerUuid,
    required this.peerName,
    required this.platform,
    required this.scriptId,
    required this.outcome,
    this.statusCode,
    this.exitCode,
    this.durationMs,
    this.reason,
    this.paramOverrideKeys = const [],
  });

  final DateTime when;

  /// Server-generated UUIDv4 echoed in the NDJSON start record. Lets
  /// the cancel button on the card target one specific run.
  final String runId;

  /// Identifies the caller via their HMAC peerUuid. Used to look up
  /// the friendlier `peerName` from `peerTokensProvider` at record
  /// time; if the peer was revoked since, `peerName` falls back to
  /// the UUID prefix.
  final String peerUuid;
  final String peerName;

  final String platform;
  final String scriptId;
  final RemoteRunOutcome outcome;

  /// HTTP status returned to the peer. 200 on accepted runs (even if
  /// the script exited non-zero), 4xx on rejects.
  final int? statusCode;

  /// PowerShell exit code. Null for rejected runs that never spawned.
  final int? exitCode;
  final int? durationMs;

  /// Machine-readable reason on rejection (`pro_mode_disabled`,
  /// `too_many_runs`, `not_remote_runnable`, `script_not_found`,
  /// `validation_failed`). Free-text on `completed` if the runner
  /// reported a runner-side error key.
  final String? reason;

  /// Keys (not values) of the paramOverrides map the peer sent. Logging
  /// keys is enough to trace "the toast message was overridden" without
  /// leaking the user-supplied content.
  final List<String> paramOverrideKeys;

  /// JSON line for the persistent audit log (Madde 10). Values are
  /// deliberately limited to what the RAM card already exposes — override
  /// KEYS only, never values, so the forensic log can't leak user content.
  Map<String, Object?> toJson() => {
        'when': when.toIso8601String(),
        'runId': runId,
        'peerUuid': peerUuid,
        'peerName': peerName,
        'platform': platform,
        'scriptId': scriptId,
        'outcome': outcome.name,
        if (statusCode != null) 'statusCode': statusCode,
        if (exitCode != null) 'exitCode': exitCode,
        if (durationMs != null) 'durationMs': durationMs,
        if (reason != null) 'reason': reason,
        if (paramOverrideKeys.isNotEmpty) 'paramOverrideKeys': paramOverrideKeys,
      };

  static RemoteRunActivity? fromJson(Map<String, dynamic> j) {
    final whenStr = j['when'] as String?;
    final when = whenStr == null ? null : DateTime.tryParse(whenStr);
    if (when == null) return null;
    final outcomeName = j['outcome'] as String?;
    final outcome = RemoteRunOutcome.values.firstWhere(
      (o) => o.name == outcomeName,
      orElse: () => RemoteRunOutcome.completed,
    );
    return RemoteRunActivity(
      when: when,
      runId: (j['runId'] ?? '').toString(),
      peerUuid: (j['peerUuid'] ?? '').toString(),
      peerName: (j['peerName'] ?? '').toString(),
      platform: (j['platform'] ?? '').toString(),
      scriptId: (j['scriptId'] ?? '').toString(),
      outcome: outcome,
      statusCode: (j['statusCode'] as num?)?.toInt(),
      exitCode: (j['exitCode'] as num?)?.toInt(),
      durationMs: (j['durationMs'] as num?)?.toInt(),
      reason: j['reason'] as String?,
      paramOverrideKeys:
          (j['paramOverrideKeys'] as List?)?.cast<String>() ?? const [],
    );
  }

  RemoteRunActivity copyWith({
    RemoteRunOutcome? outcome,
    int? statusCode,
    int? exitCode,
    int? durationMs,
    String? reason,
  }) =>
      RemoteRunActivity(
        when: when,
        runId: runId,
        peerUuid: peerUuid,
        peerName: peerName,
        platform: platform,
        scriptId: scriptId,
        outcome: outcome ?? this.outcome,
        statusCode: statusCode ?? this.statusCode,
        exitCode: exitCode ?? this.exitCode,
        durationMs: durationMs ?? this.durationMs,
        reason: reason ?? this.reason,
        paramOverrideKeys: paramOverrideKeys,
      );
}

/// Ring buffer size. Each entry is small (~12 fields, short strings); 50
/// matches the webhook activity card and covers the typical "did the
/// last run go through?" debug case.
const int _kMaxActivity = 50;

class RemoteRunActivityNotifier extends Notifier<List<RemoteRunActivity>> {
  /// Persistent forensic log (Madde 10). Null until [_initPersistence]
  /// resolves the on-disk location, or on web where there is no listener.
  RemoteRunAuditLog? _audit;

  @override
  List<RemoteRunActivity> build() {
    // Best-effort: hydrate from the persistent audit log, then keep writing
    // to it. Runs async so build() stays synchronous; any platform without
    // a file system (web) or plugin (test harness) silently stays RAM-only.
    _initPersistence();
    return const <RemoteRunActivity>[];
  }

  Future<void> _initPersistence() async {
    final log = await RemoteRunAuditLog.defaultLocation();
    if (log == null) return;
    _audit = log;
    final persisted = await log.loadRecent();
    if (persisted.isEmpty) return;
    // Entries pushed during the init window stay newest; persisted history
    // (previous sessions) appends below, capped to the RAM ring size.
    final merged = <RemoteRunActivity>[...state, ...persisted];
    state = merged.length > _kMaxActivity
        ? merged.sublist(0, _kMaxActivity)
        : merged;
  }

  void _push(RemoteRunActivity entry) {
    final next = <RemoteRunActivity>[entry, ...state];
    if (next.length > _kMaxActivity) {
      next.removeRange(_kMaxActivity, next.length);
    }
    state = next;
    // Fire-and-forget persistence (null during the brief init window).
    _audit?.append(entry);
  }

  /// Record the moment the run endpoint accepted the request and
  /// registered an ActiveRun. Caller uses the returned `runId` later
  /// with [updateOnEnd] to fill in exit code + duration.
  void recordAccepted({
    required String runId,
    required String peerUuid,
    required String peerName,
    required String platform,
    required String scriptId,
    required List<String> paramOverrideKeys,
  }) {
    _push(RemoteRunActivity(
      when: DateTime.now(),
      runId: runId,
      peerUuid: peerUuid,
      peerName: peerName,
      platform: platform,
      scriptId: scriptId,
      outcome: RemoteRunOutcome.completed,
      statusCode: 200,
      paramOverrideKeys: paramOverrideKeys,
    ));
  }

  /// Fill in the result fields once the underlying RunHandle completes.
  /// No-op if the entry has rolled off the ring buffer.
  void updateOnEnd({
    required String runId,
    required int exitCode,
    required int durationMs,
    required bool cancelled,
    String? errorKey,
  }) {
    final i = state.indexWhere((e) => e.runId == runId);
    if (i < 0) return;
    final next = [...state];
    next[i] = next[i].copyWith(
      outcome: cancelled ? RemoteRunOutcome.cancelled : RemoteRunOutcome.completed,
      exitCode: exitCode,
      durationMs: durationMs,
      reason: errorKey,
    );
    state = next;
  }

  /// Record a request that the server refused before running anything
  /// (gating, validation, 404, 429). No runId because no run was ever
  /// registered.
  void recordRejected({
    required String peerUuid,
    required String peerName,
    required String platform,
    required String scriptId,
    required int statusCode,
    required String reason,
  }) {
    _push(RemoteRunActivity(
      when: DateTime.now(),
      runId: '',
      peerUuid: peerUuid,
      peerName: peerName,
      platform: platform,
      scriptId: scriptId,
      outcome: RemoteRunOutcome.rejected,
      statusCode: statusCode,
      reason: reason,
    ));
  }

  void clear() {
    state = const <RemoteRunActivity>[];
    _audit?.clear();
  }
}

final remoteRunActivityProvider =
    NotifierProvider<RemoteRunActivityNotifier, List<RemoteRunActivity>>(
        RemoteRunActivityNotifier.new);
