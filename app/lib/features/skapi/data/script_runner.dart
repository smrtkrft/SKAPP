import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:path_provider/path_provider.dart';

import 'param_merge.dart';
import 'run_handle.dart';
import 'script_manifest.dart';
import 'script_resolver.dart';

/// Thrown by [ScriptRunner.run] when a `paramOverrides` entry violates the
/// manifest's declared constraints (unknown key, type mismatch, out-of-range,
/// disallowed value, bad pattern, or control characters).
///
/// Callers that pass overrides must catch this before entering the script
/// execution path. The [result] field carries the machine-readable [code] and
/// [paramName] so callers can surface a structured error message.
class ParamValidationException implements Exception {
  const ParamValidationException(this.result);
  final ParamValidationResult result;

  String get message => result.message ?? 'Validation failed (${result.code})';

  @override
  String toString() =>
      'ParamValidationException(${result.code}, param=${result.paramName}): ${result.message}';
}

/// Mirror of the HTTP listener's pre-run delay ceiling (one hour). Clamped
/// here too so every caller (binding chains, future entry points) is bounded,
/// not just the remote-run endpoint.
const int _kMaxPrerunDelaySeconds = 3600;

/// Interpreter family a script is executed with.
enum _ShellKind { powershell, bash }

/// Maps a manifest `runtime` string to an interpreter family.
///   `powershell-5.1`, `powershell-7`, `pwsh` → PowerShell
///   `applescript-bash` (mac), `bash` (lx), `*shell*` → POSIX shell
/// Unknown runtimes default to PowerShell (preserves pre-existing behaviour
/// for Windows-authored content).
_ShellKind _shellKindFor(String runtime) {
  final r = runtime.toLowerCase();
  if (r.startsWith('powershell') || r.contains('pwsh')) return _ShellKind.powershell;
  if (r.contains('bash') || r.contains('applescript') || r.contains('shell')) {
    return _ShellKind.bash;
  }
  return _ShellKind.powershell;
}

/// Runs SKAPI PowerShell scripts on the local machine.
///
/// The runner is desktop-only. On web and mobile platforms calling
/// `run` throws [UnsupportedError]; the UI guards the entry point with
/// the same platform check, so this throw is a defense-in-depth.
///
/// Pipeline:
///   1. `ScriptResolver.resolveSource(manifest)` returns the
///      override-aware source (override if the user has saved one,
///      else the bundled original).
///   2. The source is written to a fresh temp file
///      (`%TEMP%\skapp_skapi\(id)-(ts).ps1`). A small one-line wrapper
///      script invokes the user file under UTF-8 console encoding so
///      stdout doesn't come back as UTF-16.
///   3. `Process.start("powershell.exe", [..flags.., -File (wrapper),
///      -name value, ...])` is spawned with the wrapper invoking the
///      user file under -ExecutionPolicy Bypass.
///   4. stdout / stderr are piped line-by-line into a broadcast stream;
///      a buffered list lets late subscribers replay history.
///   5. On exit (or cancel), a `RunResult` with exit code, duration,
///      cancellation flag is delivered through `RunHandle.result`.
class ScriptRunner {
  ScriptRunner({
    required ScriptResolver resolver,
    ParamMerge paramMerge = const ParamMerge(),
  })  : _resolver = resolver,
        _paramMerge = paramMerge {
    if (isSupported) {
      unawaited(_preheat());
    }
  }

  final ScriptResolver _resolver;
  final ParamMerge _paramMerge;
  bool _preheated = false;

  // Faz 4.1 (preheat varyantı): app açılışında bir kez dummy PowerShell
  // çalıştır. Cold start'ı (1-3sn) görünmez şekilde önden öde; webhook
  // tetiklendiğinde Windows process loader cache'i sıcak olur ve
  // Process.start ~100-300ms warm fiyatına döner.
  Future<void> _preheat() async {
    if (_preheated) return;
    _preheated = true;
    try {
      await Process.run(
        _powerShellExecutable(),
        const ['-NoProfile', '-NonInteractive', '-Command', 'exit 0'],
        runInShell: false,
      );
    } catch (_) {
      // Best-effort: preheat fail webhook akışını bozmaz.
    }
  }

