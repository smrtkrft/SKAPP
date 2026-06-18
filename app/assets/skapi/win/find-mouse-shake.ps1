# find-mouse-shake.ps1
# SKAPI WIN Visual Break
# Wiggles the mouse cursor in a small circle to draw the user's eye to
# its position. Useful on multi-monitor / 4K setups where the cursor is
# easy to lose. Tier 2: SetCursorPos can be blocked by accessibility
# software; behaviour also varies under remote-desktop sessions.

param(
  [int]$radius = 60,
  [int]$loops = 3
)

if ($radius -lt 5) { $radius = 5 }
if ($radius -gt 200) { $radius = 200 }
if ($loops -lt 1) { $loops = 1 }
if ($loops -gt 10) { $loops = 10 }

Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public struct PT { public int X; public int Y; }
  public class M {
    [DllImport("user32.dll")] public static extern bool GetCursorPos(out PT p);
    [DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
  }
"@

$origin = New-Object PT
[M]::GetCursorPos([ref]$origin) | Out-Null

$steps = 36
for ($l = 0; $l -lt $loops; $l++) {
  for ($s = 0; $s -lt $steps; $s++) {
    $angle = (2 * [Math]::PI) * ($s / $steps)
    $x = $origin.X + [int]([Math]::Cos($angle) * $radius)
    $y = $origin.Y + [int]([Math]::Sin($angle) * $radius)
    [M]::SetCursorPos($x, $y) | Out-Null
    Start-Sleep -Milliseconds 12
  }
}
[M]::SetCursorPos($origin.X, $origin.Y) | Out-Null
Write-Output "OK"
