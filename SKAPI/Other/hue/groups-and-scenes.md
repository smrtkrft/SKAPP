# Hue Gruplar ve Sahneler — Tam API (v1)

**Endpoint base:** `https://{BRIDGE_IP}/api/{USERNAME}/`

---

## 1. Gruplar (Rooms / Zones)

Hue'da **grup** = oda veya bölge. Tek komutla birden fazla ampul kontrol edilir.

### Grup listesi
```
GET /groups
```

**Cevap:**
```json
{
  "1": {
    "name": "Salon",
    "lights": ["1", "2", "3"],
    "type": "Room",
    "class": "Living room",
    "state": { "any_on": true, "all_on": false },
    "action": { "on": true, "bri": 200, "ct": 250 }
  },
  "2": { ... }
}
```

### Tek grup
```
GET /groups/1
```

### Grup aç (3 ampul birden)
```http
PUT /groups/1/action
{ "on": true }
```

### Grup kapat
```http
PUT /groups/1/action
{ "on": false }
```

### Grup parlaklık + renk
```http
PUT /groups/1/action
{ "on": true, "bri": 127, "hue": 25500, "sat": 254, "transitiontime": 30 }
```

> **Not:** Grup endpoint'i `/state` değil, `/action`.

### Grup 0 = TÜM AMPULLER (özel)
```http
PUT /groups/0/action
{ "on": false }
```
Tüm Hue ampulleri tek komutla kapatır.

### Yeni grup oluştur
```http
POST /groups
{
  "name": "Çalışma Köşesi",
  "lights": ["4", "5"],
  "type": "Zone",
  "class": "Office"
}
```

### Grup düzenle
```http
PUT /groups/3
{ "name": "Yeni İsim", "lights": ["4", "5", "6"] }
```

### Grup sil
```http
DELETE /groups/3
```

---

## 2. Sahneler (Scenes)

Hue'da **sahne** = bir grubun belirli bir state preset'i (renk + parlaklık kombinasyonu).

### Sahne listesi
```
GET /scenes
```

**Cevap:**
```json
{
  "ABC123-on-0": {
    "name": "Akşam Modu",
    "type": "GroupScene",
    "group": "1",
    "lights": ["1", "2", "3"],
    "owner": "...",
    "recycle": false,
    "locked": false,
    "appdata": {...},
    "picture": "",
    "lastupdated": "2024-...",
    "version": 2
  },
  ...
}
```

### Sahne uygula (asıl komut)
```http
PUT /groups/1/action
{ "scene": "ABC123-on-0" }
```

> Sahneler grup üzerinden tetiklenir (`/groups/{id}/action`).

### Sahne oluştur (mevcut state'i sahne olarak kaydet)
```http
POST /scenes
{
  "name": "Yeni Sahne",
  "type": "GroupScene",
  "group": "1",
  "recycle": false
}
```

### Sahne düzenle
```http
PUT /scenes/{SCENE_ID}
{ "name": "Yeni İsim" }
```

### Sahne sil
```http
DELETE /scenes/{SCENE_ID}
```

---

## 3. Bridge'de Önceden Tanımlı Sahneler

Bridge yüklemesinde bazı sahneler hazır gelir:

| Sahne adı | Açıklama |
|---|---|
| Energize | Soğuk parlak beyaz (uyanma) |
| Concentrate | Soğuk beyaz (odaklanma) |
| Read | Doğal beyaz (okuma) |
| Relax | Sıcak yumuşak |
| Bright | Sıcak parlak |
| Dimmed | Sıcak kısık |
| Nightlight | Çok kısık sıcak |
| Savanna sunset | Turuncu-amber doğal |
| Tropical twilight | Mor-pembe doğal |
| Arctic aurora | Mavi-yeşil doğal |
| Spring blossom | Pembe-mor doğal |

Bu sahneler her grupta erişilebilir. ID'leri öğrenmek için `GET /scenes` çalıştır, `name` alanından eşleştir.

---

## 4. Schedule (Zamanlanmış Aksiyonlar)

### Schedule listesi
```
GET /schedules
```

