# Home Assistant REST API — Tam Kullanım

**Base URL:** `http://{HA_IP}:8123`
**Auth:** `Authorization: Bearer {TOKEN}`
**Format:** JSON

---

## 1. Health Check

```
GET /api/
```

**Cevap:**
```json
{ "message": "API running." }
```

---

## 2. Tüm Entity'ler

```
GET /api/states
```

**Cevap (kısaltılmış):**
```json
[
  {
    "entity_id": "light.salon_lambasi",
    "state": "on",
    "attributes": {
      "brightness": 200,
      "color_mode": "color_temp",
      "color_temp": 350,
      "friendly_name": "Salon Lambası",
      "supported_features": 63
    },
    "last_changed": "2024-...",
    "last_updated": "2024-...",
    "context": { "id": "...", "user_id": "..." }
  },
  ...
]
```

---

## 3. Tek Entity Durumu

```
GET /api/states/light.salon_lambasi
```

---

## 4. Entity Durumunu Set Etme (sadece state, gerçek aksiyon değil!)

```http
POST /api/states/sensor.skapp_break_status
{
  "state": "on_break",
  "attributes": {
    "duration": 60,
    "started_at": "2024-..."
  }
}
```

> **Önemli:** Bu sadece state'i değiştirir, **fiziksel cihazı etkilemez**. Custom sensor/state için kullanılır.
> Cihaz tetikleme için `/api/services/...` kullan.

---

## 5. Services Listesi

```
GET /api/services
```

Tüm domain'ler ve servisleri:
- `light.turn_on`, `light.turn_off`, `light.toggle`
- `switch.turn_on`, `switch.turn_off`, `switch.toggle`
- `cover.open_cover`, `cover.close_cover`, `cover.set_cover_position`
- `media_player.play_media`, `media_player.media_play`, `media_player.media_pause`
- `script.{script_name}` — kullanıcının yazdığı scriptler
- `scene.turn_on` — sahne tetikleme
- `automation.trigger`, `automation.toggle`
- `notify.{service_name}` — bildirim gönder
- `shell_command.{command_name}` — kullanıcı tanımlı shell komutu
- `homeassistant.restart`, `homeassistant.stop`
- ve onlarca daha (entegrasyona göre değişir)

---

## 6. Service Çağırma (En Önemli)

`POST /api/services/{domain}/{service}`

### Işık aç
```http
POST /api/services/light/turn_on
{ "entity_id": "light.salon_lambasi" }
```

### Işık aç + parlaklık + renk
```http
POST /api/services/light/turn_on
{
  "entity_id": "light.salon_lambasi",
  "brightness": 127,
  "rgb_color": [255, 100, 0]
}
```

### Birden fazla ışık (liste)
```http
POST /api/services/light/turn_on
{
  "entity_id": ["light.salon", "light.koridor", "light.mutfak"]
}
```

### Tüm ışıklar (group)
```http
POST /api/services/light/turn_on
{ "entity_id": "all" }
```

### Switch aç/kapat
```http
POST /api/services/switch/turn_on
{ "entity_id": "switch.shelly_plug" }
```

### Cover (perde) aç
```http
POST /api/services/cover/open_cover
{ "entity_id": "cover.salon_perdesi" }
```

### Cover %50 aç
```http
POST /api/services/cover/set_cover_position
{
  "entity_id": "cover.salon_perdesi",
  "position": 50
}
```

### Sahne tetikle
```http
POST /api/services/scene/turn_on
{ "entity_id": "scene.sabah_modu" }
```

### Script çalıştır
```http
POST /api/services/script/turn_on
{ "entity_id": "script.molaya_cik" }
```

veya direkt:
```http
POST /api/services/script/molaya_cik
```

### Otomasyon tetikle
```http
POST /api/services/automation/trigger
{ "entity_id": "automation.aksamlari_isiklar" }
```

