import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';
import '../../../core/ui/sk_centered_dialog.dart';
import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';

/// Centered help dialog that explains what SKAPI is, the three-step flow,
/// and the glossary the rest of the UI uses (Şablon / Aksiyon / API
/// trigger / Script). Closes with the X icon or system back gesture.
///
/// 2026-05-15: switched from `showModalBottomSheet` to `showDialog` /
/// [SkCenteredDialog] so the popup sits centered on desktop and stops
/// stealing the bottom of the screen on phones. Honest about the
/// current state: ends with a Phase 1 notice clarifying that most of
/// the tab is a skeleton.
Future<void> showSkapiHelpSheet(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const _SkapiHelpDialog(),
  );
}

class _SkapiHelpDialog extends StatelessWidget {
  const _SkapiHelpDialog();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SkCenteredDialog(
      title: l.skapiHelpSheetTitle,
      icon: Icons.help_outline_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.skapiHelpIntro,
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 20),
          _Step(
                index: 1,
                icon: Icons.menu_book_outlined,
                title: l.skapiHelpStep1Title,
                body: l.skapiHelpStep1Body,
              ),
              const SizedBox(height: 12),
              _Step(
                index: 2,
                icon: Icons.tune_rounded,
                title: l.skapiHelpStep2Title,
                body: l.skapiHelpStep2Body,
              ),
              const SizedBox(height: 12),
              _Step(
                index: 3,
                icon: Icons.upload_rounded,
                title: l.skapiHelpStep3Title,
                body: l.skapiHelpStep3Body,
              ),
              const SizedBox(height: 24),
              Text(
                l.skapiHelpGlossaryTitle,
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              _GlossaryRow(text: l.skapiHelpGlossaryTemplate),
              _GlossaryRow(text: l.skapiHelpGlossaryAction),
              _GlossaryRow(text: l.skapiHelpGlossaryApiTrigger),
              _GlossaryRow(text: l.skapiHelpGlossaryScript),
              const SizedBox(height: 20),
              SkNeuCard(
                borderRadius: 12,
                borderColor: SkColors.attentionMustard,
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: SkColors.attentionMustard,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l.skapiHelpPhase1Notice,
                        style: tt.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.index,
    required this.icon,
    required this.title,
    required this.body,
  });

  final int index;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: cs.onSurface.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: cs.onSurface),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$index. $title',
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlossaryRow extends StatelessWidget {
  const _GlossaryRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7, right: 8),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
