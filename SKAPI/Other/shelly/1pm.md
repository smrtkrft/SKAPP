# Shelly 1PM (Gen1) — Tam API Komut Listesi

**Model:** SHSW-PM
**Nesil:** Gen1
**Özellikler:** 1 röle (kanal 0) + güç ölçümü (Power Monitoring)
**Maks yük:** 16A (3500W @ 230V)
**Protokol:** HTTP REST, MQTT, CoAP, Cloud
**Varsayılan port:** 80 (HTTP)

> Tüm komutlar **GET** isteğidir. Response **JSON**.
> Cihazın IP'sini öğrenmek için Shelly app, router DHCP listesi veya `mDNS` (`shelly1pm-XXXXXX.local`).

---

## 1. Cihaz Bilgileri (Read-only)

### `GET /shelly`
Temel bilgiler — auth gerekmez.

```
http://192.168.1.42/shelly
```

**Cevap:**
```json
{
  "type": "SHSW-PM",
  "mac": "98F4ABXXXXXX",
  "auth": false,
  "fw": "20230913-114008/v1.14.0-gcb84623",
  "longid": 1,
  "num_outputs": 1,
  "num_meters": 1
}
```

### `GET /status`
Tam durum (röle + güç + sıcaklık + uptime).

```
http://192.168.1.42/status
```

### `GET /settings`
Tam ayarlar.

```
http://192.168.1.42/settings
```

---

## 2. Röle Kontrolü (Ana Aksiyonlar)

### Aç
```
GET http://192.168.1.42/relay/0?turn=on
```

### Kapat
```
GET http://192.168.1.42/relay/0?turn=off
```

### Toggle (Tersine çevir)
```
GET http://192.168.1.42/relay/0?turn=toggle
```

### Durumu sorgula
```
GET http://192.168.1.42/relay/0
```

**Cevap:**
```json
{
  "ison": true,
  "has_timer": false,
  "timer_started": 0,
  "timer_duration": 0,
  "timer_remaining": 0,
  "overpower": false,
  "source": "http"
}
```

---

## 3. Zamanlayıcı (Auto-off / Auto-on)

### N saniye sonra otomatik kapat
```
GET http://192.168.1.42/relay/0?turn=on&timer=30
```
30 saniye boyunca açık kalır, sonra otomatik kapanır.

### N saniye sonra otomatik aç
```
GET http://192.168.1.42/relay/0?turn=off&timer=60
```

### Timer'ı iptal et (durumu değiştirmeden)
Açıkken `turn=on` tekrar gönder (timer sıfırlanır).

### Bekleyen timer var mı? (status'tan oku)
```json
{ "has_timer": true, "timer_remaining": 22 }
```

---

## 4. Güç Ölçümü (Power Monitoring)

### Anlık güç + sayaç
```
GET http://192.168.1.42/meter/0
```

**Cevap:**
```json
{
  "power": 142.85,            // Watt
  "is_valid": true,
  "timestamp": 1709123456,
  "counters": [142.85, 145.10, 138.20],  // son 3 dakika ortalaması
  "total": 1234567             // toplam Wh sayacı (Wh-min)
}
```

### Toplam tüketim (kWh hesabı)
`total` alanı **Wh-dakika** cinsindendir. kWh'a çevirme:
```
kWh = total / 60 / 1000
```

---

## 5. Konfigürasyon Ayarları

### Auto-off varsayılan timer ayarla (kalıcı)
```
GET http://192.168.1.42/settings/relay/0?auto_off=300
```
Her açıldığında 300 saniye sonra otomatik kapanır.

### Auto-on varsayılan timer ayarla
```
GET http://192.168.1.42/settings/relay/0?auto_on=600
```

### Power-on davranışı (cihaz fişe takıldığında)
```
GET http://192.168.1.42/settings/relay/0?default_state=off
GET http://192.168.1.42/settings/relay/0?default_state=on
GET http://192.168.1.42/settings/relay/0?default_state=last
GET http://192.168.1.42/settings/relay/0?default_state=switch
```

### Buton tipi (fiziksel switch)
```
GET http://192.168.1.42/settings/relay/0?btn_type=momentary
GET http://192.168.1.42/settings/relay/0?btn_type=toggle
GET http://192.168.1.42/settings/relay/0?btn_type=edge
GET http://192.168.1.42/settings/relay/0?btn_type=detached
GET http://192.168.1.42/settings/relay/0?btn_type=action
```

| Tip | Davranış |
|---|---|
| `momentary` | Bas-bırak (örn. zil) |
| `toggle` | Klasik anahtar |
| `edge` | Her kenar değişiminde toggle |
| `detached` | Buton röleyi etkilemez (sadece event üretir) |
| `action` | Buton sadece HTTP/MQTT action tetikler |

### Buton ters çevir
```
GET http://192.168.1.42/settings/relay/0?btn_reverse=1
```

### Maksimum güç limiti (overpower koruması)
```
GET http://192.168.1.42/settings?max_power=2000
```
2000W üstüne çıkarsa röle otomatik kapanır.

