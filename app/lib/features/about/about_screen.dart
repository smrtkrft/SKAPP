import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_info/version_provider.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;

/// About SKAPP screen.
///
/// Five sections: device philosophy, SKAPP's role, maker showcase (empty
/// for now), connect cards (GitHub / Website / YouTube / X / Email), and
/// a compact version block. License & thanks live on a separate screen.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  static const _githubUrl = 'https://github.com/smrtkrft';
  static const _websiteUrl = 'https://smartkraft.ch';
  static const _youtubeUrl = 'https://www.youtube.com/@SmartKraftLabs';
  static const _xUrl = 'https://x.com/SmartKraftLabs';
  static const _email = 'code@smartkraft.ch';
  static const _privacyUrl = 'https://smartkraft.ch/privacy';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final versionAsync = ref.watch(appVersionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logo = isDark
        ? 'assets/branding/logo_white.png'
        : 'assets/branding/logo_black.png';
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(title: Text(l.aboutTitle)),
      bottomNavigationBar: const ShellNavBar(),
      body: ListView(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 24 + bottomInset),
        children: [
          SkContent(
            horizontalPadding: 16,
            maxWidth: 820,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Image.asset(
                    logo,
                    height: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, e, st) => const SizedBox(height: 100),
                  ),
                ),
                const SizedBox(height: 24),

                _NarrativeCard(
                  heading: l.aboutDevicesHeading,
                  body: l.aboutDevicesBody,
                ),
                const SizedBox(height: 20),
                _NarrativeCard(
                  heading: l.aboutSkappRoleHeading,
                  body: l.aboutSkappRoleBody,
                ),

                const SizedBox(height: 28),
                _SectionHeader(text: l.aboutShowcaseHeading),
                SkNeuCard(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    l.aboutShowcaseEmpty,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7),
                        ),
                  ),
                ),

                const SizedBox(height: 28),
                _SectionHeader(text: l.aboutConnectHeading),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
                  child: Text(
                    l.aboutConnectIntro,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.65),
                        ),
                  ),
                ),
                _LinkRow(
                  left: _LinkCard(
                    label: l.aboutConnectGitHub,
                    icon: Icons.code_rounded,
                    onTap: () => _open(_githubUrl),
                  ),
                  right: _LinkCard(
                    label: l.aboutConnectWebsite,
                    icon: Icons.public_rounded,
                    onTap: () => _open(_websiteUrl),
                  ),
                ),
                const SizedBox(height: 10),
                _LinkRow(
                  left: _LinkCard(
                    label: l.aboutConnectYouTube,
                    icon: Icons.play_circle_outline_rounded,
                    onTap: () => _open(_youtubeUrl),
                  ),
                  right: _LinkCard(
                    label: l.aboutConnectX,
                    icon: Icons.alternate_email_rounded,
                    onTap: () => _open(_xUrl),
                  ),
                ),
                const SizedBox(height: 10),
                _LinkCard(
                  label: _email,
                  icon: Icons.mail_outline_rounded,
                  onTap: () => _open('mailto:$_email'),
                ),
                const SizedBox(height: 10),
                _LinkCard(
                  label: l.aboutPrivacyLabel,
                  icon: Icons.privacy_tip_outlined,
                  onTap: () => _open(_privacyUrl),
                ),

                const SizedBox(height: 28),
                _VersionCard(
                  label: 'SKAPP',
                  version: switch (versionAsync) {
                    AsyncData(:final value) => 'v$value',
                    AsyncError() => '-',
                    _ => '…',
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.left, required this.right});
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: left),
          const SizedBox(width: 10),
          Expanded(child: right),
        ],
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SkNeuCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: cs.onSurface),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.open_in_new_rounded,
            size: 16,
            color: cs.onSurface.withValues(alpha: 0.45),
          ),
        ],
      ),
    );
  }
}

class _VersionCard extends StatelessWidget {
  const _VersionCard({required this.label, required this.version});

  final String label;
  final String version;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SkNeuCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: theme.textTheme.titleMedium),
          ),
          Text(
            version,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
