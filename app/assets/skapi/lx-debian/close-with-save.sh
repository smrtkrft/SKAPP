#!/usr/bin/env bash
# close-with-save.sh
# SKAPI lx-debian Programs
# Activates each window of the named process, sends Ctrl+S, waits, then
# requests a graceful close via WM_DELETE_WINDOW. Tier 2: SendKeys-style
# automation is locale and focus dependent and only "save" semantics
# behave predictably. X11 only.

set -u

processName=""
wait_s=1
while [ $# -gt 0 ]; do
  case "$1" in
    --processName) processName="$2"; shift 2 ;;
    --wait) wait_s="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$processName" ]; then
  echo "processName is required." >&2
  exit 2
fi

if [ "${XDG_SESSION_TYPE:-x11}" = "wayland" ]; then
  echo "Wayland blocks synthetic key events. Use kill-app instead." >&2
  exit 3
fi

for tool in xdotool wmctrl; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "$tool not installed. sudo apt install $tool" >&2
    exit 2
  fi
done

# Find every visible window whose WM_CLASS matches.
mapfile -t wids < <(xdotool search --onlyvisible --class "$processName" 2>/dev/null || true)
if [ "${#wids[@]}" -eq 0 ]; then
  echo "No visible window for '$processName'."
  exit 0
fi

for wid in "${wids[@]}"; do
  xdotool windowactivate --sync "$wid" key --clearmodifiers ctrl+s
  sleep "$wait_s"
  wmctrl -i -c "$wid"
  echo "Save+close: $processName ($wid)"
done
