#include <stdio.h>
#include <string.h>

#include "sk_cli.h"
#include "sk_errors.h"
#include "sk_auth.h"
#include "sk_webhook.h"

#define NS "ls_reset"

static sk_err_t cmd_config_get(sk_cli_ctx_t *ctx)
{
    sk_webhook_config_view_t v;
    sk_webhook_get_view(NS, &v);
    char buf[96];
    snprintf(buf, sizeof(buf),
             "{\"enabled\":%s,\"has_key\":%s,\"masked_key\":\"%s\"}",
             v.enabled ? "true" : "false",
             v.has_key ? "true" : "false",
             v.masked_key);
    sk_cli_ok(ctx, buf);
    return SK_OK;
}

static sk_err_t cmd_config_set(sk_cli_ctx_t *ctx)
{
    const char *en = sk_cli_arg_named(ctx, "enabled");
    if (!en) return SK_ERR_MISSING_ARG;
    bool val = en[0] == '1' || strcasecmp(en, "true") == 0;
    if (sk_webhook_set_enabled(NS, val) != ESP_OK) return SK_ERR_NVS_WRITE;
    return cmd_config_get(ctx);
}

static sk_err_t cmd_key_generate(sk_cli_ctx_t *ctx)
{
    char key[24];
    sk_webhook_key_generate(NS, key);
    char buf[64];
    snprintf(buf, sizeof(buf), "{\"api_key\":\"%s\",\"enabled\":true}", key);
    sk_cli_ok(ctx, buf);
    return SK_OK;
}

static sk_err_t cmd_key_clear(sk_cli_ctx_t *ctx)
{
    const char *tok = sk_cli_confirm_token(ctx);
    if (!tok) return SK_ERR_CONFIRM_TOKEN_REQUIRED;
    if (sk_auth_confirm_consume(tok) != ESP_OK) return SK_ERR_CONFIRM_TOKEN_INVALID;
    sk_webhook_key_clear(NS);
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

static const sk_cli_command_t s_cmds[] = {
    { .name="webhook.reset.config.get",  .summary="Webhook (virtual button) state", .usage="webhook reset config",       .handler=cmd_config_get },
    { .name="webhook.reset.config.set",  .summary="Enable/disable the webhook",     .usage="webhook reset config --enabled 0/1", .handler=cmd_config_set },
    { .name="webhook.reset.key.generate",.summary="Generate a fresh API key",       .usage="webhook reset generate-key", .handler=cmd_key_generate },
    { .name="webhook.reset.key.clear",   .summary="Delete the API key",             .usage="webhook reset clear-key",    .critical=true, .handler=cmd_key_clear },
};

void ls_webhook_cmds_register(void)
{
    for (size_t i = 0; i < sizeof(s_cmds)/sizeof(s_cmds[0]); i++) {
        sk_cli_register(&s_cmds[i]);
    }
}