### Yeni schedule
```http
POST /schedules
{
  "name": "Sabah 7'de Aç",
  "description": "Salon ışıkları",
  "command": {
    "address": "/api/{USERNAME}/groups/1/action",
    "method": "PUT",
    "body": { "on": true, "bri": 200, "ct": 300 }
  },
  "localtime": "W127/T07:00:00",       // her gün 07:00
  "status": "enabled"
}
```

### Localtime format
- `W127/T07:00:00` — her gün
- `W124/T07:00:00` — Pazartesi-Salı-Çarşamba (W = bitmask)
- `2024-12-25T08:00:00` — tek seferlik
- `PT00:30:00` — şimdiden 30 dakika sonra

### Schedule sil
```http
DELETE /schedules/{ID}
```

---

## 5. Sensors (Motion, Dimmer, Tap)

### Sensor listesi
```
GET /sensors
```

Motion sensor için:
```json
{
  "10": {
    "state": { "presence": false, "lastupdated": "2024-..." },
    "config": { "on": true, "battery": 96, "reachable": true, "sensitivity": 2 },
    "name": "Salon Hareket Sensörü",
    "type": "ZLLPresence"
  }
}
```

Tek sensor durumu sorgula → presence/temperature/illuminance event tabanlı kullanım.

---

## 6. Capabilities (Bridge Kapasiteleri)

```
GET /capabilities
```

Bridge'in kaç ampul/grup/schedule destekleyebildiği.

---

## SKAPI Şablonları

### "Grup aç (oda aç)"
```yaml
id: hue-group-on
name: "Hue Grup - Aç"
category: smarthome
target: hue-group
protocol: http
method: PUT
url: "https://{bridge_ip}/api/{username}/groups/{group_id}/action"
body: { "on": true }
params:
  - { key: bridge_ip, label: "Bridge IP", type: ip, required: true }
  - { key: username, label: "API Key", type: secret, required: true }
  - { key: group_id, label: "Grup ID", type: int, required: true }
```

### "Grup kapat"
```yaml
id: hue-group-off
name: "Hue Grup - Kapat"
target: hue-group
protocol: http
method: PUT
url: "https://{bridge_ip}/api/{username}/groups/{group_id}/action"
body: { "on": false }
params:
  - { key: bridge_ip, label: "Bridge IP", type: ip, required: true }
  - { key: username, label: "API Key", type: secret, required: true }
  - { key: group_id, label: "Grup ID", type: int, required: true }
```

### "TÜM Hue ampuller kapat" (group 0 magic)
```yaml
id: hue-all-off
name: "Hue - TÜM Ampulleri Kapat"
target: hue-bridge
protocol: http
method: PUT
url: "https://{bridge_ip}/api/{username}/groups/0/action"
body: { "on": false }
params:
  - { key: bridge_ip, label: "Bridge IP", type: ip, required: true }
  - { key: username, label: "API Key", type: secret, required: true }
```

### "Sahne uygula"
```yaml
id: hue-apply-scene
name: "Hue - Sahne Uygula"
target: hue-group
protocol: http
method: PUT
url: "https://{bridge_ip}/api/{username}/groups/{group_id}/action"
body: { "scene": "{scene_id}" }
params:
  - { key: bridge_ip, label: "Bridge IP", type: ip, required: true }
  - { key: username, label: "API Key", type: secret, required: true }
  - { key: group_id, label: "Grup ID", type: int, required: true }
  - { key: scene_id, label: "Sahne ID", type: string, required: true }
```

### "Concentrate sahnesi (çalışma)"
```yaml
id: hue-scene-concentrate
name: "Hue - Concentrate (Çalışma)"
target: hue-group
note: "Önce GET /scenes ile Concentrate ID'sini öğren, sonra şablona koy"
```

### "Yumuşak grup fade-out (mola için)"
```yaml
id: hue-group-fade-off
name: "Hue Grup - Yumuşak Söndür"
target: hue-group
protocol: http
method: PUT
url: "https://{bridge_ip}/api/{username}/groups/{group_id}/action"
body: { "on": false, "transitiontime": 100 }
params:
  - { key: bridge_ip, label: "Bridge IP", type: ip, required: true }
  - { key: username, label: "API Key", type: secret, required: true }
  - { key: group_id, label: "Grup ID", type: int, required: true }
```
