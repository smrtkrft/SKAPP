# Shelly Plus i4 (Gen2) — Tam API Komut Listesi

**Model:** SNSN-0024X (AC versiyonu) veya SNSN-0D24X (DC)
**Nesil:** Gen2 / Plus
**Özellikler:** **4 kanal kuru kontak girişi** — röle yok, sadece input. Mevcut anahtar/butonları akıllılaştırır.
**Voltaj:** AC (110-240V) veya DC (5-60V) versiyonu var
**Protokol:** HTTP RPC API, MQTT, WebSocket, BLE

> Plus i4, Gen1 i3'ün 4-kanal RPC versiyonu. Aynı paradigma — sadece input, event üretir.

---

## 1. Cihaz Bilgileri

```
GET http://192.168.1.42/rpc/Shelly.GetDeviceInfo
GET http://192.168.1.42/rpc/Shelly.GetStatus
```

---

## 2. Input Durum Sorgulama

### Tek input durumu
```
GET http://192.168.1.42/rpc/Input.GetStatus?id=0
GET http://192.168.1.42/rpc/Input.GetStatus?id=1
GET http://192.168.1.42/rpc/Input.GetStatus?id=2
GET http://192.168.1.42/rpc/Input.GetStatus?id=3
```

**Cevap:**
```json
{
  "id": 0,
  "state": false           // şu anki durum (true=aktif)
}
```

### Tüm input'ları aynı anda (Shelly.GetStatus üzerinden)
```
GET http://192.168.1.42/rpc/Shelly.GetStatus
```

`input:0`, `input:1`, `input:2`, `input:3` alanları gelir.

---

## 3. Input Konfigürasyonu

### Config oku
```
GET http://192.168.1.42/rpc/Input.GetConfig?id=0
```

### Config değiştir
```http
POST http://192.168.1.42/rpc

{
  "method": "Input.SetConfig",
  "params": {
    "id": 0,
    "config": {
      "name": "Salon Anahtarı",
      "type": "switch",         // switch | button | analog
      "invert": false,
      "factory_reset": false,
      "enable": true
    }
  }
}
```

### Input tipi açıklaması

| Tip | Açıklama |
|---|---|
| `switch` | Klasik anahtar — sadece on/off event'leri |
| `button` | Buton — short/long/double/triple push event'leri destekler |
| `analog` | Analog giriş (sadece Plus i4 DC) — voltaj okur |

---

## 4. Webhook'lar (Asıl Özellik)

i4'ün gücü — input event'lerine göre HTTP/MQTT tetikle.

### Switch tipi event'ler
- `input.toggle_on` — anahtar HIGH oldu
- `input.toggle_off` — anahtar LOW oldu

### Button tipi event'ler
- `input.btn_up`, `input.btn_down` — fiziksel basma/bırakma
- `input.short_push` — kısa bas
- `input.long_push` — uzun bas
- `input.double_push` — çift bas
- `input.triple_push` — üçlü bas

### Webhook ekle (input 0, kısa bas → SKAPP'e tetikleyici git)
```http
POST http://192.168.1.42/rpc

{
  "method": "Webhook.Create",
  "params": {
    "cid": 0,                     // input id (0-3)
    "enable": true,
    "event": "input.short_push",
    "urls": ["http://192.168.1.50:5000/api/i4-event?ch=0&type=short"]
  }
}
```

### Birden fazla URL aynı event için
```json
{
  "method": "Webhook.Create",
  "params": {
    "cid": 0,
    "enable": true,
    "event": "input.short_push",
    "urls": [
      "http://server1/a",
      "http://server2/b"
    ]
  }
}
```

### Webhook listesi
```
GET http://192.168.1.42/rpc/Webhook.List
```

### Sil
```http
POST http://192.168.1.42/rpc

{ "method": "Webhook.Delete", "params": { "id": 1 } }
```

---

## 5. MQTT Topic'leri

```
prefix/status/input:0
prefix/status/input:1
prefix/status/input:2
prefix/status/input:3
prefix/events/input:0       — JSON event akışı
```

JSON event örneği:
```json
{
  "component": "input:0",
  "event": "single_push",
  "ts": 1709123456
}
```

---

## 6. WebSocket Real-time

```
ws://192.168.1.42/rpc
```

Tüm event'ler bağlantı boyunca akar. SKAPP burada subscribe ederek manuel buton tetiklerini anlık alır.

---

## 7. Schedule

```http
POST http://192.168.1.42/rpc

{
  "method": "Schedule.Create",
  "params": {
    "enable": true,
    "timespec": "0 0 22 * * *",
    "calls": [
      { "method": "Webhook.Create", "params": { ... } }
    ]
  }
}
```

---

## 8. Cihaz Yönetimi

```
GET http://192.168.1.42/rpc/Shelly.Reboot
POST http://192.168.1.42/rpc { "method": "Shelly.Update", "params": { "stage": "stable" } }
POST http://192.168.1.42/rpc { "method": "Shelly.FactoryReset" }
```

---

## SKAPI Şablonları

### "Input durumu oku"
```yaml
id: shelly-plus-i4-status
name: "Plus i4 - Input Durumu Oku"
category: smarthome
target: shelly-plus-i4
protocol: http
method: GET
url: "http://{ip}/rpc/Input.GetStatus?id={channel}"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: channel, label: "Kanal (0-3)", type: int, min: 0, max: 3 }
```

### "i4'ü SKAPP'e bağla (webhook setup)"
```yaml
id: shelly-plus-i4-webhook
name: "Plus i4 - Webhook Bağla"
category: setup
target: shelly-plus-i4
protocol: http
method: POST
url: "http://{ip}/rpc"
body: {
  "method": "Webhook.Create",
  "params": {
    "cid": "{channel}",
    "enable": true,
    "event": "{event}",
    "urls": ["{skapp_url}"]
  }
}
params:
  - { key: ip, label: "Plus i4 IP", type: ip, required: true }
  - { key: channel, label: "Kanal (0-3)", type: int }
  - { key: event, label: "Event tipi", type: enum, options: ["input.short_push", "input.long_push", "input.double_push", "input.triple_push", "input.toggle_on", "input.toggle_off"] }
  - { key: skapp_url, label: "SKAPP webhook URL", type: string }
```

---

## SKAPI içinde Plus i4'ün rolü

i3 ile aynı — **trigger source**. ESP32 tetikleyici alternatifi:

- ESP32 = saatli tetikleyici
- Plus i4 = manuel tetikleyici (duvardaki anahtarla)

İkisi birlikte aynı SKAPP webhook'una event yollayabilir → "ya saatim doldu, ya da manuel butona bastım, mola modu başlasın".

---

## Plus i4 vs i3 Farkları

| Özellik | i3 (Gen1) | Plus i4 (Gen2) |
|---|---|---|
| Kanal sayısı | 3 | 4 |
| API | REST query | JSON-RPC |
| WebSocket event | ❌ | ✅ |
| Webhook event tipleri | 8 | 6 (rebrand) |
| Auth | Basic | Digest |
| BLE | ❌ | ✅ |
| Analog input | ❌ | ✅ (DC sürümünde) |
| Şu sürümde fiyat | Daha ucuz | Daha pahalı |
