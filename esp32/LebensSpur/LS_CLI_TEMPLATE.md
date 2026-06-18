# LS CLI Commands — Template

Bu dokümandaki kod blokları, implementasyon fazı onaylandığında `HW/components/ls_cli/` altında C dosyası olarak yazılacak şablondur. 66 komutun tam sözleşmesi için: [TABLO_B_CLI_KOMUTLARI.md](TABLO_B_CLI_KOMUTLARI.md).

Şu an LS HW build'i dokunulmadığı için bu dosyalar _henüz yazılmadı_; Faz B/C/D runtime'ı cihazda çalıştığında devreye girer.

---

## 1. Component iskeleti

**`HW/components/ls_cli/CMakeLists.txt`**
```cmake
idf_component_register(
    SRCS
        "ls_cli_registry.c"
        "ls_timer_cmds.c"
        "ls_relay_cmds.c"
        "ls_mail_cmds.c"
        "ls_actions_cmds.c"
        "ls_webhook_cmds.c"
    INCLUDE_DIRS "include"
    REQUIRES sk_core sk_webhook
    PRIV_REQUIRES timer_manager output smtp_client telegram_client nvs_flash
)
```

**`HW/components/ls_cli/include/ls_cli_registry.h`**
```c
#pragma once
void ls_cli_register_all(void);
```

**`HW/components/ls_cli/ls_cli_registry.c`**
```c
#include "ls_cli_registry.h"

void ls_timer_cmds_register(void);
void ls_relay_cmds_register(void);
void ls_mail_cmds_register(void);
void ls_actions_cmds_register(void);
void ls_webhook_cmds_register(void);

void ls_cli_register_all(void)
{
    ls_timer_cmds_register();
    ls_relay_cmds_register();
    ls_mail_cmds_register();
    ls_actions_cmds_register();
    ls_webhook_cmds_register();
}
```

---

## 2. Örnek: `ls_timer_cmds.c` (7 komut)

