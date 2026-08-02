import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cli/cli_providers.dart';
import '../../../core/ui/device_session_views.dart';
import '../../../l10n/app_localizations.dart';
import '../../device_pairing/repair_router.dart';
import '../bf/passphrase_gate.dart';
import 'sd_dashboard_screen.dart';
import 'sd_session.dart';

/// Entry widget for a SynDimm device. Resolves the long-lived
/// [deviceSessionProvider] + [secureStoreProvider], mounts an [SdSession]
/// scope and renders the dashboard underneath. Mirrors `BfHomeScreen`;
/// the passphrase gate is the shared BF implementation (client-generic,
/// probes `device.info` for `ERR_SESSION_LOCKED`).
class SdHomeScreen extends ConsumerWidget {
  const SdHomeScreen({super.key, required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sessionAsync = ref.watch(deviceSessionProvider(deviceId));
    final secureAsync = ref.watch(secureStoreProvider(deviceId));

    return sessionAsync.when(
      loading: () => DeviceSessionLoading(label: l.sdHomeLoadingConnecting),
      error: (e, _) => DeviceSessionError(
        deviceId: deviceId,
        error: e,
        onRepair: () => _startRepair(context, ref),
      ),
      data: (session) => secureAsync.when(
        loading: () => DeviceSessionLoading(label: l.sdHomeLoadingSecure),
        error: (e, _) => DeviceSessionError(
          deviceId: deviceId,
          error: e,
          onRepair: () => _startRepair(context, ref),
        ),
        data: (secure) => SdSession(
          deviceId: deviceId,
          client: session.client,
          secure: secure,
          transportKind: session.transportKind,
          child: PassphraseGate(
            client: session.client,
            child: SdDashboardScreen(deviceId: deviceId),
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
