import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/network/mdns_browser.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../core/ui/sk_yakinda_badge.dart';
import '../../l10n/app_localizations.dart';
import '../../core/storage/paired_devices_store.dart';
import 'data/action_binding.dart';
import 'data/script_manifest.dart';
import 'data/skapi_catalog.dart';
import 'data/skapi_i18n_lookup.dart';
import 'data/skapi_providers.dart';
import 'data/system_endpoint_sync_service.dart';
import 'data/user_script.dart';
import 'skapi_bind_screen.dart';
import '../devices/bf/bf_session.dart';
import 'on_device_api_editor_screen.dart';
import 'user_script_detail_screen.dart';
import 'user_script_editor_screen.dart';
import 'skapi_linux_distro_screen.dart';
import 'skapi_other_category_screen.dart';
import 'skapi_platform_screen.dart';
import 'skapi_script_detail_screen.dart';
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
                          _ActionsList(bindings: bindings),
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

/// Bindings listesi — "Aksiyonlarım" bölümü dolu olduğunda render edilir.
///
/// Cihaz başına gruplandırılmış: her grup bir [_DeviceActionGroup] (header
/// + collapsible body). Header'da cihaz adı + aksiyon sayısı + chevron;
/// gövdesi expand olduğunda o cihaza bağlı [_ActionRow]'ları gösterir.
///
/// Default state: tüm gruplar kapalı başlar (kullanıcı kararı). Sıralama
/// alfabetik (cihaz displayName'ine göre A→Z). Orphan binding'ler (paired
/// listede olmayan deviceId) listenin sonunda kendi grubuyla görünür.
class _ActionsList extends ConsumerStatefulWidget {
  const _ActionsList({required this.bindings});
  final List<ActionBinding> bindings;

  @override
  ConsumerState<_ActionsList> createState() => _ActionsListState();
}

class _ActionsListState extends ConsumerState<_ActionsList> {
  /// Açık grupların deviceId set'i. Tüm gruplar kapalı başlar; kullanıcı
  /// header'a tıklayarak açar/kapar. State sadece bu widget yaşadığı
  /// sürece tutulur (sekme değişiminde resetlenir, basitlik için).
  final Set<String> _expanded = <String>{};

  @override
  Widget build(BuildContext context) {
    final paired = ref.watch(pairedDevicesProvider);

    // Bindings'i deviceId'ye göre grupla.
    final byDevice = <String, List<ActionBinding>>{};
    for (final b in widget.bindings) {
      byDevice.putIfAbsent(b.deviceId, () => []).add(b);
    }

    // Cihaz adı çözücü: paired listede varsa displayName, yoksa raw id.
    String nameOf(String id) {
      for (final p in paired) {
        if (p.id == id) return p.displayName;
      }
      return id;
    }

    // Alfabetik sıralama (displayName, case-insensitive). Tie-break: id.
    final orderedIds = byDevice.keys.toList()
      ..sort((a, b) {
        final cmp =
            nameOf(a).toLowerCase().compareTo(nameOf(b).toLowerCase());
        return cmp != 0 ? cmp : a.compareTo(b);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < orderedIds.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _DeviceActionGroup(
            deviceId: orderedIds[i],
            deviceName: nameOf(orderedIds[i]),
            bindings: byDevice[orderedIds[i]]!,
            expanded: _expanded.contains(orderedIds[i]),
            onToggle: () => setState(() {
              if (_expanded.contains(orderedIds[i])) {
                _expanded.remove(orderedIds[i]);
              } else {
                _expanded.add(orderedIds[i]);
              }
            }),
          ),
        ],
      ],
    );
  }
}

/// Tek bir cihazın aksiyon grubu. Header tıklanabilir; tap → expand toggle.
/// Body kapalıyken çizilmez (height 0), açıkken yumuşak AnimatedSize ile
/// belirir.
class _DeviceActionGroup extends StatelessWidget {
  const _DeviceActionGroup({
    required this.deviceId,
    required this.deviceName,
    required this.bindings,
    required this.expanded,
    required this.onToggle,
  });

  final String deviceId;
  final String deviceName;
  final List<ActionBinding> bindings;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SkNeuCard(
      borderRadius: 14,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
            InkWell(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.skapiActionsGroupTitle(deviceName),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: cs.onSurface.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        l.skapiActionsGroupCount(bindings.length),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface.withValues(alpha: 0.65),
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    AnimatedRotation(
                      turns: expanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: expanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: cs.outlineVariant,
                        ),
                        // S2.6: two sub-sections inside each device group.
                        // "Local scripts" = Yapı 1 bindings (host-fired).
                        // "On-device API" = Yapı 2 endpoints (device-fired).
                        // Sub-headers only render when their list is
                        // non-empty so the card stays tight.
                        if (bindings.isNotEmpty) ...[
                          _SubSectionHeader(
                            label: l.skapiLocalScriptsSubheading,
                          ),
                          for (int i = 0; i < bindings.length; i++) ...[
                            if (i > 0)
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: cs.outlineVariant,
                              ),
                            _ActionRow(binding: bindings[i]),
                          ],
                        ],
                        _OnDeviceApiList(deviceId: deviceId),
                      ],
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
    );
  }
}

