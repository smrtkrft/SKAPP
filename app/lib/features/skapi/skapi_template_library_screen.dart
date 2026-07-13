import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ble/device_type_visual.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import 'data/device_template.dart';
import 'data/skapi_i18n_lookup.dart';
import 'data/skapi_providers.dart';
import 'data/user_template.dart';
import 'skapi_template_detail_screen.dart';

/// Kütüphanenin açılış bağlamı. null alanlar = filtre yok (gezinme modu).
/// SD ekranlarından gelen derin bağlantı deviceId + devicePrefix + tür/
/// kategori filtresi taşır: kütüphane doğrudan o cihazın içeriğine iner
/// (cihaz kartı seviyesi atlanır) ve dağıtımda cihaz seçici atlanır.
class TemplateLibraryContext {
  const TemplateLibraryContext({
    this.deviceId,
    this.devicePrefix,
    this.kinds,
    this.categoryFilter,
    this.manufacturerFilter,
  });

  final String? deviceId;

  /// Cihazın 2 harfli aile öneki (SD/BF/LS). Dolu ise kütüphane cihaz-kartı
  /// gezinmesini atlar ve doğrudan o cihazın şablon içeriğini gösterir —
  /// hem derin bağlantıda hem kart seviyesinden içeri girildiğinde.
  final String? devicePrefix;

  final Set<TemplateTargetKind>? kinds;

  /// [kTemplateCategories] üyesi (örn `dimmer`) — Modes ekranı davranışa
  /// göre filtreli açar.
  final String? categoryFilter;

  /// Üretici alt-sayfası filtresi. Dolu ise kütüphane yalnız o üreticinin
  /// (marka adı) şablonlarını gösterir; [kGenericManufacturerKey] = üretici-
  /// bağımsız (Genel) kova. Dimmer/Panjur'da üretici kutucuğuna dokununca set
  /// edilir; boşken (browse) üretici kutucukları gösterilir.
  final String? manufacturerFilter;

  bool get isDeepLink => deviceId != null;

  /// Cihaz seviyesi seçilmiş mi (kart gezinmesi atlanır, içerik gösterilir).
  bool get showDeviceDetail => devicePrefix != null;
}

/// Kütüphaneyi tanıyan cihaz aileleri (görünüm sırası). Her ailenin kendi
/// şablonu olmayabilir; boş aile listede gösterilmez.
const List<String> _kDeviceOrder = ['SD', 'LS', 'BF'];

String _deviceDesc(AppLocalizations l, String prefix) => switch (prefix) {
      'SD' => l.skapiTplDevDescSd,
      'LS' => l.skapiTplDevDescLs,
      'BF' => l.skapiTplDevDescBf,
      _ => '',
    };

/// Bir kategori satırının etiketi.
String categoryLabel(AppLocalizations l, String category) => switch (category) {
      'dimmer' => l.skapiTplCatDimmer,
      'shutter' => l.skapiTplCatShutter,
      'webhook' => l.skapiTplCatWebhook,
      'mqtt' => l.skapiTplCatMqtt,
      _ => l.skapiTplCatOther,
    };

/// Üretici-önce gruplamada üretici-bağımsız (Genel) kovanın sabit anahtarı.
/// [DeviceTemplate.manufacturer] boş veya `generic` olan şablonlar buraya
/// düşer (jenerik MQTT sürücüsü + Mod şablonları).
const String kGenericManufacturerKey = '__generic__';

/// Bir şablonun üretici kova anahtarı. Boş/`generic` → Genel (null döner),
/// aksi halde marka adı (örn `Shelly`). Yalnız Dimmer/Panjur gruplamasında
/// anlamlıdır (sürücüler manufacturer taşır; modlar taşımaz → Genel).
String? mfrKeyOf(DeviceTemplate t) {
  final m = t.manufacturer?.trim();
  if (m == null || m.isEmpty) return null;
  if (m.toLowerCase() == 'generic') return null;
  return m;
}

