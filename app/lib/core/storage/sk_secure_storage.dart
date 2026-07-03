import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

/// Tek noktadan sertleştirilmiş secure-storage cephesi (İ-5 + macOS düzeltmesi).
///
/// Tüm cihaz-kontrol sırları (bond ECDH token'ları, per-peer token'lar, install
/// bearer, TLS özel anahtarı) bunu kullanır — böylece backend seçimi kod
/// tabanında TEK yerde kalır ve kimse yanlışlıkla sertleştirilmemiş
/// `FlutterSecureStorage()` kullanamaz.
///
/// ## Neden platforma göre iki backend?
///
/// **Mobil (iOS/Android):** gerçek OS anahtar deposu (Keychain / Keystore) —
/// donanım destekli, `first_unlock_this_device` (ThisDeviceOnly, yedeğe girmez,
/// başka cihaza GÖÇMEZ). Burada sorunsuz çalışır.
///
/// **Masaüstü (macOS/Windows/Linux):** OS keychain'i KULLANMAYIZ. Sebep: bu
/// uygulama yerel/ad-hoc imzalı (Apple Developer team yok). macOS'ta iki keychain
/// türü de çıkmaz:
///   - Data-protection keychain → `keychain-access-groups` entitlement + team
///     imzası ŞART; yoksa her yazma `errSecMissingEntitlement (-34018)` ile
///     patlar (eşleşme donmasının asıl sebebi buydu).
///   - Legacy dosya keychain → entitlement gerekmez AMA ACL, kararsız ad-hoc
///     imzaya güvenmediği için HER erişimde kullanıcıdan bilgisayar şifresi ister.
///
/// Bunun yerine masaüstünde: uygulama sandbox'ının Application Support dizininde
/// **AES-GCM-256 ile şifrelenmiş tek dosya**. Şifreleme anahtarı cihaza-bağlı bir
/// tohumdan türetilir (macOS'ta `gethostuuid`, diğerlerinde container'da tutulan
/// kalıcı rastgele tohum) → dosya BAŞKA CİHAZDA çözülemez (ThisDeviceOnly amacı
/// korunur), OS keychain'e hiç dokunulmaz (şifre sorusu YOK, -34018 YOK).
abstract class SkSecureStore {
  Future<String?> read({required String key});
  Future<void> write({required String key, required String value});
  Future<void> delete({required String key});
  Future<Map<String, String>> readAll();
}

/// Platforma göre çözülen tekil örnek. Call-site'lar bunu `skSecureStorage`
/// olarak import eder (eski API yüzeyi: read/write/delete/readAll aynı).
final SkSecureStore skSecureStorage = _resolveStore();

SkSecureStore _resolveStore() {
  if (Platform.isIOS || Platform.isAndroid) return const _KeychainStore();
  return _EncryptedFileStore();
}

/// Mobil backend — gerçek OS anahtar deposu.
class _KeychainStore implements SkSecureStore {
  const _KeychainStore();

  static const FlutterSecureStorage _fss = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  @override
  Future<String?> read({required String key}) => _fss.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _fss.write(key: key, value: value);

  @override
  Future<void> delete({required String key}) => _fss.delete(key: key);

  @override
  Future<Map<String, String>> readAll() => _fss.readAll();
}

/// Masaüstü backend — cihaza-bağlı anahtarla AES-GCM şifreli tek dosya.
class _EncryptedFileStore implements SkSecureStore {
  _EncryptedFileStore();

  static const _fileName = 'sk_secure_store.enc';
  static const _seedFileName = '.sk_store_seed';

  final AesGcm _algo = AesGcm.with256bits();
  final _AsyncLock _lock = _AsyncLock();

  Map<String, String>? _cache;
  SecretKey? _key;

  Future<Directory> _dir() => getApplicationSupportDirectory();

  // ── Şifreleme anahtarı ──────────────────────────────────────────────

