// Build-safe widget tests for Madde 24 (SKAPI on-device API triggers).
//
// These are render-only smoke tests: each new screen is mounted inside a
// minimal ProviderScope + MaterialApp shell, and the test asserts that
// the widget tree builds without exceptions and surfaces its expected
// labels. No interactive flows are exercised here — those need a real
// device session (BLE/USB CLI) and are deferred to the manual test
// pass in `yapilacaklar.md` Madde 24 S2.8.
//
// What these tests catch that `flutter analyze` cannot:
//   * RenderFlex overflow when localized strings get long
//   * MissingPluralLocalization at runtime
//   * Missing required InheritedWidget in the widget tree
//   * Provider initialisation errors (mis-keyed family parameters)
//   * Wrong asset path during `_platform.json` lookup

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skapp/core/storage/paired_devices_store.dart';
import 'package:skapp/core/storage/preferences_provider.dart';
import 'package:skapp/features/skapi/data/script_manifest.dart';
import 'package:skapp/features/skapi/data/skapi_catalog.dart';
import 'package:skapp/features/skapi/skapi_api_template_detail_screen.dart';
import 'package:skapp/features/skapi/skapi_other_category_screen.dart';
import 'package:skapp/features/skapi/skapi_platform_screen.dart';
import 'package:skapp/l10n/app_localizations.dart';

Future<void> _mountWithPrefs(
  WidgetTester tester,
  Widget child,
) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
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

