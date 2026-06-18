# Tablo C — LebensSpur Event Listesi

Event bus (`sk_event_bus`) tüm aktif taşıyıcılara (BLE notify, WiFi TCP, USB NDJSON) asenkron push eder.

**Machine format** (her event bir NDJSON satırı):
```json
{"evt":"timer.tick","data":{"remaining":604783},"seq":1234,"ts":1713960000}
```

**Human format** (terminal görünümü, filtrelenebilir):
```
[14:23:07] EVT timer.tick remaining=604783
```

APP `events.subscribe` ile filter yapabilir:
```json
{"cmd":"events.subscribe","args":{"filter":["timer.*","relay.*","alarm.*"]},"id":N}
```

---

## Timer events [cihaz]

| Event | Payload | Tetikleyici | Taşıyıcı |
|---|---|---|---|
| `timer.tick` | `{remaining, state}` | Her saniye (timer running iken) | tüm + filtreli |
| `timer.set` | timer_state_t | `timer.set` komutu | tüm |
| `timer.restart` | timer_state_t | `timer.restart` / buton basımı / webhook | tüm |
| `timer.cancel` | `{state:"stopped"}` | `timer.cancel` | tüm |
| `timer.expired` | `{reason:"main"\|"vacation"}` | Süre doldu — action'lar başladı | tüm |
| `timer.alarm.triggered` | `{index:0..9, remaining}` | Erken uyarı tetiği | tüm |
| `timer.vacation.started` | `{days, remaining}` | `timer.vacation.set` | tüm |
| `timer.vacation.ended` | — | Tatil süresi doldu veya cancel | tüm |

`timer.tick` gürültülü — SKAPP UI aktifken abone olur, arka planda kapatılır.

---

## Button events [sk_io]

| Event | Payload | Tetikleyici |
|---|---|---|
| `button.pressed` | `{duration_ms}` | Kısa basım (< 1 sn) |
| `button.long-press` | `{duration_ms:3000}` | 3 sn basım → pairing mode açılır |
| `button.factory-reset-armed` | `{count, timeout_ms}` | 5x basım dizisi başladı, onay bekleniyor |
| `button.factory-reset` | — | 5x tamamlandı, factory reset başlıyor |

---

## Relay events [cihaz + sk_io]

| Event | Payload |
|---|---|
| `relay.state` | `{state:"on"\|"off", reason:"manual"\|"timer"\|"webhook"\|"api"\|"test"}` |

---

## Log events [sk_storage]

| Event | Payload |
|---|---|
| `log.added` | `{timestamp, boot_count, type:"SYSTEM"\|"WIFI"\|"TIMER"\|"SMTP"\|"ERROR"\|"OTA"\|"RESTART"\|"HW", message}` |

SKAPP log ekranı aktifken abone; arka planda sadece `type=ERROR` gelir.

---

## Network events [sk_network]

| Event | Payload | Tetikleyici |
|---|---|---|
| `wifi.state` | `{state:"connected"\|"disconnected"\|"connecting", ssid?, ip?, rssi?}` | STA state değişti |
| `wifi.ip.acquired` | `{ip, gateway, static:bool}` | DHCP veya static IP alındı |
| `wifi.ip.lost` | `{last_ip}` | Bağlantı kesildi |
| `wifi.scan.done` | `{networks:[...]}` | `wifi.scan` tamamlandı |
| `mdns.announced` | `{hostname, service, port}` | mDNS servis ilk yayın |

---

## Auth events [sk_auth]