  bool get isSupported {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  Future<RunHandle> run({
    required ScriptManifest manifest,
    Map<String, Object?> paramOverrides = const {},
    int prerunDelaySeconds = 0,
  }) async {
    if (!isSupported) {
      throw UnsupportedError(
        'ScriptRunner is desktop-only. Mobile and web call sites must '
        'render the unsupported card instead.',
      );
    }

    // Pre-execution delay: optional wait between "Run" being requested
    // and the script actually starting. Surfaced in basic-mode UI as the
    // "Geciktirme ekle" affordance and saved per-binding for action
    // chains. Negative or zero skips the wait entirely.
    final delay = prerunDelaySeconds.clamp(0, _kMaxPrerunDelaySeconds);
    if (delay > 0) {
      await Future<void>.delayed(Duration(seconds: delay));
    }

    final validation = const ParamValidator().validate(
      manifestParams: manifest.params,
      overrides: paramOverrides,
    );
    if (!validation.ok) throw ParamValidationException(validation);

    // Runtime → interpreter + flag style. `win` scripts are PowerShell
    // (`-name`), `mac` (applescript-bash) / `lx` (bash) are POSIX shell
    // (`--name`). Picking both from the same manifest field keeps the
    // bundled library cross-platform without per-script branching.
    final kind = _shellKindFor(manifest.runtime);
    final resolved = await _resolver.resolveSource(manifest);
    return _spawn(
      id: manifest.id,
      source: resolved.source,
      kind: kind,
      paramArgs: _paramMerge.resolve(
        manifestParams: manifest.params,
        overrides: paramOverrides,
        style: kind == _ShellKind.bash ? ParamStyle.posix : ParamStyle.powershell,
      ),
    );
  }

  /// Runs raw [source] directly: no asset/override resolution, no param
  /// merge. Used by user-authored scripts whose body lives in local storage
  /// rather than a bundled asset. Desktop-only, identical pipeline to [run].
  Future<RunHandle> runSource({
    required String id,
    required String source,
    int prerunDelaySeconds = 0,
  }) async {
    if (!isSupported) {
      throw UnsupportedError(
        'ScriptRunner is desktop-only. Mobile and web call sites must '
        'render the unsupported card instead.',
      );
    }
    final delay = prerunDelaySeconds.clamp(0, _kMaxPrerunDelaySeconds);
    if (delay > 0) {
      await Future<void>.delayed(Duration(seconds: delay));
    }
    // User-authored scripts are PowerShell on every platform
    // (user_script.dart: win→powershell-5.1, mac/lx→powershell-7). pwsh must
    // be installed on macOS/Linux for these to run.
    return _spawn(
      id: id,
      source: source,
      kind: _ShellKind.powershell,
      paramArgs: const [],
    );
  }

  /// Shared execution core: writes [source] to temp and spawns the matching
  /// interpreter ([kind]), streaming output. [paramArgs] are already-resolved
  /// CLI flags in the right style for [kind] (empty for raw-source runs).
  ///
  /// PowerShell: writes `<id>.ps1` + a `<id>.wrapper.ps1` that forces UTF-8
  /// console output and ExecutionPolicy bypass, invoked via `-File`.
  /// Bash (mac/lx): writes `<id>.sh` and invokes `/bin/bash <file> <args>`
  /// directly — no wrapper (the OS shell already handles UTF-8 + shebang).
  Future<RunHandle> _spawn({
    required String id,
    required String source,
    required List<String> paramArgs,
    required _ShellKind kind,
  }) async {
    final isPs = kind == _ShellKind.powershell;
    final tempDir = await _ensureTempDir();
    final ts = DateTime.now().microsecondsSinceEpoch;
    final userScript = File('${tempDir.path}/$id-$ts.${isPs ? 'ps1' : 'sh'}');
    final File? wrapper =
        isPs ? File('${tempDir.path}/$id-$ts.wrapper.ps1') : null;
    final toDelete = <File>[userScript, ?wrapper];

    final outputController = StreamController<RunOutputLine>.broadcast();
    final buffered = <RunOutputLine>[];
    final completer = Completer<RunResult>();
    final start = DateTime.now();
    Process? process;
    var cancelled = false;

    void emit(RunOutputLine line) {
      buffered.add(line);
      if (!outputController.isClosed) outputController.add(line);
    }

    try {
      // Faz 4.2: flush:false. await zaten OS write tamamlanmasını bekler;
      // flush:true sadece fsync(), Process.start için gereksiz.
      await userScript.writeAsString(source, flush: false);
      if (wrapper != null) {
        // Wrapper forces UTF-8 console output and execution policy bypass
        // without modifying the user's script. The user file is invoked
        // by absolute path, args ($args) flow through.
        final wrapperSource = '''
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
\$ErrorActionPreference = 'Continue'
& "${userScript.path.replaceAll(r'\', r'\\')}" @args
''';
        await wrapper.writeAsString(wrapperSource, flush: false);
      }
    } catch (e) {
      emit(RunOutputLine(
        kind: RunOutputKind.stderr,
        text: e.toString(),
        ts: DateTime.now(),
      ));
      _completeRunner(
        completer,
        outputController,
        emit,
        start: start,
        exitCode: -1,
        cancelled: false,
        errorMessageKey: 'skapiRunErrorTempWrite',
        errorMessageArg: e.toString(),
      );
      // Best-effort cleanup of the partially written user script.
      _safeDelete(toDelete);
      return RunHandle(
        scriptId: id,
        output: outputController.stream,
        result: completer.future,
        bufferedOutput: buffered,
        onCancel: () {},
      );
    }

    final String executable;
    final List<String> args;
    if (isPs) {
      executable = _powerShellExecutable();
      args = <String>[
        '-NoProfile',
        '-NonInteractive',
        '-ExecutionPolicy',
        'Bypass',
        '-File',
        wrapper!.path,
        ...paramArgs,
      ];
    } else {
      // mac (applescript-bash) / lx (bash): run the .sh directly. Invoking
      // `/bin/bash <file>` ignores the shebang and the execute bit, so the
      // temp file needs no chmod. AppleScript scripts call `osascript`
      // inline; on macOS that may prompt for Automation/Accessibility
      // permission and (under App Sandbox) needs the apple-events entitlement.
      executable = '/bin/bash';
      args = <String>[userScript.path, ...paramArgs];
    }

    try {
      final tProcUs = DateTime.now().microsecondsSinceEpoch;
      process = await Process.start(
        executable,
        args,
        runInShell: false,
      );
      debugPrint('[FAZ0_DIAG] T4_process_start_us=$tProcUs '
          'delta_ms=${(DateTime.now().microsecondsSinceEpoch - tProcUs) ~/ 1000} '
          'pid=${process.pid} exec=$executable');
    } catch (e) {
      emit(RunOutputLine(
        kind: RunOutputKind.stderr,
        text: e.toString(),
        ts: DateTime.now(),
      ));
      final notFound = e.toString().toLowerCase().contains('not found') ||
          e.toString().toLowerCase().contains('cannot run');
      _completeRunner(
        completer,
        outputController,
        emit,
        start: start,
        exitCode: -2,
        cancelled: false,
        errorMessageKey: (isPs && notFound)
            ? 'skapiRunErrorPowerShellMissing'
            : 'skapiRunErrorSpawn',
        errorMessageArg: e.toString(),
      );
      _safeDelete(toDelete);
      return RunHandle(
        scriptId: id,
        output: outputController.stream,
        result: completer.future,
        bufferedOutput: buffered,
        onCancel: () {},
      );
    }

    process.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen(
      (line) => emit(RunOutputLine(
        kind: RunOutputKind.stdout,
        text: line,
        ts: DateTime.now(),
      )),
    );
    process.stderr.transform(utf8.decoder).transform(const LineSplitter()).listen(
      (line) => emit(RunOutputLine(
        kind: RunOutputKind.stderr,
        text: line,
        ts: DateTime.now(),
      )),
    );

    process.exitCode.then((code) {
      _completeRunner(
        completer,
        outputController,
        emit,
        start: start,
        exitCode: code,
        cancelled: cancelled,
      );
      _safeDelete(toDelete);
    });

    return RunHandle(
      scriptId: id,
      output: outputController.stream,
      result: completer.future,
      bufferedOutput: buffered,
      onCancel: () {
        if (cancelled) return;
        cancelled = true;
        try {
          process?.kill(ProcessSignal.sigterm);
        } catch (_) {
          // Process may have exited just before the cancel; ignored.
        }
      },
    );
  }

  String _powerShellExecutable() {
    // Windows ships powershell.exe (5.1) on the PATH. PowerShell 7+ uses
    // pwsh.exe; we prefer the legacy executable because Final.md scripts
    // target 5.1 explicitly. On macOS / Linux PowerShell 7 is the only
    // option, surfaced as `pwsh`. The runner falls back to pwsh if
    // powershell.exe is missing on a non-Windows host.
    if (Platform.isWindows) return 'powershell.exe';
    return 'pwsh';
  }

  Future<Directory> _ensureTempDir() async {
    final base = await getTemporaryDirectory();
    final dir = Directory('${base.path}/skapp_skapi');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  void _completeRunner(
    Completer<RunResult> completer,
    StreamController<RunOutputLine> output,
    void Function(RunOutputLine) emit, {
    required DateTime start,
    required int exitCode,
    required bool cancelled,
    String? errorMessageKey,
    String? errorMessageArg,
  }) {
    if (completer.isCompleted) return;
    final duration = DateTime.now().difference(start).inMilliseconds;
    completer.complete(RunResult(
      exitCode: exitCode,
      durationMs: duration,
      cancelled: cancelled,
      errorMessageKey: errorMessageKey,
      errorMessageArg: errorMessageArg,
    ));
    if (!output.isClosed) output.close();
  }

  Future<void> _safeDelete(List<File> files) async {
    for (final f in files) {
      try {
        if (await f.exists()) await f.delete();
      } catch (_) {
        // Temp clean is best-effort, never blocks the user.
      }
    }
  }
}
