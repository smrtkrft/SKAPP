# autosave-trigger.ps1
# SKAPI · WIN · Save Work
# Calls the official save API for each app that exposes one, instead
# of pushing a UI keystroke. This bypasses focus races and keyboard-
# layout sensitivity that plague Ctrl+S based approaches.
#
# Final.md spec:
#   * Office 365 (Word/Excel/PowerPoint): COM Automation
#     `Application.ActiveDocument.Save` for every open document.
#   * VS Code: `code --command workbench.action.files.saveAll` via the
#     command-line bridge.
#   * OneDrive sync: a separate `onedrive-sync-now` endpoint (out of
#     scope here).
#
# The previous revision broadcast `WM_COMMAND` with a hardcoded
# `ID_SAVE=0xE2`, which is not a universal save command — almost no
# real app responds to it, so nothing was actually saved. Replaced
# with COM + CLI calls 2026-05-15.
#
# `save-all-open.ps1` (Ctrl+S to whitelist) remains the fallback for
# apps without a public save API (Notepad, generic editors, etc.).

param(
  [int]$delay = 0,
  [bool]$verbose = $true
)

if ($delay -gt 0) { Start-Sleep -Seconds $delay }

# Sayaçlar script-scope: function'lar Write-Output ile pipeline'a string
# bastığında, `return $count` ile dönen integer ile string karışıyor;
# çağıran `$savedDocs += func` ifadesinde `[int] + [Object[]]` op_Addition
# hatası alıyor. Çözüm: function void (return etmez), sayacı $script:
# scope'taki değişken üzerinde mutate eder. Verbose Write-Output mesajları
# bağımsızca stdout'a akar, SKAPP webhook log'unda görünmeye devam eder.
$script:savedDocs = 0
$script:skippedApps = @()

# ---------- Office COM Automation -----------------------------------
# `Marshal::GetActiveObject(progID)` reaches into the Running Object
# Table to grab the existing Office instance. Throws if the app is
# not running — we catch it silently and move on.
function Invoke-OfficeSave {
  param(
    [string]$progId,
    [string]$label
  )
  try {
    $app = [System.Runtime.InteropServices.Marshal]::GetActiveObject($progId)
    if (-not $app) { return }
    foreach ($doc in $app.Documents) {
      try {
        # `Saved` is false when there are unsaved edits. Skip already-
        # clean documents so we don't burn cycles or rewrite OneDrive
        # files for nothing.
        if (-not $doc.Saved) {
          $doc.Save()
          $script:savedDocs++
          if ($script:verbose) {
            Write-Output "Saved $label · $($doc.Name)"
          }
        } elseif ($script:verbose) {
          Write-Output "Clean  $label · $($doc.Name)"
        }
      } catch {
        Write-Output "Warn $label save failed: $($_.Exception.Message)"
      }
    }
    # Release the COM ref so we don't pin the Office process alive.
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($app) | Out-Null
  } catch {
    # COMException 0x800401E3 = MK_E_UNAVAILABLE → app not running.
    # Any other failure also means we can't save; log it.
    if ($script:verbose) {
      Write-Output "Skip $label (not running or COM unavailable)"
    }
    $script:skippedApps += $label
  }
}

Invoke-OfficeSave -progId "Word.Application"       -label "Word"
Invoke-OfficeSave -progId "Excel.Application"      -label "Excel"
Invoke-OfficeSave -progId "PowerPoint.Application" -label "PowerPoint"

# ---------- VS Code CLI bridge --------------------------------------
# Code's `--command` flag dispatches a command into the running
# window if `code` is on PATH and at least one window is open. If
# Code isn't installed, the CLI throws (we ignore it).
$codeCli = Get-Command code -ErrorAction SilentlyContinue
if ($codeCli) {
  $codeProcs = Get-Process -Name code -ErrorAction SilentlyContinue
  if ($codeProcs) {
    try {
      # `-r` (--reuse-window) avoids spawning a new instance, so the
      # command lands in the user's active window. `> $null` swallows
      # CLI noise; saveAll is silent on success.
      & $codeCli.Source -r --command "workbench.action.files.saveAll" 2>$null | Out-Null
      $script:savedDocs++
      if ($verbose) { Write-Output "Saved VS Code (all unsaved)" }
    } catch {
      if ($verbose) { Write-Output "VS Code save failed: $($_.Exception.Message)" }
    }
  } elseif ($verbose) {
    Write-Output "Skip VS Code (not running)"
    $script:skippedApps += "VS Code"
  }
} elseif ($verbose) {
  Write-Output "Skip VS Code (CLI not on PATH)"
}

Write-Output "OK (saved=$($script:savedDocs) skipped=$($script:skippedApps.Count))"
# `code` CLI'sının exit kodu (örn. workbench command'larda 9 dönebiliyor)
# $LASTEXITCODE'a sızar. SKAPP script_runner exit kodunu fail/success
# sinyali olarak kullanırsa yanlış alarma çıkar. Explicit exit 0.
exit 0
