# sleep.ps1
# SKAPI WIN Power Management
# Puts the machine to sleep (S3). The OS may delay if a foreground process
# is blocking idle transitions.

param(
  [int]$delay = 0
)

if ($delay -gt 0) { Start-Sleep -Seconds $delay }

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::SetSuspendState(
  [System.Windows.Forms.PowerState]::Suspend, $false, $false
) | Out-Null
Write-Output "OK"
