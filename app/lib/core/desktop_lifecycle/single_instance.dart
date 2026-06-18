// Tek-instance koruma. İki katmanlı:
//   1. Windows: kernel-level named mutex (CreateMutexW + GetLastError).
//      Tek instance kararı için DEFINITIVE — Winsock SO_REUSEADDR
//      semantiği iki bind'in de başarılı olmasına izin verebiliyor
//      (gözlemlendi: 2026-05-14, iki SKAPP release exe aynı anda
//      port 47861'e bind etti). Mutex bu race'i kapatır.
//   2. Loopback TCP socket (127.0.0.1:47861): focus IPC kanalı —
//      ikinci instance kendi mutex check'ini geçemeyince varolan
//      instance'ın TCP listener'ına connect edip `FOCUS\n` yazıyor;
//      ilk instance pencereyi öne getiriyor.
//
// Mutex Process ömrü boyunca tutulur; Windows process bitince otomatik
// release eder, ayrı temizlik gerekmez. Mac/Linux'ta sadece TCP yolu
// (Faz 2'de pthread/fcntl flock benzeri ekleneceğine göre TCP fail-open).

import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;

// Win32 FFI binding'leri — DOĞRUDAN kernel32.dll'i aç. win32 paketinin
// fonksiyonlarını kullanmıyoruz çünkü:
//   1. CreateMutexW zaten 5.15.0'da export edilmiyor (manuel binding şart)
//   2. GetLastError için win32 paketinin export'unu kullanırsak, bizim
//      `CreateMutexW` (non-leaf) çağrımız sonrası safepoint/GC ile
//      LastError clobber oluyor; win32 paketinin GetLastError leaf-declared
//      olsa bile bizim önceki non-leaf çağrımız zaten state'i sıfırlamış oluyor
//
// ÇÖZÜM: tüm Win32 binding'lerimizi `isLeaf: true` ile declare et. Leaf
// FFI çağrıları Dart VM'den native'e geçişte safepoint koymaz, GC tetiklemez,
// dolayısıyla TLS LastError korunur. Dart docs explicit: "Leaf calls preserve
// GetLastError across the call". Aksi taktirde mutex check kanıtlanmış
// şekilde çalışmıyor (2026-05-14: iki SKAPP instance aynı anda açıldı).
final _kernel32 = Platform.isWindows
    ? DynamicLibrary.open('kernel32.dll')
    : null;

typedef _CreateMutexWNative = IntPtr Function(
  Pointer<Void> lpMutexAttributes,
  Int32 bInitialOwner,
  Pointer<Utf16> lpName,
);
typedef _CreateMutexWDart = int Function(
  Pointer<Void> lpMutexAttributes,
  int bInitialOwner,
  Pointer<Utf16> lpName,
);

typedef _GetLastErrorNative = Uint32 Function();
typedef _GetLastErrorDart = int Function();

typedef _CloseHandleNative = Int32 Function(IntPtr hObject);
typedef _CloseHandleDart = int Function(int hObject);

final _createMutexW = _kernel32?.lookupFunction<
    _CreateMutexWNative, _CreateMutexWDart>('CreateMutexW', isLeaf: true);

final _getLastError = _kernel32?.lookupFunction<
    _GetLastErrorNative, _GetLastErrorDart>('GetLastError', isLeaf: true);

final _closeHandle = _kernel32?.lookupFunction<
    _CloseHandleNative, _CloseHandleDart>('CloseHandle', isLeaf: true);

/// `ERROR_ALREADY_EXISTS` Win32 sabiti. winerror.h: 183.
const int _kErrorAlreadyExists = 183;

class SingleInstance {
  SingleInstance._();
  static final SingleInstance instance = SingleInstance._();

  /// Fixed loopback port — focus IPC için.
  static const int _kPort = 47861;

  /// Windows kernel mutex adı. `Local\` namespace user oturumuna özeldir;
  /// farklı kullanıcılar aynı makinede SKAPP'larını paralel çalıştırırlar.
  /// `Global\` istersek terminal services / fast-user-switching'i tek
  /// instance'a zorlardık — istenmiyor.
  static const String _kWindowsMutexName = r'Local\SmartKraft-SKAPP-SingleInstance-v1';

  /// Bind hatalarında errno kodlari (port-in-use).
  static const Set<int> _kAddressInUseErrnos = {
    10048, // Windows WSAEADDRINUSE
    98,    // Linux EADDRINUSE
    48,    // macOS EADDRINUSE
  };

  ServerSocket? _server;

