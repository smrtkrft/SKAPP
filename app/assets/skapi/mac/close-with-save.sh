#!/bin/bash
# close-with-save.sh
# SKAPI MAC Programs
# Hedef app'i activate edip Cmd+S gönderir (kayıt diyaloğu çalışır),
# wait saniye bekler, sonra Cmd+W ile pencereyi graceful kapatır.
# Win'deki SendKeys + WM_CLOSE paritesi.
#
# Tier 2: AppleScript GUI scripting Accessibility izni gerektirir.
# Bazı uygulamalar Cmd+S'yi farklı yorumlar (Slack: search, çoğu
# browser: web sayfasını kaydet) — whitelist yaklaşımı önerilir.

set -u

process_name=""
wait_sec=1

while [ $# -gt 0 ]; do
  case "$1" in
    --processName) process_name="$2"; shift 2 ;;
    --wait)        wait_sec="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$process_name" ]; then
  echo "processName is required." >&2
  exit 2
fi

if ! pgrep -ix "$process_name" >/dev/null 2>&1; then
  echo "No running instance of '$process_name'."
  exit 0
fi

escape_as() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}
esc_name=$(escape_as "$process_name")

osascript <<EOF 2>/dev/null
tell application "$esc_name" to activate
delay 0.2
tell application "System Events"
  keystroke "s" using {command down}
end tell
delay $wait_sec
tell application "System Events"
  keystroke "w" using {command down}
end tell
EOF

echo "Save+close: $process_name"
exit 0
