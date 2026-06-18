# Home Assistant Entegrasyonu — Genel Rehber

Home Assistant (HA), açık kaynak ev otomasyonu platformu. **HTTP REST API**, **WebSocket API**, **MQTT** üzerinden entegre olur.

---

## Mimari Pozisyon

```
ESP32 ──HTTP──► HA REST API ──► HA otomasyon motoru ──► Cihazlar
                                                       (Zigbee, MQTT, vs.)
```

**HA'yı SKAPI'de hedef olarak kullanmak iki şekilde olur:**

1. **HA'yı tetikle:** ESP32 → HA REST API → HA scripti/sahnesi/otomasyonu çalışır → o da kendi cihazlarını kontrol eder
2. **HA cihazlarını direkt:** HA'da entegre edilmiş cihazları HA üzerinden kontrol et (Bridge benzeri kullan)

> Genel kural: HA varsa cihazları **HA üzerinden** kontrol et. Çünkü HA tüm karmaşıklığı (Zigbee bridge, marka API'leri, auth) üstlenmiş.

---

## Auth — Long-Lived Access Token

HA REST API için **long-lived access token** gerekir.

### Token oluşturma
1. HA arayüzü → **Profil** (sol alt) → **Long-Lived Access Tokens**
2. **Create Token** → İsim ver → Kopyala (bir kez gösterilir!)

### Kullanım
```
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...
```

---

## API Endpoint'leri

**Base URL:** `http://{HA_IP}:8123` (varsayılan port)

| Endpoint | Amaç |
|---|---|
| `/api/` | Health check |
| `/api/states` | Tüm entity durumları |
| `/api/states/{entity_id}` | Tek entity durumu |
| `/api/services` | Tüm servisler listesi |
| `/api/services/{domain}/{service}` | Servis çağır (asıl komut!) |
| `/api/events/{event_type}` | Event fire et |
| `/api/template` | Template render et |
| `/api/config` | HA config oku |
| `/api/error_log` | Hata logu |
| `/api/history/period` | Geçmiş veri |
| `/api/calendars` | Takvim entegrasyonları |
| `/api/conversation/process` | Voice/text intent |

---

## Bu Klasördeki Dosyalar

- [rest-api.md](rest-api.md) — Tam REST API + auth + state okuma
- [services.md](services.md) — Service call (cihaz tetikleme) — en çok kullanılan
- websocket.md — WebSocket API (real-time event akışı) — yakında
- automations-and-scripts.md — Otomasyon ve script tetikleme — yakında
- helpers.md — Input boolean/select/number helper'ları — yakında

---

## Hızlı Test

API çalışıyor mu?
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" http://192.168.1.20:8123/api/
```

Cevap:
```json
{ "message": "API running." }
```

---

## Servisi Çağırma (En Yaygın Senaryo)

HA'da bir ışığı açmak için:
```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "light.salon_lambasi"}' \
  http://192.168.1.20:8123/api/services/light/turn_on
```

Bu HA'daki **light.turn_on** servisini çağırır, hedef entity `light.salon_lambasi` olur.

---

## HA vs Direkt API Karşılaştırması

| Konu | Direkt cihaz API'si | HA üzerinden |
|---|---|---|
| Karmaşıklık | Cihaz bazında değişir | Tek API, tüm cihazlar |
| Auth | Cihaz bazında | Tek token |
| Discovery | Manuel IP girme | HA otomatik bulur |
| State takibi | Sürekli polling | Event-driven (WebSocket) |
| Otomasyon | SKAPP yapar | HA da yapabilir, kombinasyon olur |
| HA gerekli mi? | Hayır | Evet, kurulum/config işi var |

> SKAPI'nin pozisyonu: **kullanıcı HA varsa kullan, yoksa direkt cihazlara da git**. Her iki yol da template kataloğunda olsun.
