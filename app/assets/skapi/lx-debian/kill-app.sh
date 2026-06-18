#!/usr/bin/env bash
# kill-app.sh
# SKAPI lx-debian Window & App
# Graceful then force terminate by process name. Sends SIGTERM via
# pkill, waits `timeout` seconds, then SIGKILL anything still alive.
# preKillSave attempts a Ctrl+S to the app's window first (X11 only).

set -u

processName=""
timeout=5
preKillSave="false"
while [ $# -gt 0 ]; do
  case "$1" in
    --processName) processName="$2"; shift 2 ;;
    --timeout) timeout="$2"; shift 2 ;;
    --preKillSave) preKillSave="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$processName" ]; then
  echo "processName is required." >&2
  exit 2
fi

if ! pgrep -x "$processName" >/dev/null 2>&1; then
  echo "No process named '$processName' is running."
  exit 0
fi

if [ "$preKillSave" = "true" ] && [ "${XDG_SESSION_TYPE:-x11}" != "wayland" ]; then
  if command -v xdotool >/dev/null 2>&1; then
    wid=$(xdotool search --onlyvisible --class "$processName" 2>/dev/null | head -n 1)
    if [ -n "$wid" ]; then
      xdotool windowactivate --sync "$wid" key --clearmodifiers ctrl+s
      sleep 1
    fi
  fi
fi

pkill -TERM -x "$processName" || true
sleep "$timeout"

if pgrep -x "$processName" >/dev/null 2>&1; then
  pkill -KILL -x "$processName" || true
  echo "Force-terminated '$processName'."
else
  echo "All instances of '$processName' closed gracefully."
fi
