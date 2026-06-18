#!/bin/bash
# save-all-open.sh
# SKAPI MAC Save Work
# Whitelisted apps'in her birini sırayla activate edip Cmd+S gönderir,
# işlem sonunda orijinal foreground app'a geri döner.
#
# Win'deki Ctrl+S whitelist mantığına paralel. Default whitelist Mac
# yerli ofis app'leri (Pages/Numbers/Keynote) + TextEdit + VS Code.
# Slack/Discord/Safari Cmd+S'yi farklı yorumlar — kasıtlı dışarıda.
# Kullanıcı `--apps` ile override edebilir.

set -u

apps_csv="Pages,Numbers,Keynote,TextEdit,Code"
timeout_per_app=1
verbose=true

while [ $# -gt 0 ]; do
  case "$1" in
    --apps)          apps_csv="$2"; shift 2 ;;
    --timeoutPerApp) timeout_per_app="$2"; shift 2 ;;
    --verbose)       verbose="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# Original foreground app'i kaydet (sonra geri dönülecek).
original_fg=$(osascript -e 'tell application "System Events" to name of first application process whose frontmost is true' 2>/dev/null)

saved=0
skipped=0

# CSV'yi IFS ile parse et.
IFS=',' read -r -a apps_arr <<< "$apps_csv"

for raw in "${apps_arr[@]}"; do
  # Trim whitespace.
  app=$(echo "$raw" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  if [ -z "$app" ]; then continue; fi

  if ! pgrep -ix "$app" >/dev/null 2>&1; then
    if [ "$verbose" = "true" ]; then echo "Skip: $app (not running)"; fi
    skipped=$((skipped + 1))
    continue
  fi

  escape_as() {
    printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
  }
  esc_app=$(escape_as "$app")

  osascript <<EOF 2>/dev/null
tell application "$esc_app" to activate
delay 0.25
tell application "System Events" to keystroke "s" using {command down}
EOF

  sleep "$timeout_per_app"
  if [ "$verbose" = "true" ]; then echo "Saved: $app"; fi
  saved=$((saved + 1))
done

# Original foreground'a dön.
if [ -n "$original_fg" ]; then
  escape_as_orig=$(printf '%s' "$original_fg" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g')
  osascript -e "tell application \"$escape_as_orig\" to activate" 2>/dev/null
fi

echo "OK (saved=$saved skipped=$skipped)"
exit 0
