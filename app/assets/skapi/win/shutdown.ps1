# shutdown.ps1
# SKAPI WIN Power Management
# Initiates a graceful shutdown of Windows.
#
# `$args` PowerShell otomatik değişkenidir (script'in pozisyonel
# argümanları). Custom variable olarak kullanıp shadowlamak PS 5.1'de
# çalışır ama brittle — launch-app.ps1'deki aynı düzeltme gibi yerel
# isim kullanılıyor. Bkz: launch-app.ps1 cmdArgs rename history.

param(
  [int]$delay = 30,
  [bool]$force = $false
)

$cmdArgs = @('/s', '/t', $delay)
if ($force) { $cmdArgs += '/f' }
& shutdown @cmdArgs
Write-Output "OK"
