#!/usr/bin/env bash
# browser-close-all.sh
# SKAPI lx-debian Programs
# Closes every running browser instance gracefully via SIGTERM. Modern
# browsers preserve the session if "restore tabs on next launch" is on,
# so this is a soft "switch off the screen" rather than a data-loss
# action. Process names follow Debian package binary names.

set -u

# Comm names are limited to 15 chars by the kernel; pkill -x must match
# exactly. The list maps Debian package binaries.
browsers=(
  "firefox"
  "firefox-esr"
  "chromium"
  "chrome"
  "google-chrome"
  "brave"
  "vivaldi"
  "vivaldi-bin"
  "opera"
)

total=0
for name in "${browsers[@]}"; do
  if pgrep -x "$name" >/dev/null 2>&1; then
    count=$(pgrep -x "$name" | wc -l)
    pkill -TERM -x "$name" || true
    total=$(( total + count ))
  fi
done

echo "Sent SIGTERM to $total browser processes"
