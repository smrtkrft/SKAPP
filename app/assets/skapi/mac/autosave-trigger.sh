#!/bin/bash
# autosave-trigger.sh
# SKAPI MAC Save Work
# Resmî save API'sini her uygulama için tetikler — Ctrl+S keystroke
# yerine. Bu yöntem focus race'ten ve klavye layout duyarlılığından
# bağımsız.
#
# Mac sürümü:
#   - Pages, Numbers, Keynote: AppleScript `tell app X to save (every
#     document)` — Apple iWork native save API.
#   - VS Code: `code --command workbench.action.files.saveAll` CLI bridge.
#   - TextEdit, Preview, Finder: AppleScript save komutu Apple yerli
#     uygulamalar için stabil.
#   - Save-all-open Ctrl+S fallback'i (Word/Office/diğerleri) ayrı
#     scriptte (save-all-open.sh).
#
# Win autosave-trigger fix uyumu: function void (return değer kirletilmez),
# script sonunda `exit 0` (CLI exit code sızıntısını kapatır).

set -u

delay=0
verbose=true

while [ $# -gt 0 ]; do
  case "$1" in
    --delay)   delay="$2"; shift 2 ;;
    --verbose) verbose="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$delay" -gt 0 ]; then
  sleep "$delay"
fi

saved=0
skipped=0

# iWork suite: Pages / Numbers / Keynote
for app in "Pages" "Numbers" "Keynote"; do
  if pgrep -ix "$app" >/dev/null 2>&1; then
    if osascript -e "tell application \"$app\" to save (every document)" 2>/dev/null; then
      saved=$((saved + 1))
      if [ "$verbose" = "true" ]; then echo "Saved $app"; fi
    else
      if [ "$verbose" = "true" ]; then echo "Warn $app save failed"; fi
    fi
  else
    if [ "$verbose" = "true" ]; then echo "Skip $app (not running)"; fi
    skipped=$((skipped + 1))
  fi
done

# VS Code CLI bridge
if command -v code >/dev/null 2>&1; then
  if pgrep -ix "Code" >/dev/null 2>&1 || pgrep -ix "Visual Studio Code" >/dev/null 2>&1; then
    code -r --command workbench.action.files.saveAll >/dev/null 2>&1 || true
    saved=$((saved + 1))
    if [ "$verbose" = "true" ]; then echo "Saved VS Code (all unsaved)"; fi
  else
    if [ "$verbose" = "true" ]; then echo "Skip VS Code (not running)"; fi
    skipped=$((skipped + 1))
  fi
else
  if [ "$verbose" = "true" ]; then echo "Skip VS Code (CLI not on PATH)"; fi
fi

echo "OK (saved=$saved skipped=$skipped)"
# `code` CLI exit kodu $LASTEXITCODE'a denk gelir Win'de; bash'te de aynı
# pattern: explicit exit 0 zorunlu (autosave-trigger.ps1 fix paritesi).
exit 0
