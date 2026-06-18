import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/colors.dart';
import '../main_shell/main_shell.dart';

/// Açılış ekranı, "origami unfold" animasyonu (S0.html · 04 · final).
///
/// Sıralı sahneleme (toplam ~2.0 sn):
///   * Logo: 3D X-ekseni rotateX(-100° → 0°) + scale(0.6 → 1.04 → 1)
///     900 ms cubic ease-out, 100 ms gecikme — kâğıt katlamadan
///     açılan bir orijami hissi.
///   * SKAPP: harf harf -30 px translateY + opacity fade, 100 ms
///     stagger ile 700 ms'den itibaren düşer; her harf 500 ms.
///   * SmartKraft: rotate(-12° → -2°) + scale(0.6 → 1) + fade,
///     1300 ms'de kıvrılarak yerine oturur.
///
/// Tema-duyarlı: light'ta krem zemin + siyah `logo_black.png`, dark'ta
/// SkColors.black zemin + krem yazı + `logo_white.png`. SmartKraft her
/// iki temada hardal sarısı (palet kuralı: krem/siyah/beyaz/uyarı/dikkat).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  // Animasyon penceresi: 2200 ms toplam, son ~200 ms'i SmartKraft fold-in
  // bitişinin nefes payı, sonra MainShell'e geçilir.
  static const Duration _total = Duration(milliseconds: 2200);
  static const Duration _navDelay = Duration(milliseconds: 2100);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: _total)..forward();
    Future.delayed(_navDelay, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// Belirli bir aralıktaki normalize edilmiş ilerlemeyi `Curve` ile
  /// dönüştürür. `start..end` 0-1 arasıdır.
  double _seg(double start, double end, Curve curve) {
    final t = ((_ctrl.value - start) / (end - start)).clamp(0.0, 1.0);
    return curve.transform(t);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoAsset = isDark
        ? 'assets/branding/logo_white.png'
        : 'assets/branding/logo_black.png';
    // Splash → MainShell geçişinde renk sıçramasını önlemek için app
    // tema tokenlarıyla bire bir aynı paleti kullanıyoruz: dark'ta
    // warm-black zemin (darkBg) + warm off-white yazı (darkFg), light'ta
    // krem zemin + siyah yazı. Aksi halde 0x0A0A0A vs 0x0E0D0A arasında
    // hafif bir flicker ve dark mode'da SKAPP yazısının saf beyaz olması
    // sebebiyle home dashboard'a (warm off-white) geçişte tonal kayma
    // hissediliyordu.
    final fg = isDark ? SkColors.darkFg : SkColors.black;
    final bg = isDark ? SkColors.darkBg : SkColors.cream;

    final w = MediaQuery.of(context).size.width;
    // Mobil ile masaüstü arasında doğal ölçek farkı. S0.html mobil
    // önizlemesindeki 64 px logo + 44 px SKAPP metriği baz; geniş
    // ekranlarda 96/64 px'e büyür.
    final isWide = w >= 600;
    final logoSize = isWide ? 96.0 : 64.0;
    final markSize = isWide ? 64.0 : 44.0;
    final markSpacing = isWide ? -3.2 : -2.2;
    final handSize = isWide ? 28.0 : 22.0;

    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLogo(logoAsset, logoSize),
                const SizedBox(height: 10),
                _buildSkappMark(fg, markSize, markSpacing),
                const SizedBox(height: 10),
                _buildSmartKraftHand(handSize),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Logo: 3D rotateX unfold + scale overshoot ─────────────────────
  Widget _buildLogo(String asset, double size) {
    // 0.045 → 0.45 (≈100..990 ms), curve ease-out.
    final t = _seg(0.045, 0.45, Curves.easeOutCubic);
    // S0.html parametresi: 0% → -100°, 60% → 10°, 100% → 0°
    final angle = _piecewise(t, [
      _Stop(0.00, _deg(-100)),
      _Stop(0.60, _deg(10)),
      _Stop(1.00, 0.0),
    ]);
    final scale = _piecewise(t, [
      _Stop(0.00, 0.6),
      _Stop(0.60, 1.04),
      _Stop(1.00, 1.0),
    ]);
    final opacity = t < 0.001 ? 0.0 : t.clamp(0.0, 1.0);

    return Opacity(
      opacity: opacity,
      child: Transform(
        alignment: Alignment.topCenter,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspektif
          ..rotateX(angle)
          ..scaleByDouble(scale, scale, scale, 1.0),
        child: Image.asset(
          asset,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (ctx, err, st) => SizedBox(width: size, height: size),
        ),
      ),
    );
  }

  // ── SKAPP: harf harf yukarıdan düşer, stagger ─────────────────────
  Widget _buildSkappMark(Color fg, double size, double letterSpacing) {
    const chars = ['S', 'K', 'A', 'P', 'P'];
    // Harf başlangıç gecikmeleri (S0.html · animation-delay 700..1100 ms,
    // 2200 ms toplama göre 0.318..0.500). Her harf 500 ms = 0.227 pencere.
    const starts = [0.318, 0.364, 0.409, 0.455, 0.500];
    const window = 0.227; // 500 / 2200

    return DefaultTextStyle(
      style: GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: FontWeight.w800,
        letterSpacing: letterSpacing,
        color: fg,
        height: 0.92,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < chars.length; i++)
            _AnimatedLetter(
              char: chars[i],
              progress: _seg(starts[i], starts[i] + window, Curves.easeOutBack),
            ),
        ],
      ),
    );
  }

  // ── SmartKraft: rotate + scale fold-in ────────────────────────────
  Widget _buildSmartKraftHand(double size) {
    // 1300 ms → 1900 ms penceresi (0.591 → 0.864 of 2200).
    final t = _seg(0.591, 0.864, Curves.easeOutBack);
    // S0.html: rotate(-12°→-2°) + scale(0.6→1) + opacity(0→1)
    final angle = _lerp(_deg(-12), _deg(-2), t);
    final scale = _lerp(0.6, 1.0, t);
    final opacity = t.clamp(0.0, 1.0);

    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Transform.scale(
          scale: scale,
          child: Text(
            'SmartKraft',
            style: GoogleFonts.caveat(
              fontSize: size,
              fontWeight: FontWeight.w600,
              color: SkColors.attentionMustard,
              letterSpacing: -0.5,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Animasyon yardımcıları ──────────────────────────────────────────

class _AnimatedLetter extends StatelessWidget {
  const _AnimatedLetter({required this.char, required this.progress});
  final String char;
  final double progress;

  @override
  Widget build(BuildContext context) {
    // S0.html: translateY(-30px → 0) + opacity(0 → 1)
    final dy = (1.0 - progress) * -30.0;
    return Opacity(
      opacity: progress.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, dy),
        child: Text(char),
      ),
    );
  }
}

class _Stop {
  const _Stop(this.t, this.v);
  final double t;
  final double v;
}

double _piecewise(double t, List<_Stop> stops) {
  if (t <= stops.first.t) return stops.first.v;
  if (t >= stops.last.t) return stops.last.v;
  for (int i = 0; i < stops.length - 1; i++) {
    final a = stops[i], b = stops[i + 1];
    if (t >= a.t && t <= b.t) {
      final localT = (t - a.t) / (b.t - a.t);
      return _lerp(a.v, b.v, localT);
    }
  }
  return stops.last.v;
}

double _lerp(double a, double b, double t) => a + (b - a) * t;
double _deg(double d) => d * math.pi / 180.0;
