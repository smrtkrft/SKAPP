import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/network/skapp_peer_target.dart';
import '../../../core/theme/colors.dart';

/// Paired Desktop SKAPP peer için ikon-merkezli kart (mobil sürümde
/// Cihazlarım sekmesi). MobileDeviceCard'ın aynası.
///
/// Yapı transparan zemin, kenar/gölge yok; tek ikon `desktop_windows`.
/// Online iken hardal sarısı zeminli + pulsing halo; offline iken gri
/// zeminli, halo yok. Online state mobile→desktop yönünde gerçek:
/// `skapp_peer_health_prober` her 30 sn `/api/health` ile lastSeen'i
/// taze tutar; `SkappPeerTarget.online` getter'ı 90 sn pencereyle
/// karar verir.
///
/// Normal tıklama: detay sayfası YOK, parent "SKAPI komutu gönderilsin
/// mi?" onay dialogu açar; onaylanırsa `emitEvent(skapp.mobile.tap)`
/// ile o desktop'ın mobile-touch binding'leri tetiklenir.
/// Uzun bas: eşleşmeyi kaldırma onayını açar.
class DesktopDeviceCard extends StatefulWidget {
  const DesktopDeviceCard({
    super.key,
    required this.peer,
    required this.onTapTrigger,
    this.onLongPress,
    this.compact = false,
  });

  final SkappPeerTarget peer;

  /// Normal tıklamada çağrılır. Parent burada onay dialogu açar.
  final VoidCallback onTapTrigger;

  /// Uzun basıldığında çağrılır. Parent eşleşmeyi kaldırma onayını açar.
  final VoidCallback? onLongPress;

  final bool compact;

  @override
  State<DesktopDeviceCard> createState() => _DesktopDeviceCardState();
}

class _DesktopDeviceCardState extends State<DesktopDeviceCard>
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;
    final online = widget.peer.online;

    final compact = widget.compact;
    final glyphSize = compact ? 50.0 : 56.0;
    final iconSize = compact ? 30.0 : 34.0;
    final nameSize = compact ? 11.5 : 12.0;

    final glyphBg = online
        ? SkColors.attentionMustard.withValues(alpha: 0.12)
        : fg.withValues(alpha: 0.05);
    final glyphFg =
        online ? SkColors.attentionMustard : fg.withValues(alpha: 0.40);
    final nameColor = online ? fg : fg.withValues(alpha: 0.55);

    final title = widget.peer.name;

    return Semantics(
      button: true,
      label: title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTapTrigger();
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
                    icon: Icons.desktop_windows_rounded,
                    background: glyphBg,
                    foreground: glyphFg,
                    halo: online ? _halo : null,
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
                      color: nameColor,
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

  /// Online ise pulse halo çizmek için controller; offline ise null.
  final AnimationController? halo;

  @override
  Widget build(BuildContext context) {
    final core = AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: foreground),
    );

    final h = halo;
    if (h == null) return core;
    return SizedBox(
      width: size + 8,
      height: size + 8,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: h,
            builder: (context, _) {
              final t = h.value;
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
