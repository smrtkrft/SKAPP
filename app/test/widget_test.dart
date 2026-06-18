import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skapp/app.dart';
import 'package:skapp/core/storage/preferences_provider.dart';
import 'package:skapp/core/system/network_identity_provider.dart';
import 'package:skapp/features/main_shell/main_shell.dart';

void main() {
  testWidgets('App boots and advances past splash into main shell',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          // Phase A migration: `main()` resolves this from secure storage
          // at app boot. Tests don't have a real secure-storage backend
          // so we hand the notifier a null token; it falls through to
          // generating a fresh one, same as a first-launch scenario.
          bearerTokenBootstrapProvider.overrideWithValue(null),
        ],
        child: const SkApp(),
      ),
    );

    // Let the splash timer fire (~2100ms navDelay) and navigation settle.
    // Splash drives an AnimationController for the unfold animation, so a
    // single `pumpAndSettle` would hang on that — pump explicit windows
    // instead. Bumping past 2.2s + a settle pump covers the
    // pushReplacement into MainShell.
    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pump(const Duration(milliseconds: 300));

    // The MaterialApp must still be mounted and we advanced past the splash
    // into the MainShell (which hosts the floating bottom nav pill).
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(MainShell), findsOneWidget);
  });
}
