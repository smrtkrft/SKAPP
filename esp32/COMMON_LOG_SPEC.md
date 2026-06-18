# SKAPP Cihaz Ortak Log Standardı (sk_core)

Her SmartKraft cihazında 1:1 aynı şekilde derlenen ortak log baseline. Cihaza özgü event'ler (BF face change, LS timer triggered vs.) bu baseline'ın üzerine cihaz tarafından eklenir.

Versiyon: v1 (2026-05-25)

---

## 1. Amaç

Cihazda meydana gelen sistem olaylarını (boot, ağ, OTA, kimlik doğrulama, hatalar) yapılandırılmış (level + tag + event + key=value) bir ring buffer'a kaydetmek; `logs.get` ile hem CLI hem SKAPP tarafından çekilip incelenebilir hale getirmek.

Bu standart cihaz davranışını okunabilir kılar (post-mortem analiz, "ne oldu" sorusu) ve SKAPP'in cihazın sağlığını izleyebilmesini sağlar.

---

## 2. API

### 2.1 Log yazma (cihaz içi, sk_core)

```c
typedef enum {
    SK_LOG_DEBUG = 0,
    SK_LOG_INFO  = 1,
    SK_LOG_WARN  = 2,
    SK_LOG_ERROR = 3,
} sk_log_level_t;

// Yapılandırılmış event yaz. fmt + va_args klasik printf benzeri.
// `tag` modül adı (örn. "wifi", "ota"), `event` event ismi (örn. "connect.fail").
// Hook NimBLE-safe: çağrı non-blocking, satır arka plan task'inde ring'e yazılır.
void sk_log_event(sk_log_level_t level, const char *tag, const char *event,
                  const char *fmt, ...);

// Convenience macros (printf-style):
#define SK_LOG_E(tag, event, fmt, ...) sk_log_event(SK_LOG_ERROR, tag, event, fmt, ##__VA_ARGS__)
#define SK_LOG_W(tag, event, fmt, ...) sk_log_event(SK_LOG_WARN,  tag, event, fmt, ##__VA_ARGS__)
#define SK_LOG_I(tag, event, fmt, ...) sk_log_event(SK_LOG_INFO,  tag, event, fmt, ##__VA_ARGS__)
#define SK_LOG_D(tag, event, fmt, ...) sk_log_event(SK_LOG_DEBUG, tag, event, fmt, ##__VA_ARGS__)
```

### 2.2 logs.get (CLI / SKAPP)

Mevcut `logs.get` komutu yeni format döner:

```json
{
  "lines": [
    {"ts": 1716640000, "lvl": "I", "tag": "boot",   "event": "up",            "msg": "fw=1.2.0 reset=POWERON"},
    {"ts": 1716640005, "lvl": "I", "tag": "wifi",   "event": "connect",       "msg": "ssid=Home rssi=-52"},
    {"ts": 1716640007, "lvl": "I", "tag": "wifi",   "event": "ip.acquired",   "msg": "ip=192.168.1.50"},
    {"ts": 1716640200, "lvl": "W", "tag": "ota",    "event": "check.fail",    "msg": "reason=server_unreachable"},
    {"ts": 1716640300, "lvl": "E", "tag": "auth",   "event": "passphrase.fail","msg": "attempts_left=8"}
  ]
}
```

Geri uyumluluk: eski `"lines": [<string>, ...]` formatı kaldırılır (breaking). SKAPP yeni format'a göre güncellenmelidir.

Filtre parametreleri (mevcut):
- `logs get --limit N` (default 50, max 200)
- `logs get --level debug|info|warn|error` (en az verilen seviye)

### 2.3 Saat senkronizasyonu

`ts` (unix epoch saniye): cihaz SNTP ile saat çekemediyse veya SKAPP `time.set` yapmadıysa `0` yazılır. SKAPP UI tarafında `ts=0` "saat bilinmiyor" olarak gösterilir.

---

## 3. Ortak baseline event'ler (her cihazda %100 aynı)

