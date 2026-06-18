#!/bin/bash
# shutdown.sh
# SKAPI MAC Power Management
# macOS'ta kapatma için iki yol var:
#   1) `osascript 'tell app "System Events" to shut down'` — sudo
#      gerektirmez, Apple onaylı kullanıcı düzeyi kapatma (gerekirse
#      kayıtsız belgeler için onay sorabilir).
#   2) `sudo shutdown -h +N` — gerçek zamanlamalı kapatma, ama sudo
#      gerektirir. Webhook bağlamında sudo şifresi yok.
#
# Pratik seçim: AppleScript yolu (1). delay paramı kullanıcı kapatma
# tetiğini geciktirir — biz sleep ile bekleriz, sonra AppleScript.
# force=true durumunda kayıtsız belge onayını atlayan davranış için
# AppleScript yine yetmiyor; tek alternatif `sudo /sbin/shutdown -h now`
# olur ve bu webhook'ta çalışmaz. force flag bu yüzden bilgi amaçlı
# kabul edilir, davranışı değiştirmez (tutarlılık için manifest'te
# bırakıldı).

set -u

delay=30
force=false

while [ $# -gt 0 ]; do
  case "$1" in
    --delay) delay="$2"; shift 2 ;;
    --force) force="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$delay" -gt 0 ]; then
  sleep "$delay"
fi

osascript -e 'tell application "System Events" to shut down' 2>/dev/null

echo "OK"
exit 0
