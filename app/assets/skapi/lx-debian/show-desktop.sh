#!/usr/bin/env bash
# show-desktop.sh
# SKAPI lx-debian Visual Break
# Toggles "show desktop" via the EWMH _NET_SHOWING_DESKTOP atom. Pressing
# the same command again restores the previous arrangement, mirroring
# Win+D semantics. X11 only; Wayland equivalents are compositor-specific.

set -u

if [ "${XDG_SESSION_TYPE:-x11}" = "wayland" ]; then
  echo "Wayland session: show-desktop needs compositor support." >&2
  exit 3
fi

if ! command -v wmctrl >/dev/null 2>&1; then
  echo "wmctrl not installed. sudo apt install wmctrl" >&2
  exit 2
fi

# Read current state to toggle: wmctrl -m prints "showing the desktop: ON/OFF".
state=$(wmctrl -m 2>/dev/null | awk -F': ' '/showing the desktop/ {print $2}' | tr '[:upper:]' '[:lower:]')
if [ "$state" = "on" ]; then
  wmctrl -k off
else
  wmctrl -k on
fi
echo "OK"
