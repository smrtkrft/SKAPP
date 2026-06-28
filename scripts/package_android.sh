#!/usr/bin/env bash
# SKAPP Android paketleme: release keystore ile imzalı universal APK.
# Önkoşul: app/android/key.properties + skapp-release.jks (docs/ANDROID_SIGNING.md).
# key.properties yoksa build debug ile imzalanır (dağıtım için DEĞİL).
set -euo pipefail
cd "$(dirname "$0")/../app"

OUT="${1:-$(cd .. && pwd)/dist}"
mkdir -p "$OUT"

flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk "$OUT/SKAPP-android.apk"
echo "OK → $OUT/SKAPP-android.apk"