```c
#include "sk_cli.h"
#include "sk_errors.h"
#include "timer_manager.h"

#include <stdio.h>
#include <string.h>
#include "cJSON.h"

// -- timer.status ----------------------------------------------------------

static sk_err_t cmd_timer_status(sk_cli_ctx_t *ctx)
{
    timer_state_t s = timer_manager_get_state();
    char buf[256];
    snprintf(buf, sizeof(buf),
             "{\"state\":\"%s\",\"remaining\":%ld,\"total\":%ld,"
             "\"alarms_total\":%u,\"alarm_count_remaining\":%u,"
             "\"vacation\":{\"enabled\":%s,\"remaining\":%ld,\"total\":%ld}}",
             s.enabled ? "running" : "stopped",
             (long)s.remaining_seconds, (long)s.total_seconds,
             (unsigned)s.alarm_count, (unsigned)s.alarm_count,
             s.vacation_enabled ? "true" : "false",
             (long)s.vacation_remaining, (long)s.vacation_total);

    if (sk_cli_is_machine_mode(ctx)) {
        sk_cli_ok(ctx, buf);
    } else {
        // Inline-help format (Principle #11)
        sk_cli_writef(ctx, "Current timer:\n");
        sk_cli_writef(ctx, "  state         : %s\n", s.enabled ? "running" : "stopped");
        sk_cli_writef(ctx, "  remaining     : %ld sec\n", (long)s.remaining_seconds);
        sk_cli_writef(ctx, "  total         : %ld sec\n", (long)s.total_seconds);
        sk_cli_writef(ctx, "  alarms        : %u\n", (unsigned)s.alarm_count);
        sk_cli_writef(ctx, "  vacation      : %s\n", s.vacation_enabled ? "on" : "off");
        sk_cli_writef(ctx, "\nTo change: timer set <value> <unit>\n");
        sk_cli_writef(ctx, "  <value>       : 1-60\n");
        sk_cli_writef(ctx, "  <unit>        : days | hours | minutes\n\n");
        sk_cli_writef(ctx, "Example: timer set 7 days\n");
        sk_cli_writef(ctx, "Tip: 'timer restart' resets countdown; 'timer vacation <days>' pauses.\n");
        sk_cli_ok(ctx, NULL);
    }
    return SK_OK;
}

// -- timer.set -------------------------------------------------------------

static sk_err_t cmd_timer_set(sk_cli_ctx_t *ctx)
{
    int value = 0;
    const char *unit = NULL;

    if (sk_cli_is_machine_mode(ctx)) {
        // args = {"value":N, "unit":"days|hours|minutes"}
        const char *v = sk_cli_arg_named(ctx, "value");
        const char *u = sk_cli_arg_named(ctx, "unit");
        if (v) value = atoi(v);
        unit = u;
    } else {
        // `timer set 7 days`
        const char *a0 = sk_cli_arg(ctx, 0);
        const char *a1 = sk_cli_arg(ctx, 1);
        if (a0) value = atoi(a0);
        unit = a1;
    }
    if (!unit || value <= 0) return SK_ERR_MISSING_ARG;
    esp_err_t err = timer_manager_set(unit, value);
    if (err == ESP_ERR_INVALID_ARG) return SK_ERR_INVALID_UNIT;
    if (err != ESP_OK)              return SK_ERR_NVS_WRITE;
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

// -- timer.restart / cancel / vacation / alarm-count -----------------------

static sk_err_t cmd_timer_restart(sk_cli_ctx_t *ctx) { timer_manager_restart(); sk_cli_ok(ctx,NULL); return SK_OK; }
static sk_err_t cmd_timer_cancel (sk_cli_ctx_t *ctx) { timer_manager_cancel();  sk_cli_ok(ctx,NULL); return SK_OK; }

static sk_err_t cmd_timer_vacation(sk_cli_ctx_t *ctx)
{
    const char *d = sk_cli_is_machine_mode(ctx) ? sk_cli_arg_named(ctx, "days") : sk_cli_arg(ctx, 0);
    if (!d) return SK_ERR_MISSING_ARG;
    timer_manager_set_vacation(atoi(d));
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

static sk_err_t cmd_timer_vacation_cancel(sk_cli_ctx_t *ctx) { timer_manager_cancel_vacation(); sk_cli_ok(ctx,NULL); return SK_OK; }

static sk_err_t cmd_timer_alarm_count(sk_cli_ctx_t *ctx)
{
    const char *n = sk_cli_is_machine_mode(ctx) ? sk_cli_arg_named(ctx, "count") : sk_cli_arg(ctx, 0);
    if (!n) return SK_ERR_MISSING_ARG;
    timer_manager_set_alarm_count(atoi(n));
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

// -- register --------------------------------------------------------------

#define C(name, sum, us, han, crit) { .name = name, .summary = sum, .usage = us, .handler = han, .critical = crit }

static const sk_cli_command_t s_cmds[] = {
    C("timer.status",          "Countdown timer state and inline-help",   "timer status",                cmd_timer_status,           false),
    C("timer.set",             "Set countdown duration",                  "timer set <value> <unit>",    cmd_timer_set,              false),
    C("timer.restart",         "Reset countdown to full duration",        "timer restart",               cmd_timer_restart,          false),
    C("timer.cancel",          "Stop countdown",                          "timer cancel",                cmd_timer_cancel,           false),
    C("timer.vacation.set",    "Pause countdown for N days",              "timer vacation <days>",       cmd_timer_vacation,         false),
    C("timer.vacation.cancel", "Cancel vacation, resume main timer",      "timer vacation cancel",       cmd_timer_vacation_cancel,  false),
    C("timer.alarm-count.set", "Set number of early warnings (0-10)",     "timer alarm-count <n>",       cmd_timer_alarm_count,      false),
};

void ls_timer_cmds_register(void)
{
    for (size_t i = 0; i < sizeof(s_cmds)/sizeof(s_cmds[0]); i++) sk_cli_register(&s_cmds[i]);
}
```

---

## 3. `ls_relay_cmds.c` (5 komut)

Aynı şablonla `output.h` fonksiyonlarını kullanarak yazılır:

```c
static sk_err_t cmd_relay_status(sk_cli_ctx_t *ctx) { ... }
static sk_err_t cmd_relay_set   (sk_cli_ctx_t *ctx) { ... }
static sk_err_t cmd_relay_test  (sk_cli_ctx_t *ctx) { ... }
static sk_err_t cmd_relay_trigger(sk_cli_ctx_t *ctx){ ... }
static sk_err_t cmd_relay_off   (sk_cli_ctx_t *ctx) { ... }
```

