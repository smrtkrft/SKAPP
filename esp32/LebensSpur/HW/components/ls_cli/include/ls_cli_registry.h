#pragma once

#ifdef __cplusplus
extern "C" {
#endif

// Register every LebensSpur-specific CLI command with sk_cli.
// Call once during app_main after sk_core_init() and before transports are
// started.
void ls_cli_register_all(void);

#ifdef __cplusplus
}
#endif
