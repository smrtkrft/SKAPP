# save-active-window.ps1
# SKAPI · WIN · Save Work
# Sends Ctrl+S to the active window.

param(
  [int]$timeout = 2,
  [bool]$verbose = $true
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  using System.Text;
  public class W {
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
  }
"@

$hwnd = [W]::GetForegroundWindow()
if ($verbose) {
  $sb = New-Object System.Text.StringBuilder 256
  [W]::GetWindowText($hwnd, $sb, 256) | Out-Null
  Write-Output "Target window: $($sb.ToString())"
}

[System.Windows.Forms.SendKeys]::SendWait("^s")
Start-Sleep -Seconds $timeout
Write-Output "OK"
