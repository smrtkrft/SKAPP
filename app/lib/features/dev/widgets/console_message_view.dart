// USB Konsol satir render'i, "smart" mod (2026-05-14).
//
// Cevaplar ham JSON yerine icerik tipine gore otomatik tasarlanmis bir
// goruntu uretir:
//
//   ok=true + data.commands array       -> komut listesi (bold name + summary)
//   ok=true + data flat object          -> key-value satirlari hizali
//   ok=true + data nested object        -> recursive key-value, ic blok indent
//   ok=true + data null/empty           -> "OK" rozetli kisa satir
//   ok=false                            -> "ERR_*" baslik + params (varsa)
//   event                               -> "evt: name" yesil baslik + body
//   local error (timeout, vs.)          -> "hata" kirmizi + mesaj
//
// Komut satiri (kullanici yazdigi) onceki gibi `> cmd` formatinda.
//
// Ham JSON gormeyi seven kullanici icin her cevap satirinin sag-alt
// kosesinde "ham" toggle var: tiklayinca pretty JSON acilir/kapanir.

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';
import '../../../l10n/app_localizations.dart';
import '../usb_console_providers.dart';

class ConsoleMessageView extends StatelessWidget {
  const ConsoleMessageView({super.key, required this.entry});
  final ConsoleEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: switch (entry) {
        ConsoleEntrySent(:final command) => _SentRow(command: command),
        ConsoleEntryResponse() => _ResponseBlock(entry: entry as ConsoleEntryResponse),
        ConsoleEntryEvent() => _EventBlock(entry: entry as ConsoleEntryEvent),
        ConsoleEntryError(:final message) => _LocalErrorBlock(message: message),
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Kullanici komutu
// ---------------------------------------------------------------------------

class _SentRow extends StatelessWidget {
  const _SentRow({required this.command});
  final String command;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mono = _mono(context);
    return SelectableText.rich(
      TextSpan(
        style: mono,
        children: [
          TextSpan(
            text: '› ',
            style: mono.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(text: command),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CLI cevap blogu (ok=true / ok=false)
// ---------------------------------------------------------------------------

class _ResponseBlock extends StatefulWidget {
  const _ResponseBlock({required this.entry});
  final ConsoleEntryResponse entry;

  @override
  State<_ResponseBlock> createState() => _ResponseBlockState();
}

class _ResponseBlockState extends State<_ResponseBlock> {
  bool _rawOpen = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (e.ok) _OkBody(entry: e) else _ErrBody(entry: e),
        // Auto-confirm rozeti: kritik komut iki adımlı confirm-token
        // akışı arka planda otomatik tamamlandığında, kullanıcı tek
        // satır cevap görüyor — burada "Auto-confirmed" chip ile iki
        // round-trip olduğunu açık ediyoruz. Sahte success değil; cevap
        // gerçek (ok=true ya da ok=false), sadece sürecin saydam hali.
        if (e.autoConfirmedTokenSuffix != null) ...[
          const SizedBox(height: 4),
          _AutoConfirmBanner(tokenSuffix: e.autoConfirmedTokenSuffix!),
        ],
        const SizedBox(height: 4),
        _RawToggle(
          open: _rawOpen,
          onToggle: () => setState(() => _rawOpen = !_rawOpen),
        ),
        if (_rawOpen) ...[
          const SizedBox(height: 4),
          _RawJsonBlock(raw: e.raw),
        ],
      ],
    );
  }
}

class _OkBody extends StatelessWidget {
  const _OkBody({required this.entry});
  final ConsoleEntryResponse entry;

  @override
  Widget build(BuildContext context) {
    final mono = _mono(context);
    final cs = Theme.of(context).colorScheme;
    final decoded = _decode(entry.raw);
    final data = decoded is Map ? decoded['data'] : null;

    // data null/yok -> sade OK chip
    if (data == null || (data is Map && data.isEmpty)) {
      return Row(
        children: [
          _Pill(label: 'OK', color: SkColors.attentionMustard),
          if (entry.id != null) ...[
            const SizedBox(width: 8),
            Text(
              '#${entry.id}',
              style: mono.copyWith(
                color: cs.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ],
      );
    }

    // help (ve esdegeri) cevabi -> commands listesi. Yeni firmware
    // ek olarak 'topics' (name + summary + category) gonderir; varsa
    // komutlari namespace'e gore gruplayip kategori basliklariyla
    // (SETUP / OUTPUT / SYSTEM / ROOT) BF human mode'una benzer
    // sekilde render ederiz. Topics yoksa duz tek liste.
    //
    // Firmware machine mode'da `help <topic>` icin de tum komutlari
    // yollar (sk_cli.c:912-955 builtin_help target'i sadece human
    // mode'da kullanir). Bu yuzden filtreleme istemci tarafinda:
    // entry.cmd'yi parse edip render modunu sec.
    if (data is Map && data['commands'] is List) {
      return _CommandsList(
        commands: (data['commands'] as List).cast<dynamic>(),
        topics: data['topics'] is List
            ? (data['topics'] as List).cast<dynamic>()
            : null,
        request: entry.cmd,
      );
    }

    // device.commands array of strings
    if (data is List && data.every((e) => e is String)) {
      return _StringListBlock(items: data.cast<String>());
    }

    // Map -> recursive key-value
    if (data is Map) {
      return _KeyValueBlock(map: data.cast<String, dynamic>(), depth: 0);
    }

    // Primitive
    return SelectableText(
      data.toString(),
      style: mono.copyWith(color: cs.onSurface),
    );
  }

  static dynamic _decode(String raw) {
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }

}

class _ErrBody extends StatelessWidget {
  const _ErrBody({required this.entry});
  final ConsoleEntryResponse entry;

  @override
  Widget build(BuildContext context) {
    final mono = _mono(context);
    final cs = Theme.of(context).colorScheme;
    final decoded = _ResponseBlockData.decode(entry.raw);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Pill(label: 'ERR', color: SkColors.warnRed),
            const SizedBox(width: 8),
            Flexible(
              child: SelectableText(
                entry.err ?? 'ERR_UNKNOWN',
                style: mono.copyWith(
                  color: SkColors.warnRed,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (entry.id != null) ...[
              const SizedBox(width: 8),
              Text(
                '#${entry.id}',
                style: mono.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ],
        ),
        if (decoded?.params != null && decoded!.params!.isNotEmpty) ...[
          const SizedBox(height: 4),
          _KeyValueBlock(
            map: decoded.params!.cast<String, dynamic>(),
            depth: 0,
            valueTone: _ValueTone.error,
          ),
        ],
        // USB CLI'da `requires_auth=true` komutlar (bond.*, secure.*,
        // userdata.*, api.*) firmware tarafından reddedilir; cihaza
        // fiziksel erişim olmasına rağmen authenticated session (BLE
        // bond / TCP token) gerekiyor. Sahte UI değil, açık hint:
        // "USB üstünden çalışmaz, BLE / WiFi (bonded) gerekir".
        if (entry.transportUnauthenticated) ...[
          const SizedBox(height: 6),
          _UnauthenticatedHint(),
        ],
      ],
    );
  }
}

/// USB CLI'da auth gerektiren komut çağırıldığında gösterilir.
/// SmartKraft güvenlik modeli: USB CLI = unauthenticated transport;
/// `requires_auth=true` komutlar BLE/TCP üstünden bonded session ile
/// çağrılmalı (sk_secure_session_dispatch_signed). Bu hint kullanıcıya
/// nedeni ve çözümü tek satırda anlatır.
class _UnauthenticatedHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: SkColors.attentionMustard.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: SkColors.attentionMustard.withValues(alpha: 0.45),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 14,
            color: SkColors.attentionMustard,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SelectableText(
              "Bu komut authenticated session gerektiriyor "
              "(`requires_auth=true`). USB CLI unauthenticated; "
              "komutu Cihazlarım > [cihaz] üstünden BLE/WiFi bonded "
              "oturumda çağır.",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11.5,
                height: 1.4,
                color: cs.onSurface.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Auto-confirm rozeti: kritik komut ilk denemede
/// `ERR_CONFIRM_TOKEN_REQUIRED` döndü, firmware'in `params.confirm_token`
/// içinde yolladığı tek kullanımlık token ile aynı komut otomatik
/// yeniden gönderildi. Kullanıcı tek cevap satırı görüyor; bu chip
/// "arka planda iki round-trip yapıldı" gerçeğini saydam tutar.
class _AutoConfirmBanner extends StatelessWidget {
  const _AutoConfirmBanner({required this.tokenSuffix});
  final String tokenSuffix;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: SkColors.attentionMustard.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: SkColors.attentionMustard.withValues(alpha: 0.5),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 11,
                color: SkColors.attentionMustard,
              ),
              const SizedBox(width: 4),
              Text(
                'auto-confirm',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: SkColors.attentionMustard,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'token=$tokenSuffix',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 10.5,
            color: cs.onSurface.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}

class _ResponseBlockData {
  _ResponseBlockData(this.params);
  final Map? params;

  static _ResponseBlockData? decode(String raw) {
    try {
      final obj = jsonDecode(raw);
      if (obj is Map) {
        final p = obj['params'];
        return _ResponseBlockData(p is Map ? p : null);
      }
    } catch (_) {}
    return null;
  }
}

// ---------------------------------------------------------------------------
// help cevabi -> komut listesi
// ---------------------------------------------------------------------------

/// help cevabi -> kategori bazli komut listesi.
///
/// Firmware machine-mode help'e `topics` array'i ekledikten sonra
/// (sk_cli.c builtin_help) burada commands'i namespace'e gore gruplayip
/// kategori basliklariyla render ederiz. Topic'i olmayan namespace'ler
/// "OTHER" altinda, namespace'i olmayan komutlar (root, `help` gibi)
/// "ROOT" altinda toplanir. Topics gelmezse (eski firmware) duz tek
/// liste, kategori basligi yok.
///
/// [request] dolu ise (orn. `help`, `help wifi`, `help wifi.scan`,
/// `help all`), filtre uygulanir:
///   * `help` tek basina      -> overview: sadece namespace basliklari + hint
///   * `help [topic]`         -> sadece o namespace'in komutlari
///   * `help [command]`       -> tek komut satiri
///   * `help all`             -> tum komutlar gruplı (eski tam liste)
///   * Diger (request null veya help disi) -> tam gruplı liste (fallback)
class _CommandsList extends StatelessWidget {
  const _CommandsList({
    required this.commands,
    this.topics,
    this.request,
  });
  final List<dynamic> commands;
  final List<dynamic>? topics;
  final String? request;

  @override
  Widget build(BuildContext context) {
    final mono = _mono(context);
    final cs = Theme.of(context).colorScheme;

    final header = Row(
      children: [
        _Pill(label: 'OK', color: SkColors.attentionMustard),
        const SizedBox(width: 8),
        Text(
          '${commands.length} komut'
          '${topics != null ? " · ${topics!.length} topic" : ""}',
          style: mono.copyWith(
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );

    // Topics yoksa eski davranis: duz tek liste.
    if (topics == null || topics!.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: 6),
          for (final c in commands) _CommandRow(node: c),
        ],
      );
    }

    // Request'i parse et: "help", "help wifi", "help all", veya null.
    // _HelpMode.overview  -> sadece namespace basliklari (+ hint)
    // _HelpMode.topic     -> tek topic'in komutlari
    // _HelpMode.full      -> tum komutlar gruplı (eski davranis)
    final mode = _helpModeFromRequest(request);

    // Topics'ten namespace -> (summary, category) map'i ve kategori
    // sirasi cikar. Order kritik: BF firmware topics'i SETUP/OUTPUT/
    // SYSTEM siralamasiyla register ediyor; biz de o sirayi koruyalim.
    final topicByName = <String, _TopicInfo>{};
    final categoryOrder = <String>[];
    for (final t in topics!) {
      if (t is! Map) continue;
      final name = t['name']?.toString();
      if (name == null) continue;
      final cat = t['category']?.toString();
      topicByName[name] = _TopicInfo(
        summary: t['summary']?.toString(),
        category: cat,
      );
      if (cat != null && !categoryOrder.contains(cat)) {
        categoryOrder.add(cat);
      }
    }

    // Commands'i namespace prefix'ine gore grupla. Namespace = ilk
    // nokta-ayraci oncesi parca (`wifi.scan` -> `wifi`). Nokta yoksa
    // root (empty namespace).
    final byNamespace = <String, List<dynamic>>{};
    for (final c in commands) {
      if (c is! Map) continue;
      final name = c['name']?.toString() ?? '';
      final dot = name.indexOf('.');
      final ns = dot < 0 ? '' : name.substring(0, dot);
      byNamespace.putIfAbsent(ns, () => []).add(c);
    }

    // Render sirasi:
    //   1. categoryOrder'daki her kategori icin -> o kategorideki
    //      topics'ler (firmware-register sirasi)
    //   2. Topic'i olmayan namespace'ler -> "OTHER"
    //   3. Root komutlar (namespace boş) -> "ROOT"
    final sections = <_Section>[];
    for (final cat in categoryOrder) {
      final topicsInCat = topics!
          .whereType<Map>()
          .where((t) => t['category']?.toString() == cat)
          .map((t) => t['name']?.toString())
          .whereType<String>()
          .toList();
      final sectionTopics = <_TopicSection>[];
      for (final ns in topicsInCat) {
        final cmds = byNamespace[ns];
        if (cmds == null || cmds.isEmpty) continue;
        sectionTopics.add(_TopicSection(
          namespace: ns,
          info: topicByName[ns],
          commands: cmds,
        ));
      }
      if (sectionTopics.isNotEmpty) {
        sections.add(_Section(label: cat, topics: sectionTopics));
      }
    }

    // OTHER: topic kayitli olmayan namespace'ler
    final otherTopics = <_TopicSection>[];
    for (final ns in byNamespace.keys) {
      if (ns.isEmpty) continue;
      if (topicByName.containsKey(ns)) continue;
      otherTopics.add(_TopicSection(
        namespace: ns,
        info: null,
        commands: byNamespace[ns]!,
      ));
    }
    if (otherTopics.isNotEmpty) {
      sections.add(_Section(label: 'OTHER', topics: otherTopics));
    }

    // ROOT: namespace'siz komutlar
    final rootCommands = byNamespace[''];
    if (rootCommands != null && rootCommands.isNotEmpty) {
      sections.add(_Section(
        label: 'ROOT',
        topics: [
          _TopicSection(namespace: '', info: null, commands: rootCommands),
        ],
      ));
    }

    // Mode'a gore render dallandirilir.
    // overview: namespace baslik satirlari (komut listesi yok) + hint
    // topic: yalniz hedef namespace'in komutlari
    // full: tum komutlar gruplı (eski davranis)
    if (mode is _HelpModeTopic) {
      final target = mode.target;
      // Once exact topic eslesmesi
      final matchingTopic = sections
          .expand((s) => s.topics)
          .where((t) => t.namespace == target)
          .toList();
      if (matchingTopic.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            const SizedBox(height: 8),
            for (final t in matchingTopic) _TopicBlock(section: t),
          ],
        );
      }
      // Sonra exact command name eslesmesi (orn. "help wifi.scan")
      final matchingCmd = commands.whereType<Map>().firstWhere(
            (c) => c['name']?.toString() == target,
            orElse: () => const {},
          );
      if (matchingCmd.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            const SizedBox(height: 8),
            _CommandDetail(node: matchingCmd),
          ],
        );
      }
      // Bulunamadi -> full liste fallback + uyari satiri
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SelectableText(
              "'$target' diye bir topic/komut yok. Liste:",
              style: mono.copyWith(color: SkColors.warnRed),
            ),
          ),
          for (final s in sections) ...[
            _CategoryHeader(label: s.label),
            for (final t in s.topics) _TopicBlock(section: t, showCommands: false),
            const SizedBox(height: 6),
          ],
        ],
      );
    }

    if (mode is _HelpModeOverview) {
      final allNamespaces = sections
          .expand((s) => s.topics)
          .map((t) => t.namespace)
          .where((ns) => ns.isNotEmpty)
          .toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: 8),
          for (final s in sections) ...[
            _CategoryHeader(label: s.label),
            for (final t in s.topics) _TopicBlock(section: t, showCommands: false),
            const SizedBox(height: 6),
          ],
          const SizedBox(height: 4),
          _HelpHint(namespaces: allNamespaces),
        ],
      );
    }