/// Mustard-tinted thin label that separates "Local scripts" and
/// "On-device API" sub-sections inside a [_DeviceActionGroup] body.
/// Plain text on a divider-thin background so it doesn't compete with
/// the device group's title.
class _SubSectionHeader extends StatelessWidget {
  const _SubSectionHeader({required this.label, this.action});
  final String label;

  /// Sağda render edilen küçük aksiyon (örn. refresh ikonu). Yoksa
  /// başlık satırı önceki gibi sadece label içerir.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final labelWidget = Text(
      label.toUpperCase(),
      style: GoogleFonts.jetBrainsMono(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: cs.onSurface.withValues(alpha: 0.55),
        letterSpacing: 0.6,
      ),
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14, action == null ? 8 : 2, 6, action == null ? 6 : 2),
      color: cs.onSurface.withValues(alpha: 0.03),
      child: action == null
          ? labelWidget
          : Row(
              children: [
                Expanded(child: labelWidget),
                action!,
              ],
            ),
    );
  }
}

/// "On-device API" sub-section list. Subscribes to
/// [onDeviceApiEndpointsProvider] for the device; renders one row per
/// USER slot. Hidden entirely when the device returns zero USER
/// endpoints (the sub-header doesn't even appear), so a device with
/// only Local scripts shows the original card unchanged.
///
/// Device offline / load error states render a small placeholder row
/// (not a hard error) so the parent group's Local scripts list stays
/// readable.
class _OnDeviceApiList extends ConsumerWidget {
  const _OnDeviceApiList({required this.deviceId});
  final String deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final endpointsAsync = ref.watch(onDeviceApiEndpointsProvider(deviceId));

