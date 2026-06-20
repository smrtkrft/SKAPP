// Faz 1 — saf-mantık testi: manifest JSON parse.
//
// script_manifest.dart ([lib/features/skapi/data/script_manifest.dart])
// bundled SKAPI script/grup/platform manifestlerinin fromJson çekirdeği.
// Faz 3'te bu loader'lara try/catch + path doğrulama eklenecek; bu testler
// happy-path ve default davranışı kilitler. (ApiTemplateManifest zaten
// skapi_madde_24_test.dart'ta kapsanıyor.)

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/features/skapi/data/script_manifest.dart';

void main() {
  group('ScriptManifest.fromJson', () {
    test('tüm alanlar + params parse edilir', () {
      final json = {
        'id': 'save-active-window',
        'platform': 'win',
        'group': 'save-work',
        'tier': 2,
        'runtime': 'powershell-5.1',
        'scriptFile': 'save-active-window.ps1',
        'i18n': {
          'title': 'titleKey',
          'summaryWhat': 'whatKey',
          'summaryHow': 'howKey',
          'note': 'noteKey',
        },
        'remoteRunnable': true,
        'params': [
          {
            'name': 'timeout',
            'type': 'int',
            'default': 5,
            'i18nLabel': 'lblTimeout',
            'min': 0,
            'max': 60,
          },
        ],
      };
      final m = ScriptManifest.fromJson(json);
      expect(m.id, 'save-active-window');
      expect(m.platform, 'win');
      expect(m.group, 'save-work');
      expect(m.tier, 2);
      expect(m.runtime, 'powershell-5.1');
      expect(m.scriptFile, 'save-active-window.ps1');
      expect(m.i18nNote, 'noteKey');
      expect(m.remoteRunnable, isTrue);
      expect(m.params, hasLength(1));
      final p = m.params.single;
      expect(p.name, 'timeout');
      expect(p.type, 'int');
      expect(p.defaultValue, 5);
      expect(p.minValue, 0);
      expect(p.maxValue, 60);
    });

    test('opsiyonel alanlar yokken güvenli defaultlar', () {
      final json = {
        'id': 'minimal',
        'platform': 'win',
        'group': 'g',
        'runtime': 'powershell-5.1',
        'scriptFile': 'minimal.ps1',
        'i18n': {
          'title': 't',
          'summaryWhat': 'w',
          'summaryHow': 'h',
        },
      };
      final m = ScriptManifest.fromJson(json);
      expect(m.tier, 1); // default
      expect(m.i18nNote, isNull); // opsiyonel
      expect(m.remoteRunnable, isFalse); // güvenli default
      expect(m.params, isEmpty);
    });
  });

  group('GroupManifest.fromJson', () {
    test('scriptIds "scripts" listesinden okunur', () {
      final json = {
        'id': 'save-work',
        'platform': 'win',
        'i18nTitle': 'tt',
        'i18nDesc': 'dd',
        'i18nFoot': 'ff',
        'scripts': ['a', 'b', 'c'],
      };
      final m = GroupManifest.fromJson(json);
      expect(m.id, 'save-work');
      expect(m.scriptIds, ['a', 'b', 'c']);
      expect(m.i18nFoot, 'ff');
    });

    test('scripts yoksa boş liste, foot null', () {
      final json = {
        'id': 'g',
        'platform': 'win',
        'i18nTitle': 't',
        'i18nDesc': 'd',
      };
      final m = GroupManifest.fromJson(json);
      expect(m.scriptIds, isEmpty);
      expect(m.i18nFoot, isNull);
    });
  });

  group('PlatformManifest.fromJson', () {
    test('groups + apiTemplates birlikte okunur', () {
      final json = {
        'platform': 'win',
        'runtime': 'powershell-5.1',
        'groups': ['save-work', 'focus'],
        'apiTemplates': ['x'],
      };
      final m = PlatformManifest.fromJson(json);
      expect(m.groupIds, ['save-work', 'focus']);
      expect(m.apiTemplateIds, ['x']);
    });

    test('listeler yoksa boş', () {
      final m = PlatformManifest.fromJson({
        'platform': 'other-iot',
        'runtime': 'iot-api',
      });
      expect(m.groupIds, isEmpty);
      expect(m.apiTemplateIds, isEmpty);
    });
  });
}
