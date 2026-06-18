#!/usr/bin/env bash
# close-all-instances.sh
# SKAPI lx-debian Programs
# Sends SIGTERM to every running instance of the process. Graceful: each
# app handles its own shutdown sequence (and may still show its own save
# dialog). Use kill-app for the force-terminate variant.

set -u

processName=""
while [ $# -gt 0 ]; do
  case "$1" in
    --processName) processName="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$processName" ]; then
  echo "processName is required." >&2
  exit 2
fi

if ! pgrep -x "$processName" >/dev/null 2>&1; then
  echo "No running instance of '$processName'."
  exit 0
fi

count=$(pgrep -x "$processName" | wc -l)
pkill -TERM -x "$processName"
echo "Sent SIGTERM to $count instances of $processName"
