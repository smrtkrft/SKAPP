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
import 'widgets/skapi_tier_badge.dart';
import 'skapi_script_detail_screen.dart';
import 'widgets/skapi_platform_icon.dart';

/// Group detail screen (Adım 3 in the SKAPI WIN flow).
///
/// Renders the group description directly under the app bar (no accordion,
/// per the design rule), then a single bordered list of script rows. Each
/// row is bare: title, scriptId, favourite star, chevron. No icons.
///
/// Tapping a row opens the script detail (Adım 4); since that route is
/// built in Faz E, we surface a transient notice for now.
class SkapiGroupScreen extends ConsumerWidget {
  const SkapiGroupScreen({
    super.key,
    required this.platform,
    required this.group,
  });

  final SkapiPlatformSpec platform;
  final GroupManifest group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final scriptsAsync = ref.watch(skapiGroupScriptsProvider(
      (platform: platform.id, group: group.id),
    ));

    final groupTitle = _groupTitle(l, group.i18nTitle);

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        title: Row(
          children: [
            SkapiPlatformIcon(platform: platform),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                groupTitle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 100),
        children: [
          SkContent(
            horizontalPadding: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _GroupDescription(group: group),
                const SizedBox(height: 18),
                scriptsAsync.when(
                  loading: () => const _ScriptsLoading(),
                  error: (e, st) => _ScriptsError(
                    message: l.skapiGroupScriptsLoadError(e.toString()),
                  ),
                  data: (scripts) => _ScriptsSection(
                    scripts: scripts,
                    onTap: (s) => _onScriptTap(context, s),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Pushes the script detail screen (Adım 4). The detail screen reads
  /// the resolved (override-aware) source through [resolvedScriptProvider]
  /// and renders the Original/Editing/Parameters layout.
  void _onScriptTap(BuildContext context, ScriptManifest script) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SkapiScriptDetailScreen(manifest: script),
      ),
    );
  }
}

/// Group description block (Adım 3 mockup): two paragraphs, no heading,
/// rendered directly under the app bar. The footer is italic and
/// optional. Matches the HTML mockup's `.groupdesc` class.
class _GroupDescription extends StatelessWidget {
  const _GroupDescription({required this.group});

  final GroupManifest group;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final desc = _groupDesc(l, group.i18nDesc);
    final foot = group.i18nFoot == null ? null : _groupFoot(l, group.i18nFoot!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            desc,
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          if (foot != null) ...[
            const SizedBox(height: 10),
            Text(
              foot,
              style: tt.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.65),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// "Scripts" section header + the single bordered container holding rows.
class _ScriptsSection extends StatelessWidget {
  const _ScriptsSection({required this.scripts, required this.onTap});

  final List<ScriptManifest> scripts;
  final void Function(ScriptManifest) onTap;

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
                  l.skapiGroupScriptsHeader,
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                l.skapiGroupScriptsCount(scripts.length),
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
              for (int i = 0; i < scripts.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: cs.onSurface.withValues(alpha: 0.08),
                  ),
                _ScriptRow(
                  script: scripts[i],
                  onTap: () => onTap(scripts[i]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Single script row: title (translated), scriptId (raw, English), star
/// favourite, chevron. The star toggles via [favouriteScriptsProvider];
/// in Faz 1 that state is in-memory only.
class _ScriptRow extends ConsumerWidget {
  const _ScriptRow({required this.script, required this.onTap});

  final ScriptManifest script;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    ref.watch(favouriteScriptsProvider);
    final isFav = ref
        .read(favouriteScriptsProvider.notifier)
        .isFavourite(script.platform, script.id);
    final title = _scriptTitle(l, script.i18nTitle);
    final mustard = const Color(0xFFD4A017);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: tt.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (script.tier > 1) ...[
                        const SizedBox(width: 8),
                        SkapiTierBadge(tier: script.tier),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    script.id,
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.55),
                      fontFamily: 'monospace',
                      fontFeatures: const [],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: isFav
                  ? l.skapiFavouriteRemoveTooltip
                  : l.skapiFavouriteAddTooltip,
              icon: Icon(
                isFav ? Icons.star_rounded : Icons.star_border_rounded,
                color: isFav ? mustard : cs.onSurface.withValues(alpha: 0.4),
              ),
              onPressed: () => ref
                  .read(favouriteScriptsProvider.notifier)
                  .toggle(script.platform, script.id),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _ScriptsLoading extends StatelessWidget {
  const _ScriptsLoading();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
}

class _ScriptsError extends StatelessWidget {
  const _ScriptsError({required this.message});

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

// All i18n key resolvers delegate to the centralised lookup so adding a
// new script means only adding a case there.
String _scriptTitle(AppLocalizations l, String key) =>
    resolveSkapiI18nKey(l, key);
String _groupTitle(AppLocalizations l, String key) =>
    resolveSkapiI18nKey(l, key);
String _groupDesc(AppLocalizations l, String key) =>
    resolveSkapiI18nKey(l, key);
String _groupFoot(AppLocalizations l, String key) =>
    resolveSkapiI18nKey(l, key);