---

## 6. Zamanlama (Schedule)

### Schedule aç/kapat
```
GET http://192.168.1.42/settings/relay/0?schedule=1
```

### Schedule ekle (kompleks — settings/actions üzerinden)
Daha kolay yöntem: Shelly app'inden ekle. API üzerinden:
```
GET http://192.168.1.42/settings/actions?index=0&name=on_url&enabled=true&urls[]=http://...
```

---

## 7. Sıcaklık Koruması

### CPU/cihaz sıcaklığı
`/status` içinde:
```json
{
  "temperature": 42.5,
  "overtemperature": false,
  "tmp": { "tC": 42.5, "tF": 108.5, "is_valid": true }
}
```

Cihaz aşırı ısınırsa otomatik kapanır.

---

## 8. Bildirim / Webhook (Actions)

### Açıldığında URL çağır
```
GET http://192.168.1.42/settings/actions?index=0&name=out_on_url&enabled=true&urls[]=http://YOUR-SERVER/on
```

### Kapatıldığında URL çağır
```
GET http://192.168.1.42/settings/actions?index=0&name=out_off_url&enabled=true&urls[]=http://YOUR-SERVER/off
```

### Tüm action isimleri
- `btn_on_url`, `btn_off_url` — buton basıldığında
- `out_on_url`, `out_off_url` — röle değiştiğinde
- `longpush_url`, `shortpush_url` — bas/uzun bas
- `over_power_url` — aşırı güç
- `over_temperature_url` — aşırı sıcaklık

---

## 9. MQTT Konfigürasyonu

### MQTT etkinleştir
```
GET http://192.168.1.42/settings?mqtt_enable=true&mqtt_server=192.168.1.10:1883&mqtt_user=USER&mqtt_pass=PASS
```

### MQTT topic prefix
```
GET http://192.168.1.42/settings?mqtt_id=salonisigi
```

Topic'ler:
- `shellies/salonisigi/relay/0` — durum
- `shellies/salonisigi/relay/0/command` — `on`/`off`/`toggle`
- `shellies/salonisigi/relay/0/power` — anlık güç
- `shellies/salonisigi/relay/0/energy` — toplam tüketim

---

## 10. Cihaz Yönetimi

### Yeniden başlat
```
GET http://192.168.1.42/reboot
```

### Fabrika ayarlarına dön
```
GET http://192.168.1.42/settings?reset=true
```

### Firmware güncellemesi (eğer mevcutsa)
```
GET http://192.168.1.42/ota?update=true
```

### Belirli URL'den firmware yükle
```
GET http://192.168.1.42/ota?url=http://path-to-firmware.zip
```

### WiFi sıfırla
```
GET http://192.168.1.42/settings?wifi_recovery_reboot_enabled=true
```

---

## 11. CoAP / CoIoT

Shelly Gen1 **CoAP üzerinde CoIoT protokolü** kullanır (UDP 5683). Shelly cihazları otomatik durum yayını yapar — Home Assistant gibi sistemler bunu dinler.

SKAPI tarafında bu genelde gerek değil; HTTP yeterlidir.

---

## SKAPI Action Şablonu Örnekleri

### Şablon: "Salon ışığını aç"
```yaml
id: shelly-1pm-on
name: "Shelly 1PM - Aç"
category: smarthome
target: shelly-1pm
protocol: http
method: GET
url: "http://{ip}/relay/0?turn=on"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "30 saniyelik aç-kapat (zil gibi)"
```yaml
id: shelly-1pm-pulse
name: "Shelly 1PM - Geçici aç (X saniye)"
category: smarthome
target: shelly-1pm
protocol: http
method: GET
url: "http://{ip}/relay/0?turn=on&timer={duration}"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: duration, label: "Süre (saniye)", type: int, default: 30 }
```

### Şablon: "Anlık güç tüketimini sorgula"
```yaml
id: shelly-1pm-power
name: "Shelly 1PM - Güç oku"
category: smarthome
target: shelly-1pm
protocol: http
method: GET
url: "http://{ip}/meter/0"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

---

## Hata Kodları

| Cevap | Anlam |
|---|---|
| `200 OK` + JSON | Başarılı |
| `401 Unauthorized` | Auth yanlış (Restrict Login açıksa) |
| `404 Not Found` | Yanlış endpoint veya kanal numarası |
| `400 Bad Request` | Yanlış parametre |
| Bağlantı timeout | Cihaz erişilemez (IP yanlış? Wi-Fi mi?) |

---

## Sorun Giderme

- Komut çalışmıyor → tarayıcıdan `http://IP` aç, web arayüzü açılıyor mu?
- Yanlış cevap → `/shelly` ile cihazın gerçekten 1PM olduğunu doğrula
- Auth sorunu → Settings'ten "Restrict Login" kapatılabilir veya basic auth kullanılabilir: `http://USER:PASS@IP/relay/0?turn=on`
