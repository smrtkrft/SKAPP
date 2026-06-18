# Shelly DALI Dimmer Gen3 — Tam API Komut Listesi

**Model:** S3DM-0A1WW (DALI Dimmer Gen3)
**Nesil:** Gen3 (yeni nesil RPC API)
**Özellikler:** **DALI bus üzerinden** dimmable LED ballast / driver kontrolü. DALI 1-64 short address desteği, **DALI grupları** (0-15), **DALI sahneleri** (0-15)
**Bus:** DALI (Digital Addressable Lighting Interface)
**Protokol:** HTTP RPC API (JSON-RPC 2.0), MQTT, WebSocket
**Varsayılan port:** 80 (HTTP)

> **Önemli:** Shelly DALI Dimmer Gen3, Gen1 dimmerlerinin **REST API'sini değil**, Gen2+ ailenin **JSON-RPC API'sini** kullanır.
> Endpoint formatı: `/rpc/Method.Action` (GET) veya `/rpc` (POST + JSON body).
> DALI cihazları kendi adreslerine sahiptir — komutlar DALI bus'a forward edilir.

---

## 1. Cihaz Bilgileri

### Genel cihaz bilgisi
```
GET http://192.168.1.42/rpc/Shelly.GetDeviceInfo
```

**Cevap:**
```json
{
  "name": "Salon DALI",
  "id": "shellydalidimmerg3-XXXXXX",
  "mac": "...",
  "model": "S3DM-0A1WW",
  "gen": 3,
  "fw_id": "20240101-...",
  "ver": "1.4.0",
  "app": "DALIDimmerG3",
  "auth_en": false
}
```

### Tam config
```
GET http://192.168.1.42/rpc/Shelly.GetConfig
```

### Tam status
```
GET http://192.168.1.42/rpc/Shelly.GetStatus
```

---

## 2. DALI Bus Tarama

### DALI bus üzerindeki tüm cihazları tara
```
POST http://192.168.1.42/rpc
Content-Type: application/json

{
  "id": 1,
  "method": "DALI.Scan",
  "params": {}
}
```

Bus üzerindeki tüm DALI cihazları (1-64 short address) bulunur ve listelenir.

### Bulunan DALI cihazlarını listele
```
GET http://192.168.1.42/rpc/DALI.GetDevices
```

**Cevap:**
```json
{
  "devices": [
    { "addr": 0, "type": "ballast", "online": true },
    { "addr": 1, "type": "ballast", "online": true },
    { "addr": 5, "type": "ballast", "online": false }
  ]
}
```

---

## 3. Tek DALI Cihazı Kontrolü (Short Address ile)

### Aç (DALI cihaz adres 0)
```
GET http://192.168.1.42/rpc/Light.Set?id=0&on=true
```

`id` = DALI short address (0-63).

### Kapat
```
GET http://192.168.1.42/rpc/Light.Set?id=0&on=false
```

### Toggle
```
GET http://192.168.1.42/rpc/Light.Toggle?id=0
```

### Parlaklık ayarla (%50, açıkken)
```
GET http://192.168.1.42/rpc/Light.Set?id=0&on=true&brightness=50
```

`brightness` değeri **0-100** arasında (DALI içinde 0-254 mapped).

### Sadece parlaklığı değiştir
```
GET http://192.168.1.42/rpc/Light.Set?id=0&brightness=75
```

### Geçiş süresi (DALI fade rate)
```
GET http://192.168.1.42/rpc/Light.Set?id=0&on=true&brightness=80&transition_duration=3
```
`transition_duration` saniye cinsinden. DALI'nin yerel "fade time" özelliği kullanılır (DALI fade time = 0.7s × 2^N).

### Durum sorgula
```
GET http://192.168.1.42/rpc/Light.GetStatus?id=0
```

**Cevap:**
```json
{
  "id": 0,
  "source": "http",
  "output": true,
  "brightness": 50,
  "transition": null
}
```

---

## 4. DALI Grup Kontrolü (16 Grup, 0-15)

DALI'nin en güçlü özelliği — bir komutla bir grup içindeki tüm cihazları kontrol etmek.

### Cihazı gruba ata
```
POST http://192.168.1.42/rpc
{
  "id": 1,
  "method": "DALI.AddToGroup",
  "params": { "addr": 0, "group": 1 }
}
```

### Cihazı gruptan çıkar
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.RemoveFromGroup",
  "params": { "addr": 0, "group": 1 }
}
```

### Grubun üyelerini sorgula
```
GET http://192.168.1.42/rpc/DALI.GetGroupMembers?group=1
```

### Grubu aç (broadcast group 1'e)
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.GroupSet",
  "params": { "group": 1, "on": true }
}
```

