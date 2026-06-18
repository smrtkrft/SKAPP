// =====================================================================
// SKAPP — Faz 0 Universal Starter
// =====================================================================
// Common bootstrap for any SmartKraft ESP32 device firmware. To start a
// new device: fill in each EDIT block below, then build/flash. Disable
// any optional subsystem you don't need by flipping its ENABLE flag to 0.
// sk_core is mandatory and pulls the full SmartKraft baseline (USB CLI,
// BLE, WiFi/mDNS, TCP, secure session, button I/O).
// =====================================================================

#include <string.h>

#include "esp_log.h"
#include "nvs_flash.h"

#include "sk_core.h"   // umbrella — pulls every public sk_core API (incl. sk_ota)
#include "sk_api.h"    // outbound HTTP (Telegram, IFTTT, generic POST)

// === EDIT [sk_core] ==================================================
//
// 2-char uppercase ASCII (A-Z) device type code.
//   "BF" = Blocking Focus, "LS" = LebensSpur, ... One per device family.
#define SK_DEVICE_TYPE_PREFIX   "XX"

// Single uppercase letter (A-Z) for hardware revision.
//   'A' = first fab batch, 'B' = second, ... Bump per PCB rev.
#define SK_HW_REV               'A'

// Firmware version — semver. Bump on every release.
#define SK_FW_VERSION           "0.1.0"

// Optional build tag (git sha, CI build number). NULL = none.
#define SK_BUILD_INFO           NULL
//
// === EDIT [Control button] ===========================================
//
// Single hardware button drives BLE-on (short press), restart (5 s hold)
// and factory reset (10 s hold). Required on every SmartKraft device.
#define SK_BUTTON_GPIO          9       // ESP32-C6 DevKitC-1 boot button
#define SK_BUTTON_ACTIVE_LOW    1
//
// === EDIT [Wireless] =================================================
//
// TCP NDJSON port — also announced via mDNS as `_skapp._tcp`.
#define SK_TCP_PORT             8080
//
// === EDIT [Optional features] ========================================
#define SK_API_ENABLE           1   // Outbound HTTP (Telegram, IFTTT, generic)
//
// === EDIT [sk_ota] ===================================================
//
// Firmware OTA — manifest-driven, version-aware, manual user trigger.
// Set SK_OTA_MANIFEST_URL to the manifest.json URL on your release host.
// Empty string disables OTA entirely (sk_ota_init becomes a no-op).
//
// GitHub Releases pattern:
//   https://github.com/<owner>/<repo>/releases/latest/download/manifest.json
//
// Each release uploads manifest.json with shape:
//   { "version":"1.2.3", "url":"https://.../firmware.bin", "sha256":"<64hex>" }
#define SK_OTA_ENABLE           1
#define SK_OTA_MANIFEST_URL     ""
// =====================================================================

// Compile-time guards — typos in EDIT block are caught now, not at first boot.
_Static_assert(sizeof(SK_DEVICE_TYPE_PREFIX) == 3,
               "SK_DEVICE_TYPE_PREFIX must be exactly 2 ASCII characters");
_Static_assert(SK_HW_REV >= 'A' && SK_HW_REV <= 'Z',
               "SK_HW_REV must be an uppercase letter 'A' through 'Z'");
_Static_assert(SK_BUTTON_GPIO >= 0,
               "SK_BUTTON_GPIO must be a valid GPIO number");
_Static_assert(SK_TCP_PORT > 0 && SK_TCP_PORT < 65536,
               "SK_TCP_PORT must be a valid TCP port (1-65535)");

static const char *TAG = "main";

