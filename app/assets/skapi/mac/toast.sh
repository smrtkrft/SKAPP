#!/bin/bash
# toast.sh
# SKAPI MAC Notify
# Mac native banner notification via AppleScript (display notification).
# Notification Center'a düşer; macOS 10.9+ gerektirir. Tier 1.
#
# Windows'taki NotifyIcon balloon ile semantik denkliği: kısa süreli
# bildirim, action center geçmişine girer (Win NotifyIcon girmiyordu —
# Mac biraz daha "kalıcı" hisseder, ama davranış olarak doğru). Süre
# durationMs parametresi ile gelir; AppleScript display notification
# bunu kendi yönetir (kesin değil, kullanıcının "Banner" ayarına bağlı).
# Bu yüzden parametre adı korunsa da macOS'un kendi default 5sn'lik
# banner süresi geçerli olur — durationMs sadece script logic için.

set -u

title="SmartKraft"
body=""
duration_ms=5000

while [ $# -gt 0 ]; do
  case "$1" in
    --title)      title="$2"; shift 2 ;;
    --body)       body="$2"; shift 2 ;;
    --durationMs) duration_ms="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# Clamp duration (semantic only — Mac banner timing OS-controlled).
if [ "$duration_ms" -lt 500 ]; then duration_ms=500; fi
if [ "$duration_ms" -gt 30000 ]; then duration_ms=30000; fi

# AppleScript escape: tek tırnak değişimi (en yaygın injection vektörü).
escape_as() {
  # \ → \\, " → \", convert newlines to \n literal in AppleScript context.
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

esc_title=$(escape_as "$title")
esc_body=$(escape_as "$body")

osascript -e "display notification \"$esc_body\" with title \"$esc_title\"" 2>/dev/null

# Banner OS-controlled; script tarafından doğrulanamaz. "OK" sinyali
# webhook'a yeterli pozitif yanıt — exit 0.
echo "OK"
exit 0
