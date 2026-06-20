import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/network/mdns_browser.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../core/ui/sk_yakinda_badge.dart';
import '../../l10n/app_localizations.dart';
import 'data/script_manifest.dart';
import 'data/skapi_catalog.dart';
import 'data/skapi_i18n_lookup.dart';
import 'data/skapi_providers.dart';
import 'data/user_script.dart';
import 'user_script_detail_screen.dart';
import 'user_script_editor_screen.dart';
import 'skapi_linux_distro_screen.dart';
import 'skapi_other_category_screen.dart';
import 'skapi_platform_screen.dart';
import 'skapi_script_detail_screen.dart';
import 'widgets/skapi_action_list.dart';
import 'widgets/skapi_help_sheet.dart';
import 'widgets/skapi_platform_icon.dart';

/// SKAPI sekmesi · laptop_s5.html "optimize A" düzeni.
///
/// Ust→alt sırası: Header bar (SKAPI + sub + "+ Yeni Aksiyon" pill) →
/// **Kütüphane** (4 platform yatay tek sıra; mobile'da 2×2 grid; host
/// platform mustard chip ile vurgulanır) → **Yıldızlı** (slim dashed
/// empty) → **Aksiyonlarım** (solid empty + mustard "+ Oluştur" CTA) →
/// **Topluluk** (dashed footer kart + "yakında" rozeti).
///
/// Mevcut akışlar bu restructure'da bozulmadı: platform tap [SkapiPlatform
/// Screen]'e push, Linux ayrıca [SkapiLinuxDistroScreen]'e push, mobile
/// "+" pill ve "Oluştur" CTA snackbar (yakında) gösterir, gerçek aksiyon
/// editörü Faz E'de inecek.
class SkapiScreen extends ConsumerWidget {
  const SkapiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    ref.watch(mdnsBrowserProvider);

    final bindings = ref.watch(bindingsProvider);
    final actionCount = bindings.length;
    final platforms = kSkapiPlatforms.length;
    final favourites = ref.watch(favouriteScriptsProvider);
    final starredAsync = ref.watch(starredScriptsProvider);
    final userScripts = ref.watch(userScriptsProvider);

    return Scaffold(
      // V2 tactile: tema scaffold bg'sini kullanır (light=cream,
      // dark=darkBg). Hard-coded override kaldırıldı; SkNeuCard well
      // primitifi Theme.scaffoldBackgroundColor'dan zemin alıyor,
      // burası ile birebir eşleşsin diye.
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              subLine: l.skapiHeaderSub(platforms, actionCount),
              onAdd: () => _onAddNewAction(context, ref),
              onInfo: () => showSkapiHelpSheet(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                // Bottom 18 = inter-card gap; SafeArea zaten nav inset'i
                // consume etti, son içerik nav pill üstünden 18 px yukarıda.
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                child: Center(
                  child: ConstrainedBox(
                    // SKAPI içerik genişliği Settings ile eşit (820 px).
                    // Önceki 980, geniş ekranda 4 platform kartı sığsın
                    // diye genişti; platform filtresiyle artık 2 kart
                    // kaldı ve daha dar konteyner uyumlu.
                    constraints:
                        const BoxConstraints(maxWidth: 820),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // BF webhook listener health banner 2026-05-15'te
                        // kaldırıldı (Görev 3). Kullanıcı dev-diagnostic'in
                        // SKAPI ekranını yorduğunu bildirdi; banner +
                        // _ListenerEndpointCard + _BfEndpointsDialog
                        // komple silindi.
                        _SectionHeading(
                          title: l.skapiLibraryHeading,
                          subtitle: _libraryHostSub(l),
                        ),
                        const SizedBox(height: 8),
                        const _PlatformRow(),
                        const SizedBox(height: 16),
                        _SectionHeading(
                          title: l.skapiStarredHeading,
                          subtitle: l.skapiStarredCount(favourites.length),
                        ),
                        const SizedBox(height: 8),
                        _StarredSection(
                          favouriteCount: favourites.length,
                          starredAsync: starredAsync,
                        ),
                        const SizedBox(height: 16),
                        _SectionHeading(
                          title: l.skapiUserSectionHeading,
                          subtitle: l.skapiUserSectionSub(userScripts.length),
                        ),
                        const SizedBox(height: 8),
                        _UserScriptsSection(scripts: userScripts),
                        const SizedBox(height: 16),
                        _SectionHeading(
                          title: l.skapiActionsHeading,
                          subtitle: l.skapiActionsSubLine(actionCount),
                        ),
                        const SizedBox(height: 8),
                        // Faz C bug fix: header "N aktif" diyordu ama bu bölüm
                        // her zaman empty placeholder'ı gösteriyordu. Şimdi
                        // gerçek bindings listelenir; tap düzenleme ekranını
                        // açar. Boşken placeholder geri gelir.
                        if (bindings.isEmpty)
                          _ActionsEmpty(
                            hintText: l.skapiActionsEmptyHint,
                            ctaLabel: l.skapiActionsCreateCta,
                            onCta: () => _onAddNewAction(context, ref),
                          )
                        else
                          SkapiActionList(bindings: bindings),
                        // _ListenerEndpointCard 2026-05-15'te kaldırıldı:
                        // BF webhook URL kartı, "Kendini test et" ve
                        // "BF endpoints göster" butonları SKAPI'yi dev-
                        // diagnostic ekranına çeviriyordu. Son kullanıcı
                        // odaklı kütüphane + aksiyonlarım görünümü kaldı.
                        const SizedBox(height: 16),
                        _ContributeFooter(
                          title: l.skapiCommunityShareTitle,
                          body: l.skapiCommunityShareBody,
                          badgeText: l.comingSoonBadge,
                          onTap: () => _showComingSoon(context, l),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _libraryHostSub(AppLocalizations l) {
    final hostId = hostSkapiPlatformId();
    if (hostId == null) {
      return '${kSkapiPlatforms.length} platform';
    }
    // "{n} platform · bu bilgisayar {host}"
    final hostLabel = _platformLabelById(l, hostId);
    return '${kSkapiPlatforms.length} platform · ${l.skapiThisComputer.toLowerCase()} $hostLabel';
  }

  void _showComingSoon(BuildContext context, AppLocalizations l) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l.featureComingSoonSnack, textAlign: TextAlign.center),
        duration: const Duration(seconds: 2),
      ));
  }

  /// Entry point for the "+ Yeni Aksiyon" pill (header) and the "+ Oluştur"
  /// CTA (Aksiyonlar empty state). Device-independent: opens the user-script
  /// editor so the user authors a new script and adds it to the SKAPI library
  /// ("Benim Script'lerim"). Per-device actions are configured inside each
  /// device's own screens, not here.
  void _onAddNewAction(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const UserScriptEditorScreen()),
    );
  }
}

