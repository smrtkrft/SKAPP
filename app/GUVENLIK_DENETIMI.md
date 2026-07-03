# SKAPP — Güvenlik Denetimi

> **Kapsam:** `app/lib` (+ `android/`). Denetim: sır saklama, HTTP listener +
> webhook HMAC, TLS/sertifika, ECDH/HMAC transport, cihaz ekranları (SD dahil),
> loglama, Android intent'leri.
>
> **Durum (2026-07-03):** Güvenli, bozmayan, doğrulanabilir düzeltmeler
> UYGULANDI (`flutter analyze` temiz, test paketi regresyonsuz). Bozucu-göç
> riski taşıyan veya mimari yeniden-tasarım gerektiren maddeler, kararı size
> ait olduğu için UYGULANMADI — aşağıda gerekçesiyle listelenir.

---

## Uygulanan düzeltmeler (güvenli + doğrulandı)

| # | Alan | Dosya | Değişiklik |
|---|---|---|---|
| F-1 | Loglama | `core/cli/ble_transport.dart:61-64,192-195` | BLE trace'i `debugPrint` yalnız `kDebugMode`'da; release'te ham cevap-satırı önizlemesi yerine yalnız uzunluk. Cihaz cevap parçalarının (auth_key başlangıcı vb.) release logcat/console'a düşmesi engellendi. In-app pairing trace stream'i (kullanıcının kendi cihazı, geçici) korundu. |
| F-2 | SD ekranı | `features/devices/sd/sd_modes_screen.dart:639-647` | `auth_key` alanına `enableSuggestions:false` + `autocorrect:false` eklendi (safe-dizi alanıyla tutarlı; klavye önbelleği/öneri geçmişine sızmayı azaltır). Alan zaten `obscureText`'ti. |
| F-3 | Replay | `core/network/webhook_receiver.dart:63-68` | Nonce dedup ring 256→1024. Timestamp penceresi (60 sn) içinde gelebilecek istek sayısı 256'yı aşarsa hâlâ-geçerli bir nonce evict edilip zarf replay edilebiliyordu; 1024 tüm bağlı peer'lar için geniş marj bırakır (sınırlı). |

**Doğrulama:** `flutter analyze` → temiz; `flutter test` → 114 geçti (tek kırık
`widget_test.dart` boot testi bu değişikliklerden BAĞIMSIZ; SD entegrasyonundan
da önce kırıktı, teyit edildi).

---

## Ertelenen bulgular (kararı size ait — otonom oturumda UYGULANMADI)

Bunlar gerçek bulgular; ancak ya mevcut kullanıcıların eşleşmelerini/bond'larını
bozar, ya mimari yeniden-tasarımdır, ya da bir UX/ürün kararıdır. Uyurken tek
taraflı uygulamak "destructive/outward-facing" sınıfına girdiğinden yapılmadı.

### Y-1 · TLS pin bypass: pinlenmiş parmak-izi yoksa HERHANGİ sertifika kabul (Yüksek)
- **Dosya:** `core/network/skapp_http_client.dart:64-68`, `:539-545` —
  `badCertificateCallback`, `expectedFingerprintHex == null` iken `return true`.
- **İstismar:** "Faz B adım 4" öncesi eşleşen (null parmak-izli) legacy peer'lar
  için mobil, `https://ip:port`'a HERHANGİ sertifikayı kabul eder. LAN'da aktif
  MITM (ARP spoof) kendi self-signed sertifikasını sunar → kabul. `redeemPairing`
  için minted `peerToken` cevap gövdesinde sızar.
- **Neden ertelendi:** `null` → reddet yapmak, mevcut legacy peer'ların
  bağlantısını **yeniden-eşleşene kadar bozar**. Ayarlar zaten "yeniden eşleş"
  öneriyor. Bu bir migrasyon/UX kararı.
- **Öneri:** Legacy peer'lar için bir sürüm sonra pinlemeyi zorunlu kıl;
  ara dönemde bu durumu kullanıcıya görünür uyarı olarak göster.

### Y-2 · CLI kanalı HMAC-imzalı ama ŞİFRESİZ — sırlar LAN'da düz metin (Yüksek)
- **Dosya:** `core/cli/cli_signer.dart:37-51` (zarf: düz `body` + truncated
  `sig`), `core/cli/tcp_transport.dart:51` (`Socket.connect`, TLS yok).
- **İstismar:** Aynı WiFi'deki pasif dinleyici/ARP-spoof, TCP üzerinden
  yapılandırılan safe **dizisini**, hedef **auth_key**'ini ve **WiFi parolasını**
  (`wifi.connect`) düz metin okur — SD "dizi sırdır" modelini doğrudan çürütür.
  (Kod bunu kabul ediyor: `sd_modes_screen.dart` "cihaza şifresiz gider".)
- **Neden ertelendi:** Çözüm mimari bir eklentidir — zarf yükünü hem uygulamada
  hem firmware sk_core'da simetrik şifrelemek (ECDH ortak sırdan türetilen
  anahtarla ChaCha20/AES). Çapraz-aile, firmware-eşli, donanımsız test edilemez.
- **Öneri (en yüksek mimari öncelik):** CLI zarfına payload şifrelemesi ekle
  (imza + şifre); ya da tüm CLI kanalını cihaz-pinli TLS'e taşı. Firmware
  `GUVENLIK_DENETIMI.md` ile eşgüdümlü yapılmalı.