void main() {
  group('Madde 24 · catalog', () {
    test('kSkapiOtherCategories exposes the five SmartKraft + IoT + Server '
        'categories in expected order', () {
      expect(
        kSkapiOtherCategories.map((p) => p.id).toList(),
        const [
          'other-syndimm',
          'other-lebensspur',
          'other-blockingfocus',
          'other-iot',
          'other-server',
        ],
      );
    });

    test('every other-* category id has a matching label string', () {
      for (final c in kSkapiOtherCategories) {
        expect(c.label, isNotEmpty,
            reason: 'category ${c.id} missing fallback label');
      }
    });
  });

  group('Madde 24 · SkapiOtherCategoryScreen', () {
    testWidgets('builds and shows the heading + all five category cards',
        (tester) async {
      await _mountWithPrefs(tester, const SkapiOtherCategoryScreen());

      // Heading text from ARB resolves.
      expect(find.text('Pick a device category'), findsOneWidget);

      // All five SmartKraft / generic categories render their label.
      for (final c in kSkapiOtherCategories) {
        expect(find.text(c.label), findsOneWidget,
            reason: 'missing ${c.id} card');
      }
    });

    testWidgets('every category card carries a "coming soon" badge', (tester) async {
      await _mountWithPrefs(tester, const SkapiOtherCategoryScreen());

      // SkYakindaBadge renders its label via .toUpperCase(); five
      // categories = five badges.
      expect(find.text('TEMPLATES COMING SOON'),
          findsNWidgets(kSkapiOtherCategories.length));
    });
  });

  group('Madde 24 · SkapiPlatformScreen dispatch', () {
    testWidgets('other-* platform routes through _ApiTemplateBody and shows '
        'the empty placeholder when the asset has no apiTemplates',
        (tester) async {
      const otherSyndimm = SkapiPlatformSpec(
        id: 'other-syndimm',
        label: 'SynDimm',
        icon: Icons.lightbulb,
      );
      await _mountWithPrefs(
        tester,
        const SkapiPlatformScreen(platform: otherSyndimm),
      );
      // Let the asset bundle load + FutureProvider resolve.
      await tester.pump(const Duration(milliseconds: 200));

      // Empty placeholder under apiTemplate body shows the
      // "templates coming soon" hint (reused string from category cards).
      expect(find.text('Templates coming soon'), findsOneWidget);
    });
  });

  group('Madde 24 · SkapiApiTemplateDetailScreen', () {
    testWidgets('renders title + summary + endpoint preview + upload CTA',
        (tester) async {
      // Hand-crafted manifest, no asset dependency — keeps the test
      // hermetic and decoupled from where templates eventually land.
      const manifest = ApiTemplateManifest(
        id: 'lights-on',
        platform: 'other-syndimm',
        targetDeviceType: 'bf',
        i18nTitle: 'TEST_TITLE',
        i18nSummary: 'TEST_SUMMARY',
        defaultName: 'lights-on',
        type: 'webhook_post',
        urlTemplate: 'https://example.com/lights',
        method: 'POST',
        auth: 'bearer',
        delayAfterSec: 5,
        payloadTemplate: '{"state":"on"}',
      );

      await _mountWithPrefs(
        tester,
        const SkapiApiTemplateDetailScreen(manifest: manifest),
      );
      await tester.pump();

      // i18n keys that don't resolve fall back to the raw key — that's
      // fine for this hermetic test, we're checking *the field renders*.
      expect(find.text('TEST_TITLE'), findsWidgets);
      expect(find.text('TEST_SUMMARY'), findsOneWidget);

      // Endpoint preview rows.
      expect(find.text('webhook_post'), findsOneWidget);
      expect(find.text('POST'), findsOneWidget);
      expect(find.text('https://example.com/lights'), findsOneWidget);
      expect(find.text('bearer'), findsOneWidget);
      expect(find.text('{"state":"on"}'), findsOneWidget);

      // Upload CTA visible.
      expect(find.text('Upload to device'), findsOneWidget);
    });

    testWidgets('tapping Upload with zero paired devices opens the '
        '"pair a device first" dialog', (tester) async {
      const manifest = ApiTemplateManifest(
        id: 'lights-on',
        platform: 'other-syndimm',
        targetDeviceType: 'bf',
        i18nTitle: 'T',
        i18nSummary: 'S',
        defaultName: 'lights-on',
        type: 'generic',
        urlTemplate: 'https://example.com',
        method: 'POST',
        auth: 'none',
        delayAfterSec: 0,
      );

      await _mountWithPrefs(
        tester,
        const SkapiApiTemplateDetailScreen(manifest: manifest),
        // pairedDevicesProvider boots from SharedPreferences; empty prefs
        // = empty list, no override needed.
      );
      await tester.pump();

      await tester.tap(find.text('Upload to device'));
      await tester.pumpAndSettle();

      expect(find.text('Pair a device first'), findsOneWidget);
      expect(find.text('Open Devices'), findsOneWidget);
    });
  });

  group('Madde 24 · ApiTemplateManifest parsing', () {
    test('round-trips defaults from JSON', () {
      final json = {
        'id': 'lights-on',
        'platform': 'other-syndimm',
        'targetDeviceType': 'bf',
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
      expect(m.platform, 'other-syndimm');
      expect(m.targetDeviceType, 'bf');
      expect(m.defaultName, 'lights-on');
      expect(m.type, 'webhook_post');
      expect(m.urlTemplate, 'https://example.com/lights');
      expect(m.method, 'POST');
      expect(m.auth, 'bearer');
      expect(m.contentType, 'application/json');
      expect(m.payloadTemplate, '{"state":"on"}');
      expect(m.delayAfterSec, 7);
      expect(m.params, hasLength(1));
      expect(m.params.first.name, 'ifttt-key');
      expect(m.params.first.secret, isTrue);
    });

    test('falls back to safe defaults when optional fields missing', () {
      final json = {
        'id': 'minimal',
        'platform': 'other-iot',
        'targetDeviceType': 'bf',
        'i18n': {
          'title': 'minimalTitle',
          'summary': 'minimalSummary',
        },
        'defaults': {
          'url': 'https://example.com',
        },
      };
      final m = ApiTemplateManifest.fromJson(json);
      expect(m.defaultName, 'minimal'); // falls back to id
      expect(m.type, 'generic');         // default
      expect(m.method, 'POST');          // default
      expect(m.auth, 'none');            // default
      expect(m.delayAfterSec, 0);
      expect(m.params, isEmpty);
    });

    test('PlatformManifest reads both groups and apiTemplates lists', () {
      final json = {
        'platform': 'other-syndimm',
        'runtime': 'iot-api',
        'apiTemplates': ['lights-on', 'lights-off'],
      };
      final m = PlatformManifest.fromJson(json);
      expect(m.groupIds, isEmpty);
      expect(m.apiTemplateIds, equals(['lights-on', 'lights-off']));
    });
  });

  group('Madde 24 · paired devices integration smoke', () {
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