/// "Benim Script'lerim" list: user-authored scripts from
/// [userScriptsProvider]. Tap opens the read/run/edit detail. Empty shows a
/// short hint pointing at the "Yeni Aksiyon" pill.
class _UserScriptsSection extends StatelessWidget {
  const _UserScriptsSection({required this.scripts});
  final List<UserScript> scripts;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    if (scripts.isEmpty) {
      return SkNeuCard(
        padding: const EdgeInsets.all(16),
        child: Text(
          l.skapiUserEmptyHint,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: cs.onSurfaceVariant),
        ),
      );
    }
    return SkNeuCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (int i = 0; i < scripts.length; i++) ...[
            if (i > 0)
              Divider(height: 1, thickness: 0.5, color: cs.outlineVariant),
            ListTile(
              leading:
                  Icon(Icons.description_outlined, color: cs.onSurfaceVariant),
              title: Text(scripts[i].title),
              subtitle: scripts[i].description.trim().isEmpty
                  ? null
                  : Text(
                      scripts[i].description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      UserScriptDetailScreen(scriptId: scripts[i].id),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.subLine,
    required this.onAdd,
    required this.onInfo,
  });

  final String subLine;
  final VoidCallback onAdd;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? SkColors.darkFg : SkColors.black;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 14, 12),
      decoration: BoxDecoration(
        // V2 tactile: header bar zemini tema scaffold bg'siyle aynı (well
        // primitifin zemini ile birebir eşleşsin). Alt hairline border
        // sub-line ile body arasında ince ayırıcı sağlar.
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: fg.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.skapiTitle,
                  style: GoogleFonts.inter(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: fg,
                    letterSpacing: -0.3,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subLine,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: fg.withValues(alpha: 0.55),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l.skapiHelpButtonTooltip,
            icon: Icon(
              Icons.info_outline,
              color: fg.withValues(alpha: 0.55),
            ),
            onPressed: onInfo,
          ),
          const SizedBox(width: 4),
          _NewActionPill(label: l.skapiNewActionPill, onTap: onAdd),
        ],
      ),
    );
  }
}

