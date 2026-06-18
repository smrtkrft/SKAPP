cmake_minimum_required(VERSION 3.16)

set(SDKCONFIG_DEFAULTS "${CMAKE_SOURCE_DIR}/sdkconfig.defaults")

# Firmware versiyonu (esp_app_desc_t icin - OTA versiyon kontrolunde kullanilir)
set(PROJECT_VER "0.0.69")

# Pull SKAPP Library components from the sibling folder.
set(EXTRA_COMPONENT_DIRS "${CMAKE_SOURCE_DIR}/../../skapp-library")

include($ENV{IDF_PATH}/tools/cmake/project.cmake)
project(lebensspur)
