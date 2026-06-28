import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/responsive.dart';
import '../../core/ui/sk_confirm_dialog.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import 'data/script_manifest.dart';
import 'data/skapi_providers.dart';

/// Script editor screen (Adım 5 in the SKAPI WIN flow).
///
/// Loads the resolved (override-aware) source as the seed, lets the user
/// edit it as plain text, and writes back through [ScriptResolver] when
/// they tap Save. The bundled original is never mutated; per-device edits
/// land in the override storage layer.
///
/// The editor is intentionally a plain monospace text area: PowerShell
/// has no syntax highlighter wired in Phase 1 and adding one would be a
/// lot of moving parts for a tool that mostly receives small parameter
/// tweaks. Line numbers, modified marker, line/col indicator, and a diff
/// summary are enough to make edits feel deliberate.
class SkapiScriptEditorScreen extends ConsumerStatefulWidget {
  const SkapiScriptEditorScreen({super.key, required this.manifest});

  final ScriptManifest manifest;

  @override
  ConsumerState<SkapiScriptEditorScreen> createState() =>
      _SkapiScriptEditorScreenState();
}

class _SkapiScriptEditorScreenState
    extends ConsumerState<SkapiScriptEditorScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  String _seed = '';
  String _original = '';
  bool _seeded = false;
  int _line = 1;
  int _column = 1;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_recomputeCursor);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _recomputeCursor() {
    final sel = _controller.selection;
    final offset =
        sel.isValid ? sel.baseOffset.clamp(0, _controller.text.length) : 0;
    var line = 1;
    var col = 1;
    for (var i = 0; i < offset; i++) {
      if (_controller.text.codeUnitAt(i) == 10) {
        line++;
        col = 1;
      } else {
        col++;
      }
    }
    if (line != _line || col != _column) {
      setState(() {
        _line = line;
        _column = col;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final resolved = ref.watch(resolvedScriptProvider(widget.manifest));

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        ),
        title: Text(l.skapiEditorTitle),
      ),
      body: resolved.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, st) => SkContent(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              l.skapiScriptDetailLoadError(e.toString()),
              style: TextStyle(color: cs.error),
            ),
          ),
        ),
        data: (r) {
          // First successful load: seed the editor with the current
          // source (override if any, else bundled original).
          if (!_seeded) {
            _seed = r.source;
            _original = r.original;
            _controller.text = _seed;
            _seeded = true;
          }
          return _EditorBody(
            manifest: widget.manifest,
            controller: _controller,
            focusNode: _focus,
            originalSource: _original,
            line: _line,
            column: _column,
            onReset: () => _onReset(context),
            onSave: () => _onSave(),
          );
        },
      ),
    );
  }

  Future<void> _onReset(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final ok = await _confirm(
      context,
      title: l.skapiEditorButtonReset,
      body: l.skapiEditorAfterSaveNote,
    );
    if (!ok) return;
    await ref.read(scriptResolverProvider).reset(widget.manifest);
    ref.invalidate(resolvedScriptProvider(widget.manifest));
    if (!mounted) return;
    setState(() {
      _seeded = false;
      _line = 1;
      _column = 1;
    });
  }

  Future<void> _onSave() async {
    final source = _controller.text;
    if (source == _seed && source == _original) {
      // Nothing changed and there's no override either, no-op silently.
      Navigator.of(context).maybePop();
      return;
    }
    await ref.read(scriptResolverProvider).saveEdit(
          manifest: widget.manifest,
          editedSource: source,
        );
    ref.invalidate(resolvedScriptProvider(widget.manifest));
    if (!mounted) return;
    Navigator.of(context).maybePop();
  }

  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    final ml = MaterialLocalizations.of(context);
    return showSkConfirm(
      context,
      title: title,
      message: body,
      confirmLabel: ml.okButtonLabel,
      cancelLabel: ml.cancelButtonLabel,
    );
  }
}

class _EditorBody extends StatelessWidget {
  const _EditorBody({
    required this.manifest,
    required this.controller,
    required this.focusNode,
    required this.originalSource,
    required this.line,
    required this.column,
    required this.onReset,
    required this.onSave,
  });

