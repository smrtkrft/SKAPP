import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/colors.dart';

// ============================================================================
// Tactile neumorphic primitifleri · V2 Well varyantı
// ============================================================================
// Flutter native `BoxShadow.blurStyle: BlurStyle.inner` CSS'in `inset`
// box-shadow'una denk gelmiyor — sadece hafif bir iç tint üretiyor, gerçek
// directional shadow yok. Bu yüzden inset shadow'u CustomPainter ile
// boyuyoruz: bir büyük dış dikdörtgenden iç (offset'li) rrect'i evenOdd
// fill rule ile çıkarıyor, sonucu blur'layıp orijinal rrect'e clip'liyoruz.
// Sonuç: kart sanırki yüzeye basılmış, içe doğru çökmüş görünüyor.
// ============================================================================

/// V2 Well kart primitifi: kartlar yükselmek yerine ÇUKURDA (inset).
/// Zemine gömülmüş bir yuva gibi; içine konan ikon (SkNeuIconSlot) ve
/// değer pelet'leri çukurun tabanından raised olur.
///
/// API SkCard ile aynıdır: child, onTap, padding, borderColor.
class SkNeuCard extends StatelessWidget {
  const SkNeuCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.borderColor,
    this.borderRadius = 18,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color? borderColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final radius = BorderRadius.circular(borderRadius);

    // İç gölge yoğunluğu yarıya indirildi (önce 0.18 / 0.95 → şimdi
    // 0.09 / 0.48). Çukur hâlâ okunur ama daha sakin, kart çerçevesi
    // gözü yormuyor.
    final darkColor = isDark
        ? Colors.black.withValues(alpha: 0.28)
        : Colors.black.withValues(alpha: 0.09);
    final lightColor = isDark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.white.withValues(alpha: 0.48);