    return endpointsAsync.when(
      loading: () => _OnDeviceApiPlaceholderRow(
        icon: Icons.sync_rounded,
        text: l.commonLoading,
      ),
      error: (e, _) => _OnDeviceApiPlaceholderRow(
        icon: Icons.error_outline_rounded,
        text: l.skapiOnDeviceApiLoadError,
      ),
      data: (endpoints) {
        if (endpoints.isEmpty) {
          // Empty branch covers BOTH "device online, no endpoints" and
          // "device offline" (provider returns []) — collapsed to a
          // single hidden state because Aksiyonlarım should not surface
          // a noisy "no endpoints" message when the user just hasn't
          // configured anything yet. The OnDeviceApiEditorScreen is
          // where they'd add one.
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SubSectionHeader(
              label: l.skapiOnDeviceApiSubheading,
              // Manual refresh: provider re-fetcher tetikler. Otomatik
              // polling YOK (cihaz pil tasarrufu); kullanıcı bir başka
              // SKAPP'tan veya CLI'dan endpoint eklediyse listeyi
              // güncellemek için bu ikona dokunur.
              action: IconButton(
                tooltip: l.commonRefresh,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                onPressed: () =>
                    ref.invalidate(onDeviceApiEndpointsProvider(deviceId)),
              ),
            ),
            for (int i = 0; i < endpoints.length; i++) ...[
              if (i > 0)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: cs.outlineVariant,
                ),
              _OnDeviceApiRow(
                endpoint: endpoints[i],
                onTap: () => _openEditor(context),
              ),
            ],
            // Hint footer: tapping any row drops the user into the
            // editor (full slot list view), not a single-endpoint
            // detail screen. The editor handles edit + delete from
            // there.
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
              child: Text(
                l.skapiOnDeviceApiRowHint,
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.45),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openEditor(BuildContext context) async {
    await BfSession.pushForDevice<void>(
      context: context,
      deviceId: deviceId,
      child: OnDeviceApiEditorScreen(
        deviceId: deviceId,
        titleKey: ApiEditorTitleKey.skapiEditor,
      ),
    );
  }
}

class _OnDeviceApiRow extends StatelessWidget {
  const _OnDeviceApiRow({required this.endpoint, required this.onTap});
  final OnDeviceApiSummary endpoint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
        child: Row(
          children: [
            Icon(
              Icons.cloud_outlined,
              color: cs.onSurface.withValues(alpha: 0.55),
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    endpoint.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${endpoint.method.toUpperCase()} · ${endpoint.url}',
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
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

class _OnDeviceApiPlaceholderRow extends StatelessWidget {
  const _OnDeviceApiPlaceholderRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Row(
        children: [
          Icon(icon, size: 14, color: cs.onSurface.withValues(alpha: 0.45)),
          const SizedBox(width: 8),
          Text(
            text,
            style: tt.labelSmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.55),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends ConsumerWidget {
  const _ActionRow({required this.binding});
  final ActionBinding binding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final paired = ref.watch(pairedDevicesProvider).firstWhere(
      (d) => d.id == binding.deviceId,
      orElse: () => PairedDevice(
        id: binding.deviceId,
        name: binding.deviceId,
        prefix: '??',
        pairedAt: DateTime.now(),
      ),
    );

    final manifestAsync = ref.watch(skapiScriptManifestProvider((
      platform: binding.platform,
      script: binding.scriptId,
    )));

    final syncRecord = ref.watch(systemEndpointSyncStateProvider)[
            binding.deviceId] ??
        SyncRecord.idle;

    return InkWell(
      onTap: () => _openEditor(context, ref, manifestAsync.value),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
        child: Row(
          children: [
            Icon(
              binding.enabled
                  ? Icons.flash_on_rounded
                  : Icons.flash_off_rounded,
              color: binding.enabled
                  ? SkColors.attentionMustard
                  : cs.onSurface.withValues(alpha: 0.40),
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    manifestAsync.when(
                      data: (m) => resolveSkapiI18nKey(l, m.i18nTitle),
                      loading: () => binding.scriptId,
                      error: (_, _) => binding.scriptId,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${paired.displayName} · ${binding.platform} · '
                    '${binding.scriptId}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.55),
                      fontFamily: 'monospace',
                    ),
                  ),
                  // Per-device sync status: did SKAPP successfully tell
                  // BF where to send the webhook? Issue 3 root cause —
                  // user kept thinking "binding kayıtlı" while BF had
                  // no SYSTEM slot. Badge surfaces this asymmetry.
                  if (syncRecord.status != SyncStatus.idle &&
                      syncRecord.status != SyncStatus.removed) ...[
                    const SizedBox(height: 4),
                    _SyncBadge(record: syncRecord),
                  ],
                ],
              ),
            ),
            SkNeuSwitch(
              value: binding.enabled,
              onChanged: (v) async {
                await ref
                    .read(bindingsProvider.notifier)
                    .setEnabled(binding.id, v);
              },
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref,
    ScriptManifest? manifest,
  ) async {
    if (manifest == null) {
      // Manifest henüz yüklenmedi (offline veya asset eksik). Boş tap
      // sessiz no-op değil, kullanıcı geri bildirim alsın.
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(l.skapiManifestLoadingRetry(
              binding.platform, binding.scriptId), textAlign: TextAlign.center),
        ));
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SkapiBindScreen(
          manifest: manifest,
          existing: binding,
        ),
      ),
    );
  }
}



/// Per-row chip showing whether SKAPP has pushed the webhook URL onto
/// the device's SYSTEM slot. Three meaningful colors:
///   pending → mustard "BF'ye yazılıyor"
///   ok      → faint green "BF'ye kayıtlı"
///   failed  → warn-red with the firmware error string + tooltip
/// idle / removed states render nothing (caller filters them).
class _SyncBadge extends StatelessWidget {
  const _SyncBadge({required this.record});
  final SyncRecord record;

  /// Resolves an `errorReason` from [SystemEndpointSyncService] to a
  /// localized string. Sentinels in [SyncErrReason] map to ARB entries;
  /// anything else (raw firmware code, truncated exception message) is
  /// passed through as-is.
  String _translateReason(AppLocalizations l, String reason) {
    switch (reason) {
      case SyncErrReason.unknownCommand:
        return l.syncErrUnknownCommand;
      case SyncErrReason.notAuthenticated:
        return l.syncErrNotAuthenticated;
      case SyncErrReason.notFound:
        return l.syncErrNotFound;
      case SyncErrReason.internal:
        return l.syncErrInternal;
      case SyncErrReason.unknown:
        return l.syncErrUnknown;
      case SyncErrReason.timeout:
        return l.syncErrTimeout;
      case SyncErrReason.noBond:
        return l.syncErrNoBond;
      case SyncErrReason.connect:
        return l.syncErrConnect;
      default:
        return reason;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final l = AppLocalizations.of(context);
    Color bg;
    Color fg;
    IconData icon;
    String text;
    String? tooltip;

    switch (record.status) {
      case SyncStatus.pending:
        bg = SkColors.attentionMustard.withValues(alpha: 0.18);
        fg = SkColors.attentionMustard;
        icon = Icons.sync_rounded;
        text = l.skapiSyncBadgeWriting;
        break;
      case SyncStatus.ok:
        bg = const Color(0xFF2E7D32).withValues(alpha: 0.16);
        fg = const Color(0xFF2E7D32);
        icon = Icons.cloud_done_rounded;
        text = l.skapiSyncBadgeWritten;
        break;
      case SyncStatus.failed:
        bg = SkColors.warnRed.withValues(alpha: 0.16);
        fg = SkColors.warnRed;
        icon = Icons.warning_amber_rounded;
        text = record.errorReason == null
            ? l.skapiSyncBadgeFailed
            : _translateReason(l, record.errorReason!);
        tooltip = record.errorCode == null
            ? null
            : l.skapiSyncBadgeFirmwareCodeTooltip(record.errorCode!);
        break;
      case SyncStatus.idle:
      case SyncStatus.removed:
        return const SizedBox.shrink();
    }

    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tt.labelSmall?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return tooltip == null ? chip : Tooltip(message: tooltip, child: chip);
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
