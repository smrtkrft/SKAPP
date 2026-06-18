#!/bin/bash
# close-window.sh
# SKAPI MAC Window & App
# Belirli bir uygulamanın ön plandaki penceresini graceful kapatır
# (uygulama "kayıtsız değişiklik" dialog'u gösterebilir, Win'deki X
# tıklamasıyla aynı semantik). processName boş ise foreground app'in
# penceresine Cmd+W gönderilir.
#
# Cmd+W TAB'lı uygulamalarda yalnızca aktif sekme/penceresi kapatır
# (Win'de WM_CLOSE de aynı davranış). Tüm pencereler için bkz:
# close-all-instances ya da kill-app.

set -u

process_name=""

while [ $# -gt 0 ]; do
  case "$1" in
    --processName) process_name="$2"; shift 2 ;;
    *) shift ;;
  esac
done

escape_as() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

if [ -z "$process_name" ]; then
  # Foreground window close.
  osascript -e 'tell application "System Events" to keystroke "w" using {command down}' 2>/dev/null
  echo "Sent close to foreground window"
  exit 0
fi

esc_name=$(escape_as "$process_name")

osascript <<EOF 2>/dev/null
tell application "System Events"
  if exists (processes whose name is "$esc_name") then
    tell application "$esc_name" to activate
    delay 0.15
    keystroke "w" using {command down}
  else
    error "no process" number 3
  end if
end tell
EOF

ec=$?
if [ $ec -ne 0 ]; then
  echo "No window for process '$process_name'." >&2
  exit 3
fi

echo "Sent close: $process_name"
exit 0
