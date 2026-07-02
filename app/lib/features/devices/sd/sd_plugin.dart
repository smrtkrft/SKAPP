import 'package:flutter/widgets.dart';

import '../../../core/ble/device_type_visual.dart';
import '../../../core/devices/device_plugin.dart';
import '../../skapi/data/sd_event_catalog.dart';
import 'sd_home_screen.dart';

/// SynDimm — the SmartKraft rotary-encoder universal controller.
/// Three mode slots (dimmer / shutter / safe / mqtt_remote behaviors),
/// physical knob + SKAPP as the two control surfaces.
class SdPlugin implements DevicePlugin {
  const SdPlugin();

  @override
  String get prefix => 'SD';

  @override
  String get displayName => DeviceTypeVisual.friendlyName('SD');

  @override
  IconData get icon => DeviceTypeVisual.iconFor('SD');

  @override
  bool get isMobilePeer => false;

  @override
  List<DeviceEvent> get eventCatalog => kSdEvents
      .map((e) => DeviceEvent(value: e.value, i18nLabel: e.i18nLabel))
      .toList(growable: false);

  /// The safe sequence firing its webhook is the event worth automating
  /// on; mode.value would flood (≤10 Hz coalesced) and mode.changed is
  /// a local UI concern.
  @override
  String get defaultBindEvent => 'safe.triggered';

  @override
  Widget buildHomeScreen(String deviceId) => SdHomeScreen(deviceId: deviceId);
}
