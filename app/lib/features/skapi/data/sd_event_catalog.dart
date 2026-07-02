/// Static catalog of SynDimm (SD) firmware events offered as SKAPI
/// triggers. Keys are the exact strings the firmware publishes via
/// `sk_event_bus_publish(...)` (see SynDimm/Code/neue SKAPP_CONTRACT.md);
/// mismatches show up at runtime as bindings that never fire.
///
/// Mirrors the `BfEvent` catalog shape; `i18nLabel` names an
/// AppLocalizations getter should the bind screen's event picker return
/// (today only `SdPlugin.defaultBindEvent` is consumed).
class SdEvent {
  const SdEvent({required this.value, required this.i18nLabel});

  final String value;
  final String i18nLabel;
}

const List<SdEvent> kSdEvents = [
  // safe.triggered is the marquee automation trigger: the physical knob
  // sequence matched and the device fired its webhook.
  SdEvent(value: 'safe.triggered', i18nLabel: 'skapiBindEventSdSafeTriggered'),
  SdEvent(value: 'mode.changed', i18nLabel: 'skapiBindEventSdModeChanged'),
  SdEvent(value: 'input.gesture', i18nLabel: 'skapiBindEventSdGesture'),
  SdEvent(value: 'api.sent', i18nLabel: 'skapiBindEventApiSent'),
];
