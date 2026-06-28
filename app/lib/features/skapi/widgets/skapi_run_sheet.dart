import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/sk_centered_dialog.dart';
import '../../../core/ui/sk_confirm_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../data/run_handle.dart';
import '../data/script_manifest.dart';
import '../data/script_runner.dart';
import '../data/skapi_providers.dart';

/// Bottom sheet that drives a single script run.
///
/// State machine:
///   booting   - awaiting `ScriptRunner.run()` (manifest load + spawn)
///   running   - process is alive; output streams in
///   ok        - exit 0, success styling
///   error     - non-zero exit or runner-side failure (errorMessageKey)
///   cancelled - user pressed Cancel; UI shows the dim "Cancelled" tone
///
/// Dismissing the sheet while running prompts a confirm dialog because
/// the runner kill is destructive (running scripts may be mid-side-effect).
class SkapiRunSheet extends ConsumerStatefulWidget {
  const SkapiRunSheet({
    super.key,
    required this.manifest,
    this.paramOverrides = const {},
    this.prerunDelaySeconds = 0,
  });

  final ScriptManifest manifest;

  /// Values collected from the basic-mode form, or empty for
  /// professional-mode (runner falls back to manifest defaults).
  final Map<String, Object?> paramOverrides;

  /// Optional wait between Run being requested and the script actually
  /// starting. Set by the basic-mode "Geciktirme ekle" widget.
  final int prerunDelaySeconds;

  @override
  ConsumerState<SkapiRunSheet> createState() => _SkapiRunSheetState();
}

enum _RunSheetState { booting, running, ok, error, cancelled }

