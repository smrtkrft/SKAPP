# Shelly EM (Gen1) — Tam API Komut Listesi

**Model:** SHEM
**Nesil:** Gen1
**Özellikler:** **Enerji ölçer** — 1 röle (kontaktor kontrolü için 2A) + 2 CT clamp (her biri 50A veya 120A)
**Use case:** Tüm ev veya belirli devrenin enerji izleme
**Protokol:** HTTP REST, MQTT, CoAP

> EM, "Energy Meter" — temel görevi enerji ölçmek (relay sadece kontaktor için).

---

## 1. Cihaz Bilgileri

```
GET http://192.168.1.42/shelly
```

**Cevap:**
```json
{
  "type": "SHEM",
  "mac": "...",
  "auth": false,
  "num_outputs": 1,
  "num_meters": 2,
  "num_emeters": 2
}
```

---

## 2. Röle (Kontaktor Kontrolü)

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

> **Uyarı:** EM'in rölesi sadece **2A**! Doğrudan büyük yük bağlama, kontaktör veya benzeri tetiklemek için kullan.

---

## 3. Energy Meter Okuma (Asıl Özellik)

### CT Clamp 0 verileri
```
GET http://192.168.1.42/emeter/0
```

**Cevap:**
```json
{
  "power": 1240.5,            // Watt
  "pf": 0.95,                 // Power factor (0-1)
  "current": 5.42,            // Amper
  "voltage": 230.5,           // Volt
  "is_valid": true,
  "total": 2456789.12,        // Wh toplam
  "total_returned": 0.0       // Wh net export (solar için)
}
```

### CT Clamp 1 verileri
```
GET http://192.168.1.42/emeter/1
```

### CT 0 → CSV log indir
```
GET http://192.168.1.42/emeter/0/em_data.csv
```

CSV formatı:
```
timestamp,is_valid,power,pf,current,voltage,total
1709123400,1,1240.5,0.95,5.42,230.5,2456789
...
```

### CT 1 → CSV log
```
GET http://192.168.1.42/emeter/1/em_data.csv
```

### Toplam tüketim sıfırla
```
GET http://192.168.1.42/emeter/0/em_data?clear_total=true
```

---

## 4. Konfigürasyon

### CT clamp tipi (50A veya 120A)
```
GET http://192.168.1.42/settings/emeter/0?ctraf_type=50
GET http://192.168.1.42/settings/emeter/0?ctraf_type=120
```

### Voltaj kalibrasyonu (manuel düzeltme)
```
GET http://192.168.1.42/settings/emeter/0?voltage=230
```

### Enerji raporlama aralığı
```
GET http://192.168.1.42/settings?coiot_update_period=15
```

### Max Power koruması
```
GET http://192.168.1.42/settings/emeter/0?max_power=11000
```

11kW üzerinde uyarı/aksiyon tetiklenebilir.

---

## 5. Webhook / Actions (Energy Events)

Action isimleri:
- `over_power_url_0` — CT 0 aşırı güç
- `over_power_url_1` — CT 1 aşırı güç
- `over_temperature_url` — cihaz aşırı ısınma
- `out_on_url`, `out_off_url` — röle

```
GET http://192.168.1.42/settings/actions?index=0&name=over_power_url_0&enabled=true&urls[]=http://YOUR-SERVER/alert
```

---

## 6. MQTT Topic'leri

Röle:
- `shellies/shellyem-XXX/relay/0` — durum
- `shellies/shellyem-XXX/relay/0/command` — `on`/`off`

Energy meters:
- `shellies/shellyem-XXX/emeter/0/power` — anlık W
- `shellies/shellyem-XXX/emeter/0/pf` — power factor
- `shellies/shellyem-XXX/emeter/0/current` — A
- `shellies/shellyem-XXX/emeter/0/voltage` — V
- `shellies/shellyem-XXX/emeter/0/total` — Wh toplam
- `shellies/shellyem-XXX/emeter/0/total_returned` — Wh export
- `shellies/shellyem-XXX/emeter/1/...` — ikinci CT

---

## 7. Cihaz Yönetimi

```
GET http://192.168.1.42/reboot
GET http://192.168.1.42/ota?update=true
GET http://192.168.1.42/settings?reset=true
```

---

## SKAPI Action Şablonları

### "Anlık ev tüketimi oku"
```yaml
id: shelly-em-power
name: "Shelly EM - Anlık Güç"
category: smarthome
target: shelly-em
protocol: http
method: GET
url: "http://{ip}/emeter/{ct}"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: ct, label: "CT Clamp (0 veya 1)", type: int, min: 0, max: 1, default: 0 }
```

### "Solar export'u oku" (total_returned)
```yaml
id: shelly-em-solar
name: "Shelly EM - Solar Export"
category: smarthome
target: shelly-em
protocol: http
method: GET
url: "http://{ip}/emeter/0"
note: "Cevaptaki total_returned alanı net export (Wh) gösterir"
```

### "Kontaktor aç (yüksek güç tüketici devre)"
```yaml
id: shelly-em-relay-on
name: "Shelly EM - Kontaktor Aç"
category: smarthome
target: shelly-em
protocol: http
method: GET
url: "http://{ip}/relay/0?turn=on"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
```

### "Sayaç sıfırla"
```yaml
id: shelly-em-reset-counter
name: "Shelly EM - Sayaç Sıfırla"
category: smarthome
target: shelly-em
protocol: http
method: GET
url: "http://{ip}/emeter/{ct}/em_data?clear_total=true"
params:
  - { key: ip, label: "Cihaz IP", type: ip, required: true }
  - { key: ct, label: "CT Clamp", type: int, default: 0 }
```

---

## Kullanım Senaryoları

- **Solar PV monitör:** CT 1'i şebeke girişine bağla, `total_returned` ile satılan elektriği takip et
- **Aşırı tüketim uyarısı:** `over_power_url_0` → telefon bildirimi
- **Yüksek tarife saatinde otomatik kapama:** schedule + relay kontrolü
- **Buzdolabı tüketim takibi:** Tek devreyi CT 0'a bağla
