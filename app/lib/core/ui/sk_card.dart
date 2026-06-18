import 'package:flutter/material.dart';

/// Shared card shell, rounded, subtle border, optional ink tap.
///
/// Used by Settings, License and other card-grid screens so visual language
/// stays identical without each feature redefining its own primitive.
class SkCard extends StatelessWidget {
  const SkCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(14),
    this.borderColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  /// Override border rengi; verilmezse `onSurface * 0.16` (mevcut default).
  /// Settings'in tehlikeli (danger) kartları kırmızı border için bunu set
  /// eder; başka bir kullanım yeri yoksa default'a düşer.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // surfaceContainerLow zeminden hafifçe ayrışır (light: krem üzeri biraz
    // koyu krem, dark: warm-black üzeri biraz açık warm-black). cs.surface
    // doğrudan zemin rengi olduğu için kart-zemin kontrastı kaybolur.
    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor ?? cs.outlineVariant,
            ),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
