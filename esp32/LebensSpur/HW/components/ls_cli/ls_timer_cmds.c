#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "sk_cli.h"
#include "sk_errors.h"
#include "timer_manager.h"

// Helper: write a status object both as JSON (machine) and as the inline-help
// block specified in Tablo B / Principle #11 (human).
static void emit_status(sk_cli_ctx_t *ctx, const timer_state_t *s)
{
    char buf[256];
    snprintf(buf, sizeof(buf),
             "{\"state\":\"%s\",\"remaining\":%ld,\"total\":%ld,"
             "\"alarms_total\":%u,\"vacation\":{\"enabled\":%s,"
             "\"remaining\":%ld,\"total\":%ld}}",
             s->enabled ? "running" : "stopped",
             (long)s->remaining_seconds, (long)s->total_seconds,
             (unsigned)s->alarm_count,
             s->vacation_enabled ? "true" : "false",
             (long)s->vacation_remaining, (long)s->vacation_total);

    if (sk_cli_is_machine_mode(ctx)) {
        sk_cli_ok(ctx, buf);
        return;
    }

    sk_cli_writef(ctx, "Current timer:\n");
    sk_cli_writef(ctx, "  state         : %s\n", s->enabled ? "running" : "stopped");
    sk_cli_writef(ctx, "  remaining     : %ld sec\n", (long)s->remaining_seconds);
    sk_cli_writef(ctx, "  total         : %ld sec\n", (long)s->total_seconds);
    sk_cli_writef(ctx, "  alarms        : %u early warnings\n", (unsigned)s->alarm_count);
    sk_cli_writef(ctx, "  vacation      : %s\n", s->vacation_enabled ? "on" : "off");
    sk_cli_writef(ctx, "\nTo change: timer set <value> <unit>\n");
    sk_cli_writef(ctx, "  <value>       : 1-60\n");
    sk_cli_writef(ctx, "  <unit>        : days | hours | minutes\n\n");
    sk_cli_writef(ctx, "Example: timer set 7 days\n");
    sk_cli_writef(ctx, "Tip: 'timer restart' resets countdown; 'timer vacation <days>' pauses.\n");
    sk_cli_ok(ctx, NULL);
}

static sk_err_t cmd_status(sk_cli_ctx_t *ctx)
{
    timer_state_t s = timer_manager_get_state();
    emit_status(ctx, &s);
    return SK_OK;
}

static sk_err_t cmd_set(sk_cli_ctx_t *ctx)
{
    const char *v_str = NULL;
    const char *unit  = NULL;
    if (sk_cli_is_machine_mode(ctx)) {
        v_str = sk_cli_arg_named(ctx, "value");
        unit  = sk_cli_arg_named(ctx, "unit");
    } else {
        v_str = sk_cli_arg(ctx, 0);
        unit  = sk_cli_arg(ctx, 1);
    }
    if (!v_str || !unit) return SK_ERR_MISSING_ARG;
    int value = atoi(v_str);
    if (value <= 0) return SK_ERR_INVALID_VALUE;
    esp_err_t err = timer_manager_set(unit, value);
    if (err == ESP_ERR_INVALID_ARG) return SK_ERR_INVALID_UNIT;
    if (err != ESP_OK)              return SK_ERR_NVS_WRITE;
    timer_state_t s = timer_manager_get_state();
    emit_status(ctx, &s);
    return SK_OK;
}

static sk_err_t cmd_restart(sk_cli_ctx_t *ctx)
{
    timer_manager_restart();
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

static sk_err_t cmd_cancel(sk_cli_ctx_t *ctx)
{
    timer_manager_cancel();
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

static sk_err_t cmd_vacation_set(sk_cli_ctx_t *ctx)
{
    const char *d = sk_cli_is_machine_mode(ctx)
        ? sk_cli_arg_named(ctx, "days")
        : sk_cli_arg(ctx, 0);
    if (!d) return SK_ERR_MISSING_ARG;
    int days = atoi(d);
    if (days <= 0) return SK_ERR_INVALID_VALUE;
    timer_manager_set_vacation(days);
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

static sk_err_t cmd_vacation_cancel(sk_cli_ctx_t *ctx)
{
    timer_manager_cancel_vacation();
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

static sk_err_t cmd_alarm_count(sk_cli_ctx_t *ctx)
{
    const char *n = sk_cli_is_machine_mode(ctx)
        ? sk_cli_arg_named(ctx, "count")
        : sk_cli_arg(ctx, 0);
    if (!n) return SK_ERR_MISSING_ARG;
    int count = atoi(n);
    if (count < 0 || count > 10) return SK_ERR_INVALID_VALUE;
    timer_manager_set_alarm_count(count);
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

static const sk_cli_command_t s_cmds[] = {
    { .name="timer.status",          .summary="Countdown state + inline-help",   .usage="timer status",          .handler=cmd_status },
    { .name="timer.set",             .summary="Set countdown duration",          .usage="timer set <value> <unit>", .handler=cmd_set },
    { .name="timer.restart",         .summary="Reset countdown to full duration",.usage="timer restart",         .handler=cmd_restart },
    { .name="timer.cancel",          .summary="Stop countdown",                  .usage="timer cancel",          .handler=cmd_cancel },
    { .name="timer.vacation.set",    .summary="Pause countdown for N days",      .usage="timer vacation <days>", .handler=cmd_vacation_set },
    { .name="timer.vacation.cancel", .summary="Cancel vacation, resume main",    .usage="timer vacation cancel", .handler=cmd_vacation_cancel },
    { .name="timer.alarm-count.set", .summary="Set number of early warnings",    .usage="timer alarm-count <n>", .handler=cmd_alarm_count },
};

void ls_timer_cmds_register(void)
{
    for (size_t i = 0; i < sizeof(s_cmds)/sizeof(s_cmds[0]); i++) {
        sk_cli_register(&s_cmds[i]);
    }
}
