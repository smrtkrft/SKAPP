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
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;

import '../pairing/pairing_link.dart'
    show NdjsonLineBuffer, PairingLineOverflow;
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

  /// Satır tavanlı tampon (İ-10): `\n` göndermeyen bir uç — yanlış seçilmiş
  /// COM portu, bootloader çıktısı, ikili modda bir çevre birimi — eskiden
  /// tamponu sınırsız büyütüp her chunk'ta O(n) kopya ile ana isolate'i
  /// dondurabiliyordu. 64 KiB tavan, firmware'in tek satırlık ~12 KB `help`
  /// cevabına fazlasıyla yer bırakır.
  final _buffer = NdjsonLineBuffer();

  /// UTF-8 çözücüyü chunk'lar arasında DURUMLU tut: çok baytlı karakter
  /// (Türkçe metinler) iki okuma arasında bölününce chunk-başına decode
  /// mojibake üretiyordu. TCP/BLE zaten durumlu decoder kullanıyor.
  late final _utf8Sink = _Utf8ChunkDecoder();

  bool _authenticated = false;
  bool _closed = false;

  /// Kapanışa yol açan alt hata (unplug win32 kodu vb.); temiz kapanışta
  /// null. CliClient bunu `closedReason` üzerinden taşır.
  Object? _lostReason;

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

  /// Kapanış sebebi (varsa) — CliClient `closedReason` olarak taşır.
  Object? get lostReason => _lostReason;

  @override
  Future<void> sendLine(String line) async {
    if (_closed) {
      throw TransportClosedException(_lostReason ?? 'USB transport kapalı');
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
    } catch (e) {
      // Kapanamayan port COM kilidini sızdırır ve sonraki açılış "erişim
      // reddedildi" ile düşer — sessiz kalmamalı.
      debugPrint('[USB] closePort failed: $e');
    }
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
    final List<String> lines;
    try {
      lines = _buffer.feed(_utf8Sink.decode(bytes));
    } on PairingLineOverflow catch (e) {
      // İ-10: satır tavanı aşıldı — karşı uç NDJSON konuşmuyor (yanlış COM
      // portu / bootloader çıktısı). Sessizce büyümek yerine bağlantıyı
      // sebebiyle birlikte kes.
      debugPrint('[USB] $e — bağlantı kapatılıyor');
      if (!_incoming.isClosed) _incoming.addError(e);
      _lostReason = e;
      close();
      return;
    }
    for (var line in lines) {
      if (line.endsWith('\r')) {
        line = line.substring(0, line.length - 1);
      }
      if (line.isEmpty) continue;
      _incoming.add(line);
    }
  }

  /// Subclass kablo cekildi / cihaz reset edildi dedektör'ünden çağırır.
  /// Idempotent close + stream done propagasyonu. [reason] verilirse
  /// (unplug win32 kodu vb.) bekleyen isteklere ve `whenClosed`
  /// dinleyicilerine gerçek sebep taşınır — eskiden fiziksel çekilme de
  /// "temiz kapanış" gibi görünüyordu.
  void onTransportLost([Object? reason]) {
    if (_closed) return;
    if (reason != null) {
      _lostReason = reason;
      if (!_incoming.isClosed) _incoming.addError(reason);
    }
    close();
  }
}

/// Durumlu UTF-8 chunk çözücü: çok baytlı karakter chunk sınırında
/// bölünürse kalan baytları bir sonraki çağrıya taşır.
class _Utf8ChunkDecoder {
  final _out = StringBuffer();
  late final _sink = utf8.decoder.startChunkedConversion(
    _StringSink(_out),
  );

  String decode(List<int> bytes) {
    _sink.add(bytes);
    final s = _out.toString();
    _out.clear();
    return s;
  }
}

class _StringSink implements Sink<String> {
  _StringSink(this._buf);
  final StringBuffer _buf;

  @override
  void add(String data) => _buf.write(data);

  @override
  void close() {}
}
