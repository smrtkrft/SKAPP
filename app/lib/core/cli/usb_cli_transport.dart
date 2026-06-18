// USB CLI transport · Settings → Geliştirici modu → "USB CLI Konsol".
//
// Wire format: ham NDJSON. BF firmware'inde sk_transport_usb (bkz.
// esp32/BF/components/sk_core/src/sk_transport_usb.c) USB üzerinden gelen
// satırı `sk_cli_dispatch_line` ile *unauthenticated* dispatch ediyor:
// imzalı envelope (TCP/BLE'deki `{"body":"...","sig":"...","nonce":N}`)
// YAPILMIYOR. CliClient bu transport ile birlikte `signer: null` kullanır
// ve `send()` raw `{"cmd":"...","id":N,"args":...}` JSON gönderir
// (cli_client.dart:119).
//
// Auth handshake yapılmadığı için `connect()` içinde `_authenticated = true`
// direkt set ediliyor, TCP/BLE'deki `_authDone.future` await blocking yok.
// `requires_auth = true` cihaz tarafı komutlar (userdata.*, secure.*,
// api.endpoint.add) USB'den `ERR_NOT_AUTHENTICATED` yanıt döner, beklenen
// davranış, kullanıcı UI'da görür ve dev mod'un sınırını anlar.
//
// Buffer sınırı: cihazda USB_LINE_BUF = 1024 byte. Bunu aşan komutlar
// firmware tarafında sessiz drop edilir; sendLine içinde fail-fast guard
// var (kullanıcı görünür hata alır, drop senaryosu yaşamaz).
//
// Platform (2026-05-13'ten itibaren): **Sadece Windows desktop**. Android
// desteği kaldırıldı (niş kullanım + paket karmaşası). Mac/Linux Faz 2'de
// aynı FFI yaklaşımıyla `dart:ffi` üzerinden POSIX termios eklenecek.
// iOS hiç desteklenmiyor (MFi gerekli). Mobile platform'larda transport
// fabrika `UnsupportedError` fırlatır.

import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'cli_transport.dart';
import 'usb_port_scanner.dart';
import 'win_serial_transport.dart';

/// Platform fabrika: hangi backend kullanılacağına karar verir.
CliTransport createUsbCliTransport({
  required UsbPortInfo portInfo,
  int baudRate = 115200,
}) {
  if (kIsWeb) {
    throw UnsupportedError('USB CLI web\'de desteklenmiyor.');
  }
  if (Platform.isWindows) {
    return WinSerialTransport(portInfo: portInfo, baudRate: baudRate);
  }
  // Mac/Linux → Faz 2 (POSIX termios FFI). Şu an placeholder hata.
  throw UnsupportedError(
    'USB CLI bu platformda henüz desteklenmiyor. Şu an sadece Windows.',
  );
}

/// Tüm USB transport implementasyonlarının uyacağı line-reassembly
/// + sendLine guard'larını içeren base sınıf. Platform-spesifik subclass
/// (`WinSerialTransport`, ileride `PosixSerialTransport`) `openPort()` ve
/// `writeBytes()` + `close()` adımlarını sağlar.
abstract class UsbCliTransportBase implements CliTransport {
  UsbCliTransportBase({required this.portInfo, this.baudRate = 115200});

  final UsbPortInfo portInfo;

  /// Native USB-Serial-JTAG (ESP32-C6) baud rate'i ignore eder; TinyUSB
  /// embedded auto-negotiate. Yine de desktop API'leri config istediği
  /// için bir değer veriyoruz.
  final int baudRate;

  /// Firmware tarafında USB_LINE_BUF, bu sınırı aşan komut sessiz drop
  /// edilirdi (sk_transport_usb.c:19, sk_cli.c:22). Fail-fast guard.
  static const int kFirmwareUsbLineBuf = 1024;

  final _incoming = StreamController<String>.broadcast();
  final _buffer = StringBuffer();
  bool _authenticated = false;
  bool _closed = false;

  @override
  Stream<String> get incoming => _incoming.stream;

  @override
  bool get authenticated => _authenticated;

  @override
  Future<void> connect() async {
    await openPort();
    // USB CLI handshake'i atlar (sk_transport_usb.c unauthenticated
    // dispatcher). Authenticated bayrağı UI "bağlı" göstergesi için açık;
    // CliClient signer: null kullandığı sürece requires_auth=true komutlar
    // firmware'da reddedilir (kasıtlı, dev mod sınırını ifade eder).
    _authenticated = true;
  }

  @override
  Future<void> sendLine(String line) async {
    if (_closed) {
      throw StateError('USB transport kapalı');
    }
    final wire = line.endsWith('\n') ? line : '$line\n';
    final bytes = utf8.encode(wire);
    if (bytes.length > kFirmwareUsbLineBuf - 1) {
      throw StateError(
        'USB komutu firmware buffer sınırını aşıyor '
        '(${bytes.length} byte > ${kFirmwareUsbLineBuf - 1}). '
        'Daha kısa komut gönder veya BLE/WiFi kullan.',
      );
    }
    await writeBytes(bytes);
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _authenticated = false;
    try {
      await closePort();
    } catch (_) {/* zaten gone */}
    if (!_incoming.isClosed) {
      await _incoming.close();
    }
  }

  // -- Subclass extension points -------------------------------------------

  Future<void> openPort();
  Future<void> writeBytes(List<int> bytes);
  Future<void> closePort();

  /// Subclass okuma loop'undan çağırır: gelen ham byte chunk'ı buffer'a
  /// ekler, satır sonu (`\n` / `\r\n`) tespit edip parça parça `incoming`
  /// stream'ine atar.
  void onChunk(List<int> bytes) {
    if (_closed || _incoming.isClosed) return;
    final chunk = utf8.decode(bytes, allowMalformed: true);
    _buffer.write(chunk);
    while (true) {
      final s = _buffer.toString();
      final nl = s.indexOf('\n');
      if (nl < 0) break;
      var line = s.substring(0, nl);
      _buffer
        ..clear()
        ..write(s.substring(nl + 1));
      if (line.endsWith('\r')) {
        line = line.substring(0, line.length - 1);
      }
      if (line.isEmpty) continue;
      _incoming.add(line);
    }
  }

  /// Subclass kablo cekildi / cihaz reset edildi dedektör'ünden çağırır.
  /// Idempotent close + stream done propagasyonu.
  void onTransportLost() {
    if (_closed) return;
    close();
  }
}
