/// Output line streamed from a running script. `kind` lets the UI tint
/// stderr lines red without parsing the text. `info` is reserved for
/// runner self-messages (start banner, exit duration, cancel notice).
enum RunOutputKind { stdout, stderr, info }

class RunOutputLine {
  RunOutputLine({
    required this.kind,
    required this.text,
    required this.ts,
  });

  final RunOutputKind kind;
  final String text;
  final DateTime ts;
}

/// Live handle on a running script. Returned by `ScriptRunner.run`.
///
/// Consumers subscribe to `output` (broadcast stream, late join keeps
/// historical lines via `bufferedOutput`) and await `result` for the
/// final exit code. `cancel()` sends a kill signal; the script may not
/// terminate instantly.
class RunHandle {
  RunHandle({
    required this.scriptId,
    required Stream<RunOutputLine> output,
    required Future<RunResult> result,
    required this.bufferedOutput,
    required void Function() onCancel,
  })  : _output = output,
        _result = result,
        _onCancel = onCancel;

  final String scriptId;
  final Stream<RunOutputLine> _output;
  final Future<RunResult> _result;
  final List<RunOutputLine> bufferedOutput;
  final void Function() _onCancel;

  Stream<RunOutputLine> get output => _output;
  Future<RunResult> get result => _result;

  bool _cancelled = false;
  bool get cancelled => _cancelled;

  void cancel() {
    if (_cancelled) return;
    _cancelled = true;
    _onCancel();
  }
}

/// Final outcome of a run. Surfaced after the process exits; the UI
/// flips the sheet status from "Running" to either "Done" or "Failed"
/// based on `success`.
class RunResult {
  RunResult({
    required this.exitCode,
    required this.durationMs,
    required this.cancelled,
    this.errorMessageKey,
    this.errorMessageArg,
  });

  /// PowerShell exit code. Negative values are reserved for runner-side
  /// failures that prevented the process from starting (in which case
  /// `errorMessageKey` is set).
  final int exitCode;
  final int durationMs;
  final bool cancelled;

  /// i18n key the UI should resolve when rendering a runner-side error
  /// (temp write failure, spawn failure, missing PowerShell). Null on a
  /// normal process exit, regardless of the script's own success or
  /// failure (script errors live in stderr lines, not here).
  final String? errorMessageKey;

  /// Optional argument forwarded to the i18n placeholder. Most error
  /// keys carry an `{error}` placeholder for the underlying exception.
  final String? errorMessageArg;

  bool get success => exitCode == 0 && errorMessageKey == null && !cancelled;
}
