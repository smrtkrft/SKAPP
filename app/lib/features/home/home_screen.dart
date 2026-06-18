import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_info/version_provider.dart';
import '../../core/network/mdns_browser.dart';
import '../../core/storage/paired_devices_store.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/responsive.dart';
import '../../l10n/app_localizations.dart';
import '../skapi/data/skapi_providers.dart';

/// SmartKraft ana sayfa.
///
/// Adaptif layout: ekran boyutu sabit pixel'lere bağlı değil.
///   * Logo, body'nin tüm arka planında watermark olarak yer alır
///     ([_BodyWatermark]); boyutu `max(width, height) * 1.2` ile ekrana
///     orantılı, sabit 960 px değil.
///   * Desktop (width >= 900): brand `Expanded` ile boş dikey alanı yer,
///     ürünler ve topluluk altta sabit. 768 laptop → 4K monitör arası
///     her yükseklikte scroll'suz sığar.
///   * Mobil (width < 900): hero, viewport yüksekliğini tam doldurur;
///     alt kartlar scroll ile gelir. Her telefon ekranında aynı davranış.
///
/// Stat sayıları her zaman canlı state'ten gelir, mock kullanılmaz.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // mDNS taramasını canlı tut: her tarama PairedDevice.lastSeen'i tazeler,
    // "aktif cihaz" sayımız bu kanaldan beslenir.
    ref.watch(mdnsBrowserProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      // Tactile redesign zemin tutarlılığı: Settings + SKAPI ile aynı krem.
      // SmartKraft brand içeriği (logo + SKAPP + sarı content) bozulmadı,
      // sadece scaffold zemini tema krem'ine hizalandı.
      backgroundColor:
          isDark ? const Color(0xFF0E0D0A) : SkColors.cream,
      body: const SafeArea(child: _SmartKraftBody()),
    );
  }
}

const Duration _activeFreshness = Duration(seconds: 90);

bool _activeFor(PairedDevice d) {
  final ls = d.lastSeen;
  if (ls == null) return false;
  return DateTime.now().difference(ls) < _activeFreshness;
}

class _SmartKraftBody extends ConsumerWidget {
  const _SmartKraftBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paired = ref.watch(pairedDevicesProvider);
    final bindings = ref.watch(bindingsProvider);
    final versionAsync = ref.watch(appVersionProvider);

