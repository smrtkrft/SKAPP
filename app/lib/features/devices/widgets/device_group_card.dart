// Kart görünümündeki tek cihaz kartı (no_github/test/cihazlar_gorunum.html).
//
// Sakinlik kuralları — mockup'ta kilitlendi, burada da geçerli:
//   · TEK durum sinyali (nokta) + TEK tip işareti (glif). Rozet yok,
//     chevron yok, "çevrimiçi" yazısı yok — üçü de aynı bilgiyi
//     tekrarlıyordu.
//   · Gölge yok, hover'da yükselme yok; kenarlık en ince kademe.
//   · Çevrimdışı kart renk değil OPAKLIK kaybeder.
//   · Tek vurgu hardal: yalnız pil uyarısı ve seçim çerçevesi.
//   · Ad tek satır + ellipsis → kartlar aynı yükseklikte kalır, ızgara
//     satır satır zıplamaz.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/ble/device_type_visual.dart';
import '../../../core/storage/paired_devices_store.dart';
import '../../../core/theme/colors.dart';

class DeviceGroupCard extends StatelessWidget {
  const DeviceGroupCard({
    super.key,
    required this.device,
    required this.online,
    required this.editing,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
  });

  final PairedDevice device;
  final bool online;

  /// Düzenleme modunda glif yerine onay kutusu çizilir ve dokunuş
  /// seçim anlamına gelir (cihaz açılmaz).
  final bool editing;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;
    final card = isDark ? const Color(0xFF1F1D18) : const Color(0xFFFFFEFA);

    return Opacity(
      opacity: online ? 1.0 : 0.5,
      child: Material(
        color: selected
            ? SkColors.attentionMustard.withValues(alpha: isDark ? 0.18 : 0.12)
            : card,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? SkColors.attentionMustard
                    : fg.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (editing)
                      _Checkbox(checked: selected, fg: fg)
                    else
                      Opacity(
                        opacity: 0.42,
                        child: Icon(
                          DeviceTypeVisual.iconFor(device.prefix),
                          size: 19,
                          color: fg,
                        ),
                      ),
                    const Spacer(),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: online
                            ? SkColors.attentionMustard
                            : Colors.transparent,
                        border: online
                            ? null
                            : Border.all(
                                color: fg.withValues(alpha: 0.16), width: 1.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Text(
                  device.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.1,
                    height: 1.3,
                    color: fg,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  device.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9.5,
                    letterSpacing: 0.2,
                    color: fg.withValues(alpha: 0.40),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.checked, required this.fg});
  final bool checked;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 17,
      height: 17,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: checked ? SkColors.attentionMustard : Colors.transparent,
        border: Border.all(
          color: checked
              ? SkColors.attentionMustard
              : fg.withValues(alpha: 0.16),
          width: 1.5,
        ),
      ),
      child: checked
          ? Icon(Icons.check_rounded,
              size: 12, color: Theme.of(context).scaffoldBackgroundColor)
          : null,
    );
  }
}
