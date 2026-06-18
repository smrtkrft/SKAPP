#!/bin/bash
# kill-app.sh
# SKAPI MAC Window & App
# Bir uygulamayı zorla sonlandırır. İki aşama:
#   1) preKillSave=true ise activate + Cmd+S ile graceful save'a fırsat
#   2) `osascript 'tell app X to quit'` ile graceful kapatma (apps own
#      "unsaved changes" dialog'unu gösterebilir, bu istenmez kill için)
#   3) Timeout sonrası hâlâ çalışıyorsa `pkill -KILL -ix` ile zorla
#
# macOS process name regex'i (pgrep -ix) case-insensitive, exact match.
# "Google Chrome", "Firefox", "Safari" gibi multi-word app'ler için tam
# isim verilmeli.

set -u

process_name=""
timeout_sec=5
pre_kill_save=false

while [ $# -gt 0 ]; do
  case "$1" in
    --processName) process_name="$2"; shift 2 ;;
    --timeout)     timeout_sec="$2"; shift 2 ;;
    --preKillSave) pre_kill_save="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$process_name" ]; then
  echo "processName is required." >&2
  exit 2
fi

# Process çalışıyor mu?
if ! pgrep -ix "$process_name" >/dev/null 2>&1; then
  echo "No process named '$process_name' is running."
  exit 0
fi

escape_as() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}
esc_name=$(escape_as "$process_name")

# Pre-kill save: Activate edip Cmd+S gönder, app'in kayıt diyaloğunu
# kullanıcı bekler. Bu Win pre-kill-save davranışıyla aynı semantik.
if [ "$pre_kill_save" = "true" ]; then
  osascript <<EOF 2>/dev/null
tell application "$esc_name" to activate
delay 0.2
tell application "System Events" to keystroke "s" using {command down}
EOF
  # Save dialog'u açılırsa kullanıcının yanıt vermesi için biraz bekle.
  sleep 0.8
fi

# Graceful quit via AppleScript.
osascript -e "tell application \"$esc_name\" to quit" 2>/dev/null

# Timeout boyunca bekle, hâlâ çalışıyor mu kontrol et.
elapsed=0
while [ $elapsed -lt $timeout_sec ]; do
  if ! pgrep -ix "$process_name" >/dev/null 2>&1; then
    echo "All instances of '$process_name' closed gracefully."
    exit 0
  fi
  sleep 1
  elapsed=$((elapsed + 1))
done

# Hâlâ ayakta — SIGKILL.
killed_pids=$(pgrep -ix "$process_name" | tr '\n' ' ')
pkill -KILL -ix "$process_name" 2>/dev/null

if [ -n "$killed_pids" ]; then
  echo "Force-terminated pids: $killed_pids"
fi

exit 0
