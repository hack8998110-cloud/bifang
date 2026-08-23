param(
  [switch]$All,
  [string]$Destination = "$HOME\.codex\skills"
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$coreSkills = @(
  "bifang-starter",
  "bifang-topic",
  "bifang-script",
  "bifang-review",
  "bifang-rewrite",
  "bifang-feedback"
)

$advancedSkills = @(
  "bifang-intake",
  "bifang-diagnosis",
  "bifang-profile",
  "bifang-assets",
  "bifang-report",
  "bifang-clip",
  "bifang-account-plan",
  "bifang-evidence"
)

$legacySkills = @(
  "bifang-baokuan",
  "bifang-baokuan-batch"
)

$skills = if ($All) { $coreSkills + $advancedSkills + $legacySkills } else { $coreSkills }

New-Item -ItemType Directory -Force -Path $Destination | Out-Null

$installed = @()
$missing = @()

foreach ($skill in $skills) {
  $source = Get-ChildItem -LiteralPath (Join-Path $root "skills") -Directory -Recurse |
    Where-Object { $_.Name -eq $skill } |
    Select-Object -First 1 -ExpandProperty FullName
  if (-not $source) {
    $missing += $skill
    continue
  }
  $skillFile = Join-Path $source "SKILL.md"

  if (!(Test-Path -LiteralPath $skillFile)) {
    $missing += $skill
    continue
  }

  $target = Join-Path $Destination $skill
  Copy-Item -LiteralPath $source -Destination $target -Recurse -Force
  $installed += $skill
}

Write-Host "Bifang skills destination: $Destination"

if ($installed.Count -gt 0) {
  Write-Host "Installed:"
  foreach ($skill in $installed) {
    Write-Host "  - $skill"
  }
}

if ($missing.Count -gt 0) {
  Write-Host "Skipped missing skills:"
  foreach ($skill in $missing) {
    Write-Host "  - $skill"
  }
}

Write-Host "Done. Restart Codex or open a new conversation, then try bifang-starter."
