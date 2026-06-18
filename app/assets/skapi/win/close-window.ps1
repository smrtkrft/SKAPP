# close-window.ps1
# SKAPI WIN Window & App
# Sends WM_CLOSE to a window picked by process name. Graceful: the app
# can show its own "save changes?" dialog, identical to the user clicking
# the X button. Empty `processName` targets the currently focused window.

param(
  [string]$processName = ""
)

Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class W {
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
      public static extern IntPtr SendMessage(IntPtr h, uint msg, IntPtr w, IntPtr l);
  }
"@

$WM_CLOSE = 0x0010

if ([string]::IsNullOrWhiteSpace($processName)) {
  $hwnd = [W]::GetForegroundWindow()
  if ($hwnd -eq [IntPtr]::Zero) {
    Write-Error "No foreground window found."
    exit 2
  }
  [W]::SendMessage($hwnd, $WM_CLOSE, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null
  Write-Output "Sent close to foreground window"
  return
}

$proc = Get-Process -Name $processName -ErrorAction SilentlyContinue |
        Where-Object { $_.MainWindowHandle -ne 0 } |
        Select-Object -First 1
if (-not $proc) {
  Write-Error "No window for process '$processName'."
  exit 3
}
[W]::SendMessage($proc.MainWindowHandle, $WM_CLOSE, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null
Write-Output "Sent close: $processName (pid $($proc.Id))"
