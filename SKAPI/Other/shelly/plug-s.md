# Shelly Plug S (Gen1) — Tam API Komut Listesi

**Model:** SHPLG-S
**Nesil:** Gen1
**Özellikler:** Akıllı priz + güç ölçümü + LED ring
**Maks yük:** 12A (2500W)
**Protokol:** HTTP REST, MQTT, CoAP, Cloud
**Form:** Kompakt Avrupa prizi

> Shelly **Plug** (SHPLG-1) ve **Plug US** (SHPLG-U1) ile API büyük ölçüde aynı, sadece form ve voltaj farklı.

---

## 1. Cihaz Bilgileri

```
GET http://192.168.1.42/shelly
```

**Cevap:**
```json
{
  "type": "SHPLG-S",
  "mac": "...",
  "auth": false,
  "fw": "...",
  "num_outputs": 1,
  "num_meters": 1
}
```

```
GET http://192.168.1.42/status
GET http://192.168.1.42/settings
```

---

## 2. Röle Kontrolü

### Aç
```
GET http://192.168.1.42/relay/0?turn=on
```

### Kapat
```
GET http://192.168.1.42/relay/0?turn=off
```

### Toggle
```
GET http://192.168.1.42/relay/0?turn=toggle
```

### Durum
```
GET http://192.168.1.42/relay/0
```

### Auto-off / auto-on (saniye)
```
GET http://192.168.1.42/relay/0?turn=on&timer=300
GET http://192.168.1.42/relay/0?turn=off&timer=600
```

---

## 3. Güç Ölçümü

```
GET http://192.168.1.42/meter/0
```

**Cevap:**
```json
{
  "power": 145.2,
  "is_valid": true,
  "timestamp": 1709123456,
  "counters": [145.2, 144.8, 145.5],
  "total": 234567
}
```

`total` → Wh-dakika cinsinden. kWh için: `total / 60 / 1000`.

---

## 4. LED Ring Kontrolü (Plug S'in özel özelliği)

### LED durumu (mode)
```
GET http://192.168.1.42/settings?led_status_disable=false
GET http://192.168.1.42/settings?led_status_disable=true
```

`led_status_disable` true → LED hiç yanmaz.

### LED rengi power moduna göre
```
GET http://192.168.1.42/settings?led_power_disable=false
GET http://192.168.1.42/settings?led_power_disable=true
```

`led_power_disable` true → güç ölçümünün LED rengi devre dışı (sadece on/off rengi).

> Plug S LED'i normalde:
> - Açık + güç düşük → mavi
> - Açık + güç orta → sarı
> - Açık + güç yüksek → kırmızı
> - Kapalı → kırmızı (durum)

---

## 5. Konfigürasyon

### Auto-off varsayılan timer
```
GET http://192.168.1.42/settings/relay/0?auto_off=300
```

### Auto-on varsayılan timer
```
GET http://192.168.1.42/settings/relay/0?auto_on=600
```

### Power-on davranışı
```
GET http://192.168.1.42/settings/relay/0?default_state=off|on|last|switch
```

### Maksimum güç koruması
```
GET http://192.168.1.42/settings?max_power=2500
```

---

## 6. MQTT

```
GET http://192.168.1.42/settings?mqtt_enable=true&mqtt_server=192.168.1.10:1883
```

Topic'ler:
- `shellies/shellyplug-s-XXX/relay/0` — durum
- `shellies/shellyplug-s-XXX/relay/0/command` — `on`/`off`
- `shellies/shellyplug-s-XXX/relay/0/power` — anlık güç
- `shellies/shellyplug-s-XXX/relay/0/energy` — toplam tüketim

---

## 7. Webhook / Actions

Action isimleri:
- `out_on_url`, `out_off_url` — röle değiştiğinde
- `over_power_url` — aşırı güç
- `over_temperature_url` — aşırı sıcaklık

```
GET http://192.168.1.42/settings/actions?index=0&name=out_on_url&enabled=true&urls[]=http://YOUR-SERVER/on
```

---

## 8. Cihaz Yönetimi

```
GET http://192.168.1.42/reboot
GET http://192.168.1.42/ota?update=true
GET http://192.168.1.42/settings?reset=true
```

---

## SKAPI Action Şablonları

### "Plug aç"
```yaml
id: shelly-plug-s-on
name: "Shelly Plug S - Aç"
category: smarthome
target: shelly-plug-s
protocol: http
method: GET
url: "http://{ip}/relay/0?turn=on"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### "Plug X dakika aç sonra kapat"
```yaml
id: shelly-plug-s-timed
name: "Shelly Plug S - X Dakika Aç"
category: smarthome
target: shelly-plug-s
protocol: http
method: GET
url: "http://{ip}/relay/0?turn=on&timer={duration}"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: duration, label: "Süre (saniye)", type: int, default: 300 }
```

### "Anlık güç oku"
```yaml
id: shelly-plug-s-power
name: "Shelly Plug S - Güç Oku"
category: smarthome
target: shelly-plug-s
protocol: http
method: GET
url: "http://{ip}/meter/0"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### "LED ring kapat (görsel kirlilik için)"
```yaml
id: shelly-plug-s-led-off
name: "Shelly Plug S - LED Kapat"
category: smarthome
target: shelly-plug-s
protocol: http
method: GET
url: "http://{ip}/settings?led_status_disable=true&led_power_disable=true"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```
