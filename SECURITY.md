# Güvenlik Politikası

SKAPP, SmartKraft IoT cihazlarının yapılandırma ve kontrol uygulamasıdır.
Güvenliği ciddiye alıyoruz; topluluğun katkısıyla daha güvenli oluyor.

## Açık bildirimi

Bir güvenlik açığı keşfettiyseniz **lütfen GitHub Issues'a açmayın.**
Açıklar koordineli ifşa ile sorumlu şekilde işlenir:

- **E-posta:** code@smartkraft.ch
- **Konu satırı:** `[SECURITY] kısa özet`
- **İçerik:** etkilenen bileşen, reproduksiyon adımları, etkinin ciddiyeti hakkında
  görüşünüz

### Yanıt taahhüdü

| Süre | Aksiyon |
|---|---|
| 24 saat | Bildirimin alındığına dair onay |
| 7 gün | İlk analiz, ciddiyet değerlendirmesi |
| 30 gün | Düzeltme planı veya yayın takvimi |
| Yayın sonrası | Koordineli public disclosure (raporlayanla mutabakatla) |

## Kapsam

Bu güvenlik politikası şunları kapsar:

- SKAPP masaüstü uygulaması (Windows, macOS, Linux)
- SKAPP mobil uygulaması (iOS, Android)
- SmartKraft ESP32 cihaz firmware'leri (BF, LebensSpur ve gelecek cihazlar)
- SKAPP ile cihaz arası iletişim protokolü (BLE, USB CLI, Wi-Fi)
- SKAPP ile mobil peer arası iletişim (HTTP/TLS, HMAC)

Kapsam dışı:

- Üçüncü taraf bağımlılıkları (lütfen onların kendi disclosure kanallarını kullanın)
- Cihazınızın fiziksel güvenliği (kullanıcı sorumluluğu)
- Sosyal mühendislik saldırıları

## Tehdit modeli

Mevcut tehdit modeli ve mitigation katmanları
[`güvenlik.md`](./güvenlik.md) dosyasında belgelenmiştir. Yeni bir tehdit
keşfettiyseniz lütfen yukarıdaki e-posta üzerinden bildirin.

## Versiyon kapsamı

| Sürüm | Destek durumu |
|---|---|
| En son major.minor | Aktif güvenlik güncellemeleri |
| Bir önceki minor | Sadece kritik düzeltmeler |
| Eski sürümler | Destek dışı, yükseltme önerilir |

## Hall of Fame

Doğrulanan kritik açıkları sorumlu şekilde bildirip yayın penceresine uyan
araştırmacıları proje README'sinde ve sürüm notlarında (anonim isteğiniz
yoksa) takdir ediyoruz.

Bug bounty programımız şu an aktif değil; ileride değerlendirilecek.
