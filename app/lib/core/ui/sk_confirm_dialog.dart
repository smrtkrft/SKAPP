import 'package:flutter/material.dart';

import '../theme/colors.dart';
import 'sk_centered_dialog.dart';

/// Ortak onay diyaloğu. Kod tabanındaki ~38 ham `AlertDialog(... TextButton +
/// FilledButton ...)` tekrarını tek yere toplar; görünüm `SkCenteredDialog`
/// ile diğer modallarla tutarlı olur (DRY — tasarım cilası Faz B).
///
/// Kullanım:
/// ```dart
/// final ok = await showSkConfirm(
///   context,
///   title: l.resetTitle,
///   message: l.resetBody,
///   confirmLabel: l.commonDelete,
///   destructive: true, // onay butonu palet kırmızısı
/// );
/// if (ok) { ... }
/// ```
///
/// `true` döner: kullanıcı onayladı. `false`/null: iptal / dışarı tıklama.
Future<bool> showSkConfirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  IconData? icon,
  bool destructive = false,
  bool barrierDismissible = true,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) => SkConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      icon: icon,
      destructive: destructive,
    ),
  );
  return result ?? false;
}

/// `showSkConfirm` tarafından kurulan içerik. Doğrudan `showDialog` ile de
/// kullanılabilir; `Navigator.pop(true/false)` ile sonuç döner.
class SkConfirmDialog extends StatelessWidget {
  const SkConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.icon,
    this.destructive = false,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final IconData? icon;

  /// `true` → onay butonu palet kırmızısı (geri döndürülemez/yıkıcı eylem).
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SkCenteredDialog(
      title: title,
      icon: icon,
      maxWidth: 440,
      maxHeight: 320,
      showCloseButton: false,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(backgroundColor: SkColors.warnRed)
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
      child: Text(message, style: tt.bodyMedium),
    );
  }
}
