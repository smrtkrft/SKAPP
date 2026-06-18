/**
 * LebensSpur main — SKAPP Library integrated.
 *
 * Legacy business logic (timer, SMTP, Telegram, ext_flash, output) is kept
 * from the pre-refactor firmware. Web server / GUI-OTA are disabled in favor
 * of the skapp-library CLI transports (USB, BLE, TCP) and the minimal
 * webhook server that still exposes the virtual-button `/api/reset?key=xxx`.
 *
 * All legacy callbacks now publish through sk_event_bus so every CLI
 * transport (and the APP) receives the same stream.
 */

#include <stdio.h>
#include <string.h>
#include <dirent.h>

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"
#include "esp_mac.h"
#include "esp_ota_ops.h"
#include "esp_system.h"
#include "nvs_flash.h"

#include "sk_core.h"
#include "sk_log.h"
#include "sk_auth.h"
#include "sk_button.h"
#include "sk_transport_usb.h"
#include "sk_transport_ble.h"
#include "sk_transport_tcp.h"
#include "sk_wifi.h"
#include "sk_mdns.h"
#include "sk_ota.h"
#include "sk_webhook.h"
#include "sk_file_xfer.h"

#include "ls_cli_registry.h"
#include "timer_manager.h"
#include "smtp_client.h"
#include "telegram_client.h"
#include "output.h"
#include "ext_flash.h"
#include "device_log.h"
#include "esp_http_server.h"

#define FW_VERSION       "1.0.0"
#define LS_TYPE_PREFIX   "LS"

// LS-specific log types (offset from sk_log user range).
#define LS_LOG_TIMER   (SK_LOG_TYPE_USER_BEGIN + 0)
#define LS_LOG_SMTP    (SK_LOG_TYPE_USER_BEGIN + 1)
#define LS_LOG_TG      (SK_LOG_TYPE_USER_BEGIN + 2)

static const char *TAG = "LS";

// --- Timer → event bus ----------------------------------------------------

static void on_timer_tick(void)
{
    timer_state_t s = timer_manager_get_state();
    sk_event_bus_publishf("timer.tick",
                          "{\"remaining\":%ld,\"state\":\"%s\"}",
                          (long)s.remaining_seconds,
                          s.enabled ? "running" : "stopped");
}

static void on_alarm_triggered(int alarm_index);
static void on_timer_expired(void);

// --- SMTP / Telegram (kept from legacy) -----------------------------------

static void alarm_mail_task(void *arg)
{
    int alarm_index = (int)(intptr_t)arg;
    nvs_handle_t nvs;
    uint8_t early_mail_active = 0;
    if (nvs_open("ls_actions", NVS_READONLY, &nvs) == ESP_OK) {
        nvs_get_u8(nvs, "early_mail", &early_mail_active);
        nvs_close(nvs);
    }
    if (!early_mail_active || !smtp_client_has_config()) {
        vTaskDelete(NULL);
        return;
    }

    char email[64] = {0}, subject[64] = {0}, body[256] = {0};
    if (nvs_open("ls_ew_mail", NVS_READONLY, &nvs) == ESP_OK) {
        size_t len;
        len = sizeof(email);   nvs_get_str(nvs, "email",   email,   &len);
        len = sizeof(subject); nvs_get_str(nvs, "subject", subject, &len);
        len = sizeof(body);    nvs_get_str(nvs, "body",    body,    &len);
        nvs_close(nvs);
    }

    if (strlen(email) == 0) { vTaskDelete(NULL); return; }

    esp_err_t err = smtp_client_send(email, subject, body);
    sk_event_bus_publishf("smtp.send.success",
                          "{\"target\":\"early\",\"alarm_index\":%d,\"ok\":%s}",
                          alarm_index, err == ESP_OK ? "true" : "false");
    if (err == ESP_OK) sk_log_add(LS_LOG_SMTP, "early mail sent (alarm #%d)", alarm_index);
    else               sk_log_add(SK_LOG_TYPE_ERROR, "early mail fail: %s", esp_err_to_name(err));
    vTaskDelete(NULL);
}

static void alarm_telegram_task(void *arg)
{
    int alarm_index = (int)(intptr_t)arg;
    nvs_handle_t nvs;
    uint8_t early_tg_active = 0;
    if (nvs_open("ls_actions", NVS_READONLY, &nvs) == ESP_OK) {
        nvs_get_u8(nvs, "early_tg", &early_tg_active);
        nvs_close(nvs);
    }
    if (!early_tg_active || !telegram_client_has_config()) {
        vTaskDelete(NULL);
        return;
    }

    telegram_config_t cfg;
    telegram_client_get_config(&cfg);
    const char *msg = (strlen(cfg.message) > 0)
        ? cfg.message
        : "LebensSpur: countdown nearing its end.";
    esp_err_t err = telegram_client_send(msg);
    sk_event_bus_publishf("telegram.send.success",
                          "{\"target\":\"early\",\"alarm_index\":%d,\"ok\":%s}",
                          alarm_index, err == ESP_OK ? "true" : "false");
    if (err == ESP_OK) sk_log_add(LS_LOG_TG, "early TG sent (alarm #%d)", alarm_index);
    vTaskDelete(NULL);
}

