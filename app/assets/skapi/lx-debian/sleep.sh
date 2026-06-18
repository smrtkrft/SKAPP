#!/usr/bin/env bash
# sleep.sh
# SKAPI lx-debian Power Management
# Suspends the machine to RAM via systemd-logind. The OS may delay if a
# foreground inhibitor (systemd-inhibit) is blocking idle transitions.

set -u

delay=0
while [ $# -gt 0 ]; do
  case "$1" in
    --delay) delay="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$delay" -gt 0 ]; then sleep "$delay"; fi

if ! command -v systemctl >/dev/null 2>&1; then
  echo "systemctl not available." >&2
  exit 2
fi

systemctl suspend
echo "OK"
