#!/bin/bash
# find-mouse-shake.sh
# SKAPI MAC Visual Break
# İmleci küçük bir daire çizecek şekilde hareket ettirip kullanıcıya
# konumu hatırlatır. Multi-monitor / 4K setup'larda imleci kaybeden
# kullanıcılar için. Tier 2: AppleScript ile pointer position kontrolü
# CoreGraphics private API'ye dayanır; Accessibility izni gerektirir.
#
# Yöntem: Python + Quartz framework (macOS ships with /usr/bin/python3
# via Xcode Command Line Tools) ile CGEventCreateMouseEvent. Bu çözüm
# sağlam ve native; alternatif olarak Apple's `cliclick` (homebrew)
# kullanılabilir ama ek dependency.

set -u

radius=60
loops=3

while [ $# -gt 0 ]; do
  case "$1" in
    --radius) radius="$2"; shift 2 ;;
    --loops)  loops="$2"; shift 2 ;;
    *) shift ;;
  esac
done

if [ "$radius" -lt 5 ]; then radius=5; fi
if [ "$radius" -gt 200 ]; then radius=200; fi
if [ "$loops" -lt 1 ]; then loops=1; fi
if [ "$loops" -gt 10 ]; then loops=10; fi

# Python + Quartz ile imleç hareketi. CoreGraphics framework macOS
# system Python'a built-in olarak ulaşılır (Big Sur sonrası
# /usr/bin/python3 ile Xcode CLT yüklü gerekir).
if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 not found (install Xcode Command Line Tools)." >&2
  exit 2
fi

python3 - "$radius" "$loops" <<'PY'
import sys, math, time
try:
    from Quartz import CGEventCreateMouseEvent, CGEventPost, kCGEventMouseMoved, kCGHIDEventTap, kCGMouseButtonLeft, CGEventGetLocation, CGEventCreate
except ImportError:
    print("Quartz framework not available (need pyobjc, install via xcode-select --install).", file=sys.stderr)
    sys.exit(2)

radius = int(sys.argv[1])
loops = int(sys.argv[2])

# Current cursor position
ev = CGEventCreate(None)
loc = CGEventGetLocation(ev)
origin_x, origin_y = loc.x, loc.y

steps = 36
for _ in range(loops):
    for s in range(steps):
        angle = 2 * math.pi * s / steps
        x = origin_x + radius * math.cos(angle)
        y = origin_y + radius * math.sin(angle)
        move = CGEventCreateMouseEvent(None, kCGEventMouseMoved, (x, y), kCGMouseButtonLeft)
        CGEventPost(kCGHIDEventTap, move)
        time.sleep(0.012)

# Restore to origin
move = CGEventCreateMouseEvent(None, kCGEventMouseMoved, (origin_x, origin_y), kCGMouseButtonLeft)
CGEventPost(kCGHIDEventTap, move)
print("OK")
PY

exit 0
