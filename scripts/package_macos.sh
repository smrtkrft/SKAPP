#!/usr/bin/env bash
# SKAPP macOS paketleme: ad-hoc release .app → SKAPP-macos.dmg
# Beta: notarization YOK (Apple Developer $99, 1.0'a ertelendi). Kullanıcı ilk
# açılışta sağ-tık → Aç yapar (release notlarında talimat).
set -euo pipefail
cd "$(dirname "$0")/../app"

OUT="${1:-$(cd .. && pwd)/dist}"
mkdir -p "$OUT"

flutter build macos --release
APP="build/macos/Build/Products/Release/skapp.app"
[ -d "$APP" ] || { echo "Build çıktısı yok: $APP"; exit 1; }

DMG="$OUT/SKAPP-macos.dmg"
rm -f "$DMG"
if command -v create-dmg >/dev/null 2>&1; then
  create-dmg \
    --volname "SKAPP" \
    --window-size 600 320 \
    --icon "skapp.app" 150 150 \
    --app-drop-link 450 150 \
    "$DMG" "$APP" || true
fi
# create-dmg yoksa ya da hata verirse temel DMG'ye düş.
if [ ! -f "$DMG" ]; then
  hdiutil create -volname "SKAPP" -srcfolder "$APP" -ov -format UDZO "$DMG"
fi
echo "OK → $DMG"
