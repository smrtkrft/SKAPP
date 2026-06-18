# Hue Ampul Kontrolü — Tam API (v1)

**API:** Philips Hue CLIP v1
**Endpoint base:** `https://{BRIDGE_IP}/api/{USERNAME}/`
**Auth:** Username/API key (URL içinde)
**Format:** JSON

---

## 1. Ampul Listesi

### Tüm ampuller
```
GET https://192.168.1.30/api/{USERNAME}/lights
```

**Cevap:**
```json
{
  "1": {
    "state": { "on": true, "bri": 254, "hue": 8418, "sat": 140, "ct": 366, "xy": [0.4576, 0.4099], "alert": "none", "effect": "none", "colormode": "ct", "reachable": true },
    "type": "Extended color light",
    "name": "Salon Lambası",
    "modelid": "LCT001",
    "manufacturername": "Philips",
    ...
  },
  "2": { ... }
}
```

### Tek ampul
```
GET https://192.168.1.30/api/{USERNAME}/lights/1
```

---

## 2. Aç / Kapat

### Aç (ampul ID 1)
```http
PUT https://192.168.1.30/api/{USERNAME}/lights/1/state
Content-Type: application/json

{ "on": true }
```

### Kapat
```http
PUT /lights/1/state
{ "on": false }
```

### Toggle — direkt yok, mevcut state oku, tersini gönder
```
1. GET /lights/1 → "on": true
2. PUT /lights/1/state { "on": false }
```

---

## 3. Parlaklık

`bri` parametresi **0-254** arası. (Hue'da max 254, Wiz'deki gibi 100 değil.)

### %50 parlaklığa ayarla
```http
PUT /lights/1/state
{ "on": true, "bri": 127 }
```

### Tam parlaklık (%100)
```http
PUT /lights/1/state
{ "on": true, "bri": 254 }
```

### En kısık (%1, ama 0 değil)
```http
PUT /lights/1/state
{ "on": true, "bri": 1 }
```

> `bri: 0` kabul edilmez — kapatmak için `on: false` kullan.

---

## 4. Renk — Kelvin (Tunable White / White Ambiance)

`ct` parametresi **mired** birimi:
- mired = 1.000.000 / kelvin
- Aralık: 153 (6500K) — 500 (2000K)

### Sıcak (2700K)
```http
PUT /lights/1/state
{ "on": true, "ct": 370 }
```
1.000.000 / 2700 ≈ 370

### Doğal (4000K)
```http
PUT /lights/1/state
{ "on": true, "ct": 250 }
```

### Soğuk (6500K)
```http
PUT /lights/1/state
{ "on": true, "ct": 153 }
```

### Yaygın Kelvin → mired tablosu

| Kelvin | Mired |
|---|---|
| 2000 | 500 |
| 2200 | 455 |
| 2700 | 370 |
| 3000 | 333 |
| 3500 | 286 |
| 4000 | 250 |
| 4500 | 222 |
| 5000 | 200 |
| 5500 | 182 |
| 6000 | 167 |
| 6500 | 153 |

---

## 5. Renk — RGB / HSV / XY (Color Bulb)

Hue **3 farklı renk space** destekler. En kullanışlısı **HSV** (Hue/Saturation).

### HSV (Hue + Saturation)
- `hue`: **0-65535** (kırmızı=0, sarı=12750, yeşil=25500, mavi=46920, vb.)
- `sat`: **0-254** (0=beyaz, 254=tam doygun renk)

### Saf kırmızı
```http
PUT /lights/1/state
{ "on": true, "hue": 0, "sat": 254, "bri": 254 }
```

### Saf yeşil
```http
PUT /lights/1/state
{ "on": true, "hue": 25500, "sat": 254, "bri": 254 }
```

### Saf mavi
```http
PUT /lights/1/state
{ "on": true, "hue": 46920, "sat": 254, "bri": 254 }
```

### Mor
```http
PUT /lights/1/state
{ "on": true, "hue": 50000, "sat": 254, "bri": 254 }
```

### Yaygın renkler → hue değeri

| Renk | Hue değeri |
|---|---|
| Kırmızı | 0 |
| Turuncu | 5000 |
| Sarı | 10000 |
| Yeşil sarı | 18000 |
| Yeşil | 25500 |
| Su yeşili | 32000 |
| Cyan | 40000 |
| Mavi | 46920 |
| Mor | 50000 |
| Magenta | 56000 |
| Pembe | 62000 |

### XY (CIE 1931) — daha hassas
```http
PUT /lights/1/state
{ "on": true, "xy": [0.675, 0.322] }
```
Bu kırmızıya çok yakın bir renk. Genelde HSV daha kolay.

### RGB → Hue/Sat dönüşümü (formül)
RGB'yi HSV'ye çevirip:
- `hue` = HSV.h × (65535 / 360)
- `sat` = HSV.s × (254 / 100)
- `bri` = HSV.v × (254 / 100)

---

## 6. Geçiş Süresi (Transition Time)

`transitiontime` parametresi **deciseconds** (1/10 saniye):
- 4 = 400ms (varsayılan)
- 10 = 1 saniye
- 50 = 5 saniye
- 100 = 10 saniye

### Yumuşak fade ile aç (3 sn)
```http
PUT /lights/1/state
{ "on": true, "bri": 254, "transitiontime": 30 }
```

### Anlık (fade yok)
```http
PUT /lights/1/state
{ "on": true, "transitiontime": 0 }
```

### Yavaş söndür (10 sn'de)
```http
PUT /lights/1/state
{ "on": false, "transitiontime": 100 }
```

