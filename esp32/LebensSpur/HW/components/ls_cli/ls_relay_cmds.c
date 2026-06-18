#include <stdio.h>
#include <stdlib.h>

#include "sk_cli.h"
#include "sk_errors.h"
#include "output.h"

static void emit_status(sk_cli_ctx_t *ctx)
{
    uint16_t duration = 0;
    uint8_t  pulse = 0, delay = 0;
    output_get_relay_config(&duration, &pulse, &delay);
    bool on       = output_relay_is_on();
    bool inverted = output_get_inverted();

    char buf[192];
    snprintf(buf, sizeof(buf),
             "{\"state\":\"%s\",\"mode\":\"%s\",\"duration\":%u,"
             "\"pulse\":%s,\"delay\":%u,\"inverted\":%s}",
             on ? "on" : "off",
             inverted ? "NC" : "NO",
             (unsigned)duration,
             pulse ? "true" : "false",
             (unsigned)delay,
             inverted ? "true" : "false");

    if (sk_cli_is_machine_mode(ctx)) { sk_cli_ok(ctx, buf); return; }

    sk_cli_writef(ctx, "Current relay:\n");
    sk_cli_writef(ctx, "  state         : %s\n", on ? "ON" : "OFF");
    sk_cli_writef(ctx, "  mode          : %s  [1]\n", inverted ? "NC (normally closed)" : "NO (normally open)");
    sk_cli_writef(ctx, "  duration      : %u sec  [2]\n", (unsigned)duration);
    sk_cli_writef(ctx, "  pulse         : %s  [3]\n", pulse ? "enabled" : "solid");
    sk_cli_writef(ctx, "  delay         : %u sec  [4]\n", (unsigned)delay);
    sk_cli_writef(ctx, "\nTo change: relay set <mode> <duration> <pulse> [delay]\n");
    sk_cli_writef(ctx, "  [1] <mode>    : 0 = NC, 1 = NO\n");
    sk_cli_writef(ctx, "  [2] <duration>: 0-65535 sec (0 = sustained)\n");
    sk_cli_writef(ctx, "  [3] <pulse>   : 0 = solid, 1 = pulsed\n");
    sk_cli_writef(ctx, "  [4] <delay>   : 0-255 sec (optional)\n\n");
    sk_cli_writef(ctx, "Example: relay set 1 5 1 2\n");
    sk_cli_writef(ctx, "Tip: 'relay test' fires a short pulse for verification.\n");
    sk_cli_ok(ctx, NULL);
}

static sk_err_t cmd_status(sk_cli_ctx_t *ctx) { emit_status(ctx); return SK_OK; }

static sk_err_t cmd_set(sk_cli_ctx_t *ctx)
{
    const char *m = NULL, *d = NULL, *p = NULL, *de = NULL;
    if (sk_cli_is_machine_mode(ctx)) {
        m  = sk_cli_arg_named(ctx, "mode");
        d  = sk_cli_arg_named(ctx, "duration");
        p  = sk_cli_arg_named(ctx, "pulse");
        de = sk_cli_arg_named(ctx, "delay");
    } else {
        m  = sk_cli_arg(ctx, 0);
        d  = sk_cli_arg(ctx, 1);
        p  = sk_cli_arg(ctx, 2);
        de = sk_cli_arg(ctx, 3);
    }
    if (!m || !d || !p) return SK_ERR_MISSING_ARG;
    int mode = atoi(m), dur = atoi(d), pulse = atoi(p);
    int dly  = de ? atoi(de) : 0;
    if (mode < 0 || mode > 1 || dur < 0 || dur > 65535 ||
        pulse < 0 || pulse > 1 || dly < 0 || dly > 255) {
        return SK_ERR_INVALID_VALUE;
    }
    output_set_inverted(mode == 0);
    output_set_relay_config((uint16_t)dur, (uint8_t)pulse, (uint8_t)dly);
    output_save_config();
    emit_status(ctx);
    return SK_OK;
}

static sk_err_t cmd_test(sk_cli_ctx_t *ctx)    { output_relay_trigger(); sk_cli_ok(ctx, NULL); return SK_OK; }
static sk_err_t cmd_trigger(sk_cli_ctx_t *ctx) { output_relay_trigger(); sk_cli_ok(ctx, NULL); return SK_OK; }
static sk_err_t cmd_off(sk_cli_ctx_t *ctx)     { output_relay_off();     sk_cli_ok(ctx, NULL); return SK_OK; }

static const sk_cli_command_t s_cmds[] = {
    { .name="relay.status",  .summary="Relay state + inline-help", .usage="relay status", .handler=cmd_status },
    { .name="relay.set",     .summary="Configure relay",           .usage="relay set <mode> <duration> <pulse> [delay]", .handler=cmd_set },
    { .name="relay.test",    .summary="Fire a short test pulse",   .usage="relay test",    .handler=cmd_test },
    { .name="relay.trigger", .summary="Trigger relay manually",    .usage="relay trigger", .handler=cmd_trigger },
    { .name="relay.off",     .summary="Force relay off",           .usage="relay off",     .handler=cmd_off },
};

void ls_relay_cmds_register(void)
{
    for (size_t i = 0; i < sizeof(s_cmds)/sizeof(s_cmds[0]); i++) {
        sk_cli_register(&s_cmds[i]);
    }
}
