#!/bin/bash
# sleep.sh
# SKAPI MAC Power Management
# macOS'u uyku moduna alır (S3, RAM'de tutar). `pmset sleepnow` sudo
# gerektirmeyen native komut. Foreground bir process idle transition'ı
# engelliyorsa OS gecikebilir (örn: video çalıyor, network indirme).

set -u

delay=0

while [ $# -gt 0 ]; do
  case "$1" in
    --delay) delay="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$delay" -gt 0 ]; then
  sleep "$delay"
fi

pmset sleepnow >/dev/null 2>&1

echo "OK"
exit 0
