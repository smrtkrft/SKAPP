# Shelly Plus 2PM (Gen2) — Tam API Komut Listesi

**Model:** SNSW-002P16EU
**Nesil:** Gen2 / Plus
**Özellikler:** **2 kanal** röle + güç ölçümü her kanalda + roller (panjur/perde) modu
**Maks yük:** 10A kanal başına
**Protokol:** HTTP RPC API, MQTT, WebSocket, BLE

> Shelly 2.5 (Gen1)'in Plus eşdeğeri. Aynı 2-channel + roller mimarisi, RPC API ile.

---

## 1. Cihaz Bilgileri

```
GET http://192.168.1.42/rpc/Shelly.GetDeviceInfo
GET http://192.168.1.42/rpc/Shelly.GetStatus
GET http://192.168.1.42/rpc/Shelly.GetConfig
```

### Cihaz profilini öğren (relay vs cover)
```
GET http://192.168.1.42/rpc/Sys.GetConfig
```

`device.profile` alanı:
- `"switch"` → 2 bağımsız röle (Switch.Set kullan)
- `"cover"` → roller motoru (Cover.Open/Close/Stop kullan)

### Profil değiştir
```http
POST http://192.168.1.42/rpc

{ "method": "Sys.SetConfig", "params": { "config": { "device": { "profile": "switch" } } } }
```

veya `"cover"`. Cihaz yeniden başlar.

---

# SWITCH PROFILE (2 Bağımsız Röle)

## 2. Kanal 0 Kontrolü

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

### Durum
```
GET http://192.168.1.42/rpc/Switch.GetStatus?id=0
```

### N saniye sonra toggle (auto-off effect)
```
GET http://192.168.1.42/rpc/Switch.Set?id=0&on=true&toggle_after=30
```

## 3. Kanal 1 Kontrolü

```
GET http://192.168.1.42/rpc/Switch.Set?id=1&on=true
GET http://192.168.1.42/rpc/Switch.Set?id=1&on=false
GET http://192.168.1.42/rpc/Switch.Toggle?id=1
GET http://192.168.1.42/rpc/Switch.GetStatus?id=1
```

## 4. İki Kanalı Aynı Anda

İki ayrı istek gerekir veya MQTT üzerinden paralel:
```
http://192.168.1.42/rpc/Switch.Set?id=0&on=true
http://192.168.1.42/rpc/Switch.Set?id=1&on=true
```

## 5. Switch Konfigürasyonu

```http
POST http://192.168.1.42/rpc

{
  "method": "Switch.SetConfig",
  "params": {
    "id": 0,
    "config": {
      "name": "Üst Lamba",
      "in_mode": "follow",
      "initial_state": "restore_last",
      "auto_on": false,
      "auto_off": false,
      "auto_off_delay": 60,
      "power_limit": 2300,
      "voltage_limit": 280,
      "current_limit": 10
    }
  }
}
```

## 6. Güç Ölçümü (Her Kanal)

`Switch.GetStatus` cevabı içinde `apower`, `voltage`, `current`, `pf`, `aenergy.total`, `temperature` var.

---

# COVER PROFILE (Roller / Perde / Panjur)

## 7. Cover Kontrolü

### Aç (yukarı)
```
GET http://192.168.1.42/rpc/Cover.Open?id=0
```

### Kapat (aşağı)
```
GET http://192.168.1.42/rpc/Cover.Close?id=0
```

### Durdur
```
GET http://192.168.1.42/rpc/Cover.Stop?id=0
```

### Belirli pozisyona git (0-100)
```
GET http://192.168.1.42/rpc/Cover.GoToPosition?id=0&pos=50
```

### Belirli sürede aç (override)
```
GET http://192.168.1.42/rpc/Cover.Open?id=0&duration=5
```
5 saniye boyunca açma yönüne hareket.

### Cover durumu
```
GET http://192.168.1.42/rpc/Cover.GetStatus?id=0
```

**Cevap:**
```json
{
  "id": 0,
  "source": "http",
  "state": "stopped",        // stopped | opening | closing | open | closed | calibrating
  "apower": 0,
  "voltage": 230.5,
  "current": 0,
  "pf": 0,
  "aenergy": { "total": 0 },
  "current_pos": 50,
  "target_pos": null,
  "move_timeout": 60,
  "move_started_at": ...,
  "pos_control": true,
  "safety_switch": false
}
```

## 8. Cover Kalibrasyon

```http
POST http://192.168.1.42/rpc

{ "method": "Cover.Calibrate", "params": { "id": 0 } }
```

Cihaz kendini açıp kapatarak süreleri öğrenir.