class _NewActionPill extends StatelessWidget {
  const _NewActionPill({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pillBg = isDark ? SkColors.cream : SkColors.black;
    final pillFg = isDark ? SkColors.black : SkColors.cream;
    final dotBg = isDark ? SkColors.black : SkColors.cream;
    final dotFg = isDark ? SkColors.cream : SkColors.black;
    return Material(
      color: pillBg,
      borderRadius: BorderRadius.circular(99),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(7, 7, 16, 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: dotBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '+',
                  style: TextStyle(
                    color: dotFg,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: pillFg,
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

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? SkColors.darkFg : SkColors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: -0.3,
            ),
          ),
          if (subtitle != null) ...[
            const Spacer(),
            Text(
              subtitle!,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: fg.withValues(alpha: 0.55),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Platform kartları:
///   * Desktop: 4 kart yatay tek sıra (mac/win/lx/other).
///   * Mobile (Android/iOS): SADECE "other" (IoT cihaz scriptleri).
///     Mac/Win/Lx kartları kaldırıldı, çünkü SKAPP paradigması
///     "APP = sadece config; telefon laptop'a komut göndermez"
///     (Faz B kararı). `runRemote` da mobile'dan kaldırıldı, dolayısıyla
///     bu kartlar tıklansa bile çalıştırılacak akış yok.
class _PlatformRow extends StatelessWidget {
  const _PlatformRow();

  @override
  Widget build(BuildContext context) {
    final compact = !context.isDesktop;
    final hostId = hostSkapiPlatformId();

    if (compact) {
      // Mobile: yalnız "other" (IoT) kartı.
      // Telefonun script-tetik kullanımı artık Cihazlarım sekmesindeki
      // desktop kartından doğrudan yapılıyor (tıklama → "SKAPI komutu
      // gönderilsin mi?" onayı → emitEvent). Bu sayede SKAPI tab'ı
      // saf kütüphane görüntüleme + IoT'a indirgenmiş kalır.
      final iot = kSkapiPlatforms.firstWhere(
        (p) => p.id == 'other',
        orElse: () => kSkapiPlatforms.first,
      );
      return _PlatformCompactCard(platform: iot, isHost: false);
    }

    // Desktop: yatay tek sıra. Host platform + 'other' (IoT) kartları
    // gösterilir; diğer desktop platformları (örn Win'deyken Mac/Linux)
    // gizlenir — kullanıcı zaten o platformun üstünde değil, kütüphaneye
    // gerek yok. Eğer host belirlenmediyse (kapsam dışı bir desktop OS),
    // güvenli fallback: tüm kartları göster.
    final cards = [
      for (final p in kSkapiPlatforms)
        if (hostId == null || p.id == hostId || p.id == 'other')
          _PlatformCompactCard(platform: p, isHost: p.id == hostId),
    ];
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(width: 9),
            Expanded(child: cards[i]),
          ],
        ],
      ),
    );
  }
}

class _PlatformCompactCard extends StatelessWidget {
  const _PlatformCompactCard({
    required this.platform,
    required this.isHost,
  });

  final SkapiPlatformSpec platform;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? SkColors.darkFg : SkColors.black;

    return SkNeuCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => switch (platform.id) {
            'lx' => const SkapiLinuxDistroScreen(),
            'other' => const SkapiOtherCategoryScreen(),
            _ => SkapiPlatformScreen(platform: platform),
          },
        ),
      ),
      borderRadius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Stack(
        children: [
          Row(
            children: [
              // Raised icon slot · custom Container (SkNeuIconSlot IconData
              // alıyor ama SkapiPlatformIcon kendi widget'ını render ediyor,
              // bu yüzden manuel raised slot stilini koruyoruz). Boyut +
              // gölge ölçüleri SkNeuIconSlot ile birebir eşleşmiş.
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.white.withValues(alpha: 0.90),
                      offset: const Offset(-2, -2),
                      blurRadius: 3,
                    ),
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.55)
                          : Colors.black.withValues(alpha: 0.16),
                      offset: const Offset(2, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: SkapiPlatformIcon(platform: platform),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _platformLabelById(l, platform.id),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isHost ? SkColors.attentionMustard : fg,
                        letterSpacing: -0.2,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      _hint(platform.id),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                        color: fg.withValues(alpha: 0.55),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isHost)
            Positioned(
              top: 0,
              right: 0,
              child: _HostBadge(text: l.skapiThisComputer),
            ),
        ],
      ),
    );
  }

  String _hint(String id) {
    switch (id) {
      case 'lx':
        return 'deb · arch';
      case 'other':
        return 'esp32';
      default:
        return id;
    }
  }
}

