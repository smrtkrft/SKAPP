# Generic HTTP — Şablon Format ve Örnekler

Bu dosya, kullanıcının kendi HTTP isteğini SKAPP içinde action olarak tanımlamak için **template format**'ını gösterir.

---

## Tam Şablon Formatı

```yaml
id: my-custom-action
name: "Action Adı"
category: generic
target: http
protocol: http
method: GET|POST|PUT|DELETE|PATCH
url: "http://{host}:{port}/{path}?param={value}"

headers:
  Content-Type: "application/json"
  Authorization: "Bearer {token}"
  X-Custom-Header: "{custom_value}"

body: { "key": "{value}" }
# veya raw string body için:
# body_raw: "raw text content"
# veya form-urlencoded:
# body_form: { "field1": "{value1}", "field2": "{value2}" }

timeout_ms: 5000          # opsiyonel, varsayılan 3000
expected_status: 200      # opsiyonel
follow_redirects: true    # opsiyonel

params:
  - { key: host, label: "Sunucu IP/host", type: ip, required: true }
  - { key: token, label: "Auth Token", type: secret, required: false }
  - { key: value, label: "Parametre", type: string, required: true }
```

---

## Örnek Şablonlar

### 1. Basit GET (Tasmota)
```yaml
id: tasmota-power-on
name: "Tasmota - Aç"
category: smarthome
target: tasmota
protocol: http
method: GET
url: "http://{ip}/cm?cmnd=Power+On"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### 2. Slack Webhook (basit metin)
```yaml
id: slack-webhook
name: "Slack - Mesaj Gönder"
category: notification
target: slack
protocol: http
method: POST
url: "https://hooks.slack.com/services/{webhook_path}"
headers: { "Content-Type": "application/json" }
body: { "text": "{message}" }
params:
  - { key: webhook_path, label: "Webhook path (services/T.../B.../...)", type: secret, required: true }
  - { key: message, label: "Mesaj", type: string, required: true, default: "SKAPP'ten merhaba" }
```

### 3. Discord Webhook
```yaml
id: discord-webhook
name: "Discord - Mesaj Gönder"
category: notification
target: discord
protocol: http
method: POST
url: "https://discord.com/api/webhooks/{webhook_id}/{webhook_token}"
headers: { "Content-Type": "application/json" }
body: {
  "content": "{message}",
  "username": "{bot_name}"
}
params:
  - { key: webhook_id, label: "Webhook ID", type: secret, required: true }
  - { key: webhook_token, label: "Webhook Token", type: secret, required: true }
  - { key: message, label: "Mesaj", type: string, required: true }
  - { key: bot_name, label: "Bot ismi", type: string, default: "SKAPP" }
```

### 4. Telegram Bot
```yaml
id: telegram-message
name: "Telegram - Mesaj Gönder"
category: notification
target: telegram
protocol: http
method: GET
url: "https://api.telegram.org/bot{bot_token}/sendMessage?chat_id={chat_id}&text={message}"
params:
  - { key: bot_token, label: "Bot Token (BotFather'dan)", type: secret, required: true }
  - { key: chat_id, label: "Chat ID", type: string, required: true }
  - { key: message, label: "Mesaj", type: string, required: true }
```

### 5. IFTTT Webhook
```yaml
id: ifttt-trigger
name: "IFTTT - Event Tetikle"
category: smarthome
target: ifttt
protocol: http
method: POST
url: "https://maker.ifttt.com/trigger/{event}/with/key/{api_key}"
headers: { "Content-Type": "application/json" }
body: { "value1": "{value1}", "value2": "{value2}", "value3": "{value3}" }
params:
  - { key: event, label: "Event adı", type: string, required: true, default: "break_started" }
  - { key: api_key, label: "IFTTT API Key", type: secret, required: true }
  - { key: value1, label: "Value 1", type: string }
  - { key: value2, label: "Value 2", type: string }
  - { key: value3, label: "Value 3", type: string }
```

### 6. Node-RED HTTP-in
```yaml
id: nodered-trigger
name: "Node-RED - Akış Tetikle"
category: automation
target: node-red
protocol: http
method: POST
url: "http://{nr_host}:{nr_port}/{flow_path}"
headers: { "Content-Type": "application/json" }
body: { "trigger": "{trigger_name}", "data": "{data}" }
params:
  - { key: nr_host, label: "Node-RED IP", type: ip, required: true }
  - { key: nr_port, label: "Node-RED Port", type: int, default: 1880 }
  - { key: flow_path, label: "Flow path", type: string, default: "skapp" }
  - { key: trigger_name, label: "Trigger adı", type: string }
  - { key: data, label: "Veri", type: string }
