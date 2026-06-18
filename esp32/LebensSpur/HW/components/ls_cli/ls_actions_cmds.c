#include <stdio.h>
#include <string.h>

#include "sk_cli.h"
#include "sk_errors.h"
#include "nvs.h"

#define NVS_NS "ls_actions"

static sk_err_t cmd_get(sk_cli_ctx_t *ctx)
{
    nvs_handle_t h;
    uint8_t early_mail = 0, early_tg = 0, trig_mail = 0, trig_relay = 1;
    if (nvs_open(NVS_NS, NVS_READONLY, &h) == ESP_OK) {
        nvs_get_u8(h, "early_mail", &early_mail);
        nvs_get_u8(h, "early_tg",   &early_tg);
        nvs_get_u8(h, "trig_mail",  &trig_mail);
        nvs_get_u8(h, "trig_relay", &trig_relay);
        nvs_close(h);
    }
    char buf[160];
    snprintf(buf, sizeof(buf),
             "{\"early_mail\":%s,\"early_tg\":%s,\"trig_mail\":%s,\"trig_relay\":%s}",
             early_mail ? "true" : "false",
             early_tg   ? "true" : "false",
             trig_mail  ? "true" : "false",
             trig_relay ? "true" : "false");
    sk_cli_ok(ctx, buf);
    return SK_OK;
}

static bool parse_bool(const char *s)
{
    if (!s) return false;
    return s[0] == '1' || strcasecmp(s, "true") == 0 || strcasecmp(s, "yes") == 0;
}

static sk_err_t cmd_save(sk_cli_ctx_t *ctx)
{
    const char *em = sk_cli_arg_named(ctx, "early_mail");
    const char *et = sk_cli_arg_named(ctx, "early_tg");
    const char *tm = sk_cli_arg_named(ctx, "trig_mail");
    const char *tr = sk_cli_arg_named(ctx, "trig_relay");
    nvs_handle_t h;
    if (nvs_open(NVS_NS, NVS_READWRITE, &h) != ESP_OK) return SK_ERR_NVS_WRITE;
    if (em) nvs_set_u8(h, "early_mail", parse_bool(em) ? 1 : 0);
    if (et) nvs_set_u8(h, "early_tg",   parse_bool(et) ? 1 : 0);
    if (tm) nvs_set_u8(h, "trig_mail",  parse_bool(tm) ? 1 : 0);
    if (tr) nvs_set_u8(h, "trig_relay", parse_bool(tr) ? 1 : 0);
    nvs_commit(h);
    nvs_close(h);
    return cmd_get(ctx);
}

static const sk_cli_command_t s_cmds[] = {
    { .name="actions.get",  .summary="Trigger action flags",    .usage="actions get", .handler=cmd_get },
    { .name="actions.save", .summary="Set trigger action flags",.usage="actions save --early_mail 0/1 --early_tg 0/1 --trig_mail 0/1 --trig_relay 0/1", .handler=cmd_save },
};

void ls_actions_cmds_register(void)
{
    for (size_t i = 0; i < sizeof(s_cmds)/sizeof(s_cmds[0]); i++) {
        sk_cli_register(&s_cmds[i]);
    }
}
