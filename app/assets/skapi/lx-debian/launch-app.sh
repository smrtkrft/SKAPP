#!/usr/bin/env bash
# launch-app.sh
# SKAPI lx-debian Window & App
# Starts a binary, .desktop launcher, URL or document. Detects the input
# kind: full path -> exec; ends with .desktop -> gtk-launch; otherwise
# falls back to xdg-open which handles MIME, URLs and PATH lookup.

set -u

path=""
args=""
while [ $# -gt 0 ]; do
  case "$1" in
    --path) path="$2"; shift 2 ;;
    --args) args="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$path" ]; then
  echo "path is required (executable, .desktop file, URL, or document)." >&2
  exit 2
fi

# .desktop file: prefer gtk-launch which respects user overrides.
case "$path" in
  *.desktop)
    if command -v gtk-launch >/dev/null 2>&1; then
      desktop_id="${path##*/}"
      desktop_id="${desktop_id%.desktop}"
      if [ -n "$args" ]; then
        gtk-launch "$desktop_id" $args >/dev/null 2>&1 &
      else
        gtk-launch "$desktop_id" >/dev/null 2>&1 &
      fi
      echo "Launched (gtk-launch): $desktop_id"
      exit 0
    fi
    ;;
esac

# Absolute or relative path to a real file: exec it directly.
if [ -e "$path" ]; then
  if [ -n "$args" ]; then
    setsid "$path" $args >/dev/null 2>&1 < /dev/null &
  else
    setsid "$path" >/dev/null 2>&1 < /dev/null &
  fi
  echo "Launched: $path"
  exit 0
fi

# Otherwise treat it as an xdg-open target (URL, mime, PATH binary).
if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$path" >/dev/null 2>&1 &
  echo "Opened: $path"
  exit 0
fi

# Last resort: PATH lookup.
if command -v "$path" >/dev/null 2>&1; then
  if [ -n "$args" ]; then
    setsid "$path" $args >/dev/null 2>&1 < /dev/null &
  else
    setsid "$path" >/dev/null 2>&1 < /dev/null &
  fi
  echo "Launched (PATH): $path"
  exit 0
fi

echo "Could not launch '$path'." >&2
exit 3
