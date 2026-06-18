import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/colors.dart';
import '../../../l10n/app_localizations.dart';

/// Sol-alt legend kartı: çevrimiçi/çevrimdışı/pil-düşük cihaz sayıları.
/// Mustard pulse dot çevrimiçi sayısının yanında, kalan satırlar düz dot.
class DevicesLegend extends StatelessWidget {
  const DevicesLegend({
    super.key,
    required this.online,
    required this.offline,
    required this.lowBattery,
  });

  final int online;
  final int offline;
  final int lowBattery;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.85),
        border: Border.all(
          color: fg.withValues(alpha: 0.12),
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendRow(
            color: SkColors.attentionMustard,
            text: l.devicesLegendOnline(online),
            pulsing: online > 0,
            textColor: fg,
          ),
          const SizedBox(height: 4),
          _LegendRow(
            color: fg.withValues(alpha: 0.30),
            text: l.devicesLegendOffline(offline),
            textColor: fg,
          ),
          const SizedBox(height: 4),
          _LegendRow(
            color: SkColors.warnRed,
            text: l.devicesLegendLowBattery(lowBattery),
            textColor: fg,
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatefulWidget {
  const _LegendRow({
    required this.color,
    required this.text,
    required this.textColor,
    this.pulsing = false,
  });

  final Color color;
  final String text;
  final Color textColor;
  final bool pulsing;

  @override
  State<_LegendRow> createState() => _LegendRowState();
}

class _LegendRowState extends State<_LegendRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    if (widget.pulsing) _ctrl.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _LegendRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulsing && !_ctrl.isAnimating) {
      _ctrl.repeat(reverse: true);
    } else if (!widget.pulsing && _ctrl.isAnimating) {
      _ctrl.stop();
      _ctrl.value = 0;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, _) {
            final t = _ctrl.value;
            return Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
                boxShadow: widget.pulsing
                    ? [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.5 * (1 - t)),
                          blurRadius: 6 + 4 * t,
                          spreadRadius: 1 * t,
                        ),
                      ]
                    : null,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        Text(
          widget.text,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
            color: widget.textColor.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}
