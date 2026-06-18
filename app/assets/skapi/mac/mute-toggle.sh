#!/bin/bash
# mute-toggle.sh
# SKAPI MAC Display & Audio
# macOS sistem master mute'u toggle eder. AppleScript ile `output muted`
# property'sini ters çeviriyoruz. Hardware mute key (F10) ile aynı
# semantik, ek yetki gerektirmez.

set -u

osascript -e 'set volume output muted (not (output muted of (get volume settings)))' 2>/dev/null

echo "OK"
exit 0
