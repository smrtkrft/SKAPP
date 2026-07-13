// Build-safe widget tests — Madde 24'ün Faz B halefi: cihaz-bazlı "Other"
// kategorilerinin yerine geçen Cihaz Şablonları kütüphanesi + detay ekranı.
//
// Render-only smoke testler: ekranlar minimal ProviderScope + MaterialApp
// kabuğunda mount edilir; ağaç istisnasız kurulur ve beklenen etiketler
// yüzeye çıkar. Etkileşimli cihaz akışları (gerçek BLE/TCP session) manuel
// test geçişine ertelidir.
//
// Kütüphane testi GERÇEK asset'leri yükler (AssetManifest üzerinden) —
// bozuk bir şablon JSON'u veya pubspec asset girdisi burada da yakalanır.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skapp/core/storage/paired_devices_store.dart';
import 'package:skapp/core/storage/preferences_provider.dart';
import 'package:skapp/features/skapi/data/device_template.dart';
import 'package:skapp/features/skapi/data/script_manifest.dart';
import 'package:skapp/features/skapi/data/skapi_providers.dart';
import 'package:skapp/features/skapi/skapi_template_detail_screen.dart';
import 'package:skapp/features/skapi/skapi_template_library_screen.dart';
import 'package:skapp/l10n/app_localizations.dart';

Future<void> _mountWithPrefs(
  WidgetTester tester,
  Widget child,
) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      // Riverpod 3: varsayılan retry başarısız FutureProvider'ı sessizce
      // yeniden dener → test sonsuz "loading" görür. Testte retry kapalı,
      // hata AsyncError olarak anında yüzeye çıkar.
      retry: (_, _) => null,
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: child,
      ),
    ),
  );
  // Let async providers fire one frame.
  await tester.pump();
}

/// Hermetik sd.mode şablonu — asset bağımlılığı yok.
const _modeTemplate = DeviceTemplate(
  id: 'test-mode',
  schemaVersion: 1,
  category: 'dimmer',
  targetKind: TemplateTargetKind.sdMode,
  compatiblePrefixes: ['SD'],
  i18nTitle: 'TEST_MODE_TITLE',
  i18nSummary: 'TEST_MODE_SUMMARY',
  params: [
    TemplateParam(
      name: 'host',
      placeholder: '{{host}}',
      i18nLabel: 'Hedef IP',
      type: 'host',
    ),
  ],
  jsonBody: '{"v":2,"behavior":"dimmer","enabled":true,'
      '"targets":[{"host":"{{host}}","port":80}]}',
);

