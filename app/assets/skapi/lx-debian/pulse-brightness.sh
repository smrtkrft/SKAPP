#!/usr/bin/env bash
# pulse-brightness.sh
# SKAPI lx-debian Visual Break
# Internal display brightness'i 100% ↔ lowPercent arasında cosine
# wave ile salınır, cycles kez tekrarlar. Sonra kullanıcının orijinal
# brightness'ine geri döner. Win/Mac pulse-brightness paritesi.
# Internal panel only (brightnessctl /sys/class/backlight); external
# monitorlar ddcutil ile ayrı ele alınır, bu script kapsamında değil.

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

if ! command -v brightnessctl >/dev/null 2>&1; then
  echo "brightnessctl not installed. sudo apt install brightnessctl" >&2
  exit 2
fi

current_pct=$(brightnessctl -m 2>/dev/null | awk -F, '{print $4}' | tr -d '%')
if [ -z "$current_pct" ]; then
  echo "Could not read current brightness." >&2
  exit 2
fi

# Trap: kesinti veya normal exit'te orijinale dön.
restore_brightness() {
  brightnessctl set "${current_pct}%" >/dev/null 2>&1
}
trap restore_brightness EXIT INT TERM

# 20 fps · period * 20 step per cycle
steps_per_period=$(( period * 20 ))
sleep_ms=0.05
high=100
mid=$(awk -v h="$high" -v l="$low_percent" 'BEGIN { print (h + l) / 2.0 }')
amp=$(awk -v h="$high" -v l="$low_percent" 'BEGIN { print (h - l) / 2.0 }')

c=0
while [ "$c" -lt "$cycles" ]; do
  i=0
  while [ "$i" -lt "$steps_per_period" ]; do
    pct=$(awk -v m="$mid" -v a="$amp" -v i="$i" -v s="$steps_per_period" 'BEGIN { printf "%d", m + a * cos(2 * 3.14159265 * i / s) }')
    brightnessctl set "${pct}%" >/dev/null 2>&1
    sleep "$sleep_ms"
    i=$(( i + 1 ))
  done
  c=$(( c + 1 ))
done

echo "OK"
exit 0