    // Ana sayfa "Toplam Cihaz / Aktif" sayacı yalnız SK cihazlarını
    // (BF, LS, ...) gösterir. Mobil peer'lar (prefix MS) telefon olarak
    // ayrı kategoridir; online/offline takipleri yapılmadığı için sayaca
    // dahil edilmezler.
    final skDevices = paired.where((d) => !d.isMobilePeer).toList();
    final total = skDevices.length;
    final active = skDevices.where(_activeFor).length;
    final actionCount = bindings.length;
    final version = versionAsync.maybeWhen(
      data: (v) => v,
      orElse: () => '·',
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop eşiği responsive.dart ile aynı (>= 900). Altında telefon/
        // küçük pencere kuralları (hero = viewport, scroll'lu); üstünde
        // tek-ekran kuralı (no-scroll).
        final isDesktop = constraints.maxWidth >= 900;
        return Stack(
          children: [
            Positioned.fill(
              child: _BodyWatermark(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              ),
            ),
            Positioned.fill(
              child: isDesktop
                  ? _DesktopLayout(
                      total: total,
                      active: active,
                      actionCount: actionCount,
                      version: version,
                    )
                  : _MobileLayout(
                      total: total,
                      active: active,
                      actionCount: actionCount,
                      version: version,
                      viewportHeight: constraints.maxHeight,
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Body-level watermark: tüm HomeScreen body'sinin arka planı.
//
// Boyut formülü: `max(width, height) * 1.2`. Ekranın en uzun kenarının
// %120'si kare logo → her pencere boyutunda logo "dolu" hisseder, mockup'taki
// %60 görünür/frame oranı yaklaşık olarak korunur. Sabit 960 px değil.
//
// Konum: logo merkezi body'nin %15'inde (mockup ~%10, %15 brand pencere
// merkezindeyken brand'in logo içinde kalmasını sağlar). Dikey ortalı.
// ---------------------------------------------------------------------------

class _BodyWatermark extends StatelessWidget {
  const _BodyWatermark({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final asset = isDark
        ? 'assets/branding/logo_white.png'
        : 'assets/branding/logo_black.png';
    final opacity = isDark ? 0.10 : 0.12;

    // Logo boyutu: pencere yüksekliğinin 1.3 katı kare. `max(w,h) * 1.2`
    // yerine `height * 1.3` kullanıldı çünkü genişliğe bağlı formül ultra-
    // geniş pencerede logoyu duvar kağıdı kadar dominant yapıyordu. Yüksek-
    // liğe sabitlemek görsel yoğunluğu pencere oranı ne olursa olsun
    // dengeli tutar.
    final logoSize = height * 1.3;
    // +80 px ofset = logoyu sağa kaydır
    final logoCenterX = width * 0.15 + 80;
    // -10° saat yönü tersine (Flutter pozitif açı = saat yönü, negatif = ters)
    const logoRotation = -10 * math.pi / 180;

    return IgnorePointer(
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              left: logoCenterX - logoSize / 2,
              top: (height - logoSize) / 2,
              width: logoSize,
              height: logoSize,
              child: Transform.rotate(
                angle: logoRotation,
                child: Opacity(
                  opacity: opacity,
                  child: Image.asset(
                    asset,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Desktop layout: scroll YOK.
//
// Brand `Expanded` ile dikey kalan alanı yer, ürünler + topluluk altta
// sabit. Pencere yüksekliği ne olursa olsun (768 / 1080 / 1440 / 2160)
// tüm içerik tek ekrana sığar; brand'in çevresindeki boşluk pencereye
// göre genişler veya daralır.
// ---------------------------------------------------------------------------

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.total,
    required this.active,
    required this.actionCount,
    required this.version,
  });

  final int total;
  final int active;
  final int actionCount;
  final String version;

  @override
  Widget build(BuildContext context) {
    // Layout kuralları:
    //   1. Inter-card gap (Ürünler→İletişim) = 18 px
    //   2. İletişim altı → nav pill üst kenarı = aynı 18 px (Column SafeArea
    //      içinde, en alttaki SizedBox(18) tam nav pill üzerine değer)
    //   3. Cards ekranın altına itilir, üst kalan alana hero ortalanır
    //   4. Hero ÜST EMPTY alanın dikey merkezinde, tüm sayfanın değil
    return FractionallySizedBox(
      widthFactor: 0.83,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Üst boş alan: hero bu alanın dikey ortasında
            Expanded(
              child: Center(
                child: _BrandBlock(
                  total: total,
                  active: active,
                  actionCount: actionCount,
                  version: version,
                  size: _BrandSize.desktop,
                ),
              ),
            ),
            // Cards bloğu (alta sabit)
            const _ProductsSection(),
            const SizedBox(height: 18),
            const _CommunitySection(),
            // Cards altı → nav pill üstü (inter-card ile aynı)
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mobil layout: hero (brand block) viewport'u tam doldurur.
//
// Kural: kullanıcı uygulamayı açtığında ürünler ve topluluk kartları
// görünmemeli, scroll ile gelmeli. Hero yüksekliği `constraints.maxHeight`
// olarak verilir → her telefon ekranında doğru çalışır (320 px iPhone SE
// ile 932 px iPhone 17 Pro Max arası).
// ---------------------------------------------------------------------------

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.total,
    required this.active,
    required this.actionCount,
    required this.version,
    required this.viewportHeight,
  });

  final int total;
  final int active;
  final int actionCount;
  final String version;
  final double viewportHeight;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: viewportHeight,
            child: Center(
              child: _BrandBlock(
                total: total,
                active: active,
                actionCount: actionCount,
                version: version,
                size: _BrandSize.mobile,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                SizedBox(height: 24),
                _ProductsSection(),
                SizedBox(height: 18),
                _CommunitySection(),
                SizedBox(height: 96),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Brand block · "SKAPP" + "SmartKraft" handwriting + 4-stat pill
// ---------------------------------------------------------------------------

enum _BrandSize { desktop, mobile }

class _BrandBlock extends StatelessWidget {
  const _BrandBlock({
    required this.total,
    required this.active,
    required this.actionCount,
    required this.version,
    required this.size,
  });

  final int total;
  final int active;
  final int actionCount;
  final String version;
  final _BrandSize size;

  @override
  Widget build(BuildContext context) {
    final isDesktop = size == _BrandSize.desktop;
    final markSize = isDesktop ? 104.0 : 66.0;
    final handSize = isDesktop ? 48.0 : 32.0;
    final handRot = isDesktop ? -4.0 : -4.0;
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'SKAPP',
          style: GoogleFonts.spaceGrotesk(
            fontSize: markSize,
            fontWeight: FontWeight.w800,
            color: fg,
            letterSpacing: isDesktop ? -3.2 : -2.8,
            height: 0.92,
          ),
        ),
        const SizedBox(height: 4),
        Transform.rotate(
          angle: handRot * math.pi / 180,
          child: Text(
            'SmartKraft',
            style: GoogleFonts.caveat(
              fontSize: handSize,
              fontWeight: FontWeight.w600,
              color: SkColors.attentionMustard,
              letterSpacing: -0.5,
              height: 1.0,
            ),
          ),
        ),
        SizedBox(height: isDesktop ? 18 : 18),
        _StatGrid(
          total: total,
          active: active,
          actionCount: actionCount,
          version: version,
          size: size,
          totalLabel: l.homeBrandTotal,
          activeLabel: l.homeBrandActive,
          actionsLabel: l.homeBrandActions,
          versionLabel: l.homeBrandVersion,
        ),
      ],
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({
    required this.total,
    required this.active,
    required this.actionCount,
    required this.version,
    required this.size,
    required this.totalLabel,
    required this.activeLabel,
    required this.actionsLabel,
    required this.versionLabel,
  });

  final int total;
  final int active;
  final int actionCount;
  final String version;
  final _BrandSize size;
  final String totalLabel;
  final String activeLabel;
  final String actionsLabel;
  final String versionLabel;

  @override
  Widget build(BuildContext context) {
    final isDesktop = size == _BrandSize.desktop;
    final hPad = isDesktop ? 16.0 : 11.0;
    final valueSize = isDesktop ? 22.0 : 17.0;
    final labelSize = isDesktop ? 9.5 : 8.5;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;

    Widget cell(String value, String label) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: GoogleFonts.jetBrainsMono(
                fontSize: valueSize,
                fontWeight: FontWeight.w700,
                color: fg,
                letterSpacing: -0.3,
                height: 1.0,
              ),
            ),
            SizedBox(height: isDesktop ? 4 : 2),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: labelSize,
                fontWeight: FontWeight.w600,
                color: fg.withValues(alpha: 0.55),
                letterSpacing: 0.4,
                height: 1.0,
              ),
            ),
          ],
        ),
      );
    }

    Widget sep() => Container(
          width: 1,
          height: isDesktop ? 32 : 26,
          color: fg.withValues(alpha: 0.12),
          margin: EdgeInsets.symmetric(vertical: isDesktop ? 5 : 3),
        );

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 10 : 8,
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: isDesktop ? 0.06 : 0.10)
            : Colors.white.withValues(alpha: isDesktop ? 0.55 : 0.65),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fg.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          cell(total.toString(), totalLabel),
          sep(),
          cell(active.toString(), activeLabel),
          sep(),
          cell(actionCount.toString(), actionsLabel),
          sep(),
          cell('v$version', versionLabel),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Products section · 3 minimal ticket kart
// ---------------------------------------------------------------------------

enum _ProductStatus { live, dev, concept }

class _Product {
  const _Product({
    required this.name,
    required this.glyph,
    required this.status,
    required this.tagline,
  });

  final String name;
  final String glyph;
  final _ProductStatus status;
  final String tagline;
}

class _ProductsSection extends StatelessWidget {
  const _ProductsSection();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDesktop = context.isDesktop;
    final products = [
      _Product(
        name: 'Blocking Focus',
        glyph: '◐',
        status: _ProductStatus.live,
        tagline: l.smartkraftBlockingFocusTagline,
      ),
      _Product(
        name: 'LebensSpur',
        glyph: '≋',
        status: _ProductStatus.dev,
        tagline: l.smartkraftLebensSpurTagline,
      ),
      _Product(
        name: 'SynDimm',
        glyph: '✦',
        status: _ProductStatus.concept,
        tagline: l.smartkraftSynDimmTagline,
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isDesktop)
          // IntrinsicHeight zorunlu: Row(crossAxisAlignment.stretch) +
          // unbounded vertical = release modunda silent fail. IntrinsicHeight
          // Row'a bounded vertical sağlar, 3 kart aynı yüksekliğe oturur.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < products.length; i++) ...[
                  Expanded(child: _ProductCard(product: products[i])),
                  if (i < products.length - 1) const SizedBox(width: 12),
                ],
              ],
            ),
          )
        else
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < products.length; i++) ...[
                _ProductCard(product: products[i]),
                if (i < products.length - 1) const SizedBox(height: 8),
              ],
            ],
          ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final _Product product;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;
    final cardBg = isDark ? const Color(0xFF1A1814) : const Color(0xFFFFFEFA);
    final stripeColor = fg.withValues(alpha: 0.08);
    final glyphColor = fg.withValues(alpha: 0.60);

    final statusLabel = switch (product.status) {
      _ProductStatus.live => l.smartkraftStatusLive,
      _ProductStatus.dev => l.smartkraftStatusDev,
      _ProductStatus.concept => l.smartkraftStatusConcept,
    };
    final statusBg = switch (product.status) {
      _ProductStatus.live => SkColors.attentionMustard.withValues(alpha: 0.22),
      _ProductStatus.dev => fg.withValues(alpha: 0.08),
      _ProductStatus.concept => fg.withValues(alpha: 0.08),
    };
    final statusFg = switch (product.status) {
      _ProductStatus.live => const Color(0xFF7A5A06),
      _ProductStatus.dev => fg.withValues(alpha: 0.72),
      _ProductStatus.concept => fg.withValues(alpha: 0.60),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: fg.withValues(alpha: 0.12)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8 + 14, 12, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 32,
                    child: Center(
                      child: Text(
                        product.glyph,
                        style: TextStyle(
                          fontSize: 22,
                          color: glyphColor,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                product.name,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: fg,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: statusBg,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                statusLabel,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w700,
                                  color: statusFg,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.tagline,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.5,
                            color: fg.withValues(alpha: 0.72),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 8,
              child: ColoredBox(color: stripeColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Community section · 5 sosyal medya kartı
// URL'ler ve label'lar [about_screen.dart] ile bire bir aynı kalır.
// ---------------------------------------------------------------------------

const _websiteUrl = 'https://smartkraft.ch';
const _githubUrl = 'https://github.com/smrtkrft';
const _email = 'code@smartkraft.ch';
const _xUrl = 'https://x.com/SmartKraftLabs';
const _youtubeUrl = 'https://www.youtube.com/@SmartKraftLabs';

class _CommunitySection extends StatelessWidget {
  const _CommunitySection();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDesktop = context.isDesktop;

    final entries = <_SocialEntry>[
      _SocialEntry(
        label: l.aboutConnectWebsite,
        icon: Icons.public_rounded,
        onTap: () => _open(_websiteUrl),
      ),
      _SocialEntry(
        label: l.aboutConnectGitHub,
        icon: Icons.code_rounded,
        onTap: () => _open(_githubUrl),
      ),
      _SocialEntry(
        label: l.aboutConnectEmail,
        icon: Icons.mail_outline_rounded,
        onTap: () => _open('mailto:$_email'),
      ),
      _SocialEntry(
        label: l.aboutConnectX,
        icon: Icons.alternate_email_rounded,
        onTap: () => _open(_xUrl),
      ),
      _SocialEntry(
        label: l.aboutConnectYouTube,
        icon: Icons.play_circle_outline_rounded,
        onTap: () => _open(_youtubeUrl),
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isDesktop)
          Row(
            children: [
              for (int i = 0; i < entries.length; i++) ...[
                Expanded(child: _SocialCard(entry: entries[i])),
                if (i < entries.length - 1) const SizedBox(width: 10),
              ],
            ],
          )
        else
          _MobileSocialGrid(entries: entries),
      ],
    );
  }

  static Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _SocialEntry {
  const _SocialEntry({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

/// Mobile grid: ilk kart (Web) tam genişlik, sonraki 4 kart 2 sütun × 2 satır.
class _MobileSocialGrid extends StatelessWidget {
  const _MobileSocialGrid({required this.entries});

  final List<_SocialEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialCard(entry: entries[0]),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _SocialCard(entry: entries[1])),
            const SizedBox(width: 8),
            Expanded(child: _SocialCard(entry: entries[2])),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _SocialCard(entry: entries[3])),
            const SizedBox(width: 8),
            Expanded(child: _SocialCard(entry: entries[4])),
          ],
        ),
      ],
    );
  }
}

class _SocialCard extends StatelessWidget {
  const _SocialCard({required this.entry});

  final _SocialEntry entry;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;
    final cardBg = isDark ? const Color(0xFF1A1814) : const Color(0xFFFFFEFA);

    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: entry.onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: isDesktop ? 64 : 48,
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 8 : 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: fg.withValues(alpha: 0.12)),
          ),
          child: isDesktop
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(entry.icon,
                        size: 18, color: fg.withValues(alpha: 0.85)),
                    const SizedBox(height: 4),
                    Text(
                      entry.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: fg.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: fg.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(entry.icon,
                          size: 14, color: fg.withValues(alpha: 0.85)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: fg.withValues(alpha: 0.72),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

