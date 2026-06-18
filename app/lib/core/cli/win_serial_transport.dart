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

  /// ReadFile için reusable buffer (her tick yeniden tahsis etmemek için).
  static const int _readBufferSize = 4096;

  @override
  Future<void> openPort() async {
    if (!Platform.isWindows) {
      throw UnsupportedError('WinSerialTransport sadece Windows için.');
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
        'CreateFile başarısız: ${portInfo.portPath} (win32 err=$err). '
        'Cihaz takılı mı, başka bir uygulama portu açmış olabilir mi?',
      );
    }

    // DCB ayarla: baud rate, 8 data bits, no parity, 1 stop bit, binary mode.
    final dcb = calloc<DCB>();
    try {
      dcb.ref.DCBlength = sizeOf<DCB>();
      if (GetCommState(_handle, dcb) == 0) {
        final err = GetLastError();
        await _closeHandle();
        throw StateError('GetCommState başarısız (win32 err=$err)');
      }
      dcb.ref.BaudRate = baudRate;
      dcb.ref.ByteSize = 8;
      dcb.ref.Parity = 0; // NOPARITY
      dcb.ref.StopBits = 0; // ONESTOPBIT
      // DCB bit-packed flags (fBinary, fParity, fOutxCtsFlow, ...) win32
      // paketinin bu sürümünde direkt setter olarak expose edilmiyor;
      // GetCommState OS varsayılanlarını döndürdü (fBinary=1 dahil) ve
      // bunlar virtual COM (USB-CDC) için yeterli. Bit'lere dokunmuyoruz.
      if (SetCommState(_handle, dcb) == 0) {
        final err = GetLastError();
        await _closeHandle();
        throw StateError('SetCommState başarısız (win32 err=$err)');
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
        throw StateError('SetCommTimeouts başarısız (win32 err=$err)');
      }
    } finally {
      free(timeouts);
    }

    // RX/TX buffer'ları temizle (önceki açılışta kalmış byte olabilir).
    PurgeComm(_handle, PURGE_RXCLEAR | PURGE_TXCLEAR);

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
      throw StateError('USB port açık değil');
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
          throw StateError('WriteFile başarısız (win32 err=$err)');
        }
        final n = written.value;
        if (n <= 0) {
          if (++stalls >= 3) {
            throw StateError('WriteFile ilerlemiyor: '
                '$offset/${bytes.length} byte yazıldı');
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
    try {
      CloseHandle(_handle);
    } catch (_) {/* */}
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
        // ERROR_OPERATION_ABORTED (995): port kapatıldı, normal close
        // sırasında olur; sessiz geç. Diğer hatalar transport loss.
        if (err != 995) {
          debugPrint('[win-serial] ReadFile failed (win32 err=$err)');
          onTransportLost();
        }
        return;
      }
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