### Y-3 · Düz-HTTP ikiz listener 0.0.0.0'da tüm pipeline'ı sunar (Orta)
- **Dosya:** `core/network/skapp_http_server.dart:149-161` — `id.port+1`'de
  düz-HTTP, aynı pipeline (`/api/pair/redeem` dahil `peerToken` gövdede).
- **Neden ertelendi:** Listener davranışını değiştirmek (düz-HTTP'yi kaldırmak
  veya localhost'a bağlamak) mevcut peer keşif/redeem akışlarını bozabilir;
  BF/mobil-peer tasarımıyla bağlaşık. Ürün kararı.
- **Öneri:** Düz-HTTP ikizini yalnız `/api/health` gibi hassas-olmayan uçlarla
  sınırla; pair/redeem ve authed rotaları yalnız TLS'te sun.

### Y-4 · Bazı secure-storage örnekleri sertleştirilmemiş seçeneklerle (Orta)
- **Dosya:** `core/cli/bond_store.dart:32`, `core/network/self_signed_cert.dart:99,137`,
  `core/network/peer_tokens_provider.dart:86,255` — `FlutterSecureStorage()`
  seçeneksiz; oysa `core/cli/token_store.dart:9-12` doğru sertleştirilmiş
  (`encryptedSharedPreferences:true` + iOS accessibility).
- **İyi haber:** Bond token / TLS anahtarı / peer token'lar ZATEN
  `flutter_secure_storage`'da (Keychain/Keystore) — düz prefs/dosya DEĞİL.
  En kötü senaryo (düz-metin token) GEÇERSİZ.
- **Kalan risk:** iOS varsayılan accessibility yedeğe dahil → şifreli yedek
  başka cihaza restore edilirse bond token + TLS anahtarı göç eder.
- **Neden ertelendi:** Android'de `encryptedSharedPreferences:true`'ya geçiş
  mevcut düz-backend değerlerini **okunamaz yapar** → tüm kullanıcılar
  yeniden-eşleşmek zorunda kalır (bozucu göç). iOS accessibility'yi
  `ThisDeviceOnly`'ye çevirmek ise yeni-telefon-yedekten-geçiş davranışını
  değiştirir (UX/ürün kararı).
- **Öneri:** Bir sürümde tüm secure-storage örneklerini `TokenStore` ile aynı
  seçeneklere getir + bir kerelik migrasyon (eski anahtarları oku→yeni
  backend'e yaz→sil); iOS'ta `first_unlock_this_device`.

### Bilgi düzeyi (aksiyon opsiyonel)
- **B-1 · `/api/health` kimlik-doğrulamasız `developerModeEnabled` sızdırır**
  (`skapp_http_server.dart:298-309`). LAN keşfi. **Ama** işlevsel amacı var
  (peer picker'da "geliştirici modu kapalı" rozeti, sürpriz 403'ü önler) ve
  uzak çalıştırma zaten geçerli per-peer HMAC token ister. Kaldırmak rozeti
  bozar → ertelendi. İstenirse `developerModeEnabled`'ı yalnız kimlikli uca taşı.
- **B-2 · `X-SK-Peer-Id` header'ı parse edilir ama `BondStore.peerIdFor` ile
  doğrulanmaz** (`webhook_receiver.dart:83,89`) — dekoratif; imzalı mesaja dahil
  değil. Bilgi.
- **B-3 · Bond arama case-fold varyantlarını dener** (`device_id.dart:25-29`) —
  token kapısı hâlâ tutar; yalnız-case-farklı iki id teorik çakışması. Bilgi.

---

## Temiz doğrulandı

- **Webhook HMAC doğru:** sabit-zaman karşılaştırma, timestamp bond aramadan
  ÖNCE, token doğrulanmış deviceId ile keyed, kanonik mesaj uzunluk-prefiksli,
  nonce dedup yalnız imza geçtikten sonra; gövde boyutu auth-öncesi sınırlı.
  Bond token olmadan sahtelenemez.
- **Sırlar `flutter_secure_storage`'da**, düz prefs/Hive/dosya değil;
  SharedPreferences yalnız metadata tutar (token değil).
- **IDOR yok:** deviceId başka bond'a erişemez (HMAC o bond'un token'ıyla
  doğrulanmalı). **eval/dinamik-dispatch yok** wire verisinde. **Özel URL
  scheme / VIEW deep-link yok** (yalnız MAIN/LAUNCHER + VID/PID-filtreli USB).
- **OTA:** GitHub Releases `https://api.github.com` (public-CA doğrulamalı,
  bypass yok); indirme harici `launchUrl` — in-app APK kurulumu yok.
- **SD ekranları:** safe dizisi `obscureText`+suggestions/autocorrect kapalı,
  kaydettikten sonra temizlenir; auth_key `obscureText` (+F-2 ile sertleştirildi);
  hiçbir sır loglanmaz.

**Değerlendirme:** Uygulama güvenlik temeli sağlam (secure storage, doğru
webhook HMAC, IDOR/injection/deep-link yüzeyi yok). İki Yüksek bulgu (Y-1 TLS
pin bypass, Y-2 şifresiz CLI kanalı) gerçek ve önemli ama çözümleri
migrasyon/mimari kararlar; firmware `GUVENLIK_DENETIMI.md` ile eşgüdümlü
planlanmalı. Otonom oturumda yalnız güvenli/bozmayan alt küme (F-1..F-3)
uygulandı ve doğrulandı.