```

### 7. n8n Webhook
```yaml
id: n8n-webhook
name: "n8n - Workflow Tetikle"
category: automation
target: n8n
protocol: http
method: POST
url: "http://{n8n_host}:{n8n_port}/webhook/{webhook_path}"
headers: { "Content-Type": "application/json" }
body: { "event": "{event}", "payload": "{payload}" }
params:
  - { key: n8n_host, label: "n8n IP", type: ip, required: true }
  - { key: n8n_port, label: "n8n Port", type: int, default: 5678 }
  - { key: webhook_path, label: "Webhook path", type: string }
  - { key: event, label: "Event", type: string }
  - { key: payload, label: "Payload", type: string }
```

### 8. Hava Durumu (Open-Meteo, free, no auth)
```yaml
id: weather-current
name: "Open-Meteo - Anlık Hava"
category: data
target: weather
protocol: http
method: GET
url: "https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current=temperature_2m,humidity_2m,wind_speed_10m"
params:
  - { key: lat, label: "Enlem", type: float, default: 41.0 }
  - { key: lon, label: "Boylam", type: float, default: 29.0 }
note: "Cevap JSON: current.temperature_2m, current.humidity_2m"
```

### 9. Custom REST API + Bearer Auth
```yaml
id: custom-api-bearer
name: "Custom API - Bearer Auth"
category: generic
target: http
protocol: http
method: POST
url: "https://{api_host}/api/v1/{endpoint}"
headers: { "Authorization": "Bearer {token}", "Content-Type": "application/json" }
body: { "action": "{action}", "data": "{data}" }
params:
  - { key: api_host, label: "API Host", type: string, required: true }
  - { key: token, label: "Bearer Token", type: secret, required: true }
  - { key: endpoint, label: "Endpoint path", type: string, required: true }
  - { key: action, label: "Action", type: string }
  - { key: data, label: "Data", type: string }
```

### 10. Custom API + Basic Auth
```yaml
id: custom-api-basic
name: "Custom API - Basic Auth"
category: generic
target: http
protocol: http
method: GET
url: "http://{user}:{pass}@{host}/{path}"
params:
  - { key: user, label: "Kullanıcı", type: string, required: true }
  - { key: pass, label: "Şifre", type: secret, required: true }
  - { key: host, label: "Host", type: string, required: true }
  - { key: path, label: "Path", type: string, required: true }
```

### 11. Form-Urlencoded POST
```yaml
id: custom-form-post
name: "Form POST"
category: generic
target: http
protocol: http
method: POST
url: "http://{host}/{endpoint}"
headers: { "Content-Type": "application/x-www-form-urlencoded" }
body_form: { "field1": "{value1}", "field2": "{value2}" }
params:
  - { key: host, label: "Host", type: string, required: true }
  - { key: endpoint, label: "Endpoint", type: string, required: true }
  - { key: value1, label: "Değer 1", type: string }
  - { key: value2, label: "Değer 2", type: string }
```

### 12. Conditional GET (read-only, koşullu mantık için)
```yaml
id: custom-status-check
name: "Custom Status Check"
category: condition
target: http
protocol: http
method: GET
url: "http://{host}/api/status"
expected_status: 200
note: "200 OK döner ise durum 'available', diğer her şey 'down'"
params:
  - { key: host, label: "Sunucu", type: string, required: true }
```

---

## Parametre Tipleri (Reminder)

| Tip | Açıklama |
|---|---|
| `string` | Genel metin |
| `int` | Tam sayı |
| `float` | Ondalıklı sayı |
| `bool` | true/false toggle |
| `ip` | IP adresi (validation ile) |
| `port` | Port numarası (1-65535) |
| `url` | URL (validation ile) |
| `secret` | Maskelenmiş giriş (token, şifre) |
| `color` | Renk seçici (HEX) |
| `enum` | Dropdown (`options: [...]`) |
| `duration` | Süre (saniye/dakika) |

---

## Yararlı İpuçları

- **Test:** "Test Et" butonu şablonu çalıştırır, response'u gösterir
- **Secret tipi:** Token'ları `secret` olarak işaretle, SKAPP loglarda maskelenir
- **HTTPS uyarısı:** Self-signed sertifika varsa SKAPP "ignore SSL" seçeneği sunar
- **Timeout:** Yavaş API'ler için `timeout_ms` artır
- **Retry:** SKAPP otomatik retry yapmaz, başarısızlıkta error döner
