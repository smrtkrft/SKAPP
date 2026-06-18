# Wiz Tunable White Bulb — Tam API Komut Listesi

**Cihaz:** Wiz Connected — beyaz tunable ampul (sadece beyaz, renk yok)
**Modeller:** A60 White, A60 Tunable, BR30 White, GU10 White, MR16 White, vb. ("White" veya "Tunable" etiketli)
**Protokol:** UDP, port 38899
**Format:** JSON
**Auth:** Yok (yerel ağ)

> **Renk yok!** Sadece on/off, parlaklık, beyaz tonu (Kelvin) ve **sınırlı sahne** (sadece beyaz olanlar) destekler.
> RGB komutu (`r`, `g`, `b`) gönderilirse cihaz cevap vermez veya hata verir.

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

**Cevap:**
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
    "temp": 4000,
    "dimming": 75
  }
}
```

### Sistem konfigürasyonu (cihaz tipi tespiti için)
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
    "homeId": ...,
    "roomId": ...,
    "moduleName": "ESP01_TUNABLE",   // ← cihaz tipi (TUNABLE = white)
    "fwVersion": "1.30.2"
  }
}
```

`moduleName` içinde `TUNABLE` veya `WHITE` geçiyorsa bu dosyadaki komutlar geçerlidir.

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

### Toggle — direkt yok, getPilot ile mevcut state alınır, tersi gönderilir.
```
1. getPilot → {"state": true}
2. setPilot → {"state": false}
```

---

## 3. Parlaklık (Dimming)

### %50 parlaklığa ayarla (açık)
```json
{
  "method": "setPilot",
  "params": { "state": true, "dimming": 50 }
}
```

### %100 (tam parlak)
```json
{
  "method": "setPilot",
  "params": { "state": true, "dimming": 100 }
}
```

### %10 (en kısık — daha düşüğü kabul edilmez)
```json
{
  "method": "setPilot",
  "params": { "state": true, "dimming": 10 }
}
```

> **Not:** `dimming` aralığı **10-100**. 0 veya 1-9 değerleri kabul edilmez.
> %0 = kapalı yapmak için `state: false` kullan.

### Sadece parlaklığı değiştir (durum aynı kalır)
```json
{
  "method": "setPilot",
  "params": { "dimming": 30 }
}
```

---

## 4. Renk Sıcaklığı (Beyaz Tonu — Kelvin)

White bulb'lar **2200K (sıcak amber) ile 6500K (soğuk gün ışığı)** arası destekler.

### Sıcak beyaz (mum gibi, 2700K)
```json
{
  "method": "setPilot",
  "params": { "state": true, "temp": 2700 }
}
```

### Doğal beyaz (4000K)
```json
{
  "method": "setPilot",
  "params": { "state": true, "temp": 4000 }
}
```

### Soğuk gün ışığı (6500K)
```json
{
  "method": "setPilot",
  "params": { "state": true, "temp": 6500 }
}
```

### Hem parlaklık hem sıcaklık aynı anda
```json
{
  "method": "setPilot",
  "params": { "state": true, "dimming": 80, "temp": 3500 }
}
```

### Yaygın Kelvin değerleri ve karşılıkları

| Kelvin | Karşılık |
|---|---|
| 2200 | Mum / amber |
| 2700 | Sıcak akkor (klasik ev ampulü) |
| 3000 | Sıcak beyaz |
| 3500 | Yumuşak beyaz |
| 4000 | Doğal beyaz / nötr |
| 4500 | Beyaz |
| 5000 | Hafif soğuk beyaz |
| 5500 | Gün ışığı |
| 6000 | Soğuk gün ışığı |
| 6500 | Çok soğuk / mavi ton |

---

## 5. Sahneler (Scene) — Sadece Beyaz Sahneler

White bulb sadece **beyaz tabanlı** sahneleri destekler. Renkli sahneler (Ocean, Party vs.) çalışmaz veya en yakın beyaz tona düşürülür.

### Geçerli beyaz sahneler

| ID | Sahne | Açıklama |
|---|---|---|
| 6 | Cozy | Sıcak beyaz, kısık |
| 9 | Wake up | Yavaşça parlaklık artırır (alarm gibi) |
| 10 | Bedtime | Yavaşça söner |
| 11 | Warm white | Sabit sıcak (~2700K) |
| 12 | Daylight | Sabit doğal (~4000K) |
| 13 | Cool white | Sabit soğuk (~5500K) |
| 14 | Night light | Çok kısık sıcak (gece lambası) |
| 15 | Focus | Parlak soğuk beyaz (çalışma için) |
| 16 | Relax | Sıcak yumuşak beyaz |
| 29 | Candlelight | Mum titreşimi (sıcak amber, hafif salınım) |
| 30 | Golden white | Sıcak altın ton |

### Sahneye geç
```json
{
  "method": "setPilot",
  "params": { "state": true, "sceneId": 9 }
}
```

