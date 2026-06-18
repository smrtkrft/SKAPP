import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/preferences_provider.dart';

const _keyThemeMode = 'theme_mode';
const _keyLocale = 'locale';
const _keyUpdateChannel = 'update_channel';
const _keyAutoCheckUpdates = 'auto_check_updates';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return switch (prefs.getString(_keyThemeMode)) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark,
    };
  }

  Future<void> set(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_keyThemeMode, mode.name);
    state = mode;
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final code = prefs.getString(_keyLocale);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  Future<void> set(Locale? locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (locale == null) {
      await prefs.remove(_keyLocale);
    } else {
      await prefs.setString(_keyLocale, locale.languageCode);
    }
    state = locale;
  }
}

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);

const supportedLocales = [Locale('en'), Locale('tr')];

/// App update channel. The manifest server (future) will serve different
/// latest-version info per channel, so the choice propagates to whatever
/// updater we wire in during Phase 3.
enum UpdateChannel { stable, beta }

class UpdateChannelNotifier extends Notifier<UpdateChannel> {
  @override
  UpdateChannel build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return switch (prefs.getString(_keyUpdateChannel)) {
      'beta' => UpdateChannel.beta,
      _ => UpdateChannel.stable,
    };
  }

  Future<void> set(UpdateChannel channel) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_keyUpdateChannel, channel.name);
    state = channel;
  }
}

final updateChannelProvider =
    NotifierProvider<UpdateChannelNotifier, UpdateChannel>(
  UpdateChannelNotifier.new,
);

class AutoCheckUpdatesNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    // Default ON, users generally want to know updates exist; they can
    // still turn it off if they prefer manual control.
    return prefs.getBool(_keyAutoCheckUpdates) ?? true;
  }

  Future<void> set(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyAutoCheckUpdates, value);
    state = value;
  }
}

final autoCheckUpdatesProvider =
    NotifierProvider<AutoCheckUpdatesNotifier, bool>(
  AutoCheckUpdatesNotifier.new,
);

const _keyDeveloperMode = 'developer_mode';

/// Persistent toggle for the "Developer mode" / "Geliştirici modu" UI
/// affordances. SharedPreferences key (`developer_mode`) already matches
/// the name; user-facing label was renamed from the earlier
/// "Professional mode" wording on 2026-05-14 because users were reading
/// it as a paid tier.
///
/// **Bu bayrak satın alma / lisans / ücretli sürüm ile ilişkili
/// DEĞİLDİR.** SKAPP tek versiyon, tamamı ücretsiz. Bu toggle yalnızca
/// gelişmiş debug yüzeylerini kullanıcının açık kararıyla görünür
/// kılmak için var.
///
/// What flips on when this is true:
///   - Settings: USB CLI Console card (raw BLE/CLI debug).
///   - Settings: Network identity + SKAPP HTTP Listener + SKAPP Peers
///     cards become visible. The listener itself keeps running in the
///     background (BF webhooks need it), but bearer-protected routes
///     return 403 from `SkappHttpServer._authMiddleware` until this flag
///     is on. The mDNS announcer is also gated here.
///   - SKAPI: code panel + editor in script detail (basic users see the
///     simplified form; advanced users opt into the script source).
///   - SKAPI: remote-trigger from paired mobile SKAPP peers (Mobile peer
///     remote-trigger gate). BF device triggers are independent.
class DeveloperModeNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(_keyDeveloperMode) ?? false;
  }

  Future<void> set(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyDeveloperMode, value);
    state = value;
  }
}

final developerModeProvider =
    NotifierProvider<DeveloperModeNotifier, bool>(DeveloperModeNotifier.new);
