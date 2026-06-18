# Wiz Color (RGB) Bulb — Tam API Komut Listesi

**Cihaz:** Wiz Connected — RGB renkli ampul (full color + tunable white)
**Modeller:** A60 Color, A21 Color, BR30 Color, GU10 Color, ST64 Color, G80/G95 Color, Candle Color, vb. ("Color" etiketli tüm Wiz ampuller)
**Protokol:** UDP, port 38899
**Format:** JSON
**Auth:** Yok (yerel ağ)

> **Tam destek:** on/off, parlaklık, RGB renk, beyaz tonu (Kelvin), 32 sahne, sahne hızı.
> White bulb'tan farklı: `r`, `g`, `b` parametreleri çalışır + tüm 32 sahne destekler.

---

## 1. Cihaz Bilgileri

### Mevcut durum
```
UDP → 192.168.1.42:38899
{
  "method": "getPilot",
  "params": {}
}
```

**Cevap (renk modunda):**
```json
{
  "method": "getPilot",
  "env": "pro",
  "result": {
    "mac": "...",
    "rssi": -55,
    "src": "udp",
    "state": true,
    "sceneId": 0,
    "r": 255,
    "g": 100,
    "b": 0,
    "c": 0,
    "w": 0,
    "dimming": 75
  }
}
```

**Cevap (beyaz modunda):**
```json
{
  "result": {
    "state": true,
    "sceneId": 0,
    "temp": 3000,
    "dimming": 50
  }
}
```

> Cihaz **renk modunda** ya da **beyaz modunda** olur. `r/g/b` ile `temp` aynı anda kullanılamaz.

### Sistem bilgisi (cihaz tipi tespiti)
```json
{
  "method": "getSystemConfig",
  "params": {}
}
```

**Cevap:**
```json
{
  "result": {
    "mac": "...",
    "moduleName": "ESP01_SHRGB1C_31",  // ← RGB modeli
    "fwVersion": "1.30.2"
  }
}
```

`moduleName` içinde `RGB` veya `SHRGB` geçiyorsa bu dosyadaki tüm komutlar geçerli.

---

## 2. Aç / Kapat

### Aç (önceki ayarlarla)
```json
{
  "method": "setPilot",
  "params": { "state": true }
}
```

### Kapat
```json
{
  "method": "setPilot",
  "params": { "state": false }
}
```

### Toggle — manuel
```
1. getPilot → {"state": true}
2. setPilot → {"state": false}
```

---

## 3. Parlaklık (Dimming)

```json
{
  "method": "setPilot",
  "params": { "state": true, "dimming": 50 }
}
```

`dimming` aralığı: **10-100**. Düşüğü kapalıdır (`state: false`).

---

## 4. RGB Renk

### Saf kırmızı
```json
{
  "method": "setPilot",
  "params": { "state": true, "r": 255, "g": 0, "b": 0 }
}
```

### Saf yeşil
```json
{
  "method": "setPilot",
  "params": { "state": true, "r": 0, "g": 255, "b": 0 }
}
```

### Saf mavi
```json
{
  "method": "setPilot",
  "params": { "state": true, "r": 0, "g": 0, "b": 255 }
}
```

### Mor (kırmızı + mavi)
```json
{
  "method": "setPilot",
  "params": { "state": true, "r": 200, "g": 0, "b": 200 }
}
```

### Turuncu (kırmızı + biraz yeşil)
```json
{
  "method": "setPilot",
  "params": { "state": true, "r": 255, "g": 100, "b": 0 }
}
```

### Renk + parlaklık birlikte
```json
{
  "method": "setPilot",
  "params": { "state": true, "r": 0, "g": 100, "b": 255, "dimming": 60 }
}
```

> `r`, `g`, `b` her biri **0-255** arası.
> Üçü birlikte gönderilmelidir (eksik gönderilirse undefined davranış).