  Future<SecretKey> _deriveKey() async {
    if (_key != null) return _key!;
    final dir = await _dir();
    final seed = await _deviceSeed(dir);
    final hkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);
    _key = await hkdf.deriveKey(
      secretKey: SecretKey(seed),
      nonce: utf8.encode('skapp-secure-store-v1'), // salt
      info: utf8.encode('aead-key'),
    );
    return _key!;
  }

  /// Cihaza-bağlı tohum: macOS'ta donanım host UUID'i (`gethostuuid`, sandbox
  /// güvenli, keychain'e dokunmaz). Diğer platformlarda / FFI başarısızsa
  /// container içinde kalıcı rastgele 32-bayt tohum (yine ThisDeviceOnly —
  /// dosya başka cihaza taşınmaz).
  Future<Uint8List> _deviceSeed(Directory dir) async {
    if (Platform.isMacOS) {
      try {
        final id = _macHostUuid();
        if (id != null) return id;
      } catch (e) {
        debugPrint('[sk-store] gethostuuid başarısız, tohum dosyasına düşülüyor: $e');
      }
    }
    final f = File('${dir.path}/$_seedFileName');
    if (await f.exists()) {
      final b = await f.readAsBytes();
      if (b.length == 32) return Uint8List.fromList(b);
    }
    final rng = Random.secure();
    final fresh = Uint8List(32);
    for (var i = 0; i < 32; i++) {
      fresh[i] = rng.nextInt(256);
    }
    await f.writeAsBytes(fresh, flush: true);
    await _chmod600(f.path);
    return fresh;
  }

  Uint8List? _macHostUuid() {
    final lib = DynamicLibrary.process();
    final gethostuuid = lib.lookupFunction<
        Int32 Function(Pointer<Uint8>, Pointer<Void>),
        int Function(Pointer<Uint8>, Pointer<Void>)>('gethostuuid');
    final idPtr = calloc<Uint8>(16);
    final tsPtr = calloc<Uint8>(16); // timespec {0,0} → beklemeden döner
    try {
      final rc = gethostuuid(idPtr, tsPtr.cast());
      if (rc != 0) return null;
      final out = Uint8List(16);
      for (var i = 0; i < 16; i++) {
        out[i] = idPtr[i];
      }
      // Sıfır UUID (beklenmedik) → güvenilmez, fallback.
      if (out.every((b) => b == 0)) return null;
      return out;
    } finally {
      calloc.free(idPtr);
      calloc.free(tsPtr);
    }
  }

  // ── Dosya oku/yaz (şifreli) ─────────────────────────────────────────

  Future<Map<String, String>> _load() async {
    if (_cache != null) return _cache!;
    final dir = await _dir();
    final f = File('${dir.path}/$_fileName');
    if (!await f.exists()) {
      return _cache = <String, String>{};
    }
    try {
      final raw = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
      final nonce = base64Decode(raw['n'] as String);
      final cipher = base64Decode(raw['c'] as String);
      final mac = base64Decode(raw['m'] as String);
      final key = await _deriveKey();
      final clear = await _algo.decrypt(
        SecretBox(cipher, nonce: nonce, mac: Mac(mac)),
        secretKey: key,
      );
      final map = (jsonDecode(utf8.decode(clear)) as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, v as String));
      return _cache = map;
    } catch (e) {
      // Çözülemeyen / bozuk dosya (ör. tohum değişti, disk bozulması) →
      // temiz başla. Bond sıfırlama kullanıcı yetkisiyle serbest; sert
      // çökme yerine yeniden eşleşme çok daha iyi.
      debugPrint('[sk-store] okuma başarısız, depo sıfırlanıyor: $e');
      return _cache = <String, String>{};
    }
  }

  Future<void> _persist() async {
    final dir = await _dir();
    final f = File('${dir.path}/$_fileName');
    final key = await _deriveKey();
    final nonce = _algo.newNonce();
    final box = await _algo.encrypt(
      utf8.encode(jsonEncode(_cache ?? <String, String>{})),
      secretKey: key,
      nonce: nonce,
    );
    final payload = jsonEncode(<String, dynamic>{
      'v': 1,
      'n': base64Encode(box.nonce),
      'c': base64Encode(box.cipherText),
      'm': base64Encode(box.mac.bytes),
    });
    // Atomik yazım: geçici dosyaya yaz + rename (yarı-yazılmış dosya kalmasın).
    final tmp = File('${f.path}.tmp');
    await tmp.writeAsString(payload, flush: true);
    await tmp.rename(f.path);
    await _chmod600(f.path);
  }

  Future<void> _chmod600(String path) async {
    if (Platform.isWindows) return;
    try {
      await Process.run('chmod', ['600', path]);
    } catch (_) {/* best-effort */}
  }

  // ── Genel API (hepsi lock altında serileştirilir) ───────────────────

  @override
  Future<String?> read({required String key}) =>
      _lock.run(() async => (await _load())[key]);

  @override
  Future<void> write({required String key, required String value}) =>
      _lock.run(() async {
        (await _load())[key] = value;
        await _persist();
      });

  @override
  Future<void> delete({required String key}) => _lock.run(() async {
        (await _load()).remove(key);
        await _persist();
      });

  @override
  Future<Map<String, String>> readAll() =>
      _lock.run(() async => Map<String, String>.from(await _load()));
}

/// Basit async mutex — oku-değiştir-yaz döngülerini serileştirir ki eşzamanlı
/// write'lar dosyayı bozmasın.
class _AsyncLock {
  Future<void> _tail = Future<void>.value();

  Future<T> run<T>(Future<T> Function() action) {
    final completer = Completer<void>();
    final prev = _tail;
    _tail = completer.future;
    return prev.then((_) => action()).whenComplete(completer.complete);
  }
}
