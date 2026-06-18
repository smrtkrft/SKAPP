import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import 'data/run_handle.dart';
import 'data/skapi_providers.dart';
import 'data/user_script.dart';
import 'user_script_editor_screen.dart';

/// Read view for a single user script: header + code, with Run (desktop),
/// Edit, and Delete. Reads the script live from [userScriptsProvider] by id
/// so edits/deletes from elsewhere reflect immediately.
class UserScriptDetailScreen extends ConsumerWidget {
  const UserScriptDetailScreen({super.key, required this.scriptId});

  final String scriptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final script =
        ref.watch(userScriptsProvider).where((s) => s.id == scriptId).firstOrNull;

    // Deleted while open (e.g. from another route): bail to a tidy empty state.
    if (script == null) {
      return Scaffold(
        bottomNavigationBar: const ShellNavBar(),
        appBar: AppBar(),
        body: const SizedBox.shrink(),
      );
    }

    final runner = ref.read(scriptRunnerProvider);
    final canRun = runner.isSupported;

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(script.title),
        actions: [
          IconButton(
            tooltip: l.skapiUserEditCta,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => UserScriptEditorScreen(existing: script),
              ),
            ),
          ),
          IconButton(
            tooltip: l.commonDelete,
            icon: Icon(Icons.delete_outline, color: cs.error),
            onPressed: () => _confirmDelete(context, ref, l, script),
          ),
        ],
      ),
      body: SkContentFrame(
        maxWidth: 820,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 48),
          children: [
            SkNeuCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          script.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      _PlatformBadge(platform: script.platform),
                    ],
                  ),
                  if (script.description.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      script.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  l.skapiUserDetailCodeHeading,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        letterSpacing: 0.6,
                      ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: canRun
                      ? () => _run(context, ref, script)
                      : () {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                              content: Text(l.skapiUserRunUnsupported,
                                  textAlign: TextAlign.center),
                            ));
                        },
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: Text(l.skapiUserRunCta),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SkNeuCard(
              padding: const EdgeInsets.all(12),
              child: SelectableText(
                script.source,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    UserScript script,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.skapiUserDeleteConfirmTitle),
        content: Text(l.skapiUserDeleteConfirmBody(script.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await ref.read(userScriptsProvider.notifier).remove(script.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l.skapiUserDeletedSnack, textAlign: TextAlign.center),
      ));
    Navigator.of(context).pop();
  }

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    UserScript script,
  ) async {
    final runner = ref.read(scriptRunnerProvider);
    final handle = await runner.runSource(id: script.id, source: script.source);
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _RunOutputSheet(handle: handle),
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  const _PlatformBadge({required this.platform});
  final String platform;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final label = switch (platform) {
      'mac' => 'macOS',
      'lx' => 'Linux',
      _ => 'Windows',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: cs.onSurface)),
    );
  }
}

/// Live run output: subscribes to [RunHandle.output], lists lines, and shows
/// the exit code when the run completes.
class _RunOutputSheet extends StatefulWidget {
  const _RunOutputSheet({required this.handle});
  final RunHandle handle;

  @override
  State<_RunOutputSheet> createState() => _RunOutputSheetState();
}

class _RunOutputSheetState extends State<_RunOutputSheet> {
  final List<RunOutputLine> _lines = [];
  RunResult? _result;

  @override
  void initState() {
    super.initState();
    _lines.addAll(widget.handle.bufferedOutput);
    widget.handle.output.listen((line) {
      if (mounted) setState(() => _lines.add(line));
    });
    widget.handle.result.then((r) {
      if (mounted) setState(() => _result = r);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  l.skapiUserRunOutputTitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                if (_result != null)
                  Text(
                    l.skapiUserRunDone(_result!.exitCode),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: _result!.exitCode == 0
                              ? cs.primary
                              : cs.error,
                        ),
                  )
                else
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.5,
              ),
              child: SkNeuCard(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _lines.isEmpty
                        ? '…'
                        : _lines.map((e) => e.text).join('\n'),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12.5,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