### Grubu kapat
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.GroupSet",
  "params": { "group": 1, "on": false }
}
```

### Grubu %50'ye dim et
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.GroupSet",
  "params": { "group": 1, "on": true, "brightness": 50 }
}
```

### Grup durumu
```
GET http://192.168.1.42/rpc/DALI.GetGroupStatus?group=1
```

---

## 5. DALI Broadcast (Tüm Cihazlar)

### Broadcast aç (tüm DALI cihazları aç)
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.Broadcast",
  "params": { "on": true }
}
```

### Broadcast kapat
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.Broadcast",
  "params": { "on": false }
}
```

### Broadcast parlaklık (tüm cihazlar %30)
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.Broadcast",
  "params": { "on": true, "brightness": 30 }
}
```

### Tüm cihazları "fade to off" (DALI native fade)
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.Broadcast",
  "params": { "on": false, "transition_duration": 5 }
}
```

---

## 6. DALI Sahneleri (16 Sahne, 0-15)

DALI cihazları kendi içinde sahne hafızasına sahiptir. Her cihaz 16 sahne saklar.

### Sahne kaydet (cihaz şu anki durumu sahneye sakla)
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.StoreScene",
  "params": { "addr": 0, "scene": 1 }
}
```

### Cihazı belirli sahneye git
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.GoToScene",
  "params": { "addr": 0, "scene": 1 }
}
```

### Tüm grup sahneye git
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.GroupGoToScene",
  "params": { "group": 1, "scene": 2 }
}
```

### Tüm cihazlar broadcast sahneye git
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.BroadcastGoToScene",
  "params": { "scene": 0 }
}
```

### Sahne sil
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.RemoveScene",
  "params": { "addr": 0, "scene": 1 }
}
```

---

## 7. DALI Konfigürasyonu (Cihaz Başına)

### Min/max seviye ayarla
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.SetMinLevel",
  "params": { "addr": 0, "level": 5 }
}
```

```
POST http://192.168.1.42/rpc
{
  "method": "DALI.SetMaxLevel",
  "params": { "addr": 0, "level": 100 }
}
```

### Power-on level (cihaz açıldığında parlaklık)
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.SetPowerOnLevel",
  "params": { "addr": 0, "level": 80 }
}
```

### Fade rate (DALI native fade)
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.SetFadeRate",
  "params": { "addr": 0, "rate": 4 }
}
```
DALI fade rate 1-15 arası.

### System failure level (DALI bus düşerse cihaz parlaklığı)
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.SetSystemFailureLevel",
  "params": { "addr": 0, "level": 100 }
}
```

---

## 8. DALI Cihaz Atama (Commissioning)

DALI cihazları varsayılan olarak adres 255 (atanmamış). İlk kurulumda adres atanır.

### Yeni cihaz tarama (commissioning)
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.Commission",
  "params": {}
}
```

Bu işlem dakikalar sürebilir — bus üzerindeki tüm yeni cihazlara adres atar.