  final ScriptManifest manifest;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String originalSource;
  final int line;
  final int column;
  final VoidCallback onReset;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 110),
      children: [
        SkContent(
          horizontalPadding: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _InfoStrip(
                text: l.skapiEditorHint(manifest.id),
              ),
              const SizedBox(height: 12),
              _EditorPanel(
                controller: controller,
                focusNode: focusNode,
                originalSource: originalSource,
                line: line,
                column: column,
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  final diff = _diffLineCount(originalSource, value.text);
                  return Row(
                    children: [
                      Text(
                        diff == 1
                            ? l.skapiEditorDiffLineCount(1)
                            : l.skapiEditorDiffLinesCount(diff),
                        style: tt.labelMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        onPressed: onReset,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(l.skapiEditorButtonReset),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: FilledButton(
                        onPressed: onSave,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0A0A0A),
                          foregroundColor: const Color(0xFFF5F2EC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(l.skapiEditorButtonSave),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  l.skapiEditorAfterSaveNote,
                  textAlign: TextAlign.center,
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoStrip extends StatelessWidget {
  const _InfoStrip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const mustard = Color(0xFFD4A017);
    return SkNeuCard(
      borderRadius: 10,
      borderColor: mustard,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.8),
              height: 1.4,
            ),
      ),
    );
  }
}

/// Black panel with a line-number gutter and a multi-line code field.
/// The status bar above shows the runtime tag and a "Modified" pulse;
/// the foot shows the cursor coords.
class _EditorPanel extends StatelessWidget {
  const _EditorPanel({
    required this.controller,
    required this.focusNode,
    required this.originalSource,
    required this.line,
    required this.column,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String originalSource;
  final int line;
  final int column;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const black = Color(0xFF0A0A0A);
    const cream = Color(0xFFF5F2EC);
    const mustard = Color(0xFFD4A017);
    const dim = Color(0xFFA8A39A);
    const gutterBg = Color(0xFF0D0D0D);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cream.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status bar
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, v, _) {
              final modified = v.text != originalSource;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                decoration: const BoxDecoration(
                  color: Color(0xFF161616),
                  border: Border(
                    bottom:
                        BorderSide(color: Color(0xFF2A2A2A), width: 1),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: modified ? mustard : dim,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l.skapiEditorStatusBarTitle,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: dim,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      modified
                          ? l.skapiEditorStatusModified
                          : l.skapiEditorStatusUnmodified,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: modified ? mustard : dim,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Body: gutter + editable field. Both scroll horizontally if
          // long lines push past the panel; vertical scrolling is
          // delegated to the outer ListView so we keep one scroll axis.
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 280),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, v, _) {
                final lineCount = '\n'.allMatches(v.text).length + 1;
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: gutterBg,
                          border: Border(
                            right: BorderSide(
                                color: Color(0xFF1F1F1F), width: 1),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(11, 11, 8, 11),
                        child: Text(
                          [for (var i = 1; i <= lineCount; i++) i.toString()]
                              .join('\n'),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11.5,
                            color: Color(0xFF5A5A5A),
                            height: 1.55,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(13, 11, 11, 11),
                          child: TextField(
                            controller: controller,
                            focusNode: focusNode,
                            maxLines: null,
                            cursorColor: mustard,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11.5,
                              color: cream,
                              height: 1.55,
                            ),
                            decoration: const InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                              filled: false,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Foot: cursor position + Ctrl+S hint.
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: const BoxDecoration(
              color: Color(0xFF0D0D0D),
              border: Border(
                top: BorderSide(color: Color(0xFF1F1F1F), width: 1),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  l.skapiEditorFootCursor(line, column),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10.5,
                    color: Color(0xFF7A7A7A),
                  ),
                ),
                const Spacer(),
                Text(
                  l.skapiEditorFootSaveLabel,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10.5,
                    color: Color(0xFF7A7A7A),
                  ),
                ),
                const SizedBox(width: 6),
                _Key(label: 'Ctrl'),
                const SizedBox(width: 4),
                _Key(label: 'S'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 10,
          color: Color(0xFFA8A39A),
        ),
      ),
    );
  }
}

/// Counts how many lines differ between two sources. Faz 1 uses a coarse
/// definition: two lines at the same index that differ in any character
/// count as one changed line; length differences add to the count too.
/// Good enough for "1 line changed" / "12 lines changed" surfacing.
int _diffLineCount(String original, String edited) {
  final oLines = original.split('\n');
  final eLines = edited.split('\n');
  final maxLen = oLines.length > eLines.length ? oLines.length : eLines.length;
  var changed = 0;
  for (var i = 0; i < maxLen; i++) {
    final o = i < oLines.length ? oLines[i] : null;
    final e = i < eLines.length ? eLines[i] : null;
    if (o != e) changed++;
  }
  return changed;
}
