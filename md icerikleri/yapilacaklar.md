SKAPP Yapilacaklar




### 9- ota update sistemi x2 idf ve app ayri ayri.
- APP-ici self-updater (manifest + GitHub Releases) ilk dis tester / field-test oncesine kadar ERTELENDI.
- Test fazinda ADB Wi-Fi yeterli (tools/run/wifi_*_android.bat). Ayrintilar memory: project_dev_install_strategy.md


### 11- cihaz log kayitlari cihazda son 20 adet olmali , 
app baglantisinda app bu son loglari almali , kendi hafizasinda app icinde depolamali, her baglantida son loglar güncellenmeli

> **Durum (kismen):** [bf_logs_screen.dart](app/lib/features/devices/bf/bf_logs_screen.dart) `logs.get` ile cihazdan log cekip gosteriyor. **Eksik:** otomatik snapshot her baglantida + SharedPreferences persistence + tarihsel karsilastirma yok.


### 17- cihaza ek kullanici sifresi konulacak

farkli laptop ve telefonlarda baglanti kuruldugunda kullanicinin olusturdugu sifre istenecek , pin kodu gibi , böylece birinin cihazina yabanci biri skapp uygulamasi ile erisemeyecek

> **Durum (kismen):** Pairing'de passphrase gate var ([passphrase_gate.dart](app/lib/features/devices/bf/passphrase_gate.dart) + [bf_passphrase_screen.dart](app/lib/features/devices/bf/bf_passphrase_screen.dart)). Saha testi sonrasi kalibrasyon gerekiyor; multi-bond + slot listesi henuz tam degil (memory: project_pending_phases.md #2).


### 19- TAM I18N TAMAMLAMA + COKLU DIL EKLEME (en son yapilacak)

**Sira:** uygulama Mac/Linux/iOS dahil tüm sürümleri tamamlandiktan, hersey hazir olduktan SONRA.

**~~19a — Hardcoded stringleri ARB'a tasi (on kosul):~~ TAMAMLANDI 2026-05-26**

LS feature + wifi_scan'deki ~330 hardcoded string (EN + TR) ARB'a tasindi. ARB anahtar sayisi 1369 → 1598 (EN/TR sync ✓). Etkilenen 13 dosya:
- ls_home_screen.dart, ls_theme_tokens.dart (state.label kaldirildi, _stateLabel helper'a tasindi)
- 11 LS section dosyasi (vacation, duration, smtp, reminder_mail, reset_api, alarm_api, relay, telegram, ls_api, mail_groups, _ls_section_kit)
- wifi_scan_screen.dart:405 "Tekrar dene" → l.commonRetry

Plural format (ICU) ve placeholder'lar kullanildi (gun/saat/dakika, alici sayisi, port, slot adi). Tarih formati intl DateFormat'a tasindi (ls_section_vacation). Em-dash'ler kaldirildi (proje feedback'i geregi). Win debug + release + Android debug + release build clean.

**19b ve sonrasi (de/es/it/fr/ru/el) yine en son fazda yapilacak.**

**19b — hedef diller:**
1. English (kaynak/template)
2. Türkçe (zaten var)
3. Almanca (de)
4. Ispanyolca (es)
5. Italyanca (it)
6. Fransizca (fr)
7. Rusca (ru)
8. Yunanca (el)

Her dil icin: `app/lib/l10n/app_<kod>.arb` olustur, key'leri çevir, `flutter gen-l10n`, `MaterialApp.supportedLocales`'a `Locale('<kod>')` ekle. Pubspec'te `flutter_localizations` zaten var.

