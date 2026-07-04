# Changelog

Tüm önemli değişiklikler bu dosyada tutulur. Biçim
[Keep a Changelog](https://keepachangelog.com/) temellidir; sürümleme
[SemVer](https://semver.org/) (`MAJOR.MINOR.PATCH`).

> `app/pubspec.yaml` **daima** `X.Y.Z+N` taşır. Her yayında build numarası
> (`+N`) **monoton artar** — Android `versionCode` ve yerinde güncelleme bunu
> gerektirir. "Beta"lık semver string'iyle değil, GitHub Release + uygulama
> içi `UpdateChannel` ile ifade edilir.

## [Unreleased]

## [0.4.4] - 2026-07-04

0.4.0 betasının üzerine gelen ikinci beta. Yeni cihaz ailesi (SynDimm), 9 dil
kapsaması ve eşleştirme/güvenlik sertleştirmeleri. Dağıtım ve imza durumu
0.4.0 ile aynı (ayrıntı için aşağıdaki Notes).

### Added
- **SynDimm (SD) cihaz desteği**: `SdPlugin`/`SdSession` + pano (270°
  `SdOrbitalDial` gösterge, olay-güdümlü `SdSafeCenter`) ve ayar hub'ı
  (modlar / profiller / kasa / tercihler / olaylar / loglar).
- SynDimm arayüzü **9 dilde** tam çeviri (en, tr, de, el, es, fr, it, pt, ru).

### Changed
- **Eşleştirme yeniden yazıldı** (request-driven, bootstrap-first): app proaktif
  ECDH yazar, cihazın notify ipucunu beklemez — macOS notify yarışından
  kaynaklı X25519 sessiz takılması giderildi. Cihaz bond'luysa reconnect'e
  devreder; reconnect'te `pairing.required → bootstrap` otomatik fallback.
- **BLE keşif filtresi varsayılan AÇIK** (yalnız SmartKraft cihazları listelenir).
- **Güvenlik sertleştirme**: tüm 9 secure-storage noktası tek `skSecureStorage`
  yardımcısına taşındı (Android `encryptedSharedPrefs`, iOS/macOS
  `ThisDeviceOnly`); release'te BLE log sızıntısı `kDebugMode` ile kapatıldı;
  SD `auth_key` alanı sertleştirildi; webhook nonce-ring 256 → 1024.

### Fixed
- macOS keychain `-34018` kaynaklı eşleştirme takılması + WiFi başarı anındaki
  çökme koruması.
- Masaüstünde OS keychain olmadan güvenli depolama — tekrar tekrar çıkan
  parola sorma istemleri giderildi.

### Notes
- İmza durumu 0.4.0 ile aynı: macOS ad-hoc, Windows imzasız, Android
  debug-imza (sideload). Notarization / kod imzalama 1.0'a ertelendi.

## [0.4.0] - 2026-06-28 — İlk Public Beta

İlk halka açık beta. macOS, Windows, Linux ve Android için GitHub Releases
üzerinden dağıtılır. Bu bir erken erişim sürümüdür: bazı özellikler eksik veya
kararsız olabilir — geri bildirimleri GitHub Issues'a bekliyoruz.

### Added
- Bulutsuz tanılama: global hata yakalama (zone + Flutter + platform),
  `<appSupport>/skapp_logs/skapp.log` döner log dosyası ve Ayarlar →
  Tanılama'dan "logları kopyala / klasörü aç / paylaş" eylemleri.
- Android release imzalama (kendi keystore) ile sideload edilebilir APK.
- Paketleme: macOS DMG, Windows kurulum (Inno Setup), Linux AppImage + `.deb`.
- Uygulama içi güncelleme denetimi (GitHub Releases tabanlı, stable/beta kanal).
- Etiket (tag) tetikli otomatik build + yayın (GitHub Actions).

### Notes
- iOS bu sürümde yok.
- macOS notarization ve Windows kod imzalama 1.0'a ertelendi; beta'da
  ad-hoc/imzasız dağıtım + bypass talimatı (release notlarında).
