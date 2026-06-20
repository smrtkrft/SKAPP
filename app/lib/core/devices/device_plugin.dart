import 'package:flutter/widgets.dart';

/// A trigger event a device family can publish, surfaced in the bind UI.
///
/// Structurally mirrors the per-family `BfEvent` / `MobileEvent` catalogs;
/// the plugin layer maps those into this common shape so callers don't need
/// to know which concrete catalog a device uses.
class DeviceEvent {
  const DeviceEvent({required this.value, required this.i18nLabel});

  /// Exact event string the firmware / mobile peer publishes.
  final String value;

  /// AppLocalizations getter name resolved to a dropdown label by the bind
  /// screen (the generated l10n class exposes named getters, not lookup).
  final String i18nLabel;
}

/// One SmartKraft device family (`BF`, `LS`, `MS`, …) as a self-contained
/// plug-in. Collapses the `prefix == 'BF'/'LS'/'MS'` branches that were
/// scattered across the home dispatcher, visual table, bind screen, and
/// peer-classification call sites into a single registry entry.
///
/// Option A scope: the registry and this interface only. The existing
/// per-family home screens, icons, and event catalogs are unchanged; this
/// just centralises the type → screen / icon / event / peer-kind decision so
/// adding a family is one new plugin file plus one registry line.
abstract class DevicePlugin {
  /// Two-letter identity prefix, e.g. `BF`. Matches `PairedDevice.prefix`
  /// and `DiscoveredDevice.typePrefix`.
  String get prefix;

  /// Human-readable brand name (English; device types are technical ids).
  String get displayName;

  /// Hero icon for discovery / paired list / home shell.
  IconData get icon;

  /// `true` for a paired mobile SKAPP peer (`MS`) — a phone trigger source
  /// rather than a SmartKraft hardware device. Drives tile icon and the
  /// "skip hardware-only actions" branches.
  bool get isMobilePeer;

  /// Trigger events the bind UI offers for this family. Empty when the
  /// family ships no firmware event catalog yet.
  List<DeviceEvent> get eventCatalog;

  /// Event value a freshly-saved binding defaults to for this family.
  String get defaultBindEvent;

  /// Builds the device's home screen. `deviceId` is the BondStore /
  /// PairedDevicesStore key (BLE remoteId / MAC, or peer uuid for `MS`).
  Widget buildHomeScreen(String deviceId);
}
