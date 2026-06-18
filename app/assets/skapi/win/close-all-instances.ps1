# close-all-instances.ps1
# SKAPI WIN Programs
# Sends WM_CLOSE to every visible window of a given process. Graceful:
# each instance can show its own save dialog. Use kill-app for the
# force-terminate variant.

param(
  [string]$processName = ""
)

if ([string]::IsNullOrWhiteSpace($processName)) {
  Write-Error "processName is required."
  exit 2
}

Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class W {
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

$count = 0
foreach ($p in $procs) {
  [W]::SendMessage($p.MainWindowHandle, $WM_CLOSE, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null
  $count++
}
Write-Output "Sent close to $count instances of $processName"