## 9. Cover Konfigürasyonu

```http
POST http://192.168.1.42/rpc

{
  "method": "Cover.SetConfig",
  "params": {
    "id": 0,
    "config": {
      "name": "Salon Perdesi",
      "motor": {
        "idle_power_thr": 2,        // motor durdu sayılan W eşiği
        "idle_confirm_period": 0.25
      },
      "maxtime_open": 18,           // saniye
      "maxtime_close": 20,
      "initial_state": "stopped",
      "invert_directions": false,
      "in_mode": "dual",            // dual | detached | single
      "swap_inputs": false,
      "obstruction_detection": {
        "enable": true,
        "direction": "both",
        "action": "stop",
        "power_thr": 1000
      },
      "safety_switch": {
        "enable": true,
        "direction": "both",
        "action": "stop",
        "allowed_move_before_safety_switch_on": 50
      }
    }
  }
}
```

---

## 10. Schedule

```http
POST http://192.168.1.42/rpc

{
  "method": "Schedule.Create",
  "params": {
    "enable": true,
    "timespec": "0 0 8 * * *",        // her gün 08:00
    "calls": [
      { "method": "Cover.Open", "params": { "id": 0 } }
    ]
  }
}
```

---

## 11. Webhooks

### Switch event'leri
```http
POST http://192.168.1.42/rpc

{
  "method": "Webhook.Create",
  "params": {
    "cid": 0,
    "enable": true,
    "event": "switch.on",
    "urls": ["http://YOUR-SERVER/notify"]
  }
}
```

### Cover event'leri
- `cover.opening`
- `cover.closing`
- `cover.stopped`
- `cover.calibrating`
- `cover.open`
- `cover.closed`
- `cover.partially_open`
- `cover.obstruction_detected`
- `cover.safety_switch_triggered`

---

## 12. MQTT Topic'leri

Switch profile:
- `prefix/status/switch:0`, `status/switch:1`
- `prefix/command/switch:0` — `on`/`off`/`toggle`

Cover profile:
- `prefix/status/cover:0`
- `prefix/command/cover:0` — `open`/`close`/`stop`
- `prefix/command/cover:0/pos` — pozisyon (0-100)

---

## 13. Cihaz Yönetimi

```
GET http://192.168.1.42/rpc/Shelly.Reboot
POST http://192.168.1.42/rpc { "method": "Shelly.Update", "params": { "stage": "stable" } }
POST http://192.168.1.42/rpc { "method": "Shelly.FactoryReset" }
```

---

## SKAPI Action Şablonları

### Switch profile

#### "Kanal 0 Aç"
```yaml
id: shelly-plus2pm-ch0-on
name: "Shelly Plus 2PM - Kanal 0 Aç"
category: smarthome
target: shelly-plus2pm-switch
protocol: http
method: GET
url: "http://{ip}/rpc/Switch.Set?id=0&on=true"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

#### "Kanal 1 Aç"
```yaml
id: shelly-plus2pm-ch1-on
name: "Shelly Plus 2PM - Kanal 1 Aç"
target: shelly-plus2pm-switch
protocol: http
method: GET
url: "http://{ip}/rpc/Switch.Set?id=1&on=true"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

#### "İki kanal birden aç" (multi-action)
```yaml
id: shelly-plus2pm-both-on
name: "Shelly Plus 2PM - İki Kanal Aç"
target: shelly-plus2pm-switch
endpoints:
  - { protocol: http, method: GET, url: "http://{ip}/rpc/Switch.Set?id=0&on=true" }
  - { protocol: http, method: GET, url: "http://{ip}/rpc/Switch.Set?id=1&on=true" }
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Cover profile

#### "Perde aç (yukarı)"
```yaml
id: shelly-plus2pm-cover-open
name: "Shelly Plus 2PM Perde - Aç"
target: shelly-plus2pm-cover
protocol: http
method: GET
url: "http://{ip}/rpc/Cover.Open?id=0"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

#### "Perde %50 aç"
```yaml
id: shelly-plus2pm-cover-50
name: "Shelly Plus 2PM Perde - %50"
target: shelly-plus2pm-cover
protocol: http
method: GET
url: "http://{ip}/rpc/Cover.GoToPosition?id=0&pos={position}"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: position, label: "Pozisyon (0-100)", type: int, default: 50 }
```

#### "Perde durdur"
```yaml
id: shelly-plus2pm-cover-stop
name: "Shelly Plus 2PM Perde - Durdur"
target: shelly-plus2pm-cover
protocol: http
method: GET
url: "http://{ip}/rpc/Cover.Stop?id=0"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```
