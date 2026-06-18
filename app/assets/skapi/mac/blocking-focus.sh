#!/bin/bash
# blocking-focus.sh
# SKAPI MAC Visual Break
# Composite "focus enforcer". Üç aşama (Win blocking-focus ile birebir):
#
#   1) SAVE PHASE   → enableSave=true ise Pages / Numbers / Keynote ve
#                     VS Code için AppleScript ile save'i tetikler.
#   2) MOUSE SHAKE  → arka planda python loop, imleci radius pikselinde
#                     daireler çizdirir; countdown sırasında durmaz.
#   3) FULLSCREEN   → blur-timed pattern'inin yoğun versiyonu: siyah
#                     borderless overlay, ortada "Blocking Focus" başlığı
#                     + dev countdown. Esc/Cmd+Q ile kaçış mümkündür
#                     (soft mode, strict mode global key hook gerektirir).
#
# Tier 2: pyobjc + AppKit. find-mouse-shake ve blur-timed ile aynı
# bağımlılık. Mac güvenlik açısından bu üçlü kompozit'i tek script'te
# çalıştırırsak Accessibility izni bir kerelik alınmış olur.

set -u

duration=100
title="Blocking Focus"
shake_radius=300
enable_save=true

while [ $# -gt 0 ]; do
  case "$1" in
    --duration)    duration="$2"; shift 2 ;;
    --title)       title="$2"; shift 2 ;;
    --shakeRadius) shake_radius="$2"; shift 2 ;;
    --enableSave)  enable_save="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$duration" -lt 10 ]; then duration=10; fi
if [ "$duration" -gt 600 ]; then duration=600; fi
if [ "$shake_radius" -lt 50 ]; then shake_radius=50; fi
if [ "$shake_radius" -gt 800 ]; then shake_radius=800; fi

# ============================================================
# Phase 1 — Save (osascript per-app)
# ============================================================
if [ "$enable_save" = "true" ]; then
  # Pages, Numbers, Keynote — AppleScript ile "save (every document)"
  for app in "Pages" "Numbers" "Keynote"; do
    if pgrep -ix "$app" >/dev/null 2>&1; then
      osascript -e "tell application \"$app\" to save (every document)" 2>/dev/null && \
        echo "Saved $app"
    fi
  done

  # VS Code CLI
  if command -v code >/dev/null 2>&1; then
    if pgrep -ix "Code" >/dev/null 2>&1 || pgrep -ix "Visual Studio Code" >/dev/null 2>&1; then
      code -r --command workbench.action.files.saveAll >/dev/null 2>&1
      echo "Saved VS Code"
    fi
  fi
fi

# ============================================================
# Phase 2 + 3 — Mouse shake (background) + fullscreen overlay
# ============================================================
if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 not found (install Xcode Command Line Tools)." >&2
  exit 2
fi

esc_title=$(printf '%s' "$title" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g')

python3 - "$duration" "$shake_radius" "$esc_title" <<'PY'
import sys, math, time, threading
try:
    from AppKit import (
        NSApplication, NSWindow, NSColor, NSTextField, NSFont, NSScreen,
        NSWindowStyleMaskBorderless, NSBackingStoreBuffered,
    )
    from Foundation import NSMakeRect
    from Quartz import (
        CGEventCreateMouseEvent, CGEventPost, kCGEventMouseMoved,
        kCGHIDEventTap, kCGMouseButtonLeft, CGEventGetLocation, CGEventCreate,
    )
except ImportError:
    print("AppKit/Quartz not available (need pyobjc; install Xcode CLT + pyobjc).", file=sys.stderr)
    sys.exit(2)

duration = int(sys.argv[1])
shake_radius = int(sys.argv[2])
title = sys.argv[3]

# Origin cursor position
ev = CGEventCreate(None)
loc = CGEventGetLocation(ev)
origin_x, origin_y = loc.x, loc.y

stop_flag = {"stop": False}

def shake_loop():
    steps = 36
    while not stop_flag["stop"]:
        for s in range(steps):
            if stop_flag["stop"]:
                break
            angle = 2 * math.pi * s / steps
            x = origin_x + shake_radius * math.cos(angle)
            y = origin_y + shake_radius * math.sin(angle)
            move = CGEventCreateMouseEvent(None, kCGEventMouseMoved, (x, y), kCGMouseButtonLeft)
            CGEventPost(kCGHIDEventTap, move)
            time.sleep(0.012)

shake_thread = threading.Thread(target=shake_loop, daemon=True)
shake_thread.start()

# Fullscreen overlay (Cocoa)
app = NSApplication.sharedApplication()
screen = NSScreen.mainScreen().frame()
window = NSWindow.alloc().initWithContentRect_styleMask_backing_defer_(
    screen, NSWindowStyleMaskBorderless, NSBackingStoreBuffered, False
)
window.setLevel_(1000)  # ScreenSaver level
window.setOpaque_(False)
window.setIgnoresMouseEvents_(True)
window.setBackgroundColor_(NSColor.colorWithCalibratedRed_green_blue_alpha_(0.04, 0.04, 0.04, 1.0))
window.makeKeyAndOrderFront_(None)

w, h = screen.size.width, screen.size.height

title_label = NSTextField.alloc().initWithFrame_(NSMakeRect(0, h * 0.55, w, 100))
title_label.setBezeled_(False); title_label.setDrawsBackground_(False)
title_label.setEditable_(False); title_label.setSelectable_(False)
title_label.setAlignment_(2)
title_label.setTextColor_(NSColor.colorWithCalibratedRed_green_blue_alpha_(0.96, 0.95, 0.93, 1.0))
title_label.setFont_(NSFont.boldSystemFontOfSize_(56))
title_label.setStringValue_(title)
window.contentView().addSubview_(title_label)

cd_label = NSTextField.alloc().initWithFrame_(NSMakeRect(0, h * 0.30, w, 160))
cd_label.setBezeled_(False); cd_label.setDrawsBackground_(False)
cd_label.setEditable_(False); cd_label.setSelectable_(False)
cd_label.setAlignment_(2)
cd_label.setTextColor_(NSColor.colorWithCalibratedRed_green_blue_alpha_(0.83, 0.63, 0.09, 1.0))
cd_label.setFont_(NSFont.boldSystemFontOfSize_(96))
window.contentView().addSubview_(cd_label)

end = time.time() + duration
try:
    while time.time() < end:
        rem = int(max(0, end - time.time()))
        mins, secs = divmod(rem, 60)
        cd_label.setStringValue_("{:02d}:{:02d}".format(mins, secs))
        while True:
            evt = NSApplication.sharedApplication().nextEventMatchingMask_untilDate_inMode_dequeue_(
                0xFFFFFFFFFFFFFFFF, None, "kCFRunLoopDefaultMode", True
            )
            if evt is None:
                break
        time.sleep(0.25)
finally:
    stop_flag["stop"] = True
    shake_thread.join(timeout=0.5)
    # Restore cursor
    move = CGEventCreateMouseEvent(None, kCGEventMouseMoved, (origin_x, origin_y), kCGMouseButtonLeft)
    CGEventPost(kCGHIDEventTap, move)
    window.close()

print("OK")
PY

exit 0
