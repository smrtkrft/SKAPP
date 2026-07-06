import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/responsive.dart';
import '../../core/ui/sk_neu_card.dart';
import '../../l10n/app_localizations.dart';
import '../main_shell/main_shell.dart' show ShellNavBar;
import 'data/script_manifest.dart';
import 'data/skapi_catalog.dart';
import 'data/skapi_i18n_lookup.dart';
import 'data/skapi_providers.dart';
import 'skapi_script_detail_screen.dart';
import 'skapi_template_library_screen.dart'
    show SkapiResponsiveGrid, SkapiLibHeading;

/// "Masaüstü" cihaz detayı — cihaz-önce SKAPI kütüphanesinin PC kartı.
///
/// Örnek tasarımda (skapi.html) masaüstü scriptleri (macOS/Windows/Linux)
/// tek "Masaüstü" cihaz kartına toplanır; içeride platform çipleri o
/// platformun script kataloğunu değiştirir. Görsel dil SD/LS/BF cihaz
/// detayıyla birebir: işlev başlıkları (Güç Yönetimi, Ekran/Ses, …) altında
/// satır-içi script kartları. Kart → [SkapiScriptDetailScreen].
///
/// Linux tek satırda görünse de katalog dağıtım ailelerine (Debian/Arch)
/// bölünür; Linux seçilince alt çip satırı çıkar. Boş aile (henüz içerik
/// gelmemiş) dürüst bir "yakında" durumu gösterir — sessiz boş liste değil.
class SkapiDesktopDetailScreen extends ConsumerStatefulWidget {
  const SkapiDesktopDetailScreen({super.key});

  @override
  ConsumerState<SkapiDesktopDetailScreen> createState() =>
      _SkapiDesktopDetailScreenState();
}

class _SkapiDesktopDetailScreenState
    extends ConsumerState<SkapiDesktopDetailScreen> {
  /// Üst düzey platform seçimi: `mac` | `win` | `lx`.
  late String _platform;

  /// Linux seçiliyken etkin dağıtım ailesi (`lx-debian` | `lx-arch`).
  String _distro = 'lx-debian';

  static const _desktopPlatforms = ['mac', 'win', 'lx'];

  @override
  void initState() {
    super.initState();
    // Host bu üç masaüstünden biriyse onunla başla; değilse (mobil/web
    // config akışı) macOS ilk seçili.
    final host = hostSkapiPlatformId();
    _platform = _desktopPlatforms.contains(host) ? host! : 'mac';
  }

  /// Script kataloğunun okunacağı gerçek asset id'si. Linux için dağıtım
  /// alt-seçimine iner (`lx` klasörünün kendi grubu yoktur).
  String get _effectiveId => _platform == 'lx' ? _distro : _platform;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hostId = hostSkapiPlatformId();

    return Scaffold(
      bottomNavigationBar: const ShellNavBar(),
      appBar: AppBar(title: Text(l.skapiDeviceDesktop)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 100),
        children: [
          SkContent(
            horizontalPadding: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Bağlam notu: scriptler bilgisayarda çalışır, cihaza
                // bağlama Aksiyonlar sekmesinde yapılır (mock foot notu).
                Container(
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline,
                          size: 18,
                          color: cs.onSurface.withValues(alpha: 0.6)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l.skapiDesktopNote,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.75),
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Platform çipleri — host "· bu PC" ile işaretli.
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final p in _desktopPlatforms)
                      _Chip(
                        label: _platformLabel(l, p),
                        hint: p == hostId ? l.skapiThisComputer : null,
                        selected: _platform == p,
                        onTap: () => setState(() => _platform = p),
                      ),
                  ],
                ),
                if (_platform == 'lx') ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final d in kSkapiLinuxDistros)
                        _Chip(
                          label: d.label,
                          selected: _distro == d.id,
                          onTap: () => setState(() => _distro = d.id),
                          small: true,
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 18),
                _DesktopGroups(platformId: _effectiveId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Seçili platformun grup listesi — her grup bir işlev başlığı bölümü,
/// altında o grubun scriptleri satır-içi kart ızgarasında.
class _DesktopGroups extends ConsumerWidget {
  const _DesktopGroups({required this.platformId});
  final String platformId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final groupsAsync = ref.watch(skapiPlatformGroupsProvider(platformId));

    return groupsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => SkNeuCard(
        padding: const EdgeInsets.all(14),
        child: Text(l.skapiPlatformGroupsLoadError(e.toString()),
            style: tt.bodySmall?.copyWith(color: cs.error)),
      ),
      data: (groups) {
        if (groups.isEmpty) {
          return SkNeuCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.hourglass_empty_rounded,
                    color: cs.onSurface.withValues(alpha: 0.5)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(l.skapiPlatformEmptyBody,
                      style: tt.bodyMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.7))),
                ),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final g in groups)
              _GroupSection(platformId: platformId, group: g),
          ],
        );
      },
    );
  }
}

