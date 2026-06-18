import 'package:flutter/material.dart';

import '../data/skapi_catalog.dart';

/// Theme-aware platform icon. The Linux glyph in FontAwesome is a
/// single-color silhouette; on dark themes the default `onSurface`
/// rendering paints it pure white, which inverts the "black wings,
/// white belly" mental model of the Tux mascot and looks wrong.
///
/// Workaround: keep the penguin in its original (black) color and put
/// a small white circular fill behind it on dark themes so the black
/// silhouette stays readable against the dark surface. Light themes
/// and non-Linux platforms render normally with `colorScheme.onSurface`.
class SkapiPlatformIcon extends StatelessWidget {
  const SkapiPlatformIcon({super.key, required this.platform});
  final SkapiPlatformSpec platform;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (platform.id == 'lx' && isDark) {
      // White circular plate behind the original-color (black) penguin.
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(platform.icon, size: 18, color: Colors.black),
        ),
      );
    }
    return Icon(platform.icon, size: 22, color: cs.onSurface);
  }
}
