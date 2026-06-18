# Philips Hue — Genel Rehber

Philips Hue, Zigbee tabanlı akıllı aydınlatma ekosistemi. **Hue Bridge** yerel HTTP REST API sunar.

---

## Mimari

```
Hue ampul/cihaz ──Zigbee──► Hue Bridge ──HTTP REST──► Yerel ağ
                            (kabloyla router'a bağlı)
```

- Bireysel ampul **doğrudan** Wi-Fi'ya bağlanmaz
- Tüm komutlar **Bridge** üzerinden gider
- Bridge yerel HTTPS API sunar (port 443)
- Ayrıca **Hue Cloud API** (uzaktan kontrol için) ve **Entertainment API** (gerçek zamanlı sync için) vardır

---

## Auth — Application Key (Username)

Bridge ile konuşmak için bir **application key** gerekir. Bir kez kurulur.

### Bridge IP'sini bul
```
GET https://discovery.meethue.com/
```

Cevap:
```json
[
  { "id": "001788ABCDEF1234", "internalipaddress": "192.168.1.30", "port": 443 }
]
```

### Application key al (Bridge'in fiziksel butonuna basıp 30 saniye içinde)
```http
POST https://192.168.1.30/api
Content-Type: application/json

{ "devicetype": "skapp#mycomputer", "generateclientkey": true }
```

Cevap (Link butonuna basılıysa):
```json
[
  {
    "success": {
      "username": "abc123XYZ...",
      "clientkey": "ABC..."
    }
  }
]
```

Bu `username` artık **API key** olarak kullanılır.

### Sonraki tüm istekler bu key'i içerir
```
GET https://192.168.1.30/api/{USERNAME}/lights
```

veya yeni v2 API:
```
GET https://192.168.1.30/clip/v2/resource/light
hue-application-key: {USERNAME}
```

---

## API Sürümleri

| Sürüm | Endpoint | Format | Notlar |
|---|---|---|---|
| **v1 (CLIP API)** | `/api/{username}/...` | JSON | Eski ama hâlâ destekli, basit |
| **v2 (CLIP API)** | `/clip/v2/resource/...` | JSON | Yeni, daha tutarlı, EventStream desteği |
| **Entertainment** | UDP DTLS | Binary | Gerçek zamanlı sync (oyun/video için) |

> **Tavsiye:** SKAPI için **v1** yeterli — daha basit, daha çok örnek var.
> İleride EventStream (real-time event push) gerekirse v2'ye geç.

---

## Hue Cihaz Tipleri

- **Ampuller** — White, White Ambiance (tunable), White & Color (RGB)
- **LightStrip** — Plus, Outdoor, Gradient (gradient = tek strip'te birden fazla renk)
- **Spot** — Centura, Adore, Argenta
- **Dimmer Switch** — uzaktan kumanda
- **Tap Dial Switch** — yeni, dial + 4 buton
- **Motion Sensor**
- **Smart Plug** — sadece on/off
- **Smart Button** — tek butonlu uzaktan kumanda

---

## Bu Klasördeki Dosyalar

- [bulb-control.md](bulb-control.md) — Tek ampul kontrolü (on/off, brightness, color, ct)
- [groups-and-scenes.md](groups-and-scenes.md) — Gruplar (oda) + sahneler
- light-strip.md — LightStrip (gradient dahil) — yakında
- sensors.md — Motion, dimmer button event'leri — yakında
- discovery.md — Bridge keşfi + cihaz listeleme — yakında

---

## Hızlı Test

API key aldıktan sonra tarayıcıda test et:
```
http://192.168.1.30/api/{USERNAME}/lights
```

Tüm ampullerin listesi gelmeli.

---

## Hue vs Wiz vs Shelly Karşılaştırması

| Özellik | Hue | Wiz | Shelly Bulb |
|---|---|---|---|
| Bridge gerekli | ✅ Evet | ❌ Hayır | ❌ Hayır |
| Protokol | Zigbee + HTTPS | Wi-Fi UDP | Wi-Fi HTTP |
| Auth | API key | Yok (yerel) | Opsiyonel |
| Renk kalitesi | Çok iyi | İyi | İyi |
| Fiyat (per ampul) | Yüksek | Düşük | Orta |
| Ekosistem | Geniş | Orta | Sınırlı |
| Entertainment sync | ✅ DTLS | ❌ | ❌ |
| Yerel API | ✅ | ✅ | ✅ |