static void trigger_mail_task(void *arg)
{
    (void)arg;
    nvs_handle_t nvs;
    uint8_t trig_mail_active = 0;
    if (nvs_open("ls_actions", NVS_READONLY, &nvs) == ESP_OK) {
        nvs_get_u8(nvs, "trig_mail", &trig_mail_active);
        nvs_close(nvs);
    }
    if (!trig_mail_active || !smtp_client_has_config()) {
        vTaskDelete(NULL);
        return;
    }
    if (nvs_open("ls_tg_mail", NVS_READONLY, &nvs) != ESP_OK) {
        vTaskDelete(NULL);
        return;
    }

    uint8_t count = 0;
    nvs_get_u8(nvs, "count", &count);

    for (int i = 0; i < count && i < 10; i++) {
        char key[20], subj[64] = {0}, body[256] = {0}, rcpt[256] = {0};
        size_t len;

        snprintf(key, sizeof(key), "g%d_subj", i);
        len = sizeof(subj); nvs_get_str(nvs, key, subj, &len);
        snprintf(key, sizeof(key), "g%d_body", i);
        len = sizeof(body); nvs_get_str(nvs, key, body, &len);
        snprintf(key, sizeof(key), "g%d_rcpt", i);
        len = sizeof(rcpt); nvs_get_str(nvs, key, rcpt, &len);

        if (strlen(rcpt) == 0) continue;

        #define MAX_ATTACH 5
        char *attach_paths[MAX_ATTACH];
        int attach_count = 0;
        char mail_dir[40];
        snprintf(mail_dir, sizeof(mail_dir), "/ext/mail/g%d", i);

        DIR *dir = opendir(mail_dir);
        if (dir) {
            struct dirent *ent;
            while ((ent = readdir(dir)) != NULL && attach_count < MAX_ATTACH) {
                if (ent->d_type != DT_REG) continue;
                attach_paths[attach_count] = malloc(300);
                if (attach_paths[attach_count]) {
                    snprintf(attach_paths[attach_count], 300, "%s/%s", mail_dir, ent->d_name);
                    attach_count++;
                }
            }
            closedir(dir);
        }

        char rcpt_copy[256];
        strncpy(rcpt_copy, rcpt, sizeof(rcpt_copy) - 1);
        rcpt_copy[sizeof(rcpt_copy) - 1] = '\0';

        char *saveptr = NULL;
        char *token = strtok_r(rcpt_copy, ",", &saveptr);
        while (token) {
            while (*token == ' ') token++;
            if (strlen(token) > 0) {
                esp_err_t err;
                if (attach_count > 0) {
                    err = smtp_client_send_with_attachments(
                        token, subj, body,
                        (const char **)attach_paths, attach_count);
                } else {
                    err = smtp_client_send(token, subj, body);
                }
                sk_event_bus_publishf(
                    err == ESP_OK ? "smtp.send.success" : "smtp.send.fail",
                    "{\"target\":\"trigger\",\"group\":%d,\"rcpt\":\"%s\"}",
                    i, token);
            }
            token = strtok_r(NULL, ",", &saveptr);
        }

        for (int j = 0; j < attach_count; j++) free(attach_paths[j]);
    }

    nvs_close(nvs);
    vTaskDelete(NULL);
}

static void on_alarm_triggered(int alarm_index)
{
    sk_event_bus_publishf("timer.alarm.triggered", "{\"index\":%d}", alarm_index);
    xTaskCreate(alarm_mail_task,     "alarm_mail", 10240, (void *)(intptr_t)alarm_index, 5, NULL);
    xTaskCreate(alarm_telegram_task, "alarm_tg",    8192, (void *)(intptr_t)alarm_index, 5, NULL);
}

static void on_timer_expired(void)
{
    sk_event_bus_publish("timer.expired", "{\"reason\":\"main\"}");
    nvs_handle_t nvs;
    uint8_t trig_relay = 1;
    if (nvs_open("ls_actions", NVS_READONLY, &nvs) == ESP_OK) {
        nvs_get_u8(nvs, "trig_relay", &trig_relay);
        nvs_close(nvs);
    }
    if (trig_relay) {
        output_relay_trigger();
        sk_event_bus_publish("relay.state",
                             "{\"state\":\"on\",\"reason\":\"timer\"}");
    }
    xTaskCreate(trigger_mail_task, "trig_mail", 10240, NULL, 5, NULL);
}

// --- Button integration via sk_io ----------------------------------------

