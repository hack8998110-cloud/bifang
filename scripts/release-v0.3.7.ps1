[CmdletBinding()]
param(
  [switch]$Build,
  [string]$ReleaseDirectory
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content -Raw -LiteralPath (Join-Path $root 'release-manifest.json') | ConvertFrom-Json
if ($manifest.version -ne '0.3.7') { throw 'release-manifest.json is not 0.3.7.' }

& (Join-Path $PSScriptRoot 'release-v0.3.6.ps1') -Build:$Build -ReleaseDirectory $ReleaseDirectory
exit $LASTEXITCODE
