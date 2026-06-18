# Tablo B — LebensSpur CLI Komut Tablosu

LS cihazının 40+ API endpoint'inin CLI komutuna karşılıkları.

**İki mod — aynı komut:**
- Machine (NDJSON): `{"cmd":"timer.set","args":{...},"id":N,"nonce":...,"ts":...,"sig":...}` → `{"id":N,"ok":true,"data":{...}}`
- Human (PuTTY): `timer set 7 days` → renkli çıktı + Prensip #11 inline-help

**Legend**: `[sk_*]` = kitap | `[cihaz]` = LS-özel | **Critical** = `device.confirm-token.get` ile tek-kullanımlık token şart

---

## Namespace `timer` [cihaz]

| Komut (machine / human) | Args | Response | Hatalar |
|---|---|---|---|
| `timer.status` / `timer status` | — | `{state, remaining, total, alarms_total, alarm_count_remaining, vacation:{enabled,remaining,total}}` | — |
| `timer.set` / `timer set <v> <unit>` | `{value:1..60, unit:"days"\|"hours"\|"minutes"}` | timer_state_t | `ERR_INVALID_UNIT`, `ERR_INVALID_VALUE`, `ERR_NVS_WRITE` |
| `timer.restart` / `timer restart` | — | timer_state_t | — |
| `timer.cancel` / `timer cancel` | — | `{state:"stopped"}` | — |
| `timer.vacation.set` / `timer vacation <d>` | `{days:1..60}` | timer_state_t | `ERR_INVALID_VALUE` |
| `timer.vacation.cancel` / `timer vacation cancel` | — | timer_state_t | — |
| `timer.alarm-count.set` / `timer alarm-count <n>` | `{count:0..10}` | `{alarms_total:n}` | `ERR_INVALID_VALUE` |

**Inline-help örneği** (`timer status`):
```
Current timer:
  state         : running
  remaining     : 6d 23h 47m (604 783 sec)
  total         : 7 days (604 800 sec)
  alarms        : 3 early warnings
  vacation      : off

To change: timer set <value> <unit>
  <value>       : 1-60
  <unit>        : days | hours | minutes

Example: timer set 7 days
Tip: 'timer restart' resets countdown; 'timer vacation <days>' pauses.
```

---

## Namespace `relay` [cihaz + sk_io GPIO]

| Komut | Args | Response | Hatalar |
|---|---|---|---|
| `relay.status` / `relay status` | — | `{state:"on"\|"off", mode:"NC"\|"NO", duration_sec, pulse_enabled, delay_sec, inverted}` | — |
| `relay.set` / `relay set <mode> <dur> <pulse> [delay]` | `{mode:0\|1, duration:0..65535, pulse:0\|1, delay?:0..255}` | relay_state | `ERR_INVALID_VALUE`, `ERR_NVS_WRITE` |
| `relay.test` / `relay test` | — | `{triggered:true}` | — |
| `relay.trigger` / `relay trigger` | — | `{state:"on"}` | — |
| `relay.off` / `relay off` | — | `{state:"off"}` | — |

**Inline-help örneği** (`relay status`):
```
Current relay:
  state         : OFF
  mode          : NO (normally open)    [1]
  duration      : 5 sec                  [2]
  pulse         : enabled                [3]
  delay         : 1 sec                  [4]
  inverted      : no

To change: relay set <mode> <duration> <pulse> [delay]
  [1] <mode>    : 0 = NC (normally closed)
                  1 = NO (normally open)
  [2] <duration>: 0-65535 sec (0 = sustained)
  [3] <pulse>   : 0 = solid, 1 = pulsed
  [4] <delay>   : 0-255 sec (optional, default 0)

Example: relay set 1 5 1 2   (NO, 5s, pulsed, 2s delay)
Tip: 'relay test' fires a short pulse for verification.
```

---

## Namespace `wifi` [sk_network]

AP modu kaldırıldı. Sadece STA + scan + backup.

| Komut | Args | Response | Hatalar |
|---|---|---|---|
| `wifi.status` / `wifi status` | — | `{connected:bool, ssid, ip, rssi, mac, static:bool, dhcp_lease_sec?}` | — |
| `wifi.connect` / `wifi connect <ssid> [--pass P] [--static CIDR]` | `{ssid, pass?, static?}` | connection result | `ERR_WIFI_AUTH`, `ERR_WIFI_TIMEOUT`, `ERR_INVALID_CIDR` |
| `wifi.disconnect` / `wifi disconnect` | — | `{state:"disconnected"}` | — |
| `wifi.scan` / `wifi scan` | — | `{networks:[{ssid,rssi,auth}...]}` | `ERR_WIFI_SCAN_FAIL` |
| `wifi.config.get` / `wifi config` | — | `{primary:{ssid,has_pass,static?}, backup:{ssid,has_pass,static?}}` | — |
| `wifi.backup.save` / `wifi backup save <ssid> --pass P [--static CIDR]` | `{ssid,pass,static?}` | `{ok:true}` | `ERR_NVS_WRITE` |
| `wifi.backup.clear` / `wifi backup clear` | — | `{ok:true}` | — |
| `wifi.primary.clear` / `wifi primary clear` | — | `{ok:true}` | — |

