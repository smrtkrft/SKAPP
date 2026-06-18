#!/bin/bash
# brightness.sh
# SKAPI MAC Display & Audio
# Internal display brightness'i 0-100 aralığında ayarlar. macOS'ta üç yol:
#
#   1) `brightness` CLI (homebrew, `brew install brightness`) — float
#      0.0-1.0 alır, en güvenilir yol. Apple silicon ve Intel'de çalışır.
#   2) `nvram` / `pmset` — okuma destekler ama yazma için sudo gerekir.
#   3) AppleScript "tell application System Events" + GUI scripting —
#      System Settings > Display panelini açar, slider'ı sürükler;
#      fragile, locale-bağımlı, kullanıcı önünde görünür.
#
# Pratik seçim: `brightness` CLI varsa onu kullan, yoksa Tier 2 not
# (homebrew dependency). External monitorlar genelde desteklenmez —
# brightness CLI dahili panel için.

set -u

level=70
# Mac brightness CLI ramp süresi desteklemiyor; timeout parametresi
# Win API'siyle parite için kabul edilir ama davranışı etkilemez.
# Sleep ile post-set bekleme yapmıyoruz, tekrar tetik gelirse iyi olur.

while [ $# -gt 0 ]; do
  case "$1" in
    --level)   level="$2"; shift 2 ;;
    --timeout) shift 2 ;;  # ignored
    *) shift ;;
  esac
done

if [ "$level" -lt 0 ]; then level=0; fi
if [ "$level" -gt 100 ]; then level=100; fi

if ! command -v brightness >/dev/null 2>&1; then
  echo "brightness CLI not found. Install with: brew install brightness" >&2
  exit 2
fi

# brightness CLI float 0.0-1.0 ister, Win parite için 0-100 input'u dönüştür.
fraction=$(awk -v l="$level" 'BEGIN { printf "%.4f", l / 100.0 }')
brightness "$fraction" >/dev/null 2>&1

echo "Set brightness to ${level}%"
exit 0
