/// Notification state for a paired device, surfaced on the device card
/// in the constellation view (Cihazlarim) and as the alert in Dashboard.
///
/// Computed by [deviceNotificationStateProvider] from the union of
/// device telemetry (battery), connectivity (mDNS lastSeen) and pairing
/// status. The card UI maps each value to a colored dot and an optional
/// notification line ("pil dustu (%23)", "2 saat once cevrimdisi", ...).
///
/// MVP scope: only [none] and [offline] are computed today; [lowBattery]
/// is reserved for the next firmware revision (BF Faz D2 wires battery
/// telemetry into the runtime CLI session).
enum NotificationState {
  /// Healthy: online and within battery threshold.
  none,

  /// mDNS hasn't seen the device past the freshness window.
  offline,

  /// Battery <= configured threshold (default %20).
  lowBattery,

  /// Pairing started but not yet confirmed (button + ECDH handshake
  /// pending). Surfaces a transient state on the card while the user
  /// completes the device-side button press.
  pairingPending,
}

extension NotificationStateX on NotificationState {
  /// True if the state should draw user attention (any non-`none`).
  bool get isAlert => this != NotificationState.none;

  /// True if the state requires immediate action (low battery, dropped
  /// pairing). Offline is informational, not critical.
  bool get isCritical =>
      this == NotificationState.lowBattery ||
      this == NotificationState.pairingPending;
}
