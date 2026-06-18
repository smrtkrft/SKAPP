#!/usr/bin/env bash
# toast.sh
# SKAPI lx-debian Notify
# Sends a desktop toast through libnotify (notify-send). Tier 1 because
# notify-send is preinstalled on every modern Debian desktop. Icon names
# come from the Freedesktop icon-theme spec (e.g. dialog-information,
# dialog-warning, dialog-error). duration is the expire-time in seconds;
# 0 means "until dismissed".

set -u

title="SmartKraft"
body=""
icon="dialog-information"
duration=5
while [ $# -gt 0 ]; do
  case "$1" in
    --title) title="$2"; shift 2 ;;
    --body) body="$2"; shift 2 ;;
    --icon) icon="$2"; shift 2 ;;
    --duration) duration="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if ! command -v notify-send >/dev/null 2>&1; then
  echo "notify-send not installed. sudo apt install libnotify-bin" >&2
  exit 2
fi

# notify-send -t expects milliseconds; convert.
expire_ms=$(( duration * 1000 ))

notify-send -i "$icon" -t "$expire_ms" -a "SKAPP" "$title" "$body"
echo "OK"
