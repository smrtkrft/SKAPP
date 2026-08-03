// Windows USB CLI transport · Win32 API'lerine direkt FFI ile bağlanır.
// `flutter_libserialport` paketinin AGP 8 uyumsuzluğunu fork etmek yerine
// `win32` paketi (Microsoft maintained, sadece-Windows native FFI bindings)
// ile çalışıyoruz. Mac/Linux Faz 2'de aynı yaklaşımla `dart:ffi` +
// POSIX termios eklenecek.
//
// API zinciri (her biri Win32):
//   1. CreateFileW(\\\\.\\COMx, GENERIC_READ|GENERIC_WRITE, ...)
//   2. SetCommState(handle, DCB{baud, 8N1})
//   3. SetCommTimeouts(handle, COMMTIMEOUTS{non-blocking read})
//   4. WriteFile(handle, bytes) — komut gönder
//   5. ReadFile(handle, buffer) — periyodik polling (Timer 30ms),
//      COMMTIMEOUTS sayesinde available byte yoksa hemen 0 döner
//   6. CloseHandle(handle) — kapatış
//
// Native plugin yok, paket bundle'ı +0 KB. Sadece Windows'ta kullanılır;
// usb_cli_transport.dart'taki `createUsbCliTransport` factory bunu
// Platform.isWindows'ta seçer.

import 'dart:async';
import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:win32/win32.dart';

import 'cli_transport.dart' show TransportClosedException;
import 'usb_cli_transport.dart';

/// Windows için seri port transport implementasyonu. CreateFile +
/// SetCommState ile portu açar, Timer.periodic ile ReadFile poll eder
/// (30ms aralıkla, COMMTIMEOUTS non-blocking ayarlı).
class WinSerialTransport extends UsbCliTransportBase {
  WinSerialTransport({required super.portInfo, super.baudRate});

  /// Win32 file handle. CreateFile başarılı olunca dolar.
  int _handle = INVALID_HANDLE_VALUE;

  /// Read polling timer'ı. 30 ms aralıkla ReadFile çağırır; COMMTIMEOUTS
  /// non-blocking ayarlı olduğundan data yoksa hemen 0 döner.
  Timer? _readTimer;

  /// Üst üste gelen ERROR_OPERATION_ABORTED sayacı (bkz. _pollRead).
  int _abortedTicks = 0;

  /// ReadFile için tahsis edilen okuma buffer'ı boyutu (tick başına).
  static const int _readBufferSize = 4096;

  /// DCB bit-packed bayrak dword'ü. Bit düzeni (LSB→MSB, Win32 DCB):
  /// 0 fBinary · 1 fParity · 2 fOutxCtsFlow · 3 fOutxDsrFlow ·
  /// 4-5 fDtrControl · 6 fDsrSensitivity · 7 fTXContinueOnXoff ·
  /// 8 fOutX · 9 fInX · 10 fErrorChar · 11 fNull · 12-13 fRtsControl ·
  /// 14 fAbortOnError.
  ///
  /// Değer = fBinary(1) yalnız: donanım/yazılım akış kontrolü KAPALI,
  /// fDtrControl=DTR_CONTROL_DISABLE, fRtsControl=RTS_CONTROL_DISABLE
  /// (ikisi de de-asserted → köprü çipli kartlarda auto-reset tetiklenmez).
  static const int kDcbFlags = 0x00000001;

