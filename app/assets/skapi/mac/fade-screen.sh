#!/bin/bash
# fade-screen.sh
# SKAPI MAC Visual Break
# Internal display brightness'i şu anki seviyeden `target` seviyesine
# `duration` saniyede linear adımlarla indirir/yükseltir. Tier 2:
# `brightness` CLI dependency (brew install brightness). External
# monitorlar genelde desteklenmez (Win/Linux paritesi).

set -u

target=20
duration=3

while [ $# -gt 0 ]; do
  case "$1" in
    --target)   target="$2"; shift 2 ;;
    --duration) duration="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$target" -lt 0 ]; then target=0; fi
if [ "$target" -gt 100 ]; then target=100; fi
if [ "$duration" -lt 1 ]; then duration=1; fi

if ! command -v brightness >/dev/null 2>&1; then
  echo "brightness CLI not found. Install with: brew install brightness" >&2
  exit 2
fi

# Current brightness'i 0-100 olarak oku (CLI float döner, *100).
current_frac=$(brightness -l 2>/dev/null | awk '/brightness/ { print $4; exit }')
if [ -z "$current_frac" ]; then
  echo "Could not read current brightness." >&2
  exit 2
fi
current=$(awk -v c="$current_frac" 'BEGIN { printf "%d", c * 100 }')

echo "Fading $current -> $target over ${duration}s"

steps=$((duration * 10))
if [ $steps -lt 1 ]; then steps=1; fi
sleep_ms=$(awk -v d="$duration" -v s="$steps" 'BEGIN { printf "%.3f", (d * 1.0) / s }')

i=1
while [ $i -le $steps ]; do
  t=$(awk -v c="$current" -v g="$target" -v i="$i" -v s="$steps" 'BEGIN { printf "%d", c + (g - c) * i / s }')
  frac=$(awk -v t="$t" 'BEGIN { printf "%.4f", t / 100.0 }')
  brightness "$frac" >/dev/null 2>&1
  sleep "$sleep_ms"
  i=$((i + 1))
done

echo "OK"
exit 0
