#!/usr/bin/env bash
# find-mouse-shake.sh
# SKAPI lx-debian Visual Break
# Wiggles the mouse cursor in a small circle around its current position.
# Useful on multi-monitor / 4K setups where the cursor is easy to lose.
# X11 only via xdotool; Wayland blocks synthetic pointer motion at the
# protocol level (security). Returns exit 3 on Wayland.

set -u

radius=60
loops=3
while [ $# -gt 0 ]; do
  case "$1" in
    --radius) radius="$2"; shift 2 ;;
    --loops) loops="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$radius" -lt 5 ]; then radius=5; fi
if [ "$radius" -gt 200 ]; then radius=200; fi
if [ "$loops" -lt 1 ]; then loops=1; fi
if [ "$loops" -gt 10 ]; then loops=10; fi

if [ "${XDG_SESSION_TYPE:-x11}" = "wayland" ]; then
  echo "Wayland blocks synthetic mouse motion." >&2
  exit 3
fi

if ! command -v xdotool >/dev/null 2>&1; then
  echo "xdotool not installed. sudo apt install xdotool" >&2
  exit 2
fi

# Read origin into ox, oy.
read -r ox oy < <(xdotool getmouselocation --shell | awk -F= '/^X=/ {x=$2} /^Y=/ {y=$2} END {print x, y}')

steps=36
l=0
while [ "$l" -lt "$loops" ]; do
  s=0
  while [ "$s" -lt "$steps" ]; do
    angle=$(awk "BEGIN { print 2 * 3.14159265 * $s / $steps }")
    dx=$(awk "BEGIN { printf \"%d\", cos($angle) * $radius }")
    dy=$(awk "BEGIN { printf \"%d\", sin($angle) * $radius }")
    xdotool mousemove $((ox + dx)) $((oy + dy))
    sleep 0.012
    s=$(( s + 1 ))
  done
  l=$(( l + 1 ))
done
xdotool mousemove "$ox" "$oy"
echo "OK"
