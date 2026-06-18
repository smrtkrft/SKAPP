# save-all-open.ps1
# SKAPI · WIN · Save Work
# Cycles through whitelisted apps and tells each to save its open
# documents via Ctrl+S. Final.md spec: focus → Ctrl+S → wait → next;
# restore original foreground at the end so the user is not jolted.
#
# The previous revision sent Ctrl+S without focusing the target app,
# so every keystroke went to whatever happened to have focus when the
# script ran (usually the PowerShell host) — meaning nothing was
# actually saved. Fixed 2026-05-15.
#
# Default whitelist is the set of apps with predictable Ctrl+S =
# "save" semantics. Chat apps (Slack, Discord) and most browsers
# interpret Ctrl+S as something else and are intentionally excluded;
# the caller can override `apps` if they know better for their
# environment.

param(
  [string[]]$apps = @("winword", "excel", "powerpnt", "code", "notepad"),
  [int]$timeoutPerApp = 1,
  [bool]$verbose = $true
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class W {
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
    [DllImport("user32.dll")] public static extern bool IsWindow(IntPtr h);
    [DllImport("user32.dll")] public static extern bool IsIconic(IntPtr h);
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int cmd);
  }
"@

$SW_RESTORE = 9
$originalFg = [W]::GetForegroundWindow()
$saved = 0
$skipped = 0

foreach ($name in $apps) {
  $procs = Get-Process -Name $name -ErrorAction SilentlyContinue
  if (-not $procs) {
    if ($verbose) { Write-Output "Skip: $name (not running)" }
    $skipped++
    continue
  }
  foreach ($p in $procs) {
    if ($p.MainWindowHandle -eq 0) { continue }
    if (-not [W]::IsWindow($p.MainWindowHandle)) { continue }

    # If the window is minimized SetForegroundWindow alone won't unhide
    # it; restore first so the focus call actually brings the app to
    # the front and Ctrl+S reaches it.
    if ([W]::IsIconic($p.MainWindowHandle)) {
      [W]::ShowWindow($p.MainWindowHandle, $SW_RESTORE) | Out-Null
      Start-Sleep -Milliseconds 150
    }

    $focused = [W]::SetForegroundWindow($p.MainWindowHandle)
    if (-not $focused) {
      if ($verbose) { Write-Output "Skip: $name (could not focus pid $($p.Id))" }
      $skipped++
      continue
    }
    # Give the window manager a tick to actually deliver focus before
    # SendKeys fires. Without this, Ctrl+S can race the focus change
    # and end up in the previous foreground window.
    Start-Sleep -Milliseconds 250
    [System.Windows.Forms.SendKeys]::SendWait("^s")
    Start-Sleep -Seconds $timeoutPerApp
    if ($verbose) { Write-Output "Saved: $name (pid $($p.Id))" }
    $saved++
  }
}

# Restore focus to whoever owned the foreground when we started, so
# the user comes back to their original context instead of the last
# Word/Excel window we hopped through.
if ([W]::IsWindow($originalFg)) {
  [W]::SetForegroundWindow($originalFg) | Out-Null
}

Write-Output "OK (saved=$saved skipped=$skipped)"