### Bildirim gönder (HA companion app'e)
```http
POST /api/services/notify/mobile_app_iphone
{
  "message": "Mola zamanı!",
  "title": "SKAPI"
}
```

### Media player kontrol
```http
POST /api/services/media_player.media_pause
{ "entity_id": "media_player.spotify_cem" }
```

### TTS (text-to-speech) hoparlöre gönder
```http
POST /api/services/tts/google_translate_say
{
  "entity_id": "media_player.salon_speaker",
  "message": "Cem, mola vermenin zamanı geldi"
}
```

---

## 7. Service Cevap Formatı

Service çağrısı **etkilenen entity'leri** liste olarak döner:

```json
[
  {
    "entity_id": "light.salon_lambasi",
    "state": "on",
    "attributes": { ... },
    "last_changed": "2024-...",
    "last_updated": "2024-..."
  }
]
```

---

## 8. Event Fire (HA bus'a event yolla)

```http
POST /api/events/{event_type}
{ "key": "value", ... }
```

### Örnek: custom event
```http
POST /api/events/skapp_break_started
{ "duration": 60, "trigger": "esp32" }
```

HA otomasyonları bu event'i dinleyebilir:
```yaml
- trigger:
    platform: event
    event_type: skapp_break_started
  action:
    ...
```

---

## 9. Template Render (Server tarafında değer hesaplat)

```http
POST /api/template
{ "template": "{{ states('sensor.disari_sicaklik') }}" }
```

Cevap:
```
22.5
```

---

## 10. History (Geçmiş Veri)

```
GET /api/history/period/2024-04-01T00:00:00+00:00?filter_entity_id=light.salon_lambasi
```

Belirli entity'nin geçmiş state değişimleri.

---

## 11. Logbook

```
GET /api/logbook/2024-04-01T00:00:00+00:00?entity=light.salon_lambasi
```

Human-readable event akışı.

---

## 12. Calendars

```
GET /api/calendars
```

HA'ya entegre takvimler. SKAPI'nin "meeting-detect" için kullanışlı:
```
GET /api/calendars/calendar.work_calendar?start=2024-04-28T14:00:00Z&end=2024-04-28T15:00:00Z
```

---

## 13. Config / Error Log

### HA config
```
GET /api/config
```

### Hata logu
```
GET /api/error_log
```

---

## 14. Conversation API (Voice / Text Intent)

```http
POST /api/conversation/process
{ "text": "salon ışığını aç" }
```

HA'nın yerel intent işleyici. SKAPI için sesli komut entegrasyonu için kullanışlı.

---

## SKAPI Şablonları

### "HA - Işık aç"
```yaml
id: ha-light-on
name: "HA - Işık Aç"
category: smarthome
target: home-assistant
protocol: http
method: POST
url: "http://{ha_ip}:{ha_port}/api/services/light/turn_on"
headers: { "Authorization": "Bearer {token}", "Content-Type": "application/json" }
body: { "entity_id": "{entity}" }
params:
  - { key: ha_ip, label: "HA IP", type: ip, required: true }
  - { key: ha_port, label: "HA Port", type: int, default: 8123 }
  - { key: token, label: "Long-Lived Token", type: secret, required: true }
  - { key: entity, label: "Entity ID", type: string, default: "light.salon_lambasi" }
```

### "HA - Işık aç + parlaklık + renk"
```yaml
id: ha-light-on-color
name: "HA - Işık Aç (Renk + Parlaklık)"
category: smarthome
target: home-assistant
protocol: http
method: POST
url: "http://{ha_ip}:{ha_port}/api/services/light/turn_on"
headers: { "Authorization": "Bearer {token}" }
body: {
  "entity_id": "{entity}",
  "brightness": "{brightness}",
  "rgb_color": ["{r}", "{g}", "{b}"]
}
params:
  - { key: ha_ip, label: "HA IP", type: ip, required: true }
  - { key: ha_port, label: "HA Port", type: int, default: 8123 }
  - { key: token, label: "Token", type: secret, required: true }
  - { key: entity, label: "Entity", type: string }
  - { key: brightness, label: "Parlaklık (0-255)", type: int, default: 200 }
  - { key: r, label: "R", type: int, default: 255 }
  - { key: g, label: "G", type: int, default: 100 }
  - { key: b, label: "B", type: int, default: 0 }
```

