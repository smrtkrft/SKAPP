import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import 'data/script_manifest.dart';
import 'data/skapi_catalog.dart';
import 'data/skapi_i18n_lookup.dart';
import 'data/skapi_providers.dart';
import 'skapi_api_template_detail_screen.dart';
import 'skapi_group_screen.dart';
import 'widgets/skapi_platform_icon.dart';

/// Platform detail screen pushed when a SKAPI platform card is tapped.
///
/// Renders the Adım 2 mockup: a disabled search bar, a "How it works"
/// accordion (collapsed by default), and a single-container bare-row list
/// of action groups. Group rows tap into the group screen (Adım 3); that
/// route is built in Faz D, so for now tapping shows a transient hint.
class SkapiPlatformScreen extends ConsumerWidget {
  const SkapiPlatformScreen({super.key, required this.platform});

  final SkapiPlatformSpec platform;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final platformLabel = _platformLabel(l, platform.id);
    final isApiTemplatePlatform = platform.id.startsWith('other-');

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        title: Row(
          children: [
            SkapiPlatformIcon(platform: platform),
            const SizedBox(width: 10),
            Text(platformLabel),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 100),
        children: [
          SkContent(
            horizontalPadding: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DisabledSearchBar(
                  placeholder: l.skapiSearchPlaceholder,
                  disabledHint: l.skapiSearchDisabledHint,
                ),
                const SizedBox(height: 14),
                _HowItWorksAccordion(),
                const SizedBox(height: 18),
                if (isApiTemplatePlatform)
                  _ApiTemplateBody(platform: platform)
                else
                  _ScriptGroupBody(platform: platform),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

/// Script-group body — Win/Mac/Lx Yapı 1 mantığı. Reads
/// [skapiPlatformGroupsProvider] + [skapiPlatformScriptCountProvider] and
/// renders the original `_GroupSection`. Untouched from the pre-Madde-24
/// behaviour; only relocated into its own widget so the platform screen
/// can dispatch between script vs api-template content.
class _ScriptGroupBody extends ConsumerWidget {
  const _ScriptGroupBody({required this.platform});
  final SkapiPlatformSpec platform;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final groupsAsync = ref.watch(skapiPlatformGroupsProvider(platform.id));
    final scriptCountAsync =
        ref.watch(skapiPlatformScriptCountProvider(platform.id));

    return groupsAsync.when(
      loading: () => const _GroupListLoading(),
      error: (e, st) => _GroupListError(
        message: l.skapiPlatformGroupsLoadError(e.toString()),
      ),
      data: (groups) {
        if (groups.isEmpty) {
          return _PlatformEmpty(
            title: l.skapiPlatformEmptyTitle,
            body: l.skapiPlatformEmptyBody,
          );
        }
        final groupCount = groups.length;
        final scriptCount = scriptCountAsync.maybeWhen(
          data: (n) => n,
          orElse: () =>
              groups.fold<int>(0, (sum, g) => sum + g.scriptIds.length),
        );
        return _GroupSection(
          groups: groups,
          groupCount: groupCount,
          scriptCount: scriptCount,
          onTap: (group) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  SkapiGroupScreen(platform: platform, group: group),
            ),
          ),
        );
      },
    );
  }
}

/// API-template body for `other-*` platforms (Yapı 2). Reads
/// [skapiPlatformApiTemplatesProvider] and renders a bordered list of
/// templates. Tapping a template pushes
/// [SkapiApiTemplateDetailScreen] which surfaces the "Cihaza yükle" CTA.
/// Empty list during S2.1 skeleton stage is rendered as a friendly
/// "templates coming soon" message — same look as the script-empty case.
class _ApiTemplateBody extends ConsumerWidget {
  const _ApiTemplateBody({required this.platform});
  final SkapiPlatformSpec platform;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final templatesAsync =
        ref.watch(skapiPlatformApiTemplatesProvider(platform.id));

    return templatesAsync.when(
      loading: () => const _GroupListLoading(),
      error: (e, _) => _GroupListError(
        message: l.skapiPlatformGroupsLoadError(e.toString()),
      ),
      data: (templates) {
        if (templates.isEmpty) {
          return _PlatformEmpty(
            title: l.skapiPlatformEmptyTitle,
            body: l.skapiCategoryComingSoon,
          );
        }
        return _ApiTemplateSection(templates: templates);
      },
    );
  }
}

class _ApiTemplateSection extends StatelessWidget {
  const _ApiTemplateSection({required this.templates});
  final List<ApiTemplateManifest> templates;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  l.skapiApiTemplateSectionHeader,
                  style:
                      tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                l.skapiApiTemplateSectionCount(templates.length),
                style: tt.labelMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
        SkNeuCard(
          padding: EdgeInsets.zero,
          borderRadius: 14,
          child: Column(
            children: [
              for (int i = 0; i < templates.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: cs.onSurface.withValues(alpha: 0.08),
                  ),
                _ApiTemplateRow(template: templates[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ApiTemplateRow extends StatelessWidget {
  const _ApiTemplateRow({required this.template});
  final ApiTemplateManifest template;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final title = resolveSkapiI18nKey(l, template.i18nTitle);
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SkapiApiTemplateDetailScreen(manifest: template),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style:
                        tt.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${template.method.toUpperCase()} · ${template.urlTemplate}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.55),
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded,
                color: cs.onSurface.withValues(alpha: 0.4)),
          ],
        ),
      ),
    );
  }
}

/// Section header + the single bordered container that holds every group
/// row. Hairline divider between rows; no card-in-card.
class _GroupSection extends StatelessWidget {
  const _GroupSection({
    required this.groups,
    required this.groupCount,
    required this.scriptCount,
    required this.onTap,
  });

