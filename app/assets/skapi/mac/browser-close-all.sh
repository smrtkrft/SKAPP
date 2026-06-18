#!/bin/bash
# browser-close-all.sh
# SKAPI MAC Programs
# Tüm açık browser pencerelerini graceful kapatır. Modern browser'lar
# "next launch'ta sekme geri yükle" tercihi açıksa session korunur, bu
# yüzden "ekranı kapat" tarzı yumuşak bir aksiyon. Veri kaybı eylemi
# değil.
#
# Mac process isimleri Linux'tan farklı:
#   Linux: chrome, chromium, firefox, brave, vivaldi, opera
#   Mac:   "Google Chrome", "Firefox", "Safari", "Microsoft Edge",
#          "Brave Browser", "Vivaldi", "Opera"
#
# Yöntem: AppleScript ile her browser'a `tell application "X" to quit`.
# Process listede yoksa skip.

set -u

browsers=(
  "Safari"
  "Google Chrome"
  "Firefox"
  "Microsoft Edge"
  "Brave Browser"
  "Vivaldi"
  "Opera"
  "Arc"
)

closed=0

for app in "${browsers[@]}"; do
  if pgrep -ix "$app" >/dev/null 2>&1; then
    osascript -e "tell application \"$app\" to quit" 2>/dev/null && \
      closed=$((closed + 1))
  fi
done

if [ $closed -eq 0 ]; then
  echo "No browser instances running."
else
  echo "Closed $closed browser(s)"
fi

exit 0