---

## Namespace `smtp` [cihaz]

| Komut | Args | Response | Hatalar |
|---|---|---|---|
| `smtp.get` / `smtp get` | — | `{configured:bool, server, port, user, has_api_key, masked_key}` | — |
| `smtp.save` / `smtp save --server S --port P --user U --key K` | `smtp_config_t` | `{configured:true}` | `ERR_INVALID_ARG`, `ERR_NVS_WRITE` |
| `smtp.test` / `smtp test` | — | async (bkz. event `smtp.test.*`) | `ERR_SMTP_NO_CONFIG`, `ERR_WIFI_NOT_CONNECTED`, `ERR_BUSY` |

---

## Namespace `telegram` [cihaz]

| Komut | Args | Response | Hatalar |
|---|---|---|---|
| `telegram.get` / `telegram get` | — | `{configured, chat_id, message_preview, has_token}` | — |
| `telegram.save` / `telegram save --token T --chat C --msg M` | `telegram_config_t` | `{configured:true}` | `ERR_INVALID_ARG`, `ERR_NVS_WRITE` |
| `telegram.test` / `telegram test` | — | async (event'ler) | `ERR_TELEGRAM_NO_CONFIG`, `ERR_WIFI_NOT_CONNECTED` |

---

## Namespace `mail.early` [cihaz]

Erken uyarı maili (alarm tetiklenince gönderilir).

| Komut | Args | Response | Hatalar |
|---|---|---|---|
| `mail.early.get` / `mail early get` | — | `{email, subject, body}` | — |
| `mail.early.save` / `mail early save --email E --subject S --body B` | `{email, subject, body}` | `{ok:true}` | `ERR_INVALID_EMAIL`, `ERR_NVS_WRITE` |

---

## Namespace `mail.trigger` [cihaz]

Tetikleme mail grupları (max 10; timer dolunca tümü gönderilir).

| Komut | Args | Response | Hatalar |
|---|---|---|---|
| `mail.trigger.get` / `mail trigger list` | — | `{groups:[{id:0..9, subject, body, recipients, attachment_count}...], count}` | — |
| `mail.trigger.save` / `mail trigger save --id N --subject S --body B --rcpt R` | `{id, subject, body, recipients}` | `{ok:true}` | `ERR_INVALID_VALUE`, `ERR_NVS_FULL` |
| `mail.trigger.delete` / `mail trigger delete --id N` | `{id}` | `{ok:true}` | `ERR_NOT_FOUND` |
| `mail.trigger.file.list` / `mail trigger files --group N` | `{group:0..9}` | `{files:[{name,size}...]}` | `ERR_NOT_FOUND` |
| `mail.trigger.file.delete` / `mail trigger file-delete --group N --name F` | `{group, name}` | `{ok:true}` | `ERR_FILE_NOT_FOUND` |

Dosya yükleme için `file.upload` (aşağıda) + `target=mail.trigger.group{N}` parametre kullanılır.

---

## Namespace `actions` [cihaz]

Tetik aksiyonları bayrakları.

| Komut | Args | Response | Hatalar |
|---|---|---|---|
| `actions.get` / `actions get` | — | `{early_mail:bool, early_tg:bool, trig_mail:bool, trig_relay:bool}` | — |
| `actions.save` / `actions save --early-mail 0/1 --early-tg 0/1 --trig-mail 0/1 --trig-relay 0/1` | same 4 bool | `{ok:true}` | `ERR_NVS_WRITE` |

---

## Namespace `log` [sk_storage]

| Komut | Args | Response | Hatalar |
|---|---|---|---|
| `log.list` / `log list [--count N] [--type T]` | `{count?:int, type?:enum}` | `{entries:[{timestamp,boot_count,type,message}...]}` | — |
| `log.clear` / `log clear` | — | `{cleared:N}` | **Critical** |

---

## Namespace `ota.fw` [sk_ota]

| Komut | Args | Response | Hatalar |
|---|---|---|---|
| `ota.fw.info` / `ota fw info` | — | `{running_label, current_version, can_rollback, rollback_version}` | — |
| `ota.fw.check` / `ota fw check [--url U]` | `{url?}` | async (event'ler) | `ERR_WIFI_NOT_CONNECTED`, `ERR_BUSY` |
| `ota.fw.start` / `ota fw start` | — | async (event'ler) | **Critical**, `ERR_NO_UPDATE`, `ERR_BUSY` |
| `ota.fw.status` / `ota fw status` | — | fw_ota_status_t | — |
| `ota.fw.rollback` / `ota fw rollback` | — | `{ok:true}` + restart imminent | **Critical**, `ERR_NO_ROLLBACK` |

---

## Namespace `device` [sk_core]

| Komut | Args | Response | Hatalar |
|---|---|---|---|
| `device.info` / `device info` | — | `{id, fw_version, uptime_sec, boot_count, mode:"human"\|"machine"}` | — |
| `device.detail` / `device detail` | — | system_info_t (chip_model, cores, cpu_freq, flash_size, heap, reset_reason, ...) | — |
| `device.restart` / `device restart` | — | `{restarting:true}` | **Critical** |
| `device.factory-reset` / `device factory-reset` | — | `{reset:true}` | **Critical** |
| `device.capabilities` / `device capabilities` | — | `{books:[{name,version}...], commands:[...], events:[...]}` | — |
| `device.confirm-token.get` / `device confirm-token` | `{action?}` | `{token, ttl_sec:30}` | `ERR_BUSY` |

---

## Namespace `file` [sk_file_xfer]

Chunked base64 + CRC. BLE'de toplam >500KB reddedilir.

| Komut | Args | Response | Hatalar |
|---|---|---|---|
| `file.upload.init` / `file upload <path> <size> [--hash H] [--target T]` | `{path, size, hash?, target?}` | `{upload_id, chunk_size_max}` | `ERR_FILE_TOO_LARGE_FOR_BLE`, `ERR_NO_SPACE` |
| `file.upload.chunk` | `{upload_id, offset, data_b64, crc32}` | `{received:bytes}` | `ERR_CRC_MISMATCH`, `ERR_UNKNOWN_UPLOAD` |
| `file.upload.finish` | `{upload_id}` | `{ok:true, hash}` | `ERR_HASH_MISMATCH`, `ERR_INCOMPLETE` |
| `file.download.init` / `file download <path>` | `{path}` | `{download_id, size, hash, chunk_size}` | `ERR_FILE_NOT_FOUND` |
| `file.download.chunk` | `{download_id, offset}` | `{data_b64, crc32}` | `ERR_UNKNOWN_DOWNLOAD` |
| `file.list` / `file list <path>` | `{path}` | `{entries:[{name, size, is_dir}...]}` | `ERR_NOT_FOUND` |
| `file.delete` / `file delete <path>` | `{path}` | `{ok:true}` | `ERR_FILE_NOT_FOUND` |

---

## Namespace `webhook` [sk_webhook]

External virtual button API (IFTTT/Zapier/cron için).

| Komut | Args | Response | Hatalar |
|---|---|---|---|
| `webhook.reset.config.get` / `webhook reset config` | — | `{enabled, has_key, masked_key}` | — |
| `webhook.reset.config.set` / `webhook reset config --enabled 0/1` | `{enabled:bool}` | `{ok:true}` | `ERR_NVS_WRITE` |
| `webhook.reset.key.generate` / `webhook reset generate-key` | — | `{api_key, enabled:true}` | — |
| `webhook.reset.key.clear` / `webhook reset clear-key` | — | `{ok:true}` | **Critical** |

External HTTP endpoint `GET /api/reset?key=xxx` **aynen korunur** (harici otomasyonlar bozulmasın). Rate limit: 1s gecikme, 5 yanlıştan sonra 60s lock, 20'den sonra 1h endpoint kapalı.

---

## Namespace `pairing` + `auth` [sk_auth]

| Komut | Args | Response | Hatalar |
|---|---|---|---|
| `pairing.status` / `pairing status` | — | `{mode:"idle"\|"open", bonds_count, bonds:[{id, peer, created_at}...]}` | — |
| `pairing.start` / `pairing start` | — | `{mode:"open", timeout_sec:60}` | `ERR_BUSY` (zaten açık) |
| `pairing.stop` / `pairing stop` | — | `{mode:"idle"}` | — |
| `ble.unpair` / `ble unpair <bond_id\|--all>` | `{bond_id?, all?:bool}` | `{unpaired:N}` | **Critical**, `ERR_NOT_FOUND` |
| `auth.token.rotate` / `auth token rotate` | — | `{rotated:true}` + disconnect imminent | **Critical** |

Not: `pairing.start` USB'den de çağrılabilir (SKAPP-USB pairing akışı, BLE ile simetrik). Fiziksel buton 3 sn basım ile aynı davranışı tetikler.

---

## Namespace `system` [sk_core]

| Komut | Args | Response |
|---|---|---|
| `system.heap` / `system heap` | — | `{total, free, min_free}` |
| `system.uptime` / `system uptime` | — | `{seconds, boot_count}` |
| `system.reset-reason` / `system reset-reason` | — | `{reason:"Power on"\|"Panic"\|"WDT"\|...}` |

---

## Meta komutlar [sk_core]

| Komut | Açıklama |
|---|---|
| `help` / `?` | Tüm namespace listesi. `help <ns>` → namespace subcommand'ları. `help <ns> <cmd>` → detay syntax + örnek. |
| `json on` / `json off` | Mode toggle. Auto-detect: ilk mesaj `{` ise machine moda geçer. |
| `events.subscribe` | `{filter:["timer.*","relay.*"]}` — sadece belirli event'lere abone. Default: tümü. |
| `events.unsubscribe` | `{filter:[...]}` |
| `log.level` / `log level <tag> <level>` | Event stream'deki log gürültüsünü kontrol et. |
| `exit` / `quit` / Ctrl+D | BLE/TCP disconnect; USB'de ignore |

---

## Merkezi hata kodları [sk_errors]

Cihazdan sadece **kod + params** gelir; çeviri SKAPP (ARB).

### Protokol/auth
| Kod | Anlam |
|---|---|
| `ERR_UNKNOWN_COMMAND` | Bilinmeyen komut |
| `ERR_INVALID_ARG` | Arg tipi/değeri hatalı |
| `ERR_MISSING_ARG` | Zorunlu arg eksik |
| `ERR_NOT_AUTHENTICATED` | Handshake geçilmedi |
| `ERR_NONCE_REPLAY` | Nonce tekrar |
| `ERR_TIMESTAMP_OUT_OF_WINDOW` | ±60 sn dışında |
| `ERR_HMAC_INVALID` | İmza hatası |
| `ERR_CONFIRM_TOKEN_REQUIRED` | Kritik komut, token gerek |
| `ERR_CONFIRM_TOKEN_INVALID` | Token yanlış/geçmiş |

### Storage/bus
| Kod | Anlam |
|---|---|
| `ERR_NVS_READ`, `ERR_NVS_WRITE`, `ERR_NVS_FULL` | NVS hataları |
| `ERR_FILE_NOT_FOUND`, `ERR_FILE_TOO_LARGE_FOR_BLE`, `ERR_FILE_CRC_MISMATCH`, `ERR_FILE_HASH_MISMATCH`, `ERR_NO_SPACE` | Dosya hataları |

### Ağ
| Kod | Anlam |
|---|---|
| `ERR_WIFI_NOT_CONNECTED`, `ERR_WIFI_AUTH`, `ERR_WIFI_TIMEOUT`, `ERR_WIFI_SCAN_FAIL` | WiFi hataları |
| `ERR_INVALID_CIDR` | Static IP format hatası |

### Timer/Relay
| Kod | Anlam |
|---|---|
| `ERR_INVALID_UNIT`, `ERR_INVALID_VALUE` | Timer/relay parametre |
| `ERR_NOT_FOUND` | Grup/dosya/bond yok |

### Entegrasyon
| Kod | Anlam |
|---|---|
| `ERR_SMTP_NO_CONFIG`, `ERR_SMTP_AUTH`, `ERR_SMTP_CONNECT`, `ERR_SMTP_TLS`, `ERR_INVALID_EMAIL` | SMTP |
| `ERR_TELEGRAM_NO_CONFIG`, `ERR_TELEGRAM_API` | Telegram |

### OTA/durum
| Kod | Anlam |
|---|---|
| `ERR_OTA_IN_PROGRESS`, `ERR_NO_UPDATE`, `ERR_NO_ROLLBACK` | OTA |
| `ERR_BUSY` | Meşgul |

### BLE
| Kod | Anlam |
|---|---|
| `ERR_BLE_NO_BOND`, `ERR_PAIRING_MODE_CLOSED` | BLE/auth |

(Liste implementasyon sırasında genişler; `sk_errors.h` merkezi enum + metinler.)

---

## Özet

**66 komut** + meta (help/json/events/log.level) + **38 hata kodu** + 1 external webhook endpoint.

| Namespace | Komut | Kitap |
|---|---|---|
| `timer` | 7 | cihaz |
| `relay` | 5 | cihaz + sk_io |
| `wifi` | 8 | sk_network |
| `smtp` | 3 | cihaz |
| `telegram` | 3 | cihaz |
| `mail.early` | 2 | cihaz |
| `mail.trigger` | 5 | cihaz |
| `actions` | 2 | cihaz |
| `log` | 2 | sk_storage |
| `ota.fw` | 5 | sk_ota |
| `device` | 6 | sk_core |
| `file` | 7 | sk_file_xfer |
| `webhook` | 4 | sk_webhook |
| `pairing`+`auth` | 5 | sk_auth |
| `system` | 3 | sk_core |
| meta | 4+ | sk_core |
