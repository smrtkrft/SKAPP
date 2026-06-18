import 'package:flutter/material.dart';

import '../../core/ble/device_model.dart';
import '../../l10n/app_localizations.dart';
import '../devices/bf/bf_home_screen.dart';
import '../devices/lebensspur/ls_home_screen.dart';
import '../devices/ms/ms_home_screen.dart';

/// Top-level dispatcher for paired SmartKraft devices.
///
/// With the move from packaged device modules to in-app device folders
/// (each device living under `features/devices/<name>/`), the dispatch
/// is a plain switch on the identity prefix. To add support for a new
/// device family: import its `<X>HomeScreen`, add a `case 'XX'` arm.
/// Removing a device = deleting its folder + the matching arm here.
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
    switch (device.typePrefix) {
      case 'BF':
        return BfHomeScreen(deviceId: device.id);
      case 'LS':
        return LsHomeScreen(deviceId: device.id);
      case 'MS':
        // Mobile SKAPP peer — informational screen, no BF-style
        // dashboard. Phone is just a trigger source; this view shows
        // what events it can emit and which bindings are wired to it.
        return MsHomeScreen(peerUuid: device.id);
    }
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
