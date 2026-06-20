import 'package:flutter/material.dart';

import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../core/ui/sk_yakinda_badge.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import 'data/skapi_catalog.dart';
import 'skapi_platform_screen.dart';

/// Pushed when the SKAPI "Other" card is tapped. "Other" fragments at the
/// next level into 5 device categories: SynDimm, LebensSpur, Blocking Focus
/// (SmartKraft brands) + IoT, Server (generic). Templates inside these
/// folders are `ApiTemplateManifest` prefills the user uploads onto a
/// paired device — the device fires them on its own trigger, SKAPP is
/// not involved at fire time. Architecture detail: `yapilacaklar.md`
/// Madde 24.
///
/// The folders are empty for now (S2.1 skeleton). Tapping a card still
/// pushes [SkapiPlatformScreen], which renders the platform's empty
/// state. Once Madde 24 progresses, real templates fill the `groups`
/// arrays.
class SkapiOtherCategoryScreen extends StatelessWidget {
  const SkapiOtherCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(title: Text(l.skapiPlatformOther)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 100),
        children: [
          SkContent(
            horizontalPadding: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Heading(
                  title: l.skapiOtherCategoryHeading,
                  subtitle: l.skapiOtherCategorySubtitle,
                ),
                const SizedBox(height: 14),
                for (final cat in kSkapiOtherCategories) ...[
                  _CategoryCard(category: cat),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: tt.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});
  final SkapiPlatformSpec category;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return SkNeuCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SkapiPlatformScreen(platform: category),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(
            category.icon,
            size: 22,
            color: cs.onSurface,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.label,
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  _sub(l, category.id),
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SkYakindaBadge(label: l.skapiCategoryComingSoon),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right_rounded,
            color: cs.onSurface.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }

  String _sub(AppLocalizations l, String id) {
    switch (id) {
      case 'other-syndimm':
        return l.skapiOtherSyndimmSub;
      case 'other-lebensspur':
        return l.skapiOtherLebensspurSub;
      case 'other-blockingfocus':
        return l.skapiOtherBlockingfocusSub;
      case 'other-iot':
        return l.skapiOtherIotSub;
      case 'other-server':
        return l.skapiOtherServerSub;
    }
    return '';
  }
}
