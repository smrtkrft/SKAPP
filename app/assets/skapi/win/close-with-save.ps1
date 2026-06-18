# close-with-save.ps1
# SKAPI WIN Programs
# Sends Ctrl+S to the target window (so the app's save dialog runs),
# waits a short beat, then sends WM_CLOSE for a graceful shutdown.
# Tier 2: SendKeys is keyboard-layout sensitive and only "save"
# semantics behave predictably; chat / web apps may interpret Ctrl+S
# as something else.

param(
  [string]$processName = "",
  [int]$wait = 1
)

if ([string]::IsNullOrWhiteSpace($processName)) {
  Write-Error "processName is required."
  exit 2
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class W {
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
      public static extern IntPtr SendMessage(IntPtr h, uint msg, IntPtr w, IntPtr l);
  }
"@

$WM_CLOSE = 0x0010
$procs = Get-Process -Name $processName -ErrorAction SilentlyContinue |
         Where-Object { $_.MainWindowHandle -ne 0 }
if (-not $procs) {
  Write-Output "No running instance of '$processName'."
  exit 0
}

foreach ($p in $procs) {
  [W]::SetForegroundWindow($p.MainWindowHandle) | Out-Null
  Start-Sleep -Milliseconds 200
  [System.Windows.Forms.SendKeys]::SendWait("^s")
  Start-Sleep -Seconds $wait
  [W]::SendMessage($p.MainWindowHandle, $WM_CLOSE, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null
  Write-Output "Save+close: $processName (pid $($p.Id))"
}