    // _HelpModeFull (request null veya `help all`): eski tam liste
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        const SizedBox(height: 8),
        for (final s in sections) ...[
          _CategoryHeader(label: s.label),
          for (final t in s.topics) _TopicBlock(section: t),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  /// `request` ham komut satirini parse edip render modunu doner.
  /// "help"                  -> overview
  /// "help all"              -> full
  /// "help wifi"             -> topic("wifi")
  /// "help wifi.scan"        -> topic("wifi.scan")  (CommandsList icinde
  ///                            once topic'e, yoksa command name'e bakar)
  /// null veya help disi     -> full (fallback, raw JSON ham mod vs.)
  static _HelpMode _helpModeFromRequest(String? request) {
    if (request == null) return const _HelpModeFull();
    final trimmed = request.trim();
    if (trimmed.isEmpty) return const _HelpModeFull();
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.first != 'help') return const _HelpModeFull();
    if (parts.length == 1) return const _HelpModeOverview();
    final arg = parts[1];
    if (arg == 'all') return const _HelpModeFull();
    return _HelpModeTopic(arg);
  }
}

/// Render modu — `_helpModeFromRequest` doner, build() switch'ler.
sealed class _HelpMode {
  const _HelpMode();
}

class _HelpModeFull extends _HelpMode {
  const _HelpModeFull();
}

