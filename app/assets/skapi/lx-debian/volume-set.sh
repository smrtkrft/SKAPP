#!/usr/bin/env bash
# volume-set.sh
# SKAPI lx-debian Display & Audio
# Sets the master sink volume to a 0-100 level. Native to PipeWire/PulseAudio
# (no COM-equivalent gymnastics needed). Note: pactl can exceed 100% by
# design; this wrapper clamps to keep parity with the WIN script.

set -u

level=50
while [ $# -gt 0 ]; do
  case "$1" in
    --level) level="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$level" -lt 0 ]; then level=0; fi
if [ "$level" -gt 100 ]; then level=100; fi

if command -v wpctl >/dev/null 2>&1; then
  # wpctl takes a 0.0-1.0 float; format with 2 decimals.
  scalar=$(awk "BEGIN { printf \"%.2f\", $level/100 }")
  wpctl set-volume @DEFAULT_AUDIO_SINK@ "$scalar"
  echo "Master volume set to ${level}% (wpctl)"
  exit 0
fi

if command -v pactl >/dev/null 2>&1; then
  pactl set-sink-volume @DEFAULT_SINK@ "${level}%"
  echo "Master volume set to ${level}% (pactl)"
  exit 0
fi

echo "Neither wpctl nor pactl available." >&2
exit 2