    return CustomPaint(
      foregroundPainter: _NeuInsetShadowPainter(
        borderRadius: radius,
        darkColor: darkColor,
        lightColor: lightColor,
        // Çok ince + derin look: blur 3 ile gölge neredeyse keskin bir
        // bant; çukurun duvarları dik bıçak gibi düşer.
        offset: 4,
        blur: 3,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: radius,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1.5)
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            splashColor: SkColors.attentionMustard.withValues(alpha: 0.10),
            highlightColor: SkColors.attentionMustard.withValues(alpha: 0.05),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

/// CSS `box-shadow: inset` davranışını birebir taklit eden painter.
///
/// Algoritma:
///   1. Orijinal rrect'e clip yap (sadece kartın içini boya).
///   2. Büyük bir outer dikdörtgenden offset'lenmiş bir rrect çıkar
///      (evenOdd fill rule ile "delik içinde plane" şekli).
///   3. MaskFilter.blur ile bu şeklin kenarını yumuşat.
///   4. Dark shadow: inner rrect bottom-right'a offset → blur top-left
///      kenarda yumuşak koyu bant.
///   5. Light shadow: inner rrect top-left'e offset → blur bottom-right
///      kenarda yumuşak açık bant.
class _NeuInsetShadowPainter extends CustomPainter {
  const _NeuInsetShadowPainter({
    required this.borderRadius,
    required this.darkColor,
    required this.lightColor,
    required this.offset,
    required this.blur,
  });

  final BorderRadius borderRadius;
  final Color darkColor;
  final Color lightColor;
  final double offset;
  final double blur;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect);

    canvas.save();
    canvas.clipRRect(rrect);

    // Outer dikdörtgen: blur taşmasın diye kart boyutundan epey büyük.
    final outerExpand = math.max(size.width, size.height) * 2 + blur * 4;
    final outerRect = Rect.fromCenter(
      center: rect.center,
      width: outerExpand,
      height: outerExpand,
    );

    // Dark inset: top-left iç kenarda koyu shadow
    final darkPaint = Paint()
      ..color = darkColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
    final darkInner = rrect.shift(Offset(offset, offset));
    final darkPath = Path()
      ..addRect(outerRect)
      ..addRRect(darkInner)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(darkPath, darkPaint);

    // Light inset: bottom-right iç kenarda açık highlight
    final lightPaint = Paint()
      ..color = lightColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
    final lightInner = rrect.shift(Offset(-offset, -offset));
    final lightPath = Path()
      ..addRect(outerRect)
      ..addRRect(lightInner)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(lightPath, lightPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NeuInsetShadowPainter old) =>
      old.borderRadius != borderRadius ||
      old.darkColor != darkColor ||
      old.lightColor != lightColor ||
      old.offset != offset ||
      old.blur != blur;
}

/// Neumorphic ikon yuvası · SkNeuCard (well) içine konan RAISED soket.
///
/// Çukur kart'ın içinde dışarı çıkar (kabarık). Normal BoxShadow ile
/// yapılabilir — Flutter raised shadow'u native destekliyor.
///
/// Tone seçenekleri:
///   * neutral (default)
///   * mustard
///   * danger
class SkNeuIconSlot extends StatelessWidget {
  const SkNeuIconSlot({
    super.key,
    required this.icon,
    this.size = 44,
    this.iconSize = 22,
    this.iconColor,
    this.tone = SkNeuIconSlotTone.neutral,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final Color? iconColor;
  final SkNeuIconSlotTone tone;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;

    // Strong contrast raised shadows.
    final shDark = isDark
        ? Colors.black.withValues(alpha: 0.55)
        : Colors.black.withValues(alpha: 0.16);
    final shLight = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.90);

    final resolvedIconColor = iconColor ??
        switch (tone) {
          SkNeuIconSlotTone.mustard => SkColors.attentionMustard,
          SkNeuIconSlotTone.danger  => SkColors.warnRed,
          SkNeuIconSlotTone.neutral =>
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
        };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(size * 0.30),
        boxShadow: [
          // Top-left'ten ışık (highlight) — ince ve yoğun
          BoxShadow(
            color: shLight,
            offset: const Offset(-2, -2),
            blurRadius: 3,
            spreadRadius: 0,
          ),
          // Bottom-right'tan gölge (drop)
          BoxShadow(
            color: shDark,
            offset: const Offset(2, 2),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: resolvedIconColor),
    );
  }
}

enum SkNeuIconSlotTone { neutral, mustard, danger }

/// Neumorphic switch · V2 varyantı.
///
///   * Track: RAISED (dışarı çıkmış raylı yüzey) → normal BoxShadow
///   * Thumb: INSET (track'in içine basılı) → CustomPainter ile inset
///   * Açıkken thumb hardal sarısına döner (yine inset).
class SkNeuSwitch extends StatelessWidget {
  const SkNeuSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;

  /// null verilirse switch disabled (gri thumb + tap no-op).
  final ValueChanged<bool>? onChanged;

  static const double _width = 50;
  static const double _height = 28;
  static const double _thumbSize = 22;
  static const double _padding = 3;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;

    final shDark = isDark
        ? Colors.black.withValues(alpha: 0.55)
        : Colors.black.withValues(alpha: 0.18);
    final shLight = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.90);

    // Açıkken siyah (light) / cream (dark) thumb; pasifken gri.
    // Hardal sarısı kasıtlı kullanılmıyor; toggle nötr göstergeci olarak
    // marka rengini öne çıkarmaz, sadece on/off state'i nötr ifade eder.
    // Disabled (onChanged null): hep gri, tap no-op.
    final disabled = onChanged == null;
    final thumbColor = disabled
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.18)
        : value
            ? (isDark ? SkColors.darkFg : SkColors.black)
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35);

    return Semantics(
      toggled: value,
      child: GestureDetector(
        onTap: disabled ? null : () => onChanged!(!value),
        child: Container(
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(_height / 2),
            boxShadow: [
              // V2 track: RAISED (kabarık), iyice ince
              BoxShadow(
                color: shLight,
                offset: const Offset(-1, -1),
                blurRadius: 2,
              ),
              BoxShadow(
                color: shDark,
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(_padding),
              child: SizedBox(
                width: _thumbSize,
                height: _thumbSize,
                child: CustomPaint(
                  foregroundPainter: _NeuInsetShadowPainter(
                    borderRadius:
                        BorderRadius.circular(_thumbSize / 2),
                    darkColor: shDark,
                    lightColor: shLight,
                    offset: 1.5,
                    blur: 1.5,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: thumbColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
