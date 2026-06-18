import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cli/cli_client.dart';
import '../../../core/cli/cli_providers.dart';
import '../../../core/storage/paired_devices_store.dart';
import 'action_binding.dart';
import 'event_filter.dart';
import 'skapi_providers.dart';

/// Watches BLE event streams from every paired device and fires SKAPI
/// bindings whose `eventFilter` matches.
///
/// Faz I scope:
///   - Desktop: matched binding is executed via `ScriptRunner` and a
///     transient toast tells the user which script just ran. Output
///     does not surface here (the user can still open Run Now manually
///     to see live output). Faz K will route the run through the same
///     bottom sheet for consistency.
///   - Mobile: matched binding emits a `BindingTriggerNotice` over a
///     broadcast stream the host widget surfaces as a SnackBar. Faz K
///     replaces this with a Desktop-forward call.
///
/// Concurrency notes:
///   - Each paired device gets one `deviceEventsProvider.family` stream
///     subscription. When the paired list changes, dead subscriptions
///     are cancelled, new ones added.
///   - `Ref.listen` keeps the service tied to provider lifecycle, so a
///     `ref.invalidate(bindingsTriggerServiceProvider)` cleanly tears
///     down all subscriptions without leaking timers.
class BindingsTriggerService {
  BindingsTriggerService(this._ref);

  final Ref _ref;
  final Map<String, ProviderSubscription<AsyncValue<CliEvent>>>
      _deviceSubs = {};
  final StreamController<BindingTriggerNotice> _notices =
      StreamController.broadcast();

  /// One-time wiring. Call from a long-lived consumer (e.g. main shell
  /// initState via `ref.read`) so the service starts before any UI
  /// surface needs to display its notices.
  void start() {
    debugPrint('[BIND] trigger service start()');
    _ref.listen<List<PairedDevice>>(
      pairedDevicesProvider,
      (previous, next) => _syncSubscriptions(next),
      fireImmediately: true,
    );
  }

  Stream<BindingTriggerNotice> get notices => _notices.stream;

  void _syncSubscriptions(List<PairedDevice> devices) {
    debugPrint('[BIND] sync subs: ${devices.length} paired '
        '(${devices.map((d) => d.id).join(", ")})');
    final keep = devices.map((d) => d.id).toSet();
    final stale = _deviceSubs.keys.where((id) => !keep.contains(id)).toList();
    for (final id in stale) {
      debugPrint('[BIND] dropping stale sub: $id');
      _deviceSubs.remove(id)?.close();
    }
    for (final device in devices) {
      _deviceSubs.putIfAbsent(device.id, () {
        debugPrint('[BIND] subscribing to events for ${device.id}');
        return _ref.listen<AsyncValue<CliEvent>>(
          deviceEventsProvider(device.id),
          (previous, next) {
            next.when(
              data: (event) => _onEvent(device.id, event),
              loading: () => debugPrint(
                  '[BIND] ${device.id} session loading…'),
              error: (e, _) => debugPrint(
                  '[BIND] ${device.id} session error: $e'),
            );
          },
          fireImmediately: true,
        );
      });
    }
  }

  Future<void> _onEvent(String deviceId, CliEvent event) async {
    final eventName = (event['evt'] ?? event['event']) as String?;
    if (eventName == null || eventName.isEmpty) return;
    await _dispatch(deviceId, eventName, source: 'cli');
  }

  /// Public entry for webhook-driven dispatches (BF SYSTEM-kind webhook
  /// hits SkappHttpServer's `/api/events/incoming` route, the receiver
  /// verifies the bond signature, then calls this with the parsed event
  /// name + originating device id). Behaves identically to a CLI-driven
  /// event from the trigger service's POV — same bindings table, same
  /// run path on Desktop. Mobile keeps the toast-only behaviour because
  /// mobile can't host a listener anyway (so this branch is desktop-only
  /// in practice).
  /// Webhook entry point that returns a structured outcome so the HTTP
  /// route handler can surface "matched 0 bindings" / "script_error"
  /// in the activity log. Without this the post-accept silence (script
  /// just doesn't run) is invisible to the user.
  Future<DispatchSummary> dispatchWebhook(
    String deviceId,
    String eventName,
  ) async {
    return _dispatch(deviceId, eventName, source: 'webhook');
  }

