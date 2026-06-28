<div align="center">

# SKAPP

**SmartKraft cihaz yapılandırma uygulaması** — BLE / WiFi üzerinden cihaz
eşleştirme, yönetim, OTA ve SKAPI script otomasyonu. %100 P2P: sunucu yok,
telemetri yok, hesap yok.

[![Latest release](https://img.shields.io/github/v/release/smrtkrft/SKAPP?include_prereleases&label=indir)](https://github.com/smrtkrft/SKAPP/releases/latest)
[![License: AGPL v3](https://img.shields.io/badge/license-AGPLv3-blue)](LICENSE)

</div>

> ⚠️ **Public beta / erken erişim.** Bazı özellikler eksik veya kararsız
> olabilir. Sorunları [Issues](https://github.com/smrtkrft/SKAPP/issues)
> üzerinden bildirin — uygulama içinden **Ayarlar → Tanılama → Logları
> paylaş/kopyala** ile log dosyanızı ekleyebilirsiniz.

## İndir

| Platform | Dosya |
|---|---|
| macOS | [`SKAPP-macos.dmg`](https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-macos.dmg) |
| Windows | [`SKAPP-windows-setup.exe`](https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-windows-setup.exe) |
| Linux (AppImage) | [`SKAPP-linux-x86_64.AppImage`](https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-linux-x86_64.AppImage) |
| Linux (Debian/Ubuntu) | [`SKAPP-linux-amd64.deb`](https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-linux-amd64.deb) |
| Android | [`SKAPP-android.apk`](https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-android.apk) |

> iOS bu sürümde yok. Beta yapıları imzasız/ad-hoc olduğu için ilk açılışta
> işletim sistemi uyarı gösterebilir — kurulum talimatları her release notunda.

## Kurulum notları (beta)

- **macOS:** DMG'yi aç, uygulamayı Applications'a sürükle. İlk açılışta
  sağ-tık → **Aç** → **Aç**. Takılırsa: `xattr -dr com.apple.quarantine /Applications/skapp.app`
- **Windows:** SmartScreen çıkarsa **Daha fazla bilgi → Yine de çalıştır**.
- **Linux (AppImage):** `chmod +x SKAPP-linux-x86_64.AppImage && ./SKAPP-linux-x86_64.AppImage`
- **Android:** Tarayıcı/dosya yöneticisi için "bilinmeyen kaynaklardan kurulum"a
  izin ver, sonra APK'yı aç.

## Lisans

[GNU AGPL v3](LICENSE). Her yayının karşılık gelen kaynak kodu, aynı git
etiketindeki (tag) commit'tir.
