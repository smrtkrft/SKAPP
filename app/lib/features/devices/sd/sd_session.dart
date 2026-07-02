import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cli/cli_client.dart';
import '../../../core/cli/cli_providers.dart';
import '../../../core/cli/cli_transport.dart';
import '../../../core/cli/secure_store_client.dart';
import '../../../core/ui/device_session_views.dart';

/// Inherited handle to the live CLI client and secure-store client for a
/// SynDimm device.
///
/// Mounted by [SdHomeScreen] once the device session resolves; every
/// downstream SD screen (dashboard, modes, profiles, safe, settings,
/// events, logs) reads the clients from here via `SdSession.of(context)`.
///
/// Mirrors `BfSession` (bf_session.dart) — same provider-subscribing
/// route gate so a transport drop rebuilds the session instead of leaving
/// pushed routes clinging to a dead client.
class SdSession extends InheritedWidget {
  const SdSession({
    super.key,
    required this.deviceId,
    required this.client,
    required this.secure,
    required this.transportKind,
    required super.child,
  });

  /// Persistent identity, e.g. `SD-A06TMFSQT`.
  final String deviceId;

  /// Authenticated, ready-to-send client over BLE or TCP.
  final CliClient client;

  /// Wrapper around `secure.*` / `userdata.*` CLI commands.
  final SecureStoreClient secure;

  /// Which physical transport this session is riding right now.
  final CliTransportKind transportKind;

  static SdSession of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SdSession>();
    assert(
      scope != null,
      'SdSession not found, SD screen mounted outside SdHomeScreen.',
    );
    return scope!;
  }

  /// Push a child route under this session's scope. The pushed route
  /// subscribes to the session providers itself (NOT a snapshot), so a
  /// transport refresh re-mounts SdSession with the fresh client while
  /// the child's State survives.
  static Future<T?> push<T>(BuildContext context, Widget child) {
    final deviceId = SdSession.of(context).deviceId;
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (_) => _SdSessionRouteGate(
          deviceId: deviceId,
          child: child,
        ),
      ),
    );
  }

  /// Push an SD sub-route from a context that is NOT inside an SdSession
  /// scope (e.g. SKAPI tab CTAs).
  static Future<T?> pushForDevice<T>({
    required BuildContext context,
    required String deviceId,
    required Widget child,
  }) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (_) => _SdSessionRouteGate(
          deviceId: deviceId,
          child: child,
        ),
      ),
    );
  }

  @override
  bool updateShouldNotify(SdSession old) =>
      client != old.client ||
      secure != old.secure ||
      deviceId != old.deviceId ||
      transportKind != old.transportKind;
}

/// Reactive scope keeping pushed sub-routes alive across session
/// re-resolution (see BfSession's `_BfSessionRouteGate` rationale).
class _SdSessionRouteGate extends ConsumerWidget {
  const _SdSessionRouteGate({
    required this.deviceId,
    required this.child,
  });

  final String deviceId;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(deviceSessionProvider(deviceId));
    final secureAsync = ref.watch(secureStoreProvider(deviceId));

    return sessionAsync.when(
      loading: () => const DeviceSessionLoading(),
      error: (e, _) => DeviceSessionError(deviceId: deviceId, error: e),
      data: (session) => secureAsync.when(
        loading: () => const DeviceSessionLoading(),
        error: (e, _) => DeviceSessionError(deviceId: deviceId, error: e),
        data: (secure) => SdSession(
          deviceId: deviceId,
          client: session.client,
          secure: secure,
          transportKind: session.transportKind,
          child: child,
        ),
      ),
    );
  }
}