### HEX renk → RGB dönüşümü
| HEX | R | G | B |
|---|---|---|---|
| `#FF0000` (kırmızı) | 255 | 0 | 0 |
| `#00FF00` (yeşil) | 0 | 255 | 0 |
| `#0000FF` (mavi) | 0 | 0 | 255 |
| `#FFFF00` (sarı) | 255 | 255 | 0 |
| `#FF00FF` (magenta) | 255 | 0 | 255 |
| `#00FFFF` (cyan) | 0 | 255 | 255 |
| `#FFA500` (turuncu) | 255 | 165 | 0 |
| `#800080` (mor) | 128 | 0 | 128 |
| `#FFC0CB` (pembe) | 255 | 192 | 203 |
| `#008000` (orman yeşili) | 0 | 128 | 0 |

---

## 5. Beyaz Mod (Kelvin)

RGB bulb da tunable beyaz modu destekler — daha iyi beyaz aydınlatma için.

### Beyaz moda geç (renkten çık)
```json
{
  "method": "setPilot",
  "params": { "state": true, "temp": 3000 }
}
```

> `temp` gönderildiğinde cihaz **beyaz moda** geçer ve `r/g/b` etkisini kaybeder.

### Aralık: 2200K - 6500K

| Kelvin | Karşılık |
|---|---|
| 2200 | Mum / amber |
| 2700 | Sıcak akkor |
| 3000 | Sıcak beyaz |
| 4000 | Doğal beyaz |
| 5000 | Beyaz |
| 6500 | Soğuk gün ışığı |

### Beyaz + parlaklık
```json
{
  "method": "setPilot",
  "params": { "state": true, "temp": 4000, "dimming": 80 }
}
```

---

## 6. Cool / Warm White Kanalları (RGBCW Modeller)

Bazı Wiz Color modeller **5 kanal** destekler: R, G, B, **Cool White (C)**, **Warm White (W)**.
Bu, daha doğal beyaz üretim için RGB ile beyaz LED'leri karıştırır.

### Sıcak ve soğuk beyaz LED'leri ayrı ayrı kontrol
```json
{
  "method": "setPilot",
  "params": { "state": true, "c": 255, "w": 0 }
}
```
Sadece soğuk beyaz LED'i tam aç.

```json
{
  "method": "setPilot",
  "params": { "state": true, "c": 0, "w": 255 }
}
```
Sadece sıcak beyaz LED'i tam aç.

```json
{
  "method": "setPilot",
  "params": { "state": true, "c": 128, "w": 128 }
}
```
İki beyaz kanal yarı yarıya (~doğal beyaz).

> Bu cihazda yoksa parametre ignore edilir.

---

## 7. Sahneler (32 Sahne — Renkli Bulb Tüm Sahneleri Destekler)

### Sahneye geç
```json
{
  "method": "setPilot",
  "params": { "state": true, "sceneId": 4 }
}
```

### Sahne + hız
```json
{
  "method": "setPilot",
  "params": { "state": true, "sceneId": 4, "speed": 150 }
}
```

`speed` 10-200 arası. Düşük = yavaş, yüksek = hızlı animasyon.

### Sahne + parlaklık
```json
{
  "method": "setPilot",
  "params": { "state": true, "sceneId": 1, "dimming": 70 }
}
```

### Tüm 32 Sahne Listesi

| ID | Sahne | Tanım | Dinamik mi |
|---|---|---|---|
| 1 | Ocean | Mavi-yeşil dalga | ✅ |
| 2 | Romance | Pembe-mor yumuşak | ✅ |
| 3 | Sunset | Turuncu-mor geçiş | ✅ |
| 4 | Party | Çok hızlı renk değişimi | ✅✅✅ |
| 5 | Fireplace | Sıcak amber titreşim | ✅ |
| 6 | Cozy | Sıcak sabit | — |
| 7 | Forest | Yeşil tonları | ✅ |
| 8 | Pastel Colors | Yumuşak renkler dönüşümlü | ✅ |
| 9 | Wake up | Karanlıktan parlaklığa yavaş | ✅ |
| 10 | Bedtime | Yavaşça sönüş | ✅ |
| 11 | Warm white | Sabit sıcak | — |
| 12 | Daylight | Sabit doğal beyaz | — |
| 13 | Cool white | Sabit soğuk beyaz | — |
| 14 | Night light | Kısık sıcak | — |
| 15 | Focus | Parlak soğuk beyaz | — |
| 16 | Relax | Sıcak yumuşak beyaz | — |
| 17 | True colors | Sabit canlı renk | — |
| 18 | TV time | Mavi tonları (gece izleme) | ✅ |
| 19 | Plantgrowth | Pembe-mor (bitki spektrumu) | — |
| 20 | Spring | Yeşil-pembe canlı | ✅ |
| 21 | Summer | Sarı-turuncu sıcak | ✅ |
| 22 | Fall | Turuncu-kırmızı sonbahar | ✅ |
| 23 | Deep dive | Mavi tonları | ✅ |
| 24 | Jungle | Yeşil tonları | ✅ |
| 25 | Mojito | Yeşil-sarı | ✅ |
| 26 | Club | Çok hızlı parti renkleri | ✅✅✅ |
| 27 | Christmas | Kırmızı-yeşil dönüşüm | ✅ |
| 28 | Halloween | Turuncu-mor | ✅ |
| 29 | Candlelight | Mum titreşimi | ✅ |
| 30 | Golden white | Sıcak altın | — |
| 31 | Pulse | Renkli nabız | ✅ |
| 32 | Steampunk | Sıcak amber dönen | ✅ |

