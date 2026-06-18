// USB seri port keşfi · public facade.
//
// 2026-05-13 sonrası **sadece desktop** (Windows başlangıçta, Mac/Linux
// Faz 2). Android USB CLI kaldırıldı (niş kullanım, paket karmaşası).
// iOS hiç desteklenmiyor (MFi gerekli).
//
// Platform-spesifik implementasyon `WinPortScanner` (win_port_scanner.dart)
// içinde, Win32 SetupAPI ile native plugin'siz çalışıyor. Mac/Linux için
// ileride `PosixPortScanner` benzeri eklenecek.

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

import 'win_port_scanner.dart' as win;

/// ESP32-C6 native USB-Serial/JTAG VID, Espressif.
const int kEspressifVendorId = win.kEspressifVendorId;

/// ESP32-C6 USB-Serial-JTAG composite class PID.
const int kEsp32C6JtagProductId = win.kEsp32C6JtagProductId;

/// Platform-bağımsız port tarifi. UI bunu list/picker'da render eder,
/// transport `createUsbCliTransport(portInfo)` ile portu açar.
class UsbPortInfo {
  const UsbPortInfo({
    required this.portPath,
    required this.label,
    this.vendorId,
    this.productId,
    this.description,
  });

  /// Windows: "COM5" / "COM12". (Mac: "/dev/cu.usbserial-*", Linux:
  /// "/dev/ttyUSB*" Faz 2'de eklenecek.)
  final String portPath;

  /// Kullanıcıya gösterilecek etiket. Friendly name (örn. "USB Serial
  /// Device (COM5)") veya BF cihazı algılandıysa "SmartKraft BF-...".
  final String label;

  final int? vendorId;
  final int? productId;
  final String? description;

  /// Espressif ESP32-C6 native USB-Serial/JTAG VID+PID eşleşmesi. Üstte
  /// "SmartKraft" rozeti gösterilir + auto-select kriteri.
  bool get looksLikeBf =>
      vendorId == kEspressifVendorId && productId == kEsp32C6JtagProductId;

  /// Bilinen bir USB-UART bridge mi (CP2102, CH340, FTDI). BF dev kit
  /// böyle bir bridge ile bağlı olabilir; auto-select fallback aday'ı.
  bool get isLikelyBridge =>
      vendorId != null && win.kKnownBridgeVendorIds.contains(vendorId);

  @override
  String toString() => 'UsbPortInfo($label, '
      'vid=${vendorId?.toRadixString(16)}, '
      'pid=${productId?.toRadixString(16)})';
}

abstract class UsbPortScanner {
  /// Tek seferlik enumeration. UI ilk girişte ve manuel refresh'te çağırır.
  static Future<List<UsbPortInfo>> list() async {
    if (kIsWeb) return const [];
    if (!Platform.isWindows) return const [];
    final raw = await win.WinPortScanner.list();
    return raw
        .map((r) => UsbPortInfo(
              portPath: r.portPath,
              label: r.label,
              vendorId: r.vendorId,
              productId: r.productId,
              description: r.description,
            ))
        .toList(growable: false);
  }

  /// Periyodik (2 sn default) refresh stream'i. UsbConsoleScreen open
  /// iken provider bunu watch eder, USB plug/unplug için canlı UI.
  /// autoDispose ile ekran kapanınca kapanır.
  static Stream<List<UsbPortInfo>> watch({
    Duration interval = const Duration(seconds: 2),
  }) async* {
    yield await list();
    while (true) {
      await Future<void>.delayed(interval);
      yield await list();
    }
  }

  /// Auto-select: tam bir BF (Espressif VID+PID) eşleşmesi varsa onu döner,
  /// yoksa tek bir bridge varsa onu, hiçbiri yoksa null. UsbConsoleScreen
  /// boş portu seçilmediği durumda bu mantıkla otomatik picker'a girer.
  static UsbPortInfo? autoSelect(List<UsbPortInfo> ports) {
    final bf = ports.where((p) => p.looksLikeBf).toList();
    if (bf.length == 1) return bf.first;
    final bridges = ports.where((p) => p.isLikelyBridge).toList();
    if (bridges.length == 1) return bridges.first;
    return null;
  }
}
