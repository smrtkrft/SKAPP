import 'package:flutter/widgets.dart';

import '../../../core/ble/device_type_visual.dart';
import '../../../core/devices/device_plugin.dart';
import '../../skapi/data/mobile_event_catalog.dart';
import 'ms_home_screen.dart';

/// SKAPP Mobile — a paired phone running SKAPP. Not SmartKraft hardware; a
/// trigger source whose home view is informational rather than a dashboard.
class MsPlugin implements DevicePlugin {
  const MsPlugin();

  @override
  String get prefix => 'MS';

  @override
  String get displayName => DeviceTypeVisual.friendlyName('MS');

  @override
  IconData get icon => DeviceTypeVisual.iconFor('MS');

  @override
  bool get isMobilePeer => true;

  @override
  List<DeviceEvent> get eventCatalog => kMobileEvents
      .map((e) => DeviceEvent(value: e.value, i18nLabel: e.i18nLabel))
      .toList(growable: false);

  @override
  String get defaultBindEvent => kDefaultMobileEvent;

  @override
  Widget buildHomeScreen(String deviceId) => MsHomeScreen(peerUuid: deviceId);
}
