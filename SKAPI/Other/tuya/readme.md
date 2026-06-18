# Tuya / Smart Life Cihazları — Genel Rehber

Tuya, dünyanın en büyük IoT bulut platformu. Çok sayıda **white-label** (Smart Life, Brilliant, Lloytron, Lidl Silvercrest, Tuya Smart, vb.) marka altında binlerce cihaz Tuya altyapısı kullanır.

---

## Mimari Sorun

Tuya cihazları **varsayılan olarak buluttan yönetilir**:
```
Cihaz ──TLS──► Tuya Cloud (Çin/AB sunucular) ──► Smart Life uygulaması
```

> **Yerel ağda kontrol için ek iş gerekir.** Çoğu cihaz yerel HTTP API sunmaz.

---

## Yerel Kontrol Yolları

### Yöntem 1: Tuya Local API (En yaygın yol)
Cihaz Wi-Fi'da bulunabilir + **local key** çıkartılabilirse → yerel TCP 6668 üzerinde komut gönderilebilir.

**Gerekenler:**
- Cihazın **Device ID** (Tuya developer hesabından alınır)
- Cihazın **Local Key** (developer hesabı + cihaz pairing sonrası)
- Cihazın IP'si

**Araçlar:**
- `tinytuya` (Python) — komut göndermek için
- `LocalTuya` (Home Assistant entegrasyonu)

### Yöntem 2: Tuya Cloud API
- Tuya IoT Platform'a kayıtlı uygulama oluştur
- Access Token al
- Bulut üzerinden komut at (internet bağlantısı gerekli)

> SKAPI **yerel ağ** odaklı olduğundan **Yöntem 1** önerilir.

### Yöntem 3: Tasmota / ESPHome'a flash etme
Bazı Tuya cihazlarında ESP8266/ESP32 var. Yerel firmware (Tasmota, ESPHome) flash edilebilir. Sonra cihaz "kendi" olur, bulut/local key sorunu kalkar.

**Araçlar:**
- `tuya-convert` (eski, OTA flash)
- Manuel UART flash (lehim gerekebilir)

> Tasmota/ESPHome sonrası → cihaz `Other/esphome/` veya `Other/mqtt/` template'leri ile kontrol edilir.

---

## Tuya Cihaz Tipleri

Tuya marka altında **her şey** vardır:
- Akıllı ampul (RGB, tunable, white)
- LED strip
- Smart plug (priz)
- Smart switch (anahtar)
- Smart curtain motor
- Smart lock
- Smart thermostat
- Smart camera
- Smart sensor (PIR, kapı, su, gaz, sıcaklık)
- Smart vacuum
- Smart fan
- IR blaster (uzaktan kumanda)

---

## Tuya DataPoints (DPS)

Tuya cihazları **DataPoints** (DPS) ile çalışır. Her cihaz tipinin kendi DPS map'i vardır.

Örnek (RGB ampul):
```
DPS 20: on/off (bool)
DPS 21: işletme modu (white | colour | scene | music)
DPS 22: parlaklık (10-1000)
DPS 23: renk sıcaklığı (0-1000)
DPS 24: HSV string ("00ff66640101" gibi)
DPS 25: sahne ID
DPS 26: zamanlayıcı
```

Örnek (smart plug):
```
DPS 1: on/off (bool)
DPS 9: countdown
DPS 18: anlık güç (W ×10)
DPS 19: toplam tüketim (Wh)
DPS 20: voltaj (V ×10)
DPS 21: akım (A ×1000)
```

Cihaz başına DPS map'i farklıdır. Topluluk dokümantasyonu (`https://github.com/jasonacox/tinytuya/blob/master/server/devices.json`) referans olabilir.

---

## Bu Klasördeki Dosyalar

- [local-control.md](local-control.md) — Tuya Local API ile cihaz kontrolü (TCP 6668 + local key)
- cloud-api.md — Tuya Cloud API (yakında)
- bulb-rgb.md — RGB ampul DPS map ve örnekler (yakında)
- plug.md — Smart plug DPS (yakında)
- curtain.md — Curtain motor (yakında)

---

## SKAPI'de Tuya Pozisyonu

Tuya **karmaşıktır**. Tavsiyeler:

1. Cihazı **flash etme şansı varsa** → ESPHome/Tasmota'ya geçir, `Other/esphome/` kullan
2. Flash etme yoksa **Home Assistant + LocalTuya** kullan, SKAPI HA üzerinden tetikle
3. Direkt SKAPI → Tuya yapacaksan `local-control.md`'deki yöntemi kullan, ESP32'ye Tuya protokolü implementasyonu zor (hazır lib yok) — SKAPP üzerinden ara katman gerekebilir
