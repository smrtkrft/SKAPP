#include <stdio.h>
#include <string.h>

#include "sk_cli.h"
#include "sk_errors.h"
#include "sk_auth.h"
#include "sk_identity.h"

#include "esp_system.h"
#include "esp_ota_ops.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

static sk_err_t cmd_restart(sk_cli_ctx_t *ctx)
{
    const char *tok = sk_cli_confirm_token(ctx);
    if (!tok) return SK_ERR_CONFIRM_TOKEN_REQUIRED;
    if (sk_auth_confirm_consume(tok) != ESP_OK) return SK_ERR_CONFIRM_TOKEN_INVALID;
    sk_cli_ok(ctx, "{\"restarting\":true}");
    vTaskDelay(pdMS_TO_TICKS(200));
    esp_restart();
    return SK_OK;
}

static sk_err_t cmd_factory_reset(sk_cli_ctx_t *ctx)
{
    const char *tok = sk_cli_confirm_token(ctx);
    if (!tok) return SK_ERR_CONFIRM_TOKEN_REQUIRED;
    if (sk_auth_confirm_consume(tok) != ESP_OK) return SK_ERR_CONFIRM_TOKEN_INVALID;

    sk_auth_clear_all();
    extern esp_err_t nvs_flash_erase(void);
    nvs_flash_erase();
    sk_cli_ok(ctx, "{\"reset\":true}");
    vTaskDelay(pdMS_TO_TICKS(500));
    esp_restart();
    return SK_OK;
}

static sk_err_t cmd_info(sk_cli_ctx_t *ctx)
{
    char buf[192];
    const esp_app_desc_t *d = esp_app_get_description();
    snprintf(buf, sizeof(buf),
             "{\"id\":\"%s\",\"fw_version\":\"%s\",\"project\":\"%s\"}",
             sk_identity_get(),
             d ? d->version : "",
             d ? d->project_name : "");
    sk_cli_ok(ctx, buf);
    return SK_OK;
}

static const sk_cli_command_t s_cmds[] = {
    { .name="device.info",          .summary="Device ID, fw version",     .usage="device info",          .handler=cmd_info },
    { .name="device.restart",       .summary="Reboot the device",         .usage="device restart",       .critical=true, .handler=cmd_restart },
    { .name="device.factory-reset", .summary="Erase all user data",       .usage="device factory-reset", .critical=true, .handler=cmd_factory_reset },
};

void ls_device_cmds_register(void)
{
    for (size_t i = 0; i < sizeof(s_cmds)/sizeof(s_cmds[0]); i++) {
        sk_cli_register(&s_cmds[i]);
    }
}
