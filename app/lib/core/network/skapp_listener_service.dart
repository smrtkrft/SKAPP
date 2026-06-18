import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings_providers.dart';
import '../system/network_identity_provider.dart';
import 'skapp_http_server.dart';
import 'skapp_mdns_announcer.dart';

/// Coordinates the lifecycle of the Desktop HTTP listener with the
/// reactive `skappHttpServerRunningProvider` flag.
///
/// Why a separate wrapper:
///   - `SkappHttpServer.start/stop` are imperative and raise OS-level
///     errors (port in use, no permission). Tying them straight to a
///     Notifier would mix Riverpod state with raw Future control flow.
///   - The Settings card needs an awaitable `setEnabled(bool)` to drive
///     a switch widget; this class wraps the imperative API into one.
///   - Identity changes (port edit, token rotate) must restart the
///     listener; the wrapper listens to `networkIdentityProvider` and
///     re-bounces start/stop with debounce protection.
class SkappListenerService {
  SkappListenerService(this._ref);

  final Ref _ref;
  bool _starting = false;
  Timer? _restartDebounce;

  Future<bool> start() async {
    if (_starting) return _ref.read(skappHttpServerRunningProvider);
    _starting = true;
    try {
      final server = _ref.read(skappHttpServerProvider);
      if (!server.supported) {
        _ref.read(skappHttpServerRunningProvider.notifier).set(false);
        return false;
      }
      try {
        await server.start();
      } catch (e) {
        // Surface the bind failure so the Settings card can render the
        // actual cause (port busy, permission denied) on first paint
        // instead of staying silently OFF. The auto-start path in
        // MainShell uses fire-and-forget; without this notifier the user
        // would never see the error unless they manually toggled.
        _ref.read(skappHttpServerRunningProvider.notifier).set(false);
        _ref
            .read(skappListenerLastErrorProvider.notifier)
            .set(e.toString());
        rethrow;
      }
      // HTTP listener is up; advertise it on the LAN so paired SKAPP
      // peers can resolve us by user-given name. Announcer is best-effort:
      // a failure is captured in `lastError`, the listener stays running.
      //
      // Developer mode gate: mDNS advertisement only fires when Developer mode is on.
      // Outside Developer mode the listener still serves BF webhooks (which find
      // us via `systemEndpointSyncService` URL push, not mDNS), but we
      // don't advertise to the LAN at large. `watchProMode` keeps this in
      // sync when the user toggles the flag at runtime.
      if (_ref.read(developerModeProvider)) {
        await _ref.read(skappMdnsAnnouncerProvider).start();
      }
      _ref.read(skappHttpServerRunningProvider.notifier).set(true);
      _ref.read(skappListenerLastErrorProvider.notifier).set(null);
      return true;
    } finally {
      _starting = false;
    }
  }

  Future<void> stop() async {
    // Take down the announcement first so peers don't keep resolving a
    // dead host between unregister and the actual listener stop.
    await _ref.read(skappMdnsAnnouncerProvider).stop();
    final server = _ref.read(skappHttpServerProvider);
    await server.stop();
    _ref.read(skappHttpServerRunningProvider.notifier).set(false);
    _ref.read(skappListenerLastErrorProvider.notifier).set(null);
  }

  Future<bool> setEnabled(bool enabled) {
    return enabled ? start() : stop().then((_) => false);
  }

