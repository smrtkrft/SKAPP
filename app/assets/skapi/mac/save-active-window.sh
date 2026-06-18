#!/bin/bash
# save-active-window.sh
# SKAPI MAC Save Work
# Aktif uygulamaya Cmd+S gönderir. AppleScript System Events ile
# keystroke. Frontmost app'in adı verbose'da raporlanır.

set -u

timeout_sec=2
verbose=true

while [ $# -gt 0 ]; do
  case "$1" in
    --timeout) timeout_sec="$2"; shift 2 ;;
    --verbose) verbose="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$verbose" = "true" ]; then
  fg=$(osascript -e 'tell application "System Events" to name of first application process whose frontmost is true' 2>/dev/null)
  echo "Target window: $fg"
fi

osascript -e 'tell application "System Events" to keystroke "s" using {command down}' 2>/dev/null

sleep "$timeout_sec"
echo "OK"
exit 0
