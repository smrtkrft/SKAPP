# show-desktop.ps1
# SKAPI WIN Visual Break
# Toggles "show desktop" via the Shell COM object. Pressing the same
# command again restores the previous window arrangement, mirroring
# Win+D semantics.

$shell = New-Object -ComObject Shell.Application
$shell.ToggleDesktop()
Write-Output "OK"
