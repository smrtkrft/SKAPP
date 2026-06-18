import 'package:flutter/material.dart';

import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import 'data/skapi_catalog.dart';
import 'skapi_platform_screen.dart';
import 'widgets/skapi_platform_icon.dart';

/// Pushed when the SKAPI Linux card is tapped. Linux fragments into
/// Debian-based and Arch-based families that need different scripts
/// (apt vs pacman package names, brightnessctl rules, etc.), so the
/// user picks one before drilling into the platform groups.
///
/// Each card here is a thin wrapper that pushes [SkapiPlatformScreen]
/// with one of [kSkapiLinuxDistros]. Loaded asset paths follow the
/// platform id directly: tapping Debian loads `assets/skapi/lx-debian/`.
class SkapiLinuxDistroScreen extends StatelessWidget {
  const SkapiLinuxDistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        title: Text(l.skapiPlatformLinux),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 100),
        children: [
          SkContent(
            horizontalPadding: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Heading(
                  title: l.skapiLinuxDistroHeading,
                  subtitle: l.skapiLinuxDistroSubtitle,
                ),
                const SizedBox(height: 14),
                for (final distro in kSkapiLinuxDistros) ...[
                  _DistroCard(distro: distro),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: tt.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}

class _DistroCard extends StatelessWidget {
  const _DistroCard({required this.distro});

  final SkapiPlatformSpec distro;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final label = _distroLabel(l, distro.id);
    final sub = _distroSub(l, distro.id);
    return SkNeuCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SkapiPlatformScreen(platform: distro),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          SkapiPlatformIcon(platform: distro),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: cs.onSurface.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}

String _distroLabel(AppLocalizations l, String id) {
  switch (id) {
    case 'lx-debian':
      return l.skapiLinuxDistroDebianLabel;
    case 'lx-arch':
      return l.skapiLinuxDistroArchLabel;
  }
  return id;
}

String _distroSub(AppLocalizations l, String id) {
  switch (id) {
    case 'lx-debian':
      return l.skapiLinuxDistroDebianSub;
    case 'lx-arch':
      return l.skapiLinuxDistroArchSub;
  }
  return '';
}