class _SkapiRunSheetState extends ConsumerState<SkapiRunSheet> {
  _RunSheetState _state = _RunSheetState.booting;
  RunHandle? _handle;
  RunResult? _result;
  StreamSubscription<RunOutputLine>? _sub;
  final List<RunOutputLine> _lines = [];
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _kickoff();
  }

  Future<void> _kickoff() async {
    try {
      final runner = ref.read(scriptRunnerProvider);
      final handle = await runner.run(
        manifest: widget.manifest,
        paramOverrides: widget.paramOverrides,
        prerunDelaySeconds: widget.prerunDelaySeconds,
      );
      if (!mounted) {
        handle.cancel();
        return;
      }
      setState(() {
        _handle = handle;
        _state = _RunSheetState.running;
        _lines.addAll(handle.bufferedOutput);
      });
      _sub = handle.output.listen((line) {
        if (!mounted) return;
        setState(() => _lines.add(line));
      });
      handle.result.then((result) {
        if (!mounted) return;
        setState(() {
          _result = result;
          if (result.cancelled) {
            _state = _RunSheetState.cancelled;
          } else if (result.success) {
            _state = _RunSheetState.ok;
          } else {
            _state = _RunSheetState.error;
          }
        });
      });
    } on ParamValidationException catch (e) {
      if (!mounted) return;
      setState(() {
        _result = RunResult(
          exitCode: -2,
          durationMs: 0,
          cancelled: false,
          errorMessageKey: e.message,
        );
        _state = _RunSheetState.error;
      });
    } on UnsupportedError catch (e) {
      if (!mounted) return;
      setState(() {
        _result = RunResult(
          exitCode: -3,
          durationMs: 0,
          cancelled: false,
          errorMessageKey: 'skapiRunErrorSpawn',
          errorMessageArg: e.message ?? 'unsupported',
        );
        _state = _RunSheetState.error;
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _handle?.cancel();
    super.dispose();
  }

  Future<bool> _confirmDismiss() async {
    if (_state != _RunSheetState.running) return true;
    final l = AppLocalizations.of(context);
    // Çalışan scripti durdurmak yıkıcı (yan etki ortasında olabilir) →
    // destructive. Ortak SkConfirmDialog ile diğer modallarla tutarlı.
    final ok = await showSkConfirm(
      context,
      title: l.skapiRunSheetDismissConfirmTitle,
      message: l.skapiRunSheetDismissConfirmBody,
      cancelLabel: l.skapiRunSheetDismissConfirmStay,
      confirmLabel: l.skapiRunSheetDismissConfirmStop,
      destructive: true,
    );
    if (ok) _handle?.cancel();
    return ok;
  }

  Future<void> _copyOutput() async {
    final text = _lines.map((l) => l.text).join('\n');
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return PopScope(
      canPop: _state != _RunSheetState.running,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDismiss()) {
          if (!mounted) return;
          Navigator.of(this.context).maybePop();
        }
      },
      child: SkCenteredDialog(
        title: l.skapiRunSheetTitle,
        icon: Icons.terminal_rounded,
        subtitle: widget.manifest.id,
        maxWidth: 720,
        maxHeight: 620,
        showCloseButton: false,
        bodyPadding: EdgeInsets.zero,
        actions: [
          TextButton.icon(
            onPressed: _lines.isEmpty ? null : _copyOutput,
            icon: Icon(
              _copied ? Icons.check_rounded : Icons.copy_rounded,
            ),
            label: Text(
              _copied
                  ? l.skapiRunSheetCopiedDone
                  : l.skapiRunSheetCopyOutput,
            ),
          ),
          if (_state == _RunSheetState.running)
            OutlinedButton(
              onPressed: () => _handle?.cancel(),
              child: Text(l.skapiRunSheetCancel),
            )
          else
            FilledButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(l.skapiRunSheetClose),
            ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status chip rendered inside body since SkCenteredDialog
            // doesn't expose a header trailing slot.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  const Spacer(),
                  _StatusChip(state: _state),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: cs.onSurface.withValues(alpha: 0.08),
            ),
            // Fixed-height output area: SingleChildScrollView (provided
            // by SkCenteredDialog) handles overflow if the user adds
            // bottom panels; the output itself has its own internal
            // scroll for log lines.
            SizedBox(
              height: 360,
              child: _OutputView(lines: _lines),
            ),
            if (_result?.errorMessageKey != null)
              _ErrorBanner(result: _result!),
            if (_result != null) _DurationLine(result: _result!),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.state});
  final _RunSheetState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    const mustard = Color(0xFFD4A017);
    const red = Color(0xFFD32F2F);
    // Palet: renk yalnız dikkat (mustard=çalışıyor) ve hata (red) için.
    // "Tamam" güçlü nötr (foreground dolu), "iptal" sönük nötr — başarı
    // ayrı bir renkle değil opaklık+dolgu ile ayrışır (tasarim.md §1.3).
    final (label, fg, bg) = switch (state) {
      _RunSheetState.booting || _RunSheetState.running => (
          l.skapiRunSheetStatusRunning,
          Colors.black,
          mustard,
        ),
      _RunSheetState.ok => (
          l.skapiRunSheetStatusOk,
          cs.surface,
          cs.onSurface,
        ),
      _RunSheetState.error => (
          l.skapiRunSheetStatusError,
          Colors.white,
          red,
        ),
      _RunSheetState.cancelled => (
          l.skapiRunSheetCancel,
          cs.surface,
          cs.onSurface.withValues(alpha: 0.45),
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: tt.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _OutputView extends StatelessWidget {
  const _OutputView({required this.lines});
  final List<RunOutputLine> lines;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    if (lines.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l.skapiRunSheetEmptyOutput,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.55),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }
    const black = Color(0xFF0A0A0A);
    const cream = Color(0xFFF5F2EC);
    return Container(
      width: double.infinity,
      color: black,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: SelectableText(
                  line.text.isEmpty ? ' ' : line.text,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11.5,
                    color: line.kind == RunOutputKind.stderr
                        ? const Color(0xFFD32F2F)
                        : line.kind == RunOutputKind.info
                            ? const Color(0xFFD4A017)
                            : cream,
                    height: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.result});
  final RunResult result;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const red = Color(0xFFD32F2F);
    final message = _resolveErrorMessage(l, result);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      color: red.withValues(alpha: 0.10),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: red, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: red,
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _resolveErrorMessage(AppLocalizations l, RunResult r) {
    final arg = r.errorMessageArg ?? '';
    switch (r.errorMessageKey) {
      case 'skapiRunErrorPowerShellMissing':
        return l.skapiRunErrorPowerShellMissing;
      case 'skapiRunErrorTempWrite':
        return l.skapiRunErrorTempWrite(arg);
      case 'skapiRunErrorSpawn':
        return l.skapiRunErrorSpawn(arg);
    }
    return r.errorMessageKey ?? '';
  }
}

class _DurationLine extends StatelessWidget {
  const _DurationLine({required this.result});
  final RunResult result;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          if (result.errorMessageKey == null)
            Text(
              l.skapiRunSheetExitCode(result.exitCode),
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.7),
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          const Spacer(),
          Text(
            l.skapiRunDurationMs(result.durationMs),
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.55),
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