void main() {
  group('Şablon kütüphanesi · cihaz-önce · gerçek asset\'lerle', () {
    testWidgets('gezinme cihaz kartlarını gösterir (renksiz, ikonsuz)',
        (tester) async {
      await _mountWithPrefs(tester, const SkapiTemplateLibraryScreen());
      // AssetManifest + 20 şablonun yüklenmesi için birkaç frame.
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      // Üst düzey artık cihaz kartları — kategori değil. (locale 'en')
      expect(find.text('DEVICES'), findsOneWidget);
      expect(find.text('SynDimm'), findsOneWidget);
      expect(find.text('LebensSpur'), findsOneWidget);
      expect(find.text('Blocking Focus'), findsOneWidget);
      // "Şablonlarım" bölümü boş durum metniyle var.
      expect(find.text('MY TEMPLATES'), findsOneWidget);
      // Nötr önek çipi (renk kodu değil) her karta düşer.
      expect(find.text('SD'), findsWidgets);
    });

    testWidgets(
        'cihaz detayı: Dimmer üretici-önce (kutucuk) → alt-sayfada Sürücüler/Modlar',
        (tester) async {
      // Hermetik: sabit liste enjekte edilir (ikinci gerçek-asset testinin
      // rootBundle future'ı FakeAsync bölgeleri arasında çözülmez tuzağı).
      const shellyProfile = DeviceTemplate(
        id: 'sd-profile-test-dim',
        schemaVersion: 1,
        category: 'dimmer',
        targetKind: TemplateTargetKind.sdProfile,
        compatiblePrefixes: ['SD'],
        i18nTitle: 'Test Dimmer Profili',
        i18nSummary: 'HTTP · dimmer',
        jsonBody: '{"v":2,"id":"test_dim","protocol":"http"}',
        manufacturer: 'Shelly',
      );
      // Mod: üretici yok → Genel kovasına düşer.
      const dimMode = DeviceTemplate(
        id: 'sd-mode-test',
        schemaVersion: 1,
        category: 'dimmer',
        targetKind: TemplateTargetKind.sdMode,
        compatiblePrefixes: ['SD'],
        i18nTitle: 'Test Dimmer Modu',
        i18nSummary: 'slot',
        jsonBody: '{"v":2,"behavior":"dimmer"}',
      );
      const bfWebhook = DeviceTemplate(
        id: 'bf-webhook-test',
        schemaVersion: 1,
        category: 'webhook',
        targetKind: TemplateTargetKind.bfEndpoint,
        compatiblePrefixes: ['BF'],
        i18nTitle: 'BF Test Webhook',
        i18nSummary: 'x',
      );
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          retry: (_, _) => null,
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            deviceTemplatesProvider.overrideWith(
                (ref) async => const [shellyProfile, dimMode, bfWebhook]),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('en'),
            // devicePrefix dolu → doğrudan cihaz detayı (kart seviyesi atlanır)
            home: SkapiTemplateLibraryScreen(
              libraryContext: TemplateLibraryContext(
                deviceId: 'SD-TEST01',
                devicePrefix: 'SD',
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      // Browse: Dimmer başlığı + üretici kutucukları (Shelly + Generic).
      // Kartlar/tür etiketleri bu seviyede GÖRÜNMEZ (kutucuk arkasında).
      expect(find.text('Dimmer'), findsOneWidget);
      expect(find.text('Shelly'), findsOneWidget); // üretici kutucuğu
      expect(find.text('Generic'), findsOneWidget); // üretici-bağımsız kova
      expect(find.text('DRIVERS'), findsNothing);
      expect(find.text('MODES'), findsNothing);
      expect(find.text('Test Dimmer Profili'), findsNothing);
      // BF şablonu SD detayına düşmez (önek filtresi).
      expect(find.text('BF Test Webhook'), findsNothing);

      // Shelly kutucuğuna dokun → alt-sayfa açılır (geri ok + üretici başlığı).
      await tester.tap(find.text('Shelly'));
      await tester.pumpAndSettle();

      expect(find.byType(BackButton), findsOneWidget); // geri ok
      expect(find.text('DRIVERS'), findsOneWidget); // Sürücüler (en)
      expect(find.text('Test Dimmer Profili'), findsOneWidget);
      // Mod (Genel kovada) Shelly alt-sayfasında görünmez.
      expect(find.text('Test Dimmer Modu'), findsNothing);
    });
  });

  group('Şablon detayı · hermetik', () {
    testWidgets('form sekmesi param alanı + önizleme + CTA\'lar render olur',
        (tester) async {
      await _mountWithPrefs(
        tester,
        const SkapiTemplateDetailScreen(template: _modeTemplate),
      );
      await tester.pump();

      expect(find.text('TEST_MODE_TITLE'), findsWidgets);
      expect(find.text('TEST_MODE_SUMMARY'), findsOneWidget);
      // Param formu.
      expect(find.text('Hedef IP'), findsOneWidget);
      // Önizleme gövdesi firmware tokenlarını değil bizim yer tutucuyu
      // gösterir (host boş → literal {{host}} korunur).
      expect(find.textContaining('{{host}}'), findsWidgets);
      // Aksiyonlar.
      expect(find.text('Copy to my templates'), findsOneWidget);
      expect(find.text('Upload to device'), findsOneWidget);
    });

    testWidgets('doldurulmamış zorunlu paramla yükleme JSON sekmesine düşer '
        've hata gösterir', (tester) async {
      await _mountWithPrefs(
        tester,
        const SkapiTemplateDetailScreen(template: _modeTemplate),
      );
      await tester.pump();

      await tester.tap(find.text('Upload to device'));
      await tester.pumpAndSettle();

      // Çözülmemiş {{host}} kayıttan önce yakalanır; dağıtım başlamaz.
      expect(find.textContaining('host'), findsWidgets);
      expect(find.text('Pair a device first'), findsNothing);
    });
  });

  // ApiTemplateManifest sözleşmesi Faz B'de DeviceTemplate'e gömüldü ama
  // OnDeviceApiEditorScreen prefill yüzeyi aynı kaldı — parse testleri
  // sözleşmeyi kilitlemeye devam eder.
  group('ApiTemplateManifest parsing', () {
    test('round-trips defaults from JSON', () {
      final json = {
        'id': 'lights-on',
        'platform': 'templates',
        'targetDeviceType': 'any',
        'i18n': {
          'title': 'skapiSynDimmLightsOnTitle',
          'summary': 'skapiSynDimmLightsOnSummary',
        },
        'defaults': {
          'name': 'lights-on',
          'type': 'webhook_post',
          'url': 'https://example.com/lights',
          'method': 'POST',
          'auth': 'bearer',
          'contentType': 'application/json',
          'payload': '{"state":"on"}',
          'delayAfterSec': 7,
        },
        'params': [
          {
            'name': 'ifttt-key',
            'placeholder': '{{ifttt-key}}',
            'i18nLabel': 'paramIftttKey',
            'secret': true,
          },
        ],
      };
      final m = ApiTemplateManifest.fromJson(json);
      expect(m.id, 'lights-on');
      expect(m.defaultName, 'lights-on');
      expect(m.type, 'webhook_post');
      expect(m.urlTemplate, 'https://example.com/lights');
      expect(m.method, 'POST');
      expect(m.auth, 'bearer');
      expect(m.contentType, 'application/json');
      expect(m.payloadTemplate, '{"state":"on"}');
      expect(m.delayAfterSec, 7);
      expect(m.params, hasLength(1));
      expect(m.params.first.secret, isTrue);
    });

    test('falls back to safe defaults when optional fields missing', () {
      final json = {
        'id': 'minimal',
        'platform': 'templates',
        'targetDeviceType': 'any',
        'i18n': {'title': 'minimalTitle', 'summary': 'minimalSummary'},
        'defaults': {'url': 'https://example.com'},
      };
      final m = ApiTemplateManifest.fromJson(json);
      expect(m.defaultName, 'minimal');
      expect(m.type, 'generic');
      expect(m.method, 'POST');
      expect(m.auth, 'none');
      expect(m.delayAfterSec, 0);
      expect(m.params, isEmpty);
    });
  });

  group('DeviceTemplate parsing', () {
    test('bf.endpoint asset şeması gömülü manifest + rozetlerle çözülür', () {
      final tpl = DeviceTemplate.fromJson({
        'schemaVersion': 1,
        'id': 'bf-webhook-x',
        'category': 'webhook',
        'targetKind': 'bf.endpoint',
        'compatiblePrefixes': ['BF', 'LS', 'SD'],
        'i18n': {'title': 'X', 'summary': 'Y'},
        'platform': 'templates',
        'targetDeviceType': 'any',
        'defaults': {'url': 'https://x', 'type': 'webhook_post'},
      });
      expect(tpl.targetKind, TemplateTargetKind.bfEndpoint);
      expect(tpl.endpoint, isNotNull);
      expect(tpl.endpoint!.urlTemplate, 'https://x');
      expect(tpl.compatiblePrefixes, ['BF', 'LS', 'SD']);
      expect(tpl.jsonBody, isNull);
    });

    test('sd.profile: gömülü jsonBody objesi string\'e serileşir', () {
      final tpl = DeviceTemplate.fromJson({
        'id': 'sd-profile-x',
        'category': 'dimmer',
        'targetKind': 'sd.profile',
        'compatiblePrefixes': ['SD'],
        'i18n': {'title': 'X', 'summary': 'Y'},
        'jsonBody': {'v': 2, 'id': 'x', 'protocol': 'http'},
      });
      expect(tpl.jsonBody, contains('"protocol":"http"'));
      expect(tpl.endpoint, isNull);
    });

    test('bilinmeyen targetKind FormatException fırlatır (sessiz atlama '
        'repository katmanında)', () {
      expect(
        () => DeviceTemplate.fromJson({
          'id': 'x',
          'targetKind': 'sd.timeline',
          'i18n': {'title': 'X', 'summary': 'Y'},
        }),
        throwsFormatException,
      );
    });
  });

  group('paired devices integration smoke', () {
    testWidgets('paired devices store loads cleanly from empty prefs',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      late List<PairedDevice> paired;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: Consumer(
            builder: (ctx, ref, _) {
              paired = ref.watch(pairedDevicesProvider);
              return const MaterialApp(home: Scaffold(body: SizedBox()));
            },
          ),
        ),
      );
      await tester.pump();
      expect(paired, isEmpty);
    });
  });
}