/// Üretici kutucuğu/alt-sayfa başlığı etiketi. [kGenericManufacturerKey] →
/// yerelleştirilmiş "Genel"; aksi halde marka adı olduğu gibi.
String mfrDisplayLabel(AppLocalizations l, String key) =>
    key == kGenericManufacturerKey ? l.skapiTplMfrGeneric : key;

/// Cihaz Şablonları kütüphanesi — cihaz-önce. Üst düzeyde cihaz kartları
/// (renk/ikon yok, kimliği ad + nötr önek taşır); bir cihaza girince o
/// cihazın şablonları işlev başlıkları (Dimmer/Panjur/MQTT/Webhook) altında,
/// her başlıkta önce Sürücüler (profil) sonra Modlar (mod) kart ızgarasında.
/// Çoklu-cihaz webhook uyumlu her cihazda görünür (tek kopya).
class SkapiTemplateLibraryScreen extends ConsumerWidget {
  const SkapiTemplateLibraryScreen({
    super.key,
    this.libraryContext = const TemplateLibraryContext(),
  });

  final TemplateLibraryContext libraryContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final templatesAsync = ref.watch(deviceTemplatesProvider);
    final userTemplates = ref.watch(userTemplatesProvider);

    final detail = libraryContext.showDeviceDetail;
    final title = libraryContext.manufacturerFilter != null
        ? mfrDisplayLabel(l, libraryContext.manufacturerFilter!)
        : detail
            ? DeviceTypeVisual.friendlyName(libraryContext.devicePrefix)
            : l.skapiTplLibraryTitle;

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: templatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('$e', textAlign: TextAlign.center),
          ),
        ),
        data: (all) => detail
            ? _DeviceDetail(
                templates: all,
                userTemplates: userTemplates,
                libraryContext: libraryContext,
              )
            : _Browse(
                templates: all,
                userTemplates: userTemplates,
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Gezinme: cihaz kartları ızgarası + "Şablonlarım"
// ---------------------------------------------------------------------------

class _Browse extends StatelessWidget {
  const _Browse({required this.templates, required this.userTemplates});

  final List<DeviceTemplate> templates;
  final List<UserTemplate> userTemplates;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Cihaz aileleri: yalnız en az bir uyumlu şablonu olanlar.
    final devices = <String>[
      for (final p in _kDeviceOrder)
        if (templates.any((t) => t.compatiblePrefixes
            .map((x) => x.toUpperCase())
            .contains(p))) p,
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 100),
      children: [
        SkContent(
          horizontalPadding: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SkapiLibHeading(title: l.skapiTplDevicesHeading),
              const SizedBox(height: 10),
              SkapiResponsiveGrid(
                minExtent: 340,
                maxColumns: 2,
                children: [
                  for (final p in devices)
                    SkapiDeviceCard(
                      prefix: p,
                      templates: templates
                          .where((t) => t.compatiblePrefixes
                              .map((x) => x.toUpperCase())
                              .contains(p))
                          .toList(growable: false),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              SkapiLibHeading(title: l.skapiTplMineHeading, count: userTemplates.length),
              const SizedBox(height: 10),
              if (userTemplates.isEmpty)
                SkNeuCard(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l.skapiTplMineEmpty,
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                )
              else
                SkapiResponsiveGrid(
                  minExtent: 300,
                  maxColumns: 3,
                  children: [
                    for (final u in userTemplates)
                      SkapiTemplateCard(
                        template: u.toDeviceTemplate(),
                        userTemplateId: u.id,
                        libraryContext: const TemplateLibraryContext(),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// İkonsuz, renksiz cihaz kartı — kimlik ad + nötr önek. Alt şeritte script
/// sayısı ve işlev özeti. Dokunmak o cihazın şablon detayına iner.
///
/// Ana SKAPI sekmesi (Kütüphane) de aynı kartı kullanır — cihaz/şablon
/// kartları tek yerden gelsin, iki ekran arasında görsel kayma olmasın.
class SkapiDeviceCard extends StatelessWidget {
  const SkapiDeviceCard(
      {super.key, required this.prefix, required this.templates});

  final String prefix;
  final List<DeviceTemplate> templates;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // İşlev özeti: kategori → adet, kTemplateCategories sırasında.
    final byCat = <String, int>{};
    for (final t in templates) {
      byCat[t.category] = (byCat[t.category] ?? 0) + 1;
    }
    final summary = [
      for (final c in kTemplateCategories)
        if ((byCat[c] ?? 0) > 0) '${categoryLabel(l, c)} ${byCat[c]}',
    ].join(' · ');

    return SkNeuCard(
      padding: EdgeInsets.zero,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SkapiTemplateLibraryScreen(
            libraryContext: TemplateLibraryContext(devicePrefix: prefix),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        DeviceTypeVisual.friendlyName(prefix),
                        style: tt.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DevicePrefixChip(prefix: prefix),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right,
                        size: 20, color: cs.onSurfaceVariant),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _deviceDesc(l, prefix),
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: cs.onSurface.withValues(alpha: 0.04),
              border: Border(
                  top: BorderSide(color: cs.outlineVariant, width: 0.5)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
            child: Row(
              children: [
                Text(
                  l.skapiTplDeviceCount(templates.length),
                  style: tt.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    summary,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
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

// ---------------------------------------------------------------------------
// Cihaz detayı: işlev başlıkları → Sürücüler / Modlar → kart ızgarası
// ---------------------------------------------------------------------------

class _DeviceDetail extends StatelessWidget {
  const _DeviceDetail({
    required this.templates,
    required this.userTemplates,
    required this.libraryContext,
  });

  final List<DeviceTemplate> templates;
  final List<UserTemplate> userTemplates;
  final TemplateLibraryContext libraryContext;

  bool _matches(DeviceTemplate t) {
    final ctx = libraryContext;
    if (ctx.kinds != null && !ctx.kinds!.contains(t.targetKind)) return false;
    if (ctx.categoryFilter != null && t.category != ctx.categoryFilter) {
      return false;
    }
    if (ctx.manufacturerFilter != null) {
      final key = mfrKeyOf(t) ?? kGenericManufacturerKey;
      if (key != ctx.manufacturerFilter) return false;
    }
    final prefix = ctx.devicePrefix!;
    return t.compatiblePrefixes
        .map((p) => p.toUpperCase())
        .contains(prefix.toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final mine = [for (final u in userTemplates) if (_matches(u.toDeviceTemplate())) u];
    final matched = templates.where(_matches).toList(growable: false);

    // Kategori → şablonlar, kTemplateCategories sırasında.
    final byCat = <String, List<DeviceTemplate>>{};
    for (final t in matched) {
      (byCat[t.category] ??= <DeviceTemplate>[]).add(t);
    }
    final orderedCats = [
      for (final c in kTemplateCategories)
        if ((byCat[c]?.isNotEmpty ?? false)) c,
      for (final c in byCat.keys)
        if (!kTemplateCategories.contains(c)) c,
    ];

    if (orderedCats.isEmpty && mine.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l.skapiTplEmptyLibrary,
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 100),
      children: [
        SkContent(
          horizontalPadding: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (mine.isNotEmpty) ...[
                _CategorySection(
                  title: l.skapiTplMineHeading,
                  count: mine.length,
                  groups: [
                    (
                      null,
                      [
                        for (final u in mine)
                          SkapiTemplateCard(
                            template: u.toDeviceTemplate(),
                            userTemplateId: u.id,
                            libraryContext: libraryContext,
                          ),
                      ]
                    ),
                  ],
                ),
              ],
              for (final cat in orderedCats)
                if (_useManufacturerTiles(cat))
                  _ManufacturerTileSection(
                    title: categoryLabel(l, cat),
                    count: byCat[cat]!.length,
                    buckets: _bucketByManufacturer(byCat[cat]!),
                    onOpen: (key) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SkapiTemplateLibraryScreen(
                          libraryContext: TemplateLibraryContext(
                            devicePrefix: libraryContext.devicePrefix,
                            categoryFilter: cat,
                            manufacturerFilter: key,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  _CategorySection(
                    title: categoryLabel(l, cat),
                    count: byCat[cat]!.length,
                    note: cat == 'webhook' ? l.skapiTplSafeNote : null,
                    groups: _groupByKind(byCat[cat]!, l),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  /// Kategori içindeki şablonları türe göre gruplar: önce Sürücüler
  /// (profil), sonra Modlar (mod), sonra kalanlar (webhook/safe) etiketsiz.
  List<(String?, List<Widget>)> _groupByKind(
      List<DeviceTemplate> list, AppLocalizations l) {
    List<Widget> cards(bool Function(DeviceTemplate) f) => [
          for (final t in list)
            if (f(t))
              SkapiTemplateCard(template: t, libraryContext: libraryContext),
        ];
    final drivers = cards((t) => t.targetKind == TemplateTargetKind.sdProfile);
    final modes = cards((t) => t.targetKind == TemplateTargetKind.sdMode);
    final rest = cards((t) =>
        t.targetKind != TemplateTargetKind.sdProfile &&
        t.targetKind != TemplateTargetKind.sdMode);
    return [
      if (drivers.isNotEmpty) (l.skapiTplDrivers, drivers),
      if (modes.isNotEmpty) (l.skapiTplModes, modes),
      if (rest.isNotEmpty) (null, rest),
    ];
  }

  /// Gezinme (browse) modu: bir üretici alt-sayfasında değil ve seçici
  /// (`kinds` filtreli derin bağlantı) değil. Yalnız bu modda Dimmer/Panjur
  /// üretici kutucuğu ızgarası gösterir.
  bool get _browseMode =>
      libraryContext.manufacturerFilter == null && libraryContext.kinds == null;

  bool _useManufacturerTiles(String cat) =>
      _browseMode && (cat == 'dimmer' || cat == 'shutter');

  /// Kategori şablonlarını üretici kovalarına ayırır. Sıralama: Genel en
  /// sonda; sonra adet çok→az; eşitlikte ad A→Z (Shelly doğal olarak başa).
  List<({String key, int count})> _bucketByManufacturer(
      List<DeviceTemplate> list) {
    final counts = <String, int>{};
    for (final t in list) {
      final key = mfrKeyOf(t) ?? kGenericManufacturerKey;
      counts[key] = (counts[key] ?? 0) + 1;
    }
    final keys = counts.keys.toList()
      ..sort((a, b) {
        final ag = a == kGenericManufacturerKey ? 1 : 0;
        final bg = b == kGenericManufacturerKey ? 1 : 0;
        if (ag != bg) return ag - bg;
        final byCount = counts[b]!.compareTo(counts[a]!);
        if (byCount != 0) return byCount;
        return a.toLowerCase().compareTo(b.toLowerCase());
      });
    return [for (final k in keys) (key: k, count: counts[k]!)];
  }
}

/// Bir işlev başlığı bölümü: başlık + adet + (opsiyonel not) + tür alt-
/// etiketli kart ızgaraları.
class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.title,
    required this.count,
    required this.groups,
    this.note,
  });

  final String title;
  final int count;
  final String? note;
  final List<(String?, List<Widget>)> groups;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(title,
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              Text('$count',
                  style: tt.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant, fontFamily: 'monospace')),
            ],
          ),
          if (note != null) ...[
            const SizedBox(height: 8),
            _SafeNote(text: note!),
          ],
          for (final (label, cards) in groups) ...[
            if (label != null) ...[
              const SizedBox(height: 12),
              Text(
                label.toUpperCase(),
                style: tt.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: cs.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              ),
            ],
            const SizedBox(height: 8),
            SkapiResponsiveGrid(minExtent: 300, maxColumns: 3, children: cards),
          ],
        ],
      ),
    );
  }
}

/// Kasa ayrımı notu (SD > Webhook başlığı). Sol kenar uyarı tonu.
class _SafeNote extends StatelessWidget {
  const _SafeNote({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: SkColors.warnRed.withValues(alpha: 0.06),
        border: Border(
            left: BorderSide(color: SkColors.warnRed.withValues(alpha: 0.6), width: 3)),
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(9), bottomRight: Radius.circular(9)),
      ),
      padding: const EdgeInsets.fromLTRB(11, 9, 12, 9),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.4,
            ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Üretici-önce: kutucuk ızgarası (Dimmer/Panjur browse) → üretici alt-sayfası
// ---------------------------------------------------------------------------

/// Bir kategori başlığı + üretici kutucuğu ızgarası. Kart yerine üreticileri
/// listeler; bir kutucuğa dokununca [onOpen] o üreticinin alt-sayfasını açar.
class _ManufacturerTileSection extends StatelessWidget {
  const _ManufacturerTileSection({
    required this.title,
    required this.count,
    required this.buckets,
    required this.onOpen,
  });

  final String title;
  final int count;
  final List<({String key, int count})> buckets;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(title,
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              Text('$count',
                  style: tt.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant, fontFamily: 'monospace')),
            ],
          ),
          const SizedBox(height: 10),
          SkapiResponsiveGrid(
            minExtent: 170,
            maxColumns: 3,
            children: [
              for (final b in buckets)
                SkapiManufacturerTile(
                  manufacturerKey: b.key,
                  count: b.count,
                  onTap: () => onOpen(b.key),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Üretici kutucuğu — nötr wordmark (renk/logo yok). Monogram soketi + marka
/// adı + cihaz adedi + chevron; dokununca o üreticinin alt-sayfasını açar.
class SkapiManufacturerTile extends StatelessWidget {
  const SkapiManufacturerTile({
    super.key,
    required this.manufacturerKey,
    required this.count,
    required this.onTap,
  });

  final String manufacturerKey;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final label = mfrDisplayLabel(l, manufacturerKey);
    return SkNeuCard(
      padding: const EdgeInsets.fromLTRB(13, 12, 12, 12),
      onTap: onTap,
      child: Row(
        children: [
          _MonogramSlot(text: _monogram(label)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  l.skapiTplMfrDeviceCount(count),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.chevron_right, size: 20, color: cs.onSurfaceVariant),
        ],
      ),
    );
  }
}

/// Marka adından 2-harfli monogram (örn Shelly→SH, WiZ→WI, WLED→WL, Genel→GE).
String _monogram(String label) {
  final letters = label.replaceAll(RegExp(r'[^A-Za-z]'), '');
  final base = letters.isEmpty ? label.trim() : letters;
  if (base.isEmpty) return '?';
  return base.substring(0, base.length >= 2 ? 2 : 1).toUpperCase();
}

/// Nötr monogram soketi — SkNeuIconSlot'un raised görünümünü metinle taklit
/// eder (ikon yerine 2-harf). Renk yok; well içinde kabarık durur.
class _MonogramSlot extends StatelessWidget {
  const _MonogramSlot({required this.text});

  final String text;

  static const double size = 40;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final cs = Theme.of(context).colorScheme;
    final shDark = isDark
        ? Colors.black.withValues(alpha: 0.55)
        : Colors.black.withValues(alpha: 0.16);
    final shLight = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.90);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(size * 0.30),
        boxShadow: [
          BoxShadow(color: shLight, offset: const Offset(-2, -2), blurRadius: 3),
          BoxShadow(color: shDark, offset: const Offset(2, 2), blurRadius: 3),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          fontFamily: 'monospace',
          color: cs.onSurface.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}

/// Şablon kartı (detay ızgarası). İkon yok; başlık + tür rozeti + özet +
/// (webhook ise) uyumluluk çipi + CLI komutu.
class SkapiTemplateCard extends StatelessWidget {
  const SkapiTemplateCard({
    super.key,
    required this.template,
    required this.libraryContext,
    this.userTemplateId,
  });

  final DeviceTemplate template;
  final String? userTemplateId;
  final TemplateLibraryContext libraryContext;

  static String _cli(TemplateTargetKind k) => switch (k) {
        TemplateTargetKind.bfEndpoint => 'api.endpoint.add',
        TemplateTargetKind.sdProfile => 'profile.add',
        TemplateTargetKind.sdMode => 'mode.set',
        TemplateTargetKind.sdSafe => 'safe.set',
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final title = resolveSkapiI18nKey(l, template.i18nTitle);
    final summary = resolveSkapiI18nKey(l, template.i18nSummary);
    final isWebhook = template.targetKind == TemplateTargetKind.bfEndpoint;

    return SkNeuCard(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SkapiTemplateDetailScreen(
            template: template,
            userTemplateId: userTemplateId,
            libraryContext: libraryContext,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              TemplateKindBadge(kind: template.targetKind),
            ],
          ),
          if (summary.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          ],
          const SizedBox(height: 9),
          Row(
            children: [
              if (isWebhook)
                DevicePrefixChip(
                    prefix: template.compatiblePrefixes.join(' ')),
              const Spacer(),
              Text(
                _cli(template.targetKind),
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.45),
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ortak: responsive ızgara, başlık, rozetler
// ---------------------------------------------------------------------------

/// Mobil tek sütun, geniş ekran çok sütun. [minExtent] altına düşünce
/// sütun azalır; [maxColumns] üst sınır (cihaz kartları için 2 → 2×2).
class SkapiResponsiveGrid extends StatelessWidget {
  const SkapiResponsiveGrid({
    super.key,
    required this.children,
    this.minExtent = 300,
    this.maxColumns = 3,
  });

  final List<Widget> children;
  final double minExtent;
  final int maxColumns;
  static const double gap = 12;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        var cols = (w / minExtent).floor();
        cols = cols.clamp(1, maxColumns);
        if (cols <= 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(height: gap),
                children[i],
              ],
            ],
          );
        }
        final itemW = (w - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final child in children) SizedBox(width: itemW, child: child),
          ],
        );
      },
    );
  }
}

class SkapiLibHeading extends StatelessWidget {
  const SkapiLibHeading({super.key, required this.title, this.count});
  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: tt.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: cs.onSurfaceVariant,
              fontFamily: 'monospace',
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 8),
            Text('$count',
                style: tt.labelSmall
                    ?.copyWith(color: cs.onSurface.withValues(alpha: 0.4))),
          ],
        ],
      ),
    );
  }
}

/// Tür rozeti — renksiz: PROFİL ince hardal tonu, diğerleri nötr.
class TemplateKindBadge extends StatelessWidget {
  const TemplateKindBadge({super.key, required this.kind});
  final TemplateTargetKind kind;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final label = switch (kind) {
      TemplateTargetKind.sdProfile => l.skapiTplKindProfile,
      TemplateTargetKind.sdMode => l.skapiTplKindMode,
      TemplateTargetKind.sdSafe => l.skapiTplKindSafe,
      TemplateTargetKind.bfEndpoint => l.skapiTplKindWebhook,
    };
    final isProfile = kind == TemplateTargetKind.sdProfile;
    final bg = isProfile
        ? SkColors.attentionMustard.withValues(alpha: 0.16)
        : cs.onSurface.withValues(alpha: 0.07);
    final fg = isProfile
        ? SkColors.attentionMustard
        : cs.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(5)),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: fg,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

/// Nötr önek/uyumluluk çipi — cihaz başına renk YOK. Tek nötr çerçeve.
class DevicePrefixChip extends StatelessWidget {
  const DevicePrefixChip({super.key, required this.prefix});
  final String prefix;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: cs.outlineVariant),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        prefix.toUpperCase(),
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: cs.onSurfaceVariant,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
