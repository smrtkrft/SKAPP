import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Currently selected tab index in [MainShell]. Surfaced as a provider
/// so off-MainShell widgets (future deep-link handlers, notification
/// taps) can switch tabs without threading a callback through the
/// widget tree.
///
/// Index map (must match `_tabs` order in `main_shell.dart`):
///   0 = SmartKraft (home — V5 ticket tasarımı)
///   1 = Devices / Cihazlarım
///   2 = SKAPI
///   3 = Settings / Ayarlar
///
/// Provider transient (build() -> 0) — persisted seçim yok.
class SelectedTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  /// Switches to the tab at [index]. Caller is responsible for guarding
  /// against disabled-tab indexes (MainShell does this via `_onSelect`).
  void set(int index) => state = index;
}

final selectedTabProvider =
    NotifierProvider<SelectedTabNotifier, int>(SelectedTabNotifier.new);
