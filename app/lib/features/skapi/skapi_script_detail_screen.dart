import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings/settings_providers.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import 'data/script_manifest.dart';
import 'data/script_resolver.dart';
import 'data/skapi_i18n_lookup.dart';
import 'data/skapi_providers.dart';
import 'skapi_bind_screen.dart';
import 'skapi_script_editor_screen.dart';
import 'widgets/skapi_basic_param_form.dart';
import 'widgets/skapi_run_sheet.dart';
import 'widgets/skapi_tier_badge.dart';

/// Script detail screen (Adım 4 in the SKAPI WIN flow).
///
/// Layout, top to bottom:
///   1. det-meta hairline header: scriptId only
///   2. summary block (groupdesc style): "What it does" + "How it works"
///   3. Original Script section: read-only English code panel
///   4. Editing card: state-aware (no edit / edited / edited+outdated)
///   5. Parameters warning panel: red border, key/value rows, hint
///   6. Action buttons: Run Now (primary) | Bind to Action (50/50 grid)
///
/// "Edit" lives inside the editing card (inline), not in the bottom row,
/// so the bottom is a clean two-button surface and the editing card owns
/// its own action. Faz F replaces the inline action's stub with a route
/// push to the editor screen.
class SkapiScriptDetailScreen extends ConsumerStatefulWidget {
  const SkapiScriptDetailScreen({super.key, required this.manifest});

  final ScriptManifest manifest;

  @override
  ConsumerState<SkapiScriptDetailScreen> createState() =>
      _SkapiScriptDetailScreenState();
}

class _SkapiScriptDetailScreenState
    extends ConsumerState<SkapiScriptDetailScreen> {
  /// Live values shown in the basic-mode form. Initialised from manifest
  /// defaults; user edits update this map; `_onRun` ships it to the runner.
  late Map<String, Object?> _paramOverrides;
  int _prerunDelay = 0;

  ScriptManifest get manifest => widget.manifest;

  @override
  void initState() {
    super.initState();
    _paramOverrides = {
      for (final p in manifest.params) p.name: p.defaultValue,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final resolved = ref.watch(resolvedScriptProvider(manifest));
    final isDeveloper = ref.watch(developerModeProvider);
    final title = _scriptTitle(l, manifest.i18nTitle);

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(
              child: Text(title, overflow: TextOverflow.ellipsis),
            ),
            if (manifest.tier > 1) ...[
              const SizedBox(width: 10),
              SkapiTierBadge(tier: manifest.tier),
            ],
          ],
        ),
      ),
      // Scroll en dış katmanda: tüm pencere genişliğinde gesture alır,
      // kullanıcı kenarlardaki boş alanlardan da kaydırabilir. Settings
      // ekranı ile aynı pattern. İçerik desktop'ta SkBreakpoints'in
      // maxWideContentWidth eşiğine kadar merkezde tutulur, mobile'da
      // ekran genişliğini doldurur (constraint no-op).
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: SkBreakpoints.maxWideContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            // 1) det-meta: scriptId + binding count badge, hairline below.
            //    Tier/runtime are dev metadata, deliberately not shown to
            //    end users.
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      manifest.id,
                      style: tt.labelMedium?.copyWith(
                        fontFamily: 'monospace',
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, _) {
                      final count = ref
                          .watch(bindingsForScriptProvider(manifest.id))
                          .length;
                      if (count == 0) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A017),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          l.skapiBindBadgeCount(count),
                          style: tt.labelSmall?.copyWith(
                            color: const Color(0xFF0A0A0A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: cs.onSurface.withValues(alpha: 0.08),
            ),
            const SizedBox(height: 14),

            // 2) Summary block (no heading, direct content; matches Adım 3
            //    groupdesc convention).
            _SummaryBlock(manifest: manifest),

            const SizedBox(height: 18),

            // 3-6) Developer vs Basic branching. Developer mode keeps
            //      the original script panel + editor card + read-only
            //      param warn; Basic mode swaps them for an editable form
            //      + optional pre-run delay block.
            resolved.when(
              loading: () => const _DetailLoading(),
              error: (e, st) => _DetailError(
                message: l.skapiScriptDetailLoadError(e.toString()),
              ),
              data: (resolvedScript) => isDeveloper
                  ? _DeveloperBody(
                      manifest: manifest,
                      resolvedScript: resolvedScript,
                      onEdit: () => _onEdit(context),
                      onReset: () => _onReset(context, ref),
                      onRun: () => _onRun(context, ref),
                      onBind: () => _onBind(context),
                    )
                  : _BasicBody(
                      manifest: manifest,
                      paramOverrides: _paramOverrides,
                      prerunDelay: _prerunDelay,
                      onParamsChanged: (next) {
                        setState(() => _paramOverrides = next);
                      },
                      onPrerunChanged: (v) {
                        setState(() => _prerunDelay = v);
                      },
                      onRun: () => _onRun(context, ref),
                      onBind: () => _onBind(context),
                    ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Pushes the editor screen (Adım 5). The editor seeds itself from the
  /// override-aware resolved source, then writes back through the resolver
  /// so the next [resolvedScriptProvider] read flips the editing card to
  /// its modified state.
  void _onEdit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SkapiScriptEditorScreen(manifest: manifest),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _onReset(BuildContext context, WidgetRef ref) async {
    await ref.read(scriptResolverProvider).reset(manifest);
    // Invalidate so the detail card flips back to the "no edits" state.
    ref.invalidate(resolvedScriptProvider(manifest));
  }

  /// Opens the run sheet on Desktop hosts. Mobile hosts route through a
  /// "no-op + feature coming soon" snackbar by design: the SKAPP
  /// topology says scripts only run on Desktop SKAPPs, never on phones,
  /// and the inverse direction (phone runs script on paired Desktop)
  /// was withdrawn at Faz 3 redirect — phones are event sources
  /// (PairedDevice with `MS` prefix), they don't trigger remote runs
  /// from the script-detail screen. Desktop→Desktop remote run UI is
  /// out of scope here; it will be exposed on the Desktop's SKAPI
  /// screen using the same `SkapiRunRemoteSheet` widget in a future
  /// phase.
  void _onRun(BuildContext context, WidgetRef ref) {
    final desktop = !kIsWeb &&
        (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
    if (!desktop) {
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(l.featureComingSoonSnack, textAlign: TextAlign.center),
          duration: const Duration(seconds: 2),
        ));
      return;
    }
    final overrides = Map<String, Object?>.from(_paramOverrides);
    final prerun = _prerunDelay;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SkapiRunSheet(
        manifest: manifest,
        paramOverrides: overrides,
        prerunDelaySeconds: prerun,
      ),
    );
  }

  /// Pushes the bind form. New binding by default; the form opens with
  /// the first paired device pre-selected so the most common path is one
  /// tap away. Editing an existing binding is reached via the bindings
  /// list (added in a follow-up patch on this same screen).
  void _onBind(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SkapiBindScreen(manifest: manifest),
      ),
    );
  }
}

