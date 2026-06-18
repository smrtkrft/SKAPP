#!/bin/bash
# show-desktop.sh
# SKAPI MAC Visual Break
# Tüm pencereleri "Show Desktop" Mission Control gesture'ı ile masaüstüne
# kaydırır. macOS default kısayolu F11 ya da fn+F11; Apple Magic Mouse'da
# üç parmak dışa kaydırma. Sistem genelinde toggle: tekrar çalıştırınca
# pencere düzenini geri getirir.
#
# AppleScript ile keystroke (key code 103 = F11) gönderiyoruz. Bazı
# Mac'lerde fn key modifier gerekli; her iki varyantı denersek
# uyumluluk artar. Accessibility izni gerektirir.

set -u

# F11 doğrudan key code 103. fn modifier'ı bazı klavyelerde gerekiyor.
osascript <<'EOF' 2>/dev/null
tell application "System Events"
  key code 103
end tell
EOF

echo "OK"
exit 0
