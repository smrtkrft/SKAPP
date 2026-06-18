# SKAPI — Mimari Kararları

Bu dosya, SKAPI (Smartkraft API) kütüphanesinin mimari kararlarını içerir.
SKAPI, **SKAPP** Flutter uygulamasının içine entegre edilecek bir komut/şablon kütüphanesidir ve **ESP32-C6 (Xiao)** tabanlı IoT timer cihazlardan tetiklenen aksiyonları yönetir.

---

## 1. Vizyon ve Kapsam

SKAPI, kullanıcının ESP32-C6 cihazından "geri sayım bittiğinde şunu yap" kuralları kurmasını sağlayan **şablon tabanlı aksiyon kütüphanesidir**.

**Hedef senaryolar:**
- Geri sayım biter → odanın Wiz ampulü kapanır
- Geri sayım biter → laptopta YouTube sekmesi kapanır
- Geri sayım biter → laptopa "molaya çık" overlay'i açılır
- Geri sayım biter → Home Assistant scripti tetiklenir

**SKAPI ne değil:**
- Bağımsız bir uygulama değil — SKAPP içine asset olarak gömülü
- Kullanıcının yüklemesi gereken ek bir helper / servis yok
- Cloud bağımlılığı yok

---

## 2. Klasör Yapısı

```
SKAPI/
├── architecture.md   ← bu dosya
├── plan.md           ← Flutter UI render planı
├── WIN/              ← Windows endpoint şablonları
│   ├── start.md      ← Windows yetenek indeksi
│   └── *.md          ← her endpoint için bir dosya
├── MAC/              ← macOS şablonları
├── LX/               ← Linux şablonları
└── Other/            ← IoT cihazları (Wiz, Shelly, Hue, HA, Tuya...)
```

Her `.md` dosyası **hem dokümantasyon hem de SKAPP'in parse edip form'a dönüştüreceği şablondur**. Format için bkz. [plan.md](plan.md).

---

## 3. Bileşenler

| Bileşen | Rol | Çalıştığı yer |
|---|---|---|
| **ESP32-C6 (Xiao)** | Trigger source. Timer biter → action listesini sırayla fire eder | Fiziksel cihaz, kullanıcının evinde |
| **SKAPP Desktop** | GUI (konfigürasyon) + **gömülü HTTP server** (action listener) | Win / Mac / Linux laptop-PC |
| **SKAPP Mobile** | Sadece GUI. Server yok. Sade kullanım odaklı | iOS / Android |
| **SKAPI** (içeride) | Şablon kütüphanesi — `.md` dosyaları, asset olarak bundle | SKAPP'in içinde |
| **IoT cihazlar** (Wiz/Shelly/HA) | Kendi HTTP API'leri ile doğrudan tetiklenir, ek yazılım gerekmez | Aynı LAN'da |

> **Karar:** Ayrı bir "SKAPI Helper" servisi **olmayacak**. Laptop dinleyicisi SKAPP Desktop'ın kendisi olacak.

---

## 4. İletişim Protokolü

| Protokol | Kullanım | Karar |
|---|---|---|
| **HTTP REST** | Birincil iletişim. ESP32 → SKAPP, ESP32 → IoT, SKAPP → IoT | ✅ Zorunlu |
| **MQTT** | Smart home derin entegrasyonu (HA broker üzerinden) | ✅ Opsiyonel, Faz 2 |
| **WebSocket** | — | ❌ Kullanılmayacak (fire-and-forget yeterli) |
| **CoAP** | — | ❌ Kullanılmayacak (hedef ekosistem desteklemiyor) |

**Format:** JSON body, UTF-8.

---

## 5. Cihaz Keşfi

İki yöntem **birlikte** kullanılır:

### a) IP adresi (manuel veya DHCP rezervasyon)
- Kullanıcı SKAPP üzerinden cihazın IP'sini görüntüler/girer
- Router'da DHCP rezervasyonu yapılırsa IP değişmez

### b) mDNS broadcast (`_skapp._tcp.local`)
- SKAPP Desktop açıldığında kendini ağa duyurur
- ESP32 ve diğer SKAPP'ler `cem-laptop.local` gibi isimle erişir
- IP değişse bile isim sabit kalır

### Fallback davranışı
ESP32 firmware:
1. Önce mDNS ile cihazı bul
2. Bulamazsa son bilinen IP'ye dene
3. Yine başarısızsa SKAPP'e bildir, kullanıcıya hata göster

