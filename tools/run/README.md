# Wi-Fi Android Launchers

Android telefona kablosuz (Wi-Fi) olarak SKAPP kurmak ve geliştirmek için 3 betik. Phone Developer Options > Wireless debugging açık olmalı; her telefon yeniden başlatıldığında pair adımı tekrarlanır.

| Dosya | Ne yapar |
|---|---|
| `wifi_pair_android.bat` | PC ile Android arasında **tek seferlik Wi-Fi eşleştirme**. Telefonda Ayarlar > Geliştirici Seçenekleri > Kablosuz hata ayıklama > "Eşleşme koduyla eşle" açılır, ekrandaki IP:port ve 6 haneli kod betiğe girilir. Telefon reboot olduğunda tekrar gerekir. |
| `wifi_install_android.bat` | Eşleşmiş telefona **release APK kalıcı kurulum**. Önce `flutter build apk --release` ile APK üretilmiş olmalı (`app/build/app/outputs/flutter-apk/app-release.apk`). |
| `wifi_run_android.bat` | Eşleşmiş telefona **debug + hot reload** çalıştırır. Kodu kaydet → terminalde `r` → telefon 1 saniyede güncellenir. Günlük geliştirme için. |

## Tipik akış

1. **Telefon başına bir kez:** `wifi_pair_android.bat` → telefonda Wireless debugging > "Eşleşme koduyla eşle" > kod + IP:port gir
2. **Geliştirme sırasında:** `wifi_run_android.bat` → debug, hot reload
3. **Test sürümünü telefona yüklemek için:** önce release APK build (Claude tarafında), sonra `wifi_install_android.bat`

## Tip

Sık kullanıyorsan `.bat` dosyasına sağ tık → "Send to → Desktop (create shortcut)" ile masaüstüne tek tıkla erişim kısayolu çıkar.
