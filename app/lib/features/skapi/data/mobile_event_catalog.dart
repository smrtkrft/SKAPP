/// Static catalog of mobile SKAPP peer events the bind UI offers as
/// triggers. Mirrors the BF catalog so the bind screen can pick the
/// right list based on the selected device's prefix (`MS` → this
/// catalog, `BF` → BF catalog).
///
/// Phase 1 ships a single manual trigger. Future events (shake,
/// foreground/background, geofence, NFC tap) drop in here and the bind
/// dropdown picks them up automatically.
class MobileEvent {
  const MobileEvent({required this.value, required this.i18nLabel});

  final String value;
  final String i18nLabel;
}

const List<MobileEvent> kMobileEvents = [
  // Manual trigger — fired by the "Tetikle" button on the mobile home
  // screen. Sent over POST /api/events/incoming/peer.
  MobileEvent(
    value: 'skapp.mobile.tap',
    i18nLabel: 'skapiBindEventMobileTap',
  ),
];

/// First event value in the catalog. Used by the bind screen as the
/// default selection when a mobile peer is chosen as the device.
const String kDefaultMobileEvent = 'skapp.mobile.tap';
