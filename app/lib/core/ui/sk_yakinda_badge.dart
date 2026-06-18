import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../l10n/app_localizations.dart';
import '../theme/colors.dart';

/// Small mustard pill rendered top-right of a card to indicate the
/// underlying feature is designed but not yet wired. Tap behavior is
/// owned by the parent (typically a snackbar saying "coming soon"); this
/// widget is purely decorative and `pointer-events: none` in spirit.
///
/// Visual contract matches the HTML mockups (`laptop_s6.html` `.yk`,
/// `mobil_d.html` `.yk`): mustard background tint, mustard border, mono
/// uppercase label with letter-spacing.
class SkYakindaBadge extends StatelessWidget {
  const SkYakindaBadge({super.key, this.label});

  /// Override label. When null, falls back to the localized
  /// `skYakindaBadgeDefault` ("coming soon" / "yakında").
  final String? label;

  @override
  Widget build(BuildContext context) {
    final text = label ?? AppLocalizations.of(context).skYakindaBadgeDefault;
    return IgnorePointer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1.5),
        decoration: BoxDecoration(
          color: SkColors.attentionMustard.withValues(alpha: 0.18),
          border: Border.all(
            color: SkColors.attentionMustard.withValues(alpha: 0.45),
          ),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 8.5,
            fontWeight: FontWeight.w700,
            color: SkColors.attentionMustard,
            letterSpacing: 0.6,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