---

## 8. Pulse (Identify / Yanıp Söndür)

```json
{
  "method": "pulse",
  "params": { "delta": -80, "duration": 500 }
}
```

`delta` = parlaklık değişim (negatif = kısık).
`duration` = milisaniye.

---

## 9. Schedule

### Schedule listele
```json
{ "method": "getSchedule", "params": {} }
```

### Schedule ekle
```json
{
  "method": "setSchedule",
  "params": {
    "schdId": 1,
    "name": "Sabah Modu",
    "active": true,
    "type": "DAILY",
    "hour": 7,
    "minute": 0,
    "scene": { "sceneId": 9, "dimming": 100, "speed": 30 }
  }
}
```

---

## 10. Kullanıcı Tercihleri

### Power-on davranışı
```json
{
  "method": "setUserConfig",
  "params": {
    "userConfig": {
      "powerOnState": "ON_LAST",
      "defaultDimming": 70,
      "defaultColor": { "r": 255, "g": 200, "b": 100 }
    }
  }
}
```

---

## 11. Cihaz Yönetimi

### Yeniden başlat
```json
{ "method": "reboot", "params": {} }
```

### Fabrika ayarları
```json
{ "method": "reset", "params": {} }
```

---

## 12. Discovery (Broadcast)

```
UDP → 255.255.255.255:38899
{ "method": "getPilot", "params": {} }
```

Yerel ağdaki tüm Wiz cihazları cevap verir.

---

## SKAPI Action Şablonu Örnekleri

### Şablon: "Aç"
```yaml
id: wiz-color-on
name: "Wiz Color - Aç"
category: smarthome
target: wiz-color
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Kapat"
```yaml
id: wiz-color-off
name: "Wiz Color - Kapat"
category: smarthome
target: wiz-color
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": false } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Belirli renge ayarla (RGB picker)"
```yaml
id: wiz-color-rgb
name: "Wiz Color - Renk Seç"
category: smarthome
target: wiz-color
protocol: udp
port: 38899
payload: {
  "method": "setPilot",
  "params": { "state": true, "r": "{r}", "g": "{g}", "b": "{b}", "dimming": "{brightness}" }
}
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: r, label: "Kırmızı (0-255)", type: int, min: 0, max: 255, default: 255 }
  - { key: g, label: "Yeşil (0-255)", type: int, min: 0, max: 255, default: 0 }
  - { key: b, label: "Mavi (0-255)", type: int, min: 0, max: 255, default: 0 }
  - { key: brightness, label: "Parlaklık (10-100)", type: int, min: 10, max: 100, default: 80 }
```

> **SKAPP UI ipucu:** `type: color` kullanırsa color picker gösterir, sonra HEX'i RGB'ye çevirip 3 parametre olarak gönderir.

### Şablon: "HEX renk ile" (color picker UI)
```yaml
id: wiz-color-hex
name: "Wiz Color - HEX Renk"
category: smarthome
target: wiz-color
protocol: udp
port: 38899
payload: {
  "method": "setPilot",
  "params": { "state": true, "r": "{hex.r}", "g": "{hex.g}", "b": "{hex.b}", "dimming": "{brightness}" }
}
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: hex, label: "Renk", type: color, default: "#FF0000" }
  - { key: brightness, label: "Parlaklık (10-100)", type: int, default: 80 }
```

