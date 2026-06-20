// Faz 1 — saf-mantık testi: ParamValidator + ParamMerge.
//
// param_merge.dart ([lib/features/skapi/data/param_merge.dart]) script
// parametrelerinin doğrulama ve argv üretim çekirdeği. ParamValidator şu an
// yalnızca HTTP yolunda çağrılıyor; Faz 3'te ScriptRunner.run()'a indirilip
// tüm yollara yayılacak. Bu testler o taşımayı korur (referans davranış).

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/features/skapi/data/param_merge.dart';
import 'package:skapp/features/skapi/data/script_manifest.dart';

ScriptParam _p(
  String name,
  String type, {
  Object? def,
  List<String>? allowed,
  String? pattern,
  double? min,
  double? max,
}) =>
    ScriptParam(
      name: name,
      type: type,
      defaultValue: def,
      i18nLabel: 'lbl_$name',
      i18nHint: null,
      allowedValues: allowed,
      pattern: pattern,
      minValue: min,
      maxValue: max,
    );

void main() {
  const validator = ParamValidator();
  const merge = ParamMerge();

  group('ParamValidator.validate · kabul', () {
    test('boş override geçer', () {
      final r = validator.validate(
          manifestParams: [_p('n', 'int')], overrides: const {});
      expect(r.ok, isTrue);
    });
    test('null değer (manifest default kullan) geçer', () {
      final r = validator.validate(
          manifestParams: [_p('n', 'int')], overrides: const {'n': null});
      expect(r.ok, isTrue);
    });
    test('aralık içi int geçer', () {
      final r = validator.validate(
          manifestParams: [_p('n', 'int', min: 0, max: 100)],
          overrides: const {'n': 50});
      expect(r.ok, isTrue);
    });
  });

  group('ParamValidator.validate · ret kodları', () {
    test('unknown_param', () {
      final r = validator.validate(
          manifestParams: [_p('known', 'int')], overrides: const {'ghost': 1});
      expect(r.ok, isFalse);
      expect(r.code, 'unknown_param');
      expect(r.paramName, 'ghost');
    });
    test('type_mismatch (string beklenirken int)', () {
      final r = validator.validate(
          manifestParams: [_p('s', 'string')], overrides: const {'s': 5});
      expect(r.code, 'type_mismatch');
    });
    test('range_violation (max aşımı)', () {
      final r = validator.validate(
          manifestParams: [_p('n', 'int', min: 0, max: 10)],
          overrides: const {'n': 99});
      expect(r.code, 'range_violation');
    });
    test('not_allowed (allowedValues dışı)', () {
      final r = validator.validate(
          manifestParams: [_p('mode', 'string', allowed: ['a', 'b'])],
          overrides: const {'mode': 'c'});
      expect(r.code, 'not_allowed');
    });
    test('pattern_violation', () {
      final r = validator.validate(
          manifestParams: [_p('hex', 'string', pattern: r'^[0-9a-f]+$')],
          overrides: const {'hex': 'XYZ'});
      expect(r.code, 'pattern_violation');
    });
    test('invalid_chars (C0 kontrol baytı)', () {
      final r = validator.validate(
          manifestParams: [_p('s', 'string')],
          overrides: const {'s': 'hello\x00world'});
      expect(r.code, 'invalid_chars');
    });
    test('TAB/LF/CR izinli (kontrol karakteri sayılmaz)', () {
      final r = validator.validate(
          manifestParams: [_p('s', 'string')],
          overrides: const {'s': 'line1\nline2\tend\r'});
      expect(r.ok, isTrue);
    });
    test('stringList içinde string olmayan eleman type_mismatch', () {
      final r = validator.validate(
          manifestParams: [_p('apps', 'stringList')],
          overrides: const {
            'apps': [1, 2]
          });
      expect(r.code, 'type_mismatch');
    });

    test('Madde 19 · stringList öğesinde virgül → invalid_chars (injection)',
        () {
      final r = validator.validate(
          manifestParams: [_p('apps', 'stringList')],
          overrides: const {
            'apps': ['chrome', 'code,notepad']
          });
      expect(r.code, 'invalid_chars');
      expect(r.paramName, 'apps');
    });

    test('Madde 19 · virgülsüz stringList kabul edilir', () {
      final r = validator.validate(
          manifestParams: [_p('apps', 'stringList')],
          overrides: const {
            'apps': ['chrome', 'code']
          });
      expect(r.ok, isTrue);
    });
  });

  group('ParamMerge.resolve · argv üretimi', () {
    test('bool true → switch, false → atlanır', () {
      final args = merge.resolve(
          manifestParams: [_p('verbose', 'bool')],
          overrides: const {'verbose': true});
      expect(args, ['-verbose']);
      final none = merge.resolve(
          manifestParams: [_p('verbose', 'bool')],
          overrides: const {'verbose': false});
      expect(none, isEmpty);
    });
    test('int / string → -name value', () {
      final args = merge.resolve(
          manifestParams: [_p('timeout', 'int'), _p('title', 'string')],
          overrides: const {'timeout': 5, 'title': 'hi'});
      expect(args, ['-timeout', '5', '-title', 'hi']);
    });
    test('stringList → virgülle birleşik', () {
      final args = merge.resolve(
          manifestParams: [_p('apps', 'stringList')],
          overrides: const {
            'apps': ['chrome', 'code']
          });
      expect(args, ['-apps', 'chrome,code']);
    });
    test('override yoksa manifest default kullanılır', () {
      final args = merge.resolve(
          manifestParams: [_p('timeout', 'int', def: 30)], overrides: const {});
      expect(args, ['-timeout', '30']);
    });
    test('default ve override null → parametre atlanır', () {
      final args = merge
          .resolve(manifestParams: [_p('opt', 'string')], overrides: const {});
      expect(args, isEmpty);
    });
  });

  // macOS/Linux .sh scriptleri --name value (bool dahil) bekliyor; PowerShell
  // -name + switch-bool. Runtime-aware ScriptRunner doğru stili seçer.
  group('ParamMerge.resolve · POSIX stili (mac/lx bash)', () {
    test('int/string → --name value (çift tire)', () {
      final args = merge.resolve(
        manifestParams: [_p('level', 'int'), _p('title', 'string')],
        overrides: const {'level': 50, 'title': 'hi'},
        style: ParamStyle.posix,
      );
      expect(args, ['--level', '50', '--title', 'hi']);
    });

    test('bool → --name true/false (switch DEĞİL, değer taşır)', () {
      final on = merge.resolve(
        manifestParams: [_p('verbose', 'bool')],
        overrides: const {'verbose': true},
        style: ParamStyle.posix,
      );
      expect(on, ['--verbose', 'true']);
      final off = merge.resolve(
        manifestParams: [_p('verbose', 'bool')],
        overrides: const {'verbose': false},
        style: ParamStyle.posix,
      );
      expect(off, ['--verbose', 'false']);
    });

    test('stringList → --name csv (virgülle, PS ile aynı)', () {
      final args = merge.resolve(
        manifestParams: [_p('apps', 'stringList')],
        overrides: const {
          'apps': ['chrome', 'code']
        },
        style: ParamStyle.posix,
      );
      expect(args, ['--apps', 'chrome,code']);
    });

    test('PowerShell stili varsayılan kalır (bool switch)', () {
      final args = merge.resolve(
        manifestParams: [_p('verbose', 'bool')],
        overrides: const {'verbose': true},
      );
      expect(args, ['-verbose']); // tek tire, değer yok
    });
  });
}
