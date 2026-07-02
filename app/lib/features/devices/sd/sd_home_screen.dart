import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ble/device_model.dart';
import '../../../core/cli/cli_providers.dart';
import '../../../core/storage/paired_devices_store.dart';
import '../../../core/ui/device_session_views.dart';
import '../../../l10n/app_localizations.dart';
import '../../device_pairing/pairing_screen.dart';
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

  /// Reopens PairingScreen from the stored PairedDevice record and
  /// invalidates the session provider on return (fresh handshake).
  Future<void> _startRepair(BuildContext context, WidgetRef ref) async {
    final paired = ref.read(pairedDevicesProvider).firstWhere(
          (d) => d.id == deviceId,
          orElse: () => PairedDevice(
            id: deviceId,
            name: deviceId,
            prefix: '',
            pairedAt: DateTime.now(),
          ),
        );
    final device = DiscoveredDevice(
      id: paired.id,
      name: paired.name,
      rssi: 0,
    );
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PairingScreen(device: device)),
    );
    ref.invalidate(deviceSessionProvider(deviceId));
  }
}