### Şablon: "Beyaz tonu ayarla (Kelvin)"
```yaml
id: wiz-color-temp
name: "Wiz Color - Beyaz Tonu"
category: smarthome
target: wiz-color
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true, "temp": "{kelvin}", "dimming": "{brightness}" } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: kelvin, label: "Kelvin (2200-6500)", type: int, min: 2200, max: 6500, default: 3000 }
  - { key: brightness, label: "Parlaklık", type: int, default: 70 }
```

### Şablon: "Mola sahnesi (mavi yumuşak)"
```yaml
id: wiz-color-break
name: "Wiz Color - Mola Modu"
category: smarthome
target: wiz-color
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true, "r": 50, "g": 100, "b": 200, "dimming": 30 } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Çalışma sahnesi (Focus)"
```yaml
id: wiz-color-focus
name: "Wiz Color - Çalışma Modu"
category: smarthome
target: wiz-color
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true, "sceneId": 15, "dimming": 100 } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Parti modu (renkli + hızlı)"
```yaml
id: wiz-color-party
name: "Wiz Color - Parti"
category: smarthome
target: wiz-color
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true, "sceneId": 4, "speed": 200, "dimming": 100 } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Yumuşak uyandırma"
```yaml
id: wiz-color-wakeup
name: "Wiz Color - Uyandırma"
category: smarthome
target: wiz-color
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true, "sceneId": 9, "speed": 30 } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Gece lambası"
```yaml
id: wiz-color-night
name: "Wiz Color - Gece Lambası"
category: smarthome
target: wiz-color
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true, "sceneId": 14 } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Renk pulse (3 kez kırmızı yanıp sönsün)" (multi-action)
```yaml
id: wiz-color-alert-pulse
name: "Wiz Color - Uyarı Pulse"
category: smarthome
target: wiz-color
endpoints:
  - { protocol: udp, port: 38899, payload: { "method": "setPilot", "params": { "state": true, "r": 255, "g": 0, "b": 0, "dimming": 100 } } }
  - { delay_ms: 300 }
  - { protocol: udp, port: 38899, payload: { "method": "setPilot", "params": { "state": false } } }
  - { delay_ms: 300 }
  - { protocol: udp, port: 38899, payload: { "method": "setPilot", "params": { "state": true, "r": 255, "g": 0, "b": 0, "dimming": 100 } } }
  - { delay_ms: 300 }
  - { protocol: udp, port: 38899, payload: { "method": "setPilot", "params": { "state": false } } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

---

## Sorun Giderme

- Renk değişmiyor → cihaz beyaz modunda olabilir; `r/g/b` gönderirken `temp` göndermeyi bırak
- Sahne çalışmıyor → cihaz White only olabilir, `getSystemConfig` ile model kontrolü yap
- Parlaklık çok düşük çalışmıyor → minimum 10
- UDP cevabı gelmiyor → cevap garantisi yok; ESP32 fire-and-forget olarak gönderebilir
- Discover broadcast cevap vermiyor → router multicast/broadcast'i bloklayabilir, manuel IP gir

---

## Renk + Parlaklık Konsepti — Önemli Not

Wiz'de `r/g/b` değerleri **renk oranını** belirler, mutlak parlaklığı değil.
Asıl parlaklığı `dimming` parametresi belirler.

| Komut | Sonuç |
|---|---|
| `r:255, g:0, b:0, dimming:100` | Tam parlak kırmızı |
| `r:255, g:0, b:0, dimming:30` | Kısık kırmızı |
| `r:128, g:0, b:0, dimming:100` | Tam parlak yine kırmızı (oran aynı) |
| `r:255, g:128, b:64, dimming:50` | Yarı parlak turuncu-kırmızı |

Bu, eğer **mutlak HEX → bulb** dönüşümü yapıyorsan: HEX'in en parlak bileşenini 255'e normalize edip oranını koru, ardından gerçek parlaklığı `dimming` ile ayarla.
