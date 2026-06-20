// Faz 4 — DevicePlugin registry testleri.
//
// Registry'nin bilinen prefix'leri doğru plugin'e eşlediğini, bilinmeyenin
// null döndüğünü (→ _UnsupportedDevice fallback), her plugin'in metadata'sının
// (isMobilePeer, eventCatalog, defaultBindEvent, home screen tipi) eski
// davranışı koruduğunu doğrular.

import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/core/devices/device_plugin.dart';
import 'package:skapp/core/devices/device_plugin_registry.dart';
import 'package:skapp/features/devices/bf/bf_home_screen.dart';
import 'package:skapp/features/devices/lebensspur/ls_home_screen.dart';
import 'package:skapp/features/devices/ms/ms_home_screen.dart';

void main() {
  group('pluginFor', () {
    test('bilinen prefix\'ler doğru plugin\'i döndürür', () {
      expect(pluginFor('BF')?.prefix, 'BF');
      expect(pluginFor('LS')?.prefix, 'LS');
      expect(pluginFor('MS')?.prefix, 'MS');
    });

    test('bilinmeyen prefix null döner (→ _UnsupportedDevice)', () {
      expect(pluginFor('XX'), isNull);
      expect(pluginFor(''), isNull);
    });

    test('null prefix null döner', () {
      expect(pluginFor(null), isNull);
    });
  });

  group('isMobilePeer', () {
    test('yalnızca MS için true', () {
      expect(pluginFor('BF')!.isMobilePeer, isFalse);
      expect(pluginFor('LS')!.isMobilePeer, isFalse);
      expect(pluginFor('MS')!.isMobilePeer, isTrue);
    });
  });

  group('eventCatalog', () {
    test('BF kataloğu dolu ve timer.expired içerir', () {
      final catalog = pluginFor('BF')!.eventCatalog;
      expect(catalog, isNotEmpty);
      expect(catalog.map((e) => e.value), contains('timer.expired'));
    });

    test('MS kataloğu skapp.mobile.tap içerir', () {
      final catalog = pluginFor('MS')!.eventCatalog;
      expect(catalog.map((e) => e.value), contains('skapp.mobile.tap'));
    });

    test('LS kataloğu boş (henüz event yok)', () {
      expect(pluginFor('LS')!.eventCatalog, isEmpty);
    });

    test('katalog elemanları DeviceEvent tipinde', () {
      expect(pluginFor('BF')!.eventCatalog.first, isA<DeviceEvent>());
    });
  });

  group('defaultBindEvent', () {
    test('BF ve LS timer.expired (eski else-branch davranışı)', () {
      expect(pluginFor('BF')!.defaultBindEvent, 'timer.expired');
      expect(pluginFor('LS')!.defaultBindEvent, 'timer.expired');
    });

    test('MS skapp.mobile.tap', () {
      expect(pluginFor('MS')!.defaultBindEvent, 'skapp.mobile.tap');
    });
  });

  group('buildHomeScreen', () {
    test('her plugin doğru home screen tipini kurar', () {
      expect(pluginFor('BF')!.buildHomeScreen('BF-A06'), isA<BfHomeScreen>());
      expect(pluginFor('LS')!.buildHomeScreen('LS-001'), isA<LsHomeScreen>());
      expect(pluginFor('MS')!.buildHomeScreen('uuid-1'), isA<MsHomeScreen>());
    });
  });

  group('görsel kimlik (DeviceTypeVisual ile tutarlı)', () {
    test('displayName boş değil', () {
      expect(pluginFor('BF')!.displayName, 'Blocking Focus');
      expect(pluginFor('LS')!.displayName, 'LebensSpur');
      expect(pluginFor('MS')!.displayName, 'SKAPP Mobile');
    });

    test('icon her plugin için tanımlı', () {
      expect(pluginFor('BF')!.icon, isNotNull);
      expect(pluginFor('LS')!.icon, isNotNull);
      expect(pluginFor('MS')!.icon, isNotNull);
    });
  });
}