---

## 6. Cihaz Kimliği ve Yanlış Hedef Koruması

Birden fazla SKAPP instance'ı ağda olabilir → yanlış cihaz tetikleme riski.

**Çözüm:** Her SKAPP instance'ı 3 alanlı bir kimliğe sahip olur:

```yaml
device_id: 7f3a-9b21-4c08-...      # UUID v4, ilk açılışta üretilir, sabit
friendly_name: "Cem'in iş laptop'u" # kullanıcı verir
mdns_name: cem-laptop.local         # ağa yayınlanan isim
```

### Doğrulama akışı
ESP32 her aksiyon öncesi:
```
GET http://{host}:5000/api/identify
→ {"device_id": "7f3a-9b21-4c08-...", "friendly_name": "Cem'in iş laptop'u"}
```
Beklenen `device_id` ile uyuşmazsa **fire etmez**, hata loglar.

Bu sayede ESP32 başka eve götürülse bile yanlış laptop'u tetiklemez.

---

## 7. Listener Mimarisi (Laptop Tarafı)

> **Karar:** Laptop dinleyicisi **SKAPP Desktop'ın içine gömülü HTTP server** olacak. Ek kurulum yok.

```
┌─────────────────────────────────────────────────────────────┐
│  SKAPP Desktop (Flutter) — TEK kod tabanı                  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  ORTAK KATMAN                                         │   │
│  │  - HTTP server (shelf package, dart:io)               │   │
│  │  - Endpoint routing                                   │   │
│  │  - Auth (Bearer token), rate limit, logging           │   │
│  │  - mDNS broadcast (multicast_dns paketi)              │   │
│  │  - /api/identify, /api/health                         │   │
│  └──────────────────────────────────────────────────────┘   │
│                          │                                   │
│              ┌───────────┼───────────┐                       │
│              ▼           ▼           ▼                       │
│         ┌───────┐   ┌───────┐   ┌───────┐                   │
│         │  WIN  │   │  MAC  │   │ LINUX │                   │
│         │handler│   │handler│   │handler│                   │
│         └───────┘   └───────┘   └───────┘                   │
│         (platform channels veya dart:ffi)                   │
└─────────────────────────────────────────────────────────────┘
```

### Ortak ve OS'e özel ayrım
- **Ortak (cross-platform):** routing, auth, validation, logging, mDNS, JSON parse
- **OS'e özel:** native API çağrıları (volume, brightness, notification, lock, vb.)

Örnek: `POST /api/volume {value: 50}`
- Win → `IAudioEndpointVolume` COM
- Mac → `osascript -e "set volume output volume 50"`
- Linux → `pactl set-sink-volume @DEFAULT_SINK@ 50%`

WIN/MAC/LX klasörlerindeki `.md` dosyaları her OS için bu reçeteleri içerir.

---

## 8. SKAPP Yaşam Döngüsü

> **Sorun:** Kullanıcı SKAPP'i kapatırsa server ölür → ESP32 komutları işlenmez.
> **Çözüm:** Discord/Slack tarzı tray-resident davranış.

| Olay | Davranış |
|---|---|
| İlk kurulum | Boot'ta autostart kaydı yapılır (kullanıcı isterse kapatabilir) |
| Pencere [X]'i | **Tray'a iner**, server çalışmaya devam eder |
| Tray menüsü → Quit | Onay dialog'u: "API sunucusu durdurulacak, devam?" |
| Tray ikonu | Yeşil = çalışıyor, kırmızı = durdurulmuş |
| Tray menü | Pause/Resume server, Open SKAPP, Quit |

Mobile'da bu davranış **yok** — mobile sadece GUI / client.

---

## 9. Mobile vs Desktop Sorumlulukları

| Özellik | Desktop | Mobile |
|---|---|---|
| HTTP server (listener) | ✅ | ❌ |
| ESP32 konfigüre etme (GUI) | ✅ | ✅ |
| Şablon kütüphanesi browse | ✅ | ✅ |
| Action manuel tetikleme (test) | ✅ | ✅ |
| Aktivite/log görüntüleme | ✅ | ✅ |
| mDNS keşif | ✅ (yayın + tüketim) | ✅ (sadece tüketim) |
| System tray | ✅ | — |
| Autostart | ✅ | — |

Mobile'ın amacı: **el altındaki uzaktan kumanda + cihaz konfigüratörü**. Sade kalır.

---

## 10. Ağ Topolojisi