class _HelpModeOverview extends _HelpMode {
  const _HelpModeOverview();
}

class _HelpModeTopic extends _HelpMode {
  const _HelpModeTopic(this.target);
  final String target;
}

class _HelpHint extends StatelessWidget {
  const _HelpHint({required this.namespaces});
  final List<String> namespaces;

  @override
  Widget build(BuildContext context) {
    final mono = _mono(context);
    final cs = Theme.of(context).colorScheme;
    final example = namespaces.isNotEmpty ? namespaces.first : 'wifi';
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: SelectableText(
        "Bir topic'in komutlarini gormek icin: help $example\n"
        "Tum komutlar (gizliler dahil): help all",
        style: mono.copyWith(
          color: cs.onSurface.withValues(alpha: 0.55),
          fontSize: 11.5,
          height: 1.4,
        ),
      ),
    );
  }
}

class _TopicInfo {
  const _TopicInfo({this.summary, this.category});
  final String? summary;
  final String? category;
}

class _Section {
  const _Section({required this.label, required this.topics});
  final String label;
  final List<_TopicSection> topics;
}

class _TopicSection {
  const _TopicSection({
    required this.namespace,
    required this.info,
    required this.commands,
  });
  final String namespace;
  final _TopicInfo? info;
  final List<dynamic> commands;
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: SkColors.attentionMustard,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: cs.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicBlock extends StatelessWidget {
  const _TopicBlock({required this.section, this.showCommands = true});
  final _TopicSection section;

  /// Overview modunda false; sadece namespace satiri (komut sayisi +
  /// summary) cizilir, alt komut satirlari atlanir. true ise klasik
  /// "namespace + altinda komutlar" goruntusu.
  final bool showCommands;

  @override
  Widget build(BuildContext context) {
    final mono = _mono(context);
    final cs = Theme.of(context).colorScheme;
    final hasNs = section.namespace.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasNs) ...[
            Row(
              children: [
                SelectableText(
                  section.namespace,
                  style: mono.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${section.commands.length})',
                  style: mono.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.45),
                    fontSize: 11,
                  ),
                ),
                if (section.info?.summary != null) ...[
                  const SizedBox(width: 10),
                  Flexible(
                    child: SelectableText(
                      section.info!.summary!,
                      style: mono.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.6),
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
          ],
          if (showCommands)
            Padding(
              padding: EdgeInsets.only(left: hasNs ? 14 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final c in section.commands) _CommandRow(node: c),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CommandRow extends StatelessWidget {
  const _CommandRow({required this.node});
  final dynamic node;

  @override
  Widget build(BuildContext context) {
    final mono = _mono(context);
    final cs = Theme.of(context).colorScheme;
    final m = node is Map ? node.cast<String, dynamic>() : <String, dynamic>{};
    final name = (m['name'] ?? '').toString();
    final summary = (m['summary'] ?? '').toString();
    final critical = m['critical'] == true;
    final hidden = m['hidden'] == true;

    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 2,
                  children: [
                    SelectableText(
                      name,
                      style: mono.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                    if (critical) _MiniTag('!', SkColors.warnRed),
                    if (hidden) _MiniTag('hidden', cs.onSurface.withValues(alpha: 0.4)),
                  ],
                ),
                if (summary.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: SelectableText(
                      summary,
                      style: mono.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.65),
                        fontSize: 11.5,
                      ),
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
// Recursive key-value blok
// ---------------------------------------------------------------------------

enum _ValueTone { normal, error }

class _KeyValueBlock extends StatelessWidget {
  const _KeyValueBlock({
    required this.map,
    required this.depth,
    this.valueTone = _ValueTone.normal,
  });
  final Map<String, dynamic> map;
  final int depth;
  final _ValueTone valueTone;

  @override
  Widget build(BuildContext context) {
    if (map.isEmpty) {
      return Text(
        '{}',
        style: _mono(context).copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      );
    }

    final keyWidth = _computeKeyWidth(map.keys);
    return Padding(
      padding: EdgeInsets.only(left: depth == 0 ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in map.entries)
            _KeyValueRow(
              keyText: entry.key,
              value: entry.value,
              keyWidth: keyWidth,
              depth: depth,
              valueTone: valueTone,
            ),
        ],
      ),
    );
  }

  static double _computeKeyWidth(Iterable<String> keys) {
    final longest = keys.fold<int>(0, (m, k) => k.length > m ? k.length : m);
    // 12px/char tahmini (monospace 12pt), min 60, max 180.
    return (longest * 8.5 + 12).clamp(60.0, 180.0);
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({
    required this.keyText,
    required this.value,
    required this.keyWidth,
    required this.depth,
    required this.valueTone,
  });
  final String keyText;
  final dynamic value;
  final double keyWidth;
  final int depth;
  final _ValueTone valueTone;

  @override
  Widget build(BuildContext context) {
    final mono = _mono(context);
    final cs = Theme.of(context).colorScheme;
    final keyStyle = mono.copyWith(
      color: cs.onSurface.withValues(alpha: 0.55),
    );

    final v = value;
    // Nested object: anahtari satırının basina koy, alt blok yeni satira
    if (v is Map) {
      return Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$keyText:',
              style: keyStyle,
            ),
            _KeyValueBlock(
              map: v.cast<String, dynamic>(),
              depth: depth + 1,
              valueTone: valueTone,
            ),
          ],
        ),
      );
    }
    // Liste: array elemanlarini dikey listele
    if (v is List) {
      return Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$keyText: (${v.length})',
              style: keyStyle,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final item in v) _listItem(context, item, valueTone),
                ],
              ),
            ),
          ],
        ),
      );
    }
    // Primitive
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: keyWidth,
            child: Text('$keyText:', style: keyStyle),
          ),
          Expanded(
            child: SelectableText(
              _formatPrimitive(v),
              style: mono.copyWith(
                color: _primitiveColor(context, v, valueTone),
                fontWeight: v is bool ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listItem(BuildContext context, dynamic item, _ValueTone tone) {
    final mono = _mono(context);
    final cs = Theme.of(context).colorScheme;
    if (item is Map) {
      return Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: _KeyValueBlock(
          map: item.cast<String, dynamic>(),
          depth: 0,
          valueTone: tone,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: mono.copyWith(
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
          ),
          Expanded(
            child: SelectableText(
              _formatPrimitive(item),
              style: mono.copyWith(color: _primitiveColor(context, item, tone)),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tek komut detayi: `help wifi.connect` cevabinda kullanilir. Firmware
// tarafindan gonderilen `usage` ve `help_block` field'lari varsa
// gosterilir (bunlar sk_cli_command_t struct'inda tanimli, sk_wifi.c gibi
// dosyalarda dolduruluyor; eski firmware bunlari null gonderirse satir
// gosterilmez).
// ---------------------------------------------------------------------------

class _CommandDetail extends StatelessWidget {
  const _CommandDetail({required this.node});
  final dynamic node;

  @override
  Widget build(BuildContext context) {
    final mono = _mono(context);
    final cs = Theme.of(context).colorScheme;
    final m = node is Map ? node.cast<String, dynamic>() : <String, dynamic>{};
    final name = (m['name'] ?? '').toString();
    final summary = (m['summary'] ?? '').toString();
    final usage = m['usage']?.toString();
    final helpBlock = m['help_block']?.toString();
    final critical = m['critical'] == true;
    final hidden = m['hidden'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Komut adi + chips
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            SelectableText(
              name,
              style: mono.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: cs.primary,
              ),
            ),
            if (critical)
              _Pill(label: 'critical', color: SkColors.warnRed),
            if (hidden)
              _Pill(label: 'hidden', color: cs.onSurface.withValues(alpha: 0.5)),
          ],
        ),
        if (summary.isNotEmpty) ...[
          const SizedBox(height: 4),
          SelectableText(
            summary,
            style: mono.copyWith(
              color: cs.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
        if (usage != null && usage.isNotEmpty) ...[
          const SizedBox(height: 12),
          _DetailLabel(label: 'Kullanim'),
          const SizedBox(height: 4),
          _DetailBlock(text: usage, mono: mono, cs: cs),
        ],
        if (helpBlock != null && helpBlock.isNotEmpty) ...[
          const SizedBox(height: 10),
          _DetailLabel(label: 'Detay'),
          const SizedBox(height: 4),
          _DetailBlock(text: helpBlock, mono: mono, cs: cs),
        ],
        if ((usage == null || usage.isEmpty) &&
            (helpBlock == null || helpBlock.isEmpty)) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: SelectableText(
              "Bu komutta usage / help_block tanimi yok. "
              "Firmware tarafinda sk_cli_command_t kaydina eklenmesi gerekir.",
              style: mono.copyWith(
                color: cs.onSurface.withValues(alpha: 0.55),
                fontSize: 11.5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DetailLabel extends StatelessWidget {
  const _DetailLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: SkColors.attentionMustard,
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({
    required this.text,
    required this.mono,
    required this.cs,
  });
  final String text;
  final TextStyle mono;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: SelectableText(
        text,
        style: mono.copyWith(
          color: cs.onSurface.withValues(alpha: 0.85),
          height: 1.45,
          fontSize: 12.5,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// String list (device.commands gibi)
// ---------------------------------------------------------------------------

class _StringListBlock extends StatelessWidget {
  const _StringListBlock({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final mono = _mono(context);
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Pill(label: 'OK', color: SkColors.attentionMustard),
            const SizedBox(width: 8),
            Text(
              '${items.length} öğe',
              style: mono.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            for (final s in items)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(s, style: mono),
              ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Event blok
// ---------------------------------------------------------------------------

class _EventBlock extends StatelessWidget {
  const _EventBlock({required this.entry});
  final ConsoleEntryEvent entry;

  @override
  Widget build(BuildContext context) {
    final mono = _mono(context);
    final cs = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    final decoded = _safeDecode(entry.raw);
    final body = decoded is Map ? decoded.cast<String, dynamic>() : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Pill(label: l.usbConsoleEntryEvent, color: cs.onSurface),
            const SizedBox(width: 8),
            SelectableText(
              entry.evt,
              style: mono.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
        if (body != null && body.isNotEmpty) ...[
          const SizedBox(height: 4),
          _KeyValueBlock(
            map: Map<String, dynamic>.fromEntries(
              body.entries.where((e) => e.key != 'evt'),
            ),
            depth: 0,
          ),
        ],
      ],
    );
  }

  static dynamic _safeDecode(String raw) {
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }
}

// ---------------------------------------------------------------------------
// Lokal hata (timeout, baglanti yok)
// ---------------------------------------------------------------------------

class _LocalErrorBlock extends StatelessWidget {
  const _LocalErrorBlock({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final mono = _mono(context);
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Pill(label: l.usbConsoleEntryError, color: SkColors.warnRed),
        const SizedBox(height: 2),
        SelectableText(
          message,
          style: mono.copyWith(color: SkColors.warnRed),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Ortak parcalar
// ---------------------------------------------------------------------------

TextStyle _mono(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return TextStyle(
    fontFamily: 'monospace',
    fontSize: 12,
    height: 1.35,
    color: cs.onSurface,
  );
}

String _formatPrimitive(dynamic v) {
  if (v == null) return 'null';
  if (v is bool) return v ? 'true' : 'false';
  if (v is String) return '"$v"';
  return v.toString();
}

Color _primitiveColor(BuildContext context, dynamic v, _ValueTone tone) {
  final cs = Theme.of(context).colorScheme;
  if (tone == _ValueTone.error) return SkColors.warnRed;
  if (v == null) return cs.onSurface.withValues(alpha: 0.4);
  if (v is bool) return cs.onSurface.withValues(alpha: v ? 1.0 : 0.7);
  if (v is num) return cs.primary;
  return cs.onSurface;
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.55), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: color,
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _RawToggle extends StatelessWidget {
  const _RawToggle({required this.open, required this.onToggle});
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              open ? Icons.expand_less_rounded : Icons.code_rounded,
              size: 12,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 3),
            Text(
              open ? 'ham JSON gizle' : 'ham JSON',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RawJsonBlock extends StatelessWidget {
  const _RawJsonBlock({required this.raw});
  final String raw;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    String pretty = raw;
    try {
      final obj = jsonDecode(raw);
      const enc = JsonEncoder.withIndent('  ');
      pretty = enc.convert(obj);
    } catch (_) {/* */}
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: cs.outlineVariant, width: 0.5),
      ),
      child: SelectableText(
        pretty,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 11,
          height: 1.4,
          color: cs.onSurface.withValues(alpha: 0.78),
        ),
      ),
    );
  }
}
