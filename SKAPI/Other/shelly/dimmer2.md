# Shelly Dimmer 2 (Gen1) — Tam API Komut Listesi

**Model:** SHDM-2
**Nesil:** Gen1
**Özellikler:** Dimmable ışık kontrolü (1-100% parlaklık) + güç ölçümü + leading/trailing edge dimming
**Maks yük:** 220W (220V), 110W (110V) — yük tipine göre
**Yük tipleri:** Halojen, dimmable LED (220W), dimmable CFL (50W), kesilebilir-trafo
**Protokol:** HTTP REST, MQTT, CoAP, Cloud
**Varsayılan port:** 80 (HTTP)

> Shelly Dimmer 1 (SHDM-1) ve Dimmer 2 (SHDM-2) **aynı API'yi** kullanır. Bu dosya her ikisi için geçerlidir.
> Endpoint `/light/0` (relay değil!).

---

## 1. Cihaz Bilgileri

### `GET /shelly`
```
http://192.168.1.42/shelly
```

**Cevap:**
```json
{
  "type": "SHDM-2",
  "mac": "...",
  "auth": false,
  "fw": "...",
  "num_outputs": 1,
  "num_meters": 1
}
```

### `GET /status`
Tam durum (parlaklık + güç + sıcaklık).

### `GET /settings`
Tam ayarlar.

---

## 2. Temel Aç / Kapat

### Aç
```
GET http://192.168.1.42/light/0?turn=on
```
Önceki parlaklık seviyesinde açılır.

### Kapat
```
GET http://192.168.1.42/light/0?turn=off
```

### Toggle
```
GET http://192.168.1.42/light/0?turn=toggle
```

### Durum
```
GET http://192.168.1.42/light/0
```

**Cevap:**
```json
{
  "ison": true,
  "source": "http",
  "has_timer": false,
  "timer_duration": 0,
  "timer_remaining": 0,
  "mode": "white",
  "brightness": 75,
  "transition": 1000,
  "temp": 0
}
```

---

## 3. Parlaklık Kontrolü (Ana Özellik)

### %50'ye ayarla (açıkken parlaklığı değiştir)
```
GET http://192.168.1.42/light/0?turn=on&brightness=50
```

### %100 (tam aç)
```
GET http://192.168.1.42/light/0?turn=on&brightness=100
```

### %1 (en kısık — kapalı değil)
```
GET http://192.168.1.42/light/0?turn=on&brightness=1
```

### Sadece parlaklığı değiştir (durum aç ise açık kalır)
```
GET http://192.168.1.42/light/0?brightness=30
```

> **Not:** `brightness` değeri **1-100** arasında. 0 değeri kabul edilmez (kapatmak için `turn=off` kullan).

---

## 4. Geçiş Süresi (Transition / Fade)

### Yumuşak geçiş ile aç (3 saniye fade)
```
GET http://192.168.1.42/light/0?turn=on&brightness=80&transition=3000
```
`transition` değeri **milisaniye** cinsinden. 0-5000 arası kabul edilir.

### Anlık (fade yok)
```
GET http://192.168.1.42/light/0?turn=on&brightness=80&transition=0
```

### Yavaş "yumuşak uyandırma" simülasyonu (5 sn'de %100'e)
```
GET http://192.168.1.42/light/0?turn=on&brightness=100&transition=5000
```

### Varsayılan transition süresini değiştir (kalıcı)
```
GET http://192.168.1.42/settings/light/0?transition=2000
```

---

## 5. Zamanlayıcı (Auto-off / Auto-on)

### N saniye sonra otomatik kapat
```
GET http://192.168.1.42/light/0?turn=on&timer=30
```

### N saniye sonra otomatik aç
```
GET http://192.168.1.42/light/0?turn=off&timer=60
```

### Auto-off varsayılan (kalıcı)
```
GET http://192.168.1.42/settings/light/0?auto_off=300
```

### Auto-on varsayılan (kalıcı)
```
GET http://192.168.1.42/settings/light/0?auto_on=600
```

