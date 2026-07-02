// Safe modu ana görünümü · safe.html V5 "Olay Provası" (kullanıcı seçimi).
//
// İLKE: Dizi girişi YALNIZCA cihazdaki fiziksel düğmedendir (fiziksel
// varlık kanıtı — bilinçli tasarım kararı). Bu ekran tamamen
// ETKİLEŞİMSİZDİR (IgnorePointer): fare/klavye/dokunmatik hiçbir girdi
// üretmez; yalnız cihazdan gelen olayları yansıtır:
//   safe.triggered → çark 400° açılış dönüşü + çentikler hardal
//   safe.lockout   → çentikler + kilit kırmızı
// Durağan tabanda çark sabittir ("nöbette").

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/ui/sk_neu_card.dart';

enum SdSafeStatus { idle, fired, locked }

class SdSafeCenter extends StatelessWidget {
  const SdSafeCenter({
    super.key,
    required this.status,
    required this.statusText,
    required this.note,
  });

  final SdSafeStatus status;

  /// Durum satırı ("Güvenli Mod · Nöbette" / "Tetiklendi · …" / "Kilitli").
  final String statusText;

  /// Animasyon alanının altındaki açıklama notu (girişin yalnız cihazdan
  /// yapıldığını söyler).
  final String note;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, 340.0);
        final wheelSize = size * 0.42;
        final markColor = switch (status) {
          SdSafeStatus.idle => cs.outlineVariant,
          SdSafeStatus.fired => cs.tertiary,
          SdSafeStatus.locked => cs.error,
        };
        final statusColor = switch (status) {
          SdSafeStatus.idle => cs.onSurfaceVariant,
          SdSafeStatus.fired => cs.tertiary,
          SdSafeStatus.locked => cs.error,
        };
        return Center(
          child: IgnorePointer(
            // Etkileşimsizlik sözleşmesi: bu alt ağaç girdi ALMAZ.
            child: SkNeuCard(
              padding: EdgeInsets.zero,
              borderRadius: size / 2,
              child: SizedBox(
                width: size,
                height: size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size.square(size),
                      painter: _VaultMarksPainter(color: markColor),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _VaultWheel(
                          size: wheelSize,
                          fired: status == SdSafeStatus.fired,
                          hubColor: status == SdSafeStatus.locked
                              ? cs.error
                              : cs.tertiary,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          statusText.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10.5,
                            letterSpacing: 2,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: size * 0.62,
                          child: Text(
                            note,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9.5,
                              height: 1.5,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
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

/// Üç kollu vault çarkı. `fired` true olduğunda 400°'lik açılış dönüşü
/// (V5 karakteri), sonra durum idle'a dönünce yavaşça sıfıra.
class _VaultWheel extends StatelessWidget {
  const _VaultWheel({
    required this.size,
    required this.fired,
    required this.hubColor,
  });
  final double size;
  final bool fired;
  final Color hubColor;

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

    final spokeW = size * 0.085;
    final spokeH = size * 0.46;

    return AnimatedRotation(
      turns: fired ? 400 / 360 : 0,
      duration: fired
          ? const Duration(milliseconds: 1600)
          : const Duration(milliseconds: 600),
      curve: fired ? Curves.easeOutCubic : Curves.easeInOut,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (final deg in const [0.0, 120.0, 240.0])
              Transform.rotate(
                angle: deg * math.pi / 180,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: spokeW,
                    height: spokeH,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(spokeW / 2),
                      boxShadow: [
                        BoxShadow(
                          color: shLight,
                          offset: const Offset(-2, -2),
                          blurRadius: 5,
                        ),
                        BoxShadow(
                          color: shDark,
                          offset: const Offset(3, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SkNeuIconSlot(
              icon: Icons.lock_outline,
              size: size * 0.38,
              iconSize: size * 0.19,
              iconColor: hubColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// Çevredeki 16 çentik (design2 `.vault-marks` karşılığı) — durum rengi
/// üstten gelir (idle=outline, fired=hardal, locked=kırmızı).
class _VaultMarksPainter extends CustomPainter {
  const _VaultMarksPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final shortest = math.min(size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = color;
    final r1 = shortest / 2 - shortest * 0.085;
    final r2 = shortest / 2 - shortest * 0.045;
    for (var i = 0; i < 16; i++) {
      final a = i * 2 * math.pi / 16;
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(center + dir * r1, center + dir * r2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _VaultMarksPainter old) => old.color != color;
}
