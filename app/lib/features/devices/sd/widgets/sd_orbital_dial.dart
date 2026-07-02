// SynDimm orbital kadranı · design2.html'in dairesel çukur kadranının
// Flutter karşılığı.
//
// Görsel: dairesel neumorfik çukur (SkNeuCard, borderRadius = çap/2)
// içinde 24 detent çentiği + 270°'lik hardal değer yayı + ortada raised
// pelet disk (büyük ince değer rakamı + slot adı).
//
// Etkileşim: diskte/çukurda dairesel sürükleme değeri değiştirir
// (fiziksel enkoderin uygulamadaki karşılığı — `mode.value` yolu),
// tek dokunuş aç/kapa (dimmer) veya STOP (shutter) gönderir. Gönderim
// temposunu ekran değil ÇAĞIRAN sınırlar (dashboard 120 ms trailing
// throttle uygular); bu widget yalnız jesti değere çevirir.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/ui/sk_neu_card.dart';

/// 270°'lik gauge bandı: 135°'den (sol-alt) saat yönünde 405°'ye.
const double _kStartAngle = 3 * math.pi / 4;
const double _kSweepMax = 3 * math.pi / 2;

class SdOrbitalDial extends StatefulWidget {
  const SdOrbitalDial({
    super.key,
    required this.value,
    required this.state,
    required this.label,
    required this.interactive,
    required this.onValue,
    required this.onTap,
  });

  /// 0..100, cihazın son bilinen değeri (olaylarla canlı).
  final int value;

  /// Davranışın açık/kapalı durumu; kapalıyken rakam soluklaşır.
  final bool state;

  /// Disk altındaki etiket (slot adı ya da "Boş").
  final String label;

  /// false → jestler kapalı, yay soluk (boş slot / recovery / hata).
  final bool interactive;

  /// Sürükleme sırasında her değer değişiminde çağrılır (0..100 clamp'li).
  final ValueChanged<int> onValue;

  /// Disk dokunuşu (dimmer: aç/kapa · shutter: STOP).
  final VoidCallback onTap;

  @override
  State<SdOrbitalDial> createState() => _SdOrbitalDialState();
}

class _SdOrbitalDialState extends State<SdOrbitalDial> {
  // Sürükleme: son açı + kesirli değer birikimi (detent hissi için
  // tam sayıya yuvarlanan kısım gönderilir, kalan birikir).
  double? _lastAngle;
  double _accum = 0;

  double _angleAt(Offset local, double size) {
    final c = size / 2;
    return math.atan2(local.dy - c, local.dx - c);
  }

  void _onPanStart(DragStartDetails d, double size) {
    _lastAngle = _angleAt(d.localPosition, size);
    _accum = 0;
  }

  void _onPanUpdate(DragUpdateDetails d, double size) {
    final last = _lastAngle;
    if (last == null) return;
    final now = _angleAt(d.localPosition, size);
    var delta = now - last;
    // -π..π bandına sar (0/2π geçişinde zıplama olmasın).
    while (delta > math.pi) {
      delta -= 2 * math.pi;
    }
    while (delta < -math.pi) {
      delta += 2 * math.pi;
    }
    _lastAngle = now;
    // 270° tam tur = 100 birim.
    _accum += delta / _kSweepMax * 100;
    final step = _accum.truncate();
    if (step != 0) {
      _accum -= step;
      final next = (widget.value + step).clamp(0, 100);
      if (next != widget.value) widget.onValue(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, 340.0);
        final discSize = size * 0.62;
        final arcColor = SkColors.attentionMustard.withValues(
          alpha: widget.interactive ? (isDark ? 0.75 : 0.65) : 0.20,
        );
        return Center(
          child: SkNeuCard(
            padding: EdgeInsets.zero,
            borderRadius: size / 2,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart:
                  widget.interactive ? (d) => _onPanStart(d, size) : null,
              onPanUpdate:
                  widget.interactive ? (d) => _onPanUpdate(d, size) : null,
              onPanEnd: widget.interactive ? (_) => _lastAngle = null : null,
              onTap: widget.interactive ? widget.onTap : null,
              child: SizedBox(
                width: size,
                height: size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size.square(size),
                      painter: _DialPainter(
                        fraction: widget.value / 100,
                        arcColor: arcColor,
                        tickColor: cs.outlineVariant,
                        trackColor: cs.onSurface.withValues(
                          alpha: isDark ? 0.08 : 0.07,
                        ),
                      ),
                    ),
                    // Merkez raised disk (pelet) — SkNeuIconSlot gölge
                    // deyimiyle aynı raised görünüm, sadece daire.
                    _RaisedDisc(
                      size: discSize,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${widget.value}',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  fontSize: discSize * 0.38,
                                  fontWeight: FontWeight.w200,
                                  height: 1,
                                  color: widget.state && widget.interactive
                                      ? cs.onSurface
                                      : cs.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 2,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Çukur içinden yükselen dairesel pelet (raised) — merkez disk ve safe
/// çarkının paylaştığı görünüm.
class _RaisedDisc extends StatelessWidget {
  const _RaisedDisc({required this.size, required this.child});
  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final shDark = isDark
        ? Colors.black.withValues(alpha: 0.55)
        : Colors.black.withValues(alpha: 0.16);
    final shLight = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.90);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: shLight, offset: const Offset(-3, -3), blurRadius: 7),
          BoxShadow(color: shDark, offset: const Offset(4, 4), blurRadius: 8),
        ],
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

/// Detent çentikleri + değer yayı. `LsCountdownRing`'in `_RingPainter`
/// fork'u: tam daire yerine 270° gauge bandı + 24 çentik.
class _DialPainter extends CustomPainter {
  const _DialPainter({
    required this.fraction,
    required this.arcColor,
    required this.tickColor,
    required this.trackColor,
  });

  final double fraction;
  final Color arcColor;
  final Color tickColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final shortest = math.min(size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);
    final stroke = shortest * 0.028;
    final arcRadius = shortest / 2 - stroke * 2.2;
    final rect = Rect.fromCircle(center: center, radius: arcRadius);

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawArc(rect, _kStartAngle, _kSweepMax, false, trackPaint);

    final clamped = fraction.isFinite ? fraction.clamp(0.0, 1.0) : 0.0;
    if (clamped > 0) {
      final arcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = arcColor;
      canvas.drawArc(rect, _kStartAngle, _kSweepMax * clamped, false, arcPaint);
    }

    // 24 detent çentiği, yay bandının hemen içinde.
    final tickPaint = Paint()
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..color = tickColor;
    const ticks = 24;
    final r1 = arcRadius - stroke * 2.6;
    final r2 = arcRadius - stroke * 1.4;
    for (var i = 0; i <= ticks; i++) {
      final a = _kStartAngle + _kSweepMax * (i / ticks);
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(center + dir * r1, center + dir * r2, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DialPainter old) =>
      old.fraction != fraction ||
      old.arcColor != arcColor ||
      old.tickColor != tickColor ||
      old.trackColor != trackColor;
}
