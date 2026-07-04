// SynDimm hedef-cihaz profil kataloğu — assets/sd_profiles/*.json yükleyici.
//
// Kaynak-of-truth FIRMWARE repo'sudur (SynDimm/Code/neue/profiles/); asset
// seti oradan elle senkronlanır. Dosya adları hardcode edilmez: AssetManifest
// üzerinden enumerate edilir ki yeni bir profil JSON'u eklemek pubspec'teki
// klasör girdisi dışında kod değişikliği istemesin.

import 'dart:convert';

import 'package:flutter/services.dart';

/// Katalogdaki tek profil. [rawJson] cihaza `profile.add` ile basılacak
/// kompakt olmayan orijinal metindir (önizlemede olduğu gibi gösterilir).
class SdCatalogProfile {
  const SdCatalogProfile({
    required this.id,
    required this.name,
    required this.protocol,
    required this.behaviors,
    required this.rawJson,
  });

  final String id;
  final String name;
  final String protocol;
  final List<String> behaviors;
  final String rawJson;

  /// MQTT jenerik profilleri kullanıcı kişiselleştirmesi ister: cihaz
  /// başına topic prefix'i (+ çoklu cihazda benzersiz id). Seçici bu
  /// bayrağa göre düzenleme alanlarını gösterir.
  bool get isMqtt => protocol == 'mqtt';
}

class SdProfileCatalog {
  SdProfileCatalog._(this.profiles);

  final List<SdCatalogProfile> profiles;

  static SdProfileCatalog? _cached;

  /// Bundled kataloğu yükler (ilk çağrıda; sonrası bellekten). Bozuk bir
  /// asset tüm kataloğu düşürmesin diye girdi başına tolerantdır.
  static Future<SdProfileCatalog> load() async {
    if (_cached != null) return _cached!;
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest
        .listAssets()
        .where((p) =>
            p.startsWith('assets/sd_profiles/') && p.endsWith('.json'))
        .toList()
      ..sort();
    final out = <SdCatalogProfile>[];
    for (final path in paths) {
      try {
        final raw = await rootBundle.loadString(path);
        final m = jsonDecode(raw);
        if (m is! Map || m['v'] != 2) continue;
        final id = m['id']?.toString() ?? '';
        if (id.isEmpty) continue;
        out.add(SdCatalogProfile(
          id: id,
          name: m['name']?.toString() ?? id,
          protocol: m['protocol']?.toString() ?? '?',
          behaviors: [
            if (m['behaviors'] is List)
              for (final b in m['behaviors'] as List) b.toString(),
          ],
          rawJson: raw,
        ));
      } catch (_) {/* bozuk asset atlanır */}
    }
    _cached = SdProfileCatalog._(out);
    return _cached!;
  }

  /// Davranışa uyan profiller (behaviors alanı boş olanlar her davranışa
  /// uyar sayılır — geriye-uyum, firmware de aynı toleransı gösterir).
  List<SdCatalogProfile> forBehavior(String behavior) => [
        for (final p in profiles)
          if (p.behaviors.isEmpty || p.behaviors.contains(behavior)) p,
      ];
}
