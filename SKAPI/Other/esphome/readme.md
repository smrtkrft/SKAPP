# ESPHome — Genel Rehber

ESPHome, ESP8266/ESP32/RP2040/LibreTiny tabanlı cihazları için **YAML ile yapılandırılan açık kaynak firmware**. SKAPI için ideal — yerel API, otomatik discovery, OTA güncellemeleri.

---

## Neden ESPHome SKAPI'ye İdeal

- **Yerel HTTP REST API** ✅ (Web Server component)
- **Native API** (TCP/binary) — Home Assistant ile lossless event akışı
- **MQTT** ✅ (opsiyonel, MQTT broker varsa)
- **mDNS discovery** otomatik (`{device-name}.local`)
- **Auth** opsiyonel ama destekli
- **Cloud yok** (cihaz tamamen yerel)
- **Açık kaynak**, topluluk büyük

---

## ESPHome Cihaz Yapılandırması

ESPHome cihazları **YAML config** ile derlenir. Örnek:

```yaml
esphome:
  name: salon-lambasi
  platform: ESP32
  board: esp32dev

wifi:
  ssid: "MyWiFi"
  password: "..."

api:                  # Native API (HA için)
  encryption:
    key: "..."

ota:                  # OTA güncelleme
  password: "..."

web_server:           # Web GUI + REST API
  port: 80

mdns:                 # Otomatik mDNS (varsayılan açık)

mqtt:                 # Opsiyonel
  broker: 192.168.1.10
  username: "..."
  password: "..."

# Cihaza bağlı bileşenler
switch:
  - platform: gpio
    name: "Salon Anahtarı"
    pin: GPIO5
    id: salon_relay

light:
  - platform: monochromatic
    name: "Salon Lambası"
    output: pwm_output
    id: salon_light

sensor:
  - platform: dht
    pin: GPIO4
    temperature: { name: "Salon Sıcaklık" }
    humidity: { name: "Salon Nem" }
```

Her bileşen otomatik olarak HTTP/native API üzerinden erişilebilir hale gelir.

---

## API Sürümleri

| API | Port | Format | Use case |
|---|---|---|---|
| **Web Server (REST)** | 80 | JSON | Tarayıcıdan, ESP32'den, SKAPI'den kolay tetikleme |
| **Native API** | 6053 | Protobuf binary | Home Assistant, real-time event akışı |
| **MQTT** | 1883 (broker'a) | JSON | Smart home entegrasyonu |
| **WebSocket** | 80 (`/events`) | JSON event stream | Tarayıcı/SKAPI event subscribe |

> **SKAPI için tavsiye:** Web Server REST API. Basit, evrensel, ESP32'den HTTP atması trivial.

---

## Bu Klasördeki Dosyalar

- [native-api.md](native-api.md) — Web Server REST + WebSocket event stream + native API
- entity-types.md — switch / light / sensor / climate / fan / cover / lock / number / button / select (yakında)
- service-calls.md — Custom service tanımı + tetikleme (yakında)

---

## Hızlı Test

ESPHome cihazının web arayüzünü aç:
```
http://salon-lambasi.local
```

Tüm bileşenler listelenir. Her birinin yanında "Toggle/On/Off" butonları + REST endpoint linkleri var.

API dokümantasyonu için web arayüzünde **GET /text_sensor/...** veya benzeri linklere bak.

---

## Entity Naming Convention

ESPHome'da entity ID'leri YAML'deki `name` alanından türetilir:
- `name: "Salon Lambası"` → `light.salon_lambasi` veya web URL'inde `salon_lambasi`
- Türkçe karakterler ASCII'leştirilir, boşluklar `_`
- Manuel olarak `id: ...` ile override edilebilir

---

## SKAPI vs ESPHome

ESPHome zaten "akıllı cihaz firmware'i" — SKAPP'in entegre etmesi en kolay olanlardan biri:

```
ESP32-C6 timer ──HTTP──► ESPHome cihaz:80/switch/salon_relay/turn_on
```

Tek satır komut, hiçbir auth/protokol karmaşası yok.
