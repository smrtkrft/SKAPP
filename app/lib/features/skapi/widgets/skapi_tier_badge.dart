import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Tier rozeti shown next to a script title when the manifest's
/// `tier > 1`. Tier 2 = "Experimental" (mustard, runnable but flaky on
/// some machines). Tier 3 = "Coming soon" (cream, not implemented yet,
/// the run sheet should refuse to start the process).
///
/// Tier 1 has no badge: it's the default, well-tested case.
class SkapiTierBadge extends StatelessWidget {
  const SkapiTierBadge({super.key, required this.tier});

  final int tier;

  @override
  Widget build(BuildContext context) {
    if (tier <= 1) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    const mustard = Color(0xFFD4A017);

    final isExperimental = tier == 2;
    final label = isExperimental
        ? l.skapiTierBadgeExperimental
        : l.skapiTierBadgeBlocked;
    final tooltip = isExperimental
        ? l.skapiTierBadgeExperimentalTooltip
        : l.skapiTierBadgeBlockedTooltip;
    final bg = isExperimental
        ? mustard
        : cs.onSurface.withValues(alpha: 0.08);
    final fg = isExperimental
        ? const Color(0xFF0A0A0A)
        : cs.onSurface.withValues(alpha: 0.7);

    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
      ),
    );
  }
}
