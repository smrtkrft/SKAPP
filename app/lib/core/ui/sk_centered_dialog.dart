import 'package:flutter/material.dart';

/// Centered modal dialog shell. Replaces the project's earlier
/// "alttan kayan" `showModalBottomSheet` paradigm with a consistent
/// centered popup that works equally well on phone and desktop.
///
/// Layout (`_LanguagePickerDialog` pattern):
///   * `Dialog` with rounded `RoundedRectangleBorder(16)`
///   * `ConstrainedBox(maxWidth, maxHeight)` to keep popups
///     readable on wide desktop windows (default 520 × 640)
///   * Column:
///       - Header row: optional icon · title · optional close X
///       - Optional subtitle line under the header
///       - Divider
///       - `Flexible(SingleChildScrollView(child))` for the body
///       - Optional `Divider + actions` row at the bottom
///
/// Use `Navigator.of(context).pop(value)` from inside the child to
/// dismiss with a return value — same as `showModalBottomSheet`.
///
/// Example:
/// ```dart
/// final result = await showDialog<MyResult>(
///   context: context,
///   builder: (_) => SkCenteredDialog(
///     title: 'Pick something',
///     icon: Icons.menu,
///     child: Column(...),
///   ),
/// );
/// ```
class SkCenteredDialog extends StatelessWidget {
  const SkCenteredDialog({
    super.key,
    required this.title,
    this.icon,
    this.subtitle,
    this.maxWidth = 520,
    this.maxHeight = 640,
    required this.child,
    this.actions,
    this.showCloseButton = true,
    this.bodyPadding = const EdgeInsets.fromLTRB(20, 14, 20, 18),
  });

  /// Header title, rendered bold next to [icon] (if any). Required —
  /// every dialog should have one so the user knows what they're
  /// looking at.
  final String title;

  /// Optional leading icon in the header. Same colour as the title.
  final IconData? icon;

  /// Optional secondary line below the title. Use for short context
  /// (e.g. "3 paired peers", "{deviceName}"). Long bodies belong in
  /// [child] instead.
  final String? subtitle;

  /// Outer width / height caps. Defaults sized for phone-sensible
  /// dialogs; pickers and long forms can grow these to ~720×600.
  final double maxWidth;
  final double maxHeight;

  /// Scrollable body. Wrap multi-section content in a `Column` —
  /// the dialog wraps the whole thing in a `SingleChildScrollView`,
  /// so any height that exceeds [maxHeight] becomes scrollable.
  final Widget child;

  /// Optional bottom action row (e.g. Copy / Cancel / Close). When
  /// provided, a divider is auto-added above and the row is padded
  /// like the standard Material `AlertDialog.actions` slot.
  final List<Widget>? actions;

  /// Show the top-right X close icon. Default true; set false for
  /// "blocking" dialogs that should only be dismissed by an action
  /// button.
  final bool showCloseButton;

  /// Padding applied around [child] inside the scroll area. Default
  /// 20·14·20·18. Override to 0 when the child wants to render
  /// edge-to-edge (e.g. ListView with its own padding).
  final EdgeInsetsGeometry bodyPadding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Dialog(
      // shape ve backgroundColor theme'den gelir (DialogThemeData).
      // Tactile redesign sonrası: krem zemin + radius 18 + soft drop shadow.
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                18,
                showCloseButton ? 8 : 20,
                subtitle == null ? 14 : 8,
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 22,
                      color: cs.onSurface.withValues(alpha: 0.75),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (showCloseButton)
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      tooltip: MaterialLocalizations.of(context)
                          .closeButtonTooltip,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                ],
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: Text(
                  subtitle!,
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ),
            Divider(
              height: 1,
              color: cs.outlineVariant.withValues(alpha: 0.35),
            ),
            // Body — Flexible lets the content scroll inside maxHeight
            // instead of forcing the dialog to expand off-screen.
            Flexible(
              child: SingleChildScrollView(
                padding: bodyPadding,
                child: child,
              ),
            ),
            // Optional bottom actions row
            if (actions != null && actions!.isNotEmpty) ...[
              Divider(
                height: 1,
                color: cs.outlineVariant.withValues(alpha: 0.35),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (var i = 0; i < actions!.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      actions![i],
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
