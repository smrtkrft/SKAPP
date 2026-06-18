# fade-screen.ps1
# SKAPI WIN Visual Break
# Fades the internal display brightness from current to `target` over
# `duration` seconds in linear steps. Tier 2: WMI brightness only works
# on internal panels (laptops, tablets); external monitors do not react.

param(
  [int]$target = 20,
  [int]$duration = 3
)

if ($target -lt 0) { $target = 0 }
if ($target -gt 100) { $target = 100 }
if ($duration -lt 1) { $duration = 1 }

try {
  $bm = Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightness -ErrorAction Stop
  if (-not $bm) { throw "No internal display brightness reporter." }
  $methods = Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods -ErrorAction Stop
  if (-not $methods) { throw "No brightness write methods." }
} catch {
  Write-Error $_.Exception.Message
  exit 2
}

$current = ($bm | Select-Object -First 1).CurrentBrightness
Write-Output "Fading $current -> $target over ${duration}s"

$steps = [Math]::Max(1, $duration * 10)
$sleepMs = [int](($duration * 1000) / $steps)
for ($i = 1; $i -le $steps; $i++) {
  $t = $current + (($target - $current) * $i / $steps)
  ($methods | Select-Object -First 1).WmiSetBrightness(0, [int]$t) | Out-Null
  Start-Sleep -Milliseconds $sleepMs
}
Write-Output "OK"
