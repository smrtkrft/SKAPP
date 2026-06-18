#!/usr/bin/env bash
# lock.sh
# SKAPI lx-debian Power Management
# Locks the current desktop session. Tries loginctl first (works on systemd
# Debian/Ubuntu under any session manager that listens to logind), then
# falls back to xdg-screensaver for non-systemd minimal setups.

set -u

if command -v loginctl >/dev/null 2>&1; then
  if loginctl lock-session "${XDG_SESSION_ID:-}" 2>/dev/null; then
    echo "OK"
    exit 0
  fi
fi

if command -v xdg-screensaver >/dev/null 2>&1; then
  xdg-screensaver lock
  echo "OK"
  exit 0
fi

echo "No supported lock mechanism found (loginctl/xdg-screensaver)." >&2
exit 2