/// Developer-mode body: original script panel + state-aware editing card +
/// read-only param warning + action buttons. The detail screen uses this
/// when [developerModeProvider] is true.
class _DeveloperBody extends StatelessWidget {
  const _DeveloperBody({
    required this.manifest,
    required this.resolvedScript,
    required this.onEdit,
    required this.onReset,
    required this.onRun,
    required this.onBind,
  });

  final ScriptManifest manifest;
  final ResolvedScript resolvedScript;
  final VoidCallback onEdit;
  final VoidCallback onReset;
  final VoidCallback onRun;
  final VoidCallback onBind;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHead(
          title: l.skapiScriptDetailOriginalSectionTitle,
          sub: l.skapiScriptDetailOriginalSectionSub,
        ),
        const SizedBox(height: 6),
        _CodePanel(
          source: resolvedScript.original,
          copyLabel: l.skapiScriptCopyButton,
          copiedLabel: l.skapiScriptCopyButtonDone,
        ),
        const SizedBox(height: 18),
        _SectionHead(title: l.skapiScriptDetailEditingSectionTitle),
        const SizedBox(height: 6),
        _EditingCard(
          state: resolvedScript.state,
          onEdit: onEdit,
          onView: onEdit,
          onReset: onReset,
        ),
        const SizedBox(height: 18),
        if (manifest.params.isNotEmpty) _ParamWarn(manifest: manifest),
        const SizedBox(height: 18),
        _ActionButtons(onRun: onRun, onBind: onBind),
      ],
    );
  }
}

