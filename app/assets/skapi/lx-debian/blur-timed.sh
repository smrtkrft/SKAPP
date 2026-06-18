#!/usr/bin/env bash
# blur-timed.sh
# SKAPI lx-debian Visual Break
# Win blur-timed paritesi. Gerçek Gaussian blur yerine fullscreen
# semi-transparent solid overlay; "odaklanmak istiyorum ama
# yapamıyorum" friction'ı üretir, gerçek blur compositing'i
# gerektirmez. Python + GTK 3 (python3-gi paketi) ile fullscreen
# borderless transparent window. Geri sayım orta-merkezde.
#
# Tier 2: python3-gi (PyGObject) dependency. Debian'da `sudo apt
# install python3-gi gir1.2-gtk-3.0`. X11 ve Wayland'in ikisinde
# çalışır (GTK abstract eder).

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

op=$(awk -v o="$opacity" 'BEGIN { v = o + 0; if (v < 0) v = 0; if (v > 1) v = 1; printf "%.3f", v }')

if [[ ! "$color" =~ ^#[0-9A-Fa-f]{6}$ ]]; then
  color="#0A0A0A"
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 not found. sudo apt install python3" >&2
  exit 2
fi

python3 - "$duration" "$op" "$color" <<'PY'
import sys, gi
try:
    gi.require_version("Gtk", "3.0")
    from gi.repository import Gtk, GLib, Gdk
except (ImportError, ValueError):
    print("python3-gi (PyGObject) not installed. sudo apt install python3-gi gir1.2-gtk-3.0", file=sys.stderr)
    sys.exit(2)

duration = int(sys.argv[1])
opacity = float(sys.argv[2])
hex_color = sys.argv[3].lstrip("#")
r = int(hex_color[0:2], 16) / 255.0
g = int(hex_color[2:4], 16) / 255.0
b = int(hex_color[4:6], 16) / 255.0

class BlurWindow(Gtk.Window):
    def __init__(self):
        super().__init__()
        self.set_decorated(False)
        self.set_keep_above(True)
        self.set_skip_taskbar_hint(True)
        self.set_skip_pager_hint(True)
        self.fullscreen()

        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual and screen.is_composited():
            self.set_visual(visual)

        self.set_app_paintable(True)
        self.connect("draw", self.on_draw)

        # Countdown label overlay
        self.label = Gtk.Label()
        self.label.set_markup("<span foreground='#D4A017' font='84' weight='bold'>00:00</span>")
        self.label.set_halign(Gtk.Align.CENTER)
        self.label.set_valign(Gtk.Align.CENTER)
        self.add(self.label)

        self.end = duration
        self.tick()
        GLib.timeout_add(250, self.tick)

    def on_draw(self, widget, cr):
        cr.set_source_rgba(r, g, b, opacity)
        cr.set_operator(1)  # CAIRO_OPERATOR_SOURCE
        cr.paint()
        return False

    def tick(self):
        if self.end <= 0:
            Gtk.main_quit()
            return False
        mins, secs = divmod(self.end, 60)
        self.label.set_markup(
            f"<span foreground='#D4A017' font='84' weight='bold'>{mins:02d}:{secs:02d}</span>"
        )
        self.end -= 1
        return True

win = BlurWindow()
win.show_all()
Gtk.main()
print("OK")
PY

exit 0