  Future<DispatchSummary> _dispatch(
    String deviceId,
    String eventName, {
    required String source,
  }) async {
    final bindings = _ref.read(bindingsForDeviceProvider(deviceId));
    debugPrint('[BIND] event $deviceId/$eventName via $source '
        '(bindings for device: ${bindings.length}, isDesktop=$_isDesktop)');
    int matched = 0;
    final scriptResults = <ScriptDispatchResult>[];
    for (final binding in bindings) {
      final matches = EventFilter.match(binding.eventFilter, eventName);
      debugPrint('[BIND]   filter="${binding.eventFilter}" '
          'script=${binding.platform}/${binding.scriptId} '
          'enabled=${binding.enabled} → match=$matches');
      if (!matches) continue;
      matched++;
      _emit(binding, eventName);
      if (_isDesktop) {
        debugPrint('[BIND]   → running on desktop');
        // Await the run so the dispatch summary carries a real success
        // / failure verdict. Webhook caller is already fire-and-forget
        // wrapped (`unawaited`) at the HTTP route, so blocking here
        // doesn't stall the BF reply.
        final r = await _runOnDesktop(binding);
        scriptResults.add(r);
      } else {
        debugPrint('[BIND]   → mobile path: toast only (Faz B karar)');
        // Mobile dispatched-but-not-run still counts as matched.
        scriptResults.add(ScriptDispatchResult(
          scriptId: binding.scriptId,
          platform: binding.platform,
          success: true, // toast only, treated as "delivered"
        ));
      }
    }
    return DispatchSummary(
      matchedBindings: matched,
      scriptResults: List.unmodifiable(scriptResults),
    );
  }

  bool get _isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  Future<ScriptDispatchResult> _runOnDesktop(ActionBinding binding) async {
    try {
      final repo = _ref.read(scriptRepositoryProvider);
      final manifest =
          await repo.loadScript(binding.platform, binding.scriptId);
      debugPrint(
          '[BIND] manifest loaded: ${manifest.platform}/${manifest.id}');
      final runner = _ref.read(scriptRunnerProvider);
      final handle = await runner.run(
        manifest: manifest,
        paramOverrides: binding.paramOverrides,
        prerunDelaySeconds: binding.prerunDelaySeconds,
      );
      final result = await handle.result;
      debugPrint('[BIND] script done: exit=${result.exitCode} '
          'duration=${result.durationMs}ms');
      return ScriptDispatchResult(
        scriptId: binding.scriptId,
        platform: binding.platform,
        success: result.exitCode == 0,
        exitCode: result.exitCode,
      );
    } catch (e, st) {
      debugPrint('[BIND] run failed: $e\n$st');
      return ScriptDispatchResult(
        scriptId: binding.scriptId,
        platform: binding.platform,
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  void _emit(ActionBinding binding, String eventName) {
    if (_notices.isClosed) return;
    _notices.add(BindingTriggerNotice(
      binding: binding,
      eventName: eventName,
      desktop: _isDesktop,
    ));
  }

  void dispose() {
    for (final sub in _deviceSubs.values) {
      sub.close();
    }
    _deviceSubs.clear();
    _notices.close();
  }
}

/// Snapshot describing one matched binding firing. Surfaced through the
/// service's `notices` broadcast stream so any host widget can listen
/// and render an appropriate toast.
class BindingTriggerNotice {
  const BindingTriggerNotice({
    required this.binding,
    required this.eventName,
    required this.desktop,
  });

  final ActionBinding binding;
  final String eventName;
  final bool desktop;
}

/// Outcome of running a single binding's script. Carries enough context
/// for the activity-log row in the SKAPI screen to display per-script
/// success/failure (`exit=0`, `error=skapiRunErrorPowerShellMissing`,
/// etc.) without a separate logging surface.
class ScriptDispatchResult {
  const ScriptDispatchResult({
    required this.scriptId,
    required this.platform,
    required this.success,
    this.exitCode,
    this.errorMessage,
  });

  final String scriptId;
  final String platform;
  final bool success;
  final int? exitCode;
  final String? errorMessage;
}

/// Result of a single dispatch call (one webhook → 0..N matched
/// bindings → 0..N script runs). The HTTP route hands this back to
/// WebhookActivityNotifier so the user sees "matched 0" or "matched 2,
/// script_error" instead of a misleading green "Kabul edildi" with no
/// follow-up.
class DispatchSummary {
  const DispatchSummary({
    required this.matchedBindings,
    required this.scriptResults,
  });

  final int matchedBindings;
  final List<ScriptDispatchResult> scriptResults;

  bool get anyFailed => scriptResults.any((r) => !r.success);
  bool get allSucceeded =>
      scriptResults.isNotEmpty && scriptResults.every((r) => r.success);
}
