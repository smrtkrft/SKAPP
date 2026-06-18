// İlk-giriş ekranı: kullanıcı yeni mi cihaz kuruyor, yoksa CLI'dan
// önceden yapılandırılmış cihazı SKAPP'a mı ekliyor? Akışlar farklı
// transport ve farklı UI adımları kullandığı için seçim baştan netleşir.
//
//   "Sıfırdan kurulum"  → BLE pairing → WiFi setup wizard → dashboard
//   "Hazır cihazı ekle" → mDNS browse → TCP ECDH pairing → dashboard
//                         (kullanıcı yapılandırması var ise wizard atlanır)

import 'package:flutter/material.dart';

import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import 'discovery_screen.dart';
import 'wifi_discovery_screen.dart';

class SetupChoiceScreen extends StatelessWidget {
  const SetupChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDesktop = context.isDesktop;

    final fresh = _ChoiceCard(
      icon: Icons.flag_outlined,
      title: l.setupChoiceFreshTitle,
      subtitle: l.setupChoiceFreshBody,
      onTap: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DiscoveryScreen()),
      ),
    );
    final existing = _ChoiceCard(
      icon: Icons.wifi_tethering,
      title: l.setupChoiceExistingTitle,
      subtitle: l.setupChoiceExistingBody,
      onTap: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const WifiDiscoveryScreen(),
        ),
      ),
    );

    // Mobil tek kolon stretch, desktop iki kolon yan yana ve toplam
    // genişlik SkContent içinde sınırlı tutulur. IntrinsicHeight iki
    // kartın yüksekliğini eşitler, biri uzun bir başlığa sahip olsa
    // bile farklı yüksekliklerle hizasız durmaz.
    final Widget choices = isDesktop
        ? IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: fresh),
                const SizedBox(width: 16),
                Expanded(child: existing),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              fresh,
              const SizedBox(height: 16),
              existing,
            ],
          );

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l.setupChoiceTitle),
      ),
      body: SafeArea(
        child: SkContent(
          maxWidth: 820,
          horizontalPadding: 24,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isDesktop ? 0 : 24,
              16,
              isDesktop ? 0 : 24,
              32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 5),
                Text(
                  l.setupChoiceQuestion,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  l.setupChoiceSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                choices,
                const Spacer(flex: 3),
                Text(
                  l.setupChoiceFooter,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SkNeuCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkNeuIconSlot(icon: icon, size: 44, iconSize: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
        ],
      ),
    );
  }
}
