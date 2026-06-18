#!/usr/bin/env bash
# mute-toggle.sh
# SKAPI lx-debian Display & Audio
# Toggles or sets the master sink mute. Tries wpctl first (PipeWire on
# Debian 12+), falls back to pactl (PulseAudio on older releases). Both
# binaries ship with the default audio stack so most users have one.

set -u

mode="toggle"
while [ $# -gt 0 ]; do
  case "$1" in
    --mode) mode="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if command -v wpctl >/dev/null 2>&1; then
  case "$mode" in
    on)     wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 ;;
    off)    wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 ;;
    toggle|*) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
  esac
  echo "mute ${mode} (wpctl)"
  exit 0
fi

if command -v pactl >/dev/null 2>&1; then
  case "$mode" in
    on)     pactl set-sink-mute @DEFAULT_SINK@ 1 ;;
    off)    pactl set-sink-mute @DEFAULT_SINK@ 0 ;;
    toggle|*) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
  esac
  echo "mute ${mode} (pactl)"
  exit 0
fi

echo "Neither wpctl nor pactl available." >&2
exit 2
