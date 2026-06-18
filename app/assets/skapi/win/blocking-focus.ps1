# blocking-focus.ps1
# SKAPI WIN Visual Break
#
# Composite "focus enforcer": runs three Final.md actions back-to-back
# in one atomic call, so the SKAPP action chain editor doesn't have to
# stitch them together every time.
#
#   1. SAVE PHASE   -> autosave-trigger logic inlined: Office COM
#                      (Word/Excel/PowerPoint via Marshal.GetActiveObject
#                      + $doc.Save()) and VS Code CLI
#                      (code -r --command workbench.action.files.saveAll).
#                      Best-effort, swallows failures so a broken app
#                      can't keep the user trapped at the start.
#   2. MOUSE SHAKE  -> continuous circular drag of the cursor while the
#                      countdown runs; SetCursorPos in a parallel
#                      runspace, stopped via a synchronized hashtable
#                      flag. Origin captured before start, restored in
#                      finally so the cursor lands back where it began.
#   3. FULLSCREEN   -> "dialog.ps1 fullscreen=true" pattern: STA WPF
#                      window, borderless, always-on-top, black
#                      background, "Blocking Focus" title + huge mustard
#                      countdown. No close button. Esc/Alt+F4 deliberately
#                      not eaten (soft mode; strict mode with input
#                      hooks belongs in a separate script).
#
# Params:
#   duration     seconds the lockdown runs (10..600). Default 100.
#   title        text shown in the middle of the window. Default
#                "Blocking Focus".
#   shakeRadius  pixels of the mouse shake circle (50..800). Default 300.
#   enableSave   $true to run the save phase. $false skips it for the
#                "no data to save" case (e.g. movie watching).

param(
  [int]$duration = 100,
  [string]$title = "Blocking Focus",
  [int]$shakeRadius = 300,
  [bool]$enableSave = $true
)

if ($duration -lt 10) { $duration = 10 }
if ($duration -gt 600) { $duration = 600 }
if ($shakeRadius -lt 50) { $shakeRadius = 50 }
if ($shakeRadius -gt 800) { $shakeRadius = 800 }

# ============================================================
# Phase 1 — Save (autosave-trigger inline)
# ============================================================
function Invoke-OfficeSave {
  param([string]$progId, [string]$label)
  try {
    $app = [System.Runtime.InteropServices.Marshal]::GetActiveObject($progId)
    if (-not $app) { return }
    foreach ($doc in $app.Documents) {
      try {
        if (-not $doc.Saved) {
          $doc.Save()
          Write-Output "Saved $label - $($doc.Name)"
        }
      } catch {
        Write-Output "Warn $label save failed: $($_.Exception.Message)"
      }
    }
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($app) | Out-Null
  } catch {
    # App not running or COM unavailable — skip silently. The script
    # must keep going even if save fails; the user already pressed
    # "lock me down".
  }
}

if ($enableSave) {
  Invoke-OfficeSave -progId "Word.Application"       -label "Word"
  Invoke-OfficeSave -progId "Excel.Application"      -label "Excel"
  Invoke-OfficeSave -progId "PowerPoint.Application" -label "PowerPoint"

  $codeCli = Get-Command code -ErrorAction SilentlyContinue
  if ($codeCli -and (Get-Process -Name code -ErrorAction SilentlyContinue)) {
    try {
      & $codeCli.Source -r --command "workbench.action.files.saveAll" 2>$null | Out-Null
      Write-Output "Saved VS Code"
    } catch {}
  }
}

# ============================================================
# Phase 2 — Origin snapshot + mouse shake runspace
# ============================================================
Add-Type @"
using System;
using System.Runtime.InteropServices;
public struct PT { public int X; public int Y; }
public class M {
  [DllImport("user32.dll")] public static extern bool GetCursorPos(out PT p);
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
}
"@

$origin = New-Object PT
[M]::GetCursorPos([ref]$origin) | Out-Null

# Thread-safe stop flag shared between main script and shake runspace
# (PowerShell global state is runspace-isolated, so a global var
# wouldn't work). The hashtable.Synchronized() wrapper makes property
# writes atomic across threads.
$flag = [hashtable]::Synchronized(@{ stop = $false })

