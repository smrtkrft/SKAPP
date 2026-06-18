// Windows USB seri port keşfi · SetupAPI ile.
//
// SetupDiGetClassDevs(GUID_DEVCLASS_PORTS) tüm seri port cihazlarını
// listeler (USB-Serial bridge'ler, COM port'lar). Her cihaz için:
//   - SPDRP_FRIENDLYNAME      → "USB Serial Device (COM5)" gibi etiket;
//                               COM port adını buradan parse ediyoruz
//   - SPDRP_HARDWAREID         → "USB\\VID_303A&PID_1001\\..." formatında;
//                               VID/PID burada
//
// Native plugin yok, sadece win32 paketi (FFI). Periyodik polling ile
// USB plug/unplug event'lerini yakalıyoruz; 2 saniyelik tick UX olarak
// yeterli. Daha "live" istenirse RegisterDeviceNotification ile WM_
// DEVICECHANGE callback'i eklenebilir (ileride).
//
// BF cihazları için VID/PID tanıma:
//   - 0x303A / 0x1001  ESP32-C6 native USB-Serial-JTAG (referans BF board)
//   - 0x10C4 / 0xEA60  Silicon Labs CP2102/CP2104 (yaygın USB-UART bridge)
//   - 0x1A86 / 0x7523  CH340/CH341
//   - 0x0403 / 0x6001  FTDI FT232
// İlk eşleşme `looksLikeBf` true döner; auto-select için kullanılır.

import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

/// ESP32-C6 native USB-Serial/JTAG VID/PID.
const int kEspressifVendorId = 0x303A;
const int kEsp32C6JtagProductId = 0x1001;

/// Yaygın USB-UART bridge VID'leri (BF cihazları CP2102/CH340 ile de bağlanır).
const Set<int> kKnownBridgeVendorIds = {
  0x303A, // Espressif
  0x10C4, // Silicon Labs (CP2102/CP2104)
  0x1A86, // QinHeng (CH340/CH341)
  0x0403, // FTDI
};

/// Internal Win32 result struct. Public API için `WinPortInfo`
/// (usb_port_scanner.dart) facade'ı kullanılır; bu sadece scanner'ın
/// kendi sonuç tipi.
class WinPortInfo {
  const WinPortInfo({
    required this.portPath,
    required this.label,
    this.vendorId,
    this.productId,
    this.description,
  });

  /// "COM5" / "COM12" gibi düz portname.
  final String portPath;
  final String label;
  final int? vendorId;
  final int? productId;
  final String? description;

  bool get looksLikeBf =>
      vendorId == kEspressifVendorId && productId == kEsp32C6JtagProductId;

  bool get isLikelyBridge =>
      vendorId != null && kKnownBridgeVendorIds.contains(vendorId);
}

/// SetupAPI ile Windows COM portlarını listeler. Mobile/web platformlarda
/// ya factory hiç çağrılmaz ya da çağrılırsa boş liste döner.
abstract class WinPortScanner {
  /// `GUID_DEVCLASS_PORTS` = {4d36e978-e325-11ce-bfc1-08002be10318}
  /// win32 paketinde bu sabit her sürümde mevcut değil, GUID'i runtime'da
  /// bytes'tan inşa ediyoruz (Windows ABI'da değişmez, sabittir).
  ///
  /// GUID layout little-endian Data1 + Data2 + Data3 + big-endian Data4.
  /// Bu sürümde GUID.Data4 array setter olarak expose edilmediği için
  /// pointer'ı Uint8'a cast edip 16 byte'ı direkt yazıyoruz.
  static Pointer<GUID> _allocPortsClassGuid() {
    final guid = calloc<GUID>();
    final raw = guid.cast<Uint8>();
    const bytes = <int>[
      0x78, 0xE9, 0x36, 0x4D, // Data1 LE: 0x4D36E978
      0x25, 0xE3, // Data2 LE: 0xE325
      0xCE, 0x11, // Data3 LE: 0x11CE
      0xBF, 0xC1, 0x08, 0x00, 0x2B, 0xE1, 0x03, 0x18, // Data4 BE
    ];
    for (var i = 0; i < 16; i++) {
      raw[i] = bytes[i];
    }
    return guid;
  }

