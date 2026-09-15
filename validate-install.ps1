param(
  [switch]$All,
  [string]$Destination = "$HOME\.codex\skills"
)

$ErrorActionPreference = "Stop"

$coreSkills = @(
  "bifang"
)

$advancedSkills = @(
  "bifang-starter",
  "bifang-topic",
  "bifang-script",
  "bifang-review",
  "bifang-rewrite",
  "bifang-feedback",
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

Write-Host "Checking Bifang skills in: $Destination"

$failed = $false

foreach ($skill in $skills) {
  $skillFile = Join-Path $Destination "$skill\SKILL.md"
  if (Test-Path -LiteralPath $skillFile) {
    Write-Host "[OK] $skill"
  } else {
    Write-Host "[MISSING] $skill -> $skillFile"
    $failed = $true
  }
}

if ($failed) {
  Write-Host "Validation failed. Run install.ps1 again or check your skills directory."
  exit 1
}

Write-Host "Validation passed. Restart Codex or open a new conversation, then test bifang."
