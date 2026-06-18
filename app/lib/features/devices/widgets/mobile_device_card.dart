import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/storage/paired_devices_store.dart';
import '../../../core/theme/colors.dart';
import '../../../l10n/app_localizations.dart';

/// Mobile peer (SKAPP Mobile, prefix `MS`) için ikon-merkezli kart.
///
/// SK kartından yapısal olarak ayrıdır: transparan zemin, kenar/gölge yok.
/// Tek tip ikon (`tap_and_play`) hardal sarısı zeminli pulsing halo ile;
/// altta isim. Online/offline durum ayrımı şu an gösterilmiyor — telefon
/// için gerçek online tespit altyapısı (heartbeat, auth-touch wiring)
/// henüz yok, durum etiketi yanıltıcı olmasın diye kaldırıldı.
///
/// Telefonun SKAPP'te detay sayfası olmadığı için normal tıklama bir ipucu
/// balonu (SnackBar) gösterir; uzun bas eşleşmeyi kaldırma onayını açar.
class MobileDeviceCard extends StatefulWidget {
  const MobileDeviceCard({
    super.key,
    required this.device,
    required this.onTapHint,
    this.onLongPress,
    this.compact = false,
  });

  final PairedDevice device;

  /// Normal tıklamada çağrılır. Telefon kartı detay sayfası açmaz; çağıran
  /// taraf burada bir SnackBar/Toast gösterir.
  final VoidCallback onTapHint;

  /// Uzun basıldığında çağrılır. Çağıran taraf eşleşmeyi kaldırma onay
  /// dialogunu açar.
  final VoidCallback? onLongPress;

  final bool compact;

  @override
  State<MobileDeviceCard> createState() => _MobileDeviceCardState();
}

class _MobileDeviceCardState extends State<MobileDeviceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _halo;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _halo = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _halo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;

    final compact = widget.compact;
    final glyphSize = compact ? 50.0 : 56.0;
    final iconSize = compact ? 30.0 : 34.0;
    final nameSize = compact ? 11.5 : 12.0;

    final title = widget.device.displayName;

    return Semantics(
      button: true,
      label: title,
      hint: l.devicesMobileNoDetailHint,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTapHint();
        },
        onLongPressStart: (_) => setState(() => _pressed = true),
        onLongPressEnd: (_) => setState(() => _pressed = false),
        onLongPress: widget.onLongPress,
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: SizedBox(
            width: compact ? 110 : 118,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, compact ? 12 : 16, 10, 13),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Glyph(
                    size: glyphSize,
                    iconSize: iconSize,
                    icon: Icons.tap_and_play_rounded,
                    background: SkColors.attentionMustard
                        .withValues(alpha: 0.12),
                    foreground: SkColors.attentionMustard,
                    halo: _halo,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: nameSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.1,
                      color: fg,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Glyph extends StatelessWidget {
  const _Glyph({
    required this.size,
    required this.iconSize,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.halo,
  });

  final double size;
  final double iconSize;
  final IconData icon;
  final Color background;
  final Color foreground;
  final AnimationController halo;

  @override
  Widget build(BuildContext context) {
    final core = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: foreground),
    );

    // Halo: 0 → 1 boyunca scale 1.0 → 1.28, opacity 0.75 → 0.
    return SizedBox(
      width: size + 8,
      height: size + 8,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: halo,
            builder: (context, _) {
              final t = halo.value;
              final scale = 1.0 + 0.28 * t;
              final opacity = (0.75 * (1 - t)).clamp(0.0, 1.0);
              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: size + 4,
                    height: size + 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: SkColors.attentionMustard
                            .withValues(alpha: 0.55),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          core,
        ],
      ),
    );
  }
}
