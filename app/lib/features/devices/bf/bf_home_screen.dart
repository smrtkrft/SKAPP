import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cli/cli_providers.dart';
import '../../../core/ui/device_session_views.dart';
import '../../../l10n/app_localizations.dart';
import '../../device_pairing/repair_router.dart';
import 'bf_dashboard_screen.dart';
import 'bf_session.dart';
import 'passphrase_gate.dart';

/// Entry widget for a BF device. Resolves the long-lived
/// [deviceSessionProvider] + [secureStoreProvider], mounts a [BfSession]
/// scope and renders the dashboard underneath. Sub-screens (api chain,
/// settings, etc.) inherit the same [BfSession] via the widget tree.
///
/// This wrapper replaces the old [DeviceHomeScreen → ModuleRegistry →
/// BfModule.buildDeviceScreen] indirection. With BF defined directly in
/// the app there's no interface package to cross, just the same async
/// resolution flow inlined where it belongs.
class BfHomeScreen extends ConsumerWidget {
  const BfHomeScreen({super.key, required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sessionAsync = ref.watch(deviceSessionProvider(deviceId));
    final secureAsync = ref.watch(secureStoreProvider(deviceId));

    return sessionAsync.when(
      loading: () => DeviceSessionLoading(label: l.bfHomeLoadingConnecting),
      error: (e, _) => DeviceSessionError(
        deviceId: deviceId,
        error: e,
        onRepair: () => _startRepair(context, ref),
      ),
      data: (session) => secureAsync.when(
        loading: () => DeviceSessionLoading(label: l.bfHomeLoadingSecure),
        error: (e, _) => DeviceSessionError(
          deviceId: deviceId,
          error: e,
          onRepair: () => _startRepair(context, ref),
        ),
        data: (secure) => BfSession(
          deviceId: deviceId,
          client: session.client,
          secure: secure,
          transportKind: session.transportKind,
          // PassphraseGate sits between the BfSession scope and the
          // dashboard so any `always_required` lock from the firmware
          // surfaces here once, before the user touches any sub-screen.
          // Sub-screens reached via BfSession.push reuse the same
          // unlocked CliClient and don't probe again.
          child: PassphraseGate(
            client: session.client,
            child: BfDashboardScreen(deviceId: deviceId),
          ),
        ),
      ),
    );
  }

  /// Onarım artık taşıyıcı-farkındalı tek yönlendiriciden geçer
  /// (repair_router.dart): BLE ile eşleşmiş cihaz → PairingScreen,
  /// WiFi/mDNS ile eşleşmiş cihaz → WifiPairingScreen.
  Future<void> _startRepair(BuildContext context, WidgetRef ref) =>
      startRepairFlow(context, ref, deviceId);
}
