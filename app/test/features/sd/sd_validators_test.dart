// sd_validators birim testleri + bundled katalog kapısı.
//
// Katalog testi assets/sd_profiles/*.json dosyalarını DOSYA SİSTEMİNDEN okur
// (flutter test cwd = app kökü) — rootBundle/widget ortamı gerektirmez; bozuk
// bir katalog asset'i CI'da burada yakalanır. Firmware tarafındaki ikizi:
// SynDimm test/host/test_profiles.c (aynı kurallar, repo profiles/ üstünde).

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/features/devices/sd/sd_validators.dart';

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

  group('bundled katalog kapısı', () {
    test('assets/sd_profiles/*.json tamamı kurallardan geçer', () {
      final dir = Directory('assets/sd_profiles');
      expect(dir.existsSync(), isTrue,
          reason: 'katalog asset klasörü eksik');
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .toList();
      expect(files.length, greaterThanOrEqualTo(12),
          reason: '2026-07-03 itibarıyla 12 profil');
      for (final f in files) {
        final raw = f.readAsStringSync();
        expect(validateProfileJson(raw), isNull,
            reason: '${f.path} katalog kurallarından geçemedi');
        // Seçicinin gösterdiği alanlar mevcut ve davranış bildirimi var.
        final m = jsonDecode(raw) as Map<String, dynamic>;
        expect(m['behaviors'], isA<List<dynamic>>(),
            reason: '${f.path}: behaviors[] seçici filtresi için şart');
        expect((m['behaviors'] as List).isNotEmpty, isTrue,
            reason: '${f.path}: boş behaviors[] filtrede her yerde görünür');
      }
    });
  });
}