**19c — surec onerisi:**
- Once tüm key'ler MT ile ilk pass (DeepL/GPT) — hizli, otomatik
- Sonra her dil icin native speaker review (UI bag­lami olmadan ceviri kalitesiz olur)
- Plural/placeholder formati her dilde kontrol (Rusca/Yunanca'da plural farkli)

**19d — runtime dil secimi:**
Settings'teki "Dil" karti zaten alt sayfa açıyor; supportedLocales ne uzarsa otomatik orda görünür. Kod degisikligi gerekmez.

**Mimari guvencesi:** Flutter gen-l10n altyapisi key bazli; yeni dil eklemek için *kod yazılmaz*, sadece çeviri dosyası eklenir.



### 21- Linux // sudo apt install skapp

**Amaç:** SKAPP'i Debian/Ubuntu/Pi OS kullanıcılarının `sudo apt install skapp` ile kurması, sonraki sürümler `sudo apt update` ile otomatik gelmesi. Web sitede ek olarak AppImage indirme butonu (apt kullanmayan veya hızlı denemek isteyen kullanıcılar için).

**Hedef kapsam:**
- Mimari: amd64 (Intel/AMD masaüstü) + arm64 (Pi 4/5, modern ARM laptop, ARM server)
- Distro: Ubuntu 22.04+, Debian 12+, Linux Mint 21+, Pop!_OS 22.04+, Raspberry Pi OS Bookworm+
- AppImage paralel: glibc 2.28+ tüm modern Linux

**Faz 1 — Linux build artefakt'ı (.deb paket)**

1. Linux desktop bağımlılıklarını ekle: `pubspec.yaml`'da değişiklik yok, sistem paketleri runtime gereksinimi:
   - `libgtk-3-0`, `libglib2.0-0`, `libsecret-1-0` (flutter_secure_storage ileride), `libwebkit2gtk-4.1-0` (varsa), `libayatana-appindicator3-1`
   - `Depends:` field'ında `.deb` control dosyasında listelenir
2. `.desktop` dosyası: `linux/skapp.desktop`
   ```
   [Desktop Entry]
   Type=Application
   Name=SKAPP
   Comment=SmartKraft device configuration
   Exec=/usr/bin/skapp
   Icon=skapp
   Categories=Utility;Network;
   Terminal=false
   ```
3. PNG ikonlar (mevcut `app/assets/branding/logo_black.png`'den çoklu boyut üret): 16/32/48/64/128/256 → `linux/icons/hicolor/<N>x<N>/apps/skapp.png`
4. `linux/DEBIAN/control` template (CI'da version inject edilir):
   ```
   Package: skapp
   Version: 0.1.0-1
   Section: utils
   Priority: optional
   Architecture: amd64
   Maintainer: SmartKraft <code@smartkraft.ch>
   Depends: libgtk-3-0, libglib2.0-0, libsecret-1-0
   Homepage: https://smartkraft.ch
   Description: SmartKraft device configuration GUI
    SKAPP is the desktop / mobile companion to SmartKraft IoT devices.
    Provides BLE/WiFi pairing, configuration, SKAPI script library
    and remote-trigger listener.
   ```
5. Build script (`tools/build/linux_deb.sh`):
   - `flutter build linux --release` → `build/linux/x64/release/bundle/`
   - `mkdir -p .pkgroot/usr/{bin,share/{applications,icons,skapp}}` 
   - bundle'ı `.pkgroot/usr/share/skapp/` altına kopyala
   - `/usr/bin/skapp` symlink'i `/usr/share/skapp/skapp` binary'sine
   - `.desktop` dosyasını `/usr/share/applications/`'a, ikonları `/usr/share/icons/hicolor/.../apps/`'a
   - `dpkg-deb --build .pkgroot skapp_0.1.0-1_amd64.deb`
6. arm64 için: `flutter build linux --release` cross-compile yapamaz → CI matrix'te ayrı runner gerekir (GitHub Actions `ubuntu-22.04-arm` ücretsiz public repo'da mevcut)

**Faz 2 — GPG keypair (paket imzalama)**

1. Sunucuda (veya güvenli kişisel makinede): `gpg --full-generate-key`
   - RSA 4096
   - Email: `code@smartkraft.ch`
   - Expiration: 2 yıl (yenilenecek)
2. Public key export: `gpg --armor --export <KEY_ID> > skapp.gpg`
3. Private key güvenli yedek (offline disk + parola yöneticisi)
4. CI için: GitHub Secrets'a `GPG_PRIVATE_KEY` ekle (CI bunu import edip imzalama yapacak)

**Faz 3 — APT repository (reprepro)**

1. Ubuntu/Debian sunucuda (veya statik hosting'i tetikleyen build runner'da): `apt install reprepro`
2. Repo dizini: `/var/www/apt/`
3. `/var/www/apt/conf/distributions`:
   ```
   Origin: SmartKraft
   Label: SKAPP
   Codename: stable
   Architectures: amd64 arm64
   Components: main
   SignWith: <KEY_ID>
   Description: SKAPP APT repository
   ```
4. `/var/www/apt/conf/options`:
   ```
   verbose
   basedir /var/www/apt
   ```
5. Paketleri ekle: `reprepro -b /var/www/apt includedeb stable skapp_0.1.0-1_amd64.deb`
6. `dists/stable/InRelease` ve `Release.gpg` otomatik üretilir
7. `pool/main/s/skapp/` altında `.deb` dosyası yer alır

**Faz 4 — Statik web hosting**

1. **Tercih edilen seçenek (kolay, ücretsiz):** Cloudflare Pages veya GitHub Pages
   - Repo'da `apt/` klasörü, push → otomatik deploy
   - HTTPS otomatik (Cloudflare ücretsiz cert)
2. **Alternatif:** Kendi VPS (Hetzner, DigitalOcean, vb.) + Nginx + Let's Encrypt
3. URL pattern: `https://smartkraft.ch/apt/...`
4. Bandwidth: bir `.deb` ~30-50 MB; 1000 indirme = 30-50 GB ay (Cloudflare ücretsiz tier yeterli)
5. Pages varsa cache: `Cache-Control: public, max-age=300` (5 dk; yeni sürüm 5 dk içinde dağıtılır)

**Faz 5 — Tek-satır install scripti**

1. Web sitede `https://smartkraft.ch/install-skapp.sh`:
   ```bash
   #!/usr/bin/env bash
   set -euo pipefail
   echo "[SKAPP] GPG key kuruluyor..."
   curl -fsSL https://smartkraft.ch/apt/skapp.gpg | \
     sudo gpg --dearmor -o /usr/share/keyrings/skapp.gpg
   echo "[SKAPP] APT repository kayıt ediliyor..."
   echo "deb [signed-by=/usr/share/keyrings/skapp.gpg] https://smartkraft.ch/apt stable main" | \
     sudo tee /etc/apt/sources.list.d/skapp.list >/dev/null
   echo "[SKAPP] Paket listesi güncelleniyor..."
   sudo apt update
   echo "[SKAPP] SKAPP yükleniyor..."
   sudo apt install -y skapp
   echo "[SKAPP] Hazır. Menüden açabilir veya 'skapp' komutunu çalıştırabilirsin."
   ```
2. Kullanıcı tek satır komutu kopyalar:
   ```bash
   curl -fsSL https://smartkraft.ch/install-skapp.sh | sudo bash
   ```
3. Web sitede "Linux için kur" sayfasında bu komut + manuel adımlar (script'e güvenmeyenler için)

**Faz 6 — CI/CD otomasyonu (GitHub Actions)**

1. `.github/workflows/release.yml`:
   - Trigger: tag push (`v*`)
   - Matrix: `[ubuntu-22.04, ubuntu-22.04-arm]`
   - Steps:
     - Flutter setup
     - `flutter pub get`
     - `flutter build linux --release`
     - `tools/build/linux_deb.sh <arch>` → `.deb` üret
     - GPG private key import (Secrets'tan)
     - reprepro container ile `.deb`'i repo'ya ekle
     - rsync ile repo'yu Cloudflare Pages branch'a / VPS'e push
2. Tek tag push → 5-10 dk sonra her iki mimari için yeni sürüm `apt update`'te görünür

**Faz 7 — Web sitede dağıtım sayfası**

1. `/download/linux` URL'i
2. İçerik:
   - "Tek satır kur (Debian/Ubuntu/Pi)" → `curl ... | sudo bash` komutu
   - "Manuel kurulum (script'e güvenmiyorsan)" → 4 adım copy-paste
   - "AppImage indir" → `skapp-0.1.0-x86_64.AppImage` direkt link
   - "Diğer dağıtımlar (Arch/Fedora)" → AppImage öner, gelecekte Snap/Flathub eklenecek
3. Distro detection JavaScript ile (User-Agent veya `/etc/os-release` browser'dan okunamaz, ama platform.os "Linux" ise default Linux sekme)

**Faz 8 — Test ve doğrulama**

1. Temiz Docker container: `docker run -it ubuntu:22.04 bash`
   - `apt install -y curl gnupg` (script'in gerektirdiği)
   - Tek-satır install komutunu çalıştır
   - `skapp --version` ile doğrula (CLI flag eklenecek mi? Şimdilik GUI-only, çalışıyor mu görsel doğrula)
2. Pi 4 üzerinde Pi OS Bookworm: aynı script
3. Auto-update senaryosu:
   - Eski sürüm kurulu → yeni `.deb` repo'ya push → `apt update && apt list --upgradable` listeliyor mu?
   - `sudo apt upgrade` → yeni sürüm geliyor, kullanıcı verisi (~/.local/share/skapp/) korundu mu?
4. Uninstall: `sudo apt remove skapp` clean kalkıyor mu? `sudo apt purge skapp` kullanıcı verisini silecek mi (purge = config temizler ama user data ~/.config'de kalır, doğru davranış)

**Faz 9 — Versionlama disiplini**

1. SemVer: `MAJOR.MINOR.PATCH` (örn. `0.1.0`)
2. Debian package version: `<upstream>-<debian>` (örn. `0.1.0-1`)
   - `0.1.0-1` ilk paket
   - Hata düzeltme paketleme değişikliğinde `0.1.0-2` (kod değişmedi, sadece paket meta'sı)
3. `debian/changelog` dosyası — her sürüm girişi (Debian standardı, repo'da `dch` aracıyla yönetilir)
4. APT'de upgrade kuralı: yeni version > eski version → otomatik upgrade önerilir

**Faz 10 — Yan plan (paralel olarak yapılabilir)**

1. **AppImage build:**
   - `appimagetool` ile `flutter build linux --release` çıktısını `.AppImage` dosyası olarak paketle
   - Web sitede direkt indirme linki
2. **Snap Store** (yaygınlaştırmak istenirse):
   - `snapcraft.yaml` yaz, `snapcraft` komutu ile build
   - Snap Store'a publish (ücretsiz, otomatik kanal management)
3. **Flathub** (uzak vade):
   - `org.smartkraft.SKAPP.yml` manifest yaz
   - Flathub PR aç (community review süreci, haftalar)

**Toplam efor tahmini:**

| Faz | Tahmini | Bağımlılık |
|---|---|---|
| 1 (build pipeline) | 1 gün | flutter linux yapısı hazır |
| 2 (GPG) | 1 saat | hesap yönetimi |
| 3 (reprepro) | 0.5-1 gün | Linux sunucu erişimi |
| 4 (hosting) | 0.5 gün | Cloudflare hesabı veya VPS |
| 5 (install script) | 0.5 saat | trivial |
| 6 (CI/CD) | 1 gün | GitHub Actions yaml + secrets |
| 7 (web sayfa) | 0.5 gün | mevcut site CMS'e bağlı |
| 8 (test) | 0.5 gün | Docker + Pi |
| 9 (versionlama) | sürekli | her release |
| 10 (AppImage) | 0.5 gün | apt'ten bağımsız |

**Toplam: ~4-5 gün ilk kurulum + sürekli release maintenance.**

**Sıralama notu:** Diğer Linux paket sistemleri (Snap, Flathub, AUR, RPM) ileride ele alınır. AUR community tarafından maintain edilir, biz yapmasak da çıkar. Snap/Flathub ekstra kapsam ama maintenance maliyeti var, ilk dış tester'dan sonra düşünülür.


### 22- DESKTOP TRAY + ZORUNLU AUTOSTART (Win/Mac/Linux)

Windows Faz 1 implement edildi (`tray_lifecycle.dart` + `single_instance.dart`). Aşağıdaki 2 açık nokta kaldı (macOS + Linux Faz 2); diğer nokta kapatıldı veya stale-olduğu için kaldırıldı 2026-05-26.

**Detay memory:** project_desktop_tray_background.md

**Açık noktalar:**

1. ~~**İlk kapatmada bir kerelik bilgi toast'u**~~ — _Implement edildi 2026-05-26._ `DesktopLifecycle.firstHideEvents` stream + `tray_first_hide_seen` SharedPreferences flag + 3.5sn delayed hide. MainShell stream'i dinleyip `trayFirstHideToast` SnackBar render eder (EN + TR ARB).

2. **macOS Faz 2** — menu bar konvansiyonu (sağ üst), dock icon opsiyonel gizleme. `desktopLifecycleSupported` gate'i hazır; `_setupTray` ve `_setupAutostart` macOS path'leri test edilmeli. LaunchAgent plist yazımı `launch_at_startup` paketinin macOS desteğiyle.

3. **Linux Faz 2** — `libayatana-appindicator3-1` dependency `.deb control` dosyasına eklenmeli (Madde 21 ile koordine). XDG Autostart spec'ine göre `~/.config/autostart/skapp.desktop` yazımı. `Factory Reset` cascade'inde unregisterAutostart Linux path'i de gerekiyor (şu an Windows-only).

_Kaldırıldı 2026-05-26:_
- "Pro mod göstergesi" — kavram artık yok, sadece `developerModeProvider` var. Tray menüsünde Developer mode göstergesi için somut gereksinim yok; debug için Settings ekranı zaten erişilebilir.
- "Tray icon monokrom vs marka rengi" — marka rengi `tray.ico` kullanılıyor, Win 11 overflow paneline atması monokrom ile düzelmez (Shell_NotifyIcon API kısıtı, OS davranışı). Karar fiilen "marka rengi"; ayrı asset üretme gereği yok.


### 23- HARDENING 35 DAKİKALIK PAKET (şimdi yapılır, public push öncesi)

**Karar (2026-05-16):** SKAPP henüz yayına hazır değil ama 3 hardening adımı **şimdi yapılır**: zaman alıyorlar (özellikle GPG yedekleme) ve acele halde hata yapılır. Detaylı talimat ve adım-adım komutlar `hardening_kullanici_aksiyonlari.md` dosyasında; bu madde sadece yapılacak listesi + niye şimdi yapıldığı.

**Neden şimdi:**
- GPG anahtar üretim + parola yöneticisi + iki fiziksel yedek disiplini ilk seferde yarım saat ister; SKAPP yayını gününde stresle yapılmamalı
- 2FA aktivasyonu GitHub hesabını koruyor, SKAPP'le bağımsız her durumda yapılmalı
- Calendar reminder GPG expiry (2 yıl sonra) için, unutulursa anahtar bittiği gün apt repo kırılır

**3 adım (toplam 35 dk):**

#### A · GitHub + e-posta 2FA (SMS, 5 dk)

GitHub hesabı tek failure point. Sızarsa saldırgan repo'na malicious code commit edebilir.

- [x] A1: github.com/settings/security → 2FA → SMS veya Authenticator app
- [x] A2: Aynı şekilde e-posta hesabında (code@smartkraft.ch) 2FA aktif
- [x] Recovery codes parola yöneticisinde
- Sonra: SKAPP kitleselleşince YubiKey 5 (~30 USD) ile yükseltilir; SIM swap saldırılarına karşı bağışık

#### B · GPG keypair (30 dk)

Linux APT imzasız repo'yu reddeder. SKAPP `.deb` paketleri GPG ile imzalanacak.

- [ ] B1: PowerShell'de `scoop install gpg` veya `winget install GnuPG.Gpg4win`
- [ ] B2: `gpg --full-generate-key` (RSA 4096, 2y, code@smartkraft.ch, güçlü parola)
- [ ] B3: `gpg --list-secret-keys --keyid-format=long` ile KEY_ID al, parola yöneticisine kaydet
- [ ] B4: `gpg --armor --output skapp.gpg --export <KEY_ID>` (public key, web sitende yayınlanacak)
- [ ] B5: `gpg --armor --output skapp-private-BACKUP.gpg --export-secret-keys <KEY_ID>` → şifreli USB + iki fiziksel konumda yedek, asla cloud sync
- [ ] B6: `gpg --output skapp-revoke.gpg --gen-revoke <KEY_ID>` (kayıp senaryosu için iptal sertifikası)

**Önemli:** PowerShell `>` operatörü UTF-16 BOM yazıp armored çıktıyı bozar; GPG'nin kendi `--output` flag'ini kullan.

#### H · Calendar reminder (1 dk)

- [ ] H1: Google Calendar / takvimine "2028-05-16 GPG anahtarı yenile, 2 ay önceden hatırlat" event ekle
- [ ] H2: Aynı takvime "yıllık güvenlik gözden geçirme, güvenlik.md oku"

**Sonra (SKAPP yayına yaklaşırken):**
- C (DNS) + D (hosting onay): Faz 4 (CI scaffold) sırasında
- G1-G4 (push + repo settings): public/private karar verilince
- E (Apple Developer $99/yıl): macOS hedef olunca ertelendi
- F (Windows code signing): kullanıcı feedback'i sonrası ertelendi

Detay komutlar ve "ne için yapılıyor" açıklamaları için `hardening_kullanici_aksiyonlari.md`'ye bak.


### 24- SKAPI ON-DEVICE API TRIGGERS · "Yeni Aksiyon" akışı (Yapı 2)  · ✓ İMPLEMENTASYON TAMAM 2026-05-20

> **Durum (2026-05-20):** S2.1 → S2.8 statik doğrulamalar tamam. `dart analyze` temiz, Win release + Android release build temiz, EN/TR ARB 1428 anahtar sync.
> **Manuel entegrasyon testi bekliyor** (cihaz + transport gerektirir): plan'daki S2.8 ikinci kontrol listesi (8 senaryo) kullanıcı tarafından doğrulanacak.
> **Bilinen UX dar boğazı:** S2.6 implementation Local script binding'i olan cihazlarda iki alt-başlık gösteriyor; yalnız on-device API'si olan cihaz Aksiyonlarım'da gözükmüyor (BF dashboard'undan yönetilir). Tam paired-device iterate refactor sonraya bırakıldı.



**Bağlam:** SKAPI sekmesinde iki ayrı yapı yan yana yaşayacak.

- **Yapı 1 · Local scripts (mevcut, kalır):** Win/Mac/Linux platformlarındaki hazır scriptler. BF event → SKAPP webhook → desktop'ta PowerShell/bash çalışır. Veri: `bindingsProvider` (local store) + `system_endpoint_sync_service`.
- **Yapı 2 · On-device API triggers (bu plan):** `other` platformu. Kullanıcı bir HTTP endpoint tanımlar, BF firmware'in 5 USER slot'una (`sk_api`) yazılır. Geri sayım bitince **cihaz kendisi** fire eder, SKAPP devre dışı.

**Mevcut hazırlık (kod kontrolü 2026-05-20):**
- BF firmware: `SK_API_USER_SLOTS=5` ([sk_api.h:51](esp32/BF/components/sk_api/include/sk_api.h#L51)) ✓
- CLI komutları: `api.endpoint.add/remove/list`, `api.send`, `api.chain.run` ([sk_api.c:1461-1598](esp32/BF/components/sk_api/src/sk_api.c#L1461)) ✓
- Tetik: tek `timer.expired`, geri sayım bitince zincir fire eder ([bf_timer_engine.c:271](esp32/BF/components/bf_timer_engine/src/bf_timer_engine.c#L271)) ✓
- Editör altyapısı: [bf_api_chain_screen.dart](app/lib/features/devices/bf/bf_api_chain_screen.dart) çalışıyor (refactor + relocate edilecek)
- Other klasörü: boş ([_platform.json](app/assets/skapi/other/_platform.json) groups:[])

**Kararlar (2026-05-20 konuşması):**

| # | Konu | Karar |
|---|---|---|
| 1 | Endpoint storage | **Live** · SKAPP cache tutmaz, her açılışta cihazdan `api.endpoint.list` çekilir. Source of truth = cihaz. |
| 2 | Per-slot enable toggle | **Yok** · sil = devre dışı. Firmware'e `enabled` alanı eklenmez. |
| 3 | Şablon yapısı | **Tek slot** · bir `ApiTemplateManifest` = bir endpoint prefill. Zincir şablonu yok. |
| 4 | Manifest tipi | **Yeni `ApiTemplateManifest`** (mevcut `ScriptManifest` korunur, union yok). |
| 5 | Cihaz offline davranışı | **Pill her zaman aktif** ama seçilen cihaz offline ise alt SnackBar "{cihaz} çevrimdışı, çevrim içine al" gösterilir, editör açılmaz. _Plan'ın ilk hali "form açılır, Kaydet'te snackbar" idi ama `BfSession.pushForDevice` route gate'i bağlanamayan cihazda tam ekran hata kusuyordu; revize 2026-05-26._ |
| 6 | Other alt-platform yapısı | **Alt-platform** (lx pattern'i): `other-syndimm`, `other-lebensspur`, `other-blockingfocus`, `other-iot`, `other-server`. |
| 7 | `delay_after_sec` UI | **Accordion "Gelişmiş ayarlar"** altında gizli, default 0. |
| 8 | Aksiyonlarım listesi | Cihaz grubu içinde iki alt-başlık: **"Local scripts"** (Yapı 1) + **"On-device API"** (Yapı 2 live). |
| 9 | Editör konumu | `bf_api_chain_screen` → **`OnDeviceApiEditorScreen`** (refactor + `features/skapi/`). BF dashboard ve SKAPI pill aynı ekranı açar. |

**Tetik:** BF'de tek tetik, sabit · `timer.expired` (geri sayım bitti). UI'da readonly info chip. _İleride farklı cihazlarda farklı tetikler olabilir; cihaz-kapasite descriptor genişler._

#### Faz adımları

**S2.1 · Other alt-platform skeleton** (~15 dk)

5 yeni klasör, her birinde boş `_platform.json`:
- `app/assets/skapi/other-syndimm/_platform.json`
- `app/assets/skapi/other-lebensspur/_platform.json`
- `app/assets/skapi/other-blockingfocus/_platform.json`
- `app/assets/skapi/other-iot/_platform.json`
- `app/assets/skapi/other-server/_platform.json`

Her biri: `{ schemaVersion: 1, platform: "other-<id>", runtime: "iot-api", groups: [] }`.

Mevcut `other/_platform.json` → "Other" landing alt-platform listesi (lx pattern'i; SKAPI → Other tıklayınca 5 kart). Boş `groups` "yakında" placeholder gösterir. İçerikler sonra doldurulur.

**S2.2 · `ApiTemplateManifest` veri tipi** (~30 dk)

Yeni: `app/lib/features/skapi/data/api_template_manifest.dart`
- Alanlar: `id`, `platform`, `i18nTitle`, `i18nSummary`, `targetDeviceType` (`bf` başlangıçta), `defaults: { type, urlTemplate, method, auth, headerName?, contentType?, payloadTemplate?, delayAfterSec }`, optional `params` (kullanıcının doldurması gereken alanlar, örn IFTTT key).
- Loader (`skapi_catalog.dart`): JSON `kind: "api"` ise `ApiTemplateManifest`, yoksa mevcut `ScriptManifest`. Geriye dönük uyumlu.
- `i18n_lookup`: yeni tipin başlık/özet anahtarlarını çözer.

**S2.3 · `OnDeviceApiEditorScreen` refactor** (~1-1.5 saat, en riskli adım)

`bf_api_chain_screen.dart` → `features/skapi/on_device_api_editor_screen.dart`.
- Sınıf adı: `OnDeviceApiEditorScreen`.
- Constructor: `{ required PairedDevice targetDevice, ApiTemplateManifest? prefillTemplate, sk_api_endpoint? editing }`.
- `editing != null` → düzenleme modu, "Sil" butonu görünür.
- `prefillTemplate != null && editing == null` → şablondan sıfırdan.
- Statik `_DeviceApiCapability`: `bf` için `{ slotCount: 5, allowedTypes, allowedAuth }`. İleride başka cihazlar.
- Form: name, type (segmented), url, method (dropdown), auth (dropdown + token/header_name conditional), content_type, payload (Generic için TextArea).
- **Accordion "Gelişmiş ayarlar"** → `delay_after_sec` slider 0-300, default 0.
- Tetik info chip readonly: "Tetik: geri sayım bitti (sabit)".
- Kaydet: cihaz online → `api.endpoint.add` (sendCritical) → pop. Cihaz offline (CLI client null) → snackbar.
- BF dashboard'undaki giriş noktası route güncelle (eski path import → yeni path).

**S2.4 · SKAPI "+ Yeni Aksiyon" pill akışı** (~45 dk)

[skapi_screen.dart:62](app/lib/features/skapi/skapi_screen.dart#L62) `onAdd: () => _showComingSoon(...)` yerine:
1. `pairedDevicesProvider` sorgula, `targetDeviceType` (şimdilik `bf`) filtresi uygula.
2. **0 cihaz:** centered dialog "önce cihaz eşle" → DevicesScreen route.
3. **1 cihaz:** direkt `OnDeviceApiEditorScreen(targetDevice: only)`.
4. **2+ cihaz:** bottom sheet cihaz picker → seçim → editöre push.

`_ActionsEmpty` "Oluştur" CTA (`_showComingSoon`) aynı akışa bağlanır.

**S2.5 · Other şablon detay → "Cihaza yükle" CTA** (~30 dk)

Yeni `SkapiApiTemplateDetailScreen` (Other şablonları için ayrı detay ekranı; Win/Mac/Lx detayları `SkapiScriptDetailScreen` olarak değişmez).
- "Bağla" butonu YOK (Yapı 1'e özgü).
- Yerine **"Cihaza yükle"** (mustard CTA): tap → cihaz picker (S2.4 ile aynı) → `OnDeviceApiEditorScreen(targetDevice, prefillTemplate: this)`.

**S2.6 · Aksiyonlarım: cihaz grubu içinde iki alt-başlık** (~1 saat)

`_DeviceActionGroup` body:
- İki bölüm: **"Local scripts"** (mevcut `_ActionRow`, boşsa gizli) + **"On-device API"** (yeni `_OnDeviceApiList`, boşsa gizli). Her ikisi boşsa mevcut "boş grup" görünümü.
- `_OnDeviceApiList`: `onDeviceApiEndpointsProvider.family<PairedDevice>` (yeni). `api.endpoint.list` cihazdan çeker, USER bucket filtresi, SYSTEM gizli.
- Satır: name + type badge + url kısaltma + tap → editör (düzenleme). "Sil" düzenleme ekranında (swipe-delete listede risk).
- Cihaz offline: alt-başlık altında "cihaz çevrimdışı" mesajı (cached liste yok, live kararı).
- Live refresh: sayfa focus + 30 sn polling (BF dashboard polling pattern'i).

Master switch (`sk_api.on/off`) burada gösterilmez; BF cihaz ekranındaki API chain kontrolünde zaten var.

**S2.7 · i18n anahtarları** (~20 dk)

EN + TR ARB (placeholder, sonradan diğer diller faz 19'da):
- `skapiNewActionPickDeviceTitle`, `skapiNewActionNoDevicesTitle/Body/Cta`
- `skapiOnDeviceApiSubheading`, `skapiLocalScriptsSubheading`
- `skapiApiEditorTitle`, `skapiApiEditorAdvancedSection`, `skapiApiEditorDelayAfterLabel/Hint`
- `skapiApiTriggerFixedInfo` ("Tetik: geri sayım bitti")
- `skapiApiSaveOfflineSnack`, `skapiApiTemplateUploadCta`
- `skapiOnDeviceApiEmpty`, `skapiOnDeviceApiDeviceOffline`

`flutter gen-l10n` regenerate.

**S2.8 · 2x kontrol + release build** (~1 saat, memory `feedback_phase_double_check.md`)

**İlk kontrol · kod:**
- `dart analyze` temiz
- `flutter test` temiz
- `flutter build windows --release` temiz
- `flutter build apk --release` temiz

**İkinci kontrol · entegrasyon (manuel):**
1. Pill → 0 cihaz → "cihaz eşle" CTA görünür
2. Pill → 1 BF online → editör → sıfırdan endpoint kaydet → BF'de `api endpoint list` ile doğrula
3. Pill → BF offline (BLE kapalı + USB yok) → editör açılır → Kaydet → snackbar görünür
4. Other → SynDimm → boş placeholder doğrula
5. Geçici test template ekle (örn `other-syndimm/test.json`) → detay → "Cihaza yükle" → editör prefill ile açılır → kaydet → BF'de doğrula
6. Aksiyonlarım'da yeni endpoint görünür (live polling), düzenle ekranına gider
7. Editör → Sil → `api endpoint list` ile doğrula (silinmiş)
8. BF dashboard'undaki "API chain" giriş noktası hala çalışıyor (refactor route fix)
9. Edge: 5 slot dolu iken yeni eklemeye çalış → firmware reddetmeli, snackbar "slot dolu"

#### Sıralama ve commit noktaları

S2.1 → S2.2 → **commit 1** (skeleton + data type, no UI değişiklik) → S2.3 → **commit 2** (refactor, BF dashboard hala çalışır, SKAPI pill hala snackbar) → S2.4 → S2.5 → S2.6 → **commit 3** (UI tamamlandı) → S2.7 → S2.8 → **commit 4** (faz tamamlandı, GF-10/11 çizilir).

**Tahmini toplam:** 5-6 saat (test ve i18n dahil). En riskli S2.3 (refactor + route fix); en zaman alıcı S2.6 (live polling provider).

**Bu plan tamamlanınca yapılacaklar:**
- GF-10 ve GF-11 (SKAPI sekmesi "+ Yeni Aksiyon" + "Oluştur" snackbar'ları) `~~çizilir~~`
- Memory: `project_skapi_on_device_api.md` yazılır (Yapı 1 / Yapı 2 ayrımı + alt-platform yapısı + endpoint storage live kararı).


---


### 25- LebensSpur (LS) cihaz entegrasyonu

**Faz 1 ve Faz 2 (2.0 → 2.10) TAMAMLANDI 2026-05-20.** Cihaz USB CLI + BLE + WiFi üzerinden tek başına çalışıyor; SKAPP'tan eşleştirilebilir, LsHomeScreen yeni neumorphic tasarım + 10 collapsible section ile production-ready.

#### Tamamlandı

- **Faz 1.0-1.6** (firmware): timer + relay + smtp + mail_groups + reset_api 5 component + protocol/v1 sözleşmesi + ts_unix replay fix + SMTPS cert bundle hardening + JSON escape.
- **Faz 1.7** (CLI overhaul): space-separated dispatch (`timer set`), positional + keyword args (no `--flag`), per-command `help_block`, summary inline parameter hints, `sk_cli_fmt_duration` (s/m/h/d), up/down arrow history, ANSI sequence parser.
- **Faz 2.0** (pairing entegrasyonu): 5 LS component factory-reset subscriber (eski sahibin SMTP key + mail recipients + reset_api shared key + relay GPIO sızıntısı düzeldi), sk_event_bus capacity 32→64, sk_passphrase PBKDF2 5000→600 iter + raw vTaskDelay (IDLE-WDT panik fix). SKAPP tarafında `device_home_screen.dart` `case 'LS'` + `LsHomeScreen` shell.
- **Faz 2.1-2.6** (LS dashboard): Yeni neumorphic tasarım (`ls_gui_design2.html` referans) Flutter'a aktarıldı. `ls_home_screen.dart` 3 cluster (CONFIGURATION / TRIGGER ACTIONS / EARLY WARNING) + hero countdown ring. 10 collapsible section: Duration, Vacation, SMTP, Reset API, Mail Groups, Relay, LS API, Telegram, Reminder Mail, Alarm API. Her section kendi CLI bindings + statusText callback. sk_core duplications (logs/info/OTA/factory-reset/passphrase/pairing/bonds/WiFi) LS dashboard'dan kaldırıldı.
- **Faz 2.7** (CLI/event contract uyum kontrolü): `timer.restart/.cancel/.vacation.set` (yok) → `timer.start/.reset/.stop/vacation.set` ve `data['remaining']` → `data['remaining_sec']` 6 mismatch düzeldi. Eski Info/Logs ayrı ekranları silindi (sk_core üzerinden generic akış).
- **Faz 2.8** (LS branding): `DeviceTypeVisual` helper (`lib/core/ble/device_type_visual.dart`) — `iconFor(prefix)` + `friendlyName(prefix)` tek noktada. Pairing wizard hero icon prefix'e göre (LS: hourglass_bottom_rounded) + altında "LebensSpur" caption. Discovery tile subtitle'da brand adı ("BF · Blocking Focus"). `PairedDevice.typeFullName` da bu helper'a delege.
- **Faz 2.9** (UI tutarlılık): LS feature'da hardcoded TR string yok (audit clean) — sections day-one English. `ls_theme_tokens.dart` legacy ölü kod (`LsCards`/`LsTypography`/`LsButtons`/`LsStatusColors`/`LsRadius`) silindi; sadece kullanılan `LsSpacing` + `LsTimerStateKind` kaldı. Tüm LS sections `isDark` ternary ile light + dark tema güvenli.
- **Faz 2.10** (closeout): `flutter analyze` (full project) clean; Win release build temiz (`build\windows\x64\runner\Release\skapp.exe`); Android release build temiz.

#### Bekleyen / Karar Gerekli (Faz 2 dışı, ilerideki iyileştirmeler)

- **Mini firmware patch**: `timer.alarm` → `sk_api_chain_run` subscriber (Early Warning auto-fire için). Şu an SKAPP-tarafı `alarm_api` SharedPreferences sidecar üzerinden config edilebiliyor ama firmware otomatik trigger etmiyor.
- **SMTP atomic save firmware komutu**: Şu an SMTP section 4 ayrı setter (host/port/sender/key) sequential gönderiyor; biri başarısız olursa partial state kalır. Firmware'a `smtp.save {host,port,sender,key}` atomic komut eklenmesi (`commands.json` v1.1).
- **Mail Groups triple-nested expansion UX**: 10 grup × her birinde recipient listesi × subject/body editor → tek seferde sadece bir grup açık olsun mu, accordion yerine modal mı? Kullanıcı feedback'i bekleniyor.
- **PCB pin map kesinleşmesi** — button GPIO 9 + relay GPIO 19 şu an default; LS rev-A PCB üretildiğinde main.c'de güncellenir.
- **sk_core `device.info` eksik alanları** — chip/cores/cpu_freq/flash_size/heap stats/reset_reason yok. Audit ajanı raporladı.
- **sk_core `logs.get` hook DISABLED** — şu an boş döner. NimBLE ECDH stack baskısı yüzünden kapalı (kod yorumunda TODO).
- **sk_core multi-bond test** — 8 slot capacity var ama 2+ SKAPP install ile test edilmedi.
- **OTA manifest URL boş** — sk_ota runtime'da disabled. smartkraft.ch hosting kararı verilince doldur (memory: project_ota_plan.md).
- **WiFi scan fix flash bekliyor**: `esp32/ls/sk_core/src/sk_wifi.c` pre-flight disconnect + sticky pin fix yapıldı, build clean; COM10 monitor açık olduğu için flash beklemede.

#### Detay plan

- `LS_FAZ2_PLAN.md` (SKAPP root) — orijinal 10 alt-faz plan referansı (arşiv)
- Memory: `project_ls_faz1_decisions.md` (Faz 1 kapsam + 2.0 closeout)
- Memory: `project_ls_faz2_plan.md` (Faz 2 plan referansı)
- Memory: `project_ls_migration_doc.md` (genel dönüşüm)
- Memory: `feedback_lebensspur_freeze.md` (eski `esp32/LebensSpur/` dondurulmuş)

#### Kullanım

LS dashboard production-ready. Sonraki adımlar bekleyen liste içinden seçilir; öncelik kullanıcıya. "Mini firmware patch" + WiFi flash en kritik açık iş; rev-A PCB üretildiğinde pin map ile birlikte tekrar firmware turuna girilir.


---


## GELIŞTIRME FAZLARI — şu an UI'da görünür ama içeriği boş, "yakında" uyarısıyla sonraya bırakılan yerler

Aşağıdaki yerler **kullanıcının ekranında görünüyor** (tab, kart, satır, buton). Tıklandığında ya `disabled` durumunda hiçbir şey olmuyor ya `_comingSoon()` snackbar'ı gösteriyor ya da `comingSoonBadge` rozetiyle işaretli. Sonraki fazlarda **gerçek içerikleri** yazılacak.

> Listeye yeni bir madde eklemeden önce kontrol et: yer hâlâ "yakında" mı yoksa içerik aktive edildi mi? Aktif olanın üzerini çiz, dosyada kalsın (referans).

### A. Sekme seviyesinde (alt nav + dashboard sticky)

| # | Yer | Konum | UI davranışı | Eksik içerik |
|---|---|---|---|---|
| ~~GF-1~~ | ~~**SmartKraft sekmesi**~~ | _Implement edildi (Home tab şu an aktif)_ | _HomeScreen brand watermark + canlı cihaz/binding sayaçları + responsive adaptif layout_ | _Ekosistem hub fikri (marka manifestosu, cihaz kataloğu, maker showcase, topluluk linkleri) ileride büyütme aşaması olarak ele alınabilir, ayrı plan_ |
| GF-2 | **Notlar sekmesi** | [main_shell.dart:113-118](app/lib/features/main_shell/main_shell.dart#L113-L118) + [home_screen.dart:218-224](app/lib/features/home/home_screen.dart#L218-L224) | `disabled: true` rozet "yakında", tap snackbar | Kullanıcı notları: cihaz başına ya da bağımsız markdown notlar (örn. cihaz kurulum geçmişi, özel ayar açıklamaları, diagnostic copy-paste'leri) |

### B. Settings sayfası

| # | Yer | Konum | UI davranışı | Eksik içerik |
|---|---|---|---|---|
| ~~GF-3~~ | ~~**Node name** (This Node section)~~ | _Implement edildi_ | _Settings _NavCard tap → promptNetworkIdentityName dialog → networkIdentityProvider.setName(). Tam wired._ | _Makine kullanıcı adı override planı varsa ayrı bir iş; mDNS instance adı zaten edit edilebiliyor._ |
| ~~GF-4~~ | ~~**Diagnostic**~~ | _Settings'ten kaldırıldı 2026-05-13_ | _Card + section + ARB anahtarları silindi_ | Geri eklenecek özellik: crash log + recent error timeline + "logları üreticiye gönder" butonu + cihaz logu indir. Asıl içerik yazılırken Settings'e yeni `_NavCard` ekle |
| ~~GF-5~~ | ~~**Data**~~ | _Settings'ten kaldırıldı 2026-05-13 (v0.2 kapsam dışı, app fazla büyüdü)_ | _Card + section + ARB anahtarları silindi_ | Geri eklenecek özellik: yedek/dışa aktar/içe aktar (paired device + override scriptler + bindings + ayarlar JSON, bulut yok). Asıl içerik yazılırken yeni `_NavCard` Settings'e eklenir |
| ~~GF-6~~ | ~~**Reset pairings**~~ | _Implement edildi 2026-05-13_ | _ResetService.resetPairings cascade akışı: paired + bonds + peer_tokens + skapp_peers + bindings sil. Identity/settings/theme/notes korunur. Confirm dialog sayılı, summary dialog uyarılarla._ | _ResetService cascade: cihaz NVS'i sıfırlanmaz (zero-trust, dialog metninde belirtildi)_ |
| ~~GF-7~~ | ~~**Factory reset**~~ | _Implement edildi 2026-05-13_ | _ResetService.factoryReset: Reset Pairings + identity reset + TLS clear + autostart unregister (Windows registry win32_registry) + secure storage cleanup + SharedPreferences.clear + SKAPI overrides. Type-to-confirm dialog (SIL/ERASE). Restart butonu summary'de._ | _Plan: ~/.claude/plans/reset.md_ |
| GF-8 | **Update channel cycling** | [settings_screen.dart:139-147](app/lib/features/settings/settings_screen.dart#L139-L147) | Cycle çalışıyor (stable/beta) ama hiçbir yere etkisi yok | Update channel state OTA backend'e bağlanmalı; auto-check + check updates butonu da bu kanalı dinleyecek |
| GF-9 | **Check updates butonu** | [settings_screen.dart:158-162](app/lib/features/settings/settings_screen.dart#L158-L162) | Tap → snackbar "OTA service not wired yet" | App-içi self-updater (manifest + GitHub Releases) — ilk dış tester öncesine kadar ERTELENDI (memory: project_dev_install_strategy.md) |

### C. SKAPI sayfası

| # | Yer | Konum | UI davranışı | Eksik içerik |
|---|---|---|---|---|
| ~~GF-10~~ | ~~**+ Yeni Aksiyon** (header pill)~~ | _Implement edildi 2026-05-20 (Madde 24)_ | _Cihaz picker → OnDeviceApiEditorScreen ile Yapı 2 endpoint editörüne push. 0 cihaz → "önce eşle" dialog → Cihazlarım tab._ | _Manuel entegrasyon testi bekliyor_ |
| ~~GF-11~~ | ~~**Aksiyonlar empty CTA** ("Oluştur")~~ | _Implement edildi 2026-05-20 (Madde 24)_ | _GF-10 ile aynı akışa bağlandı._ | _Aynı_ |
| GF-12 | **Topluluk paylaşım kartı** | [skapi_screen.dart `_ContributeFooter`](app/lib/features/skapi/skapi_screen.dart) | Card "yakında" badge, tap snackbar | **Detaylı 4 fazlı plan: [topluluk_script.md](topluluk_script.md)** — Faz 0 (1 günlük iş): GitHub repo `smartkraft/skapi-community-scripts` aç, `_ContributeFooter.onTap` snackbar yerine `SkCenteredDialog` (GitHub issue + mailto butonu). Faz 1: in-app form, Faz 2: curated katalog + OTA, Faz 3: discovery + güven. **Sıradaki adım**: Faz 0 |
| ~~GF-13~~ | ~~**SKAPI script editör**~~ | _Implement edildi_ | _SkapiScriptEditorScreen._onSave → scriptResolverProvider.saveEdit override storage'a yazar + invalidate ile detay ekranı modified state'e geçer; line/col indicator + dialog confirm + ConfirmDialog reset, 573 satır._ | _Manifest validation (örn. PowerShell sözdizimi) yapılmıyor; runtime hatası kullanıcıya geri yansır. Gerekirse ayrı iş._ |

### D. BF cihaz ekranlarında

| # | Yer | Konum | UI davranışı | Eksik içerik |
|---|---|---|---|---|
| GF-14 | **BF Settings — Check updates satırı** | [bf_settings_screen.dart:293-298](app/lib/features/devices/bf/bf_settings_screen.dart#L293-L298) | `disabled: true` satır | Cihaz firmware OTA — manifest URL henüz null, OTA backend yok (memory: project_firmware_ota.md) |

### E. Pairing / Discovery yarım yerleri

| # | Yer | Durum | Eksik içerik |
|---|---|---|---|
| GF-15 | **WiFi-only pairing fazı** | ~~Tamamlandı 2026-05-14~~ | `user_configured` flag firmware'de sk_baseline.c NVS'de, device.info'da, factory-reset event'inde temizlenir; SKAPP pairing_screen._routeAfterPairing okuyup wizard skip kararını verir |
| GF-16 | **mDNS-only cihaz pairing** | TCP ECDH aktif | (Tamamlandı, GF-15 kapsamında) |

### F. Cihaz şifresi / multi-bond

| # | Yer | Durum | Eksik içerik |
|---|---|---|---|
| GF-17 | **Cihaz kullanıcı şifresi (PIN/passphrase)** | Pairing'de gate var, multi-bond eksik | Memory: project_pending_phases.md #2 — büyük iş, ayrı plan |

---

### Tek-cümle özet (sonraki sıralama)

Tamamlanan (referans için duruyor): GF-1, GF-3, GF-6, GF-7, GF-10, GF-11, GF-13, GF-15, GF-16, 22.1, Madde 24 BUG/NIT turu.
Donanım/dış işlem gerektirenler (engellenen): GF-8/9 + GF-14 OTA backend, GF-17 multi-bond test, 22.2 macOS Faz 2, 22.3 Linux Faz 2 (Madde 21 ile), 23-B GPG, 24-S2.8 manuel test, 25 LS bekleyenler.
Sıradaki self-contained kod işleri: GF-12 Topluluk paylaşım dialog (Faz 0 kod kısmı), Madde 11 BF log persistence, Madde 19 hazırlık i18n hardcoded TR temizlemesi.
