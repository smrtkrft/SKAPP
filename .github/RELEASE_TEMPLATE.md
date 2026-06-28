> ⚠️ **Public beta / erken erişim.** Bazı özellikler eksik veya kararsız
> olabilir. Geri bildirim ve hata bildirimi için
> [Issues](https://github.com/smrtkrft/SKAPP/issues) — uygulama içinden
> **Ayarlar → Tanılama → Logları paylaş/kopyala** ile log dosyanızı ekleyin.

## İndir

| Platform | Dosya |
|---|---|
| macOS | `SKAPP-macos.dmg` |
| Windows | `SKAPP-windows-setup.exe` |
| Linux (AppImage) | `SKAPP-linux-x86_64.AppImage` |
| Linux (Debian/Ubuntu) | `SKAPP-linux-amd64.deb` |
| Android | `SKAPP-android.apk` |

## Kurulum (beta yapıları imzasız/ad-hoc)

- **macOS:** DMG'yi aç → uygulamayı Applications'a sürükle. İlk açılışta
  **sağ-tık → Aç → Aç**. Takılırsa Terminal'de:
  `xattr -dr com.apple.quarantine /Applications/skapp.app`
- **Windows:** SmartScreen çıkarsa **Daha fazla bilgi → Yine de çalıştır**.
- **Linux (AppImage):**
  `chmod +x SKAPP-linux-x86_64.AppImage && ./SKAPP-linux-x86_64.AppImage`
- **Linux (.deb):** `sudo apt install ./SKAPP-linux-amd64.deb`
- **Android:** Tarayıcı/dosya yöneticisi için "bilinmeyen kaynaklardan
  kurulum"a izin ver, sonra APK'yı aç.

> iOS bu sürümde yoktur.

## Lisans / kaynak

SKAPP [AGPL v3](https://github.com/smrtkrft/SKAPP/blob/main/LICENSE). Bu
yayının karşılık gelen kaynak kodu, bu sürümün etiketlendiği (tag) commit'tir.
