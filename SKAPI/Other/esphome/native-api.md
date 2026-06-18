# ESPHome — Web Server REST + WebSocket API

**Base URL:** `http://{DEVICE_IP}` veya `http://{device-name}.local`
**Web Server bileşeni gerekli:** `web_server: { port: 80 }`
**Auth:** Opsiyonel (HTTP Basic Auth veya token, YAML'da tanımlanır)

---

## 1. Bileşen Listesi

### Tüm bileşenler (web GUI / REST endpoint)
```
GET /
```
HTML web arayüzü.

### JSON formatında bileşen listesi
```
GET /events?json
```

veya tek tek tip endpoint'leri.

---

## 2. Switch Kontrolü

### Aç
```
POST /switch/{name}/turn_on
```

### Kapat
```
POST /switch/{name}/turn_off
```

### Toggle
```
POST /switch/{name}/toggle
```

### Durum
```
GET /switch/{name}
```

**Cevap:**
```json
{
  "id": "switch-salon_relay",
  "value": true,
  "state": "ON"
}
```

---

## 3. Light Kontrolü

### Aç
```
POST /light/{name}/turn_on
```

### Aç + parlaklık + renk (query string ile)
```
POST /light/{name}/turn_on?brightness=128&r=255&g=100&b=0
```

### Aç + transition
```
POST /light/{name}/turn_on?brightness=255&transition=2
```

### Kapat
```
POST /light/{name}/turn_off
```

### Kapat + transition
```
POST /light/{name}/turn_off?transition=3
```

### Toggle
```
POST /light/{name}/toggle
```

### Renk sıcaklığı (tunable)
```
POST /light/{name}/turn_on?color_temp=300
```

### Efekt (tanımlıysa)
```
POST /light/{name}/turn_on?effect=Rainbow
```

### Durum
```
GET /light/{name}
```

**Light parametreleri (POST query string ile):**
- `state`: `ON` / `OFF`
- `brightness`: 0-255
- `r`, `g`, `b`: 0-255
- `color_temp`: mired (153-500)
- `white_value`: 0-255 (RGBW için)
- `effect`: efekt adı
- `transition`: saniye (fade)
- `flash`: saniye (yanıp söndür)
- `color_mode`: `rgb`, `color_temp`, `white`, `rgbw`, `rgbww`

---

## 4. Sensor (Read-only)

### Sensor değeri
```
GET /sensor/{name}
```

**Cevap:**
```json
{
  "id": "sensor-salon_sicaklik",
  "value": 22.5,
  "state": "22.5 °C"
}
```

### Binary sensor (true/false)
```
GET /binary_sensor/{name}
```

### Text sensor (string değer)
```
GET /text_sensor/{name}
```

---

## 5. Cover (Perde / Panjur)

### Aç
```
POST /cover/{name}/open
```

### Kapat
```
POST /cover/{name}/close
```

### Durdur
```
POST /cover/{name}/stop
```

### Belirli pozisyona git
```
POST /cover/{name}/set?position=0.5
```
0.0 = tam kapalı, 1.0 = tam açık.

### Durum
```
GET /cover/{name}
```

---

## 6. Climate (Termostat)

### Mode değiştir
```
POST /climate/{name}/set?mode=heat
POST /climate/{name}/set?mode=cool
POST /climate/{name}/set?mode=off
POST /climate/{name}/set?mode=auto
```

### Hedef sıcaklık
```
POST /climate/{name}/set?target_temperature=22
```

### Aralık (heat/cool için)
```
POST /climate/{name}/set?target_temperature_low=20&target_temperature_high=24
```

### Durum
```
GET /climate/{name}
```

---

## 7. Fan

```
POST /fan/{name}/turn_on
POST /fan/{name}/turn_off
POST /fan/{name}/toggle
POST /fan/{name}/turn_on?speed=high
POST /fan/{name}/turn_on?speed_level=3
POST /fan/{name}/turn_on?oscillating=true
```

---

## 8. Lock

```
POST /lock/{name}/lock
POST /lock/{name}/unlock
GET /lock/{name}
```

---

## 9. Number (Slider girdi)

```
POST /number/{name}/set?value=42.5
GET /number/{name}
```

---

## 10. Button (Tetiklenebilir)

```
POST /button/{name}/press
```

---

## 11. Select (Dropdown)

```
POST /select/{name}/set?option=Mavi
GET /select/{name}
```

---

## 12. WebSocket Event Stream

```
ws://{DEVICE_IP}/events
```

Bağlanınca tüm bileşen state değişiklikleri JSON event olarak akar:
```json
{ "id": "sensor-salon_sicaklik", "value": 22.6, "state": "22.6 °C" }
```

> SKAPI bunu real-time sensor monitoring için kullanabilir.

---

## 13. OTA Güncelleme

ESPHome'a OTA göndermek SKAPI dışı bir konu — `esphome` CLI veya Web GUI ile yapılır.

```
esphome run config.yaml --device 192.168.1.42
```

---

## SKAPI Şablonları

### "ESPHome switch aç"
```yaml
id: esphome-switch-on
name: "ESPHome - Switch Aç"
category: smarthome
target: esphome
protocol: http
method: POST
url: "http://{ip}/switch/{name}/turn_on"
params:
  - { key: ip, label: "Cihaz IP veya {name}.local", type: string, required: true }
  - { key: name, label: "Switch entity adı", type: string, required: true, placeholder: "salon_relay" }
```

### "ESPHome light aç (renk + parlaklık)"
```yaml
id: esphome-light-color
name: "ESPHome - Işık Aç (Renk)"
category: smarthome
target: esphome
protocol: http
method: POST
url: "http://{ip}/light/{name}/turn_on?brightness={brightness}&r={r}&g={g}&b={b}&transition={transition}"
params:
  - { key: ip, label: "Cihaz IP", type: string, required: true }
  - { key: name, label: "Light entity adı", type: string, required: true }
  - { key: brightness, label: "Parlaklık (0-255)", type: int, default: 200 }
  - { key: r, label: "R", type: int, default: 255 }
  - { key: g, label: "G", type: int, default: 100 }
  - { key: b, label: "B", type: int, default: 0 }
  - { key: transition, label: "Transition (sn)", type: int, default: 1 }
```

### "ESPHome cover %X aç"
```yaml
id: esphome-cover-set
name: "ESPHome - Perde Pozisyon"
category: smarthome
target: esphome
protocol: http
method: POST
url: "http://{ip}/cover/{name}/set?position={position}"
params:
  - { key: ip, label: "Cihaz IP", type: string, required: true }
  - { key: name, label: "Cover entity adı", type: string, required: true }
  - { key: position, label: "Pozisyon (0.0-1.0)", type: float, default: 0.5 }
```

### "ESPHome sensor değeri oku"
```yaml
id: esphome-sensor-read
name: "ESPHome - Sensor Oku"
category: smarthome
target: esphome
protocol: http
method: GET
url: "http://{ip}/sensor/{name}"
params:
  - { key: ip, label: "Cihaz IP", type: string, required: true }
  - { key: name, label: "Sensor entity adı", type: string, required: true }
```

### "ESPHome button bas (custom action tetikle)"
```yaml
id: esphome-button-press
name: "ESPHome - Buton Bas"
category: smarthome
target: esphome
protocol: http
method: POST
url: "http://{ip}/button/{name}/press"
params:
  - { key: ip, label: "Cihaz IP", type: string, required: true }
  - { key: name, label: "Button entity adı", type: string, required: true }
```

---

## ESPHome Custom Service (gelişmiş)

ESPHome YAML'da özel servis tanımlanabilir:
```yaml
api:
  services:
    - service: start_break_routine
      variables:
        duration: int
      then:
        - light.turn_on:
            id: salon_light
            brightness: 50%
            red: 0
            green: 50
            blue: 100
        - delay: !lambda return duration * 1000;
        - light.turn_off: salon_light
```

**Bu servisleri sadece Native API (6053) ile tetikleyebilirsin.** Web Server REST API custom service'leri desteklemez.

Native API için Python: `aioesphomeapi`. ESP32'den native API çağırmak zor (binary protokol) — bu durumda HA gateway daha pratik.

> **Tavsiye:** SKAPI için custom service yerine Web Server'daki standart entity action'ları kullan. Daha kolay.
