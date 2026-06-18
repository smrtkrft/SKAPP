# Shelly Plus 1PM (Gen2) — Tam API Komut Listesi

**Model:** SNSW-001P16EU
**Nesil:** Gen2 / Plus
**Özellikler:** Tek kanal röle + güç ölçümü + sıcaklık sensörü
**Maks yük:** 16A (3680W @ 230V)
**Protokol:** HTTP RPC API (JSON-RPC 2.0), MQTT, WebSocket, BLE
**Varsayılan port:** 80

> Plus 1PM, **Gen1 Shelly 1PM'in JSON-RPC versiyonu**.
> Aynı işlevsellik ama yeni API. Daha güçlü auth (Digest), WebSocket event akışı, gelişmiş schedule.

---

## 1. Cihaz Bilgileri

### Genel info
```
GET http://192.168.1.42/rpc/Shelly.GetDeviceInfo
```

**Cevap:**
```json
{
  "name": "Salon Lambası",
  "id": "shellyplus1pm-XXXXXX",
  "mac": "...",
  "model": "SNSW-001P16EU",
  "gen": 2,
  "fw_id": "...",
  "ver": "1.4.0",
  "app": "Plus1PM",
  "auth_en": false
}
```

### Tam config
```
GET http://192.168.1.42/rpc/Shelly.GetConfig
```

### Tam status (tüm bileşenler)
```
GET http://192.168.1.42/rpc/Shelly.GetStatus
```

### Switch:0 durumu
```
GET http://192.168.1.42/rpc/Switch.GetStatus?id=0
```

**Cevap:**
```json
{
  "id": 0,
  "source": "http",
  "output": true,
  "apower": 142.5,         // anlık W
  "voltage": 230.5,        // V
  "current": 0.62,         // A
  "pf": 0.95,              // power factor
  "freq": 50,              // Hz
  "aenergy": {
    "total": 12345.67,     // toplam Wh
    "by_minute": [...],
    "minute_ts": ...
  },
  "ret_aenergy": {
    "total": 0,            // export Wh (solar)
    ...
  },
  "temperature": { "tC": 42.5, "tF": 108.5 }
}
```

---

## 2. Switch Kontrolü (Ana)

### Aç
```
GET http://192.168.1.42/rpc/Switch.Set?id=0&on=true
```

### Kapat
```
GET http://192.168.1.42/rpc/Switch.Set?id=0&on=false
```

### Toggle
```
GET http://192.168.1.42/rpc/Switch.Toggle?id=0
```

### N saniye sonra otomatik kapat
```
GET http://192.168.1.42/rpc/Switch.Set?id=0&on=true&toggle_after=30
```

`toggle_after` saniye cinsinden — N saniye sonra durumu tersine çevirir.

---

## 3. POST + JSON RPC (Tam yöntem)

```http
POST http://192.168.1.42/rpc
Content-Type: application/json

{
  "id": 1,
  "method": "Switch.Set",
  "params": { "id": 0, "on": true, "toggle_after": 60 }
}
```

---

## 4. Switch Konfigürasyonu

### Tüm config oku
```
GET http://192.168.1.42/rpc/Switch.GetConfig?id=0
```

### Config değiştir
```http
POST http://192.168.1.42/rpc

{
  "method": "Switch.SetConfig",
  "params": {
    "id": 0,
    "config": {
      "name": "Salon Ana",
      "in_mode": "follow",        // follow | flip | activate | detached
      "initial_state": "restore_last",  // off | on | restore_last | match_input
      "auto_on": true,
      "auto_on_delay": 60,
      "auto_off": false,
      "auto_off_delay": 30,
      "power_limit": 2500,        // W üst sınır
      "voltage_limit": 280,       // V üst sınır
      "current_limit": 16         // A üst sınır
    }
  }
}
```

---

## 5. Energy Meter — Detaylı Tüketim

### Tüketim verisi
```
GET http://192.168.1.42/rpc/Switch.GetStatus?id=0
```
`aenergy.total` → toplam Wh.

### Sayaç sıfırla
```http
POST http://192.168.1.42/rpc

{ "method": "Switch.ResetCounters", "params": { "id": 0, "type": ["aenergy"] } }
```

---

## 6. Schedule (Gelişmiş)

### Schedule listesi
```
GET http://192.168.1.42/rpc/Schedule.List
```

### Yeni schedule ekle
```http
POST http://192.168.1.42/rpc

{
  "method": "Schedule.Create",
  "params": {
    "enable": true,
    "timespec": "0 30 22 * * *",       // cron formatı: her gün 22:30
    "calls": [
      { "method": "Switch.Set", "params": { "id": 0, "on": false } }
    ]
  }
}
```

### Schedule sil
```http
POST http://192.168.1.42/rpc

{ "method": "Schedule.Delete", "params": { "id": 1 } }
```

### Tümünü temizle
```http
POST http://192.168.1.42/rpc

{ "method": "Schedule.DeleteAll" }
```

---

## 7. Webhooks (Yeni Sistem)

### Webhook oluştur
```http
POST http://192.168.1.42/rpc

{
  "method": "Webhook.Create",
  "params": {
    "cid": 0,                      // component id (Switch:0)
    "enable": true,
    "event": "switch.on",          // switch.on | switch.off | switch.overpower | ...
    "urls": ["http://YOUR-SERVER/on"]
  }
}
```

### Webhook listele
```
GET http://192.168.1.42/rpc/Webhook.List
```

### Sil
```http
POST http://192.168.1.42/rpc

{ "method": "Webhook.Delete", "params": { "id": 1 } }
```

### Desteklenen event'ler
```
GET http://192.168.1.42/rpc/Webhook.ListSupported
```

