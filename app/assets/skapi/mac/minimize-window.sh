#!/bin/bash
# minimize-window.sh
# SKAPI MAC Window & App
# Belirli bir uygulamanın ön plandaki penceresini minimize eder (Dock'a
# indirir). processName boş ise frontmost app'in penceresi minimize
# edilir. AppleScript Accessibility izni gerektirir.
#
# Tier 2: Cmd+M keystroke kullanılır (System Events). Bazı app'ler
# Cmd+M'yi yakalamayabilir (full-screen mode'da olanlar gibi); o
# durumda no-op olur ve script "OK" döner.

set -u

process_name=""

while [ $# -gt 0 ]; do
  case "$1" in
    --processName) process_name="$2"; shift 2 ;;
    *) shift ;;
  esac
done

escape_as() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

if [ -z "$process_name" ]; then
  # Foreground window minimize.
  osascript -e 'tell application "System Events" to keystroke "m" using {command down}' 2>/dev/null
  echo "Minimised foreground window"
  exit 0
fi

esc_name=$(escape_as "$process_name")

# AppleScript ile target app'i activate edip Cmd+M gönder. Process listede
# yoksa exit 3. activate edemezse "no window" durumudur.
osascript <<EOF 2>/dev/null
tell application "System Events"
  if exists (processes whose name is "$esc_name") then
    tell application "$esc_name" to activate
    delay 0.15
    keystroke "m" using {command down}
  else
    error "no process" number 3
  end if
end tell
EOF

ec=$?
if [ $ec -ne 0 ]; then
  echo "No window for process '$process_name'." >&2
  exit 3
fi

echo "Minimised: $process_name"
exit 0
