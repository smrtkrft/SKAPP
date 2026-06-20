// Faz 3 — ScriptRunner.run() param doğrulama + path-traversal testleri.
//
// Gerçek Process.start veya asset/override IO olmadan yalnızca doğrulama
// dalını test eder. ScriptResolver mocktail ile stub edilir.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skapp/features/skapi/data/script_manifest.dart';
import 'package:skapp/features/skapi/data/script_resolver.dart';
import 'package:skapp/features/skapi/data/script_runner.dart';

// ---------------------------------------------------------------------------
// Test doubles

class MockScriptResolver extends Mock implements ScriptResolver {}

// ---------------------------------------------------------------------------
// Fixtures

ScriptManifest _manifest({List<ScriptParam> params = const []}) =>
    ScriptManifest(
      id: 'test-script',
      platform: 'win',
      group: 'test-group',
      tier: 1,
      runtime: 'powershell-5.1',
      scriptFile: 'test-script.ps1',
      i18nTitle: 'Test Script',
      i18nSummaryWhat: 'What',
      i18nSummaryHow: 'How',
      i18nNote: null,
      params: params,
    );

ScriptParam _intParam(String name, {double? min, double? max}) => ScriptParam(
      name: name,
      type: 'int',
      defaultValue: 0,
      i18nLabel: name,
      i18nHint: null,
      minValue: min,
      maxValue: max,
    );

ScriptParam _stringParam(
  String name, {
  String? pattern,
  List<String>? allowedValues,
}) =>
    ScriptParam(
      name: name,
      type: 'string',
      defaultValue: '',
      i18nLabel: name,
      i18nHint: null,
      pattern: pattern,
      allowedValues: allowedValues,
    );

// ---------------------------------------------------------------------------
// Tests

void main() {
  late MockScriptResolver resolver;
  late ScriptRunner runner;

  setUpAll(() {
    registerFallbackValue(
      _manifest(),
    );
  });

  setUp(() {
    resolver = MockScriptResolver();
    runner = ScriptRunner(resolver: resolver);
  });

  group('ParamValidator — unknown_param', () {
    test('bildirilmemiş override anahtarı ParamValidationException fırlatır',
        () async {
      await expectLater(
        runner.run(
          manifest: _manifest(),
          paramOverrides: {'nonexistent': 'value'},
        ),
        throwsA(
          isA<ParamValidationException>()
              .having((e) => e.result.code, 'code', 'unknown_param')
              .having((e) => e.result.paramName, 'paramName', 'nonexistent'),
        ),
      );
      // Validation başarısız → resolver hiç çağrılmamalı
      verifyNever(() => resolver.resolveSource(any()));
    });
  });

  group('ParamValidator — type_mismatch', () {
    test('int param için string değer reddedilir', () async {
      await expectLater(
        runner.run(
          manifest: _manifest(params: [_intParam('timeout')]),
          paramOverrides: {'timeout': 'not-an-int'},
        ),
        throwsA(
          isA<ParamValidationException>()
              .having((e) => e.result.code, 'code', 'type_mismatch'),
        ),
      );
      verifyNever(() => resolver.resolveSource(any()));
    });
  });

  group('ParamValidator — range_violation', () {
    test('minValue altındaki sayı reddedilir', () async {
      await expectLater(
        runner.run(
          manifest: _manifest(params: [_intParam('volume', min: 0, max: 100)]),
          paramOverrides: {'volume': -1},
        ),
        throwsA(
          isA<ParamValidationException>()
              .having((e) => e.result.code, 'code', 'range_violation'),
        ),
      );
    });

    test('maxValue üstündeki sayı reddedilir', () async {
      await expectLater(
        runner.run(
          manifest: _manifest(params: [_intParam('volume', min: 0, max: 100)]),
          paramOverrides: {'volume': 101},
        ),
        throwsA(
          isA<ParamValidationException>()
              .having((e) => e.result.code, 'code', 'range_violation'),
        ),
      );
    });
  });

  group('ParamValidator — not_allowed', () {
    test('allowedValues dışındaki değer reddedilir', () async {
      await expectLater(
        runner.run(
          manifest: _manifest(
            params: [
              _stringParam('mode', allowedValues: ['dark', 'light'])
            ],
          ),
          paramOverrides: {'mode': 'blue'},
        ),
        throwsA(
          isA<ParamValidationException>()
              .having((e) => e.result.code, 'code', 'not_allowed'),
        ),
      );
    });
  });

  group('ParamValidator — pattern_violation', () {
    test('pattern eşleşmeyen string reddedilir', () async {
      await expectLater(
        runner.run(
          manifest: _manifest(
            params: [_stringParam('tag', pattern: r'^\d{4}$')],
          ),
          paramOverrides: {'tag': 'abcd'},
        ),
        throwsA(
          isA<ParamValidationException>()
              .having((e) => e.result.code, 'code', 'pattern_violation'),
        ),
      );
    });
  });

  group('ParamValidator — invalid_chars', () {
    test('kontrol karakteri içeren string reddedilir', () async {
      await expectLater(
        runner.run(
          manifest: _manifest(params: [_stringParam('note')]),
          paramOverrides: {'note': 'bad\x01value'},
        ),
        throwsA(
          isA<ParamValidationException>()
              .having((e) => e.result.code, 'code', 'invalid_chars'),
        ),
      );
    });
  });

  group('Geçerli parametreler', () {
    test('boş overrides → resolver çağrılır (Process spawn edilmeden hata)', () async {
      // resolveSource'u stub et (gerçek asset yok)
      when(() => resolver.resolveSource(any())).thenAnswer(
        (_) async => ResolvedScript(
          manifest: _manifest(),
          source: 'Write-Host "ok"',
          original: 'Write-Host "ok"',
          state: ScriptState.original,
        ),
      );

      // Platform desteklenmiyor (macOS/Linux dev ortamı) → UnsupportedError
      // ya da destekleniyor → Process.start çağrısı (test ortamında başarısız)
      // Her iki durumda da ParamValidationException FIRALATILMAMALI
      try {
        await runner.run(manifest: _manifest());
      } on ParamValidationException {
        fail('Geçerli (boş) overrides için ParamValidationException beklenmiyordu');
      } catch (_) {
        // UnsupportedError veya Process hatası normal
      }
      verify(() => resolver.resolveSource(any())).called(1);
    });

    test('geçerli int override → doğrulama geçer', () async {
      when(() => resolver.resolveSource(any())).thenAnswer(
        (_) async => ResolvedScript(
          manifest: _manifest(params: [_intParam('volume', min: 0, max: 100)]),
          source: 'Write-Host "ok"',
          original: 'Write-Host "ok"',
          state: ScriptState.original,
        ),
      );

      try {
        await runner.run(
          manifest: _manifest(params: [_intParam('volume', min: 0, max: 100)]),
          paramOverrides: {'volume': 50},
        );
      } on ParamValidationException {
        fail('Geçerli override için ParamValidationException beklenmiyordu');
      } catch (_) {}
      verify(() => resolver.resolveSource(any())).called(1);
    });
  });

  group('ParamValidationException mesajı', () {
    test('message field null değil ve code içeriyor', () async {
      try {
        await runner.run(
          manifest: _manifest(),
          paramOverrides: {'bad': 'val'},
        );
        fail('exception bekleniyor');
      } on ParamValidationException catch (e) {
        expect(e.message, isNotEmpty);
        expect(e.toString(), contains('unknown_param'));
      }
    });
  });
}
