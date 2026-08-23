[CmdletBinding()]
param(
  [switch]$Build,
  [string]$ReleaseDirectory
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content -Raw -LiteralPath (Join-Path $root "release-manifest.json") | ConvertFrom-Json

if (-not $ReleaseDirectory) {
  $ReleaseDirectory = Join-Path (Split-Path -Parent (Split-Path -Parent $root)) "releases"
}

$readme = Get-Content -Raw -LiteralPath (Join-Path $root "README.md")
$changelog = Get-Content -Raw -LiteralPath (Join-Path $root "CHANGELOG.md")
$releaseNotes = Join-Path $root "docs\releases\v$($manifest.version).md"
if ($readme -notmatch "# 毕方 V$([regex]::Escape($manifest.version))") { throw "README version is not V$($manifest.version)." }
if ($changelog -notmatch "## V$([regex]::Escape($manifest.version))") { throw "CHANGELOG does not contain V$($manifest.version)." }
if (-not (Test-Path -LiteralPath $releaseNotes)) { throw "Missing release notes: $releaseNotes" }

$skills = @($manifest.allPublicSkills)
foreach ($skill in $skills) {
  $skillDirectory = Get-ChildItem -LiteralPath (Join-Path $root "skills") -Directory -Recurse |
    Where-Object { $_.Name -eq $skill } |
    Select-Object -First 1 -ExpandProperty FullName
  $skillFile = if ($skillDirectory) { Join-Path $skillDirectory "SKILL.md" } else { $null }
  if (-not (Test-Path -LiteralPath $skillFile)) { throw "Missing public skill: $skill" }
}

$installers = @("install.ps1", "validate-install.ps1", "install.sh", "validate-install.sh")
foreach ($installer in $installers) {
  $text = Get-Content -Raw -LiteralPath (Join-Path $root $installer)
  foreach ($skill in $skills) {
    if ($text -notmatch [regex]::Escape($skill)) { throw "$installer does not list $skill." }
  }
}

$files = Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object {
  $relative = $_.FullName.Substring($root.Length).TrimStart('\', '/')
  $segments = $relative -split '[\\/]'
  -not (@($manifest.excludedPathSegments) | Where-Object { $segments -contains $_ })
}

foreach ($file in $files) {
  $relative = $file.FullName.Substring($root.Length).TrimStart('\', '/')
  if ($relative -match '(?i)(^|[\\/])(internal|private)([\\/]|$)') { throw "Private path would enter release: $relative" }
}

Write-Host "Release checks passed: V$($manifest.version), $($skills.Count) public skills, $($files.Count) files."

if (-not $Build) {
  Write-Host "Dry run only. Re-run with -Build to create the release archive."
  exit 0
}

New-Item -ItemType Directory -Force -Path $ReleaseDirectory | Out-Null
$archive = Join-Path $ReleaseDirectory "bifang-v$($manifest.version)-open-source.zip"
if (Test-Path -LiteralPath $archive) { Remove-Item -LiteralPath $archive -Force }

Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::Open($archive, [System.IO.Compression.ZipArchiveMode]::Create)
try {
  foreach ($file in $files) {
    $relative = $file.FullName.Substring($root.Length).TrimStart('\', '/') -replace '\\', '/'
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $file.FullName, $relative, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
  }
}
finally {
  $zip.Dispose()
}

Write-Host "Created: $archive"
