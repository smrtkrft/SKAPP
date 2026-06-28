import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/colors.dart';
import '../../../l10n/app_localizations.dart';

/// Sağ-alt koyu stat kartı: bağlı / BF / LS sayıları.
/// laptop_s2.html `.s2-st`, mobil_d.html `.c-st` karşılığı.
class DevicesStatsCard extends StatelessWidget {
  const DevicesStatsCard({
    super.key,
    required this.paired,
    required this.bf,
    required this.ls,
    this.ms = 0,
    this.dk = 0,
  });

  final int paired;
  final int bf;
  final int ls;

  /// Paired mobile SKAPP peers ("MS" prefix). Renders an extra stat
  /// when non-zero; hidden at zero so the card doesn't grow for users
  /// who only own hardware devices.
  final int ms;

  /// Paired Desktop SKAPP peers (mobil sürümde). Renders an extra stat
  /// when non-zero; bağlı total'ına dahildir, alt stat ayrı bir kategori
  /// olarak görünür.
  final int dk;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Light tema: siyah kart + krem yazı (dashboard krem zeminle kontrast).
    // Dark tema: krem kart + siyah yazı (warm-black zeminle kontrast).
    final bg = isDark ? SkColors.cream : SkColors.black;
    final fg = isDark ? SkColors.black : SkColors.cream;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.40 : 0.20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Stat(value: paired, label: l.devicesStatPaired, fg: fg),
          _Sep(fg: fg),
          _Stat(value: bf, label: l.devicesStatBf, fg: fg),
          _Sep(fg: fg),
          _Stat(value: ls, label: l.devicesStatLs, fg: fg),
          if (dk > 0) ...[
            _Sep(fg: fg),
            _Stat(value: dk, label: l.devicesDesktopStatLabel, fg: fg),
          ],
          if (ms > 0) ...[
            _Sep(fg: fg),
            _Stat(value: ms, label: l.devicesStatMs, fg: fg),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.fg});
  final int value;
  final String label;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // Değer + etiketi tek okunabilir parça olarak birleştir ("5 paired").
      label: '$value $label',
      child: ExcludeSemantics(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.toString(),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: fg,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              color: fg.withValues(alpha: 0.55),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }
}

class _Sep extends StatelessWidget {
  const _Sep({required this.fg});
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 26,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: fg.withValues(alpha: 0.18),
    );
  }
}
