// Reusable test harness helpers (Faz 0 test altyapısı).
//
// Extracted from the inline `_mountWithPrefs` in skapi_madde_24_test.dart so
// every widget/provider test boots the same minimal ProviderScope +
// MaterialApp shell with mocked SharedPreferences and the app's l10n
// delegates wired up.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Riverpod 3 exports the `Override` type from misc.dart, not the main entry.
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skapp/core/storage/preferences_provider.dart';
import 'package:skapp/l10n/app_localizations.dart';

/// Returns a fresh [SharedPreferences] backed by mock in-memory storage,
/// seeded with [initial]. Use for pure provider/store unit tests that need
/// a real prefs instance without a widget tree.
Future<SharedPreferences> mockPrefs([
  Map<String, Object> initial = const {},
]) async {
  SharedPreferences.setMockInitialValues(initial);
  return SharedPreferences.getInstance();
}

/// Builds a [ProviderContainer] with [sharedPreferencesProvider] overridden
/// to a mock-backed instance. Caller is responsible for `container.dispose()`.
/// Extra [overrides] are appended after the prefs override.
Future<ProviderContainer> mockContainer({
  Map<String, Object> initialPrefs = const {},
  List<Override> overrides = const [],
}) async {
  final prefs = await mockPrefs(initialPrefs);
  return ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      ...overrides,
    ],
  );
}

/// Pumps [child] inside the standard ProviderScope + MaterialApp shell used
/// across the suite. Locale defaults to English so ARB lookups resolve to
/// the source strings the assertions match against.
Future<void> mountWithPrefs(
  WidgetTester tester,
  Widget child, {
  Map<String, Object> initialPrefs = const {},
  List<Override> overrides = const [],
  Locale locale = const Locale('en'),
}) async {
  final prefs = await mockPrefs(initialPrefs);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        ...overrides,
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: child,
      ),
    ),
  );
  // Let async providers fire one frame.
  await tester.pump();
}
