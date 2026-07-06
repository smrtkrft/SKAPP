// Cihaz Şablonları kütüphanesi — assets/skapi/templates/*.json yükleyici.
//
// Dosya adları hardcode edilmez: AssetManifest üzerinden enumerate edilir
// (SdProfileCatalog deseni) ki yeni bir şablon JSON'u eklemek pubspec'teki
// klasör girdisi dışında kod değişikliği istemesin. Bozuk bir asset tüm
// kütüphaneyi düşürmesin diye dosya başına tolerantdır.

import 'package:flutter/services.dart';

import 'device_template.dart';

class DeviceTemplateRepository {
  DeviceTemplateRepository({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  static const _prefix = 'assets/skapi/templates/';

  List<DeviceTemplate>? _cache;

  Future<List<DeviceTemplate>> loadAll() async {
    final cached = _cache;
    if (cached != null) return cached;

    final manifest = await AssetManifest.loadFromAssetBundle(_bundle);
    final paths = manifest
        .listAssets()
        .where((p) => p.startsWith(_prefix) && p.endsWith('.json'))
        .toList()
      ..sort();

    final out = <DeviceTemplate>[];
    for (final path in paths) {
      try {
        out.add(DeviceTemplate.decode(await _bundle.loadString(path)));
      } catch (_) {/* bozuk asset atlanır */}
    }
    _cache = out;
    return out;
  }

  /// Kategori → şablon listesi; kategori sırası [kTemplateCategories],
  /// bilinmeyen kategoriler sona "other" anahtarında toplanır (asset
  /// yazım hatası sessizce kaybolmasın, listede görünsün).
  static Map<String, List<DeviceTemplate>> groupByCategory(
      List<DeviceTemplate> all) {
    final out = <String, List<DeviceTemplate>>{
      for (final c in kTemplateCategories) c: <DeviceTemplate>[],
    };
    for (final t in all) {
      (out[kTemplateCategories.contains(t.category) ? t.category : 'other'] ??=
              <DeviceTemplate>[])
          .add(t);
    }
    out.removeWhere((_, list) => list.isEmpty);
    return out;
  }
}
