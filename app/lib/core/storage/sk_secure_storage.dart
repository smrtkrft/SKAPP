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
///
/// **macOS `useDataProtectionKeyChain: false` — KRİTİK.** Data-protection
/// keychain (varsayılan) iOS-tarzı çalışır ve `keychain-access-groups`
/// entitlement'ı + geçerli bir team-imzası ŞART koşar. Yerel/ad-hoc imzalı
/// (TeamIdentifier=not set) sandboxed masaüstü derlemesinde bu entitlement
/// olmadığından HER secure-storage yazması `errSecMissingEntitlement (-34018)`
/// ile patlıyordu → bond hiç kaydedilemiyordu → cihaz eşleşmesi ECDH yazımından
/// ÖNCE (bond_store.appPeerId) uncaught-zone crash ile ölüyordu (X25519'da
/// "çember dönme" sebebi buydu). Legacy dosya-tabanlı keychain entitlement
/// gerektirmez ve iCloud'a SENKRONLANMAZ — ThisDeviceOnly amacımızla birebir.
const FlutterSecureStorage skSecureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  ),
  mOptions: MacOsOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
    useDataProtectionKeyChain: false,
  ),
);