  /// Subscribes to identity changes and restarts the server when port,
  /// token, or LAN visibility has changed; also restarts ONLY the mDNS
  /// announcer when just the instance name changes (no need to bounce the
  /// HTTP server for a label-only edit). Debounced so a user dragging a
  /// number field doesn't bounce the listener on every keystroke.
  void watchIdentity() {
    _ref.listen<NetworkIdentity>(
      networkIdentityProvider,
      (previous, next) {
        if (previous == null) return;
        final portOrTokenChanged = previous.port != next.port ||
            previous.bearerToken != next.bearerToken;
        final lanVisibleChanged = previous.lanVisible != next.lanVisible;
        final nameChanged = previous.name != next.name;
        if (!portOrTokenChanged && !lanVisibleChanged && !nameChanged) return;

        _restartDebounce?.cancel();
        _restartDebounce = Timer(const Duration(milliseconds: 600), () async {
          if (!_ref.read(skappHttpServerRunningProvider)) return;
          if (portOrTokenChanged || lanVisibleChanged) {
            // Full restart: server bind port, auth token, or bind address
            // changed; existing connections must be torn down.
            await stop();
            await start();
          } else {
            // Name-only change: keep the HTTP server alive, just
            // re-publish with the new instance name.
            await _ref.read(skappMdnsAnnouncerProvider).restart();
          }
        });
      },
    );
  }

  /// Subscribes to Developer mode (`developerModeProvider`) and reacts:
  ///
  /// - **Developer mode true → false** (turning off):
  ///   - Stop the mDNS announcer so the host is no longer advertised on
  ///     the LAN (defense-in-depth; bearer routes are already returning
  ///     403 from the auth middleware).
  ///   - Auto-restore `lanVisible = true` if it was switched off. The
  ///     toggle lives inside the Developer mode UI section; once Developer mode is
  ///     off, the user can no longer flip it back manually, so leaving it
  ///     `false` would silently kill BF webhooks. Fires a one-shot pulse
  ///     on `lanVisibleAutoReopenedProvider` so the UI can surface a
  ///     snackbar explaining the auto-revert.
  /// - **Developer mode false → true** (turning on):
  ///   - Start the mDNS announcer (HTTP listener is already up; it stays
  ///     running across Developer mode toggles for the BF webhook chain).
  void watchProMode() {
    _ref.listen<bool>(
      developerModeProvider,
      (previous, next) {
        if (previous == null || previous == next) return;
        if (!_ref.read(skappHttpServerRunningProvider)) return;
        if (next) {
          unawaited(_ref.read(skappMdnsAnnouncerProvider).start());
        } else {
          unawaited(_ref.read(skappMdnsAnnouncerProvider).stop());
          final identity = _ref.read(networkIdentityProvider);
          if (!identity.lanVisible) {
            unawaited(
              _ref
                  .read(networkIdentityProvider.notifier)
                  .setLanVisible(true)
                  .then((_) {
                _ref
                    .read(lanVisibleAutoReopenedProvider.notifier)
                    .pulse();
              }),
            );
          }
        }
      },
    );
  }

  void dispose() {
    _restartDebounce?.cancel();
  }
}

final skappListenerServiceProvider = Provider<SkappListenerService>((ref) {
  final svc = SkappListenerService(ref);
  ref.onDispose(svc.dispose);
  return svc;
});

/// Last bind / startup error from [SkappListenerService.start]. Null while
/// the listener is healthy or has never been started. The Settings card
/// reads this on first paint so an auto-start failure (port busy, missing
/// permission) is visible without forcing the user to toggle the switch.
class SkappListenerLastErrorNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? value) => state = value;
}

final skappListenerLastErrorProvider =
    NotifierProvider<SkappListenerLastErrorNotifier, String?>(
        SkappListenerLastErrorNotifier.new);

/// One-shot pulse counter for the "LAN visibility auto-restored on Pro
/// mode turn-off" event. `SkappListenerService.watchProMode` increments
/// this whenever it flips `lanVisible` back to `true` so the user can be
/// told why their toggle moved without explicit input. A widget elsewhere
/// (typically `MainShell`) uses `ref.listen<int>` to surface a snackbar
/// using the localized `settingsLanVisibleAutoReopenedSnack` key.
///
/// Using an int (monotonic counter) instead of a stream / event class
/// keeps the wiring synchronous and trivially compatible with
/// `ref.listen`, which fires once per value change.
class LanVisibleAutoReopenedNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void pulse() => state = state + 1;
}

final lanVisibleAutoReopenedProvider =
    NotifierProvider<LanVisibleAutoReopenedNotifier, int>(
        LanVisibleAutoReopenedNotifier.new);
