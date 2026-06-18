# grayscale.ps1
# SKAPI WIN Visual Break
# Toggles Windows Color Filters (grayscale). Three modes:
#
#   1) on=true  + durationSec=0  → açar ve bırakır (kullanıcı manuel
#      kapatır veya başka binding kapatır).
#   2) on=false + durationSec=0  → kapatır ve bırakır.
#   3) on=true  + durationSec>0  → açar, N saniye bekler, otomatik
#      olarak kapatır ("geri renklendirme"). Visual-break flow için
#      doğal: cihaz tetiklediğinde N saniyelik gri mola, sonra
#      otomatik renge döner. Pulse-brightness ile aynı paradigma.
#
# Live flip path: Win+Ctrl+C is the system hotkey Microsoft ships for
# Color Filters toggle. We force `HotkeyEnabled=1` so the simulated
# keystroke is always honored. Win+Ctrl+C is a TOGGLE — only press
# it when current != target, otherwise the existing state inverts.
#
# Fallback: hotkey bloklu / non-interactive session ise registry'i
# doğrudan yazıyoruz. Windows bunu sonraki sign-in'de uygular. Bu
# bir hata değil, bilgi mesajıdır — script `exit 0` döner.

param(
  [bool]$on = $true,
  [int]$durationSec = 0,
  [bool]$verbose = $true
)

if ($durationSec -lt 0) { $durationSec = 0 }
if ($durationSec -gt 3600) { $durationSec = 3600 }

$key = "HKCU:\Software\Microsoft\ColorFiltering"

function Set-Grayscale {
  param([bool]$enable)
  $target = [int]$enable

  if (-not (Test-Path $key)) {
    New-Item -Path $key -Force | Out-Null
  }
  Set-ItemProperty -Path $key -Name "FilterType"    -Value 0 -Type DWord
  Set-ItemProperty -Path $key -Name "HotkeyEnabled" -Value 1 -Type DWord

  $cur = (Get-ItemProperty -Path $key -Name "Active" -ErrorAction SilentlyContinue).Active
  if ($null -eq $cur) { $cur = 0 }

  if ($cur -eq $target) {
    return @{ status = "already"; value = $target }
  }

  # Current state differs from target → flip via the system hotkey.
  [CF]::keybd_event(0x5B, 0, 0, [UIntPtr]::Zero)  # Win down
  Start-Sleep -Milliseconds 30
  [CF]::keybd_event(0x11, 0, 0, [UIntPtr]::Zero)  # Ctrl down
  Start-Sleep -Milliseconds 30
  [CF]::keybd_event(0x43, 0, 0, [UIntPtr]::Zero)  # C down
  Start-Sleep -Milliseconds 30
  [CF]::keybd_event(0x43, 0, 2, [UIntPtr]::Zero)  # C up
  [CF]::keybd_event(0x11, 0, 2, [UIntPtr]::Zero)  # Ctrl up
  [CF]::keybd_event(0x5B, 0, 2, [UIntPtr]::Zero)  # Win up

  Start-Sleep -Milliseconds 250

  $now = (Get-ItemProperty -Path $key -Name "Active" -ErrorAction SilentlyContinue).Active
  if ($null -eq $now) { $now = 0 }
  if ($now -ne $target) {
    Set-ItemProperty -Path $key -Name "Active" -Value $target -Type DWord
    return @{ status = "deferred"; value = $target }
  }

  return @{ status = "flipped"; value = $target }
}

try {
  Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class CF {
      [DllImport("user32.dll")] public static extern void keybd_event(byte vk, byte scan, uint flags, UIntPtr extra);
    }
"@

  $result = Set-Grayscale -enable $on
  if ($verbose) {
    switch ($result.status) {
      "already"  { Write-Output "already $($result.value) (no change)" }
      "flipped"  { if ($on) { Write-Output "enabled" } else { Write-Output "disabled" } }
      "deferred" { Write-Output "Color Filters in-session değişimi bloklandı (kısayol kapalı); değişim sonraki oturumda uygulanır." }
    }
  }

  # Auto-revert mode: açtıysak ve duration > 0 ise N saniye sonra kapat.
  if ($on -and $durationSec -gt 0) {
    if ($verbose) { Write-Output "auto-revert: ${durationSec}s sonra renge dönecek" }
    Start-Sleep -Seconds $durationSec
    $revert = Set-Grayscale -enable $false
    if ($verbose) {
      switch ($revert.status) {
        "already"  { Write-Output "revert: zaten kapalıydı" }
        "flipped"  { Write-Output "revert: renge döndü" }
        "deferred" { Write-Output "revert: sonraki oturumda kapanır" }
      }
    }
  }

  exit 0
} catch {
  Write-Error "grayscale failed: $($_.Exception.Message)"
  exit 1
}
