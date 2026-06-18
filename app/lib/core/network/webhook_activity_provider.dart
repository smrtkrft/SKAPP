import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Outcome of a single inbound webhook hit. Used for diagnostic UI so
/// the user can tell whether a BF device's countdown-end actually
/// reached SKAPP, and if so, what the receiver did with it.
enum WebhookOutcome {
  /// Signature passed, body parsed, dispatched to bindings pipeline.
  accepted,

  /// HMAC mismatch / no bond stored / nonce replay. Webhook reached
  /// SKAPP but was refused.
  rejected,

  /// Headers missing / body empty / event name absent. Webhook reached
  /// SKAPP but was malformed.
  malformed,

  /// Synthetic entry from the in-app "Self-test" button. Confirms the
  /// listener URL is reachable from the laptop itself (catches firewall
  /// problems where the listener binds OK but inbound packets are
  /// dropped before reaching the route).
  selfTest,
}

/// Outcome of the binding dispatch pipeline AFTER a webhook is accepted.
/// Lets the UI show why a script may not have run even though the
/// webhook was received and verified successfully (the previously-silent
/// failure surface — "Kabul edildi" but no script).
enum DispatchOutcome {
  /// Dispatch wasn't attempted yet (initial state on accept) or this
  /// webhook is a non-dispatch entry (rejected / malformed / self-test).
  none,

  /// At least one binding matched; script(s) launched. Per-script
  /// success/failure surfaces in [WebhookActivity.scriptResults].
  matched,

  /// Webhook accepted but no enabled binding matched the device id +
  /// event name. Script never runs. Shows up in UI as a yellow warning
  /// so the user can fix the binding instead of staring at a green tick.
  noMatch,

  /// Dispatch threw before reaching the runner (e.g. paired-list lookup
  /// failed, unhandled exception). Free-text [WebhookActivity.note]
  /// carries the cause.
  error,
}

/// Per-script run outcome carried inside [WebhookActivity.scriptResults].
class ScriptRunResult {
  const ScriptRunResult({
    required this.scriptId,
    required this.platform,
    required this.success,
    this.exitCode,
    this.errorKey,
    this.errorMessage,
  });

  final String scriptId;
  final String platform;
  final bool success;
  final int? exitCode;

  /// Localised key emitted by ScriptRunner (e.g.
  /// `skapiRunErrorPowerShellMissing`).
  final String? errorKey;
  final String? errorMessage;
}

class WebhookActivity {
  const WebhookActivity({
    required this.when,
    required this.outcome,
    this.deviceId,
    this.eventName,
    this.statusCode,
    this.note,
    this.dispatch = DispatchOutcome.none,
    this.matchedBindings = 0,
    this.scriptResults = const [],
  });

  final DateTime when;
  final WebhookOutcome outcome;

  /// Originating device id (parsed from `X-SK-Device-Id`). Null on
  /// malformed headers.
  final String? deviceId;

  /// Event name from the body (`event` or `evt` field). Null when the
  /// receiver rejected before parsing.
  final String? eventName;

  /// HTTP status code returned to the BF. 200 on accept, 401/403/400
  /// on various rejects.
  final int? statusCode;

  /// Free-text note for diagnostics: HMAC reason, missing-bond
  /// indicator, self-test result, etc.
  final String? note;

  /// Outcome of the post-accept binding dispatch. Defaults to `none`
  /// for outcomes other than [WebhookOutcome.accepted].
  final DispatchOutcome dispatch;

  /// Number of enabled bindings whose `eventFilter` matched the
  /// incoming event for this device. Zero means the webhook was
  /// accepted but no script will run — the most-likely silent-failure
  /// case for end users that exact-match deviceId mismatch caused.
  final int matchedBindings;

  /// One entry per script attempted. Empty if `matchedBindings == 0`
  /// or dispatch errored before launching any.
  final List<ScriptRunResult> scriptResults;

  WebhookActivity copyWith({
    DispatchOutcome? dispatch,
    int? matchedBindings,
    List<ScriptRunResult>? scriptResults,
    String? note,
  }) =>
      WebhookActivity(
        when: when,
        outcome: outcome,
        deviceId: deviceId,
        eventName: eventName,
        statusCode: statusCode,
        note: note ?? this.note,
        dispatch: dispatch ?? this.dispatch,
        matchedBindings: matchedBindings ?? this.matchedBindings,
        scriptResults: scriptResults ?? this.scriptResults,
      );
}

/// Maximum entries kept in the ring buffer. Each webhook reception
/// snapshot is small; 50 covers typical "did anything just happen?"
/// debugging without growing unbounded.
const int _kMaxActivity = 50;

class WebhookActivityNotifier extends Notifier<List<WebhookActivity>> {
  @override
  List<WebhookActivity> build() => const <WebhookActivity>[];

  /// Stable id generator — increments on each accept so dispatch
  /// updates can mutate the matching entry in-place. Ring buffer is
  /// small (50), linear scan by `when` is fast enough.
  void record(WebhookActivity entry) {
    final next = <WebhookActivity>[entry, ...state];
    if (next.length > _kMaxActivity) {
      next.removeRange(_kMaxActivity, next.length);
    }
    state = next;
  }

  /// Returns the timestamp of the new entry so the caller can update
  /// dispatch outcome later.
  DateTime recordAccepted({
    required String deviceId,
    required String eventName,
  }) {
    final now = DateTime.now();
    record(WebhookActivity(
      when: now,
      outcome: WebhookOutcome.accepted,
      deviceId: deviceId,
      eventName: eventName,
      statusCode: 200,
    ));
    return now;
  }

  /// Mutates the entry whose [when] matches [token] to carry the
  /// dispatch result. No-op if the entry has been pushed off the ring
  /// buffer (very old).
  void updateDispatch({
    required DateTime token,
    required DispatchOutcome dispatch,
    int? matchedBindings,
    List<ScriptRunResult>? scriptResults,
    String? note,
  }) {
    final i = state.indexWhere((e) => e.when == token);
    if (i < 0) return;
    final next = [...state];
    next[i] = next[i].copyWith(
      dispatch: dispatch,
      matchedBindings: matchedBindings,
      scriptResults: scriptResults,
      note: note,
    );
    state = next;
  }

  void recordRejected({
    String? deviceId,
    int? statusCode,
    String? note,
  }) {
    record(WebhookActivity(
      when: DateTime.now(),
      outcome: WebhookOutcome.rejected,
      deviceId: deviceId,
      statusCode: statusCode,
      note: note,
    ));
  }

  void recordMalformed({
    String? deviceId,
    String? note,
    int statusCode = 400,
  }) {
    record(WebhookActivity(
      when: DateTime.now(),
      outcome: WebhookOutcome.malformed,
      deviceId: deviceId,
      statusCode: statusCode,
      note: note,
    ));
  }

  void recordSelfTest({required bool success, String? note}) {
    record(WebhookActivity(
      when: DateTime.now(),
      outcome: WebhookOutcome.selfTest,
      statusCode: success ? 200 : null,
      note: note,
    ));
  }

  void clear() {
    state = const <WebhookActivity>[];
  }
}

final webhookActivityProvider =
    NotifierProvider<WebhookActivityNotifier, List<WebhookActivity>>(
        WebhookActivityNotifier.new);
