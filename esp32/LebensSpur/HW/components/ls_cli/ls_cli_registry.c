#include "ls_cli_registry.h"

void ls_timer_cmds_register(void);
void ls_relay_cmds_register(void);
void ls_mail_cmds_register(void);
void ls_actions_cmds_register(void);
void ls_webhook_cmds_register(void);
void ls_device_cmds_register(void);

void ls_cli_register_all(void)
{
    ls_timer_cmds_register();
    ls_relay_cmds_register();
    ls_mail_cmds_register();
    ls_actions_cmds_register();
    ls_webhook_cmds_register();
    ls_device_cmds_register();
}
