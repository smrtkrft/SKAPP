# Generic HTTP — Özel HTTP API Şablonu

SKAPI'nin "kataloğunda olmayan" cihazlar veya servisler için **jenerik HTTP request** şablonu.

---

## Ne İçin?

- Henüz SKAPI'de yerini almamış cihazlar (örn. yeni Tasmota cihaz, exotic IoT)
- Webhook'a sahip web servisleri (IFTTT, Zapier, n8n, Node-RED)
- Kullanıcının kendi yazdığı web servisleri / scriptleri
- Public API'ler (hava durumu, takvim, vb.)
- Slack/Discord/Telegram webhook'ları

---

## Desteklenen Özellikler

- HTTP methods: GET, POST, PUT, DELETE, PATCH
- Custom headers (Auth, Content-Type)
- JSON body / form-urlencoded body / raw body
- Query string parameters
- Path parameters (`{var}` ile)
- Auth: None / Basic / Bearer / Custom
- Timeout
- Response parsing (opsiyonel — koşullu mantık için)

---

## Bu Klasördeki Dosyalar

- [template.md](template.md) — Jenerik HTTP request şablonu + örnekler
- webhook-services.md — Slack, Discord, IFTTT, Telegram webhook örnekleri (yakında)
- public-apis.md — Hava durumu, NTP, geocoding gibi public API'ler (yakında)

---

## Use case Örnekleri

### 1. Tasmota cihaz (HTTP)
```
GET http://192.168.1.55/cm?cmnd=Power+On
```

### 2. Slack webhook
```
POST https://hooks.slack.com/services/T.../B.../...
Content-Type: application/json
{ "text": "Mola zamanı!" }
```

### 3. Discord webhook
```
POST https://discord.com/api/webhooks/.../...
Content-Type: application/json
{ "content": "Mola başladı" }
```

### 4. Telegram bot
```
GET https://api.telegram.org/bot{TOKEN}/sendMessage?chat_id={CHAT_ID}&text=Mola
```

### 5. IFTTT webhook
```
POST https://maker.ifttt.com/trigger/break_started/with/key/{API_KEY}
{ "value1": "60sn" }
```

### 6. Node-RED HTTP-in
```
POST http://192.168.1.20:1880/skapp/break
{ "duration": 60 }
```

### 7. n8n webhook
```
POST http://192.168.1.20:5678/webhook/skapp-break
```

### 8. Public API — hava durumu
```
GET https://api.open-meteo.com/v1/forecast?latitude=41&longitude=29&current=temperature_2m
```

---

## SKAPI'nin Rolü

`http-generic` şablonu kullanıcıya tam esneklik verir. SKAPP'te:

```
[Yeni Action]
  → Şablon Tipi: [⚙ Generic HTTP]
  → URL: [______________]
  → Method: [POST ▼]
  → Headers: [+ Add Header]
  → Body: [______________]
  → Test Et
```

Bu şekilde **dünyadaki herhangi bir HTTP API'si** SKAPP üzerinden ESP32 ile tetiklenebilir.

> Çoğu zaman cihaz katalogda yoksa kullanıcı önce template.md'deki örneklerden bir tanesini uyarlayıp action'ını oluşturur.