---

## 7. Alert (Yanıp Sönme)

```http
PUT /lights/1/state
{ "alert": "select" }       // tek yanıp söner (1 kez)

{ "alert": "lselect" }      // 15 saniye yanıp söner

{ "alert": "none" }         // durdur
```

---

## 8. Effect

```http
PUT /lights/1/state
{ "effect": "colorloop" }   // renkler arası dönüşüm (sürekli)

{ "effect": "none" }        // efekt kapat
```

---

## 9. Hue/Sat İnkremental Değişim

Mevcut değere ekleme/çıkarma:
```http
PUT /lights/1/state
{ "bri_inc": 50 }          // parlaklığı 50 artır
{ "bri_inc": -100 }        // 100 azalt
{ "hue_inc": 1000 }        // hue'yu 1000 artır
{ "sat_inc": -50 }         // sat'ı 50 azalt
{ "ct_inc": 50 }           // ct'yi 50 artır (sıcaklaştır)
```

Animasyonlu efektler için kullanışlı.

---

## 10. Cihaz Bilgisi / İsim

### İsim değiştir
```http
PUT https://192.168.1.30/api/{USERNAME}/lights/1
{ "name": "Yeni İsim" }
```

### Cihazı sil
```http
DELETE https://192.168.1.30/api/{USERNAME}/lights/1
```

### Yeni cihaz tara (Bridge ZigBee scan)
```http
POST https://192.168.1.30/api/{USERNAME}/lights
```

---

## SKAPI Şablonları

### "Hue ampul aç"
```yaml
id: hue-bulb-on
name: "Hue Ampul - Aç"
category: smarthome
target: hue-bulb
protocol: http
method: PUT
url: "https://{bridge_ip}/api/{username}/lights/{light_id}/state"
body: { "on": true }
params:
  - { key: bridge_ip, label: "Bridge IP", type: ip, required: true }
  - { key: username, label: "API Key", type: secret, required: true }
  - { key: light_id, label: "Ampul ID", type: int, required: true }
```

### "Hue ampul kapat"
```yaml
id: hue-bulb-off
name: "Hue Ampul - Kapat"
category: smarthome
target: hue-bulb
protocol: http
method: PUT
url: "https://{bridge_ip}/api/{username}/lights/{light_id}/state"
body: { "on": false }
params:
  - { key: bridge_ip, label: "Bridge IP", type: ip, required: true }
  - { key: username, label: "API Key", type: secret, required: true }
  - { key: light_id, label: "Ampul ID", type: int, required: true }
```

### "Belirli renge ayarla (HSV)"
```yaml
id: hue-bulb-color
name: "Hue Ampul - Renk Ayarla"
category: smarthome
target: hue-color-bulb
protocol: http
method: PUT
url: "https://{bridge_ip}/api/{username}/lights/{light_id}/state"
body: { "on": true, "hue": "{hue}", "sat": "{sat}", "bri": "{bri}", "transitiontime": "{transition}" }
params:
  - { key: bridge_ip, label: "Bridge IP", type: ip, required: true }
  - { key: username, label: "API Key", type: secret, required: true }
  - { key: light_id, label: "Ampul ID", type: int }
  - { key: hue, label: "Hue (0-65535)", type: int, default: 25500 }
  - { key: sat, label: "Saturation (0-254)", type: int, default: 254 }
  - { key: bri, label: "Brightness (0-254)", type: int, default: 254 }
  - { key: transition, label: "Geçiş (deciseconds)", type: int, default: 4 }
```

### "Beyaz tonu (Kelvin)"
```yaml
id: hue-bulb-temp
name: "Hue Ampul - Beyaz Tonu"
category: smarthome
target: hue-bulb
protocol: http
method: PUT
url: "https://{bridge_ip}/api/{username}/lights/{light_id}/state"
body: { "on": true, "ct": "{mired}", "bri": "{bri}" }
params:
  - { key: bridge_ip, label: "Bridge IP", type: ip, required: true }
  - { key: username, label: "API Key", type: secret, required: true }
  - { key: light_id, label: "Ampul ID", type: int }
  - { key: mired, label: "Mired (153-500)", type: int, default: 250 }
  - { key: bri, label: "Brightness", type: int, default: 200 }
```

### "Yumuşak uyandırma (10 dk fade up)"
```yaml
id: hue-bulb-wakeup
name: "Hue Ampul - Yumuşak Uyandırma"
target: hue-bulb
endpoints:
  - { method: PUT, url: "https://{bridge_ip}/api/{username}/lights/{light_id}/state", body: { "on": true, "bri": 1 } }
  - { method: PUT, url: "https://{bridge_ip}/api/{username}/lights/{light_id}/state", body: { "bri": 254, "transitiontime": 6000 } }
params:
  - { key: bridge_ip, label: "Bridge IP", type: ip, required: true }
  - { key: username, label: "API Key", type: secret, required: true }
  - { key: light_id, label: "Ampul ID", type: int }
```

### "Yanıp söndür (alert)"
```yaml
id: hue-bulb-alert
name: "Hue Ampul - Yanıp Söndür"
target: hue-bulb
protocol: http
method: PUT
url: "https://{bridge_ip}/api/{username}/lights/{light_id}/state"
body: { "alert": "select" }
params:
  - { key: bridge_ip, label: "Bridge IP", type: ip, required: true }
  - { key: username, label: "API Key", type: secret, required: true }
  - { key: light_id, label: "Ampul ID", type: int }
```
