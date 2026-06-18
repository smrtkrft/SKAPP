import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/ble/notification_state.dart';
import '../../../core/storage/paired_devices_store.dart';
import '../../../core/theme/colors.dart';

/// Constellation device card — Strip form.
///
/// Sadece üç veri: atanmış ad, ID, çevrim içi durumu. Tür yazısı yoktur;
/// ID prefix'i (LS-, BF-, WD-, SY-) zaten türü ifade eder. Durum sol
/// kenardaki 3px renkli şerit ile verilir: mustard çevrim içi, kırmızı
/// uyarı (örn. düşük pil), gri çevrim dışı. Kartta ekstra etiket yok,
/// fonksiyon detayı cihaz ekranına aittir.
class ConstellationDeviceCard extends StatelessWidget {
  const ConstellationDeviceCard({
    super.key,
    required this.device,
    required this.notificationState,
    required this.onTap,
    this.onLongPress,
    this.compact = false,
  });

  final PairedDevice device;
  final NotificationState notificationState;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  /// Mobile: 132×~54, Desktop: 152×~62.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final width = compact ? 132.0 : 152.0;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;
    final cardBg = isDark
        ? const Color(0xFF1F1D18)
        : const Color(0xFFFFFEFA);

    final stripColor = _stripColor(notificationState, fg);
    final title = (device.customName?.isNotEmpty ?? false)
        ? device.customName!
        : device.typeFullName;
    final isOffline = notificationState == NotificationState.offline;

    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(8),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          width: width,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: fg.withValues(alpha: 0.12),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 8,
                bottom: 8,
                child: Container(
                  width: 3,
                  decoration: BoxDecoration(
                    color: stripColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  14,
                  compact ? 9 : 10,
                  11,
                  compact ? 10 : 11,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fraunces(
                        fontSize: compact ? 13.5 : 14.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                        color: isOffline
                            ? fg.withValues(alpha: 0.55)
                            : fg,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      device.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: compact ? 9.5 : 10.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                        color: fg.withValues(alpha: 0.38),
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _stripColor(NotificationState s, Color fg) {
    switch (s) {
      case NotificationState.none:
      case NotificationState.pairingPending:
        return SkColors.attentionMustard;
      case NotificationState.lowBattery:
        return SkColors.warnRed;
      case NotificationState.offline:
        return fg.withValues(alpha: 0.30);
    }
  }
}