void app_main(void)
{
    // NVS bootstrap — almost every sk_* library uses NVS.
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    // sk_core: identity, CLI, event bus, errors, capabilities, USB CLI.
    ESP_ERROR_CHECK(sk_core_init(&(sk_core_cfg_t){
        .device_type_prefix = SK_DEVICE_TYPE_PREFIX,
        .hw_rev             = SK_HW_REV,
        .fw_version         = SK_FW_VERSION,
        .build_info         = SK_BUILD_INFO,
    }));

    if (strcmp(SK_DEVICE_TYPE_PREFIX, "XX") == 0) {
        ESP_LOGW(TAG, "SK_DEVICE_TYPE_PREFIX is still the placeholder 'XX' — "
                      "edit main.c with your device type code (e.g. \"LS\").");
    }

    ESP_ERROR_CHECK(sk_transport_usb_init(NULL));

    // Auth subscriptions (control.short-press, factory-reset) registered first
    // so a button press during boot is captured rather than dropped — the
    // button polling task starts only after sk_button_init below.
    ESP_ERROR_CHECK(sk_auth_init());
    ESP_ERROR_CHECK(sk_passphrase_init());

    // Control button — drives pairing/BLE-on (short), restart (5 s), factory reset (10 s).
    ESP_ERROR_CHECK(sk_button_init(&(sk_button_cfg_t){
        .gpio_num        = SK_BUTTON_GPIO,
        .active_low      = SK_BUTTON_ACTIVE_LOW,
        .pullup_internal = true,
    }, NULL, NULL));

    // Wireless stack (always on — every SmartKraft device is BLE+WiFi).
    ESP_ERROR_CHECK(sk_wifi_init());
    ESP_ERROR_CHECK(sk_mdns_init(SK_TCP_PORT, SK_FW_VERSION));
    ESP_ERROR_CHECK(sk_transport_ble_init(NULL));
    ESP_ERROR_CHECK(sk_transport_tcp_init(&(sk_transport_tcp_cfg_t){
        .port = SK_TCP_PORT,
    }));

#if SK_OTA_ENABLE
    ESP_ERROR_CHECK(sk_ota_init(&(sk_ota_cfg_t){
        .fw_version   = SK_FW_VERSION,
        .manifest_url = SK_OTA_MANIFEST_URL[0] ? SK_OTA_MANIFEST_URL : NULL,
    }));
#endif

#if SK_API_ENABLE
    ESP_ERROR_CHECK(sk_api_init());
#endif

    ESP_LOGI(TAG, "Faz 0 starter up — id=%s", sk_identity_get());

    // ------------------------------------------------------------------
    // Device-specific code lives below this line. The Faz 0 init block
    // above stays untouched per project_faz0_starter.md.
    //
    // Examples:
    //
    //   // Telegram bot endpoint — alert when sensor trips
    //   sk_api_endpoint_add(&(sk_api_endpoint_cfg_t){
    //       .name  = "alert",
    //       .type  = SK_API_TELEGRAM,
    //       .url   = "<chat_id>",
    //       .token = "<bot_token>",
    //   });
    //   sk_api_send("alert", "Sensor tripped");
    //
    //   // Custom REST API with X-API-Key header
    //   sk_api_endpoint_add(&(sk_api_endpoint_cfg_t){
    //       .name        = "log_to_cloud",
    //       .type        = SK_API_GENERIC,
    //       .url         = "https://api.example.com/v1/logs",
    //       .token       = "<api_key>",
    //       .auth        = SK_API_AUTH_CUSTOM_HEADER,
    //       .header_name = "X-API-Key",
    //   });
    //
    //   // Listen for factory-reset to clean device-specific NVS
    //   int sub;
    //   sk_event_bus_subscribe("device.factory-reset.requested",
    //                          on_my_factory_reset, NULL, &sub);
    //
    //   // Listen for OTA state changes (e.g. update LED, send Telegram alert)
    //   sk_event_bus_subscribe("ota.fw.state",
    //                          on_my_ota_state, NULL, &sub);
    //
    //   // Register cihaz-özgü CLI commands (timer, sensor, relay...) via
    //   // sk_cli_register(&cmd_def). Inbound HTTP (uncommon, ~1 device in
    //   // practice) wires `esp_http_server` directly — sk_api covers only
    //   // outbound calls.
    //
    //   // Spawn application task(s)
    // ------------------------------------------------------------------
}