---

## 6. Güç Ölçümü

### Anlık güç
```
GET http://192.168.1.42/meter/0
```

**Cevap:**
```json
{
  "power": 32.5,
  "is_valid": true,
  "timestamp": ...,
  "counters": [32.5, 32.4, 32.6],
  "total": 12345
}
```

---

## 7. Min/Max Parlaklık Limitleri

Bazı LED'ler %1'de titreyebilir. Minimum çalışma parlaklığı ayarlanabilir.

### Minimum parlaklık (titreşimi önle)
```
GET http://192.168.1.42/settings/light/0?min_brightness_on_toggle=10
```
Toggle ile açılınca minimum %10'da başlar.

### Lehinglenmiş yük tipi (leading vs trailing edge)
```
GET http://192.168.1.42/settings/light/0?leading_edge=true
GET http://192.168.1.42/settings/light/0?leading_edge=false
```

| Tip | Kullanım |
|---|---|
| `leading_edge=true` | Halojen, klasik resistif yükler, manyetik trafolar |
| `leading_edge=false` (trailing) | LED, elektronik trafolar — modern dimable LED'ler için tercih |

### Yük tipi profili
```
GET http://192.168.1.42/settings/light/0?warmup_brightness=50&warmup_time=200
```
LED'lerin "warmup" davranışı için.

---

## 8. Konfigürasyon

### Power-on davranışı
```
GET http://192.168.1.42/settings/light/0?default_state=off|on|last|switch
```

### Power-on parlaklığı
```
GET http://192.168.1.42/settings/light/0?default_brightness=50
```
Açılışta %50 parlaklıkta başla.

### Buton tipi
```
GET http://192.168.1.42/settings/light/0?btn1_mode=one_button|dual_button|toggle|edge|detached
GET http://192.168.1.42/settings/light/0?btn2_mode=one_button|dual_button|toggle|edge|detached
```

| Tip | Davranış |
|---|---|
| `one_button` | Tek buton: kısa bas → toggle, uzun bas → dim ayarı |
| `dual_button` | İki buton: biri yukarı/biri aşağı |
| `toggle` | Klasik anahtar |
| `edge` | Kenar değişiminde toggle |
| `detached` | Buton bağımsız (event üretir) |

### Buton ters çevir
```
GET http://192.168.1.42/settings/light/0?btn1_reverse=1
GET http://192.168.1.42/settings/light/0?btn2_reverse=1
```

---

## 9. Schedule

### Schedule aç/kapat
```
GET http://192.168.1.42/settings/light/0?schedule=1
```

### Sunset/sunrise zamanları
Cihaz konum bilgisini Cloud'dan alır. Schedule ile "gün batımında aç" gibi kurallar tanımlanır (Shelly app'ten).

---

## 10. Sıcaklık Koruması

`/status` içinde:
```json
{
  "temperature": 45.2,
  "overtemperature": false,
  "tmp": { "tC": 45.2, "tF": 113.4, "is_valid": true },
  "loaderror": false,
  "overpower": false
}
```

Aşırı ısınma → otomatik kapanma.

---

## 11. Webhook / Actions

Action isimleri:
- `btn1_on_url`, `btn1_off_url`
- `btn2_on_url`, `btn2_off_url`
- `btn1_shortpush_url`, `btn1_longpush_url`
- `btn2_shortpush_url`, `btn2_longpush_url`
- `out_on_url`, `out_off_url`
- `over_power_url`
- `over_temperature_url`

Örnek:
```
GET http://192.168.1.42/settings/actions?index=0&name=out_on_url&enabled=true&urls[]=http://YOUR-SERVER/on
```

---

## 12. MQTT Konfigürasyonu

```
GET http://192.168.1.42/settings?mqtt_enable=true&mqtt_server=192.168.1.10:1883
```