/// Tek işlev başlığı: grup adı + script sayısı + satır-içi script kartları.
class _GroupSection extends ConsumerWidget {
  const _GroupSection({required this.platformId, required this.group});
  final String platformId;
  final GroupManifest group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final scriptsAsync = ref.watch(
        skapiGroupScriptsProvider((platform: platformId, group: group.id)));

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SkapiLibHeading(
            title: resolveSkapiI18nKey(l, group.i18nTitle),
            count: group.scriptIds.length,
          ),
          const SizedBox(height: 10),
          scriptsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: LinearProgressIndicator(minHeight: 2),
            ),
            error: (_, _) => const SizedBox.shrink(),
            data: (scripts) => SkapiResponsiveGrid(
              minExtent: 300,
              maxColumns: 3,
              children: [for (final s in scripts) _ScriptCard(manifest: s)],
            ),
          ),
        ],
      ),
    );
  }
}

/// Script kartı — SD/LS/BF şablon kartıyla aynı iskelet: başlık + nötr
/// "SCRIPT" rozeti + kısa özet. Dokunmak script detayına gider.
class _ScriptCard extends StatelessWidget {
  const _ScriptCard({required this.manifest});
  final ScriptManifest manifest;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final title = resolveSkapiI18nKey(l, manifest.i18nTitle);
    final summary = resolveSkapiI18nKey(l, manifest.i18nSummaryWhat);

    return SkNeuCard(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SkapiScriptDetailScreen(manifest: manifest),
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
                    style:
                        tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              _NeutralTag(text: l.skapiTplKindScript),
            ],
          ),
          if (summary.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          ],
        ],
      ),
    );
  }
}

/// Nötr dolgulu tür rozeti (TemplateKindBadge'in script eşdeğeri).
class _NeutralTag extends StatelessWidget {
  const _NeutralTag({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: cs.onSurfaceVariant,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

/// Platform / dağıtım seçim çipi (mock `.plat`). Seçili = hardal dolgu.
class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.hint,
    this.small = false,
  });

  final String label;
  final String? hint;
  final bool selected;
  final bool small;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bg = selected
        ? SkColors.attentionMustard
        : Theme.of(context).scaffoldBackgroundColor;
    final fg = selected ? SkColors.black : cs.onSurface;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : cs.onSurface.withValues(alpha: 0.18),
            ),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: small ? 12 : 14, vertical: small ? 7 : 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: tt.labelLarge?.copyWith(
                  fontSize: small ? 12 : 13,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
              if (hint != null) ...[
                const SizedBox(width: 6),
                Text(
                  '· ${hint!.toLowerCase()}',
                  style: tt.labelSmall?.copyWith(
                    fontSize: 10,
                    color: fg.withValues(alpha: 0.7),
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String _platformLabel(AppLocalizations l, String id) => switch (id) {
      'mac' => l.skapiPlatformMac,
      'win' => l.skapiPlatformWin,
      'lx' => l.skapiPlatformLinux,
      _ => id,
    };