class _HostBadge extends StatelessWidget {
  const _HostBadge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: SkColors.attentionMustard,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text.toUpperCase(),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: SkColors.attentionMustard,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}

/// Renders the "Yıldızlı APIler" body. Three branches:
///   * favourites empty            → dashed slim placeholder (existing copy)
///   * manifest load in progress   → 1-line linear progress
///   * manifests resolved          → bordered list of compact rows
///
/// `_StarredCompactRow` is the inline tile: mustard star (tap to unstar),
/// translated title + raw id (mono), chevron, tap-to-detail. Same row
/// across both themes since `cs.surfaceContainerLow` + `cs.outlineVariant`
/// adapt automatically.
class _StarredSection extends ConsumerWidget {
  const _StarredSection({
    required this.favouriteCount,
    required this.starredAsync,
  });

  final int favouriteCount;
  final AsyncValue<List<ScriptManifest>> starredAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    if (favouriteCount == 0) {
      return _SlimEmpty(
        icon: Icons.star_border_rounded,
        text: l.skapiStarredSlimEmpty,
      );
    }
    return starredAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(minHeight: 2),
      ),
      error: (e, _) => _SlimEmpty(
        icon: Icons.error_outline_rounded,
        text: '$e',
      ),
      data: (scripts) {
        if (scripts.isEmpty) {
          // Stored keys all resolved to missing assets, behave like empty.
          return _SlimEmpty(
            icon: Icons.star_border_rounded,
            text: l.skapiStarredSlimEmpty,
          );
        }
        final cs = Theme.of(context).colorScheme;
        return SkNeuCard(
          borderRadius: 14,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (int i = 0; i < scripts.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: cs.outlineVariant,
                  ),
                _StarredCompactRow(script: scripts[i]),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StarredCompactRow extends ConsumerWidget {
  const _StarredCompactRow({required this.script});

  final ScriptManifest script;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final title = resolveSkapiI18nKey(l, script.i18nTitle);

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SkapiScriptDetailScreen(manifest: script),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
        child: Row(
          children: [
            IconButton(
              tooltip: l.skapiFavouriteRemoveTooltip,
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.star_rounded,
                color: SkColors.attentionMustard,
              ),
              onPressed: () => ref
                  .read(favouriteScriptsProvider.notifier)
                  .toggle(script.platform, script.id),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '${script.platform} · ${script.id}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.55),
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _SlimEmpty extends StatelessWidget {
  const _SlimEmpty({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? SkColors.darkFg : SkColors.black;
    return SkNeuCard(
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      child: Row(
        children: [
          Icon(icon, size: 16, color: fg.withValues(alpha: 0.40)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: fg.withValues(alpha: 0.65),
                letterSpacing: -0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsEmpty extends StatelessWidget {
  const _ActionsEmpty({
    required this.hintText,
    required this.ctaLabel,
    required this.onCta,
  });

  final String hintText;
  final String ctaLabel;
  final VoidCallback onCta;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? SkColors.darkFg : SkColors.black;
    return SkNeuCard(
      borderRadius: 14,
      padding: const EdgeInsets.fromLTRB(14, 11, 11, 11),
      child: Row(
        children: [
          Icon(
            Icons.link_rounded,
            size: 20,
            color: fg.withValues(alpha: 0.40),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              hintText,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: fg.withValues(alpha: 0.65),
                letterSpacing: -0.1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: SkColors.attentionMustard,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: onCta,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(11, 7, 13, 7),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '+',
                      style: TextStyle(
                        color: SkColors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      ctaLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: SkColors.black,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContributeFooter extends StatelessWidget {
  const _ContributeFooter({
    required this.title,
    required this.body,
    required this.badgeText,
    required this.onTap,
  });

  final String title;
  final String body;
  final String badgeText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? SkColors.darkFg : SkColors.black;
    return SkNeuCard(
      onTap: onTap,
      borderRadius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          Icon(
            Icons.upload_rounded,
            size: 18,
            color: fg.withValues(alpha: 0.65),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: fg,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                    color: fg.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SkYakindaBadge(label: badgeText),
        ],
      ),
    );
  }
}

String _platformLabelById(AppLocalizations l, String id) {
  switch (id) {
    case 'mac':
      return l.skapiPlatformMac;
    case 'win':
      return l.skapiPlatformWin;
    case 'lx':
      return l.skapiPlatformLinux;
    case 'other':
      return l.skapiPlatformOther;
  }
  return id;
}
