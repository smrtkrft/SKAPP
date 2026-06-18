# Shelly RGBW2 (Gen1) — Tam API Komut Listesi

**Model:** SHRGBW2
**Nesil:** Gen1
**Özellikler:** RGB + W LED strip / spot kontrolcüsü, 2 mod (color veya 4×white)
**Maks akım:** 4×4A = 12A toplam
**Voltaj:** 12-24V DC
**Protokol:** HTTP REST, MQTT, CoAP, Cloud

> RGBW2'nin **iki çalışma modu** vardır:
> - **Color mode** — Tek RGB strip (4 channel: R, G, B, W birleşik)
> - **White mode** — 4 ayrı tek-renkli LED strip (channel 0, 1, 2, 3)

---

## 1. Cihaz Bilgileri

```
GET http://192.168.1.42/shelly
```

**Cevap:**
```json
{
  "type": "SHRGBW2",
  "mac": "...",
  "auth": false,
  "mode": "color",   // veya "white"
  "num_outputs": 1   // color mode → 1, white mode → 4
}
```

---

## 2. Mod Seçimi

### Color moduna geç
```
GET http://192.168.1.42/settings?mode=color
```

### White moduna geç (4 bağımsız tek renkli strip)
```
GET http://192.168.1.42/settings?mode=white
```

⚠️ Mod değişikliği sonrası cihaz yeniden başlar.

---

# COLOR MODE (RGB + W birleşik)

## 3. Aç / Kapat

### Aç (önceki rengiyle)
```
GET http://192.168.1.42/color/0?turn=on
```

### Kapat
```
GET http://192.168.1.42/color/0?turn=off
```

### Toggle
```
GET http://192.168.1.42/color/0?turn=toggle
```

### Durum
```
GET http://192.168.1.42/color/0
```

**Cevap:**
```json
{
  "ison": true,
  "mode": "color",
  "red": 255,
  "green": 100,
  "blue": 0,
  "white": 0,
  "gain": 80,
  "effect": 0,
  "transition": 0,
  "source": "http"
}
```

---

## 4. RGB Renk Ayarlama

### Saf kırmızı
```
GET http://192.168.1.42/color/0?turn=on&red=255&green=0&blue=0&white=0
```

### Saf yeşil
```
GET http://192.168.1.42/color/0?turn=on&red=0&green=255&blue=0
```

### Saf mavi
```
GET http://192.168.1.42/color/0?turn=on&red=0&green=0&blue=255
```

### Beyaz LED ile karışım
```
GET http://192.168.1.42/color/0?turn=on&red=255&green=200&blue=100&white=128
```

`red`, `green`, `blue`, `white` her biri **0-255** arası.

---

## 5. Parlaklık (Gain)

`gain` parametresi RGB kanallarının ortak parlaklığını (0-100) belirler.

### Renk + parlaklık
```
GET http://192.168.1.42/color/0?turn=on&red=255&green=0&blue=0&gain=50
```

### Sadece parlaklık değiştir
```
GET http://192.168.1.42/color/0?gain=30
```

> `gain` sadece RGB kanallarına etki eder. `white` kanalı kendi parlaklığını korur.

---

## 6. Geçiş Süresi (Transition)

```
GET http://192.168.1.42/color/0?turn=on&red=0&green=200&blue=100&transition=2000
```

`transition` milisaniye cinsinden, 0-5000 arası.

### Yavaş söndür
```
GET http://192.168.1.42/color/0?turn=off&transition=5000
```

---

## 7. Efektler (Color Mode)

### Efekt seç
```
GET http://192.168.1.42/color/0?effect=1
```

| Efekt ID | Açıklama |
|---|---|
| 0 | Efekt yok (sabit renk) |
| 1 | Meteor shower (renk akışı) |
| 2 | Gradual change (yumuşak renk geçişi) |
| 3 | Flash (yanıp sönen) |

### Efekti kapat
```
GET http://192.168.1.42/color/0?effect=0
```

---

## 8. Auto-off / Auto-on

```
GET http://192.168.1.42/color/0?turn=on&timer=300
```

---

# WHITE MODE (4 Bağımsız Kanal)

## 9. Tek Kanal Kontrolü (white mode)

White mode'da 4 kanal var: 0, 1, 2, 3.

### Kanal 0'ı aç
```
GET http://192.168.1.42/white/0?turn=on&brightness=80
```

### Kanal 1'i kapat
```
GET http://192.168.1.42/white/1?turn=off
```

