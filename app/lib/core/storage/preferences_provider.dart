import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds a single SharedPreferences instance. Overridden in main() after
/// SharedPreferences.getInstance() resolves, so accessors can stay synchronous.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider was read before being overridden. '
    'Ensure ProviderScope overrides it at app startup.',
  );
});
