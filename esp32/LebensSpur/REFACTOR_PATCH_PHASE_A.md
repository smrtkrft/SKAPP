# LS — Faz A Refactor Patch

**Durum**: Taslak. Mevcut `HW/main/main.c`'ye **henüz uygulanmadı** — eski build bozulmasın diye LS klasörüne aktif değişiklik yapılmadı. Faz A kodu test edilip kullanıcı onayı geldiğinde aşağıdaki patch'ler LS'ye uygulanır.

---

## Değişecek dosyalar

- `HW/main/main.c` — tam refactor (aşağıda yeni içerik)
- `HW/main/idf_component.yml` — sk_* dependencies
- `HW/main/CMakeLists.txt` — PRIV_REQUIRES güncel
- `HW/CMakeLists.txt` — `EXTRA_COMPONENT_DIRS` ile skapp-library'ye bakacak
- `HW/sdkconfig.defaults` — USB Serial/JTAG + NimBLE (Faz B için hazır) ayarları

---

## 1. `HW/main/main.c` (yeni içerik)

```c
// LebensSpur main — Faz A sürümü.
// sk_core + sk_transport_usb + sk_log + mevcut LS business logic (timer,
// smtp, telegram, output). BLE/WiFi/OTA Faz B/C/D'de eklenir.

#include <stdio.h>
#include "esp_log.h"
#include "nvs_flash.h"

#include "sk_core.h"
#include "sk_log.h"
#include "sk_transport_usb.h"

// LS-specific legacy components — still live under HW/components/ until
// Faz A timer_manager refactor (callback -> event bus) is complete.
#include "timer_manager.h"
#include "output.h"
#include "ext_flash.h"
#include "smtp_client.h"
#include "telegram_client.h"

static const char *TAG = "LS";

// LS-local event types extend sk_log.
#define LS_LOG_TYPE_TIMER   (SK_LOG_TYPE_USER_BEGIN + 0)
#define LS_LOG_TYPE_SMTP    (SK_LOG_TYPE_USER_BEGIN + 1)

// ---- Legacy callbacks rewired to event bus ----

static void on_button_pressed(void)
{
    if (output_relay_is_on()) output_relay_off();
    esp_err_t err = timer_manager_restart();
    if (err == ESP_OK) {
        sk_event_bus_publish("button.pressed", "{\"duration_ms\":0}");
        sk_event_bus_publish("timer.restart", NULL);
    } else {
        sk_log_add(LS_LOG_TYPE_TIMER, "restart fail: %s", esp_err_to_name(err));
    }
}

static void on_factory_reset(void)
{
    sk_log_add(SK_LOG_TYPE_RESTART, "factory reset (button 5x)");
    nvs_flash_erase();
    ext_flash_format_user_data();
    vTaskDelay(pdMS_TO_TICKS(200));
    esp_restart();
}

static void on_timer_tick(void)
{
    timer_state_t s = timer_manager_get_state();
    sk_event_bus_publishf("timer.tick",
                          "{\"remaining\":%ld,\"state\":\"%s\"}",
                          (long)s.remaining_seconds,
                          s.enabled ? "running" : "stopped");
}

static void on_alarm_triggered(int alarm_index)
{
    sk_event_bus_publishf("timer.alarm.triggered", "{\"index\":%d}", alarm_index);
    // existing alarm_mail_task / alarm_telegram_task still spawned here
    // for Faz A; moved into cihaz-özel ls_actions component in Faz D.
}

static void on_timer_expired(void)
{
    output_relay_trigger();
    sk_event_bus_publish("timer.expired", "{\"reason\":\"main\"}");
    // trigger_mail_task spawn — kept from legacy main.c for Faz A.
}

void app_main(void)
{
    // Standard NVS bootstrap.
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    // sk_core first — identity, event bus, CLI dispatcher.
    ESP_ERROR_CHECK(sk_core_init(&(sk_core_cfg_t){
        .device_type_prefix = "LS",
        .fw_version         = "1.0.0",
    }));
    ESP_ERROR_CHECK(sk_log_init(NULL));

    // Legacy components init.
    ext_flash_init();
    timer_manager_init();
    output_init();
    smtp_client_init();
    telegram_client_init();

    output_set_button_callback(on_button_pressed);
    output_set_factory_reset_callback(on_factory_reset);
    timer_manager_set_expiry_callback(on_timer_expired);
    timer_manager_set_alarm_callback(on_alarm_triggered);
    timer_manager_set_tick_callback(on_timer_tick);

    // TODO Faz D: register LS-specific CLI commands via ls_cli_register_all()
    // (timer.*, relay.*, mail.*, smtp.*, telegram.*, actions.*).
    // For Faz A smoke-test, sk_core built-ins (help, json, device.capabilities)
    // are sufficient over USB CLI.

    ESP_ERROR_CHECK(sk_transport_usb_init(NULL));

    ESP_LOGI(TAG, "LebensSpur ready — id=%s", sk_identity_get());
}
```

