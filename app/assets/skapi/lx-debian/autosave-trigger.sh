#!/usr/bin/env bash
# autosave-trigger.sh
# SKAPI lx-debian Save Work
# Walks every visible top-level window and sends Ctrl+S. X11 lacks the
# WIN WM_COMMAND/ID_SAVE broadcast path, so the fallback is per-window
# focus + key injection via xdotool. Tier 2 because it depends on the
# focused app honouring Ctrl+S as "save" (most editors do; chat apps
# may misinterpret).

set -u

delay=0
verbose="true"
while [ $# -gt 0 ]; do
  case "$1" in
    --delay) delay="$2"; shift 2 ;;
    --verbose) verbose="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$delay" -gt 0 ]; then sleep "$delay"; fi

if [ "${XDG_SESSION_TYPE:-x11}" = "wayland" ]; then
  echo "Wayland blocks broadcast key injection." >&2
  exit 3
fi

for tool in wmctrl xdotool; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "$tool not installed. sudo apt install $tool" >&2
    exit 2
  fi
done

# wmctrl -l columns: WID DESKTOP HOST TITLE
count=0
while IFS= read -r line; do
  wid=$(echo "$line" | awk '{print $1}')
  title=$(echo "$line" | cut -d' ' -f5-)
  [ -z "$wid" ] && continue
  [ -z "$title" ] && continue
  xdotool windowactivate --sync "$wid" key --clearmodifiers ctrl+s 2>/dev/null || continue
  [ "$verbose" = "true" ] && echo "Sent: $title"
  count=$(( count + 1 ))
  sleep 0.2
done < <(wmctrl -l)

echo "OK ($count windows)"