### Cihaza manuel adres ata
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.SetShortAddress",
  "params": { "old_addr": 255, "new_addr": 5 }
}
```

### Cihazı tanımlamak için yanıp söndür (identify)
```
POST http://192.168.1.42/rpc
{
  "method": "DALI.Identify",
  "params": { "addr": 0 }
}
```

---

## 9. WebSocket Real-time Event

Gen2+ Shelly cihazları WebSocket üzerinden real-time event yayınlar.

```
ws://192.168.1.42/rpc
```

Bağlanınca tüm event'leri JSON olarak alırsın (ışık değişimleri, DALI bus event'leri).

---

## 10. MQTT Konfigürasyonu

### MQTT etkinleştir
```
POST http://192.168.1.42/rpc
{
  "method": "MQTT.SetConfig",
  "params": {
    "config": {
      "enable": true,
      "server": "192.168.1.10:1883",
      "user": "USER",
      "pass": "PASS",
      "topic_prefix": "shelly-dali"
    }
  }
}
```

Topic örnekleri:
- `shelly-dali/status/light:0` — DALI cihaz 0 durumu
- `shelly-dali/command/light:0` — komut: `{"on": true, "brightness": 50}`

---

## 11. Cihaz Yönetimi

### Yeniden başlat
```
GET http://192.168.1.42/rpc/Shelly.Reboot
```

### Firmware güncelle
```
POST http://192.168.1.42/rpc
{
  "method": "Shelly.Update",
  "params": { "stage": "stable" }
}
```

### Fabrika ayarları
```
POST http://192.168.1.42/rpc
{
  "method": "Shelly.FactoryReset"
}
```

---

## 12. Authentication

Gen3 cihazlar **Digest Authentication** kullanır:

```
GET http://192.168.1.42/rpc/Shelly.GetDeviceInfo
Authorization: Digest username="admin", realm="...", ...
```

Veya basit:
```
http://admin:PASSWORD@192.168.1.42/rpc/...
```

Şifre cihaz ayarlarından kurulur.

---

## SKAPI Action Şablonu Örnekleri

### Şablon: "DALI grup 1'i aç"
```yaml
id: shelly-dali-group-on
name: "Shelly DALI - Grup Aç"
category: smarthome
target: shelly-dali-dimmer
protocol: http
method: POST
url: "http://{ip}/rpc"
body: {
  "method": "DALI.GroupSet",
  "params": { "group": "{group}", "on": true }
}
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: group, label: "DALI Grup (0-15)", type: int, min: 0, max: 15 }
```

### Şablon: "DALI grup 1'i %30 dim"
```yaml
id: shelly-dali-group-dim
name: "Shelly DALI - Grup Dim"
category: smarthome
target: shelly-dali-dimmer
protocol: http
method: POST
url: "http://{ip}/rpc"
body: {
  "method": "DALI.GroupSet",
  "params": {
    "group": "{group}",
    "on": true,
    "brightness": "{brightness}"
  }
}
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: group, label: "DALI Grup (0-15)", type: int }
  - { key: brightness, label: "Parlaklık (%)", type: int, min: 0, max: 100, default: 30 }
```

### Şablon: "Mola sahnesini çağır" (broadcast scene)
```yaml
id: shelly-dali-scene
name: "Shelly DALI - Tüm Cihazlar Sahne"
category: smarthome
target: shelly-dali-dimmer
protocol: http
method: POST
url: "http://{ip}/rpc"
body: {
  "method": "DALI.BroadcastGoToScene",
  "params": { "scene": "{scene}" }
}
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: scene, label: "DALI Sahne (0-15)", type: int, min: 0, max: 15 }
```

### Şablon: "Tek DALI cihazı %50 yumuşak fade"
```yaml
id: shelly-dali-single-fade
name: "Shelly DALI - Cihaz Fade"
category: smarthome
target: shelly-dali-dimmer
protocol: http
method: GET
url: "http://{ip}/rpc/Light.Set?id={addr}&on=true&brightness={brightness}&transition_duration={fade}"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: addr, label: "DALI Adres (0-63)", type: int }
  - { key: brightness, label: "Parlaklık (%)", type: int, default: 50 }
  - { key: fade, label: "Fade süresi (sn)", type: int, default: 3 }
```

---

## Hata Kodları (RPC standart)

| Cevap | Anlam |
|---|---|
| `{ "result": {...} }` | Başarılı |
| `{ "error": { "code": -32700, "message": "..." } }` | Parse hatası |
| `{ "error": { "code": -32601, "message": "Method not found" } }` | Method yok |
| `{ "error": { "code": -32602, "message": "Invalid params" } }` | Yanlış parametre |
| `{ "error": { "code": 401, "message": "Unauthorized" } }` | Auth gerekli |

---

## Sorun Giderme

- DALI cihazı bulunamıyor → bus polaritesi (DA+/DA-), 16V besleme bağlı mı kontrol et
- `Scan` boş dönüyor → cihazlar adres almamış olabilir, `Commission` çağır
- Brightness değişmiyor → cihazın min/max level ayarları kısıtlamış olabilir
- Grup komutu hiçbir cihaza gitmedi → grup atamaları doğru mu? `GetGroupMembers` ile kontrol
- Broadcast çalışıyor ama tek cihaz çalışmıyor → cihazın short address'i 255 olabilir (atanmamış)

---

## DALI Hakkında Kısa Not

DALI = **Digital Addressable Lighting Interface**, IEC 62386 standardı.
- **2 telli düşük voltaj bus** (16V), polariteden bağımsız
- **Maksimum 64 cihaz** bir bus'ta (short address 0-63)
- **16 grup**, **16 sahne** her cihaz için
- Cihazlar kendi içinde fade time, fade rate, min/max level saklar
- Asıl gücü: cihaz yandığı zaman bile parlaklık seviyesini hatırlar (system failure level)
- LED, fluorescent, halogen ballast'lar destekler
