import 'package:flutter/material.dart';

import '../theme/colors.dart';

/// Mustard-bordered info banner used to draw attention to a not-yet-active
/// area or to surface a constraint the user should know.
///
/// Originally lived inline inside the (now removed) actions screen; lifted
/// to `core/ui/` so the SKAPI tab, settings cards, and other screens can
/// surface "this is here but isn't wired yet" notices in a single visual
/// language. The mustard tone matches `SkColors.attentionMustard`
/// reserved for "pay attention, not an error" per the project palette.
class SkInfoBanner extends StatelessWidget {
  const SkInfoBanner({
    super.key,
    required this.text,
    this.icon = Icons.info_outline,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SkColors.attentionMustard, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: SkColors.attentionMustard),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
