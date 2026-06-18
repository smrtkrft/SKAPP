#!/usr/bin/env bash
# brightness.sh
# SKAPI lx-debian Display & Audio
# Sets internal display brightness (0-100) via brightnessctl, with a
# fallback to the lighter `light` tool for setups that ship it. Both
# write to /sys/class/backlight; on Debian, brightnessctl needs the user
# in the `video` group to run sudoless (default after install on most
# distros; see /usr/lib/udev/rules.d/90-brightnessctl.rules).

set -u

level=70
while [ $# -gt 0 ]; do
  case "$1" in
    --level) level="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$level" -lt 0 ]; then level=0; fi
if [ "$level" -gt 100 ]; then level=100; fi

if command -v brightnessctl >/dev/null 2>&1; then
  brightnessctl set "${level}%" >/dev/null
  echo "Set brightness to ${level}%"
  exit 0
fi

if command -v light >/dev/null 2>&1; then
  light -S "$level"
  echo "Set brightness to ${level}%"
  exit 0
fi

echo "No brightness tool found. Install: sudo apt install brightnessctl" >&2
exit 2
