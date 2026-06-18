# minimize-window.ps1
# SKAPI WIN Window & App
# Minimises a specific window picked by process name. The first matching
# main window is targeted; pass an empty `processName` to minimise the
# currently focused window instead.

param(
  [string]$processName = ""
)

Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class W {
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int cmd);
  }
"@

$SW_MINIMIZE = 6

if ([string]::IsNullOrWhiteSpace($processName)) {
  $hwnd = [W]::GetForegroundWindow()
  if ($hwnd -eq [IntPtr]::Zero) {
    Write-Error "No foreground window found."
    exit 2
  }
  [W]::ShowWindow($hwnd, $SW_MINIMIZE) | Out-Null
  Write-Output "Minimised foreground window"
  return
}

$proc = Get-Process -Name $processName -ErrorAction SilentlyContinue |
        Where-Object { $_.MainWindowHandle -ne 0 } |
        Select-Object -First 1
if (-not $proc) {
  Write-Error "No window for process '$processName'."
  exit 3
}
[W]::ShowWindow($proc.MainWindowHandle, $SW_MINIMIZE) | Out-Null
Write-Output "Minimised: $processName (pid $($proc.Id))"
