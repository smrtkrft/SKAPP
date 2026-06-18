# SKAPP Library

SmartKraft cihazlarının ortak ESP-IDF altyapı kütüphanesi. `sk_core` her SmartKraft cihazda zorunlu baseline'dır; üstüne ihtiyaç duyulursa `sk_api` opsiyonel olarak eklenir.

## Felsefe

Her SmartKraft cihazı SKAPP (Flutter) ile aynı protokolle konuşur. Bu protokolün altyapısı (CLI, BLE, WiFi, auth, event bus, OTA, vb.) her cihazda yeniden yazılmaz — burada bir kez yazılır, kütüphane olarak dahil edilir. Cihaz üstüne kendi iş mantığını (timer, sensor, röle, vb.) koyar.

## Paketler (2 toplam)

| Paket | Durum | Zorunlu? | Görev |
|---|---|---|---|
| `sk_core` | tamam | EVET | Identity (`XX-YZZZZZZZZ`) + CLI + event bus + errors + capabilities + USB Serial/JTAG transport + BLE GATT + WiFi STA + mDNS + TCP NDJSON + secure session (ECDH + Mutual C-R + per-message HMAC) + button + LED I/O + control button gesture interpreter + **firmware OTA** (manifest-driven, semver compare, sha256 verify, A/B + rollback) |
| `sk_api` | tamam | opsiyonel | Cihazdan dışarıya HTTP/HTTPS çağrıları. Tam kapsama: 4 endpoint type (generic, telegram, ifttt, webhook_post) × 4 HTTP method (POST/GET/PUT/DELETE) × 4 auth scheme (none, bearer, basic, custom_header) + custom Content-Type. NVS-persisted, async worker, TLS cert bundle, JSON escape, master enable, 7 CLI komutu (`api.*`) |

## Bağımlılık grafiği

```
       sk_core (zorunlu)  ← her şeyin temeli
       │ identity, CLI, event bus, errors, capabilities
       │ USB Serial/JTAG, BLE GATT, WiFi/mDNS, TCP NDJSON
       │ auth (ECDH + C-R + HMAC), button + LED I/O
       │ control button gesture interpreter (BLE-on / restart / factory-reset)
       │ firmware OTA (manifest-driven, semver, sha256, A/B + rollback)
       │
       └─── sk_api         (opsiyonel, cihazdan dışarıya HTTP/HTTPS)
```

## Klasör yapısı

```
skapp-library/
├── README.md                 (bu dosya)
├── CMakeLists.txt            (Faz 0 starter projesi)
├── sdkconfig.defaults
├── main/                     (Faz 0 ham başlangıç firmware'ı)
├── sk_core/                  (ZORUNLU baseline, OTA dahil)
├── sk_api/                   (opsiyonel — outbound HTTP/HTTPS)
├── protocol/
│   └── v1/                   (JSON Schema sözleşmesi)
└── examples/
    └── minimal/              (yeni cihaz başlangıç şablonu)
```

## Kullanım

Cihaz firmware'ı `main/CMakeLists.txt` içinde sadece kullanacağı paketleri PRIV_REQUIRES'a ekler:

```cmake
PRIV_REQUIRES sk_core sk_ota nvs_flash
```

Component manager `EXTRA_COMPONENT_DIRS` ile bu klasöre bakacak şekilde ayarlanır. Local geliştirmede registry'e gerek yok.

## Örnek cihaz paket seçimleri

- **LebensSpur** (zengin): 2 paket — sk_core + sk_api
- **Blocking Focus** (minimalist): 1 paket — sadece sk_core (BLE + buton + OTA zaten içeride)
- **Faz 0 starter**: sk_core (yeterli) — `idf.py monitor` ile uçtan uca test

> Diyagnostik log saklama veya büyük dosya transferi (log dump, ses dosyası, kalibrasyon snapshot) gereken cihazlar için ileride ayrıca yazılacak — bu repo'da bulunmaz, ihtiyaç duyan cihazın kendi component'ı olur.

## Versiyonlama

Her paket bağımsız semver. sk_core 0.3.0'da (USB + connect + I/O merge'leri sonrası), opsiyoneller 0.1.0'da. `sk_capabilities` cihazın sağladığı komut setinin runtime sürüm bilgisini APP'e bildirir.

## Protokol sözleşmesi (`protocol/v1/`)

Cihaz ↔ APP arasındaki sözleşme JSON Schema olarak tutulur:
- `commands.json` — her CLI komutunun args ve response şeması
- `events.json` — event payload şemaları
- `errors.json` — ERR_* kod kataloğu
- `auth.md` — pairing + handshake + HMAC spec

**Durum:** klasör boş — ileride doldurulacak.

## Lisans

SmartKraft açık kaynak ekosistemi. Firmware + HW açık, APP kapalı. Lisans detayı (AGPL-3.0 muhtemel) ürün çıkışında netleşecek.
