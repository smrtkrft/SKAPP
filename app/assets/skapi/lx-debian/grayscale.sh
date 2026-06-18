#!/usr/bin/env bash
# grayscale.sh
# SKAPI lx-debian Visual Break
# Toggles a desktop-wide grayscale filter. GNOME exposes it via the
# org.gnome.desktop.a11y.magnifier color-saturation key (0.0 = grayscale,
# 1.0 = full color), no extension needed once magnifier-enabled is true.
# KDE/XFCE have no equivalent system path; this script returns exit 3
# on those DEs so the user sees the boundary instead of a silent no-op.

set -u

on="true"
while [ $# -gt 0 ]; do
  case "$1" in
    --on) on="$2"; shift 2 ;;
    *) shift ;;
  esac
done

de="${XDG_CURRENT_DESKTOP:-}"
case "$de" in
  *GNOME*|*Unity*)
    if ! command -v gsettings >/dev/null 2>&1; then
      echo "gsettings not available." >&2
      exit 2
    fi
    schema="org.gnome.desktop.a11y.magnifier"
    if [ "$on" = "true" ]; then
      gsettings set "$schema" color-saturation 0.0
      gsettings set org.gnome.desktop.a11y.applications screen-magnifier-enabled true
      echo "enabled"
    else
      gsettings set "$schema" color-saturation 1.0
      gsettings set org.gnome.desktop.a11y.applications screen-magnifier-enabled false
      echo "disabled"
    fi
    ;;
  *)
    echo "Grayscale toggle not wired for desktop '$de'. GNOME-only at tier 2." >&2
    exit 3
    ;;
esac
