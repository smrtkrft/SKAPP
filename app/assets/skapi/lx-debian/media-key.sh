#!/usr/bin/env bash
# media-key.sh
# SKAPI lx-debian Display & Audio
# Sends a media-key action via playerctl (MPRIS). Linux's hidden gem:
# Spotify, Firefox, VLC, mpv, Rhythmbox all expose MPRIS, so one binary
# drives them all. Tier 1 because Debian ships playerctl in main.

set -u

key="play-pause"
while [ $# -gt 0 ]; do
  case "$1" in
    --key) key="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if ! command -v playerctl >/dev/null 2>&1; then
  echo "playerctl not installed. sudo apt install playerctl" >&2
  exit 2
fi

case "$key" in
  play-pause|playpause|play|pause) playerctl play-pause ;;
  next)                            playerctl next ;;
  prev|previous)                   playerctl previous ;;
  stop)                            playerctl stop ;;
  *)
    echo "Unknown media key: $key (use play-pause | next | previous | stop)" >&2
    exit 2
    ;;
esac

echo "media key sent: $key"
