# SKAPP Windows paketleme: release build → SKAPP-windows-setup.exe (Inno, imzasız).
# Önkoşul: flutter + Inno Setup (iscc PATH'te). Çalıştır: pwsh scripts/package_windows.ps1
$ErrorActionPreference = "Stop"
$app = Resolve-Path (Join-Path $PSScriptRoot "..\app")
Set-Location $app

$m = Select-String -Path "pubspec.yaml" -Pattern '^version:\s*([0-9]+\.[0-9]+\.[0-9]+)'
$version = $m.Matches[0].Groups[1].Value

flutter build windows --release

$out = Join-Path $app "..\dist"
New-Item -ItemType Directory -Force -Path $out | Out-Null

iscc "/DAppVersion=$version" "/O$out" "windows\installer\skapp.iss"
Write-Host "OK -> $out\SKAPP-windows-setup.exe"