/// Basic-mode body: editable parameter form + optional pre-run delay
/// + action buttons. Code panel and editor are not surfaced; the user
/// works with parameter widgets only. The detail screen uses this when
/// [developerModeProvider] is false (the default).
class _BasicBody extends StatelessWidget {
  const _BasicBody({
    required this.manifest,
    required this.paramOverrides,
    required this.prerunDelay,
    required this.onParamsChanged,
    required this.onPrerunChanged,
    required this.onRun,
    required this.onBind,
  });

  final ScriptManifest manifest;
  final Map<String, Object?> paramOverrides;
  final int prerunDelay;
  final ValueChanged<Map<String, Object?>> onParamsChanged;
  final ValueChanged<int> onPrerunChanged;
  final VoidCallback onRun;
  final VoidCallback onBind;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHead(title: l.skapiBasicSettingsTitle),
        const SizedBox(height: 6),
        SkapiBasicParamForm(
          params: manifest.params,
          initialValues: paramOverrides,
          onChanged: onParamsChanged,
        ),
        const SizedBox(height: 16),
        SkapiBasicPrerunDelay(
          value: prerunDelay,
          onChanged: onPrerunChanged,
        ),
        const SizedBox(height: 12),
        _ActionButtons(onRun: onRun, onBind: onBind),
      ],
    );
  }
}

class _SummaryBlock extends StatelessWidget {
  const _SummaryBlock({required this.manifest});

  final ScriptManifest manifest;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final what = _summaryWhat(l, manifest.i18nSummaryWhat);
    final how = _summaryHow(l, manifest.i18nSummaryHow);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LabeledParagraph(
            label: l.skapiScriptDetailSummaryWhatLabel,
            body: what,
          ),
          const SizedBox(height: 10),
          _LabeledParagraph(
            label: l.skapiScriptDetailSummaryHowLabel,
            body: how,
          ),
          // Optional notes block, only when the manifest set an i18nNote.
          if (manifest.i18nNote != null) ...[
            const SizedBox(height: 16),
            Text(
              l.skapiScriptDetailNotesTitle,
              style: tt.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _scriptNote(l, manifest.i18nNote!),
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.75),
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LabeledParagraph extends StatelessWidget {
  const _LabeledParagraph({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return RichText(
      text: TextSpan(
        style: tt.bodyMedium?.copyWith(
          color: cs.onSurface.withValues(alpha: 0.8),
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: body),
        ],
      ),
    );
  }
}

class _SectionHead extends StatelessWidget {
  const _SectionHead({required this.title, this.sub});

  final String title;
  final String? sub;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              title,
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          if (sub != null)
            Text(
              sub!,
              style: tt.labelMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
                fontFamily: 'monospace',
              ),
            ),
        ],
      ),
    );
  }
}

/// Black panel + cream mono code block with a Copy button at the top right.
class _CodePanel extends StatefulWidget {
  const _CodePanel({
    required this.source,
    required this.copyLabel,
    required this.copiedLabel,
  });

  final String source;
  final String copyLabel;
  final String copiedLabel;

  @override
  State<_CodePanel> createState() => _CodePanelState();
}

