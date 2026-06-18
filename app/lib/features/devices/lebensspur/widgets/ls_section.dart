// Reusable collapsible neumorphic well · matches `.section` from
// ls_gui_design2.html.
//
// The HTML uses `display: grid; grid-template-rows: 0fr → 1fr` to
// animate the expand. Flutter doesn't have a direct equivalent but
// `AnimatedSize` driven by a conditional child achieves the same
// "height tweens between content size and 0" behavior. The header is a
// row of: raised icon socket · title + subtitle · chevron (rotates 90°
// when open).

import 'package:flutter/material.dart';

import '../../../../core/ui/sk_neu_card.dart';
import '../../../../core/theme/colors.dart';

/// One collapsible section inside an LS cluster. The body is supplied
/// by the parent (next-phase agents will populate it with real forms);
/// when [expanded] is false the body is removed from the tree entirely
/// so off-screen sections don't pay layout / event cost.
///
/// Visual contract:
///   * Outer container: SkNeuCard (inset well, 18px radius).
///   * Header (always visible): raised icon · title · status text · chevron.
///   * Body (when expanded): inset content below a hairline separator.
///
/// Touch target: the *whole* header row is tappable, mirroring the
/// `button.section-head` from the design. The body is opaque to taps
/// so child widgets receive their own events without bubbling back to
/// the toggle.
class LsSection extends StatelessWidget {
  const LsSection({
    super.key,
    required this.icon,
    required this.title,
    required this.statusText,
    required this.expanded,
    required this.onToggle,
    required this.body,
    this.iconTone = LsSectionTone.neutral,
    this.statusTone = LsSectionTone.neutral,
  });

  final IconData icon;
  final String title;
  final String statusText;
  final bool expanded;
  final VoidCallback onToggle;

  /// Section content shown when [expanded] is true.
  final Widget body;

  /// Colors the raised header icon: mustard or warn switches its tint
  /// per the design (e.g. mustard for active triggers, warn for unset).
  final LsSectionTone iconTone;

  /// Tints the secondary status string. Useful when a section's current
  /// value is significant (mustard "running", warn "error").
  final LsSectionTone statusTone;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? SkColors.darkFg : SkColors.black;
    final statusColor = switch (statusTone) {
      LsSectionTone.mustard => SkColors.attentionMustard,
      LsSectionTone.warn => SkColors.warnRed,
      LsSectionTone.neutral => fg.withValues(alpha: 0.50),
    };
    final iconSlotTone = switch (iconTone) {
      LsSectionTone.mustard => SkNeuIconSlotTone.mustard,
      LsSectionTone.warn => SkNeuIconSlotTone.danger,
      LsSectionTone.neutral => SkNeuIconSlotTone.neutral,
    };
    final hairline = fg.withValues(alpha: 0.04);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SkNeuCard(
        padding: EdgeInsets.zero,
        onTap: onToggle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  SkNeuIconSlot(
                    icon: icon,
                    size: 38,
                    iconSize: 18,
                    tone: iconSlotTone,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: fg,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          statusText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeInOutCubic,
                    child: Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: fg.withValues(alpha: 0.35),
                    ),
                  ),
                ],
              ),
            ),
            // Body, animated height transition
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: expanded
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: hairline, width: 1),
                        ),
                      ),
                      width: double.infinity,
                      child: body,
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tone variants for section header icon + status line.
enum LsSectionTone { neutral, mustard, warn }

/// Placeholder body used by [LsSection] while the per-section forms are
/// still pending. Renders the design intent so QA can verify the
/// collapse animation without each section's plumbing being wired.
///
/// Next-phase agents should REPLACE this with their real form widget;
/// the shell wires them in via the `body` slot on [LsSection].
class LsSectionPlaceholderBody extends StatelessWidget {
  const LsSectionPlaceholderBody({super.key, required this.sectionLabel});

  /// Human-readable section name, for the message body. Shown verbatim
  /// to make it obvious *which* section is still pending when debugging.
  final String sectionLabel;

  @override
  Widget build(BuildContext context) {
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Text(
        '$sectionLabel · coming in the next phase\n'
        'See ls_gui_design2.html for the form layout.',
        style: TextStyle(
          fontSize: 12,
          color: fg.withValues(alpha: 0.50),
          height: 1.5,
        ),
      ),
    );
  }
}
