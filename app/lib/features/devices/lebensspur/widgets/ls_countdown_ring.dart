// LebensSpur hero countdown ring · CustomPainter port of ls_gui_design2.html.
//
// The HTML reference paints two concentric SVG circles (track + progress)
// at r=46 inside a 100-unit viewBox, with stroke-width 4 and round line
// caps. The arc is rotated -90° so progress sweeps clockwise from 12
// o'clock. We mirror that here directly with Canvas.drawArc; no external
// chart libs.
//
// Stroke colors track the SkColors palette: hairline-grade track + a
// translucent mustard accent that subtly intensifies as the deadline
// approaches. Digits + state label live OUTSIDE this widget (the parent
// composes them in a Stack above the ring), so this file is purely the
// painted ring container.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

/// Visual ring for the LebensSpur hero countdown.
///
/// [fraction] is `remaining / total`, clamped to 0..1. When 0 the
/// progress arc disappears (clean track only); when 1 the arc completes
/// the full circle. The HTML version animates `stroke-dashoffset` over
/// 600ms; we run an implicit `TweenAnimationBuilder<double>` with the
/// same duration so digit-by-digit ticks feel smooth.
class LsCountdownRing extends StatelessWidget {
  const LsCountdownRing({
    super.key,
    required this.fraction,
    this.size = 260,
    this.accentDashed = false,
  });

  /// Remaining over total, 0..1.
  final double fraction;

  /// Outer diameter of the ring; the painted stroke sits a few pixels
  /// inside this box so dual neumorphic shadows still have room to
  /// breathe when the ring is dropped into a well container.
  final double size;

  /// Dashed accent stroke variant. The HTML used a solid arc for both
  /// `Running` and `Triggered` states; we expose this flag so the parent
  /// can opt into a dashed look on `triggered` without forking the
  /// painter. Default solid mirrors the original.
  final bool accentDashed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final track = isDark
        ? SkColors.darkFg.withValues(alpha: 0.08)
        : SkColors.black.withValues(alpha: 0.07);
    final accent = SkColors.attentionMustard.withValues(
      alpha: isDark ? 0.65 : 0.55,
    );

    final clamped = fraction.isFinite ? fraction.clamp(0.0, 1.0) : 0.0;

    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: clamped, end: clamped),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
          return CustomPaint(
            painter: _RingPainter(
              fraction: value,
              trackColor: track,
              accentColor: accent,
              dashed: accentDashed,
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.fraction,
    required this.trackColor,
    required this.accentColor,
    required this.dashed,
  });

  final double fraction;
  final Color trackColor;
  final Color accentColor;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    final shortest = math.min(size.width, size.height);
    // HTML: viewBox 100, r=46 → 8% inset from outer edge.
    final stroke = shortest * 0.04;
    final radius = (shortest / 2) - stroke * 1.5;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = trackColor;

    canvas.drawCircle(center, radius, trackPaint);

    if (fraction <= 0) return;

    final accentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = accentColor;

    final sweep = 2 * math.pi * fraction.clamp(0.0, 1.0);
    const start = -math.pi / 2; // 12 o'clock

    if (!dashed) {
      canvas.drawArc(rect, start, sweep, false, accentPaint);
      return;
    }

    // Dashed: split sweep into ~16 segments per full circle so the
    // pattern visibility stays roughly constant regardless of size.
    const segments = 16;
    final segArc = (2 * math.pi) / segments;
    final visibleSegs = (fraction.clamp(0.0, 1.0) * segments).ceil();
    for (var i = 0; i < visibleSegs; i++) {
      final segStart = start + segArc * i;
      // last segment may be shorter to honor exact remaining sweep
      final segEnd =
          math.min(segStart + segArc * 0.55, start + sweep);
      if (segEnd <= segStart) break;
      canvas.drawArc(rect, segStart, segEnd - segStart, false, accentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.fraction != fraction ||
      old.trackColor != trackColor ||
      old.accentColor != accentColor ||
      old.dashed != dashed;
}
