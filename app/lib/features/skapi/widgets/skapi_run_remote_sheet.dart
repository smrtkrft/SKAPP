import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/skapp_http_client.dart';
import '../../../core/network/skapp_peer_target.dart';
import '../../../core/ui/sk_centered_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../data/run_handle.dart';
import '../data/script_manifest.dart';

/// Mobile-side remote run sheet. Mirrors `SkapiRunSheet` (local Desktop
/// runner) with two differences:
///   1. Output comes from `SkappHttpClient.runRemote` instead of
///      `ScriptRunner`. The wire format is identical (`RunOutputLine`)
///      so the rendering path is shared.
///   2. Errors map to remote-run-specific i18n keys
///      (offline / unauthorized / generic) so the user understands the
///      failure is a connectivity / auth issue, not a script bug.
class SkapiRunRemoteSheet extends ConsumerStatefulWidget {
  const SkapiRunRemoteSheet({
    super.key,
    required this.manifest,
    required this.peer,
    this.paramOverrides = const {},
    this.prerunDelaySeconds = 0,
  });

  final ScriptManifest manifest;
  final SkappPeerTarget peer;

  /// Basic-mode form values forwarded to the remote runner. Empty for
  /// professional-mode where the form is not surfaced.
  final Map<String, Object?> paramOverrides;

  /// Optional pre-run wait honored by the remote `ScriptRunner`.
  final int prerunDelaySeconds;

  @override
  ConsumerState<SkapiRunRemoteSheet> createState() =>
      _SkapiRunRemoteSheetState();
}

enum _State { connecting, running, ok, error, cancelling, cancelled }

class _SkapiRunRemoteSheetState extends ConsumerState<SkapiRunRemoteSheet> {
  _State _state = _State.connecting;
  final List<RunOutputLine> _lines = [];
  StreamSubscription<RunOutputLine>? _sub;
  RemoteRunResult? _result;
  String? _error;
  bool _copied = false;
  RemoteRunHandle? _handle;

  @override
  void initState() {
    super.initState();
    _kickoff();
  }

  Future<void> _kickoff() async {
    final l = AppLocalizations.of(context);
    try {
      final client = ref.read(skappHttpClientProvider);
      final handle = await client.runRemote(
        peer: widget.peer,
        platform: widget.manifest.platform,
        scriptId: widget.manifest.id,
        paramOverrides: widget.paramOverrides,
        prerunDelaySeconds: widget.prerunDelaySeconds,
      );
      if (!mounted) return;
      setState(() {
        _handle = handle;
        _state = _State.running;
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
            _state = _State.cancelled;
          } else {
            _state = result.success ? _State.ok : _State.error;
          }
        });
      });
    } on SkappPeerOfflineException {
      if (!mounted) return;
      setState(() {
        _state = _State.error;
        _error = l.skapiRunRemoteOfflineError;
      });
    } on SkappPeerUnauthorizedException {
      if (!mounted) return;
      setState(() {
        _state = _State.error;
        _error = l.skapiRunRemoteUnauthorizedError;
      });
    } on SkappPeerTooManyRunsException catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _State.error;
        _error = l.skapiRunRemoteTooManyRuns(e.running, e.limit);
      });
    } on SkappPeerHttpException catch (e) {
      if (!mounted) return;
      // 403 with body marker `pro_mode_disabled` means the target Desktop
      // has Developer mode off, explicit message instead of generic HTTP
      // text so the user knows the failure is config, not a bug.
      // `not_remote_runnable` is a separate 403 with its own message —
      // the script detail screen filters those out *before* opening this
      // sheet, but the defensive branch keeps the message useful if the
      // sheet is somehow opened with a non-whitelisted script.
      final isDeveloperModeOff =
          e.statusCode == 403 && e.body.contains('pro_mode_disabled');
      final isNotWhitelisted =
          e.statusCode == 403 && e.body.contains('not_remote_runnable');
      setState(() {
        _state = _State.error;
        _error = isDeveloperModeOff
            ? l.skapiRunRemoteDeveloperModeDisabled
            : isNotWhitelisted
                ? l.skapiRunRemoteNotWhitelisted
                : l.skapiRunRemoteHttpError(e.toString());
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _State.error;
        _error = l.skapiRunRemoteHttpError(e.toString());
      });
    }
  }

  /// User pressed the in-sheet Cancel button while the run is live.
  /// Fires `DELETE /api/scripts/runs/runId` in the background and
  /// flips the sheet into "cancelling" so the button can't be tapped
  /// twice. The final state flip to `_State.cancelled` happens when
  /// the `end` record carries `cancelled: true`.
  void _onCancel() {
    final handle = _handle;
    if (handle == null) return;
    setState(() => _state = _State.cancelling);
    unawaited(handle.cancel());
  }

  @override
  void dispose() {
    _sub?.cancel();
    // Sheet was dismissed while a run was still streaming. Send a
    // best-effort cancel so the desktop process doesn't keep running
    // unattended. The future is fire-and-forget; we're disposing.
    final handle = _handle;
    if (handle != null &&
        (_state == _State.running || _state == _State.cancelling)) {
      unawaited(handle.cancel());
    }
    super.dispose();
  }

  Future<void> _copy() async {
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
    final tt = Theme.of(context).textTheme;
    return SkCenteredDialog(
      title: l.skapiRunRemoteSheetTitle(widget.peer.name),
      icon: Icons.cloud_outlined,
      subtitle: widget.manifest.id,
      maxWidth: 720,
      maxHeight: 620,
      showCloseButton: false,
      bodyPadding: EdgeInsets.zero,
      actions: [
        TextButton.icon(
          onPressed: _lines.isEmpty ? null : _copy,
          icon: Icon(_copied ? Icons.check_rounded : Icons.copy_rounded),
          label: Text(_copied
              ? l.skapiRunSheetCopiedDone
              : l.skapiRunSheetCopyOutput),
        ),
        // Cancel button is only meaningful while the run is in flight;
        // terminal states (ok/error/cancelled) make Cancel a no-op.
        if (_state == _State.running || _state == _State.cancelling)
          OutlinedButton.icon(
            onPressed: _state == _State.cancelling ? null : _onCancel,
            icon: const Icon(Icons.stop_circle_outlined),
            label: Text(l.skapiRunRemoteCancelButton),
            style: OutlinedButton.styleFrom(
              foregroundColor: cs.error,
              side: BorderSide(color: cs.error),
            ),
          ),
        FilledButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(l.skapiRunSheetClose),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 360,
            child: _OutputView(state: _state, lines: _lines),
          ),
          if (_error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: cs.error.withValues(alpha: 0.10),
              child: Text(
                _error!,
                style: TextStyle(color: cs.error),
              ),
            ),
          if (_result != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                _state == _State.cancelled
                    ? l.skapiRunRemoteCancelledNote
                    : l.skapiRunSheetExitCode(_result!.exitCode),
                style: tt.labelMedium?.copyWith(
                  fontFamily: 'monospace',
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OutputView extends StatelessWidget {
  const _OutputView({required this.state, required this.lines});
  final _State state;
  final List<RunOutputLine> lines;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    if (state == _State.connecting && lines.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text(
                l.skapiRunRemoteConnecting,
                style: TextStyle(color: cs.onSurface.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
      );
    }
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
