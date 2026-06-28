#!/usr/bin/env bash
# SKAPP Linux paketleme: release bundle → AppImage + .deb (imza yok).
set -euo pipefail
cd "$(dirname "$0")/../app"

OUT="${1:-$(cd .. && pwd)/dist}"
mkdir -p "$OUT"
VERSION=$(grep -m1 '^version:' pubspec.yaml | sed 's/version:[[:space:]]*//; s/+.*//')

flutter build linux --release
BUNDLE="build/linux/x64/release/bundle"
[ -d "$BUNDLE" ] || { echo "Build çıktısı yok: $BUNDLE"; exit 1; }

# ---------- AppImage ----------
WORK=$(mktemp -d)
APPDIR="$WORK/SKAPP.AppDir"
mkdir -p "$APPDIR/usr/bin"
cp -r "$BUNDLE/." "$APPDIR/usr/bin/"
install -Dm644 linux/packaging/skapp.desktop "$APPDIR/skapp.desktop"
install -Dm644 linux/packaging/skapp.desktop "$APPDIR/usr/share/applications/skapp.desktop"
cp assets/branding/icon_full.png "$APPDIR/skapp.png"
install -Dm644 assets/branding/icon_full.png \
  "$APPDIR/usr/share/icons/hicolor/256x256/apps/skapp.png"
cat > "$APPDIR/AppRun" <<'EOF'
#!/bin/sh
HERE="$(dirname "$(readlink -f "$0")")"
exec "$HERE/usr/bin/skapp" "$@"
EOF
chmod +x "$APPDIR/AppRun"

if command -v appimagetool >/dev/null 2>&1; then
  APPIMAGETOOL="appimagetool"
else
  echo "appimagetool indiriliyor…"
  curl -fsSL -o "$WORK/appimagetool" \
    "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
  chmod +x "$WORK/appimagetool"
  APPIMAGETOOL="$WORK/appimagetool --appimage-extract-and-run"
fi
ARCH=x86_64 $APPIMAGETOOL "$APPDIR" "$OUT/SKAPP-linux-x86_64.AppImage"

# ---------- .deb ----------
DEB="$WORK/deb"
mkdir -p "$DEB/DEBIAN" "$DEB/opt/skapp" "$DEB/usr/share/applications" \
  "$DEB/usr/share/icons/hicolor/256x256/apps" "$DEB/usr/bin"
cp -r "$BUNDLE/." "$DEB/opt/skapp/"
cp assets/branding/icon_full.png "$DEB/usr/share/icons/hicolor/256x256/apps/skapp.png"
sed 's|Exec=skapp|Exec=/opt/skapp/skapp|' linux/packaging/skapp.desktop \
  > "$DEB/usr/share/applications/skapp.desktop"
ln -s /opt/skapp/skapp "$DEB/usr/bin/skapp"
cat > "$DEB/DEBIAN/control" <<EOF
Package: skapp
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: amd64
Maintainer: SmartKraft <code@smartkraft.ch>
Depends: libgtk-3-0, libsecret-1-0, libayatana-appindicator3-1
Description: SmartKraft device configuration app
 BLE/WiFi cihaz eslestirme, yonetim ve SKAPI script otomasyonu.
EOF
dpkg-deb --build --root-owner-group "$DEB" "$OUT/SKAPP-linux-amd64.deb"

echo "OK → $OUT/SKAPP-linux-x86_64.AppImage"
echo "OK → $OUT/SKAPP-linux-amd64.deb"
