/// Static catalog of BF firmware events that the bind UI offers as
/// triggers. Keys are the exact strings the firmware publishes via
/// `sk_event_bus_publish(...)` (kept in sync manually, mismatches show
/// up at runtime as bindings that never fire).
///
/// `i18nLabel` resolves to the dropdown label in the bind screen via a
/// switch in the screen file (the generated AppLocalizations exposes
/// named getters, not string lookup).
class BfEvent {
  const BfEvent({required this.value, required this.i18nLabel});

  final String value;
  final String i18nLabel;
}

const List<BfEvent> kBfEvents = [
  // Names verified against esp32/BF/components/.../sk_event_bus_publish(...)
  // calls in firmware. Diverging from these breaks bindings silently.
  BfEvent(value: 'timer.state', i18nLabel: 'skapiBindEventTimerStarted'),
  BfEvent(value: 'timer.expired', i18nLabel: 'skapiBindEventTimerExpired'),
  BfEvent(value: 'face.changed', i18nLabel: 'skapiBindEventFaceChanged'),
  BfEvent(value: 'button.pressed', i18nLabel: 'skapiBindEventButtonPressed'),
  BfEvent(value: 'button.hold', i18nLabel: 'skapiBindEventButtonHeld'),
  BfEvent(value: 'battery.low', i18nLabel: 'skapiBindEventBatteryLow'),
  BfEvent(value: 'battery.lockout', i18nLabel: 'skapiBindEventBatteryLockout'),
  BfEvent(value: 'power.state', i18nLabel: 'skapiBindEventPowerStateChanged'),
  BfEvent(
      value: 'pairing.mode.open',
      i18nLabel: 'skapiBindEventPairingSuccess'),
  BfEvent(value: 'api.sent', i18nLabel: 'skapiBindEventApiSent'),
];
