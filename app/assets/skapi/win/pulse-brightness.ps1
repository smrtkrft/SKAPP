# pulse-brightness.ps1
# SKAPI WIN Visual Break
# Modulates internal display brightness on a cosine wave between
# 100% and `lowPercent` over `period` seconds, repeated `cycles`
# times. Restores the user's original brightness at exit (or on
# any error in finally). Same WMI path as brightness.ps1 /
# fade-screen.ps1 — internal panels only; external monitors over
# DDC/CI do not react.
#
# Used by visual-break flows to draw attention without going to
# black: the rhythmic dim → bright pulse is impossible to ignore
# but never blocks the user's screen.

param(
  [int]$period = 2,
  [int]$lowPercent = 60,
  [int]$cycles = 5
)

if ($period -lt 1) { $period = 1 }
if ($period -gt 10) { $period = 10 }
if ($lowPercent -lt 0) { $lowPercent = 0 }
if ($lowPercent -gt 90) { $lowPercent = 90 }
if ($cycles -lt 1) { $cycles = 1 }
if ($cycles -gt 30) { $cycles = 30 }

try {
  $bm = Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightness `
        -ErrorAction Stop
  if (-not $bm) { throw "No internal display brightness reporter." }
  $methods = Get-WmiObject -Namespace root/WMI `
             -Class WmiMonitorBrightnessMethods -ErrorAction Stop
  if (-not $methods) { throw "No brightness write methods." }
} catch {
  Write-Error $_.Exception.Message
  exit 2
}

$current = ($bm | Select-Object -First 1).CurrentBrightness
$writer  = $methods | Select-Object -First 1

# 20 fps so the wave looks smooth without spamming WMI.
$stepsPerPeriod = $period * 20
$sleepMs        = [int](1000 / 20)
$highPercent    = 100
$mid            = ($highPercent + $lowPercent) / 2.0
$amp            = ($highPercent - $lowPercent) / 2.0

try {
  for ($c = 0; $c -lt $cycles; $c++) {
    for ($i = 0; $i -lt $stepsPerPeriod; $i++) {
      $t = $mid + $amp * [Math]::Cos(2 * [Math]::PI * $i / $stepsPerPeriod)
      $writer.WmiSetBrightness(0, [int]$t) | Out-Null
      Start-Sleep -Milliseconds $sleepMs
    }
  }
  Write-Output "OK"
} finally {
  # Always rest the user back at the brightness they had on entry,
  # even if the loop was interrupted (ctrl+c / kill / WMI hiccup).
  try { $writer.WmiSetBrightness(0, [int]$current) | Out-Null } catch {}
}
