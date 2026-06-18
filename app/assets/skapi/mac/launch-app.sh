#!/bin/bash
# launch-app.sh
# SKAPI MAC Window & App
# Bir uygulamayı, URL'yi veya doküman'ı macOS native `open` ile başlatır.
# Üç input türü desteklenir:
#   1) App bundle adı: "Safari", "Visual Studio Code" → `open -a Name`
#   2) Tam path: "/Applications/Safari.app" → `open path`
#   3) URL: "https://example.com" veya "mailto:..." → `open url`
#
# `open` komutu mac native, sudo gerektirmez, .app paketlerini ve
# URL scheme'lerini doğrudan tanır. Win'in Start-Process eşdeğeri.

set -u

path=""
cmd_args=""

while [ $# -gt 0 ]; do
  case "$1" in
    --path)    path="$2"; shift 2 ;;
    --cmdArgs) cmd_args="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$path" ]; then
  echo "path is required (app name, .app path, URL, or document)." >&2
  exit 2
fi

# cmd_args verilmişse `open -a Name --args ...` ile binary'e geçilir.
if [ -n "$cmd_args" ]; then
  # shellcheck disable=SC2086
  open -a "$path" --args $cmd_args 2>/dev/null
  ec=$?
else
  open "$path" 2>/dev/null
  ec=$?
  if [ $ec -ne 0 ]; then
    # `open path` başarısız oldu → -a flag ile app adı olarak dene.
    open -a "$path" 2>/dev/null
    ec=$?
  fi
fi

if [ $ec -ne 0 ]; then
  echo "Failed to launch: $path" >&2
  exit 1
fi

echo "Launched: $path"
exit 0
