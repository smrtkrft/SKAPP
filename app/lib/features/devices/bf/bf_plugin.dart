import 'package:flutter/widgets.dart';

import '../../../core/ble/device_type_visual.dart';
import '../../../core/devices/device_plugin.dart';
import '../../skapi/data/bf_event_catalog.dart';
import 'bf_home_screen.dart';

/// Blocking Focus — the SmartKraft focus-timer device.
class BfPlugin implements DevicePlugin {
  const BfPlugin();

  @override
  String get prefix => 'BF';

  @override
  String get displayName => DeviceTypeVisual.friendlyName('BF');

  @override
  IconData get icon => DeviceTypeVisual.iconFor('BF');

  @override
  bool get isMobilePeer => false;

  @override
  List<DeviceEvent> get eventCatalog => kBfEvents
      .map((e) => DeviceEvent(value: e.value, i18nLabel: e.i18nLabel))
      .toList(growable: false);

  /// `timer.expired` is the only firmware event that fires the API chain
  /// (Faz B karar); bindings default to it. Note this is NOT
  /// `kBfEvents.first` (`timer.state`).
  @override
  String get defaultBindEvent => 'timer.expired';

  @override
  Widget buildHomeScreen(String deviceId) => BfHomeScreen(deviceId: deviceId);
}
