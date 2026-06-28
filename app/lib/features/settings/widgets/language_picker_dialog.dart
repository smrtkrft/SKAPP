import 'package:flutter/material.dart';

import '../../../core/ui/sk_neu_card.dart';
import '../../../l10n/app_localizations.dart';

/// One selectable language entry in [LanguagePickerDialog]. `pinned` entries
/// (e.g. System/auto) render raised at the top, separated from the A→Z list.
class LanguageOption {
  const LanguageOption({
    required this.locale,
    required this.nativeName,
    required this.secondary,
    required this.code,
    this.pinned = false,
  });
  final Locale locale;
  final String nativeName;
  final String secondary;
  final String code;
  final bool pinned;
}

/// Dil seçici dialog · V2 tactile (sarı yok, arama yok).
///
/// Yapı:
///   - Header: translate ikonu + başlık + close X
///   - Pinned zone: Sistem (auto) tile, raised tactile (kabarık), push pin
///   - Divider
///   - Section header: "Tüm diller" + A → Z N dil
///   - Scrollable list: gerçek desteklenen diller (şu an En + Tr; gelecekte
///     yeni dil eklenince options listesine eklenecek)
///
/// Selected state: tile V2 well (içe basılı, SkNeuCard inset shadow ile)
/// + siyah check ikonu. Mustard kullanılmaz; tactile metafora sadık seçim
/// = fiziksel basma. Bkz: popup.html dil seçici tasarımı.
class LanguagePickerDialog extends StatelessWidget {
  const LanguagePickerDialog({
    super.key,
    required this.title,
    required this.options,
    required this.current,
  });
  final String title;
  final List<LanguageOption> options;
  final Locale current;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final pinned = options.where((o) => o.pinned).toList();
    final regular = options.where((o) => !o.pinned).toList()
      ..sort((a, b) => a.nativeName.toLowerCase().compareTo(
            b.nativeName.toLowerCase(),
          ));

    return Dialog(
      // Shape ve background theme.dialogTheme'den geliyor (Tactile redesign).
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== Header =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 14),
              child: Row(
                children: [
                  Icon(
                    Icons.translate_rounded,
                    size: 22,
                    color: cs.onSurface.withValues(alpha: 0.75),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip:
                        MaterialLocalizations.of(context).closeButtonTooltip,
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: cs.outlineVariant.withValues(alpha: 0.35),
            ),

            // ===== Pinned zone (Sistem) =====
            if (pinned.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final opt in pinned)
                      LanguageTile(
                        option: opt,
                        selected: opt.locale == current,
                        onTap: () => Navigator.of(context).pop(opt.locale),
                      ),
                  ],
                ),
              ),

            // ===== Section header: Tüm diller =====
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Text(
                      l.settingsLanguagePickerAllSection.toUpperCase(),
                      style: tt.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.8,
                        color: cs.onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                  Text(
                    'A → Z · ${regular.length}',
                    style: tt.labelSmall?.copyWith(
                      fontFamily: 'monospace',
                      letterSpacing: 0.4,
                      color: cs.onSurface.withValues(alpha: 0.40),
                    ),
                  ),
                ],
              ),
            ),

            // ===== Scrollable regular list =====
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final opt in regular)
                      LanguageTile(
                        option: opt,
                        selected: opt.locale == current,
                        onTap: () => Navigator.of(context).pop(opt.locale),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tek dil satırı · 3 state:
///   - Pinned + not selected: raised (kabarık) tactile + push_pin ikonu
///   - Pinned + selected: well (içe basılı, SkNeuCard inset) + push_pin + check
///   - Regular + not selected: flat (saydam), hover bg
///   - Regular + selected: well (içe basılı) + siyah check
///
/// Mustard hardal sarısı KULLANILMAZ. Check ikonu daima siyah (onSurface).
class LanguageTile extends StatelessWidget {
  const LanguageTile({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });
  final LanguageOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final tileContent = Row(
      children: [
        // Badge: native script (En/Tr/Ру/Ελ). Pinned'de "AUTO" (mono).
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: cs.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(11),
          ),
          alignment: Alignment.center,
          child: Text(
            option.code,
            style: option.pinned
                ? tt.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: cs.onSurface.withValues(alpha: 0.75),
                  )
                : tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface.withValues(alpha: 0.85),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                option.nativeName,
                style: tt.titleSmall?.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              // Endonim kuralı: gerçek diller için secondary boş bırakılır
              // (exonym gösterilmez); yalnız Sistem/auto gibi açıklamalı
              // girişlerde dolu olur.
              if (option.secondary.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  option.secondary,
                  style: tt.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    letterSpacing: 0.2,
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ],
          ),
        ),
        // Pinned ikonu: hep görünür (pinned tile'larda)
        if (option.pinned) ...[
          const SizedBox(width: 8),
          Icon(
            Icons.push_pin_rounded,
            size: 16,
            color: cs.onSurface.withValues(alpha: 0.45),
          ),
        ],
        // Selected check (siyah)
        if (selected) ...[
          const SizedBox(width: 8),
          Icon(
            Icons.check_rounded,
            size: 22,
            color: cs.onSurface,
          ),
        ],
      ],
    );

    const radius = 14.0;
    const tilePadding = EdgeInsets.symmetric(horizontal: 12, vertical: 10);

    // 3 state'i ayrı widget kabuklarıyla render et (her birinin gölgesi
    // farklı: well, raised, flat).
    if (selected) {
      // V2 well (inset) — SkNeuCard ile zaten doğru gölge.
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: SkNeuCard(
          onTap: onTap,
          borderRadius: radius,
          padding: tilePadding,
          child: tileContent,
        ),
      );
    }

    if (option.pinned) {
      // Raised (kabarık) — basit BoxShadow, sk_neu_card.dart pinned-tile
      // CSS karşılığı.
      final bg = Theme.of(context).scaffoldBackgroundColor;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.78),
                offset: const Offset(-2, -2),
                blurRadius: 4,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(radius),
              child: Padding(
                padding: tilePadding,
                child: tileContent,
              ),
            ),
          ),
        ),
      );
    }

    // Regular (flat) — saydam, hover bg.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Padding(
            padding: tilePadding,
            child: tileContent,
          ),
        ),
      ),
    );
  }
}
