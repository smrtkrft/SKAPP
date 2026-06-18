# lock.ps1
# SKAPI WIN Power Management
# Locks the workstation immediately. Returns the user to the sign-in screen.

Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class L {
    [DllImport("user32.dll")] public static extern bool LockWorkStation();
  }
"@

[L]::LockWorkStation() | Out-Null
Write-Output "OK"
