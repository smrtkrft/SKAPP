#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <dirent.h>

#include "sk_cli.h"
#include "sk_errors.h"
#include "smtp_client.h"
#include "telegram_client.h"
#include "nvs.h"

// -- smtp.* ----------------------------------------------------------------

static sk_err_t cmd_smtp_get(sk_cli_ctx_t *ctx)
{
    smtp_config_t cfg = {0};
    bool has = smtp_client_has_config();
    if (has) smtp_client_get_config(&cfg);
    char buf[256];
    snprintf(buf, sizeof(buf),
             "{\"configured\":%s,\"server\":\"%s\",\"port\":%u,\"user\":\"%s\","
             "\"has_api_key\":%s}",
             has ? "true" : "false",
             cfg.server, (unsigned)cfg.port, cfg.user,
             cfg.api_key[0] ? "true" : "false");
    sk_cli_ok(ctx, buf);
    return SK_OK;
}

static sk_err_t cmd_smtp_save(sk_cli_ctx_t *ctx)
{
    const char *srv  = sk_cli_arg_named(ctx, "server");
    const char *port = sk_cli_arg_named(ctx, "port");
    const char *user = sk_cli_arg_named(ctx, "user");
    const char *key  = sk_cli_arg_named(ctx, "key");
    if (!srv || !port || !user || !key) return SK_ERR_MISSING_ARG;
    smtp_config_t cfg = {0};
    strncpy(cfg.server,  srv,  sizeof(cfg.server)  - 1);
    strncpy(cfg.user,    user, sizeof(cfg.user)    - 1);
    strncpy(cfg.api_key, key,  sizeof(cfg.api_key) - 1);
    cfg.port = (uint16_t)atoi(port);
    if (smtp_client_save_config(&cfg) != ESP_OK) return SK_ERR_NVS_WRITE;
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

static void smtp_test_task(void *arg)
{
    (void)arg;
    esp_err_t err = smtp_client_send_test();
    // Progress + done events are already published by the legacy smtp_client
    // implementation as it is extended in phase D. For now emit a terminal
    // event here.
    (void)err;
    vTaskDelete(NULL);
}

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

static sk_err_t cmd_smtp_test(sk_cli_ctx_t *ctx)
{
    if (!smtp_client_has_config()) return SK_ERR_SMTP_NO_CONFIG;
    xTaskCreate(smtp_test_task, "smtp_test", 10240, NULL, 4, NULL);
    sk_cli_ok(ctx, "{\"started\":true}");
    return SK_OK;
}

// -- telegram.* ------------------------------------------------------------

static sk_err_t cmd_tg_get(sk_cli_ctx_t *ctx)
{
    telegram_config_t cfg = {0};
    bool has = telegram_client_has_config();
    if (has) telegram_client_get_config(&cfg);
    char buf[320];
    snprintf(buf, sizeof(buf),
             "{\"configured\":%s,\"chat_id\":\"%s\",\"message\":\"%s\","
             "\"has_token\":%s}",
             has ? "true" : "false",
             cfg.chat_id, cfg.message,
             cfg.token[0] ? "true" : "false");
    sk_cli_ok(ctx, buf);
    return SK_OK;
}

static sk_err_t cmd_tg_save(sk_cli_ctx_t *ctx)
{
    const char *token = sk_cli_arg_named(ctx, "token");
    const char *chat  = sk_cli_arg_named(ctx, "chat");
    const char *msg   = sk_cli_arg_named(ctx, "msg");
    if (!token || !chat) return SK_ERR_MISSING_ARG;
    telegram_config_t cfg = {0};
    strncpy(cfg.token,   token, sizeof(cfg.token)   - 1);
    strncpy(cfg.chat_id, chat,  sizeof(cfg.chat_id) - 1);
    if (msg) strncpy(cfg.message, msg, sizeof(cfg.message) - 1);
    if (telegram_client_save_config(&cfg) != ESP_OK) return SK_ERR_NVS_WRITE;
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

static void tg_test_task(void *arg)
{
    (void)arg;
    telegram_client_send("LebensSpur test message");
    vTaskDelete(NULL);
}

static sk_err_t cmd_tg_test(sk_cli_ctx_t *ctx)
{
    if (!telegram_client_has_config()) return SK_ERR_TELEGRAM_NO_CONFIG;
    xTaskCreate(tg_test_task, "tg_test", 8192, NULL, 4, NULL);
    sk_cli_ok(ctx, "{\"started\":true}");
    return SK_OK;
}

// -- mail.early.* ---------------------------------------------------------

static sk_err_t cmd_early_get(sk_cli_ctx_t *ctx)
{
    nvs_handle_t h;
    char email[64] = {0}, subject[64] = {0}, body[256] = {0};
    if (nvs_open("ls_ew_mail", NVS_READONLY, &h) == ESP_OK) {
        size_t sz;
        sz = sizeof(email);   nvs_get_str(h, "email",   email,   &sz);
        sz = sizeof(subject); nvs_get_str(h, "subject", subject, &sz);
        sz = sizeof(body);    nvs_get_str(h, "body",    body,    &sz);
        nvs_close(h);
    }
    char buf[480];
    snprintf(buf, sizeof(buf),
             "{\"email\":\"%s\",\"subject\":\"%s\",\"body\":\"%s\"}",
             email, subject, body);
    sk_cli_ok(ctx, buf);
    return SK_OK;
}

static sk_err_t cmd_early_save(sk_cli_ctx_t *ctx)
{
    const char *email   = sk_cli_arg_named(ctx, "email");
    const char *subject = sk_cli_arg_named(ctx, "subject");
    const char *body    = sk_cli_arg_named(ctx, "body");
    if (!email) return SK_ERR_MISSING_ARG;
    nvs_handle_t h;
    if (nvs_open("ls_ew_mail", NVS_READWRITE, &h) != ESP_OK) return SK_ERR_NVS_WRITE;
    nvs_set_str(h, "email",   email);
    if (subject) nvs_set_str(h, "subject", subject);
    if (body)    nvs_set_str(h, "body",    body);
    nvs_commit(h);
    nvs_close(h);
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

// -- mail.trigger.* (groups) ----------------------------------------------

static sk_err_t cmd_trigger_list(sk_cli_ctx_t *ctx)
{
    nvs_handle_t h;
    uint8_t count = 0;
    char out[1024];
    int off = snprintf(out, sizeof(out), "{\"groups\":[");
    if (nvs_open("ls_tg_mail", NVS_READONLY, &h) == ESP_OK) {
        nvs_get_u8(h, "count", &count);
        for (int i = 0; i < count && i < 10; i++) {
            char key[20], rcpt[256] = {0};
            snprintf(key, sizeof(key), "g%d_rcpt", i);
            size_t sz = sizeof(rcpt);
            nvs_get_str(h, key, rcpt, &sz);
            off += snprintf(out + off, sizeof(out) - off,
                            "%s{\"id\":%d,\"recipients\":\"%s\"}",
                            i ? "," : "", i, rcpt);
        }
        nvs_close(h);
    }
    snprintf(out + off, sizeof(out) - off, "],\"count\":%u}", (unsigned)count);
    sk_cli_ok(ctx, out);
    return SK_OK;
}

static sk_err_t cmd_trigger_save(sk_cli_ctx_t *ctx)
{
    const char *id_s = sk_cli_arg_named(ctx, "id");
    const char *subj = sk_cli_arg_named(ctx, "subject");
    const char *body = sk_cli_arg_named(ctx, "body");
    const char *rcpt = sk_cli_arg_named(ctx, "rcpt");
    if (!id_s || !rcpt) return SK_ERR_MISSING_ARG;
    int id = atoi(id_s);
    if (id < 0 || id > 9) return SK_ERR_INVALID_VALUE;
    nvs_handle_t h;
    if (nvs_open("ls_tg_mail", NVS_READWRITE, &h) != ESP_OK) return SK_ERR_NVS_WRITE;
    char key[20];
    if (subj) { snprintf(key, sizeof(key), "g%d_subj", id); nvs_set_str(h, key, subj); }
    if (body) { snprintf(key, sizeof(key), "g%d_body", id); nvs_set_str(h, key, body); }
    snprintf(key, sizeof(key), "g%d_rcpt", id); nvs_set_str(h, key, rcpt);
    uint8_t count = 0; nvs_get_u8(h, "count", &count);
    if (id + 1 > count) { count = id + 1; nvs_set_u8(h, "count", count); }
    nvs_commit(h);
    nvs_close(h);
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

static sk_err_t cmd_trigger_delete(sk_cli_ctx_t *ctx)
{
    const char *id_s = sk_cli_arg_named(ctx, "id");
    if (!id_s) return SK_ERR_MISSING_ARG;
    int id = atoi(id_s);
    if (id < 0 || id > 9) return SK_ERR_INVALID_VALUE;
    nvs_handle_t h;
    if (nvs_open("ls_tg_mail", NVS_READWRITE, &h) != ESP_OK) return SK_ERR_NVS_WRITE;
    char key[20];
    snprintf(key, sizeof(key), "g%d_subj", id); nvs_erase_key(h, key);
    snprintf(key, sizeof(key), "g%d_body", id); nvs_erase_key(h, key);
    snprintf(key, sizeof(key), "g%d_rcpt", id); nvs_erase_key(h, key);
    nvs_commit(h);
    nvs_close(h);
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

static sk_err_t cmd_trigger_files(sk_cli_ctx_t *ctx)
{
    const char *g_s = sk_cli_arg_named(ctx, "group");
    if (!g_s) return SK_ERR_MISSING_ARG;
    int g = atoi(g_s);
    if (g < 0 || g > 9) return SK_ERR_INVALID_VALUE;
    char dir[40]; snprintf(dir, sizeof(dir), "/ext/mail/g%d", g);
    DIR *d = opendir(dir);
    char out[512];
    int off = snprintf(out, sizeof(out), "{\"files\":[");
    bool first = true;
    if (d) {
        struct dirent *e;
        while ((e = readdir(d)) != NULL) {
            if (e->d_type != DT_REG) continue;
            char path[64]; snprintf(path, sizeof(path), "%s/%s", dir, e->d_name);
            struct stat st; long size = 0;
            if (stat(path, &st) == 0) size = (long)st.st_size;
            off += snprintf(out + off, sizeof(out) - off,
                            "%s{\"name\":\"%s\",\"size\":%ld}",
                            first ? "" : ",", e->d_name, size);
            first = false;
        }
        closedir(d);
    }
    snprintf(out + off, sizeof(out) - off, "]}");
    sk_cli_ok(ctx, out);
    return SK_OK;
}

static sk_err_t cmd_trigger_file_delete(sk_cli_ctx_t *ctx)
{
    const char *g_s = sk_cli_arg_named(ctx, "group");
    const char *n   = sk_cli_arg_named(ctx, "name");
    if (!g_s || !n) return SK_ERR_MISSING_ARG;
    int g = atoi(g_s);
    if (g < 0 || g > 9) return SK_ERR_INVALID_VALUE;
    char path[96]; snprintf(path, sizeof(path), "/ext/mail/g%d/%s", g, n);
    if (remove(path) != 0) return SK_ERR_FILE_NOT_FOUND;
    sk_cli_ok(ctx, NULL);
    return SK_OK;
}

static const sk_cli_command_t s_cmds[] = {
    { .name="smtp.get",       .summary="SMTP configuration",       .usage="smtp get",       .handler=cmd_smtp_get },
    { .name="smtp.save",      .summary="Save SMTP configuration",  .usage="smtp save --server S --port P --user U --key K", .handler=cmd_smtp_save },
    { .name="smtp.test",      .summary="Send a test SMTP email",   .usage="smtp test",      .handler=cmd_smtp_test },
    { .name="telegram.get",   .summary="Telegram configuration",   .usage="telegram get",   .handler=cmd_tg_get },
    { .name="telegram.save",  .summary="Save Telegram config",     .usage="telegram save --token T --chat C [--msg M]", .handler=cmd_tg_save },
    { .name="telegram.test",  .summary="Send a test Telegram msg", .usage="telegram test",  .handler=cmd_tg_test },
    { .name="mail.early.get", .summary="Early-warning email cfg",  .usage="mail early get", .handler=cmd_early_get },
    { .name="mail.early.save",.summary="Save early-warning email", .usage="mail early save --email E [--subject S --body B]", .handler=cmd_early_save },
    { .name="mail.trigger.get",        .summary="List trigger-mail groups",     .usage="mail trigger list",        .handler=cmd_trigger_list },
    { .name="mail.trigger.save",       .summary="Save a trigger-mail group",     .usage="mail trigger save --id N --rcpt R [--subject S --body B]", .handler=cmd_trigger_save },
    { .name="mail.trigger.delete",     .summary="Delete a trigger-mail group",   .usage="mail trigger delete --id N", .handler=cmd_trigger_delete },
    { .name="mail.trigger.file.list",  .summary="List attachments of a group",   .usage="mail trigger files --group N", .handler=cmd_trigger_files },
    { .name="mail.trigger.file.delete",.summary="Delete an attachment",          .usage="mail trigger file-delete --group N --name F", .handler=cmd_trigger_file_delete },
};

void ls_mail_cmds_register(void)
{
    for (size_t i = 0; i < sizeof(s_cmds)/sizeof(s_cmds[0]); i++) {
        sk_cli_register(&s_cmds[i]);
    }
}
