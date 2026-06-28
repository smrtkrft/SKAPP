# Android Release İmzalama (SKAPP)

Beta, Google Play olmadan **sideload APK** olarak dağıtılır; yine de release
build'in kalıcı bir keystore ile imzalanması gerekir. **Bu adım sende.**

## ⚠️ En kritik kural
`skapp-release.jks` + parolaları **kaybedersen, yayınlanmış kullanıcılara
yerinde güncelleme (in-place update) veremezsin** — yeni APK farklı imzayla
reddedilir, kullanıcı uygulamayı silip yeniden kurmak zorunda kalır (verisi
gider). Bu yüzden keystore'u **sonsuza dek** sakla: şifre yöneticisi + offline
şifreli yedek (en az 2 kopya).

## 1) Keystore üret (bir kez)
Repo kökünden:
```bash
keytool -genkey -v \
  -keystore app/android/skapp-release.jks \
  -storetype JKS \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias skapp
```
`-validity 10000` ≈ 27 yıl. Sorulan store + key parolalarını güçlü seç ve not et.

## 2) key.properties oluştur
```bash
cp app/android/key.properties.example app/android/key.properties
# app/android/key.properties içindeki CHANGE_ME değerlerini doldur:
#   storePassword, keyPassword, keyAlias=skapp, storeFile=skapp-release.jks
```
Hem `key.properties` hem `*.jks` `.gitignore`'da — commit edilmez.

## 3) Doğrula
```bash
cd app && flutter build apk --release
# build/app/outputs/flutter-apk/app-release.apk üretildiğinde imza aktif.
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
```
`key.properties` yoksa build debug anahtarıyla imzalanır (geliştirme için OK,
dağıtım için DEĞİL).

## 4) CI için (GitHub Actions, Faz 2/5)
Keystore'u base64'le ve repo ayarlarından **Secrets**'a ekle:
```bash
base64 -i app/android/skapp-release.jks | pbcopy   # macOS
```
Eklenecek GitHub Secrets:
- `ANDROID_KEYSTORE_BASE64` → yukarıdaki base64 metni
- `ANDROID_STORE_PASSWORD`, `ANDROID_KEY_PASSWORD`, `ANDROID_KEY_ALIAS` (=skapp)

Workflow bunları decode edip `key.properties` + `skapp-release.jks` olarak
yazar (bkz. `.github/workflows/release.yml`). Bu, keystore'un ikinci kopyasıdır.
