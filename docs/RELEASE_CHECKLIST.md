# SKAPP — Yayın Öncesi Smoke-Test Matrisi

Bir beta yayını ("hazır") yalnızca aşağıdaki tüm satırlar ilgili platformda,
**paketlenmiş artifact'tan temiz kurulumla** (dev build değil) geçtiğinde
hazırdır. Kur, sonra sırayla doğrula.

| Adım | macOS | Windows | Linux | Android |
|---|---|---|---|---|
| Paketten kurulum (DMG / setup.exe / AppImage+.deb / APK) | ☐ | ☐ | ☐ | ☐ |
| İlk açılış splash'i geçiyor (beyaz/boş ekran yok) | ☐ | ☐ | ☐ | ☐ |
| Quarantine / SmartScreen bypass adımları belgelendiği gibi çalışıyor | ☐ | ☐ | ☐ | n/a |
| BLE: tarama SmartKraft cihazı buluyor, eşleşme başarılı | ☐ | ☐ | ☐ | ☐ |
| WiFi/mDNS: BLE wifi.connect sonrası cihaz LAN'da keşfediliyor | ☐ | ☐ | ☐ | ☐ |
| Çekirdek akış: bir SKAPI script aç, çalıştır, çıktıyı gör | ☐ | ☐ | ☐ | ☐ |
| Ayarlar → Tanılama: Kopyala / Klasörü aç / Paylaş çalışıyor | ☐ | ☐ | ☐ | ☐ |
| Tray / single-instance (masaüstü): tray'e in, tekrar başlat odaklıyor | ☐ | ☐ | ☐ | n/a |
| Tema + dil (EN/TR) değişimi yeniden başlatınca korunuyor | ☐ | ☐ | ☐ | ☐ |
| Factory reset ilk-açılış durumuna dönüyor ve logları siliyor | ☐ | ☐ | ☐ | ☐ |
| About'taki sürüm yayın tag'i ile eşleşiyor | ☐ | ☐ | ☐ | ☐ |
| Güncelleme denetimi: yeni sürüm varsa banner + doğru asset linki | ☐ | ☐ | ☐ | ☐ |

## Her yayında (release) izlenecek sıra
1. `app/pubspec.yaml` sürümünü artır (`X.Y.Z+N`, `+N` monoton).
2. `CHANGELOG.md`'ye sürüm notu ekle.
3. `cd app && flutter clean && flutter pub get && flutter analyze` → temiz.
4. Yukarıdaki matrisi hedef platformlarda geçir.
5. `git tag -a vX.Y.Z -m "SKAPP vX.Y.Z"` → `git push --tags` → CI build + yayın yapar.
6. GitHub Release asset adlarının **sabit** kaldığını doğrula (web sitesi
   indirme linkleri `releases/latest/download/<asset>` bunlara bağlı):
   `SKAPP-macos.dmg`, `SKAPP-windows-setup.exe`, `SKAPP-linux-x86_64.AppImage`,
   `SKAPP-linux-amd64.deb`, `SKAPP-android.apk`.