| level | tag         | event                  | msg örneği                                          | Tetiklenme |
|-------|-------------|------------------------|------------------------------------------------------|------------|
| I     | boot        | up                     | `fw=1.2.0 reset=POWERON partition=ota_0`             | Her boot |
| W     | boot        | unclean                | `reset=PANIC prev_fw=1.2.0`                          | Önceki boot panik/wdt ise |
| I     | wifi        | connect                | `ssid=Home rssi=-52 slot=primary`                    | WIFI_EVENT_STA_CONNECTED |
| I     | wifi        | ip.acquired            | `ip=192.168.1.50`                                    | IP_EVENT_STA_GOT_IP |
| W     | wifi        | disconnect             | `ssid=Home reason=4 retries=1`                       | WIFI_EVENT_STA_DISCONNECTED |
| E     | wifi        | connect.fail           | `ssid=Home reason=auth_fail attempts=5`              | 5 başarısız denemeden sonra |
| W     | wifi        | scan.empty             | `(boş)`                                              | Scan sıfır AP döndü |
| I     | ble         | advertise.start        | `(boş)`                                              | Pairing window veya idle advert |
| I     | ble         | connect                | `peer=AB:CD:EF:01:02:03 mtu=247`                     | Peer bağlandı |
| I     | ble         | disconnect             | `peer=AB:CD:EF:01:02:03 reason=peer_term`            | Peer ayrıldı |
| I     | ota         | check.start            | `url=https://...`                                    | `ota check` |
| I     | ota         | check.available        | `current=1.2.0 available=1.3.0`                      | Yeni sürüm bulundu |
| I     | ota         | check.up-to-date       | `current=1.2.0`                                      | Güncel |
| E     | ota         | check.fail             | `reason=http_404` veya `reason=dns`                  | Manifest fetch fail |
| I     | ota         | install.start          | `version=1.3.0 size=812345`                          | Download başladı |
| W     | ota         | install.progress       | `pct=50`                                             | İsteğe bağlı, throttled |
| E     | ota         | install.fail.download  | `reason=timeout bytes=400000`                        | Download fail |
| E     | ota         | install.fail.verify    | `reason=sha256_mismatch`                             | SHA256 doğrulama fail |
| I     | ota         | install.success        | `version=1.3.0 reboot=imminent`                      | Flash başarılı, reboot |
| I     | ota         | rollback               | `from=1.3.0 to=1.2.0`                                | Manuel veya auto-rollback |
| I     | pairing     | open                   | `ttl=60`                                             | `pairing start` |
| I     | pairing     | close                  | `reason=timeout` veya `reason=bonded`                | Pencere kapandı |
| I     | auth        | bond.added             | `slot=0 peer=AB:CD:EF:01:02:03`                      | Yeni bond |
| I     | auth        | bond.removed           | `slot=0`                                             | `bond remove` |
| W     | auth        | passphrase.fail        | `attempts_left=8`                                    | Yanlış passphrase |
| E     | auth        | passphrase.lockout     | `triggered=factory-reset`                            | 10 yanlış → factory reset |
| I     | auth        | session.unlocked       | `slot=0`                                             | Handshake başarılı |
| E     | auth        | handshake.fail         | `reason=hmac_mismatch`                               | HMAC envelope verify fail |
| I     | api         | endpoint.fire          | `name=lights status=200 ms=320`                      | Webhook tetiklendi (her cihaz kendi event'inde) |
| E     | api         | endpoint.fail          | `name=lights reason=timeout`                         | Webhook fail |
| E     | sys         | nvs.write.fail         | `ns=sk_wifi key=ssid err=NO_SPACE`                   | NVS write hatası |
| E     | sys         | oom                    | `size=8192 where=logs_buffer`                        | Malloc fail |
| W     | sys         | mutex.timeout          | `name=event_bus ms=1000`                             | Lock alınamadı |
| I     | sys         | factory-reset          | `source=cli` veya `source=button` veya `source=skapp`| Factory reset tetiklendi |

Toplam: **~30 ortak event tipi**.

### 3.1 Severity rehberi

- **DEBUG**: yalnız geliştirici, çoğu zaman kapalı
- **INFO**: normal akış (connect, advertise, install başladı vs.)
- **WARN**: beklenmedik ama otomatik toparlanır (disconnect retry, scan empty)
- **ERROR**: kullanıcı eylemi gerekir veya işlem başarısız (auth fail, ota fail, oom)

---

## 4. Cihaza özgü event'ler (%20)

Cihazların kendi modülleri (BF: bf_vibration, bf_face_detector, bf_battery; LS: ls_timer_engine, ls_relay, ls_smtp) ortak API'yi (`SK_LOG_*` makroları) kullanarak kendi event'lerini yayar.

**BF örnek:**
```c
SK_LOG_I("face", "change", "from=%d to=%d", old, new);
SK_LOG_W("battery", "low", "voltage=%dmV pct=%d", mv, pct);
```

**LS örnek:**
```c
SK_LOG_I("timer", "triggered", "alarm=%d", alarm_idx);
SK_LOG_E("smtp", "send.fail", "group=%d reason=auth", group_id);
SK_LOG_I("relay", "fire", "duration_s=%d", duration);
```

Cihaza özgü tag'ler (`face`, `battery`, `timer`, `relay`, `smtp`, `mail`, `vibration`, `tilt`, ...) bu standart tarafından rezerve edilmez. Cihaz kendi tag uzayını yönetir.

---

## 5. Saklama ve performans

- **Ring buffer**: 64 satır × 256 byte (16 KB statik). Eski satırlar otomatik düşer.
- **Async hook**: `sk_log_event` çağrısı FreeRTOS queue'ya bir kayıt push'lar, arka plan task ring'e yazar. NimBLE host task'i bloklanmaz.
- **NVS persist YOK**: cihaz reset olunca log buffer sıfırlanır. İstisna: boot reason (`esp_reset_reason()`) bir sonraki boot'ta `boot.unclean` event'i olarak yayınlanır (RTC memory veya tek byte NVS).
- **Severity gate**: derleme zamanı `CONFIG_SK_LOG_MIN_LEVEL` (default `SK_LOG_INFO`). Debug derlemelerde DEBUG açılabilir.

---

## 6. SKAPP entegrasyonu

- `logs.get` istemcisi: `app/lib/features/devices/_common/logs_service.dart` (ortak, BF ve LS paylaşır)
- Ekran: `LogsScreen` widget'ı (BF + LS), severity filtresi (Info/Warn/Error toggle) + arama kutusu + cihaz tarafında saat geçersizse görsel uyarı
- Eski `BfLogsScreen` yerine ortak `DeviceLogsScreen` (cihaz tipinden bağımsız) konur

---

## 7. Migrasyon

1. sk_core'a `sk_log_event` API'sini ekle (header + impl + queue task)
2. NimBLE-safe hook'u aç (eski `sk_log_hook_init` yerine async sürüm)
3. Hata noktalarına `SK_LOG_*` çağrılarını yerleştir (sk_wifi, sk_ota, sk_auth, sk_passphrase, sk_api)
4. `logs.get` handler'ı yeni JSON formatına çevir
5. BF + LS firmware'lerini yeniden build et + flashla
6. SKAPP `DeviceLogsScreen`'i yeni format için güncelle
7. Test: cihazda manuel hata senaryoları (yanlış passphrase, geçersiz wifi, ota check fail) üret, logs.get çekip görüldüğünü doğrula
