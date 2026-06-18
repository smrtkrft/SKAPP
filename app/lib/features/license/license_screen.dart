import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_info/version_provider.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;

/// License & thanks screen.
///
/// Two narrative cards, SmartKraft's own philosophy / licensing approach,
/// and a thank-you to the open-source community, followed by a small,
/// quiet link to Flutter's built-in third-party license list.
class LicenseScreen extends ConsumerWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final versionAsync = ref.watch(appVersionProvider);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(title: Text(l.licenseTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 24 + bottomInset),
        children: [
          SkContent(
            horizontalPadding: 16,
            maxWidth: 820,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _NarrativeCard(
                  heading: l.licenseSmartKraftHeading,
                  body: l.licenseSmartKraftBody,
                ),
                const SizedBox(height: 20),
                _NarrativeCard(
                  heading: l.licenseOpenSourceHeading,
                  body: l.licenseOpenSourceBody,
                ),
                const SizedBox(height: 28),
                _ThirdPartyLink(
                  label: l.licenseThirdPartyLink,
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'SKAPP',
                    applicationVersion: versionAsync.asData?.value ?? '',
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NarrativeCard extends StatelessWidget {
  const _NarrativeCard({required this.heading, required this.body});

  final String heading;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SkNeuCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading.toUpperCase(),
            style: theme.textTheme.labelSmall,
          ),
          const SizedBox(height: 14),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _ThirdPartyLink extends StatelessWidget {
  const _ThirdPartyLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            '$label  →',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.55),
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
      ),
    );
  }
}
