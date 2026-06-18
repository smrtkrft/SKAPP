#!/bin/bash
# media-key.sh
# SKAPI MAC Display & Audio
# Media key gönderir (play-pause / next / previous / stop). macOS'ta
# tek bir merkezi MPRIS-benzeri abstraksiyon yok; iki yaklaşım var:
#
#   1) AppleScript per-app: `tell app "Music" to playpause` — yalnız
#      o uygulamaya etki eder, hangi uygulamanın foreground'da
#      olduğunu önemsemez. Ama her uygulama (Spotify, VLC) ayrı dil
#      kullanır.
#   2) HID Apple Event ile virtual media key (NSEvent + private API) —
#      hangi app foreground'sa o yakalar. AppleScript ile değil,
#      Swift binary gerektirir. Tier 3.
#
# Pratik seçim: yaklaşım (1). Music + Spotify + VLC için sırayla dener,
# ilk başarılı olanı durur. Çalışan player yoksa toplam no-op + verbose.
# Diğer player'lar (TIDAL, Apple Podcasts) eklenmemiş, manifest update
# ile genişler. Tier 2.

set -u

key="play-pause"

while [ $# -gt 0 ]; do
  case "$1" in
    --key) key="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# Normalize key alias'larını AppleScript komutuna çevir.
case "$(echo "$key" | tr '[:upper:]' '[:lower:]')" in
  play-pause|playpause|play|pause) as_cmd="playpause" ;;
  next)               as_cmd="next track" ;;
  prev|previous)      as_cmd="previous track" ;;
  stop)               as_cmd="stop" ;;
  *)
    echo "Unknown media key: $key (use play-pause | next | previous | stop)" >&2
    exit 2
    ;;
esac

# Player'ları sırayla dene; çalışan ilk app komutu alır.
tried_any=false
for app in "Music" "Spotify" "VLC" "QuickTime Player"; do
  # is_running kontrolü: process listesinde varsa dene.
  if pgrep -ix "$app" >/dev/null 2>&1; then
    tried_any=true
    osascript -e "tell application \"$app\" to $as_cmd" 2>/dev/null && {
      echo "media key sent to $app: $key"
      exit 0
    }
  fi
done

if [ "$tried_any" = "false" ]; then
  echo "No supported media player running (Music/Spotify/VLC/QuickTime)" >&2
  exit 3
fi

echo "media key delivered but no app accepted it cleanly: $key"
exit 0
