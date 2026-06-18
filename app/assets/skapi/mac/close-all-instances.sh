#!/bin/bash
# close-all-instances.sh
# SKAPI MAC Programs
# Tüm açık örneklerine graceful quit gönderir. AppleScript `quit` her
# pencereye değil, app process'in tamamına gider — Win WM_CLOSE'un her
# pencereye gönderilmesinin Mac karşılığı genelde tek instance'a indirgenir
# çünkü macOS bir app = bir process'tir (Multi-instance Safari, Slack vb.
# istisna ama çoğu app tek).
#
# Pratik davranış: AppleScript ile app'i quit eder. Her instance kendi
# "unsaved changes" dialog'unu gösterebilir.

set -u

process_name=""

while [ $# -gt 0 ]; do
  case "$1" in
    --processName) process_name="$2"; shift 2 ;;
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

osascript -e "tell application \"$esc_name\" to quit" 2>/dev/null

count=$(pgrep -ix "$process_name" | wc -l | tr -d ' ')
echo "Sent quit to $process_name (remaining instances: $count)"
exit 0