  @override
  Future<void> openPort() async {
    if (!Platform.isWindows) {
      throw UnsupportedError('WinSerialTransport is Windows-only.');
    }

    // COM10+ portları için "\\\\.\\COMx" prefix'i gerek (COM1-9 prefix'siz
    // de çalışır ama prefix tutarlı, hep kullan).
    final portPath = r'\\.\' + portInfo.portPath;
    final pPortName = portPath.toNativeUtf16();
    try {
      _handle = CreateFile(
        pPortName,
        GENERIC_READ | GENERIC_WRITE,
        0, // share mode 0 = exclusive
        nullptr, // security attrs
        OPEN_EXISTING,
        0, // attrs (overlapped I/O kullanmıyoruz)
        NULL,
      );
    } finally {
      free(pPortName);
    }

    if (_handle == INVALID_HANDLE_VALUE) {
      final err = GetLastError();
      throw StateError(
        'CreateFile failed: ${portInfo.portPath} (win32 err=$err). '
        'Is the device plugged in, or has another application opened '
        'the port?',
      );
    }

    // DCB ayarla: baud rate, 8 data bits, no parity, 1 stop bit, binary mode.
    final dcb = calloc<DCB>();
    try {
      dcb.ref.DCBlength = sizeOf<DCB>();
      if (GetCommState(_handle, dcb) == 0) {
        final err = GetLastError();
        await _closeHandle();
        throw StateError('GetCommState failed (win32 err=$err)');
      }
      dcb.ref.BaudRate = baudRate;
      dcb.ref.ByteSize = 8;
      dcb.ref.Parity = 0; // NOPARITY
      dcb.ref.StopBits = 0; // ONESTOPBIT
      // Bit-packed bayrakları AÇIKÇA yaz. Eskiden GetCommState'in
      // döndürdüğü değer olduğu gibi bırakılıyordu ("paket setter
      // sunmuyor" — win32 5.15'te `bitfield` alanı doğrudan yazılabilir);
      // oysa DCB, sürücüde/önceki açan uygulamada ne kaldıysa onu yansıtır.
      // Miras alınan iki ayar CLI'yı tamamen bozabiliyordu:
      //   * fOutxCtsFlow=1 → CTS hiç gelmeyen bir CDC portunda her
      //     WriteFile 1 sn timeout'la 0 byte yazar → "WriteFile
      //     ilerlemiyor" ile TÜM komutlar düşer.
      //   * DTR/RTS asserted → CP2102/CH340/FTDI köprülü kartlarda
      //     auto-reset devresi çipi reset'te tutar → cihaz tamamen sessiz.
      // Bu yüzden: yalnız fBinary=1; akış kontrolü kapalı, DTR/RTS
      // de-asserted (native USB-Serial-JTAG bunları zaten umursamaz).
      dcb.ref.bitfield = kDcbFlags;
      if (SetCommState(_handle, dcb) == 0) {
        final err = GetLastError();
        await _closeHandle();
        throw StateError('SetCommState failed (win32 err=$err)');
      }
    } finally {
      free(dcb);
    }

    // Non-blocking read timeouts. ReadIntervalTimeout = MAXDWORD (0xFFFFFFFF)
    // ve ReadTotalTimeoutMultiplier = 0, ReadTotalTimeoutConstant = 0:
    // ReadFile available byte varsa onları döner, yoksa anında 0 döner.
    // Polling pattern için ideal.
    final timeouts = calloc<COMMTIMEOUTS>();
    try {
      timeouts.ref.ReadIntervalTimeout = 0xFFFFFFFF; // MAXDWORD
      timeouts.ref.ReadTotalTimeoutMultiplier = 0;
      timeouts.ref.ReadTotalTimeoutConstant = 0;
      timeouts.ref.WriteTotalTimeoutMultiplier = 0;
      timeouts.ref.WriteTotalTimeoutConstant = 1000; // 1 sn write timeout
      if (SetCommTimeouts(_handle, timeouts) == 0) {
        final err = GetLastError();
        await _closeHandle();
        throw StateError('SetCommTimeouts failed (win32 err=$err)');
      }
    } finally {
      free(timeouts);
    }

    // RX/TX buffer'ları temizle (önceki açılışta kalmış byte olabilir).
    if (PurgeComm(_handle, PURGE_RXCLEAR | PURGE_TXCLEAR) == 0) {
      // Purge başarısızsa önceki oturumdan kalan yarım satır ilk cevabın
      // başına yapışır ve ikisi birden tek bozuk satır olarak düşer.
      debugPrint('[win-serial] PurgeComm failed (win32 err=${GetLastError()})');
    }

    // Read polling timer'ı başlat. 30ms aralık: gözle algılanmaz latency
    // ama CPU tüketimi minimal (her tick'te sadece bir ReadFile çağrısı).
    _readTimer = Timer.periodic(
      const Duration(milliseconds: 30),
      (_) => _pollRead(),
    );
  }

