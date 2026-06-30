# 5×Release — GitHub'dan Tüm Platformları Yayınlama

Tek bir git **tag**'i ile 5 kurulum dosyasını GitHub Releases'e otomatik
üretip yükleme rehberi (macOS · Windows · Linux ×2 · Android). İşi
`.github/workflows/release.yml` yapar; sen yalnız tetiklersin.

> **İki kanal, karıştırma:**
> - `ota/` (yerel) = kendi cihazına hızlı kurulum/test. Gitignore'lı, GitHub'a gitmez.
> - **GitHub Releases** = herkesin indirdiği resmi dosyalar (CI üretir). Web sitesi butonları buraya bağlanır.

Üretilen sabit asset adları (web linkleri bunlara bağlı, **sürümler arası değişmez**):
`SKAPP-windows-setup.exe` · `SKAPP-macos.dmg` · `SKAPP-linux-x86_64.AppImage` · `SKAPP-linux-amd64.deb` · `SKAPP-android.apk`

---

## Ön koşullar (tek seferlik)

- Repo GitHub'da olmalı: `github.com/smrtkrft/SKAPP` (CI ancak repodaki workflow'u çalıştırır).
- Yerelde `flutter analyze` temiz olmalı.
- **Windows `.exe` için kendi Windows bilgisayarına gerek YOK** — GitHub'ın bulut `windows-latest` runner'ı senin yerine derler. Sen sadece kodu push'lar + tag atarsın.

---

## Adım 0 — (Opsiyonel, önerilir) Android imzalama

Atlarsan APK **debug** anahtarıyla çıkar (sideload/test OK, gerçek release değil).
Detay: `docs/ANDROID_SIGNING.md`.

1. Keystore üret (bir kez, **sonsuza dek sakla**):
   ```bash
   keytool -genkey -v -keystore app/android/skapp-release.jks \
     -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias skapp
   ```
2. GitHub → **Settings → Secrets and variables → Actions → New repository secret**:
   | Secret | Değer |
   |---|---|
   | `ANDROID_KEYSTORE_BASE64` | `base64 -i app/android/skapp-release.jks \| pbcopy` çıktısı |
   | `ANDROID_STORE_PASSWORD` | store parolası |
   | `ANDROID_KEY_PASSWORD` | key parolası |
   | `ANDROID_KEY_ALIAS` | `skapp` |

---

## Adım 1 — Kodu commit + push et

`.github/workflows/release.yml` GitHub'a gidince CI hazır olur.
```bash
git add -A
git commit -m "Dağıtım altyapısı + 9 dil + updater (v0.4.0 beta)"
git push origin main
```
> İlk kez yayınlıyorsan workflow'un repoda olduğunu kontrol et:
> GitHub → **Actions** sekmesinde "Release" iş akışı görünmeli.

---

## Adım 2 — Sürümü doğrula

- `app/pubspec.yaml` → `version: 0.4.0+4` (biçim **daima** `X.Y.Z+N`; her yayında `+N` artar).
- `CHANGELOG.md` o sürümün notunu içeriyor.

---

## Adım 3 — Tag at ve push'la (CI'yi BU tetikler)

```bash
git tag -a v0.4.0 -m "SKAPP v0.4.0 — public beta"
git push origin v0.4.0
```
Workflow `push: tags: ['v*']` ile tetiklenir. (Tag atmadan elle denemek için
GitHub → Actions → Release → **Run workflow** = `workflow_dispatch` de var, ama
release yayınlamak için tag yolu kullanılır.)

---

## Adım 4 — CI'yi izle (GitHub → Actions)

"Release" çalışması açılır; 4 derleme job'u **paralel** koşar, sonra `release` job'u toplar:

