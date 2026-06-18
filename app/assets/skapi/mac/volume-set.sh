#!/bin/bash
# volume-set.sh
# SKAPI MAC Display & Audio
# Master ses seviyesini 0-100 olarak ayarlar. AppleScript `set volume
# output volume` native API; sudo gerektirmez, CoreAudio'ya direkt
# bağlanır. Per-app volume desteklemez (Win volume-set ile aynı kapsam).

set -u

level=50

while [ $# -gt 0 ]; do
  case "$1" in
    --level) level="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$level" -lt 0 ]; then level=0; fi
if [ "$level" -gt 100 ]; then level=100; fi

osascript -e "set volume output volume $level" 2>/dev/null

echo "Master volume set to ${level}%"
exit 0
