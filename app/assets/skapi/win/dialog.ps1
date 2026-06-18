# dialog.ps1
# SKAPI WIN Notify
# Two presentation modes, picked by the `fullscreen` flag:
#
#   * `fullscreen=false` (default): classic modal MessageBox with
#     OK/Cancel/Yes/No buttons. Returns the user's choice
#     (ok / cancel / yes / no / timeout). Used for "ask first" flows
#     where the caller branches on the answer.
#
#   * `fullscreen=true`: black always-on-top, borderless, button-LESS
#     window that fills the screen, shows a large title + body + huge
#     mustard countdown, and closes automatically when `timeout`
#     elapses. Used for "you must look" moments — break overlay,
#     forced pause, focus-lock prompts where the user is NOT supposed
#     to be able to click past it. Always returns "timeout".
#
# Threading note: both MessageBox.Show and WPF Window require an STA
# thread. The PowerShell host is STA for normal interactive scripts,
# so the non-timeout MessageBox path runs in-thread. Anything that
# needs a wall-clock timeout uses a child runspace explicitly opened
# in STA mode (RunspaceFactory + ApartmentState="STA").

param(
  [string]$title = "SKAPP",
  [string]$body = "",
  [string]$buttons = "ok_cancel",
  [int]$timeout = 0,
  [bool]$fullscreen = $false
)

Add-Type -AssemblyName System.Windows.Forms

# Fullscreen with no buttons must auto-close, otherwise the user is
# trapped. Force a sane default if the caller forgot.
if ($fullscreen -and $timeout -le 0) { $timeout = 60 }

# ============================================================
# Fullscreen path: WPF window in an STA runspace, races a timer.
# ============================================================
if ($fullscreen) {
  $rs = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace()
  $rs.ApartmentState = "STA"
  $rs.ThreadOptions  = "ReuseThread"
  $rs.Open()
  $ps = [PowerShell]::Create()
  $ps.Runspace = $rs

  $ps.AddScript({
    param($t, $b, $secs)
    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Xaml

    # XAML kept inline so the script stays self-contained — one file,
    # no sibling .xaml asset to ship.
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
                 Margin="0,0,0,24"/>
      <TextBlock Name="BodyText"
                 Foreground="#F5F2EC"
                 FontFamily="Segoe UI"
                 FontSize="28"
                 TextAlignment="Center"
                 TextWrapping="Wrap"
                 MaxWidth="900"
                 Margin="0,0,0,48"
                 Opacity="0.82"/>
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
    $window.FindName("BodyText").Text  = $b
    $cdText = $window.FindName("CountdownText")

    # Esc / Alt+F4 are intentionally not blocked — Final.md spec for
    # `mode=soft`. A future strict mode wires WH_KEYBOARD_LL to eat
    # everything, but that needs its own script.
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
  }).AddArgument($title).AddArgument($body).AddArgument($timeout) | Out-Null

  $async = $ps.BeginInvoke()
  # Wait for the window to close (timer fires or user kills it via
  # task manager / Alt+F4). The +5s grace is paranoid padding for
  # the dispatcher to actually tear down.
  $waited = 0.0
  $cap = $timeout + 5
  while (-not $async.IsCompleted -and $waited -lt $cap) {
    Start-Sleep -Milliseconds 250
    $waited += 0.25
  }
  if (-not $async.IsCompleted) {
    try { $ps.Stop() } catch {}
  }
  try { $rs.Close() } catch {}
  Write-Output "timeout"
  exit 0
}

# ============================================================
# Classic MessageBox path.
# ============================================================
$buttonSet = switch ($buttons.ToLower()) {
  "ok"            { [System.Windows.Forms.MessageBoxButtons]::OK }
  "ok_cancel"     { [System.Windows.Forms.MessageBoxButtons]::OKCancel }
  "yes_no"        { [System.Windows.Forms.MessageBoxButtons]::YesNo }
  "yes_no_cancel" { [System.Windows.Forms.MessageBoxButtons]::YesNoCancel }
  default         { [System.Windows.Forms.MessageBoxButtons]::OKCancel }
}

if ($timeout -le 0) {
  $result = [System.Windows.Forms.MessageBox]::Show($body, $title, $buttonSet)
  switch ($result) {
    "OK"     { Write-Output "ok" }
    "Cancel" { Write-Output "cancel" }
    "Yes"    { Write-Output "yes" }
    "No"     { Write-Output "no" }
    default  { Write-Output $result.ToString().ToLower() }
  }
  exit 0
}

# Timed MessageBox needs an STA runspace.
$rs = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace()
$rs.ApartmentState = "STA"
$rs.ThreadOptions  = "ReuseThread"
$rs.Open()
$ps = [PowerShell]::Create()
$ps.Runspace = $rs

$ps.AddScript({
  param($t, $b, $bs)
  Add-Type -AssemblyName System.Windows.Forms
  return [System.Windows.Forms.MessageBox]::Show($b, $t, $bs)
}).AddArgument($title).AddArgument($body).AddArgument($buttonSet) | Out-Null

$async = $ps.BeginInvoke()

$elapsed = 0.0
while (-not $async.IsCompleted -and $elapsed -lt $timeout) {
  Start-Sleep -Milliseconds 250
  $elapsed += 0.25
}

if (-not $async.IsCompleted) {
  try { $ps.Stop() } catch {}
  try { $rs.Close() } catch {}
  Write-Output "timeout"
  exit 0
}

$result = $ps.EndInvoke($async) | Select-Object -First 1
try { $rs.Close() } catch {}

switch ($result) {
  "OK"     { Write-Output "ok" }
  "Cancel" { Write-Output "cancel" }
  "Yes"    { Write-Output "yes" }
  "No"     { Write-Output "no" }
  default  { Write-Output $result.ToString().ToLower() }
}
