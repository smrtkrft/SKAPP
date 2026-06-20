import 'package:flutter/widgets.dart';

import '../../../core/ble/device_type_visual.dart';
import '../../../core/devices/device_plugin.dart';
import 'ls_home_screen.dart';

/// LebensSpur — the SmartKraft hourglass device.
class LsPlugin implements DevicePlugin {
  const LsPlugin();

  @override
  String get prefix => 'LS';

  @override
  String get displayName => DeviceTypeVisual.friendlyName('LS');

  @override
  IconData get icon => DeviceTypeVisual.iconFor('LS');

  @override
  bool get isMobilePeer => false;

  /// No LS-specific event catalog ships yet; bind UI shows nothing extra.
  @override
  List<DeviceEvent> get eventCatalog => const [];

  /// Preserves the bind screen's pre-registry behaviour: any non-mobile
  /// device (BF and LS alike) defaulted to `timer.expired`.
  @override
  String get defaultBindEvent => 'timer.expired';

  @override
  Widget buildHomeScreen(String deviceId) => LsHomeScreen(deviceId: deviceId);
}
