# kill-app.ps1
# SKAPI WIN Window & App
# Force-terminates a process by name. Tries WM_CLOSE first to give the
# app a chance to save; falls back to TerminateProcess after `timeout`
# seconds. No always-on-top warning UI in this tier-2 path; the SKAPP
# action chain editor will compose a dialog + this script for the
# Final.md "with countdown" experience.

param(
  [string]$processName = "",
  [int]$timeout = 5,
  [bool]$preKillSave = $false
)

if ([string]::IsNullOrWhiteSpace($processName)) {
  Write-Error "processName is required."
  exit 2
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class K {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
      public static extern IntPtr SendMessage(IntPtr h, uint msg, IntPtr w, IntPtr l);
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  }
"@

$WM_CLOSE = 0x0010
$procs = Get-Process -Name $processName -ErrorAction SilentlyContinue
if (-not $procs) {
  Write-Output "No process named '$processName' is running."
  exit 0
}

foreach ($p in $procs) {
  if ($preKillSave -and $p.MainWindowHandle -ne 0) {
    [K]::SetForegroundWindow($p.MainWindowHandle) | Out-Null
    [System.Windows.Forms.SendKeys]::SendWait("^s")
    Start-Sleep -Milliseconds 800
  }
  if ($p.MainWindowHandle -ne 0) {
    [K]::SendMessage($p.MainWindowHandle, $WM_CLOSE, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null
  }
}

Start-Sleep -Seconds $timeout

$still = Get-Process -Name $processName -ErrorAction SilentlyContinue
if ($still) {
  foreach ($p in $still) {
    try {
      Stop-Process -Id $p.Id -Force -ErrorAction Stop
      Write-Output "Force-terminated pid $($p.Id)"
    } catch {
      Write-Error "Could not terminate pid $($p.Id): $($_.Exception.Message)"
    }
  }
} else {
  Write-Output "All instances of '$processName' closed gracefully."
}
