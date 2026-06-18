# toast.ps1
# SKAPI WIN Notify
# Shows a Windows balloon-style notification via `NotifyIcon` (System.
# Windows.Forms). This is older than the WinRT ToastNotificationManager
# path but works reliably on every Windows 10 / 11 build without an
# AppUserModelID registration step — the previous WinRT version was
# Tier 2 because the host AUMID defaulted to "Microsoft.PowerShell" and
# many environments could not load the WinRT types at all. Switched
# 2026-05-15 for "just works" semantics; tier upgraded to 1.
#
# The tradeoff is purely cosmetic: balloon tips appear briefly at the
# bottom-right and don't land in Action Center history. For SKAPP's
# use cases (Blocking Focus break reminder, OTA done, etc.) ephemeral
# is the right behaviour anyway.

param(
  [string]$title = "SmartKraft",
  [string]$body  = "",
  [int]$durationMs = 5000
)

if ($durationMs -lt 500) { $durationMs = 500 }
if ($durationMs -gt 30000) { $durationMs = 30000 }

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$notify = New-Object System.Windows.Forms.NotifyIcon
try {
  # Reuse the host process icon if available, otherwise the generic
  # Information glyph. The icon is what shows in the tray briefly
  # while the balloon is up.
  try {
    $hostPath = (Get-Process -Id $PID).Path
    $notify.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($hostPath)
  } catch {
    $notify.Icon = [System.Drawing.SystemIcons]::Information
  }

  $notify.BalloonTipTitle = $title
  $notify.BalloonTipText  = $body
  $notify.BalloonTipIcon  = [System.Windows.Forms.ToolTipIcon]::Info
  $notify.Visible = $true
  $notify.ShowBalloonTip($durationMs)

  # Hold the tray icon alive long enough for the balloon to actually
  # render. Disposing too early eats the balloon before it appears.
  Start-Sleep -Milliseconds ($durationMs + 200)

  Write-Output "OK"
} finally {
  $notify.Visible = $false
  $notify.Dispose()
}