### "HA - Sahne tetikle"
```yaml
id: ha-scene-trigger
name: "HA - Sahne Tetikle"
category: smarthome
target: home-assistant
protocol: http
method: POST
url: "http://{ha_ip}:{ha_port}/api/services/scene/turn_on"
headers: { "Authorization": "Bearer {token}" }
body: { "entity_id": "{scene}" }
params:
  - { key: ha_ip, label: "HA IP", type: ip, required: true }
  - { key: ha_port, label: "HA Port", type: int, default: 8123 }
  - { key: token, label: "Token", type: secret, required: true }
  - { key: scene, label: "Scene ID", type: string, default: "scene.sabah_modu" }
```

### "HA - Script çalıştır"
```yaml
id: ha-script-run
name: "HA - Script Çalıştır"
category: smarthome
target: home-assistant
protocol: http
method: POST
url: "http://{ha_ip}:{ha_port}/api/services/script/turn_on"
headers: { "Authorization": "Bearer {token}" }
body: { "entity_id": "{script}" }
params:
  - { key: ha_ip, label: "HA IP", type: ip, required: true }
  - { key: ha_port, label: "HA Port", type: int, default: 8123 }
  - { key: token, label: "Token", type: secret, required: true }
  - { key: script, label: "Script ID", type: string, default: "script.molaya_cik" }
```

### "HA - Custom event fire (mola sinyali yay)"
```yaml
id: ha-fire-event
name: "HA - Event Yayınla"
category: smarthome
target: home-assistant
protocol: http
method: POST
url: "http://{ha_ip}:{ha_port}/api/events/skapp_break_started"
headers: { "Authorization": "Bearer {token}" }
body: { "duration": "{duration}", "trigger": "esp32" }
params:
  - { key: ha_ip, label: "HA IP", type: ip, required: true }
  - { key: ha_port, label: "HA Port", type: int, default: 8123 }
  - { key: token, label: "Token", type: secret, required: true }
  - { key: duration, label: "Mola süresi (sn)", type: int, default: 60 }
```

### "HA - Telefona bildirim gönder"
```yaml
id: ha-notify-mobile
name: "HA - Telefona Bildirim"
category: smarthome
target: home-assistant
protocol: http
method: POST
url: "http://{ha_ip}:{ha_port}/api/services/notify/mobile_app_iphone"
headers: { "Authorization": "Bearer {token}" }
body: { "message": "{message}", "title": "{title}" }
params:
  - { key: ha_ip, label: "HA IP", type: ip, required: true }
  - { key: ha_port, label: "HA Port", type: int, default: 8123 }
  - { key: token, label: "Token", type: secret, required: true }
  - { key: title, label: "Başlık", type: string, default: "SKAPI" }
  - { key: message, label: "Mesaj", type: string, default: "Mola zamanı!" }
```

### "HA - Sıcaklık oku" (read-only, condition için)
```yaml
id: ha-read-state
name: "HA - Entity Durumu Oku"
category: smarthome
target: home-assistant
protocol: http
method: GET
url: "http://{ha_ip}:{ha_port}/api/states/{entity}"
headers: { "Authorization": "Bearer {token}" }
params:
  - { key: ha_ip, label: "HA IP", type: ip, required: true }
  - { key: ha_port, label: "HA Port", type: int, default: 8123 }
  - { key: token, label: "Token", type: secret, required: true }
  - { key: entity, label: "Entity ID", type: string, default: "sensor.disari_sicaklik" }
```