Tipik event'ler:
- `switch.on`, `switch.off`, `switch.toggle`
- `switch.overpower`, `switch.overvoltage`, `switch.overcurrent`
- `switch.temperature_over`, `switch.temperature_under`
- `input.toggle_on`, `input.toggle_off`
- `input.btn_up`, `input.btn_down`
- `input.short_push`, `input.long_push`, `input.double_push`, `input.triple_push`

---

## 8. WebSocket Real-time Event

```
ws://192.168.1.42/rpc
```

Bağlanınca tüm event'ler JSON olarak gelir. SKAPP burada subscribe ederek anlık güç değişimlerini takip edebilir.

---

## 9. Input Konfigürasyonu

Plus 1PM'de fiziksel buton bağlantısı (SW terminal).

### Config
```http
POST http://192.168.1.42/rpc

{
  "method": "Input.SetConfig",
  "params": {
    "id": 0,
    "config": {
      "name": "Duvar Anahtarı",
      "type": "switch",          // switch | button
      "invert": false,
      "factory_reset": true
    }
  }
}
```

### Input durumu
```
GET http://192.168.1.42/rpc/Input.GetStatus?id=0
```

---

## 10. MQTT Konfigürasyonu

```http
POST http://192.168.1.42/rpc

{
  "method": "MQTT.SetConfig",
  "params": {
    "config": {
      "enable": true,
      "server": "192.168.1.10:1883",
      "user": "USER",
      "ssl_ca": "*",
      "client_id": "shelly-salon",
      "topic_prefix": "shelly-salon",
      "rpc_ntf": true,
      "status_ntf": true
    }
  }
}
```

Topic örnekleri:
- `shelly-salon/status/switch:0` — durum JSON
- `shelly-salon/command/switch:0` — `on`/`off`/`toggle`
- `shelly-salon/rpc` — RPC istek/cevap
- `shelly-salon/events/rpc` — event akışı

---

## 11. WiFi / Cloud / BLE Konfigürasyonu

### WiFi config
```http
POST http://192.168.1.42/rpc

{
  "method": "Wifi.SetConfig",
  "params": {
    "config": {
      "ap": { "enable": true, "is_open": false },
      "sta": { "ssid": "MyWiFi", "pass": "...", "enable": true }
    }
  }
}
```

### Cloud kapat (SKAPI tamamen yerel)
```http
POST http://192.168.1.42/rpc

{ "method": "Cloud.SetConfig", "params": { "config": { "enable": false } } }
```

### BLE aç/kapat
```http
POST http://192.168.1.42/rpc

{ "method": "BLE.SetConfig", "params": { "config": { "enable": true } } }
```

---

## 12. Authentication

Plus 1PM **Digest Authentication** kullanır. Şifre cihaz ayarlarından kurulur.

### Şifre ayarla
```http
POST http://192.168.1.42/rpc

{ "method": "Shelly.SetAuth", "params": { "user": "admin", "realm": "shellyplus1pm-XXX", "ha1": "MD5_HASH" } }
```

### Auth ile istek
```
http://admin:PASSWORD@192.168.1.42/rpc/Switch.Set?id=0&on=true
```

---

## 13. Cihaz Yönetimi

### Yeniden başlat
```
GET http://192.168.1.42/rpc/Shelly.Reboot
```

### Firmware güncelle (stable)
```http
POST http://192.168.1.42/rpc

{ "method": "Shelly.Update", "params": { "stage": "stable" } }
```

### Beta firmware
```http
POST http://192.168.1.42/rpc

{ "method": "Shelly.Update", "params": { "stage": "beta" } }
```

### Belirli URL'den firmware
```http
POST http://192.168.1.42/rpc

{ "method": "Shelly.Update", "params": { "url": "https://..." } }
```

### Fabrika ayarları
```http
POST http://192.168.1.42/rpc

{ "method": "Shelly.FactoryReset" }
```

---

## SKAPI Action Şablonları

### "Aç"
```yaml
id: shelly-plus1pm-on
name: "Shelly Plus 1PM - Aç"
category: smarthome
target: shelly-plus1pm
protocol: http
method: GET
url: "http://{ip}/rpc/Switch.Set?id=0&on=true"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### "Kapat"
```yaml
id: shelly-plus1pm-off
name: "Shelly Plus 1PM - Kapat"
category: smarthome
target: shelly-plus1pm
protocol: http
method: GET
url: "http://{ip}/rpc/Switch.Set?id=0&on=false"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### "X saniye sonra kapat"
```yaml
id: shelly-plus1pm-pulse
name: "Shelly Plus 1PM - Geçici Aç"
category: smarthome
target: shelly-plus1pm
protocol: http
method: GET
url: "http://{ip}/rpc/Switch.Set?id=0&on=true&toggle_after={duration}"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: duration, label: "Süre (sn)", type: int, default: 30 }
```

### "Anlık güç oku"
```yaml
id: shelly-plus1pm-power
name: "Shelly Plus 1PM - Güç Oku"
category: smarthome
target: shelly-plus1pm
protocol: http
method: GET
url: "http://{ip}/rpc/Switch.GetStatus?id=0"
note: "Cevaptaki apower alanı W cinsinden"
```

### "Sayaç sıfırla"
```yaml
id: shelly-plus1pm-reset-counter
name: "Shelly Plus 1PM - Enerji Sayacını Sıfırla"
category: smarthome
target: shelly-plus1pm
protocol: http
method: POST
url: "http://{ip}/rpc"
body: { "method": "Switch.ResetCounters", "params": { "id": 0, "type": ["aenergy"] } }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```