  bool get supported {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Bind dener ve gerekirse mutex acquire eder.
  ///
  /// Windows: önce mutex; `ERROR_ALREADY_EXISTS` ise kesin ikinci instance.
  /// Mac/Linux: TCP bind ile karar.
  /// Her iki tarafta da TCP bind yan etkili olarak IPC server'ı kurar
  /// (ilk instance ise). TCP fail-open: ikinci instance kararı değişmez,
  /// sadece IPC kaybedilir.
  Future<bool> tryAcquire() async {
    if (!supported) return true;

    if (Platform.isWindows) {
      final mutexAcquired = _tryAcquireWindowsMutex();
      if (!mutexAcquired) {
        debugPrint('[single-instance] Windows mutex held → second instance');
        return false;
      }
    }

    try {
      _server = await ServerSocket.bind(
        InternetAddress.loopbackIPv4,
        _kPort,
      ).timeout(const Duration(seconds: 2));
      debugPrint('[single-instance] TCP listener up on 127.0.0.1:$_kPort');
      return true;
    } on SocketException catch (e) {
      final errCode = e.osError?.errorCode;
      if (errCode != null && _kAddressInUseErrnos.contains(errCode)) {
        if (Platform.isWindows) {
          // Mutex'i biz aldık ama port başkasındadır — orphan socket
          // (önceki instance crash etmiş, mutex temizlendi ama TCP socket
          // TIME_WAIT'te). IPC kaybı, ama ilk instance kararı geçerli.
          debugPrint('[single-instance] Windows: mutex OK ama port in use '
              '(orphan socket); IPC olmadan devam');
          return true;
        }
        return false;
      }
      debugPrint('[single-instance] bind failed unexpectedly: $e '
          '(errno=$errCode) → fail-open, no IPC');
      return true;
    } on TimeoutException {
      debugPrint('[single-instance] bind timed out > 2s → fail-open, no IPC');
      return true;
    } catch (e) {
      debugPrint('[single-instance] bind threw unexpected $e → fail-open');
      return true;
    }
  }

  /// Windows named mutex acquire. true = biz aldık (ilk instance),
  /// false = mutex zaten başkasında (ikinci instance). Mutex handle
  /// process ömrü boyunca açık kalır; OS process exit'te otomatik
  /// release eder.
  ///
  /// Tüm FFI çağrıları `isLeaf: true` ile declare edildi — Dart VM
  /// safepoint koymaz, GC tetiklemez, Win32 TLS LastError korunur.
  /// Aksi takdirde CreateMutexW sonrası LastError clobber olabilir
  /// ve mutex check fail eder (gözlemlenen bug 2026-05-14).
  bool _tryAcquireWindowsMutex() {
    final create = _createMutexW;
    final getErr = _getLastError;
    final closeH = _closeHandle;
    if (create == null || getErr == null || closeH == null) {
      // kernel32.dll resolve edilemedi (olmaması imkânsız ama gate'i
      // tut). Fail-open.
      debugPrint('[single-instance] kernel32 FFI lookup failed → fail-open');
      return true;
    }
    final namePtr = _kWindowsMutexName.toNativeUtf16();
    try {
      final handle = create(nullptr, 0 /* FALSE = bInitialOwner */, namePtr);
      // KRITIK: GetLastError IMMEDIATELY, leaf FFI sayesinde LastError
      // CreateMutexW'den sonra clobber olmadan korunur.
      final lastErr = getErr();
      if (handle == 0) {
        debugPrint('[single-instance] CreateMutexW returned NULL '
            '(win32 err=$lastErr) → fail-open');
        return true;
      }
      if (lastErr == _kErrorAlreadyExists) {
        // Mutex daha önce başka bir process tarafından oluşturulmuş;
        // bizim handle'ımız ona ATTACH oldu, sahiplenmedi. Handle'ı
        // kapatıyoruz (referans sayısı azalır) ve "ikinci instance"
        // sinyali veriyoruz.
        closeH(handle);
        return false;
      }
      // Biz oluşturduk → sahibiz. CloseHandle çağırmıyoruz; handle
      // process'in handle table'ında kalır, process exit'te Windows
      // otomatik close eder ve mutex object freed olur.
      return true;
    } finally {
      malloc.free(namePtr);
    }
  }

  /// Gelen TCP connection'ları focus signal sayar.
  void listenForFocus(void Function() onFocus) {
    final server = _server;
    if (server == null) return;
    server.listen(
      (client) async {
        debugPrint('[single-instance] focus request from peer');
        try {
          onFocus();
        } catch (e) {
          debugPrint('[single-instance] onFocus threw: $e');
        }
        try {
          await client.drain<void>();
        } catch (_) {/* */}
        try {
          await client.close();
        } catch (_) {/* */}
      },
      onError: (Object e) {
        debugPrint('[single-instance] server error: $e');
      },
    );
  }

  /// İkinci instance: varolan SKAPP'a focus sinyali gönder, exit(0).
  Future<Never> signalAndExit() async {
    try {
      final socket = await Socket.connect(
        InternetAddress.loopbackIPv4,
        _kPort,
        timeout: const Duration(milliseconds: 800),
      );
      socket.write('FOCUS\n');
      await socket.flush();
      await socket.close();
      debugPrint('[single-instance] focus signal sent, exiting');
    } catch (e) {
      debugPrint('[single-instance] failed to signal existing '
          'instance: $e — exiting anyway');
    }
    exit(0);
  }
}
