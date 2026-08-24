# opencode-free-setup installer — Windows (PowerShell)
# Repo: https://github.com/CliffVale/opencode-free-setup
param(
  [switch]$SkipTools,
  [switch]$Freebuff,
  [switch]$Yes,
  [string]$Source
)
$ErrorActionPreference = "Stop"
$OpenCodeDir = if ($env:OPENCODE_CONFIG_DIR) { $env:OPENCODE_CONFIG_DIR } else { "$env:USERPROFILE\.config\opencode" }

function Say($m)  { Write-Host "▸ $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "✓ $m" -ForegroundColor Green }

# ── deps ────────────────────────────────────────────────────────────────
if (-not $SkipTools) {
  Say "Installing OpenCode…"
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    # OpenCode ships a native Windows build; npm fallback below also works
    npm install -g opencode-ai 2>$null; if ($LASTEXITCODE -ne 0) { winget install anomaly.opencode }
  } else {
    npm install -g opencode-ai
  }
  Ok "OpenCode installed"

  if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Say "Installing Node.js LTS…"; winget install OpenJS.NodeJS.LTS
  }
  if ($Freebuff) { npm install -g freebuff; Ok "Freebuff installed" }
}

# ── config + skills ─────────────────────────────────────────────────────
New-Item -ItemType Directory -Force -Path "$OpenCodeDir/skills","$OpenCodeDir/agents" | Out-Null
$Tmp = Join-Path $env:TEMP ("ocfs-" + [guid]::NewGuid())
if ($Source -and (Test-Path $Source)) { $Src = $Source }
else {
  Say "Fetching setup files…"
  git clone --depth 1 https://github.com/CliffVale/opencode-free-setup $Tmp
  $Src = $Tmp
}
if (Test-Path "$OpenCodeDir/opencode.jsonc") {
  Copy-Item "$OpenCodeDir/opencode.jsonc" "$OpenCodeDir/opencode.jsonc.bak.$(Get-Date -Format yyyyMMdd-HHmmss)"
}
Copy-Item "$Src/setup/opencode.jsonc" "$OpenCodeDir/opencode.jsonc"
Copy-Item "$Src/setup/AGENTS.md"      "$OpenCodeDir/AGENTS.md" -ErrorAction SilentlyContinue
Copy-Item "$Src/setup/agents/*.md"    "$OpenCodeDir/agents/"
Copy-Item "$Src/skills/*"             "$OpenCodeDir/skills/" -Recurse -Force
Ok "Config + skills installed to $OpenCodeDir"
Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "════════ Setup complete ════════" -ForegroundColor Green
Write-Host @"
Next steps:
  1. cd into any project and run:  opencode
  2. /connect → pick provider (Zen = free models, no card)
  3. /models  → pick a free model
More free quota: docs/05-api-keys-guide.md in the repo.
"@ -ForegroundColor White
