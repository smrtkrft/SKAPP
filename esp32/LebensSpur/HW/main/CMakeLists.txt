idf_component_register(
    SRCS "main.c"
    INCLUDE_DIRS "."
    PRIV_REQUIRES
        # SKAPP Library books (from ../../skapp-library via EXTRA_COMPONENT_DIRS)
        sk_core sk_storage sk_transport_usb sk_auth sk_io
        sk_network sk_transport_tcp sk_ota sk_webhook sk_file_xfer sk_transport_ble
        ls_cli
        # Legacy LS business components (still live under components/)
        wifi_manager web_server ext_flash flash_sync timer_manager
        smtp_client telegram_client device_log output
        nvs_flash spi_flash esp_partition gui_ota fw_ota app_update
)