  /// Tek seferlik enumeration. UI ilk girişte ve manuel refresh'te çağırır.
  static Future<List<WinPortInfo>> list() async {
    final guid = _allocPortsClassGuid();
    final hDevInfo = SetupDiGetClassDevs(
      guid,
      nullptr,
      NULL,
      DIGCF_PRESENT,
    );
    if (hDevInfo == INVALID_HANDLE_VALUE) {
      free(guid);
      return const [];
    }
    final out = <WinPortInfo>[];
    try {
      var index = 0;
      while (true) {
        final devInfo = calloc<SP_DEVINFO_DATA>();
        devInfo.ref.cbSize = sizeOf<SP_DEVINFO_DATA>();
        final hasMore =
            SetupDiEnumDeviceInfo(hDevInfo, index, devInfo) != 0;
        if (!hasMore) {
          free(devInfo);
          break;
        }
        try {
          final friendly = _getDeviceProperty(
            hDevInfo,
            devInfo,
            SPDRP_FRIENDLYNAME,
          );
          final hardwareId = _getDeviceProperty(
            hDevInfo,
            devInfo,
            SPDRP_HARDWAREID,
          );
          if (friendly != null) {
            final portName = _extractComPort(friendly);
            if (portName != null) {
              final ids = _extractVidPid(hardwareId ?? '');
              out.add(WinPortInfo(
                portPath: portName,
                label: friendly,
                vendorId: ids.vid,
                productId: ids.pid,
                description: hardwareId,
              ));
            }
          }
        } finally {
          free(devInfo);
        }
        index++;
      }
    } finally {
      SetupDiDestroyDeviceInfoList(hDevInfo);
      free(guid);
    }
    out.sort((a, b) {
      if (a.looksLikeBf != b.looksLikeBf) return a.looksLikeBf ? -1 : 1;
      if (a.isLikelyBridge != b.isLikelyBridge) {
        return a.isLikelyBridge ? -1 : 1;
      }
      return a.portPath.compareTo(b.portPath);
    });
    return out;
  }

  /// Periyodik refresh stream'i. Provider bunu watch eder, ekran açıkken
  /// otomatik canlı kalır. autoDispose ile kapanır.
  static Stream<List<WinPortInfo>> watch({
    Duration interval = const Duration(seconds: 2),
  }) async* {
    yield await list();
    while (true) {
      await Future<void>.delayed(interval);
      yield await list();
    }
  }

  /// Tek bir cihazın stringe çevrilen property'sini okur. Buffer size
  /// önce 0 ile çağrılır, gerçek size GetLastError ile döner, sonra
  /// allocate edip tekrar çağırılır (Win32 idiomu).
  static String? _getDeviceProperty(
    int hDevInfo,
    Pointer<SP_DEVINFO_DATA> devInfo,
    int property,
  ) {
    final neededBytes = calloc<Uint32>();
    try {
      // İlk çağrı: buffer null, gerçek boyutu öğren
      SetupDiGetDeviceRegistryProperty(
        hDevInfo,
        devInfo,
        property,
        nullptr,
        nullptr,
        0,
        neededBytes,
      );
      if (neededBytes.value == 0) return null;
      final buffer = calloc<Uint8>(neededBytes.value);
      try {
        final ok = SetupDiGetDeviceRegistryProperty(
          hDevInfo,
          devInfo,
          property,
          nullptr,
          buffer.cast(),
          neededBytes.value,
          nullptr,
        );
        if (ok == 0) return null;
        // REG_SZ veya REG_MULTI_SZ döner (UTF-16). REG_MULTI_SZ ise
        // ilk null'a kadar parse et.
        final ptr = buffer.cast<Utf16>();
        return ptr.toDartString();
      } finally {
        free(buffer);
      }
    } finally {
      free(neededBytes);
    }
  }

  /// "USB Serial Device (COM5)" gibi friendly name'den "COM5"'i çeker.
  /// Eşleşme yoksa null döner (cihaz seri port değil veya farklı format).
  static String? _extractComPort(String friendlyName) {
    final match = RegExp(r'\((COM\d+)\)').firstMatch(friendlyName);
    return match?.group(1);
  }

  /// "USB\\VID_303A&PID_1001\\..." formatından VID + PID çıkarır.
  /// Bulamazsa (vid: null, pid: null) döner.
  static ({int? vid, int? pid}) _extractVidPid(String hardwareId) {
    final vidMatch =
        RegExp(r'VID_([0-9A-Fa-f]{4})').firstMatch(hardwareId);
    final pidMatch =
        RegExp(r'PID_([0-9A-Fa-f]{4})').firstMatch(hardwareId);
    return (
      vid: vidMatch != null ? int.parse(vidMatch.group(1)!, radix: 16) : null,
      pid: pidMatch != null ? int.parse(pidMatch.group(1)!, radix: 16) : null,
    );
  }
}
