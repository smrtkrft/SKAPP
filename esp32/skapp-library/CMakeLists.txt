cmake_minimum_required(VERSION 3.16)

# Faz 0 starter project. sk_core is the all-in-one SmartKraft baseline
# (USB CLI + BLE + WiFi/mDNS + TCP + secure session + button/LED I/O).
# Optional library on top: sk_api (outbound HTTP). sk_ota merged into sk_core.
set(EXTRA_COMPONENT_DIRS
    "${CMAKE_CURRENT_LIST_DIR}/sk_core"
    "${CMAKE_CURRENT_LIST_DIR}/sk_api"
)

include($ENV{IDF_PATH}/tools/cmake/project.cmake)
project(skapp_starter)