| Event | Payload |
|---|---|
| `pairing.mode.open` | `{timeout_sec:60}` |
| `pairing.mode.close` | `{reason:"timeout"\|"success"\|"user"\|"abort"}` |
| `pairing.completed` | `{bond_id, peer_transport:"ble"\|"usb"}` |
| `auth.handshake.ok` | `{transport, peer_info}` |
| `auth.handshake.fail` | `{transport, reason:"timeout"\|"invalid_response"\|"no_token"}` |
| `auth.token.rotated` | — (token kendisi ASLA event'te görünmez) |
| `auth.bond.revoked` | `{bond_id, reason:"unpair_cmd"\|"factory_reset"}` |

---

## SMTP events [cihaz]

| Event | Payload |
|---|---|
| `smtp.test.progress` | `{stage:"connect"\|"tls"\|"auth"\|"data"\|"done"}` |
| `smtp.test.done` | `{success:bool, error_code?}` |
| `smtp.send.started` | `{target:"early"\|"trigger", group?, recipient}` |
| `smtp.send.success` | `{target, group?, recipient, duration_ms}` |
| `smtp.send.fail` | `{target, group?, recipient, error_code}` |

---

## Telegram events [cihaz]

| Event | Payload |
|---|---|
| `telegram.test.done` | `{success, error_code?}` |
| `telegram.send.success` | `{target:"early"\|"trigger"}` |
| `telegram.send.fail` | `{target, error_code}` |

---

## OTA events [sk_ota]

| Event | Payload |
|---|---|
| `ota.fw.state` | fw_ota_status_t (state değişince) |
| `ota.fw.progress` | `{progress_pct, bytes_downloaded, bytes_total}` |
| `ota.fw.done` | `{success, new_version, error?}` — başarıdan sonra `device.shutdown.imminent` gelir |

---

## Webhook events [sk_webhook]

| Event | Payload |
|---|---|
| `webhook.triggered` | `{endpoint:"/api/reset", source_ip, result:"ok"\|"bad_key"\|"disabled"}` |
| `webhook.rate-limit.hit` | `{endpoint, source_ip, lockout_sec}` |

---

## File transfer events [sk_file_xfer]

| Event | Payload |
|---|---|
| `file.upload.started` | `{upload_id, path, size}` |
| `file.upload.progress` | `{upload_id, bytes, total}` |
| `file.upload.done` | `{upload_id, success, error?}` |
| `file.download.started` | `{download_id, path, size}` |
| `file.download.progress` | `{download_id, bytes, total}` |
| `file.download.done` | `{download_id, success}` |

---

## Device/lifecycle events [sk_core]

| Event | Payload |
|---|---|
| `device.boot` | `{boot_count, reset_reason, fw_version, running_label}` |
| `device.shutdown.imminent` | `{reason:"restart_cmd"\|"factory_reset"\|"ota"\|"panic", delay_ms}` |
| `device.capability.changed` | `{books:[...]}` — OTA sonrası |
| `device.mode.changed` | `{mode:"human"\|"machine"}` |

---

## Event filtreleme ve throttling

### SKAPP abonelik örnekleri

**UI dashboard açık** (LS cihaz ana sayfa):
```json
{"cmd":"events.subscribe","args":{"filter":[
  "timer.*","relay.state","wifi.state","log.added","button.*"
]}}
```

**Arka plan** (cihaz listesi ekranı, bildirim gerektirir):
```json
{"cmd":"events.subscribe","args":{"filter":[
  "timer.alarm.triggered","timer.expired","ota.fw.done",
  "auth.handshake.fail","webhook.rate-limit.hit"
]}}
```

**Log görüntüleme açıkken**:
```json
{"cmd":"events.subscribe","args":{"filter":["log.added"]}}
```

### Throttling kuralları
- `timer.tick` default 1/sn; APP isterse `log.level` ile downgrade veya filter dışı bırakır
- `*.progress` event'ler rate-limited: max 10/sn per stream
- Aynı event 100ms içinde tekrar → coalesced

### Seq numarası
Her event'te monoton artan `seq`. Bağlantı kesilip yeniden açılınca APP `events.catchup --since <last_seq>` ile eksikleri talep edebilir (cihaz ring buffer'ında var ise).

---

## Özet

**~45 event türü**, aşağıdaki ana gruplar:

| Grup | Event sayısı | Kitap |
|---|---|---|
| timer | 8 | cihaz |
| button | 4 | sk_io |
| relay | 1 | cihaz + sk_io |
| log | 1 | sk_storage |
| wifi/mdns | 5 | sk_network |
| auth/pairing | 7 | sk_auth |
| smtp | 5 | cihaz |
| telegram | 3 | cihaz |
| ota.fw | 3 | sk_ota |
| webhook | 2 | sk_webhook |
| file | 6 | sk_file_xfer |
| device/lifecycle | 4 | sk_core |
