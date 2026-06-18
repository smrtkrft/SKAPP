idf_component_register(
    SRCS
        "ls_cli_registry.c"
        "ls_timer_cmds.c"
        "ls_relay_cmds.c"
        "ls_mail_cmds.c"
        "ls_actions_cmds.c"
        "ls_webhook_cmds.c"
        "ls_device_cmds.c"
    INCLUDE_DIRS "include"
    REQUIRES sk_core sk_webhook
    PRIV_REQUIRES
        timer_manager output smtp_client telegram_client
        ext_flash device_log nvs_flash
)
