# hibernate.ps1
# SKAPI WIN Power Management
# Sends the machine into hibernation (S4). Requires hibernation enabled in
# the OS power policy; if it is not, Windows falls back to sleep.

param(
  [int]$delay = 0
)

if ($delay -gt 0) { Start-Sleep -Seconds $delay }
shutdown /h
Write-Output "OK"
