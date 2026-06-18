# launch-app.ps1
# SKAPI WIN Window & App
# Starts an executable or opens a URL/document with optional arguments.
#
# Parameter renamed `args` → `cmdArgs` 2026-05-15: `$args` is a
# PowerShell automatic variable (the script-argument array) and using
# it as a custom parameter name shadows the automatic. Works in PS 5.1
# but is brittle across versions; renamed for safety.

param(
  [string]$path = "",
  [string]$cmdArgs = ""
)

if ([string]::IsNullOrWhiteSpace($path)) {
  Write-Error "path is required (executable, URL, or document)."
  exit 2
}

try {
  if ([string]::IsNullOrWhiteSpace($cmdArgs)) {
    Start-Process -FilePath $path | Out-Null
  } else {
    Start-Process -FilePath $path -ArgumentList $cmdArgs | Out-Null
  }
  Write-Output "Launched: $path"
} catch {
  Write-Error $_.Exception.Message
  exit 1
}
