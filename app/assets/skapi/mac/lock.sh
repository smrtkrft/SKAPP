#!/bin/bash
# lock.sh
# SKAPI MAC Power Management
# Workstation'ı kilitleyip giriş ekranına döner. macOS 10.13+ standart
# kısayolu: Ctrl+Cmd+Q. AppleScript ile System Events üzerinden bu
# kısayolu basıyoruz. Accessibility izni gerektirir.
#
# Alternatif: `pmset displaysleepnow` ekranı uyutur ama auto-lock
# kullanıcının System Settings > Lock Screen ayarına bağlı (immediate
# olmayabilir). Kilit semantiği için keystroke tercih edildi.

set -u

osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}' 2>/dev/null

echo "OK"
exit 0