Inline-help formatı için Tablo B'deki relay status örneğine bakılır.

---

## 4. `ls_mail_cmds.c` (13 komut)

- smtp.* (get/save/test) — `smtp_client.h` kullanır
- telegram.* (get/save/test) — `telegram_client.h`
- mail.early.* (get/save) — `ls_ew_mail` NVS
- mail.trigger.* (get/save/delete/file.list/file.delete) — `ls_tg_mail` NVS + `/ext/mail/gN/`

Dosya upload/delete kısmı `sk_file_xfer` API'sini çağırır.

---

## 5. `ls_actions_cmds.c` (2 komut)

```c
static sk_err_t cmd_actions_get(sk_cli_ctx_t *ctx) { /* read ls_actions NVS, emit 4 booleans */ }
static sk_err_t cmd_actions_save(sk_cli_ctx_t *ctx){ /* parse and persist */ }
```

---

## 6. `ls_webhook_cmds.c` (4 komut)

```c
#include "sk_webhook.h"

static sk_err_t cmd_reset_config_get(sk_cli_ctx_t *ctx)
{
    sk_webhook_config_view_t v;
    sk_webhook_get_view("ls_reset", &v);
    char buf[96];
    snprintf(buf, sizeof(buf),
             "{\"enabled\":%s,\"has_key\":%s,\"masked_key\":\"%s\"}",
             v.enabled ? "true" : "false",
             v.has_key ? "true" : "false", v.masked_key);
    sk_cli_ok(ctx, buf);
    return SK_OK;
}

static sk_err_t cmd_reset_key_generate(sk_cli_ctx_t *ctx)
{
    char key[24];
    sk_webhook_key_generate("ls_reset", key);
    char buf[48]; snprintf(buf, sizeof(buf), "{\"api_key\":\"%s\"}", key);
    sk_cli_ok(ctx, buf);
    return SK_OK;
}

static sk_err_t cmd_reset_config_set(sk_cli_ctx_t *ctx)
{
    const char *en = sk_cli_arg_named(ctx, "enabled");
    sk_webhook_set_enabled("ls_reset", en && (en[0]=='1' || strcmp(en,"true")==0));
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

static sk_err_t cmd_reset_key_clear(sk_cli_ctx_t *ctx)
{
    const char *tok = sk_cli_confirm_token(ctx);
    if (!tok) return SK_ERR_CONFIRM_TOKEN_REQUIRED;
    if (sk_auth_confirm_consume(tok) != ESP_OK) return SK_ERR_CONFIRM_TOKEN_INVALID;
    sk_webhook_key_clear("ls_reset");
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}
```

Ve external HTTP endpoint kaydı (app_main içinde):

```c
static esp_err_t webhook_reset_handler(httpd_req_t *req, void *user)
{
    (void)user;
    timer_manager_restart();
    httpd_resp_set_type(req, "application/json");
    httpd_resp_sendstr(req, "{\"ok\":true,\"timer\":\"restarted\"}");
    return ESP_OK;
}

// app_main() içinde:
sk_webhook_register("/api/reset", HTTP_GET, "ls_reset", webhook_reset_handler, NULL);
sk_webhook_start(80);
```

---

## 7. Implementasyon sırası önerisi

Bu dosyalar yazılırken önerilen test akışı:

1. `ls_cli_registry.c` + iskelet boş register fonksiyonları (`ls_*_cmds_register`)
2. `ls_timer_cmds.c` — USB CLI'da `timer status` / `timer set` test et
3. `ls_relay_cmds.c` — `relay set 1 5 1` ile röle test et
4. `ls_actions_cmds.c` — basit toggle flags
5. `ls_mail_cmds.c` — smtp config + test mail
6. `ls_webhook_cmds.c` — son, sk_webhook'la entegrasyon

Her adımda mevcut `components/<x>/` içindeki gerçek implementasyon zaten var, sadece CLI wrapper yazılıyor. Toplam ~600 satır tahmini.
