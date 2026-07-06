import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import 'data/action_binding.dart';
import 'data/script_manifest.dart';
import 'data/skapi_i18n_lookup.dart';
import 'data/skapi_providers.dart';
import 'skapi_desktop_detail_screen.dart';
import 'skapi_script_detail_screen.dart';
import 'skapi_template_library_screen.dart';
import 'user_script_editor_screen.dart';
import 'widgets/skapi_action_list.dart';

/// SKAPI sekmesi — tek sayfalık tasarım (mockup: `SKAPP/1.html`).
///
/// Üst→alt, hepsi sola-dayalı ortak başlık ([SkapiLibHeading]) altında:
///   1. **SKAPI** → 2×2 ürün kartı ızgarası: SynDimm · LebensSpur ·
///      Blocking Focus · Masaüstü. Her kart neumorphic well (SkNeuCard) +
///      raised glyph yuvası; dokunmak o cihazın kütüphanesine / masaüstü
///      detayına iner.
///   2. **Hızlı Erişim** → yıldızlı script çipleri (favori scriptler).
///   3. **Aksiyonlarım** → cihaz × script bağlantıları ([SkapiActionList]).
///   4. **Topluluğa gönder** → katkı CTA kartı.
///
/// Renk yok, tek vurgu (hardal) yalnız "live" rozet / yıldız / CTA için.
/// Desktop'ta [SkContent] içeriği ortalar ve genişliği sınırlar.
class SkapiScreen extends ConsumerWidget {
  const SkapiScreen({super.key});

