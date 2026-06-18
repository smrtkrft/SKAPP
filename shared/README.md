# SKAPP `shared/`

Hem **SKAPP (Flutter app)** hem de **her SmartKraft cihaz firmware'i** tarafından uyulması gereken ortak şartnameler.

## Bağımsızlık prensibi

- **Cihaz firmware tek başına çalışmalı.** SKAPP olmasa da USB CLI üzerinden konfigüre edilebilir, donanım fonksiyonel kalır. Bu klasördeki dosyalar firmware build'inin bir parçası **değildir** (vendored sk_core içinde gerekli implementasyon zaten var).
- **SKAPP tek başına çalışmalı.** Hiçbir cihaz olmadan açılır, "Cihaz tara" ekranında bekler.
- **İkisi bir arada tam uyumlu.** Bu klasördeki dosyalar bunu sağlayan kontrat.

## Kapsam

Bu klasöre **YALNIZCA** her iki tarafın aynı anlamda yorumlamak zorunda olduğu şeyler girer:

| Dosya | İçerik | Kim okur |
|---|---|---|
| `cli_contract.md` | Wire format (JSON), zorunlu komut seti, hata kodları, versiyonlama | Firmware impl ↔ SKAPP CLI client |
| `event_taxonomy.md` *(planlı)* | Event isimleri (`face.changed`, `timer.expired`, ...) | Firmware publisher ↔ SKAPP subscriber |
| `manifest_schema.md` *(planlı)* | `device.manifest` cevabının şeması (cihaza özgü komut ve UI hint'leri) | Firmware ↔ SKAPP renderer |

## Buraya **GİRMEYECEK** olanlar

- Cihaz-spesifik komut listeleri — bunlar runtime'da `device.manifest` ile öğrenilir, statik dosya olarak yazılmaz.
- Cihazın iç implementasyon detayı (sk_core kaynak kodu, hardware pin map'i vb.) — `BF/`, `SKAPP/esp32/skapp-library/`, vs. ait dosyalar.
- Flutter UI kodu — `SKAPP/app/lib/` altında.

## Versiyonlama

`cli_contract.md` üst kısmındaki `Version: x.y.z` semver kuralına uyar:
- **patch**: yorum/format düzeltmesi, anlam değişmedi
- **minor**: yeni opsiyonel komut/alan eklendi, eski client'lar çalışmaya devam eder
- **major**: breaking change — APP `device.info`'dan dönen `protocol_version`'ı kontrol edip eski cihazları reddetmeli

Bir değişiklik bu klasöre giriyorsa hem firmware hem SKAPP tarafının aynı anda güncellenmesi gerek. Tek tarafa dokunmak protokolü kırar.
