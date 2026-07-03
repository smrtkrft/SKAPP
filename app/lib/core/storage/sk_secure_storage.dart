import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Tek noktadan sertleştirilmiş `flutter_secure_storage` örneği (İ-5).
///
/// Tüm cihaz-kontrol sırları (bond ECDH token'ları, per-peer token'lar, install
/// bearer, TLS özel anahtarı) bunu kullanır — böylece secure-storage seçenekleri
/// kod tabanında TUTARLI kalır ve ileride biri yanlışlıkla sertleştirilmemiş
/// `FlutterSecureStorage()` kullanamaz.
///
/// - **Android:** `encryptedSharedPreferences: true` → AES ile şifreli backend.
/// - **iOS/macOS:** `first_unlock_this_device` (ThisDeviceOnly) → keychain öğeleri
///   yedeğe girmez / başka cihaza GÖÇMEZ. Varsayılan `whenUnlocked` şifreli
///   yedekle başka cihaza restore edilip kurbanın cihazlarını sürebiliyordu.
const FlutterSecureStorage skSecureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  ),
);
