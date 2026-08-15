// Cihazlar sekmesi görünüm seçimi · takımyıldız ↔ kart.
//
// Seçim SharedPreferences'ta kalıcı: kullanıcı kart görünümünü seçtiyse
// uygulamayı kapatıp açtığında orada kalmalı.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/preferences_provider.dart';

enum DevicesViewMode { constellation, cards }

class DevicesViewModeNotifier extends Notifier<DevicesViewMode> {
  static const _prefsKey = 'devices_view_mode';

  @override
  DevicesViewMode build() {
    final raw = ref.read(sharedPreferencesProvider).getString(_prefsKey);
    return raw == 'cards'
        ? DevicesViewMode.cards
        : DevicesViewMode.constellation;
  }

  Future<void> set(DevicesViewMode mode) async {
    if (state == mode) return;
    state = mode;
    await ref
        .read(sharedPreferencesProvider)
        .setString(_prefsKey, mode == DevicesViewMode.cards ? 'cards' : 'constellation');
  }

  Future<void> toggle() => set(state == DevicesViewMode.cards
      ? DevicesViewMode.constellation
      : DevicesViewMode.cards);
}

final devicesViewModeProvider =
    NotifierProvider<DevicesViewModeNotifier, DevicesViewMode>(
        DevicesViewModeNotifier.new);
