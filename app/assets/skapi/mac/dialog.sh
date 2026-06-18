#!/bin/bash
# dialog.sh
# SKAPI MAC Notify
# İki sunum modu (Windows dialog.ps1 ile semantik denkliği):
#
#   1) fullscreen=false (default): osascript "display dialog" ile modal
#      buton dialog'u. Buton seçimine göre "ok / cancel / yes / no /
#      timeout" stdout'a basılır. AppleScript timeout doğal desteklenir.
#
#   2) fullscreen=true: AppleScript ile fullscreen, borderless, ön planda
#      Cocoa pencere. Display Dialog'da kasıtlı timeout var, kullanıcının
#      kaçma yolu yok (Cmd+Q hariç). Geri sayım belirir, bitince kapanır.
#      Always "timeout" döner.
#
# Yetki notu: ilk çalıştırmada macOS Accessibility izni isteyebilir
# (System Events ya da GUI scripting kullanımıyla). Kullanıcı manuel
# onay vermeli.

set -u

title="SKAPP"
body=""
buttons="ok_cancel"
timeout_secs=0
fullscreen=false

while [ $# -gt 0 ]; do
  case "$1" in
    --title)      title="$2"; shift 2 ;;
    --body)       body="$2"; shift 2 ;;
    --buttons)    buttons="$2"; shift 2 ;;
    --timeout)    timeout_secs="$2"; shift 2 ;;
    --fullscreen) fullscreen="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# Fullscreen + zero timeout = kullanıcı kilitlenir, default ver.
if [ "$fullscreen" = "true" ] && [ "$timeout_secs" -le 0 ]; then
  timeout_secs=60
fi

escape_as() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

esc_title=$(escape_as "$title")
esc_body=$(escape_as "$body")

# ============================================================
# Fullscreen branch — borderless overlay window with countdown.
# ============================================================
if [ "$fullscreen" = "true" ]; then
  # AppleScript ile fullscreen Cocoa overlay. NSWindow level kFloat,
  # styleMask borderless, alpha 1.0, siyah arka plan. Geri sayım her
  # saniye güncellenir, sıfırlanınca pencere kapanır.
  osascript <<EOF 2>/dev/null
use framework "AppKit"
use framework "Foundation"
use scripting additions

set endTime to (current date) + $timeout_secs

set screenFrame to (current application's NSScreen's mainScreen()'s frame())
set winRect to current application's NSMakeRect(0, 0, item 1 of item 2 of screenFrame, item 2 of item 2 of screenFrame)

set styleMask to (current application's NSWindowStyleMaskBorderless)
set win to (current application's NSWindow's alloc()'s initWithContentRect:winRect styleMask:styleMask backing:(current application's NSBackingStoreBuffered) defer:false)
win's setLevel:(current application's NSScreenSaverWindowLevel)
win's setOpaque:false
win's setBackgroundColor:(current application's NSColor's colorWithCalibratedRed:0.04 green:0.04 blue:0.04 alpha:1.0)
win's setIgnoresMouseEvents:true
win's makeKeyAndOrderFront:(missing value)

