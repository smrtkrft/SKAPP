# Changelog

Tüm önemli değişiklikler bu dosyada tutulur. Biçim
[Keep a Changelog](https://keepachangelog.com/) temellidir; sürümleme
[SemVer](https://semver.org/) (`MAJOR.MINOR.PATCH`).

> `app/pubspec.yaml` **daima** `X.Y.Z+N` taşır. Her yayında build numarası
> (`+N`) **monoton artar** — Android `versionCode` ve yerinde güncelleme bunu
> gerektirir. "Beta"lık semver string'iyle değil, GitHub Release + uygulama
> içi `UpdateChannel` ile ifade edilir.

## [Unreleased]

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
