#!/usr/bin/env bash
# fade-screen.sh
# SKAPI lx-debian Visual Break
# Linearly fades the internal display backlight from current to target
# over `duration` seconds. brightnessctl works on internal panels via
# /sys/class/backlight; external monitors over DDC need ddcutil and
# are not handled here.

set -u

target=20
duration=3
while [ $# -gt 0 ]; do
  case "$1" in
    --target) target="$2"; shift 2 ;;
    --duration) duration="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$target" -lt 0 ]; then target=0; fi
if [ "$target" -gt 100 ]; then target=100; fi
if [ "$duration" -lt 1 ]; then duration=1; fi

if ! command -v brightnessctl >/dev/null 2>&1; then
  echo "brightnessctl not installed. sudo apt install brightnessctl" >&2
  exit 2
fi

# brightnessctl prints "Current brightness: N (P%)" with -m it gives a
# machine-readable form: name,class,curr,max,curr%
read_pct=$(brightnessctl -m 2>/dev/null | awk -F, '{print $4}' | tr -d '%')
if [ -z "$read_pct" ]; then
  echo "Could not read current brightness." >&2
  exit 2
fi

steps=$(( duration * 10 ))
[ "$steps" -lt 1 ] && steps=1
sleep_ms=$(awk "BEGIN { printf \"%.3f\", $duration / $steps }")

echo "Fading $read_pct -> $target over ${duration}s"
i=1
while [ "$i" -le "$steps" ]; do
  pct=$(( read_pct + (target - read_pct) * i / steps ))
  brightnessctl set "${pct}%" >/dev/null
  sleep "$sleep_ms"
  i=$(( i + 1 ))
done
echo "OK"
