#!/usr/bin/env bash
# blocking-focus.sh
# SKAPI lx-debian Visual Break
# Composite "focus enforcer" — üç aşama:
#   1) SAVE PHASE   → enableSave=true ise LibreOffice (UNO bridge) +
#                     VS Code CLI (workbench.action.files.saveAll)
#   2) MOUSE SHAKE  → xdotool background loop, imleci shakeRadius
#                     pikselinde daireler çizdirir
#   3) FULLSCREEN   → Python + GTK borderless window, "Blocking Focus"
#                     başlığı + countdown
#
# X11 only (xdotool gerektirir, Wayland synthetic mouse motion'u
# protokol seviyesinde bloklar — exit 3).
#
# Tier 2: xdotool + python3-gi dependency. `sudo apt install xdotool
# python3-gi gir1.2-gtk-3.0`.

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

if [ "${XDG_SESSION_TYPE:-x11}" = "wayland" ]; then
  echo "Wayland blocks synthetic mouse motion (xdotool needed for shake)." >&2
  exit 3
fi

if ! command -v xdotool >/dev/null 2>&1; then
  echo "xdotool not installed. sudo apt install xdotool" >&2
  exit 2
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 not found." >&2
  exit 2
fi

# ============================================================
# Phase 1 — Save (LibreOffice + VS Code)
# ============================================================
if [ "$enable_save" = "true" ]; then
  # LibreOffice tüm açık belgeleri kaydet (soffice running and listening
  # on UNO socket is assumed — most Debian setups). Daha sağlam yol:
  # her açık doc'a Ctrl+S xdotool ile gönderme, ama save-all-open.sh
  # zaten o paterni yapar, burada UNO yaklaşımı önerilir.
  if pgrep -ix "soffice.bin" >/dev/null 2>&1; then
    # libreoffice --headless ile bağlanılamaz çünkü mevcut session var.
    # Pragmatik: her açık LibreOffice penceresine Ctrl+S gönder.
    for wid in $(xdotool search --onlyvisible --class "libreoffice" 2>/dev/null); do
      xdotool windowactivate "$wid" 2>/dev/null
      sleep 0.2
      xdotool key --clearmodifiers ctrl+s 2>/dev/null
      echo "Saved LibreOffice window $wid"
    done
  fi

  # VS Code CLI bridge
  if command -v code >/dev/null 2>&1; then
    if pgrep -ix "code" >/dev/null 2>&1; then
      code -r --command workbench.action.files.saveAll >/dev/null 2>&1 || true
      echo "Saved VS Code"
    fi
  fi
fi

# ============================================================
# Phase 2 — Mouse shake (background)
# ============================================================
read -r ox oy < <(xdotool getmouselocation --shell | awk -F= '/^X=/ {x=$2} /^Y=/ {y=$2} END {print x, y}')

shake_stop_file=$(mktemp -t skapp-bf-stop.XXXXXX)
shake_loop() {
  steps=36
  while [ ! -f "$shake_stop_file" ]; do
    s=0
    while [ "$s" -lt "$steps" ]; do
      [ -f "$shake_stop_file" ] && break
      angle=$(awk "BEGIN { print 2 * 3.14159265 * $s / $steps }")
      dx=$(awk "BEGIN { printf \"%d\", cos($angle) * $shake_radius }")
      dy=$(awk "BEGIN { printf \"%d\", sin($angle) * $shake_radius }")
      xdotool mousemove $((ox + dx)) $((oy + dy)) 2>/dev/null
      sleep 0.012
      s=$(( s + 1 ))
    done
  done
}
shake_loop &
shake_pid=$!

cleanup() {
  touch "$shake_stop_file" 2>/dev/null
  sleep 0.1
  kill "$shake_pid" 2>/dev/null
  xdotool mousemove "$ox" "$oy" 2>/dev/null
  rm -f "$shake_stop_file"
}
trap cleanup EXIT INT TERM

# ============================================================
# Phase 3 — Fullscreen GTK overlay with countdown
# ============================================================
esc_title=$(printf '%s' "$title" | sed -e "s/'/\\\\''/g")

python3 - "$duration" "$title" <<'PY'
import sys, gi
try:
    gi.require_version("Gtk", "3.0")
    from gi.repository import Gtk, GLib
except (ImportError, ValueError):
    print("python3-gi not installed.", file=sys.stderr)
    sys.exit(2)

duration = int(sys.argv[1])
title_text = sys.argv[2]

class FocusWindow(Gtk.Window):
    def __init__(self):
        super().__init__()
        self.set_decorated(False)
        self.set_keep_above(True)
        self.set_skip_taskbar_hint(True)
        self.fullscreen()
        self.modify_bg(Gtk.StateType.NORMAL, Gtk.gdk.Color(int(0x0A0A0A * 257 / 257)) if False else None)
        css = Gtk.CssProvider()
        css.load_from_data(b"window { background-color: #0A0A0A; }")
        ctx = self.get_style_context()
        ctx.add_provider(css, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

        vbox = Gtk.VBox(spacing=24)
        vbox.set_halign(Gtk.Align.CENTER)
        vbox.set_valign(Gtk.Align.CENTER)

        self.title_lbl = Gtk.Label()
        self.title_lbl.set_markup(
            f"<span foreground='#F5F2EC' font='56' weight='bold'>{GLib.markup_escape_text(title_text)}</span>"
        )
        vbox.pack_start(self.title_lbl, False, False, 0)

        self.cd_lbl = Gtk.Label()
        self.cd_lbl.set_markup("<span foreground='#D4A017' font='96' weight='bold'>00:00</span>")
        vbox.pack_start(self.cd_lbl, False, False, 0)

        self.add(vbox)
        self.end = duration
        self.update_label()
        GLib.timeout_add(250, self.tick)

    def update_label(self):
        mins, secs = divmod(self.end, 60)
        self.cd_lbl.set_markup(
            f"<span foreground='#D4A017' font='96' weight='bold'>{mins:02d}:{secs:02d}</span>"
        )

    def tick(self):
        if self.end <= 0:
            Gtk.main_quit()
            return False
        self.end -= 1
        self.update_label()
        return True

win = FocusWindow()
win.show_all()
Gtk.main()
PY

echo "OK"
exit 0
