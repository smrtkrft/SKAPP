# browser-close-all.ps1
# SKAPI WIN Programs
# Closes EVERY browser window gracefully. Modern browsers preserve the
# session if the user has "restore tabs on next launch" enabled, so this
# is a soft "switch off the screen" rather than a data-loss action.
#
# The previous revision used `Get-Process | MainWindowHandle` which
# returns ONE handle per process — Chrome/Edge/Firefox run all windows
# under a single main process (multi-window, single main HWND on .NET
# side), so only the first window closed. Fixed 2026-05-15 by
# enumerating top-level windows with `EnumWindows` and matching the
# owning PID against the browser process set, covering every visible
# browser window regardless of how many share a process.

$browsers = @("chrome", "msedge", "firefox", "brave", "vivaldi", "opera", "opera_gx")

Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  using System.Text;
  public class W {
    [DllImport("user32.dll")]
      public static extern bool EnumWindows(EnumDelegate cb, IntPtr p);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
      public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
    [DllImport("user32.dll")]
      public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
      public static extern IntPtr SendMessage(IntPtr h, uint msg, IntPtr w, IntPtr l);
    public delegate bool EnumDelegate(IntPtr h, IntPtr p);
  }
"@

$WM_CLOSE = 0x0010

# Cache running browser PIDs once so the EnumWindows callback can match
# without re-querying Get-Process for every window. Renderer/utility
# subprocesses share the browser name so they end up here too, but they
# carry no visible window — IsWindowVisible filters them out below.
$browserPids = @{}
foreach ($name in $browsers) {
  foreach ($p in (Get-Process -Name $name -ErrorAction SilentlyContinue)) {
    $browserPids[[uint32]$p.Id] = $p.ProcessName
  }
}

if ($browserPids.Count -eq 0) {
  Write-Output "No browser instances running."
  exit 0
}

$script:total = 0

$cb = [W+EnumDelegate] {
  param([IntPtr]$h, [IntPtr]$p)
  if (-not [W]::IsWindowVisible($h)) { return $true }
  $sb = New-Object System.Text.StringBuilder 256
  [W]::GetWindowText($h, $sb, 256) | Out-Null
  # Windows with no caption are usually message-only or tool windows.
  # Real browser windows always have a title (tab name or "New Tab").
  if ($sb.Length -eq 0) { return $true }

  # `$pid` is a PowerShell automatic variable (current process id),
  # so we use a different name for the out-param target.
  $ownerPid = [uint32]0
  [W]::GetWindowThreadProcessId($h, [ref]$ownerPid) | Out-Null
  if (-not $browserPids.ContainsKey($ownerPid)) { return $true }

  [W]::SendMessage($h, $WM_CLOSE, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null
  $script:total++
  return $true
}
[W]::EnumWindows($cb, [IntPtr]::Zero) | Out-Null

Write-Output "Closed $($script:total) browser windows"