  final List<GroupManifest> groups;
  final int groupCount;
  final int scriptCount;
  final void Function(GroupManifest group) onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  l.skapiPlatformGroupsHeader,
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                l.skapiPlatformScreenCategoriesSub(groupCount, scriptCount),
                style: tt.labelMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
        SkNeuCard(
          padding: EdgeInsets.zero,
          borderRadius: 14,
          child: Column(
            children: [
              for (int i = 0; i < groups.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: cs.onSurface.withValues(alpha: 0.08),
                  ),
                _GroupRow(group: groups[i], onTap: () => onTap(groups[i])),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// One group row: i18n title + script count + chevron. No icon, per the
/// "ikonsuz catindex" decision.
class _GroupRow extends StatelessWidget {
  const _GroupRow({required this.group, required this.onTap});

  final GroupManifest group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final title = _groupTitle(l, group.i18nTitle);
    final count = group.scriptIds.length;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              l.skapiGroupItemCount(count),
              style: tt.labelMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty-state card for platforms whose `_platform.json` ships with no
/// groups yet (mac/lx/other in Faz 1). Honest "coming later" messaging,
/// no fake list rows, no silent no-op.
class _PlatformEmpty extends StatelessWidget {
  const _PlatformEmpty({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return SkNeuCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      child: Row(
        children: [
            Icon(
              Icons.hourglass_empty_rounded,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: tt.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

class _GroupListLoading extends StatelessWidget {
  const _GroupListLoading();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
}

class _GroupListError extends StatelessWidget {
  const _GroupListError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SkNeuCard(
      borderRadius: 14,
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

/// Collapsible "Nasıl Çalışır?" explainer at the top of the screen.
/// Default state is collapsed; when the user taps the header it expands
/// to show the prose body, the 2-node flow diagram, and the privacy foot.
///
/// Mirrors the HTML mockup's `.hiw` block. The diagram is intentionally
/// 2 nodes (device → computer); when more parties join the picture (cloud
/// relay, multi-device fan-out) we extend `_HiwFlow` with extra nodes
/// rather than adding another card.
class _HowItWorksAccordion extends StatefulWidget {
  @override
  State<_HowItWorksAccordion> createState() => _HowItWorksAccordionState();
}

class _HowItWorksAccordionState extends State<_HowItWorksAccordion> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return SkNeuCard(
      padding: EdgeInsets.zero,
      borderRadius: 14,
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l.skapiHowItWorksTitle,
                      style: tt.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.25 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _open ? _HiwBody() : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _HiwBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final exampleDevice = 'Blocking Focus';
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(
            height: 1,
            thickness: 1,
            color: cs.onSurface.withValues(alpha: 0.08),
          ),
          const SizedBox(height: 12),
          Text(
            l.skapiHowItWorksBody(exampleDevice),
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          _HiwFlow(),
          const SizedBox(height: 10),
          Text(
            l.skapiHowItWorksFoot,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.65),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _HiwFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        child: Row(
          children: [
            Expanded(
              child: _HiwNode(
                num: '1',
                label: l.skapiHowItWorksFlowDeviceLabel,
                sub: l.skapiHowItWorksFlowDeviceSub,
              ),
            ),
            _HiwDashedLine(),
            Expanded(
              child: _HiwNode(
                num: '2',
                label: l.skapiHowItWorksFlowComputerLabel,
                sub: l.skapiHowItWorksFlowComputerSub,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HiwNode extends StatelessWidget {
  const _HiwNode({required this.num, required this.label, required this.sub});

  final String num;
  final String label;
  final String sub;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cs.surface,
            border: Border.all(color: cs.onSurface.withValues(alpha: 0.4)),
          ),
          alignment: Alignment.center,
          child: Text(
            num,
            style: tt.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: tt.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          sub,
          textAlign: TextAlign.center,
          style: tt.labelSmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}

class _HiwDashedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 32,
      height: 1,
      child: CustomPaint(
        painter: _DashedHorizontalLinePainter(
          color: cs.onSurface.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _DashedHorizontalLinePainter extends CustomPainter {
  _DashedHorizontalLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 4.0;
    const gap = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedHorizontalLinePainter old) =>
      old.color != color;
}

/// Search bar shown at the top of the platform detail screen.
///
/// Phase 1: deliberately disabled. The control still has an obvious search
/// affordance (icon + placeholder) but the disabled hint underneath says
/// "will activate once the SKAPI parser is wired", so the user knows it's
/// a planned feature, not a broken one. No silent no-op tap.
class _DisabledSearchBar extends StatelessWidget {
  const _DisabledSearchBar({
    required this.placeholder,
    required this.disabledHint,
  });

  final String placeholder;
  final String disabledHint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Tooltip(
      message: disabledHint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cs.onSurface.withValues(alpha: 0.16)),
              color: cs.onSurface.withValues(alpha: 0.03),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    placeholder,
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.4),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: cs.onSurface.withValues(alpha: 0.35),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
            child: Text(
              disabledHint,
              style: tt.labelSmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.55),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _platformLabel(AppLocalizations l, String id) {
  switch (id) {
    case 'mac':
      return l.skapiPlatformMac;
    case 'win':
      return l.skapiPlatformWin;
    case 'lx':
      return l.skapiPlatformLinux;
    case 'other':
      return l.skapiPlatformOther;
  }
  return id;
}

// Delegates to the centralised lookup so adding a new group means only
// adding a case in `data/skapi_i18n_lookup.dart`.
String _groupTitle(AppLocalizations l, String key) =>
    resolveSkapiI18nKey(l, key);
