# blur-timed.ps1
# SKAPI WIN Visual Break
#
# Final.md §5 spec describes a real-time Gaussian-blurred fullscreen
# overlay (Direct2D / Win2D + BitBlt of the desktop below) for N
# seconds. PowerShell 5.1 + WPF doesn't ship a usable Win2D wrapper,
# so a faithful implementation would need a C++ helper binary. This
# script is the pragmatic interim: a fullscreen always-on-top
# semi-transparent solid overlay that creates the same "I can't focus
# on the screen, take a break" friction without the blur math.
#
# Real Gaussian blur will land later as a separate helper invocation
# from this script. Until then, the user gets an intentionally muted
# screen and a countdown so it doesn't feel arbitrary.
#
# Params:
#   duration  seconds the overlay stays up (5..600). Default 120.
#   opacity   solid colour alpha (0.0..1.0). Default 0.55.
#   color     overlay colour, hex. Default #0A0A0A (palette black).
#
# Threading: WPF Window must run on an STA thread. We open a child
# STA runspace and drive a DispatcherTimer that updates the countdown
# label every second, closing the window when it hits zero.

param(
  [int]$duration = 120,
  [string]$opacity = "0.55",
  [string]$color = "#0A0A0A"
)

if ($duration -lt 5) { $duration = 5 }
if ($duration -gt 600) { $duration = 600 }

# Parse opacity string defensively — CLI passes everything as text.
[double]$op = 0.55
[double]::TryParse(
  $opacity,
  [System.Globalization.NumberStyles]::Float,
  [System.Globalization.CultureInfo]::InvariantCulture,
  [ref]$op
) | Out-Null
if ($op -lt 0.0) { $op = 0.0 }
if ($op -gt 1.0) { $op = 1.0 }

# Validate hex; fall back to palette black on garbage input.
if ($color -notmatch '^#[0-9A-Fa-f]{6}$') { $color = "#0A0A0A" }

$rs = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace()
$rs.ApartmentState = "STA"
$rs.ThreadOptions  = "ReuseThread"
$rs.Open()
$ps = [PowerShell]::Create()
$ps.Runspace = $rs

$ps.AddScript({
  param($secs, $opacity, $color)
  Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Xaml

  # AllowsTransparency requires WindowStyle=None; we keep the window
  # borderless and let Background opacity do the work.
  $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        WindowStyle="None"
        WindowState="Maximized"
        ResizeMode="NoResize"
        Topmost="True"
        ShowInTaskbar="False"
        AllowsTransparency="True"
        Background="Transparent">
  <Grid>
    <Rectangle Name="Veil" />
    <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center">
      <TextBlock Name="LabelText"
                 Foreground="#F5F2EC"
                 FontFamily="Segoe UI"
                 FontSize="24"
                 TextAlignment="Center"
                 Opacity="0.75"
                 Margin="0,0,0,16"/>
      <TextBlock Name="CountdownText"
                 Foreground="#D4A017"
                 FontFamily="Segoe UI"
                 FontSize="84" FontWeight="Bold"
                 TextAlignment="Center"/>
    </StackPanel>
  </Grid>
</Window>
"@

  $reader = New-Object System.Xml.XmlNodeReader ([xml]$xaml)
  $window = [Windows.Markup.XamlReader]::Load($reader)

  $veil = $window.FindName("Veil")
  $brush = New-Object System.Windows.Media.SolidColorBrush
  $brush.Color = [System.Windows.Media.ColorConverter]::ConvertFromString($color)
  $brush.Opacity = $opacity
  $veil.Fill = $brush

  $window.FindName("LabelText").Text = "Bulanik mola"
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
}).AddArgument($duration).AddArgument($op).AddArgument($color) | Out-Null

$async = $ps.BeginInvoke()

# Wait with a small grace pad so the dispatcher has time to tear
# down its timer cleanly after the window closes.
$waited = 0.0
$cap = $duration + 5
while (-not $async.IsCompleted -and $waited -lt $cap) {
  Start-Sleep -Milliseconds 250
  $waited += 0.25
}
if (-not $async.IsCompleted) {
  try { $ps.Stop() } catch {}
}
try { $rs.Close() } catch {}

Write-Output "OK"