  @override
  Future<void> writeBytes(List<int> bytes) async {
    if (_handle == INVALID_HANDLE_VALUE) {
      throw StateError('USB port is not open');
    }
    final buffer = calloc<Uint8>(bytes.length);
    final written = calloc<Uint32>();
    try {
      for (var i = 0; i < bytes.length; i++) {
        buffer[i] = bytes[i] & 0xFF;
      }
      // Drain the whole buffer. WriteFile can return a short count when the
      // 1 s write timeout fires mid-transfer (a long CLI line on a busy
      // USB-CDC endpoint). A silently truncated command reaches the firmware
      // as malformed NDJSON and the response wait then times out, so we loop
      // over the remainder and only give up (throw) when a write makes no
      // forward progress.
      var offset = 0;
      var stalls = 0;
      while (offset < bytes.length) {
        final ok = WriteFile(
          _handle,
          (buffer + offset).cast(),
          bytes.length - offset,
          written,
          nullptr,
        );
        if (ok == 0) {
          final err = GetLastError();
          throw StateError('WriteFile failed (win32 err=$err)');
        }
        final n = written.value;
        if (n <= 0) {
          if (++stalls >= 3) {
            throw StateError('WriteFile made no progress: '
                '$offset/${bytes.length} bytes written');
          }
          continue;
        }
        stalls = 0;
        offset += n;
      }
    } finally {
      free(buffer);
      free(written);
    }
  }

  @override
  Future<void> closePort() async {
    _readTimer?.cancel();
    _readTimer = null;
    await _closeHandle();
  }

  Future<void> _closeHandle() async {
    if (_handle == INVALID_HANDLE_VALUE) return;
    // CloseHandle hatayı DÖNÜŞ DEĞERİYLE bildirir (0), exception ile
    // değil — eski try/catch ölü koddu ve başarısız kapanış (sızan COM
    // kilidi → sonraki açılışta "erişim reddedildi") görünmez kalıyordu.
    if (CloseHandle(_handle) == 0) {
      debugPrint('[win-serial] CloseHandle failed (win32 err=${GetLastError()})'
          ' — the COM lock may have leaked');
    }
    _handle = INVALID_HANDLE_VALUE;
  }

  /// Timer her 30ms'de çağırır. Available byte'ları okuyup base'in
  /// `onChunk` line reassembly metoduna besler.
  void _pollRead() {
    if (_handle == INVALID_HANDLE_VALUE) return;
    final buffer = calloc<Uint8>(_readBufferSize);
    final read = calloc<Uint32>();
    try {
      final ok = ReadFile(
        _handle,
        buffer.cast(),
        _readBufferSize,
        read,
        nullptr,
      );
      if (ok == 0) {
        final err = GetLastError();
        // ERROR_OPERATION_ABORTED (995) normalde kendi kapanışımızda
        // görülür — ama closePort timer'ı CloseHandle'dan ÖNCE iptal
        // ettiği için bu tick'e hiç düşmemesi gerekir. Israrla geliyorsa
        // sürücü I/O'yu iptal etmiştir: sessizce yok saymak, portu sonsuza
        // dek "bağlı" gösterip her komutu 10 sn timeout'a düşürürdü.
        // Sayaçla tolere et, ısrar ederse kopuş say.
        if (err == 995 && ++_abortedTicks < 5) return;
        debugPrint('[win-serial] ReadFile failed (win32 err=$err)');
        onTransportLost(
          TransportClosedException('USB read error (win32 err=$err)'),
        );
        return;
      }
      _abortedTicks = 0;
      final n = read.value;
      if (n == 0) return; // available data yok, normal poll tick
      final chunk = Uint8List(n);
      for (var i = 0; i < n; i++) {
        chunk[i] = buffer[i];
      }
      onChunk(chunk);
    } finally {
      free(buffer);
      free(read);
    }
  }
}