### Tüm kanalları aynı anda (4 ayrı GET)
```
http://192.168.1.42/white/0?turn=on&brightness=100
http://192.168.1.42/white/1?turn=on&brightness=100
http://192.168.1.42/white/2?turn=on&brightness=100
http://192.168.1.42/white/3?turn=on&brightness=100
```

### Durum
```
GET http://192.168.1.42/white/0
```

---

## 10. Konfigürasyon

### Power-on davranışı
```
GET http://192.168.1.42/settings/color/0?default_state=off|on|last|switch
GET http://192.168.1.42/settings/white/0?default_state=off|on|last|switch
```

### Maksimum güç koruması
```
GET http://192.168.1.42/settings?max_power=300
```

### Buton modu
```
GET http://192.168.1.42/settings?btn_type=momentary|toggle|edge|detached
```

---

## 11. Schedule

```
GET http://192.168.1.42/settings/color/0?schedule=1
```

---

## 12. MQTT Topic'leri

Color mode:
- `shellies/shellyrgbw2-XXX/color/0/status` — JSON durum
- `shellies/shellyrgbw2-XXX/color/0/command` — `on`/`off`/`toggle`
- `shellies/shellyrgbw2-XXX/color/0/set` — JSON: `{"turn": "on", "red": 255, ...}`

White mode (4 kanal):
- `shellies/shellyrgbw2-XXX/white/0/status` ... white/3/status
- `shellies/shellyrgbw2-XXX/white/0/command` — `on`/`off`/`toggle`
- `shellies/shellyrgbw2-XXX/white/0/brightness` — sayı

---

## 13. Webhook / Actions

Action isimleri:
- `out_on_url`, `out_off_url`
- `btn_on_url`, `btn_off_url`
- `longpush_url`, `shortpush_url`

---

## 14. Cihaz Yönetimi

```
GET http://192.168.1.42/reboot
GET http://192.168.1.42/ota?update=true
```

---

## SKAPI Action Şablonları

### "RGB renk ayarla (color mode)"
```yaml
id: shelly-rgbw2-color
name: "Shelly RGBW2 - Renk Ayarla"
category: smarthome
target: shelly-rgbw2-color
protocol: http
method: GET
url: "http://{ip}/color/0?turn=on&red={r}&green={g}&blue={b}&gain={brightness}"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: r, label: "Kırmızı (0-255)", type: int, default: 255 }
  - { key: g, label: "Yeşil (0-255)", type: int, default: 0 }
  - { key: b, label: "Mavi (0-255)", type: int, default: 0 }
  - { key: brightness, label: "Parlaklık (0-100)", type: int, default: 80 }
```

### "Strip kapat"
```yaml
id: shelly-rgbw2-off
name: "Shelly RGBW2 - Kapat"
category: smarthome
target: shelly-rgbw2
protocol: http
method: GET
url: "http://{ip}/color/0?turn=off"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### "Yumuşak fade (3 sn'de yeni renge)"
```yaml
id: shelly-rgbw2-fade
name: "Shelly RGBW2 - Renk Geçişi"
category: smarthome
target: shelly-rgbw2-color
protocol: http
method: GET
url: "http://{ip}/color/0?turn=on&red={r}&green={g}&blue={b}&transition={fade}"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: r, label: "R", type: int, default: 100 }
  - { key: g, label: "G", type: int, default: 100 }
  - { key: b, label: "B", type: int, default: 200 }
  - { key: fade, label: "Geçiş süresi (ms)", type: int, default: 3000 }
```

### "Efekt başlat (Meteor shower)"
```yaml
id: shelly-rgbw2-effect
name: "Shelly RGBW2 - Efekt Başlat"
category: smarthome
target: shelly-rgbw2-color
protocol: http
method: GET
url: "http://{ip}/color/0?turn=on&effect={effect}"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: effect, label: "Efekt (0-3)", type: int, min: 0, max: 3, default: 1 }
```

### "White mode tek kanal"
```yaml
id: shelly-rgbw2-white
name: "Shelly RGBW2 - White Kanal"
category: smarthome
target: shelly-rgbw2-white
protocol: http
method: GET
url: "http://{ip}/white/{channel}?turn=on&brightness={brightness}"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: channel, label: "Kanal (0-3)", type: int, min: 0, max: 3 }
  - { key: brightness, label: "Parlaklık (0-100)", type: int, default: 80 }
```
