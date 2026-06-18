#!/bin/bash
# grayscale.sh
# SKAPI MAC Visual Break
# macOS Color Filter (grayscale) toggle. Yöntem: `defaults write` ile
# Accessibility preferences kayıtlarını yaz, sonra `pkill universalAccessd`
# ile preferences daemon'ı yeniden başlatıp değişikliği apply ettir.
#
# Üç mod (Windows grayscale ile paralel):
#   1) on=true + durationSec=0  → gri'ye geçer ve bekler
#   2) on=false + durationSec=0 → renge döner
#   3) on=true + durationSec>0  → gri'ye geçer, N saniye sonra otomatik
#      olarak renge döner (auto-revert, görsel mola pattern'i)
#
# Tier 2: Apple preferences private API kullanılır; macOS sürüm
# değişimlerinde bozulabilir. AppleScript GUI scripting alternatifi
# fragile, defaults yolu daha sağlam.

set -u

on=true
duration_sec=0

while [ $# -gt 0 ]; do
  case "$1" in
    --on)          on="$2"; shift 2 ;;
    --durationSec) duration_sec="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$duration_sec" -lt 0 ]; then duration_sec=0; fi
if [ "$duration_sec" -gt 3600 ]; then duration_sec=3600; fi

apply_grayscale() {
  local target_on="$1"
  if [ "$target_on" = "true" ]; then
    defaults write com.apple.universalaccess grayscale -bool true 2>/dev/null
    defaults write com.apple.universalaccess colorFilterEnabled -bool true 2>/dev/null
  else
    defaults write com.apple.universalaccess grayscale -bool false 2>/dev/null
    defaults write com.apple.universalaccess colorFilterEnabled -bool false 2>/dev/null
  fi
  # universalAccessd'i restart et — preferences cache'i yenilenir,
  # değişiklik anında uygulanır. Bu komut sudo gerektirmez (user
  # ownership'ında daemon).
  killall universalAccessd 2>/dev/null
  killall cfprefsd 2>/dev/null
}

current=$(defaults read com.apple.universalaccess grayscale 2>/dev/null || echo "0")

if [ "$on" = "true" ]; then
  target=1
else
  target=0
fi

if [ "$current" = "$target" ] && [ "$duration_sec" = "0" ]; then
  echo "already $target (no change)"
  exit 0
fi

apply_grayscale "$on"
if [ "$on" = "true" ]; then
  echo "enabled"
else
  echo "disabled"
fi

# Auto-revert mode
if [ "$on" = "true" ] && [ "$duration_sec" -gt 0 ]; then
  echo "auto-revert: ${duration_sec}s sonra renge dönecek"
  sleep "$duration_sec"
  apply_grayscale "false"
  echo "revert: renge döndü"
fi

exit 0
