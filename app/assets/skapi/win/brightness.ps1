# brightness.ps1
# SKAPI WIN Display & Audio
# Sets internal display brightness (0-100). WMI path; works on laptops
# and tablets. External monitors over DDC/CI are not supported here.

param(
  [int]$level = 70,
  [int]$timeout = 1
)

if ($level -lt 0) { $level = 0 }
if ($level -gt 100) { $level = 100 }

try {
  $methods = Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods
  if (-not $methods) {
    Write-Error "No internal display brightness methods found."
    exit 2
  }
  $methods.WmiSetBrightness($timeout, $level) | Out-Null
  Write-Output "Set brightness to $level%"
} catch {
  Write-Error $_.Exception.Message
  exit 1
}