  /// Cihaz-bağımsız yeni kullanıcı scripti (app'in "Yeni Aksiyon" akışıyla
  /// aynı hedef). Aksiyonlarım bölümündeki "+ Aksiyon ekle" buradan gider.
  void _onAdd(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const UserScriptEditorScreen()),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    final bindings = ref.watch(bindingsProvider);
    final favourites = ref.watch(favouriteScriptsProvider);
    final starredAsync = ref.watch(starredScriptsProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 120),
          children: [
            SkContent(
              horizontalPadding: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1 ─ SKAPI · 2×2 ürün kartları
                  SkapiLibHeading(title: l.skapiTitle),
                  const SizedBox(height: 12),
                  const _ProductGrid(),

                  const SizedBox(height: 28),
                  // 2 ─ Hızlı Erişim
                  SkapiLibHeading(
                    title: l.skapiQuickAccessHeading,
                    count: favourites.length,
                  ),
                  const SizedBox(height: 12),
                  _QuickAccess(
                    starredAsync: starredAsync,
                    favouriteCount: favourites.length,
                  ),

                  const SizedBox(height: 28),
                  // 3 ─ Aksiyonlarım
                  SkapiLibHeading(
                    title: l.skapiActionsHeading,
                    count: bindings.length,
                  ),
                  const SizedBox(height: 12),
                  _ActionsBlock(
                    bindings: bindings,
                    onAdd: () => _onAdd(context),
                  ),

                  const SizedBox(height: 30),
                  // 4 ─ Topluluğa gönder
                  const _CommunityCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// 2×2 ürün kartları
// ===========================================================================

enum _Badge { live, dev, concept, connected }

class _Product {
  const _Product({
    required this.prefix,
    required this.name,
    required this.tagline,
    required this.badge,
    this.glyph,
    this.icon,
    required this.onTap,
  });

  final String prefix; // DevicePrefixChip metni (SD/LS/BF/PC)
  final String name;
  final String tagline;
  final _Badge badge;
  final String? glyph; // metin glyph (✦ ≋ ◐)
  final IconData? icon; // veya Material ikon (Masaüstü)
  final void Function(BuildContext) onTap;
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    void openFamily(BuildContext ctx, String prefix) => Navigator.of(ctx).push(
          MaterialPageRoute(
            builder: (_) => SkapiTemplateLibraryScreen(
              libraryContext: TemplateLibraryContext(devicePrefix: prefix),
            ),
          ),
        );

    final products = <_Product>[
      _Product(
        prefix: 'SD',
        name: 'SynDimm',
        glyph: '✦',
        tagline: l.smartkraftSynDimmTagline,
        badge: _Badge.concept,
        onTap: (ctx) => openFamily(ctx, 'SD'),
      ),
      _Product(
        prefix: 'LS',
        name: 'LebensSpur',
        glyph: '≋',
        tagline: l.smartkraftLebensSpurTagline,
        badge: _Badge.dev,
        onTap: (ctx) => openFamily(ctx, 'LS'),
      ),
      _Product(
        prefix: 'BF',
        name: 'Blocking Focus',
        glyph: '◐',
        tagline: l.smartkraftBlockingFocusTagline,
        badge: _Badge.live,
        onTap: (ctx) => openFamily(ctx, 'BF'),
      ),
      _Product(
        prefix: 'PC',
        name: l.skapiDeviceDesktop,
        icon: Icons.desktop_windows_outlined,
        tagline: l.skapiDesktopCardDesc,
        badge: _Badge.connected,
        onTap: (ctx) => Navigator.of(ctx).push(
          MaterialPageRoute(builder: (_) => const SkapiDesktopDetailScreen()),
        ),
      ),
    ];

    Widget row(_Product a, _Product b) => IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _ProductCard(product: a)),
              const SizedBox(width: 12),
              Expanded(child: _ProductCard(product: b)),
            ],
          ),
        );

    return Column(
      children: [
        row(products[0], products[1]),
        const SizedBox(height: 12),
        row(products[2], products[3]),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final _Product product;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SkNeuCard(
      padding: const EdgeInsets.all(16),
      onTap: () => product.onTap(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GlyphSlot(glyph: product.glyph, icon: product.icon),
              const Spacer(),
              _StatusBadge(badge: product.badge),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            product.name,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.tagline,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              DevicePrefixChip(prefix: product.prefix),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: cs.onSurface.withValues(alpha: 0.40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Well kartın içinde RAISED (kabarık) glyph yuvası — [SkNeuIconSlot]'un
/// gölge reçetesini birebir taklit eder ama metin glyph'i de destekler.
class _GlyphSlot extends StatelessWidget {
  const _GlyphSlot({this.glyph, this.icon});
  final String? glyph;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final fg = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75);
    final shDark = isDark
        ? Colors.black.withValues(alpha: 0.55)
        : Colors.black.withValues(alpha: 0.16);
    final shLight = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.90);

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: shLight, offset: const Offset(-2, -2), blurRadius: 3),
          BoxShadow(color: shDark, offset: const Offset(2, 2), blurRadius: 3),
        ],
      ),
      alignment: Alignment.center,
      child: icon != null
          ? Icon(icon, size: 22, color: fg)
          : Text(glyph ?? '', style: TextStyle(fontSize: 22, color: fg, height: 1.0)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.badge});
  final _Badge badge;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    final (String label, Color bg, Color fg, bool dot) = switch (badge) {
      _Badge.live => (
          l.smartkraftStatusLive,
          SkColors.attentionMustard.withValues(alpha: 0.22),
          cs.onSurface,
          false,
        ),
      _Badge.dev => (
          l.smartkraftStatusDev,
          cs.onSurface.withValues(alpha: 0.07),
          cs.onSurface.withValues(alpha: 0.70),
          false,
        ),
      _Badge.concept => (
          l.smartkraftStatusConcept,
          cs.onSurface.withValues(alpha: 0.07),
          cs.onSurface.withValues(alpha: 0.60),
          false,
        ),
      _Badge.connected => (
          l.devicesStatPaired.toUpperCase(),
          cs.onSurface.withValues(alpha: 0.06),
          cs.onSurface.withValues(alpha: 0.72),
          true,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: SkColors.attentionMustard,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: fg,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Hızlı Erişim · yıldızlı script çipleri
// ===========================================================================

class _QuickAccess extends StatelessWidget {
  const _QuickAccess({
    required this.starredAsync,
    required this.favouriteCount,
  });

  final AsyncValue<List<ScriptManifest>> starredAsync;
  final int favouriteCount;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (favouriteCount == 0) {
      return _QuickAccessEmpty(text: l.skapiStarredSlimEmpty);
    }
    return starredAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: LinearProgressIndicator(minHeight: 2),
      ),
      error: (e, _) => _QuickAccessEmpty(text: '$e'),
      data: (scripts) {
        if (scripts.isEmpty) {
          return _QuickAccessEmpty(text: l.skapiStarredSlimEmpty);
        }
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final s in scripts) _StarredChip(script: s),
          ],
        );
      },
    );
  }
}

