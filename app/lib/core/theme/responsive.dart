// Layout breakpoints + helpers for desktop / tablet / phone.
//
// Desktop is NOT a stretched mobile, content has a comfortable reading max
// width, and the chrome (navigation) switches to a side rail. Use
// [SkContent] to wrap the body of any top-level screen so it stays centered
// at large widths.

import 'package:flutter/widgets.dart';

class SkBreakpoints {
  SkBreakpoints._();

  /// Below this we treat the window as a phone (bottom nav, full-bleed).
  static const double compact = 600;

  /// At/above this we treat the window as a desktop (side rail, capped width).
  static const double expanded = 900;

  /// The widest a single column of "reading" content should ever be on a
  /// desktop window. Cards / lists / forms cap at this so a 1920 px window
  /// doesn't produce 1700 px wide text rows. Matches the Settings / SKAPI
  /// tabs (and the per-device screens via [SkContentFrame]) so every tab
  /// shares one content width instead of drifting between 720 and 820.
  static const double maxContentWidth = 820;

  /// Wider cap used for two-column / dashboard layouts that benefit from a
  /// little more horizontal room than reading content.
  static const double maxWideContentWidth = 1040;
}

extension SkLayout on BuildContext {
  double get _w => MediaQuery.sizeOf(this).width;
  bool get isCompact => _w < SkBreakpoints.compact;
  bool get isDesktop => _w >= SkBreakpoints.expanded;
}

/// Centers and caps the width of its child. On phones this is a no-op
/// (child fills the screen). On wider windows the child is constrained to
/// [maxWidth] and centered, with optional symmetric horizontal padding so
/// content doesn't kiss the rail.
class SkContent extends StatelessWidget {
  const SkContent({
    super.key,
    required this.child,
    this.maxWidth = SkBreakpoints.maxContentWidth,
    this.horizontalPadding = 24,
  });

  final Widget child;
  final double maxWidth;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < SkBreakpoints.expanded) return child;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: child,
        ),
      ),
    );
  }
}

/// Caps and centers content at every window size, mirroring the Settings /
/// SKAPI tabs' `Center > ConstrainedBox(maxWidth: 820)` wrapper exactly.
///
/// Unlike [SkContent] (which is a no-op below the desktop breakpoint and adds
/// its own horizontal padding), this constrains unconditionally and adds no
/// padding of its own, so the child's existing list/scroll padding stays the
/// single source of truth. On phones the 820 cap is wider than the screen, so
/// content fills the width; on desktop it stops the dashboard from stretching
/// across a 1920 px window. Used by the per-device screens (BF, LS) so they
/// match the rest of the app instead of going full-bleed.
class SkContentFrame extends StatelessWidget {
  const SkContentFrame({
    super.key,
    required this.child,
    this.maxWidth = 820,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
