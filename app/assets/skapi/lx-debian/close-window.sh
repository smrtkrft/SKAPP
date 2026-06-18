#!/usr/bin/env bash
# close-window.sh
# SKAPI lx-debian Window & App
# Sends WM_DELETE_WINDOW to a window picked by WM_CLASS, equivalent to
# clicking the X button. The app may show its own "save?" dialog. Empty
# processName targets the active window. X11 path; for Wayland, prefer
# the kill-app graceful path which uses signals.

set -u

processName=""
while [ $# -gt 0 ]; do
  case "$1" in
    --processName) processName="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "${XDG_SESSION_TYPE:-x11}" = "wayland" ]; then
  echo "Wayland session: use kill-app for graceful close." >&2
  exit 3
fi

if ! command -v wmctrl >/dev/null 2>&1; then
  echo "wmctrl not installed. sudo apt install wmctrl" >&2
  exit 2
fi

if [ -z "$processName" ]; then
  if ! command -v xdotool >/dev/null 2>&1; then
    echo "xdotool needed to find active window. sudo apt install xdotool" >&2
    exit 2
  fi
  wid=$(xdotool getactivewindow)
  wmctrl -i -c "$wid"
  echo "Sent close to active window ($wid)"
  exit 0
fi

# wmctrl -x -c matches by WM_CLASS instance (e.g. "firefox.Firefox").
if wmctrl -x -c "$processName" 2>/dev/null; then
  echo "Sent close: $processName"
  exit 0
fi

# Last resort: title substring match.
if wmctrl -c "$processName" 2>/dev/null; then
  echo "Sent close (title match): $processName"
  exit 0
fi

echo "No window matching '$processName'." >&2
exit 3
