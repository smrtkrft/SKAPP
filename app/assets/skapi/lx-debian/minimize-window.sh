#!/usr/bin/env bash
# minimize-window.sh
# SKAPI lx-debian Window & App
# Minimises one window. Empty processName targets the currently focused
# window (xdotool getactivewindow); otherwise picks the first window
# whose WM_CLASS matches. X11 only: Wayland has no portable handle for
# arbitrary windows.

set -u

processName=""
while [ $# -gt 0 ]; do
  case "$1" in
    --processName) processName="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "${XDG_SESSION_TYPE:-x11}" = "wayland" ]; then
  echo "Wayland session: per-window minimize needs compositor IPC." >&2
  exit 3
fi

if ! command -v xdotool >/dev/null 2>&1; then
  echo "xdotool not installed. sudo apt install xdotool" >&2
  exit 2
fi

if [ -z "$processName" ]; then
  wid=$(xdotool getactivewindow)
  xdotool windowminimize "$wid"
  echo "Minimised foreground window ($wid)"
  exit 0
fi

wid=$(xdotool search --class "$processName" 2>/dev/null | head -n 1)
if [ -z "$wid" ]; then
  echo "No window for class '$processName'." >&2
  exit 3
fi
xdotool windowminimize "$wid"
echo "Minimised: $processName ($wid)"
