// SKAPI sekmesi — tek sayfalık düzen (mockup: SKAPP/1.html) için render +
// etkileşim smoke testi. Statik ürün kartları (SynDimm/LebensSpur/Blocking
// Focus/Masaüstü) anında çizilir; Masaüstü detayı gerçek asset'lerden platform
// script sayılarını yükler, o yüzden bozuk pubspec/asset girdisi de yakalanır.
//
// Doğruladıkları:
//   * Bölüm başlıkları (SkapiLibHeading, uppercase): SKAPI / QUICK ACCESS /
//     MY ACTIONS.
//   * 2×2 ürün kartları + durum rozetleri (LIVE / CONCEPT).
//   * Hızlı Erişim boş durumu (favori yokken) yüzeye çıkar.
//   * Aksiyonlar açıklaması + "Add action" satırı (binding yokken).
//   * Topluluğa gönder CTA'sı render olur.
//   * Masaüstü kartı → detay → üç platform çipi.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skapp/core/storage/preferences_provider.dart';
import 'package:skapp/features/skapi/skapi_screen.dart';
import 'package:skapp/l10n/app_localizations.dart';

void main() {
  testWidgets('tek sayfa düzeni: ürün kartları, hızlı erişim, aksiyonlar, topluluk',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        // Riverpod 3 varsayılan retry, asset yüklerken anlık hata alan
        // FutureProvider'ı sessizce yeniden dener → data↔loading arasında
        // zıplar. Retry kapalı → tek yönlü resolve.
        retry: (_, _) => null,
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const SkapiScreen(),
        ),
      ),
    );

    // Gerçek asset yüklemesi değişken sürer; hedef görünene kadar sınırlı
    // pump — spinner animasyonuna takılan pumpAndSettle yerine.
    Future<void> pumpUntil(Finder finder, {int tries = 40}) async {
      for (var i = 0; i < tries; i++) {
        if (finder.evaluate().isNotEmpty) return;
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    await pumpUntil(find.text('SynDimm'));

    // --- Bölüm başlıkları (SkapiLibHeading uppercase) ---
    expect(find.text('SKAPI'), findsOneWidget);
    expect(find.text('QUICK ACCESS'), findsOneWidget);
    expect(find.text('MY ACTIONS'), findsOneWidget);

    // --- 2×2 ürün kartları ---
    expect(find.text('SynDimm'), findsOneWidget);
    expect(find.text('LebensSpur'), findsOneWidget);
    expect(find.text('Blocking Focus'), findsOneWidget);
    expect(find.text('Desktop'), findsOneWidget);

    // --- Durum rozetleri ---
    expect(find.text('LIVE'), findsOneWidget);
    expect(find.text('CONCEPT'), findsOneWidget);

    // --- Hızlı Erişim: favori yok → boş durum ---
    expect(find.textContaining('Star library entries'), findsOneWidget);

    // --- Aksiyonlar: açıklama + "Add action" satırı (binding yok) ---
    expect(find.textContaining('An action is what happens'), findsOneWidget);
    expect(find.text('Add action'), findsOneWidget);

    // --- Topluluğa gönder CTA ---
    expect(
      find.textContaining('Send your library to the SmartKraft community'),
      findsOneWidget,
    );

    // --- Masaüstü kartı → detay → platform çipleri ---
    await tester.tap(find.text('Desktop'));
    await pumpUntil(find.text('Windows'));
    // Üç masaüstü platform çipi (host = macOS test VM'inde işaretli).
    expect(find.text('macOS'), findsOneWidget);
    expect(find.text('Windows'), findsOneWidget);
    expect(find.text('Linux'), findsOneWidget);
  });
}
