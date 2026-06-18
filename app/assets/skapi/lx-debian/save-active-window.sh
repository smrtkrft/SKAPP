#!/usr/bin/env bash
# save-active-window.sh
# SKAPI lx-debian Save Work
# Sends Ctrl+S to the currently focused window via xdotool. X11 only:
# Wayland blocks synthetic key injection at the protocol level.

set -u

timeout=2
verbose="true"
while [ $# -gt 0 ]; do
  case "$1" in
    --timeout) timeout="$2"; shift 2 ;;
    --verbose) verbose="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "${XDG_SESSION_TYPE:-x11}" = "wayland" ]; then
  echo "Wayland blocks synthetic key events. Use autosave-trigger fallback." >&2
  exit 3
fi

if ! command -v xdotool >/dev/null 2>&1; then
  echo "xdotool not installed. sudo apt install xdotool" >&2
  exit 2
fi

if [ "$verbose" = "true" ]; then
  name=$(xdotool getactivewindow getwindowname 2>/dev/null || echo "")
  echo "Target window: $name"
fi

xdotool key --clearmodifiers ctrl+s
sleep "$timeout"
echo "OK"
