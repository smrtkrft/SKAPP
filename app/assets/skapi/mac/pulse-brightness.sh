#!/bin/bash
# pulse-brightness.sh
# SKAPI MAC Visual Break
# Internal display brightness'i cosine dalga ile 100% ↔ lowPercent
# arasında `period` saniyede salınır, `cycles` kez tekrarlar. Sonra
# kullanıcının orijinal brightness'ine geri döner. Tier 2: `brightness`
# CLI dependency.
#
# 20 fps update: dalga akıcı görünür ama brightness API'sini
# yumuşatmaz. Çıkışta finally davranışı için trap kullanılır —
# user Ctrl+C basarsa veya sleep kesilirse orijinal brightness'a
# geri dönülür.

set -u

period=2
low_percent=60
cycles=5

while [ $# -gt 0 ]; do
  case "$1" in
    --period)     period="$2"; shift 2 ;;
    --lowPercent) low_percent="$2"; shift 2 ;;
    --cycles)     cycles="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$period" -lt 1 ]; then period=1; fi
if [ "$period" -gt 10 ]; then period=10; fi
if [ "$low_percent" -lt 0 ]; then low_percent=0; fi
if [ "$low_percent" -gt 90 ]; then low_percent=90; fi
if [ "$cycles" -lt 1 ]; then cycles=1; fi
if [ "$cycles" -gt 30 ]; then cycles=30; fi

if ! command -v brightness >/dev/null 2>&1; then
  echo "brightness CLI not found. Install with: brew install brightness" >&2
  exit 2
fi

current_frac=$(brightness -l 2>/dev/null | awk '/brightness/ { print $4; exit }')
if [ -z "$current_frac" ]; then
  echo "Could not read current brightness." >&2
  exit 2
fi
current=$(awk -v c="$current_frac" 'BEGIN { printf "%d", c * 100 }')

# Trap: kesinti veya normal exit'te orijinale dön.
restore_brightness() {
  frac=$(awk -v c="$current" 'BEGIN { printf "%.4f", c / 100.0 }')
  brightness "$frac" >/dev/null 2>&1
}
trap restore_brightness EXIT INT TERM

steps_per_period=$((period * 20))
sleep_ms=0.05  # 20 fps
high=100
mid=$(awk -v h="$high" -v l="$low_percent" 'BEGIN { print (h + l) / 2.0 }')
amp=$(awk -v h="$high" -v l="$low_percent" 'BEGIN { print (h - l) / 2.0 }')

c=0
while [ $c -lt $cycles ]; do
  i=0
  while [ $i -lt $steps_per_period ]; do
    t=$(awk -v m="$mid" -v a="$amp" -v i="$i" -v s="$steps_per_period" 'BEGIN { printf "%d", m + a * cos(2 * 3.14159265 * i / s) }')
    frac=$(awk -v t="$t" 'BEGIN { printf "%.4f", t / 100.0 }')
    brightness "$frac" >/dev/null 2>&1
    sleep "$sleep_ms"
    i=$((i + 1))
  done
  c=$((c + 1))
done

echo "OK"
exit 0
