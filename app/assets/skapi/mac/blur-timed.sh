#!/bin/bash
# blur-timed.sh
# SKAPI MAC Visual Break
# Win'deki gibi: gerçek Gaussian blur yerine fullscreen semi-transparent
# solid overlay. "Ekrana odaklanamıyorum, mola vermem lazım" friction'ı
# üretir, klasik blur compositing'i gerektirmez.
#
# macOS implementation: Python + Cocoa (NSWindow + NSView). System Python
# AppKit binding'leri olmalı (pyobjc, Xcode CLT ile gelir). Pencere
# borderless, always-on-top, alpha N, click-through (kullanıcı altındaki
# içeriği görebilir ama hafifçe karanlık). Geri sayım orta-merkezde
# 96pt font.
#
# Tier 2: pyobjc dependency + AppKit binding gerekir. Yoksa kullanıcı
# Xcode CLT yüklemek zorunda kalır.

set -u

duration=120
opacity="0.55"
color="#0A0A0A"

while [ $# -gt 0 ]; do
  case "$1" in
    --duration) duration="$2"; shift 2 ;;
    --opacity)  opacity="$2"; shift 2 ;;
    --color)    color="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$duration" -lt 5 ]; then duration=5; fi
if [ "$duration" -gt 600 ]; then duration=600; fi

# Opacity validation, 0.0 - 1.0
op=$(awk -v o="$opacity" 'BEGIN { v = o + 0; if (v < 0) v = 0; if (v > 1) v = 1; printf "%.3f", v }')

# Color validation
if [[ ! "$color" =~ ^#[0-9A-Fa-f]{6}$ ]]; then
  color="#0A0A0A"
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 not found." >&2
  exit 2
fi

python3 - "$duration" "$op" "$color" <<'PY'
import sys, time
try:
    from AppKit import (
        NSApplication, NSWindow, NSColor, NSTextField, NSFont, NSScreen,
        NSWindowStyleMaskBorderless, NSBackingStoreBuffered, NSEvent,
    )
    from Foundation import NSObject, NSMakeRect, NSTimer
except ImportError:
    print("AppKit/pyobjc not available (install with: pip3 install pyobjc).", file=sys.stderr)
    sys.exit(2)

duration = int(sys.argv[1])
opacity = float(sys.argv[2])
color_hex = sys.argv[3].lstrip("#")
r = int(color_hex[0:2], 16) / 255.0
g = int(color_hex[2:4], 16) / 255.0
b = int(color_hex[4:6], 16) / 255.0

app = NSApplication.sharedApplication()
screen = NSScreen.mainScreen().frame()
window = NSWindow.alloc().initWithContentRect_styleMask_backing_defer_(
    screen, NSWindowStyleMaskBorderless, NSBackingStoreBuffered, False
)
window.setLevel_(1000)  # ScreenSaver level
window.setOpaque_(False)
window.setIgnoresMouseEvents_(True)
window.setBackgroundColor_(NSColor.colorWithCalibratedRed_green_blue_alpha_(r, g, b, opacity))
window.makeKeyAndOrderFront_(None)

# Countdown label
w, h = screen.size.width, screen.size.height
label = NSTextField.alloc().initWithFrame_(NSMakeRect(0, h * 0.4, w, 160))
label.setBezeled_(False)
label.setDrawsBackground_(False)
label.setEditable_(False)
label.setSelectable_(False)
label.setAlignment_(2)  # NSTextAlignmentCenter
label.setTextColor_(NSColor.colorWithCalibratedRed_green_blue_alpha_(0.83, 0.63, 0.09, 1.0))
label.setFont_(NSFont.boldSystemFontOfSize_(84))
window.contentView().addSubview_(label)

end = time.time() + duration
while time.time() < end:
    rem = int(max(0, end - time.time()))
    mins, secs = divmod(rem, 60)
    label.setStringValue_("{:02d}:{:02d}".format(mins, secs))
    # Process pending events to keep window responsive
    while True:
        evt = NSApplication.sharedApplication().nextEventMatchingMask_untilDate_inMode_dequeue_(
            0xFFFFFFFFFFFFFFFF, None, "kCFRunLoopDefaultMode", True
        )
        if evt is None:
            break
    time.sleep(0.25)

window.close()
print("OK")
PY

exit 0