| Job | Runner | Üretir | Secret |
|---|---|---|---|
| android | ubuntu | `SKAPP-android.apk` | Android secret'ları (varsa) |
| linux | ubuntu | `SKAPP-linux-x86_64.AppImage` + `SKAPP-linux-amd64.deb` | — |
| windows | windows | `SKAPP-windows-setup.exe` | — |
| macos | macos | `SKAPP-macos.dmg` | — |
| release | ubuntu | 5 asset'i Release'e ekler | (otomatik `GITHUB_TOKEN`) |

Toplam ~15-25 dk. Yeşil ✓ = başarı; kırmızı ✗ = o job'un log'una tıkla.

---

## Adım 5 — Sonuç: GitHub Release

GitHub → **Releases** → `v0.4.0`. İçinde 5 dosya + `.github/RELEASE_TEMPLATE.md`'den
gelen kurulum talimatlı açıklama. (Beta normal release olarak yayınlanır —
pre-release işaretli değil — ki `latest` linkleri çalışsın.)

İndirme linklerini test et:
```
https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-windows-setup.exe
https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-macos.dmg
https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-linux-x86_64.AppImage
https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-linux-amd64.deb
https://github.com/smrtkrft/SKAPP/releases/latest/download/SKAPP-android.apk
```

---

## Adım 6 — Web sitesi butonları

Sitendeki indirme butonlarını yukarıdaki `releases/latest/download/<asset>`
linklerine bağla. Asset adları sabit olduğu için sürüm değişince linkleri
güncellemen gerekmez.

---

## Sorun giderme (ilk koşuda en riskli adım)

| Belirti | Olası neden / çözüm |
|---|---|
| `linux` job apt/derleme hatası | GTK/`libsecret`/`libayatana-appindicator3` paket adı; log'a göre `release.yml`'deki apt satırını düzelt |
| `windows` job `iscc` bulunamadı | `choco install innosetup` adımı; runner'da Inno yolu değişmişse `package_windows.ps1`'i güncelle |
| `linux` AppImage `appimagetool` hatası | İndirme URL'i / `--appimage-extract-and-run`; `scripts/package_linux.sh` |
| `android` job imza hatası | Secret adları/değerleri; yoksa debug ile çıkar (hata değil, uyarı) |
| Release oluşmuyor | `permissions: contents: write` (workflow'da var) + tag gerçekten push edildi mi |

**Bir job patlarsa:** Actions → ilgili çalışma → **Re-run failed jobs** (geçici hata ise).
**Kod düzeltmesi gerekiyorsa** ve aynı sürümü yeniden denemek istersen tag'i taşı:
```bash
git tag -d v0.4.0                 # yereldeki tag'i sil
git push origin :refs/tags/v0.4.0 # uzaktaki tag'i sil
# düzeltmeyi commit + push et, sonra:
git tag -a v0.4.0 -m "..." && git push origin v0.4.0
```
(Aynı tag'e bağlı Release güncellenir. Karışmasın istersen yeni sürüm: `v0.4.1`.)

---

## Sonraki sürümü yayınlama (kısa döngü)

1. `app/pubspec.yaml` → sürümü artır (`0.4.1+5`; `+N` mutlaka artar).
2. `CHANGELOG.md`'ye not ekle.
3. `flutter analyze` temiz.
4. commit + push.
5. `git tag -a v0.4.1 -m "..." && git push origin v0.4.1` → CI gerisini yapar.

---

## Notlar (beta imza durumu)

- **Windows `.exe` imzasız** → kullanıcıda SmartScreen "Daha fazla bilgi → Yine de çalıştır". (Kod imzalama sertifikası 1.0'a ertelendi.)
- **macOS `.dmg` ad-hoc / notarize değil** → indiren kullanıcı ilk açılışta **sağ-tık → Aç**, ya da `xattr -dr com.apple.quarantine /Applications/skapp.app`. (Notarization = Apple Developer $99, 1.0.)
- **Android APK** sideload ile kurulur ("bilinmeyen kaynaklar"a izin). Google Play 1.0'a ertelendi.
- **iOS yok** (bu sürümde).
- Yayın öncesi her platformda `docs/RELEASE_CHECKLIST.md` smoke-test matrisini geçir.
