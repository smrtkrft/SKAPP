#!/usr/bin/env bash
# dialog.sh
# SKAPI lx-debian Notify
# Modal dialog via zenity (GNOME/GTK) with kdialog (KDE) fallback. Maps
# user choice to a stable string on stdout: ok / cancel / yes / no /
# timeout. Callers branch on the value, mirroring the WIN MessageBox
# wrapper.

set -u

title="SKAPP"
body=""
buttons="ok_cancel"
timeout=0
while [ $# -gt 0 ]; do
  case "$1" in
    --title) title="$2"; shift 2 ;;
    --body) body="$2"; shift 2 ;;
    --buttons) buttons="$2"; shift 2 ;;
    --timeout) timeout="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# Pick the dialog backend.
if command -v zenity >/dev/null 2>&1; then
  backend="zenity"
elif command -v kdialog >/dev/null 2>&1; then
  backend="kdialog"
else
  echo "No dialog tool. sudo apt install zenity (or kdialog)." >&2
  exit 2
fi

zenity_args=(--title "$title" --text "$body")
[ "$timeout" -gt 0 ] && zenity_args+=(--timeout "$timeout")

# Zenity exit codes: 0=affirmative, 1=cancel/no, 5=timeout.
case "$buttons" in
  ok)
    if [ "$backend" = "zenity" ]; then
      zenity --info "${zenity_args[@]}" >/dev/null 2>&1
      ec=$?
    else
      kdialog --title "$title" --msgbox "$body"
      ec=$?
    fi
    if [ "$ec" -eq 5 ]; then echo "timeout"; else echo "ok"; fi
    ;;
  ok_cancel)
    if [ "$backend" = "zenity" ]; then
      zenity --question --ok-label="OK" --cancel-label="Cancel" "${zenity_args[@]}"
      ec=$?
    else
      kdialog --title "$title" --warningcontinuecancel "$body"
      ec=$?
    fi
    case "$ec" in
      0) echo "ok" ;;
      5) echo "timeout" ;;
      *) echo "cancel" ;;
    esac
    ;;
  yes_no)
    if [ "$backend" = "zenity" ]; then
      zenity --question "${zenity_args[@]}"
      ec=$?
    else
      kdialog --title "$title" --yesno "$body"
      ec=$?
    fi
    case "$ec" in
      0) echo "yes" ;;
      5) echo "timeout" ;;
      *) echo "no" ;;
    esac
    ;;
  yes_no_cancel)
    if [ "$backend" = "zenity" ]; then
      # Three-button via custom labels; cancel maps to a non-standard exit.
      zenity --question --ok-label="Yes" --extra-button="No" --cancel-label="Cancel" "${zenity_args[@]}"
      ec=$?
      if [ "$ec" -eq 0 ]; then echo "yes"
      elif [ "$ec" -eq 5 ]; then echo "timeout"
      else echo "cancel"; fi
    else
      kdialog --title "$title" --yesnocancel "$body"
      ec=$?
      case "$ec" in
        0) echo "yes" ;;
        1) echo "no" ;;
        *) echo "cancel" ;;
      esac
    fi
    ;;
  *)
    echo "Unknown buttons: $buttons" >&2
    exit 2
    ;;
esac
