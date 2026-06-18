# Tablo A — Dosya Bazında Değişiklik Listesi

LS mevcut kodunun her component'ının yeni yapıda nereye gittiği, ne olduğu. Bu tablo **LS migration guide** olarak da hizmet eder.

**Legend**:
- 🗑 **SİL** — dosya/klasör tamamen kaldırılacak
- 🔄 **TAŞI** — başka konuma (muhtemelen `skapp-library/`'ye)
- ✂ **KIRP** — belli fonksiyonlar silinir, kalanı kalır
- ✏ **REVİZE** — yerinde düzenleme (event bus entegrasyonu vb.)
- ⭐ **KALIR** — cihaz-özel, dokunulmaz
- ➕ **YENİ** — yeni dosya/component

---

## 1. `main/main.c` ✏ **REVİZE** (550 → ~100 satır)

### Silinecekler
| Satır | Ne |
|---|---|
| 19-30 | `#include "web_server.h"`, `"gui_ota.h"`, `"flash_sync.h"` |
| 52 | `web_server_send_timer_event()` — on_button_pressed içinde |
| 293 | `web_server_send_timer_event()` — on_timer_expired içinde |
| 407 | `web_server_send_timer_event()` — tick callback |
| 427-441 | `gui_ota_init()` bloğu |
| 444-462 | `wifi_manager_init()` + AP init + web_server_start() bloğu |
| 299-328 | `generate_device_name()` fonksiyonu (sk_identity'ye taşınacak) |
| 470-539 | Flash bilgi yazdırma bloğu (sk_core startup banner'a taşınır) |

### Eklenecekler
```c
// Yeni imports
#include "sk_core.h"
#include "sk_auth.h"
#include "sk_io_button.h"
#include "sk_transport_usb.h"
#include "sk_transport_ble.h"
#include "sk_network.h"
#include "sk_storage.h"
#include "sk_ota.h"
#include "sk_webhook.h"
#include "sk_file_xfer.h"
// LS-özel
#include "ls_cli_registry.h"
#include "timer_manager.h"
#include "relay_control.h"
#include "smtp_client.h"
#include "telegram_client.h"
```

### Yeni app_main iskeleti
```c
void app_main(void)
{
    sk_core_init(&(sk_core_cfg_t){
        .device_type_prefix = "LS",
        .fw_version = FW_VERSION,
    });
    sk_storage_init();
    sk_auth_init();
    sk_io_button_init(&button_callbacks);  // pairing/factory reset dispatch
    
    // LS-özel business logic
    timer_manager_init();
    relay_control_init();
    smtp_client_init();
    telegram_client_init();
    ls_cli_register_all();  // timer, relay, mail, actions CLI komutları
    
    // Transport layers — sk_cli'ya otomatik register eder
    sk_transport_usb_init();
    sk_transport_ble_init();
    
    // Network-dependent: WiFi state event'i geldiğinde başlar
    sk_network_init();
    sk_ota_init();
    sk_webhook_init();
    
    sk_capabilities_publish();
    sk_event_bus_publish(EVT_DEVICE_BOOT, ...);
}
```

Callback'ler event bus üzerinden yayınlanır (`sk_event_bus_publish(EVT_TIMER_TICK, ...)`), doğrudan web_server çağırılmaz.

---

## 2. `components/web_server/` 🗑 **SİL** + ➕ **`components/webhook_server/` YENİ**

### SİL
`components/web_server/` tamamı (2361 satır).

### Taşınacak (sadece reset mantığı → webhook_server)
| Kaynak | Hedef |
|---|---|
| `web_server.c:1455-1489` `api_reset_config_get_handler` | `webhook_server.c` |
| `web_server.c:1493-1518` `api_reset_config_save_handler` | `webhook_server.c` |
| `web_server.c:1522-1545` `api_reset_generate_handler` | `webhook_server.c` |
| `web_server.c:1549-1591` `api_reset_handler` | `webhook_server.c` |
| NVS namespace `ls_reset` | aynen korunur |

### YENİ webhook_server
- ~200 satır, minimal esp_http_server
- Sadece `/api/reset*` endpoint'leri
- Tarayıcı GUI, SSE, CORS yok
- Rate limit: `sk_webhook` kitabından kullanır

### CLI karşılıkları
Tablo B'deki `webhook.reset.*` komutları `components/ls_cli/ls_webhook_cmds.c`'de register edilir.

---

## 3. `components/wifi_manager/` 🔄 **TAŞI → `skapp-library/sk_network/`** (769 → ~500)

### Silinecek (AP kodu)
| Fonksiyon / Sembol | Satır civarı |
|---|---|
| `WIFI_AP_CHANNEL`, `WIFI_AP_MAX_CONN` makroları | header |
| `wifi_manager_start_ap()` | ~80 satır |
| `wifi_manager_set_ap_enabled()` / `_is_ap_enabled()` | ~40 satır |
| `wifi_manager_get_ap_ssid()` | header + impl |
| AP dalı `wifi_event_handler` | ~60 satır |
| Captive portal / DNS hijack kodu (varsa) | — |

### Korunacak (STA) — `sk_wifi` API'sine dönüşür
| Eski API | Yeni API |
|---|---|
| `wifi_manager_init(device_name)` | `sk_wifi_init()` — device_name sk_identity'den alınır |
| `wifi_manager_connect_sta(ssid, pass, static)` | `sk_wifi_connect_sta(...)` |
| `wifi_manager_auto_connect()` | `sk_wifi_auto_connect()` |
| `wifi_manager_save_backup(...)` | `sk_wifi_save_backup(...)` |
| `wifi_manager_has_saved_config()` / `_has_backup_config()` | `sk_wifi_has_config_primary/backup()` |
| `wifi_manager_is_connected()` | `sk_wifi_is_connected()` |
| `wifi_manager_get_ip()` | `sk_wifi_get_ip()` |
| `wifi_manager_get_sta_ssid()` | `sk_wifi_get_ssid()` |
| `wifi_manager_clear_primary/backup()` | aynı isim, prefix değişir |

### Eklenecek
- WiFi scan (`sk_wifi_scan()` → `networks[]`)
- Event bus entegrasyonu: her state değişiminde `sk_event_bus_publish(EVT_WIFI_STATE, ...)`

---

## 4. `components/gui_ota/` 🗑 **SİL** (523 satır → 0)

Tarayıcı GUI artık yok. Slot A/B mantığı, GitHub indirme, LittleFS yazma — hepsi gereksiz.

---

## 5. `components/fw_ota/` 🔄 **TAŞI → `skapp-library/sk_ota/`** (491 satır)

### API geçişi
| Eski | Yeni |
|---|---|
| `fw_ota_init()` | `sk_ota_init()` |
| `fw_ota_check(url)` | `sk_ota_check(url)` |
| `fw_ota_start()` | `sk_ota_start()` |
| `fw_ota_get_status(&st)` | `sk_ota_get_status(&st)` |
| `fw_ota_rollback()` | `sk_ota_rollback()` |
| `fw_ota_is_busy()`, `fw_ota_can_rollback()` | aynı isim, prefix değişir |
| `fw_ota_get_running_label()`, `fw_ota_get_rollback_version()` | aynı isim |
| `fw_ota_status_t` struct | `sk_ota_status_t` |
| enum `FW_OTA_*` | `SK_OTA_*` |

### Revize
- `fw_ota_status_t` değişince → `sk_event_bus_publish(EVT_OTA_FW_STATE, ...)`
- `progress_pct` değişince → `EVT_OTA_FW_PROGRESS` (rate-limited 1/sn)
- Tamamlanınca → `EVT_OTA_FW_DONE`

---

## 6. `components/ext_flash/` ✏ **REVİZE** (837 → ~400 satır)

### Silinecek
| Fonksiyon | Satır (tahmini) |
|---|---|
| `ext_flash_slot_a_*` 8 fonksiyon | ~150 |
| `ext_flash_slot_b_*` 5 fonksiyon | ~80 |
| `ext_flash_active_*` fonksiyon ailesi | ~100 |
| `ext_flash_set_active_slot()`, `_get_active_slot()`, `_get_active_mount()`, `_get_inactive_mount()` | ~50 |
| `ext_flash_create_default_files()` (GUI dosyaları) | ~50 |
| `ext_flash_is_slot_a_mounted()`, `_is_slot_b_mounted()` | ~20 |
| `ext_flash_get_slot_a_info()`, `_get_slot_b_info()` | ~30 |
| LittleFS multi-partition mount logic | ~50 |

### Korunacak
- SPI W25Q256 init (single partition olacak)
- `ext_flash_read_file`, `ext_flash_write_file`, `ext_flash_delete_file` — user_data için
- `ext_flash_get_info()`, `ext_flash_format_user_data()`, `ext_flash_is_user_data_mounted()`

### CMakeLists revize
```diff
- EMBED_TXTFILES
-     "${GUI_DIR}/index.html"
-     "${GUI_DIR}/style.css"
-     "${GUI_DIR}/app.js"
-     "${GUI_DIR}/config.json"
-     "${GUI_DIR}/lang/en.json"
-     "${GUI_DIR}/lang/de.json"
-     "${GUI_DIR}/lang/es.json"
-     "${GUI_DIR}/lang/fr.json"
-     "${GUI_DIR}/lang/it.json"
-     "${GUI_DIR}/lang/tr.json"
- EMBED_FILES
-     "${GUI_DIR}/pic/logo.png"
-     "${GUI_DIR}/pic/darklogo.png"
```

GUI kaynakları artık binary'ye gömülmez.

### Harici flash partition tablosu (programmatic)
```diff
- Slot A    : 0x000000 (2 MB)  - GUI Web Arayuzu
- Slot B    : 0x200000 (2 MB)  - GUI OTA slot
- User Data : 0x400000 (28 MB) - Kullanici verileri
+ User Data : 0x000000 (32 MB) - Kullanici verileri (mail + log)
```

Sonra: muhtemelen bu component da `sk_storage` altına alınabilir (ileride sk_ext_flash olarak). Şimdilik LS'ye özel kalır.

---

## 7. `components/flash_sync/` ❓ **DEĞERLENDİR** (99 satır)

İçeriğini incele:
- Eğer sadece web server'a özgü senkronizasyon → 🗑 SİL
- NVS helper yararlı ise → 🔄 TAŞI `skapp-library/sk_storage/sk_nvs_helper/`

Implementation aşamasında fonksiyon-by-fonksiyon karar.

---

## 8. `components/timer_manager/` ⭐ **KALIR** (cihaz-özel, 490 satır)

LebensSpur'un core business logic'i. Değişmez.

### Minor revize
- `web_server_send_timer_event()` referansları → `sk_event_bus_publish(EVT_TIMER_*, ...)`
- `timer_manager_set_tick_callback()` artık direkt web_server'a değil event bus'a gönderir

---

## 9. `components/smtp_client/` ⭐ **KALIR** (cihaz-özel, 778 satır)

Dokunulmaz. Muhtemelen hata kodları `sk_errors` katalogundan gelir (ERR_SMTP_*).

---

## 10. `components/telegram_client/` ⭐ **KALIR** (cihaz-özel, 172 satır)

Dokunulmaz.

---

## 11. `components/device_log/` 🔄 **TAŞI → `skapp-library/sk_storage/sk_log/`** (249 satır)

### API geçişi
| Eski | Yeni |
|---|---|
| `device_log_init()` | `sk_log_init()` |
| `device_log_persist_init()` | `sk_log_persist_init()` |
| `device_log_add(type, fmt, ...)` | `sk_log_add(type, fmt, ...)` |
| `device_log_get_count()` | `sk_log_count()` |
| `device_log_get(idx)` | `sk_log_get(idx)` |
| `device_log_to_json(buf, size, count)` | `sk_log_to_json(...)` |
| `device_log_get_boot_count()` | `sk_log_boot_count()` |
| `device_log_entry_t` | `sk_log_entry_t` |
| `device_log_type_t` | `sk_log_type_t` |

### Eklenecek
- Her `sk_log_add()` → `sk_event_bus_publish(EVT_LOG_ADDED, entry)`

---

## 12. `components/output/` ✂ **BÖLÜN** (444 satır)

### Bölüm A → `skapp-library/sk_io/sk_button/` (~250 satır)
- Buton state machine, debounce, kısa/uzun bas detection
- Multi-tap (5x) detection
- Pairing mode tetik callback (3 sn basım)
- Factory reset callback (5x basım)
- Event bus: `EVT_BUTTON_PRESSED`, `EVT_BUTTON_LONG_PRESS`, `EVT_BUTTON_FACTORY_RESET`

### Bölüm B → `components/relay_control/` (~200 satır, LS'ye özgü)
- `relay_control_init()`
- `relay_control_trigger()`, `_off()`, `_is_on()`
- `relay_control_set_config()`, `_get_config()` (duration, pulse, delay)
- `relay_control_set_inverted()`, `_get_inverted()`
- NVS save/load config
- Pulse task
- Event bus: `EVT_RELAY_STATE`

---

## 13. `components/system_info/` 🔄 **TAŞI → `skapp-library/sk_core/sk_identity/`** (84 satır)

`system_info_get()` → `sk_core`'a taşınır, `device.detail` CLI komutunun implementasyonu olur. `system_info_t` struct aynen.

`generate_device_name()` (main.c'deki) → `sk_identity_init()` içinde.

---

## 14. ➕ **YENİ LS component'ları**

### `components/relay_control/`
Bkz. madde 12.

### `components/mail_attachments/` (~150 satır)
- `/ext/mail/gN/` klasör yönetimi
- `mail_attachments_list(group)`, `_delete(group, name)`, `_upload_chunk(...)`
- NVS yok (dosyalar LittleFS'te, listesi dizin taraması)
- Bu fonksiyonlar eski `web_server.c:1598-1795` içindeki upload/list/delete handler'larından gelir

### `components/webhook_server/` (~200 satır)
Bkz. madde 2.

### `components/ls_cli/` (~600 satır)
LS'ye özgü CLI komutlarını `sk_cli`'ya register eder. Her namespace ayrı dosya:

| Dosya | Komutlar |
|---|---|
| `ls_timer_cmds.c` | timer.* (7 komut) |
| `ls_relay_cmds.c` | relay.* (5 komut) |
| `ls_mail_cmds.c` | mail.early.*, mail.trigger.*, smtp.*, telegram.* (13 komut) |
| `ls_actions_cmds.c` | actions.* (2 komut) |
| `ls_webhook_cmds.c` | webhook.reset.* (4 komut) |
| `ls_cli_registry.c` | `ls_cli_register_all()` entry point |

---

## 15. `sdkconfig.defaults` ✏ **REVİZE**

```diff
  CONFIG_IDF_TARGET="esp32c6"
  CONFIG_ESPTOOLPY_FLASHSIZE_4MB=y
  CONFIG_ESPTOOLPY_FLASHSIZE="4MB"
  CONFIG_PARTITION_TABLE_CUSTOM=y
  CONFIG_PARTITION_TABLE_CUSTOM_FILENAME="partitions.csv"
  CONFIG_BOOTLOADER_APP_ROLLBACK_ENABLE=y
  CONFIG_SPI_FLASH_SUPPORT_BIST=y
  
- CONFIG_ESP_WIFI_SOFTAP_SUPPORT=y
- CONFIG_HTTPD_MAX_REQ_HDR_LEN=1024
- CONFIG_HTTPD_MAX_URI_LEN=512
  
  CONFIG_LWIP_MAX_SOCKETS=16
  CONFIG_ESP_TLS_USING_MBEDTLS=y
  CONFIG_NVS_ENCRYPTION=n
  CONFIG_LOG_DEFAULT_LEVEL_INFO=y
  CONFIG_LOG_DEFAULT_LEVEL=3

+ # BLE stack
+ CONFIG_BT_ENABLED=y
+ CONFIG_BT_NIMBLE_ENABLED=y
+ CONFIG_BT_NIMBLE_SM_SC=y
+ CONFIG_BT_NIMBLE_SM_BONDING=y
+ CONFIG_BT_NIMBLE_EXT_ADV=n
+ CONFIG_BT_NIMBLE_MAX_CONNECTIONS=2
+ 
+ # USB CLI
+ CONFIG_ESP_CONSOLE_USB_SERIAL_JTAG=y
+ CONFIG_USB_SERIAL_JTAG_ENABLED=y
+ 
+ # Crypto (sk_auth)
+ CONFIG_MBEDTLS_HMAC_SHA256_C=y
+ CONFIG_MBEDTLS_ECDH_C=y
+ CONFIG_MBEDTLS_ECP_DP_CURVE25519_ENABLED=y
+ 
+ # sk_core / CLI
+ CONFIG_ESP_CONSOLE_HISTORY_BUFFER_SIZE=2048
```

`sk_core` ileride kendi `sdkconfig.sk_defaults` sunar, LS onu include eder.

---

## 16. `partitions.csv` ✅ **DEĞİŞMEZ** (dahili 4MB OTA tablosu aynen)

---

## 17. `GUI/` klasörü 🔄 **ARŞİVLE**

Flutter taşıma başlamadan önce:
1. Screenshot arşivi al → `docs/legacy-gui-screenshots/` (S16 kararı)

Taşıma bitince:
- `esp32/LebensSpur/GUI/` → `docs/legacy-gui/` taşı

---

## Satır sayısı özeti

| Dosya/klasör | Öncesi | Sonrası | Fark |
|---|---|---|---|
| main/main.c | 550 | ~100 | **−450** |
| web_server/ | 2361 | 0 | **−2361** |
| webhook_server/ (yeni) | 0 | ~200 | +200 |
| wifi_manager/ | 769 | 0 (→sk_network) | −769 |
| sk_network/ (yeni kitap) | — | ~500 | +500 (ortak) |
| gui_ota/ | 523 | 0 | **−523** |
| fw_ota/ | 491 | 0 (→sk_ota) | −491 |
| sk_ota/ (yeni kitap) | — | ~500 | +500 (ortak) |
| ext_flash/ | 837 | ~400 | −437 |
| flash_sync/ | 99 | 0 (muhtemel) | −99 |
| timer_manager/ | 490 | ~490 (event bus) | 0 |
| smtp_client/ | 778 | 778 | 0 |
| telegram_client/ | 172 | 172 | 0 |
| device_log/ | 249 | 0 (→sk_log) | −249 |
| sk_log/ (yeni kitap) | — | ~260 | +260 (ortak) |
| output/ | 444 | sk_button 250 + relay_control 200 | **−0** (bölünme) |
| system_info/ | 84 | 0 (→sk_core) | −84 |
| ls_cli/ (yeni) | 0 | ~600 | +600 |
| mail_attachments/ (yeni) | 0 | ~150 | +150 |

### LS-only toplam
- Öncesi: ~7800 satır
- Sonrası: ~2900 satır LS-özel + kullanılan kitaplar
- **LS-özel koddan −4900 satır (-63%)**

### skapp-library (ortak, 1 kez yazılır, N cihaz kullanır)
- sk_core, sk_auth, sk_transport_*, sk_io, sk_network, sk_storage, sk_ota, sk_webhook, sk_file_xfer
- Toplam tahmini: **~5500-6500 satır** (ilk cihaz yazımında)
- 2. cihaz için marjinal maliyet: 0 (sadece cihaz-özel iş mantığı yazılır)

---

## Silme onayı gereken dosyalar

İmplementasyon fazı başladığında şu silmeler için **ayrı kullanıcı onayı** gerekir:

1. `components/web_server/` tüm klasör (webhook_server'a taşıma sonrası)
2. `components/gui_ota/` tüm klasör
3. `components/flash_sync/` (değerlendirme sonrası)
4. `components/system_info/` (sk_core'a taşıma sonrası)
5. `components/output/` (bölündükten sonra)
6. `components/device_log/` (sk_log'a taşıma sonrası)
7. `components/wifi_manager/` (sk_network'e taşıma sonrası)
8. `components/fw_ota/` (sk_ota'ya taşıma sonrası)
9. `ext_flash/CMakeLists.txt` EMBED_TXTFILES/EMBED_FILES bölümleri
10. `GUI/` → `docs/legacy-gui/` (screenshot sonrası)
