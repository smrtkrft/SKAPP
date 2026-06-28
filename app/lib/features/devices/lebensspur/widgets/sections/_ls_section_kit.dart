// Shared form primitives for LsSection bodies.
//
// Mirrors the `.section-body-inner`, `.field`, `.neu-input`, `.actions-row`
// and `.btn-primary` patterns from `ls_gui_design2.html`. Kept in one
// file so every section reads the same way and a future visual tweak
// only touches one place.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../l10n/app_localizations.dart';

// ============================================================================
// SECTION BODY · padded vertical column with hairline divider above.
// ============================================================================

/// Wraps the children of a section's body with the standard
/// `padding: 0 20 20` + 12 px vertical gap pattern from the HTML
/// (`.section-body-inner > .pad-top`).
class LsSectionBody extends StatelessWidget {
  const LsSectionBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Error banner with retry, used for the initial fetch failure path.
class LsSectionErrorLine extends StatelessWidget {
  const LsSectionErrorLine({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.error_outline, size: 16, color: SkColors.warnRed),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(fontSize: 12, color: SkColors.warnRed),
          ),
        ),
        TextButton(
          onPressed: onRetry,
          child: Text(AppLocalizations.of(context).commonRetry),
        ),
      ],
    );
  }
}

// ============================================================================
// FIELD ROW · label above input (or row with right-aligned input + hint)
// ============================================================================

/// One form row. Label sits 12 px above its [child]; when [row] is true
/// the label and child are placed inline (label left, input right) like
/// `.field-row` from the HTML, and any [hint] sits underneath.
class LsField extends StatelessWidget {
  const LsField({
    super.key,
    required this.label,
    required this.child,
    this.hint,
    this.row = false,
  });

  final String label;
  final Widget child;
  final String? hint;
  final bool row;

  @override
  Widget build(BuildContext context) {
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;
    final labelStyle = TextStyle(
      fontSize: 12,
      color: fg.withValues(alpha: 0.70),
      letterSpacing: 0.1,
    );
    final hintStyle = TextStyle(
      fontSize: 11,
      color: fg.withValues(alpha: 0.50),
    );

    if (row) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: labelStyle)),
              const SizedBox(width: 12),
              child,
            ],
          ),
          if (hint != null) ...[
            const SizedBox(height: 6),
            Text(hint!, style: hintStyle),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 6),
        child,
        if (hint != null) ...[
          const SizedBox(height: 6),
          Text(hint!, style: hintStyle),
        ],
      ],
    );
  }
}

/// Two columns of [LsField]s side-by-side, collapsing to a single column
/// when the container narrows under 360 px (matches the HTML's
/// `@media (max-width: 460px)` rule, adjusted for typical mobile width
/// inside a 16 px page padding).
class LsField2Col extends StatelessWidget {
  const LsField2Col({super.key, required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 360) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              left,
              const SizedBox(height: 12),
              right,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: left),
            const SizedBox(width: 12),
            Expanded(child: right),
          ],
        );
      },
    );
  }
}

// ============================================================================
// RAISED INPUT · mirrors `.neu-input` from the HTML.
// ============================================================================

/// Raised text input. Looks like it sits proud of the well, matching
/// `.neu-input`: dual outer BoxShadow (light top-left + dark bottom-right),
/// 12 px radius, mustard focus halo.
class LsNeuTextField extends StatelessWidget {
  const LsNeuTextField({
    super.key,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.align = TextAlign.left,
    this.maxLength,
    this.suffix,
  });

  final TextEditingController controller;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final TextAlign align;
  final int? maxLength;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final fg = isDark ? SkColors.darkFg : SkColors.black;
    final shDark = isDark
        ? Colors.black.withValues(alpha: 0.55)
        : Colors.black.withValues(alpha: 0.18);
    final shLight = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.90);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: shLight,
            offset: const Offset(-2, -2),
            blurRadius: 3,
          ),
          BoxShadow(
            color: shDark,
            offset: const Offset(2, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        enabled: enabled,
        textAlign: align,
        maxLength: maxLength,
        style: TextStyle(fontSize: 14, color: fg),
        decoration: InputDecoration(
          isDense: true,
          counterText: '',
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14,
            color: fg.withValues(alpha: 0.50),
          ),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}

/// Raised dropdown. Same surface treatment as [LsNeuTextField].
class LsNeuDropdown<T> extends StatelessWidget {
  const LsNeuDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final fg = isDark ? SkColors.darkFg : SkColors.black;
    final shDark = isDark
        ? Colors.black.withValues(alpha: 0.55)
        : Colors.black.withValues(alpha: 0.18);
    final shLight = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.90);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: shLight,
            offset: const Offset(-2, -2),
            blurRadius: 3,
          ),
          BoxShadow(
            color: shDark,
            offset: const Offset(2, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          isDense: true,
          icon: Icon(Icons.expand_more, color: fg.withValues(alpha: 0.50)),
          style: TextStyle(fontSize: 14, color: fg),
          dropdownColor: bg,
        ),
      ),
    );
  }
}

// ============================================================================
// ACTIONS ROW · pill buttons at the bottom of an expanded section.
// ============================================================================

/// Bottom-of-section action row with a hairline divider above. Matches
/// `.actions-row` from the HTML.
class LsActionsRow extends StatelessWidget {
  const LsActionsRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final fg = Theme.of(context).brightness == Brightness.dark
        ? SkColors.darkFg
        : SkColors.black;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: fg.withValues(alpha: 0.04), width: 1),
        ),
      ),
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 12,
        runSpacing: 8,
        children: children,
      ),
    );
  }
}

/// Raised pill button. Mirrors `.btn-primary` from the HTML.
///   * Default: neutral fg, mustard on hover (rendered always-on when
///     [accent] is true so a dirty form's Save button reads as the
///     primary call to action).
///   * Set [danger] for warn-red (used by Cancel-vacation / Regenerate).
///   * Pass null [onPressed] to disable.
class LsPillButton extends StatelessWidget {
  const LsPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.accent = false,
    this.danger = false,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool accent;
  final bool danger;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final fgBase = isDark ? SkColors.darkFg : SkColors.black;
    final disabled = onPressed == null;
    final fg = disabled
        ? fgBase.withValues(alpha: 0.35)
        : danger
            ? SkColors.warnRed
            : accent
                ? SkColors.attentionMustard
                : fgBase;
    final shDark = isDark
        ? Colors.black.withValues(alpha: 0.55)
        : Colors.black.withValues(alpha: 0.18);
    final shLight = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.90);

    final shape = BorderRadius.circular(999);
    return Material(
      color: Colors.transparent,
      borderRadius: shape,
      child: InkWell(
        onTap: onPressed,
        borderRadius: shape,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: shape,
            border: outlined
                ? Border.all(
                    color: danger
                        ? SkColors.warnRed.withValues(alpha: 0.50)
                        : fgBase.withValues(alpha: 0.18),
                    width: 1,
                  )
                : null,
            boxShadow: outlined
                ? null
                : [
                    BoxShadow(
                      color: shLight,
                      offset: const Offset(-2, -2),
                      blurRadius: 3,
                    ),
                    BoxShadow(
                      color: shDark,
                      offset: const Offset(2, 2),
                      blurRadius: 3,
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: fg),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: fg,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
