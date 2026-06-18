# Wiz LED Strip — Tam API Komut Listesi

**Cihaz:** Wiz Connected LED Strip (RGB)
**Modeller:** Wiz LED Strip Lightbar (2m, 3m, 4m, 5m)
**Protokol:** UDP, port 38899
**Format:** JSON (color-bulb ile aynı)

> Wiz LED Strip API'si **Wiz Color Bulb ile aynıdır** — tek farkı fiziksel form.
> Renk + parlaklık + Kelvin + 32 sahne tam destekli.

---

## API Komutları

LED Strip'in API'si tamamen `color-bulb.md` ile aynıdır. Bu dosyada **özet + LED Strip'e özel kullanım önerileri**.

### Aç
```json
UDP → IP:38899
{ "method": "setPilot", "params": { "state": true } }
```

### Kapat
```json
{ "method": "setPilot", "params": { "state": false } }
```

### RGB renk
```json
{ "method": "setPilot", "params": { "state": true, "r": 255, "g": 0, "b": 100 } }
```

### Beyaz tonu (Kelvin)
```json
{ "method": "setPilot", "params": { "state": true, "temp": 4000 } }
```

### Parlaklık
```json
{ "method": "setPilot", "params": { "state": true, "dimming": 50 } }
```

### Sahne (32 sahne destekli)
```json
{ "method": "setPilot", "params": { "state": true, "sceneId": 4 } }
```

Tüm parametre detayları için: [color-bulb.md](color-bulb.md)

---

## LED Strip'e Özel Notlar

### Strip uzunluğu
- Wiz Strip 2m → tüm strip aynı renk gösterir
- Strip **adreslenebilir değil** — tüm LED'ler aynı renk olur (segment-by-segment kontrol yok)
- Multi-zone istiyorsan ESPHome WLED veya benzer cihazlara bak

### En iyi sahneler (LED Strip için)
- **TV time (ID 18)** — TV arkası mavi tonları, göz yormayan
- **Fireplace (ID 5)** — Sıcak amber, salon ortamı
- **Pulse (ID 31)** — Müzik partisi
- **Wake up (ID 9)** — Yatak başı yumuşak uyandırma
- **Bedtime (ID 10)** — Uyku öncesi söndürme

### Senkron Strip + Bulb
Aynı SKAPP action chain'inde hem Strip'i hem Bulb'u tetikle:
```yaml
endpoints:
  - { protocol: udp, port: 38899, target_ip: "{strip_ip}", payload: { "method": "setPilot", "params": { "state": true, "sceneId": 5 } } }
  - { protocol: udp, port: 38899, target_ip: "{bulb_ip}", payload: { "method": "setPilot", "params": { "state": true, "sceneId": 5 } } }
```

---

## SKAPI Şablonları

### "Strip aç (TV time sahne)"
```yaml
id: wiz-strip-tv
name: "Wiz Strip - TV Time"
category: smarthome
target: wiz-strip
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true, "sceneId": 18, "dimming": 70 } }
params:
  - { key: ip, label: "Strip IP", type: ip, required: true }
```

### "Strip kapat"
```yaml
id: wiz-strip-off
name: "Wiz Strip - Kapat"
category: smarthome
target: wiz-strip
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": false } }
params:
  - { key: ip, label: "Strip IP", type: ip, required: true }
```

### "Strip renk seç"
```yaml
id: wiz-strip-color
name: "Wiz Strip - Renk Seç"
category: smarthome
target: wiz-strip
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true, "r": "{r}", "g": "{g}", "b": "{b}", "dimming": "{brightness}" } }
params:
  - { key: ip, label: "Strip IP", type: ip, required: true }
  - { key: r, label: "R (0-255)", type: int, default: 255 }
  - { key: g, label: "G (0-255)", type: int, default: 0 }
  - { key: b, label: "B (0-255)", type: int, default: 100 }
  - { key: brightness, label: "Parlaklık", type: int, default: 80 }
```

### "Mola modu (mavi yumuşak)"
```yaml
id: wiz-strip-break
name: "Wiz Strip - Mola Modu"
category: smarthome
target: wiz-strip
protocol: udp
port: 38899
payload: { "method": "setPilot", "params": { "state": true, "r": 50, "g": 100, "b": 200, "dimming": 30 } }
params:
  - { key: ip, label: "Strip IP", type: ip, required: true }
```
