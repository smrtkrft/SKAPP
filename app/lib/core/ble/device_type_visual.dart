import 'package:flutter/material.dart';

/// Per-prefix visual identity for SmartKraft device families.
///
/// Centralises the icon + brand name a device gets across the pairing
/// wizard, discovery list, paired list, and home shell so adding a new
/// family (XX) is a single-spot change here. Brand names stay in English
/// per memory feedback_i18n_script_ids (device-type identifiers are
/// technical names, not translated copy).
class DeviceTypeVisual {
  const DeviceTypeVisual._();

  /// Hero icon for the family. Bluetooth icon is the explicit fallback
  /// for unknown / non-SmartKraft entries since those flows still go
  /// through BLE transport.
  static IconData iconFor(String? prefix) {
    switch (prefix) {
      case 'BF':
        return Icons.lock_clock_outlined;
      case 'LS':
        return Icons.hourglass_bottom_rounded;
      case 'MS':
        return Icons.smartphone_outlined;
      default:
        return Icons.bluetooth_rounded;
    }
  }

  /// Human-readable brand name, mirrors PairedDevice.typeFullName so a
  /// DiscoveredDevice (which has no PairedDevice wrapper yet) renders
  /// the same label. Falls back to the raw prefix for future families.
  static String friendlyName(String? prefix) {
    switch (prefix) {
      case 'BF':
        return 'Blocking Focus';
      case 'LS':
        return 'LebensSpur';
      case 'MS':
        return 'SKAPP Mobile';
      default:
        return prefix ?? '';
    }
  }
}
