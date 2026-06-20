import 'package:flutter/material.dart';

import '../../core/ble/device_model.dart';
import '../../core/devices/device_plugin_registry.dart';
import '../../l10n/app_localizations.dart';

/// Top-level dispatcher for paired SmartKraft devices.
///
/// Each device family lives under `features/devices/<name>/` and registers a
/// `DevicePlugin` in [devicePluginRegistry]. Dispatch is a single registry
/// lookup; an unknown prefix falls back to [_UnsupportedDevice]. To add a
/// device family: write its plugin + add one registry line — no edit here.
class DeviceHomeScreen extends StatelessWidget {
  const DeviceHomeScreen({super.key, required this.device});
  final DiscoveredDevice device;

  @override
  Widget build(BuildContext context) {
    // Pass device.id (BLE remoteId / MAC on Android) downstream, that is
    // the key BondStore + PairedDevicesStore use, and what the rest of
    // the setup flow already plumbs through deviceSessionProvider. Using
    // device.name here would land the device home shell on a freshly
    // created session that can't find the bond and dies with
    // "no bond stored for <name>".
    final plugin = pluginFor(device.typePrefix);
    if (plugin != null) return plugin.buildHomeScreen(device.id);
    return _UnsupportedDevice(device: device);
  }
}

class _UnsupportedDevice extends StatelessWidget {
  const _UnsupportedDevice({required this.device});
  final DiscoveredDevice device;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l.deviceHomeUnsupportedTitle),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            l.deviceHomeUnsupportedBody(device.name),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
