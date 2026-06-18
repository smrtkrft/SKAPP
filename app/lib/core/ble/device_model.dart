// Models for a SmartKraft device discovered over BLE.
//
// SmartKraft identity convention (sk_identity.h): `<XX>-<suffix>`
//   - 2 uppercase letters: device type prefix (BF, LS, ...)
//   - dash
//   - hardware revision letter + unique suffix (currently 1 + 8 = 9 chars,
//     accepted range 6..12 for future revisions).

/// Pairing posture advertised by the device, parsed from BLE manufacturer
/// data per the sk_transport_ble.c contract:
///
///   Company ID = 0x00F1, payload = ASCII tag
///     'par' → SK_PAIRABLE_OPEN   (no bond yet, button-press or window
///                                 active, will accept ECDH exchange)
///     'bnd' → SK_PAIRABLE_BONDED (at least one bond stored, will reject
///                                 a fresh pair without re-opening)
enum SkPairableState { pairable, bonded, unknown }

/// A SmartKraft device discovered over BLE.
class DiscoveredDevice {
  const DiscoveredDevice({
    required this.id,
    required this.name,
    required this.rssi,
    this.pairable = SkPairableState.unknown,
  });

  /// Stable BLE identifier (remoteId / MAC). Used to reopen the connection
  /// from a stored bond, does NOT survive an Android reboot on every OEM,
  /// so the pairing flow also keeps the human-readable name.
  final String id;
  final String name;
  final int rssi;

  /// Pairing posture from advertised manufacturer data; defaults to
  /// `unknown` when the scan result didn't carry it (mDNS-only entries,
  /// non-SmartKraft devices, older firmware).
  final SkPairableState pairable;

  static final _identityPattern =
      RegExp(r'^([A-Z]{2})-([A-Z0-9]{6,12})$');

  /// Two-letter device-type prefix, or null if the name doesn't match.
  String? get typePrefix => _identityPattern.firstMatch(name)?.group(1);

  bool get isSmartKraft => typePrefix != null;

  /// Decode the pairing-posture tag from a flutter_blue_plus
  /// manufacturerData map. Returns `unknown` when the SmartKraft block
  /// is absent or unparseable; never throws.
  ///
  /// Wire format (sk_transport_ble.c:137-140):
  ///   mfg_data = { 0xF1, 0x00, 'p','a','r' }  -> pairable
  ///   mfg_data = { 0xF1, 0x00, 'b','n','d' }  -> bonded
  ///
  /// flutter_blue_plus keys the map by the 16-bit Company ID (0x00F1 =
  /// 241) and strips those two bytes from the value, so the value seen
  /// here is the 3-byte ASCII tag.
  static SkPairableState parsePairable(Map<int, List<int>> mfg) {
    final payload = mfg[0xF1];
    if (payload == null || payload.length < 3) return SkPairableState.unknown;
    final tag = String.fromCharCodes(payload.take(3));
    switch (tag) {
      case 'par':
        return SkPairableState.pairable;
      case 'bnd':
        return SkPairableState.bonded;
      default:
        return SkPairableState.unknown;
    }
  }
}
