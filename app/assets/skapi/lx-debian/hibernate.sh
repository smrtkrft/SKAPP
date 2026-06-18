#!/usr/bin/env bash
# hibernate.sh
# SKAPI lx-debian Power Management
# Hibernates the machine via systemd-logind. Requires hibernation to be
# configured (swap >= RAM and resume= kernel param); on Debian the default
# fallback is suspend if hibernation is not available.

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

systemctl hibernate
echo "OK"
