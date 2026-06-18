#!/usr/bin/env bash
# save-all-open.sh
# SKAPI lx-debian Save Work
# Iterates whitelisted app process names, activates each visible window,
# and sends Ctrl+S. Default app list covers LibreOffice, VS Code, gedit,
# kate; pass --apps "name1,name2" to override. X11 only.

set -u

apps_csv="soffice.bin,code,gedit,kate"
timeoutPerApp=2
verbose="true"
while [ $# -gt 0 ]; do
  case "$1" in
    --apps) apps_csv="$2"; shift 2 ;;
    --timeoutPerApp) timeoutPerApp="$2"; shift 2 ;;
    --verbose) verbose="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "${XDG_SESSION_TYPE:-x11}" = "wayland" ]; then
  echo "Wayland blocks synthetic key events." >&2
  exit 3
fi

if ! command -v xdotool >/dev/null 2>&1; then
  echo "xdotool not installed. sudo apt install xdotool" >&2
  exit 2
fi

IFS=',' read -ra apps <<< "$apps_csv"

for name in "${apps[@]}"; do
  name="${name// /}"
  [ -z "$name" ] && continue
  if ! pgrep -x "$name" >/dev/null 2>&1; then
    [ "$verbose" = "true" ] && echo "Skip: $name (not running)"
    continue
  fi
  mapfile -t wids < <(xdotool search --onlyvisible --class "$name" 2>/dev/null || true)
  if [ "${#wids[@]}" -eq 0 ]; then
    [ "$verbose" = "true" ] && echo "Skip: $name (no visible window)"
    continue
  fi
  for wid in "${wids[@]}"; do
    xdotool windowactivate --sync "$wid" key --clearmodifiers ctrl+s
    [ "$verbose" = "true" ] && echo "Saved: $name ($wid)"
    sleep "$timeoutPerApp"
  done
done

echo "OK"