set titleField to current application's NSTextField's alloc()'s initWithFrame:(current application's NSMakeRect(0, (item 2 of item 2 of screenFrame) * 0.55, item 1 of item 2 of screenFrame, 80))
titleField's setStringValue:"$esc_title"
titleField's setAlignment:(current application's NSTextAlignmentCenter)
titleField's setBezeled:false
titleField's setDrawsBackground:false
titleField's setEditable:false
titleField's setSelectable:false
titleField's setTextColor:(current application's NSColor's colorWithCalibratedRed:0.96 green:0.95 blue:0.93 alpha:1.0)
titleField's setFont:(current application's NSFont's boldSystemFontOfSize:56)
(win's contentView())'s addSubview:titleField

set bodyField to current application's NSTextField's alloc()'s initWithFrame:(current application's NSMakeRect((item 1 of item 2 of screenFrame) * 0.1, (item 2 of item 2 of screenFrame) * 0.40, (item 1 of item 2 of screenFrame) * 0.8, 100))
bodyField's setStringValue:"$esc_body"
bodyField's setAlignment:(current application's NSTextAlignmentCenter)
bodyField's setBezeled:false
bodyField's setDrawsBackground:false
bodyField's setEditable:false
bodyField's setSelectable:false
bodyField's setTextColor:(current application's NSColor's colorWithCalibratedRed:0.96 green:0.95 blue:0.93 alpha:0.82)
bodyField's setFont:(current application's NSFont's systemFontOfSize:28)
(win's contentView())'s addSubview:bodyField

set cdField to current application's NSTextField's alloc()'s initWithFrame:(current application's NSMakeRect(0, (item 2 of item 2 of screenFrame) * 0.20, item 1 of item 2 of screenFrame, 120))
cdField's setAlignment:(current application's NSTextAlignmentCenter)
cdField's setBezeled:false
cdField's setDrawsBackground:false
cdField's setEditable:false
cdField's setSelectable:false
cdField's setTextColor:(current application's NSColor's colorWithCalibratedRed:0.83 green:0.63 blue:0.09 alpha:1.0)
cdField's setFont:(current application's NSFont's boldSystemFontOfSize:96)
(win's contentView())'s addSubview:cdField

repeat
  set remaining to (endTime - (current date)) as integer
  if remaining is less than 0 then set remaining to 0
  set mins to remaining div 60
  set secs to remaining mod 60
  set cdText to (text -2 thru -1 of ("0" & mins)) & ":" & (text -2 thru -1 of ("0" & secs))
  cdField's setStringValue:cdText
  if remaining is 0 then exit repeat
  delay 0.25
end repeat

win's close()
EOF
  echo "timeout"
  exit 0
fi

# ============================================================
# Classic MessageBox path — display dialog with timeout support.
# ============================================================

# AppleScript button → SKAPP semantic map. Set "buttons list" + "default
# button" + "cancel button" indirectly via giving up after timeout.
case "$buttons" in
  "ok")
    btn_list='{"OK"}'
    default_btn='"OK"'
    cancel_btn=''
    ;;
  "yes_no")
    btn_list='{"No", "Yes"}'
    default_btn='"Yes"'
    cancel_btn='cancel button "No"'
    ;;
  "yes_no_cancel")
    btn_list='{"Cancel", "No", "Yes"}'
    default_btn='"Yes"'
    cancel_btn='cancel button "Cancel"'
    ;;
  *)
    # ok_cancel veya bilinmeyen değer → güvenli default
    btn_list='{"Cancel", "OK"}'
    default_btn='"OK"'
    cancel_btn='cancel button "Cancel"'
    ;;
esac

# Timeout 0 ise giving up satırı eklenmez; >0 ise saniye sonra timeout.
giving_up_clause=""
if [ "$timeout_secs" -gt 0 ]; then
  giving_up_clause="giving up after $timeout_secs"
fi

# Compose AppleScript. cancel_btn boş olabilir; tek ifade.
script="
set theResult to display dialog \"$esc_body\" with title \"$esc_title\" buttons $btn_list default button $default_btn $cancel_btn $giving_up_clause
return theResult
"

# osascript output: "button returned:OK, gave up:false" gibi record.
# Cancel button basıldığında AppleScript exception atar (-128) → kontrolü
# stderr'den + exit code üzerinden yapacağız.
raw=$(osascript -e "$script" 2>&1)
exit_code=$?

if [ $exit_code -ne 0 ]; then
  # -128 user cancelled. Diğer kodlar parse error / system error.
  if echo "$raw" | grep -q "User canceled"; then
    echo "cancel"
    exit 0
  fi
  # Genel hata — script formatı bozulduysa.
  echo "error: $raw" >&2
  exit 1
fi

# raw örnek: "button returned:OK, gave up:false"
if echo "$raw" | grep -q "gave up:true"; then
  echo "timeout"
  exit 0
fi

# Parse: "button returned:X, gave up:false" → X'i çek.
pressed=$(echo "$raw" | sed -n 's/.*button returned:\([^,]*\).*/\1/p')

case "$pressed" in
  "OK")     echo "ok" ;;
  "Cancel") echo "cancel" ;;
  "Yes")    echo "yes" ;;
  "No")     echo "no" ;;
  *)        echo "$(echo "$pressed" | tr '[:upper:]' '[:lower:]')" ;;
esac

exit 0
