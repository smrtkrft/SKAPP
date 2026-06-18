#!/usr/bin/env bash
# shutdown.sh
# SKAPI lx-debian Power Management
# Schedules a graceful poweroff. Uses /sbin/shutdown for delay support;
# on Debian this honours the inhibitor lock and broadcasts a wall message
# to other logged-in users.

set -u

delay=30
force=false
while [ $# -gt 0 ]; do
  case "$1" in
    --delay) delay="$2"; shift 2 ;;
    --force) force="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# /sbin/shutdown takes minutes (or +N for "now in N minutes"). Convert
# the SKAPP "seconds" parameter; values under 60 round up to 1 minute
# because shutdown -h has no sub-minute granularity.
mins=$(( (delay + 59) / 60 ))
if [ "$mins" -lt 1 ]; then mins=1; fi

if [ "$force" = "true" ]; then
  # No SIGKILL inside shutdown; "force" here means skip the standard
  # 90s SIGTERM grace by sending SIGKILL to user services first.
  loginctl terminate-user "$USER" 2>/dev/null || true
fi

if command -v shutdown >/dev/null 2>&1; then
  shutdown -h "+${mins}"
  echo "Scheduled poweroff in ${mins} min"
  exit 0
fi

if command -v systemctl >/dev/null 2>&1; then
  if [ "$delay" -gt 0 ]; then sleep "$delay"; fi
  systemctl poweroff
  echo "OK"
  exit 0
fi

echo "Neither shutdown nor systemctl found." >&2
exit 2