class _StarredChip extends StatelessWidget {
  const _StarredChip({required this.script});
  final ScriptManifest script;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final tt = Theme.of(context).textTheme;
    final shDark = isDark
        ? Colors.black.withValues(alpha: 0.50)
        : Colors.black.withValues(alpha: 0.14);
    final shLight = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.white.withValues(alpha: 0.88);
    final title = resolveSkapiI18nKey(l, script.i18nTitle);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SkapiScriptDetailScreen(manifest: script),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 9, 15, 9),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(color: shLight, offset: const Offset(-2, -2), blurRadius: 4),
              BoxShadow(color: shDark, offset: const Offset(3, 3), blurRadius: 6),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded,
                  size: 15, color: SkColors.attentionMustard),
              const SizedBox(width: 7),
              Text(
                title,
                style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAccessEmpty extends StatelessWidget {
  const _QuickAccessEmpty({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return SkNeuCard(
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      child: Row(
        children: [
          Icon(Icons.star_border_rounded,
              size: 16, color: cs.onSurface.withValues(alpha: 0.40)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Aksiyonlarım
// ===========================================================================

class _ActionsBlock extends StatelessWidget {
  const _ActionsBlock({required this.bindings, required this.onAdd});

  final List<ActionBinding> bindings;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mustard-left açıklama şeridi (mock ile aynı).
        Container(
          decoration: BoxDecoration(
            color: SkColors.attentionMustard.withValues(alpha: 0.08),
            border: const Border(
              left: BorderSide(color: SkColors.attentionMustard, width: 3),
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(9),
              bottomRight: Radius.circular(9),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(11, 9, 12, 9),
          child: Text(
            l.skapiActionsExplainer,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.75),
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (bindings.isEmpty)
          _ActionsEmpty(hintText: l.skapiActionsEmptyHint)
        else
          SkapiActionList(bindings: bindings),
        const SizedBox(height: 10),
        _AddActionRow(label: l.skapiActionsAddCta, onTap: onAdd),
      ],
    );
  }
}

class _ActionsEmpty extends StatelessWidget {
  const _ActionsEmpty({required this.hintText});
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return SkNeuCard(
      borderRadius: 14,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Icon(Icons.link_rounded,
              size: 20, color: cs.onSurface.withValues(alpha: 0.40)),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              hintText,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

/// "+ Aksiyon ekle" — kesik-kenarlı, zemine gömülü (inset) satır.
class _AddActionRow extends StatelessWidget {
  const _AddActionRow({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SkNeuCard(
      borderRadius: 14,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded,
                size: 18, color: SkColors.attentionMustard),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: SkColors.attentionMustard,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Topluluğa gönder · CTA
// ===========================================================================

class _CommunityCard extends StatelessWidget {
  const _CommunityCard();

  static const _communityUrl = 'https://github.com/smrtkrft';

  Future<void> _open() async {
    await launchUrl(Uri.parse(_communityUrl),
        mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SkNeuCard(
      padding: const EdgeInsets.all(16),
      borderColor: SkColors.attentionMustard.withValues(alpha: 0.35),
      onTap: _open,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: SkColors.attentionMustard.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.ios_share_rounded,
                size: 22, color: SkColors.attentionMustard),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              l.skapiContributeTitle,
              style: tt.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.1,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.arrow_forward_rounded,
              size: 20, color: cs.onSurface.withValues(alpha: 0.55)),
        ],
      ),
    );
  }
}
