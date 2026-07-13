// Üretici kutucuğu işaret soketi üç yollu: resmi monokrom logo (Shelly/
// Tasmota/Philips-Hue) → SVG; wordmark marka (WiZ/WLED) → tam ad Text;
// gerisi (Genel/bilinmeyen) → nötr 2-harf monogram. mfrLogoAsset/mfrWordmark
// eşlemelerini ve _ManufacturerMark render dallanmasını kilitler (0.4.12).
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/features/skapi/skapi_template_library_screen.dart';
import 'package:skapp/l10n/app_localizations.dart';

Future<void> _pumpTile(WidgetTester tester, String manufacturerKey) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: Center(
          child: SkapiManufacturerTile(
            manufacturerKey: manufacturerKey,
            count: 3,
            onTap: () {},
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('mfrLogoAsset', () {
    test('resmi logolu üreticiler eşlenir (büyük/küçük harf duyarsız)', () {
      expect(mfrLogoAsset('Shelly'), 'assets/skapi/logos/shelly.svg');
      expect(mfrLogoAsset('tasmota'), 'assets/skapi/logos/tasmota.svg');
      expect(mfrLogoAsset('Philips'), 'assets/skapi/logos/philips.svg');
    });

    test('wordmark markalar logo değil wordmark eşler', () {
      expect(mfrLogoAsset('WiZ'), isNull);
      expect(mfrLogoAsset('WLED'), isNull);
      expect(mfrWordmark('WiZ'), 'WiZ');
      expect(mfrWordmark('wled'), 'WLED');
    });

    test('Genel + bilinmeyen üretici: logo ve wordmark yok (→ monogram)', () {
      expect(mfrLogoAsset(kGenericManufacturerKey), isNull);
      expect(mfrWordmark(kGenericManufacturerKey), isNull);
      expect(mfrLogoAsset('Acme'), isNull);
      expect(mfrWordmark('Acme'), isNull);
    });
  });

  group('SkapiManufacturerTile işaret soketi', () {
    testWidgets('Shelly → SVG logo render eder, monogram metni değil',
        (tester) async {
      await _pumpTile(tester, 'Shelly');
      expect(find.byType(SvgPicture), findsOneWidget);
      // Marka adı etiketi hâlâ görünür ama slot metin monogramı taşımaz.
      expect(find.text('Shelly'), findsOneWidget);
      expect(find.text('SH'), findsNothing);
    });

    testWidgets('Philips → resmi Hue SVG işareti render eder', (tester) async {
      await _pumpTile(tester, 'Philips');
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('WiZ → SVG yok, wordmark (tam ad) slot içinde render eder',
        (tester) async {
      await _pumpTile(tester, 'WiZ');
      expect(find.byType(SvgPicture), findsNothing);
      // Wordmark slot + sağdaki ad etiketi = iki "WiZ".
      expect(find.text('WiZ'), findsNWidgets(2));
      expect(find.text('WI'), findsNothing);
    });

    testWidgets('Genel → SVG/wordmark yok, nötr 2-harf monogram (GE)',
        (tester) async {
      await _pumpTile(tester, kGenericManufacturerKey);
      expect(find.byType(SvgPicture), findsNothing);
      expect(find.text('GE'), findsOneWidget);
    });
  });
}