$shakeRs = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace()
$shakeRs.Open()
$shakePs = [PowerShell]::Create()
$shakePs.Runspace = $shakeRs
$shakePs.AddScript({
  param($flag, $originX, $originY, $radius)
  Add-Type @"
using System;
using System.Runtime.InteropServices;
public class MShake {
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
}
"@
  $steps = 36
  while (-not $flag.stop) {
    for ($s = 0; $s -lt $steps; $s++) {
      if ($flag.stop) { break }
      $angle = (2 * [Math]::PI) * ($s / $steps)
      $x = $originX + [int]([Math]::Cos($angle) * $radius)
      $y = $originY + [int]([Math]::Sin($angle) * $radius)
      [MShake]::SetCursorPos($x, $y) | Out-Null
      Start-Sleep -Milliseconds 12
    }
  }
}).AddArgument($flag).AddArgument($origin.X).AddArgument($origin.Y).AddArgument($shakeRadius) | Out-Null
$shakeAsync = $shakePs.BeginInvoke()

# ============================================================
# Phase 3 — Fullscreen WPF window (STA), countdown, no close button
# ============================================================
$winRs = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace()
$winRs.ApartmentState = "STA"
$winRs.ThreadOptions  = "ReuseThread"
$winRs.Open()
$winPs = [PowerShell]::Create()
$winPs.Runspace = $winRs

$winPs.AddScript({
  param($t, $secs)
  Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Xaml

  $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        WindowStyle="None"
        WindowState="Maximized"
        ResizeMode="NoResize"
        Topmost="True"
        ShowInTaskbar="False"
        Background="#0A0A0A">
  <Grid>
    <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center" Margin="40">
      <TextBlock Name="TitleText"
                 Foreground="#F5F2EC"
                 FontFamily="Segoe UI"
                 FontSize="56" FontWeight="Bold"
                 TextAlignment="Center"
                 Margin="0,0,0,32"/>
      <TextBlock Name="CountdownText"
                 Foreground="#D4A017"
                 FontFamily="Segoe UI"
                 FontSize="96" FontWeight="Bold"
                 TextAlignment="Center"/>
    </StackPanel>
  </Grid>
</Window>
"@

  $reader = New-Object System.Xml.XmlNodeReader ([xml]$xaml)
  $window = [Windows.Markup.XamlReader]::Load($reader)
  $window.FindName("TitleText").Text = $t
  $cdText = $window.FindName("CountdownText")

  $end = (Get-Date).AddSeconds($secs)
  $timer = New-Object System.Windows.Threading.DispatcherTimer
  $timer.Interval = [TimeSpan]::FromMilliseconds(250)
  $timer.Add_Tick({
    $remaining = [int][math]::Max(0, ($end - (Get-Date)).TotalSeconds)
    $cdText.Text = "{0:00}:{1:00}" -f [math]::Floor($remaining / 60), ($remaining % 60)
    if ($remaining -le 0) {
      $timer.Stop()
      $window.Close()
    }
  })
  $timer.Start()

  [void]$window.ShowDialog()
}).AddArgument($title).AddArgument($duration) | Out-Null

$winAsync = $winPs.BeginInvoke()

# ============================================================
# Wait for the window to close (poll + small grace), then clean up.
# ============================================================
try {
  $waited = 0.0
  $cap = $duration + 5
  while (-not $winAsync.IsCompleted -and $waited -lt $cap) {
    Start-Sleep -Milliseconds 250
    $waited += 0.25
  }
  if (-not $winAsync.IsCompleted) {
    try { $winPs.Stop() } catch {}
  }
} finally {
  # Stop the shake loop, give it a tick to break out of its inner
  # for-loop, then snap the cursor back home. Cleanup runs even if
  # something above threw — the user must NEVER be left with a
  # juggling cursor or a stuck overlay.
  $flag.stop = $true
  Start-Sleep -Milliseconds 80
  try { $shakePs.Stop() } catch {}
  try { $winRs.Close() } catch {}
  try { $shakeRs.Close() } catch {}
  try { [M]::SetCursorPos($origin.X, $origin.Y) | Out-Null } catch {}
}

Write-Output "OK"
# `code` CLI (workbench.action.files.saveAll) bazen exit 9 döner, bu
# $LASTEXITCODE'a sızar ve scriptin kendisi 9 ile çıkmış gibi görünür.
# SKAPP webhook handler exit kodunu fail/success sinyali olarak yorumlar
# ve kullanıcı "hata" görür — oysa save phase başarılı. Explicit exit 0
# bu yan etkiyi kapatır. autosave-trigger.ps1'de aynı pattern düzeltildi.
exit 0
