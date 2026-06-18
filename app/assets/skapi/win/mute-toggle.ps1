# mute-toggle.ps1
# SKAPI WIN Display & Audio
# Toggles the system master mute. Sends `VK_VOLUME_MUTE` (0xAD) — the
# same virtual key the hardware mute button emits — which Windows
# routes through the audio stack with no admin or COM dependency.
#
# A previous revision accepted a `mode` parameter (toggle/mute/unmute)
# but ignored it: passing `mode=off` still toggled. Misleading UX, so
# the parameter was removed 2026-05-15. If absolute on/off is ever
# needed, wire a separate Core Audio COM script (pattern in
# volume-set.ps1).

Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class MuteSend {
    [DllImport("user32.dll")] public static extern void keybd_event(byte vk, byte scan, uint flags, UIntPtr extra);
  }
"@

# 0xAD = VK_VOLUME_MUTE. Down + up emits a single press.
[MuteSend]::keybd_event(0xAD, 0, 0, [UIntPtr]::Zero)
[MuteSend]::keybd_event(0xAD, 0, 2, [UIntPtr]::Zero)

Write-Output "OK"
