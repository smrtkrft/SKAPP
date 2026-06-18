# media-key.ps1
# SKAPI WIN Display & Audio
# Sends a media-key keystroke (play-pause / next / previous / stop).
# Routed by Windows through the System Media Transport Controls (SMTC)
# to whichever app currently owns the media session. Marked tier 2:
# success depends on a media app being foregrounded for the session
# arbiter; if none is, the keystroke is dropped silently.

param(
  [string]$key = "play-pause"
)

$vk = switch ($key.ToLower()) {
  "play-pause" { 0xB3 }   # VK_MEDIA_PLAY_PAUSE
  "playpause"  { 0xB3 }
  "play"       { 0xB3 }
  "pause"      { 0xB3 }
  "next"       { 0xB0 }   # VK_MEDIA_NEXT_TRACK
  "prev"       { 0xB1 }   # VK_MEDIA_PREV_TRACK
  "previous"   { 0xB1 }
  "stop"       { 0xB2 }   # VK_MEDIA_STOP
  default      { 0 }
}

if ($vk -eq 0) {
  Write-Error "Unknown media key: $key (use play-pause | next | previous | stop)"
  exit 2
}

Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class MK {
    [DllImport("user32.dll")] public static extern void keybd_event(byte vk, byte scan, uint flags, UIntPtr extra);
  }
"@

[MK]::keybd_event([byte]$vk, 0, 0, [UIntPtr]::Zero)
[MK]::keybd_event([byte]$vk, 0, 2, [UIntPtr]::Zero)

Write-Output "media key sent: $key"