class _CodePanelState extends State<_CodePanel> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.source));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    const black = Color(0xFF0A0A0A);
    const cream = Color(0xFFF5F2EC);
    const mustard = Color(0xFFD4A017);
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: black,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.fromLTRB(13, 13, 13, 13),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SelectableText(
              widget.source,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11.5,
                color: cream,
                height: 1.55,
              ),
            ),
          ),
        ),
        Positioned(
          top: 7,
          right: 7,
          child: Material(
            color: _copied ? mustard : const Color(0xFF222222),
            borderRadius: BorderRadius.circular(7),
            child: InkWell(
              onTap: _copy,
              borderRadius: BorderRadius.circular(7),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  _copied ? widget.copiedLabel : widget.copyLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _copied ? black : cream,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// State-aware editing card. Mirrors the HTML mockup's `.editstate` rules:
///   original          → neutral border, "No edits yet" + Edit
///   modified          → mustard border, "Edited" + View + Reset
///   modifiedOutdated  → mustard border, "Library updated" + Compare + Reset
class _EditingCard extends StatelessWidget {
  const _EditingCard({
    required this.state,
    required this.onEdit,
    required this.onView,
    required this.onReset,
  });

  final ScriptState state;
  final VoidCallback onEdit;
  final VoidCallback onView;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    const mustard = Color(0xFFD4A017);

    final modified = state != ScriptState.original;
    final borderColor = modified ? mustard : cs.onSurface.withValues(alpha: 0.16);
    final iconBg =
        modified ? mustard : cs.onSurface.withValues(alpha: 0.04);
    final iconColor =
        modified ? const Color(0xFF0A0A0A) : cs.onSurface.withValues(alpha: 0.55);

    final (title, sub) = switch (state) {
      ScriptState.original => (
          l.skapiScriptDetailEditingNotYet,
          l.skapiScriptDetailEditingNotYetSub,
        ),
      ScriptState.modified => (
          l.skapiScriptDetailEditingModified,
          l.skapiScriptDetailEditingModifiedSub('-'),
        ),
      ScriptState.modifiedOutdated => (
          l.skapiScriptDetailEditingOutdated,
          l.skapiScriptDetailEditingOutdatedSub,
        ),
    };

    return SkNeuCard(
      borderRadius: 14,
      borderColor: modified ? borderColor : null,
      padding: const EdgeInsets.fromLTRB(13, 13, 13, 13),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: iconBg),
            alignment: Alignment.center,
            child: Icon(
              modified ? Icons.edit_note_rounded : Icons.edit_outlined,
              size: 18,
              color: iconColor,
            ),
          ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (modified) ...[
              OutlinedButton(
                onPressed: onView,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  state == ScriptState.modifiedOutdated
                      ? l.skapiScriptDetailButtonCompare
                      : l.skapiScriptDetailButtonView,
                ),
              ),
              const SizedBox(width: 6),
              OutlinedButton(
                onPressed: onReset,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(l.skapiScriptDetailButtonReset),
              ),
            ] else
              OutlinedButton(
                onPressed: onEdit,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(l.skapiScriptDetailButtonEdit),
              ),
          ],
        ),
    );
  }
}

/// Red-bordered warning panel: parameter values the user should review.
/// The panel carries its own heading (no SectionHead above it) so it does
/// not double-stack with the surrounding rhythm.
class _ParamWarn extends StatelessWidget {
  const _ParamWarn({required this.manifest});

  final ScriptManifest manifest;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    const red = Color(0xFFD32F2F);

    return SkNeuCard(
      borderRadius: 12,
      borderColor: red,
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: red, width: 1.2),
                ),
                child: const Text(
                  '!',
                    style: TextStyle(
                      color: red,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    l.skapiScriptDetailParamWarnTitle,
                    style: tt.labelLarge?.copyWith(
                      color: red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < manifest.params.length; i++) ...[
              if (i == 0)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: cs.onSurface.withValues(alpha: 0.08),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text(
                        manifest.params[i].name,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      _renderDefault(manifest.params[i].defaultValue),
                      style: tt.labelMedium?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.7),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: cs.onSurface.withValues(alpha: 0.08),
              ),
            ],
            const SizedBox(height: 9),
            Text(
              l.skapiScriptDetailParamWarnHint,
              style: tt.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.65),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
    );
  }

  String _renderDefault(Object? v) {
    if (v == null) return 'null';
    if (v is List) return v.join(', ');
    return v.toString();
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.onRun, required this.onBind});

  final VoidCallback onRun;
  final VoidCallback onBind;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const black = Color(0xFF0A0A0A);
    const cream = Color(0xFFF5F2EC);
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 46,
            child: FilledButton.icon(
              onPressed: onRun,
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              label: Text(
                l.skapiScriptDetailButtonRun,
                overflow: TextOverflow.ellipsis,
              ),
              style: FilledButton.styleFrom(
                backgroundColor: black,
                foregroundColor: cream,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 46,
            child: OutlinedButton(
              onPressed: onBind,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                l.skapiScriptDetailButtonBindAction,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailLoading extends StatelessWidget {
  const _DetailLoading();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SkNeuCard(
      borderRadius: 14,
      borderColor: cs.error.withValues(alpha: 0.6),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: cs.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.error,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// i18n key resolvers delegate to the centralised lookup so adding a new
// script means only adding a case there, not in every screen.

String _scriptTitle(AppLocalizations l, String key) =>
    resolveSkapiI18nKey(l, key);
String _summaryWhat(AppLocalizations l, String key) =>
    resolveSkapiI18nKey(l, key);
String _summaryHow(AppLocalizations l, String key) =>
    resolveSkapiI18nKey(l, key);
String _scriptNote(AppLocalizations l, String key) =>
    resolveSkapiI18nKey(l, key);