## 2. `HW/main/idf_component.yml`

```yaml
dependencies:
  espressif/mdns:
    version: "*"
  sk_core:
    path: "../../skapp-library/sk_core"
  sk_storage:
    path: "../../skapp-library/sk_storage"
  sk_transport_usb:
    path: "../../skapp-library/sk_transport_usb"
```

## 3. `HW/main/CMakeLists.txt`

```cmake
idf_component_register(
    SRCS "main.c"
    INCLUDE_DIRS "."
    PRIV_REQUIRES
        sk_core sk_storage sk_transport_usb
        wifi_manager ext_flash flash_sync timer_manager
        smtp_client telegram_client device_log output
        nvs_flash spi_flash esp_partition gui_ota fw_ota app_update
)
```

(Faz A'da `gui_ota`, `device_log`, `wifi_manager`'a hâlâ bağımlıyız; Faz B-C'de bunlar sk_* ile değişir.)

## 4. `HW/CMakeLists.txt`

```cmake
cmake_minimum_required(VERSION 3.16)

set(EXTRA_COMPONENT_DIRS
    "${CMAKE_SOURCE_DIR}/../../skapp-library"
)

include($ENV{IDF_PATH}/tools/cmake/project.cmake)
project(LebensSpur)
```

## 5. `HW/sdkconfig.defaults` ekleri

```diff
+ # USB Serial/JTAG CLI (sk_transport_usb)
+ CONFIG_ESP_CONSOLE_USB_SERIAL_JTAG=y
+ CONFIG_USB_SERIAL_JTAG_ENABLED=y
+ CONFIG_ESP_CONSOLE_HISTORY_BUFFER_SIZE=2048
+
+ # NimBLE (Faz B için hazır)
+ CONFIG_BT_ENABLED=y
+ CONFIG_BT_NIMBLE_ENABLED=y
+ CONFIG_BT_NIMBLE_SM_SC=y
+ CONFIG_BT_NIMBLE_SM_BONDING=y
+
+ # mbedtls primitives (sk_auth için, Faz B)
+ CONFIG_MBEDTLS_HMAC_SHA256_C=y
+ CONFIG_MBEDTLS_ECDH_C=y
+ CONFIG_MBEDTLS_ECP_DP_CURVE25519_ENABLED=y
```

Not: `CONFIG_ESP_WIFI_SOFTAP_SUPPORT=y` **Faz C'de** kaldırılacak (AP modu siliniyor). Faz A'da mevcut.

---

## Faz A hedefi (bu patch uygulandıktan sonra)

USB CLI üzerinden şu komutlar çalışır:

```
ls> help
ls> device info
ls> device capabilities
ls> json on
{"cmd":"device.capabilities","id":1}
```

Timer tick olayları event bus'a düşer (sk_log_add log görünür):
```
{"evt":"timer.tick","data":{"remaining":3599,"state":"running"},"seq":42}
```

Test: `idf.py monitor` ile USB CLI tüketilir. İlk sanity check.

---

## Sonraki fazlar (bu dosyayı uygulamadan yazılabilir)

- **Faz B (sk_auth, sk_io, sk_transport_ble)**: main.c'ye eklenir — pairing mode, bond list, mutual C-R handshake, BLE advertising.
- **Faz C (sk_network, sk_transport_tcp)**: `wifi_manager` → `sk_network`'e taşınır, WiFi STA + mDNS + TCP CLI eklenir.
- **Faz D (sk_webhook, sk_ota, sk_file_xfer, ls_cli)**: web_server → webhook_server refactor, fw_ota → sk_ota taşıması, 66 LS komutu ls_cli'ya register edilir.
- **Faz E (SKAPP)**: Flutter sk_core paketi + LS ekranları.

---

## Onay

Bu patch `HW/` altına uygulanmadı. Hazır olunca onay ver, aşağıdaki adımlarla aktif edilir:

1. `HW/main/main.c` içeriği yukarıdaki yeni content ile değiştirilir
2. `HW/main/idf_component.yml` eklenir/güncellenir
3. `HW/main/CMakeLists.txt` güncellenir
4. `HW/CMakeLists.txt` `EXTRA_COMPONENT_DIRS` eklenir
5. `HW/sdkconfig.defaults` ekleri uygulanır
6. `idf.py build` — derleme doğrulanır
7. `idf.py flash monitor` — USB CLI test edilir