Topic'ler:
- `shellies/shellydimmer2-XXX/light/0` — durum (`on`/`off`)
- `shellies/shellydimmer2-XXX/light/0/command` — `on`/`off`/`toggle`
- `shellies/shellydimmer2-XXX/light/0/set` — JSON ile parlaklık + transition: `{"brightness": 50, "transition": 1000, "turn": "on"}`
- `shellies/shellydimmer2-XXX/light/0/brightness` — sayı ile parlaklık
- `shellies/shellydimmer2-XXX/light/0/power` — anlık güç

---

## 13. Cihaz Yönetimi

### Yeniden başlat
```
GET http://192.168.1.42/reboot
```

### Firmware güncelle
```
GET http://192.168.1.42/ota?update=true
```

### Fabrika ayarları
```
GET http://192.168.1.42/settings?reset=true
```

### Kalibrasyon (yük tipini öğren)
```
GET http://192.168.1.42/settings/light/0?calibrate=true
```
Cihaz kendisi yükü dener ve uygun dimming profili bulur.

---

## SKAPI Action Şablonu Örnekleri

### Şablon: "Işığı aç"
```yaml
id: shelly-dimmer2-on
name: "Shelly Dimmer 2 - Aç"
category: smarthome
target: shelly-dimmer2
protocol: http
method: GET
url: "http://{ip}/light/0?turn=on"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Işığı kapat"
```yaml
id: shelly-dimmer2-off
name: "Shelly Dimmer 2 - Kapat"
category: smarthome
target: shelly-dimmer2
protocol: http
method: GET
url: "http://{ip}/light/0?turn=off"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Belirli parlaklığa ayarla (%50)"
```yaml
id: shelly-dimmer2-brightness
name: "Shelly Dimmer 2 - Parlaklık Ayarla"
category: smarthome
target: shelly-dimmer2
protocol: http
method: GET
url: "http://{ip}/light/0?turn=on&brightness={brightness}"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: brightness, label: "Parlaklık (%1-100)", type: int, min: 1, max: 100, default: 50 }
```

### Şablon: "Yumuşak uyandırma (5 sn'de %100'e)"
```yaml
id: shelly-dimmer2-wakeup
name: "Shelly Dimmer 2 - Yumuşak Uyandırma"
category: smarthome
target: shelly-dimmer2
protocol: http
method: GET
url: "http://{ip}/light/0?turn=on&brightness=100&transition=5000"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Yumuşak Uyut (10 sn'de %0'a)"
```yaml
id: shelly-dimmer2-fade-off
name: "Shelly Dimmer 2 - Yumuşak Uyut"
category: smarthome
target: shelly-dimmer2
protocol: http
method: GET
url: "http://{ip}/light/0?turn=off&transition=10000"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### Şablon: "Geçici aç (X dk sonra otomatik kapan)"
```yaml
id: shelly-dimmer2-pulse
name: "Shelly Dimmer 2 - Geçici Aç"
category: smarthome
target: shelly-dimmer2
protocol: http
method: GET
url: "http://{ip}/light/0?turn=on&brightness={brightness}&timer={duration}"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: brightness, label: "Parlaklık (%)", type: int, default: 70 }
  - { key: duration, label: "Süre (saniye)", type: int, default: 600 }
```

---

## Hata Kodları

| Cevap | Anlam |
|---|---|
| `200 OK` + JSON | Başarılı |
| `400` | Yanlış parametre (örn. brightness=0 veya 101) |
| `401` | Auth yanlış |
| `404` | Yanlış endpoint |

---

## Sorun Giderme

- Işık titreşiyor → `min_brightness_on_toggle` ayarı çok düşük, %10 dene
- Geçişler ani → `transition` parametresi 0 mı? Veya varsayılan transition ayarlandı mı?
- LED %1'de bile yanmıyor → kalibrasyon yap (`calibrate=true`)
- Aşırı ısınma → yük çok yüksek (220W limit), yük tipi yanlış (`leading_edge` ayarını değiştir)
- Bağlanmıyor → cihazın "neutral" kablosu var mı? (Shelly Dimmer 2 nötr gerektirir)