### Sahne hızı (dinamik sahneler için — Wake up, Bedtime, Candlelight)
```json
{
  "method": "setPilot",
  "params": { "state": true, "sceneId": 9, "speed": 50 }
}
```
`speed` 10-200 arası. Düşük = yavaş, yüksek = hızlı.

### Sahne + parlaklık birlikte
```json
{
  "method": "setPilot",
  "params": { "state": true, "sceneId": 16, "dimming": 40 }
}
```

---

## 6. Pulse (Identify / Yanıp Söndür)

Cihazı tanımlamak için kısa süreliğine yanıp söndürür.

```json
{
  "method": "pulse",
  "params": { "delta": -50, "duration": 100 }
}
```

`delta` = parlaklık değişim miktarı (negatif = kısık).
`duration` = milisaniye.

---

## 7. Schedule (Zamanlama)

### Schedule listele
```json
{
  "method": "getSchedule",
  "params": {}
}
```

### Schedule ekle (örn. her gün saat 22:00'de bedtime sahnesi)
```json
{
  "method": "setSchedule",
  "params": {
    "schdId": 1,
    "name": "Gece Modu",
    "active": true,
    "type": "DAILY",
    "hour": 22,
    "minute": 0,
    "scene": { "sceneId": 10, "dimming": 30 }
  }
}
```

---

## 8. Kullanıcı Tercihleri

### Power-on davranışı (cihaz açıldığında ne yapsın)
```json
{
  "method": "setUserConfig",
  "params": {
    "userConfig": {
      "powerOnState": "ON_LAST",  // ON_LAST | ON_DEFAULT | OFF
      "defaultDimming": 50,
      "defaultTemp": 3000
    }
  }
}
```

---

## 9. Cihaz Yönetimi

### Yeniden başlat
```json
{
  "method": "reboot",
  "params": {}
}
```

### Fabrika ayarları
```json
{
  "method": "reset",
  "params": {}
}
```

### Cihazı kayıt et (Wiz app'e bağlamak için)
```json
{
  "method": "registration",
  "params": {
    "phoneMac": "AA:BB:CC:DD:EE:FF",
    "phoneIp": "192.168.1.100",
    "register": true
  }
}
```

---

## 10. Discovery (UDP Broadcast)

Yerel ağdaki tüm Wiz cihazlarını keşfetmek için broadcast:

```
UDP → 255.255.255.255:38899
{
  "method": "getPilot",
  "params": {}
}
```

Tüm Wiz cihazları cevap verir, IP'leri kaydedilir.

---

## SKAPI Action Şablonu Örnekleri

### Şablon: "Aç"
```yaml
id: wiz-white-on
name: "Wiz White - Aç"
category: smarthome
target: wiz-white
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Kapat"
```yaml
id: wiz-white-off
name: "Wiz White - Kapat"
category: smarthome
target: wiz-white
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": false } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Sıcak akşam ayarı (2700K, %30)"
```yaml
id: wiz-white-evening
name: "Wiz White - Akşam Modu"
category: smarthome
target: wiz-white
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true, "temp": 2700, "dimming": 30 } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Yumuşak uyandırma (Wake up sahnesi)"
```yaml
id: wiz-white-wakeup
name: "Wiz White - Yumuşak Uyandırma"
category: smarthome
target: wiz-white
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true, "sceneId": 9, "speed": 50 } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Çalışma modu (Focus)"
```yaml
id: wiz-white-focus
name: "Wiz White - Çalışma"
category: smarthome
target: wiz-white
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true, "sceneId": 15, "dimming": 100 } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Mola sinyali (kısa pulse)"
```yaml
id: wiz-white-pulse
name: "Wiz White - Yanıp Söndür"
category: smarthome
target: wiz-white
protocol: udp
port: 38899
payload: { "method": "pulse", "params": { "delta": -80, "duration": 500 } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Parlaklık ayarla"
```yaml
id: wiz-white-brightness
name: "Wiz White - Parlaklık"
category: smarthome
target: wiz-white
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true, "dimming": "{brightness}" } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: brightness, label: "Parlaklık (10-100)", type: int, min: 10, max: 100, default: 50 }
```

---

## Sorun Giderme

- Cevap gelmiyor → cihaz aynı Wi-Fi'da mı? `ping IP` çalışıyor mu?
- `dimming: 5` çalışmadı → minimum 10. Daha kısık için `state: false` kullan.
- `r, g, b` gönderdim çalışmadı → bu white bulb, RGB yok. `color-bulb.md`'ye bak.
- Sahne çalışıyor ama renkli görünüyor → bu White bulb değil, RGB olabilir. `getSystemConfig` ile `moduleName` kontrol et.
- UDP cevabı kaybolur (firewall) → Wiz UDP cevaplarını engellemediğinden emin ol.

---

## Performans Notları

- UDP olduğu için **cevap garantisi yok** (TCP gibi handshake yok)
- ESP32 fire-and-forget olarak gönderebilir, cevabı beklemese de olur
- Cevap için 100-300ms timeout yeterli
- Aynı komut tekrar gönderilebilir (idempotent)