static void on_button_event(sk_button_event_t evt, uint32_t meta, void *user)
{
    (void)user; (void)meta;
    switch (evt) {
    case SK_BUTTON_EVT_SHORT_PRESS:
        if (output_relay_is_on()) output_relay_off();
        timer_manager_restart();
        sk_event_bus_publish("timer.restart", NULL);
        break;
    case SK_BUTTON_EVT_LONG_PRESS:
        // Open pairing mode so the APP can pair via BLE (Just Works ECDH).
        sk_auth_open_pairing_mode(60);
        break;
    case SK_BUTTON_EVT_MULTI_TAP:
        sk_log_add(SK_LOG_TYPE_RESTART, "factory reset (button 5x)");
        sk_auth_clear_all();
        nvs_flash_erase();
        ext_flash_format_user_data();
        vTaskDelay(pdMS_TO_TICKS(200));
        esp_restart();
        break;
    }
}

// --- Webhook: /api/reset?key=xxx → timer restart -------------------------

static esp_err_t webhook_reset_handler(httpd_req_t *req, void *user)
{
    (void)user;
    timer_manager_restart();
    sk_event_bus_publish("timer.restart", "{\"source\":\"webhook\"}");
    httpd_resp_set_type(req, "application/json");
    httpd_resp_sendstr(req, "{\"ok\":true,\"timer\":\"restarted\"}");
    return ESP_OK;
}

// --- app_main -------------------------------------------------------------

void app_main(void)
{
    ESP_LOGI(TAG, "=== LebensSpur booting (SKAPP Library) ===");

    esp_err_t err = nvs_flash_init();
    if (err == ESP_ERR_NVS_NO_FREE_PAGES || err == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        err = nvs_flash_init();
    }
    ESP_ERROR_CHECK(err);

    // 1. Core + storage + auth — mandatory foundation.
    ESP_ERROR_CHECK(sk_core_init(&(sk_core_cfg_t){
        .device_type_prefix = LS_TYPE_PREFIX,
        .fw_version         = FW_VERSION,
    }));
    ESP_ERROR_CHECK(sk_log_init(NULL));
    ESP_ERROR_CHECK(sk_auth_init());

    // 2. Physical I/O (button triggers pairing mode + factory reset).
    // Legacy `output` component still owns the relay + GPIO numbers.
    // We register a plain sk_button on the same GPIO as legacy (GPIO18,
    // active-low pull-up) so long-press opens pairing.
    ESP_ERROR_CHECK(sk_button_init(&(sk_button_cfg_t){
        .gpio_num            = 18,
        .active_low          = true,
        .pullup_internal     = true,
        .long_press_ms       = 3000,
        .multi_tap_window_ms = 800,
        .multi_tap_threshold = 5,
    }, on_button_event, NULL));

    // 3. Legacy LS business components.
    ext_flash_init();
    device_log_init();           // pre-existing logs remain available
    timer_manager_init();
    output_init();               // relay GPIO + (legacy) button
    // Disable output's own button handling so sk_button owns the GPIO.
    output_set_button_callback(NULL);
    output_set_factory_reset_callback(NULL);
    smtp_client_init();
    telegram_client_init();

    // Re-route timer callbacks through sk_event_bus (replacing web_server_send_*).
    timer_manager_set_expiry_callback(on_timer_expired);
    timer_manager_set_alarm_callback(on_alarm_triggered);
    timer_manager_set_tick_callback(on_timer_tick);

    // 4. LS-specific CLI commands (timer.*, relay.*, mail.*, ...).
    ls_cli_register_all();

    // 5. Transports.
    ESP_ERROR_CHECK(sk_transport_usb_init(NULL));
    ESP_ERROR_CHECK(sk_transport_ble_init(NULL));

    // 6. Network-dependent services: only start once STA is up (sk_transport_tcp
    //    subscribes to wifi.state internally; same pattern for webhook + mdns).
    ESP_ERROR_CHECK(sk_wifi_init());
    ESP_ERROR_CHECK(sk_mdns_init(8080, FW_VERSION));
    ESP_ERROR_CHECK(sk_transport_tcp_init(NULL));

    // 7. OTA + webhook.
    sk_ota_init(&(sk_ota_cfg_t){
        .manifest_url = NULL,  // runtime configurable via ota.fw.check <url>
        .fw_version   = FW_VERSION,
    });
    sk_webhook_register("/api/reset", HTTP_GET, "ls_reset",
                        webhook_reset_handler, NULL);
    sk_webhook_start(80);

    // 8. File transfer (no backend wired yet — upload handlers will supply one).
    sk_file_xfer_init(NULL);

    // Finalize OTA: mark this boot valid once every init returned.
    esp_ota_mark_app_valid_cancel_rollback();

    sk_log_add(SK_LOG_TYPE_SYSTEM, "LS ready fw=%s", FW_VERSION);
    ESP_LOGI(TAG, "=== LebensSpur ready ===");
}
