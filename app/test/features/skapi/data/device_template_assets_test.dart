// Bundled şablon kataloğu bütünlük kapısı — assets/skapi/templates/*.json
// dosyalarını DOSYA SİSTEMİNDEN okur (flutter test cwd = app kökü); bozuk
// bir şablon asset'i CI'da burada yakalanır. sd.profile gövdeleri firmware
// profil kurallarından, sd.mode gövdeleri Binding v2 kurallarından geçer —
// {{param}} yer tutucuları tip-uyumlu örnek değerlerle doldurularak.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/devices/validators/sd_validators.dart';
import 'package:skapp/features/skapi/data/device_template.dart';
import 'package:skapp/features/skapi/data/template_render.dart';

/// Param tipine göre örnek değer: int yer tutucuları JSON'da tırnaksız
/// geçebilir, "x" basmak gövdeyi bozar.
String _sampleFor(TemplateParam p) {
  if (p.defaultValue != null && p.defaultValue!.isNotEmpty) {
    return p.defaultValue!;
  }
  return switch (p.type) {
    'int' => '1',
    'host' => '192.168.1.40',
    _ => 'ornek',
  };
}

void main() {
  final dir = Directory('assets/skapi/templates');
  final files = dir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  test('şablon klasörü mevcut ve dolu', () {
    expect(dir.existsSync(), isTrue, reason: 'şablon asset klasörü eksik');
    expect(files.length, greaterThanOrEqualTo(19),
        reason: '12 SD profil sarması + 3 mode + 1 safe + 4 webhook');
  });

  test('tüm asset\'ler decode olur, id\'ler benzersiz, kategoriler geçerli',
      () {
    final ids = <String>{};
    for (final f in files) {
      final tpl = DeviceTemplate.decode(f.readAsStringSync());
      expect(ids.add(tpl.id), isTrue,
          reason: '${f.path}: id "${tpl.id}" tekrar ediyor');
      expect(kTemplateCategories.contains(tpl.category), isTrue,
          reason: '${f.path}: bilinmeyen kategori "${tpl.category}"');
      expect(tpl.compatiblePrefixes, isNotEmpty,
          reason: '${f.path}: uyumluluk rozeti boş olamaz');
      // Dosya adı = id sözleşmesi (AssetManifest enumerate düzeni).
      expect(f.path.endsWith('${tpl.id}.json'), isTrue,
          reason: '${f.path}: dosya adı id ile eşleşmeli');
    }
  });

  test('sd.profile gövdeleri (örnek değerlerle) firmware kurallarından geçer',
      () {
    for (final f in files) {
      final tpl = DeviceTemplate.decode(f.readAsStringSync());
      if (tpl.targetKind != TemplateTargetKind.sdProfile) continue;
      final values = {for (final p in tpl.params) p.name: _sampleFor(p)};
      final rendered = renderTemplate(tpl.jsonBody!, values);
      expect(unresolvedPlaceholders(rendered), isEmpty,
          reason: '${f.path}: params listesi gövdedeki tüm '
              '{{yer tutucuları}} kapsamıyor');
      expect(validateProfileJson(rendered), isNull,
          reason: '${f.path}: profil kurallarından geçemedi');
      expect(tpl.source, isNotNull,
          reason: '${f.path}: firmware köken işareti (source) şart');
    }
  });

  test('sd.mode gövdeleri (örnek değerlerle) Binding v2 kurallarından geçer',
      () {
    for (final f in files) {
      final tpl = DeviceTemplate.decode(f.readAsStringSync());
      if (tpl.targetKind != TemplateTargetKind.sdMode) continue;
      final values = {for (final p in tpl.params) p.name: _sampleFor(p)};
      final rendered = renderTemplate(tpl.jsonBody!, values);
      expect(unresolvedPlaceholders(rendered), isEmpty,
          reason: '${f.path}: kapsanmayan {{yer tutucu}}');
      expect(validateModeBindingJson(rendered), isNull,
          reason: '${f.path}: Binding v2 kurallarından geçemedi');
    }
  });

  test('sd.safe gövdeleri (örnek değerlerle) Safe v2 kurallarından geçer', () {
    for (final f in files) {
      final tpl = DeviceTemplate.decode(f.readAsStringSync());
      if (tpl.targetKind != TemplateTargetKind.sdSafe) continue;
      final values = {for (final p in tpl.params) p.name: _sampleFor(p)};
      final rendered = renderTemplate(tpl.jsonBody!, values);
      expect(validateSafeEntryJson(rendered), isNull,
          reason: '${f.path}: Safe v2 kurallarından geçemedi');
    }
  });

  test('bf.endpoint şablonları gömülü manifest taşır ve tek-süslü '
      'firmware token\'ları korunur', () {
    for (final f in files) {
      final tpl = DeviceTemplate.decode(f.readAsStringSync());
      if (tpl.targetKind != TemplateTargetKind.bfEndpoint) continue;
      final ep = tpl.endpoint;
      expect(ep, isNotNull, reason: '${f.path}: defaults bloğu eksik');
      expect(ep!.urlTemplate, isNotEmpty);
      // Gövde şablonundaki tek-süslü {event}/{device} token'ları config-time
      // render'dan DOKUNULMADAN çıkmalı (cihaz ateşleme anında doldurur).
      final payload = ep.payloadTemplate;
      if (payload != null && payload.contains('{event}')) {
        final values = {
          for (final p in tpl.params) p.name: _sampleFor(p),
        };
        expect(renderTemplate(payload, values).contains('{event}'), isTrue,
            reason: '${f.path}: firmware token config-time render\'da '
                'bozuldu');
      }
    }
  });

  test('mqtt jenerik sarmalarında id/prefix parametreleri var', () {
    for (final f in files) {
      final tpl = DeviceTemplate.decode(f.readAsStringSync());
      if (tpl.targetKind != TemplateTargetKind.sdProfile) continue;
      final body = jsonDecode(renderTemplate(
        tpl.jsonBody!,
        {for (final p in tpl.params) p.name: _sampleFor(p)},
      )) as Map<String, dynamic>;
      if (body['protocol'] != 'mqtt') continue;
      final names = {for (final p in tpl.params) p.name};
      expect(names.containsAll({'mqtt-id', 'mqtt-prefix'}), isTrue,
          reason: '${f.path}: MQTT jeneriği kişiselleştirme paramları '
              '(mqtt-id, mqtt-prefix) taşımalı');
    }
  });
}
