// sd_validators birim testleri. (Bundled şablon asset kapısı Faz B'de
// test/features/skapi/data/device_template_assets_test.dart'a taşındı —
// assets/sd_profiles kaldırıldı, içerik assets/skapi/templates altında.)
// Firmware tarafındaki ikiz: SynDimm test/host/test_profiles.c.

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/devices/validators/sd_validators.dart';

void main() {
  group('validateProfileJson', () {
    String valid({String id = 'x'}) =>
        '{"v":2,"id":"$id","protocol":"http"}';

    test('geçerli asgari profil', () {
      expect(validateProfileJson(valid()), isNull);
    });
    test('boş / whitespace', () {
      expect(validateProfileJson('')!.kind, SdProfileJsonError.empty);
      expect(validateProfileJson('  \n')!.kind, SdProfileJsonError.empty);
    });
    test('2048 bayt sınırı', () {
      final big = '{"v":2,"id":"x","protocol":"http","pad":"${'a' * 2048}"}';
      expect(validateProfileJson(big)!.kind, SdProfileJsonError.tooBig);
    });
    test('bozuk JSON detay taşır', () {
      final issue = validateProfileJson('{nope')!;
      expect(issue.kind, SdProfileJsonError.invalidJson);
      expect(issue.detail, isNotEmpty);
    });
    test('nesne değil', () {
      expect(validateProfileJson('[1,2]')!.kind,
          SdProfileJsonError.notObject);
    });
    test('id zorunlu', () {
      expect(validateProfileJson('{"v":2,"protocol":"http"}')!.kind,
          SdProfileJsonError.idRequired);
    });
    test('id 15 sınırı ve alfabe (NVS anahtarı)', () {
      expect(validateProfileJson(valid(id: 'a' * 15)), isNull);
      expect(validateProfileJson(valid(id: 'a' * 16))!.kind,
          SdProfileJsonError.idFormat);
      expect(validateProfileJson(valid(id: 'a b'))!.kind,
          SdProfileJsonError.idFormat);
      expect(validateProfileJson(valid(id: 'shelly_dim-g2')), isNull);
    });
    test('v == 2 şart', () {
      expect(
          validateProfileJson('{"v":1,"id":"x","protocol":"http"}')!.kind,
          SdProfileJsonError.version);
    });
  });

  group('validateSafeSequence (ürün kuralı: 3-6 segment, 1-50 tık)', () {
    test('geçerli örnekler', () {
      expect(validateSafeSequence('L3-R5-L2'), isNull);
      expect(validateSafeSequence('l3-r5-l2'), isNull); // upper-case edilir
      expect(validateSafeSequence('R50-L50-R50-L50-R50-L50'), isNull); // 6 seg
      expect(validateSafeSequence('L3-R5-L2-B'), isNull); // -B sayılmaz
      expect(validateSafeSequence('R1-L1-R1-L1-R1-L1-B'), isNull); // 6+B
    });
    test('boş', () {
      expect(validateSafeSequence(''), SdSafeSequenceError.required);
    });
    test('format hataları', () {
      expect(validateSafeSequence('X3-R5-L2'), SdSafeSequenceError.format);
      expect(validateSafeSequence('L0-R5-L2'), SdSafeSequenceError.format);
      expect(validateSafeSequence('L3-'), SdSafeSequenceError.format);
      expect(validateSafeSequence('L3-B-R5'), SdSafeSequenceError.format);
      expect(validateSafeSequence('L51-R5-L2'), SdSafeSequenceError.format);
    });
    test('min 3', () {
      expect(validateSafeSequence('L3-R5'), SdSafeSequenceError.tooShort);
      expect(validateSafeSequence('L3-R5-B'), SdSafeSequenceError.tooShort);
    });
    test('max 6 (kuyruk -B segment sayılmaz)', () {
      expect(validateSafeSequence('R1-L1-R1-L1-R1-L1-R1'),
          SdSafeSequenceError.tooLong); // 7
      expect(validateSafeSequence('R1-L1-R1-L1-R1-L1'), isNull); // tam 6
    });
  });

  group('validateModeBindingJson (Binding v2 aynası)', () {
    const validDimmer = '{"v":2,"behavior":"dimmer","enabled":true,'
        '"targets":[{"host":"192.168.1.40","port":80}]}';
    const validMqtt = '{"v":2,"behavior":"mqtt_remote",'
        '"params":{"broker":"192.168.1.2","topic":"x"}}';

    test('geçerli örnekler', () {
      expect(validateModeBindingJson(validDimmer), isNull);
      expect(validateModeBindingJson(validMqtt), isNull);
    });
    test('boş / bozuk / nesne değil', () {
      expect(validateModeBindingJson('')!.kind, SdModeJsonError.empty);
      expect(
          validateModeBindingJson('{nope')!.kind, SdModeJsonError.invalidJson);
      expect(validateModeBindingJson('[1]')!.kind, SdModeJsonError.notObject);
    });
    test('v == 2 şart', () {
      expect(validateModeBindingJson('{"v":1,"behavior":"dimmer"}')!.kind,
          SdModeJsonError.version);
    });
    test('behavior zorunlu ve bilinen küme', () {
      expect(validateModeBindingJson('{"v":2}')!.kind,
          SdModeJsonError.behaviorRequired);
      expect(validateModeBindingJson('{"v":2,"behavior":"disco"}')!.kind,
          SdModeJsonError.behaviorUnknown);
    });
    test('dimmer/shutter hedef ister, mqtt_remote istemez', () {
      expect(validateModeBindingJson('{"v":2,"behavior":"dimmer"}')!.kind,
          SdModeJsonError.targetRequired);
      expect(
          validateModeBindingJson(
              '{"v":2,"behavior":"shutter","targets":[{}]}')!.kind,
          SdModeJsonError.targetRequired);
      expect(validateModeBindingJson('{"v":2,"behavior":"mqtt_remote"}'),
          isNull);
    });
  });

  group('validateSafeEntryJson (Safe v2 aynası)', () {
    const valid = '{"v":2,"enabled":true,"sequence":"L3-R5-L2",'
        '"endpoint":"webhook1"}';

    test('geçerli örnek', () {
      expect(validateSafeEntryJson(valid), isNull);
    });
    test('v == 2 şart', () {
      expect(
          validateSafeEntryJson(
              '{"v":1,"sequence":"L3-R5-L2","endpoint":"x"}')!.kind,
          SdSafeJsonError.version);
    });
    test('sequence kuralları detayıyla yüzeye çıkar', () {
      final issue = validateSafeEntryJson(
          '{"v":2,"sequence":"L3-R5","endpoint":"x"}')!;
      expect(issue.kind, SdSafeJsonError.sequence);
      expect(issue.detail, 'tooShort');
    });
    test('endpoint zorunlu', () {
      expect(
          validateSafeEntryJson('{"v":2,"sequence":"L3-R5-L2"}')!.kind,
          SdSafeJsonError.endpointRequired);
    });
  });
}