> **Karar:** Sadece **aynı Wi-Fi LAN**. İnternet bağlantısı / cloud relay yok.

```
              ┌──────────────────────────┐
              │      Ev Wi-Fi Router     │
              └────────────┬─────────────┘
                           │
        ┌─────────┬────────┼────────┬─────────────┐
        ▼         ▼        ▼        ▼             ▼
   ┌────────┐ ┌──────┐ ┌──────┐ ┌──────┐    ┌──────────┐
   │ESP32-C6│ │SKAPP │ │SKAPP │ │ Wiz  │    │  Shelly  │
   │ Xiao   │ │Desktop│ │Mobile│ │ Lamp │    │  Switch  │
   └────────┘ └──────┘ └──────┘ └──────┘    └──────────┘
```

**Sonuçlar:**
- NAT/firewall sorunu yok (LAN içi)
- Port forwarding gerek yok
- DDNS gerek yok
- Cloud servis bağımlılığı yok
- Wi-Fi düşerse sistem durur (kabul edilebilir kısıt)

---

## 11. Eşleştirme (Pairing)

> **Karar:** ESP32 ↔ SKAPP arası **mevcut protokol** kullanılır. SKAPI ek pairing logic'i tanımlamaz.

SKAPP'in ESP32 cihazını provisioning'i SKAPP projesinin sorumluluğu, SKAPI bunun üzerine inşa edilir.

---

## 12. Güvenlik

| Katman | Yöntem |
|---|---|
| Kimlik doğrulama | **Bearer token** (her SKAPP instance'ında otomatik üretilen rastgele 32 karakter) |
| Cihaz doğrulama | `/api/identify` ile `device_id` karşılaştırma (yanlış hedef koruması) |
| Ağ izolasyonu | LAN-only — cihaz dışarıya açık değil |
| IP whitelist | Opsiyonel (yalnızca ESP32 IP'sinden istek kabul) |
| TLS | Opsiyonel (LAN içi self-signed sertifika veya plain HTTP) |
| Rate limit | Endpoint başına saniyede X istek |
| Logging | Her isteği zaman damgası, kaynak IP, endpoint, sonuç ile logla |

---

## 13. Action Şablon Formatı

Her `.md` dosyası YAML frontmatter + Markdown body içerir.

```markdown
---
id: volume-set
name: "Ses seviyesini ayarla"
category: audio
os: [win, mac, lx]
icon: volume_up
risk: safe
params:
  - key: value
    label: "Seviye (0-100)"
    type: int
    min: 0
    max: 100
    required: true
endpoint:
  method: POST
  path: /api/volume
  body: { "value": "{{value}}" }
---

## Ne yapar
Ana ses seviyesini 0-100 arasında ayarlar.

## OS implementasyonu
- **Win:** `IAudioEndpointVolume` COM interface
- **Mac:** `osascript -e "set volume output volume {{value}}"`
- **Linux:** `pactl set-sink-volume @DEFAULT_SINK@ {{value}}%`

## Güvenlik
Veri kaybı yok. Geri alınabilir.
```

Tam format kuralları için bkz. [plan.md](plan.md) §3.

---

## 14. Karar Özeti

| Karar | Sonuç |
|---|---|
| Listener nerede? | SKAPP Desktop'ın içinde gömülü HTTP server |
| Ek kurulum? | Yok |
| Protokol? | HTTP REST (zorunlu) + MQTT (opsiyonel, Faz 2) |
| Keşif? | mDNS + IP, fallback'li |
| Cihaz kimliği? | UUID + friendly_name + identify endpoint |
| 3 OS yaklaşımı? | Tek codebase, ortak protokol, OS'e özel handler |
| Mobile? | Sadece GUI, server yok |
| Ağ? | LAN-only, cloud yok |
| Pairing? | Mevcut SKAPP protokolü, SKAPI dokunmuyor |
| Şablon formatı? | YAML frontmatter + Markdown body, asset olarak bundle |

---

## 15. Faz Planı

| Faz | Kapsam |
|---|---|
| **Faz 1 (MVP)** | HTTP REST server, 10-15 endpoint Win için, mDNS, identify, tray, autostart |
| **Faz 2** | Mac + Linux handler'ları, Other/ klasörü (Wiz, Shelly, HA template'leri) |
| **Faz 3** | MQTT subscriber (opsiyonel), online template güncelleme, gelişmiş gamification |

Detaylı endpoint listesi için bkz. `WIN/start.md`.
