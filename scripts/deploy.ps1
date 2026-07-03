#!/usr/bin/env pwsh
<#
.SYNOPSIS
    PINKZ Deployment Script (Windows)
.DESCRIPTION
    Deploys the backend to Cloudflare Workers, runs remote migrations,
    and builds the Flutter app for production.
#>

$ErrorActionPreference = "Stop"
$ROOT_DIR = Split-Path -Parent (Split-Path -Parent $PSCommandPath)

function Write-Info   { Write-Host "[INFO]  $args" -ForegroundColor Blue }
function Write-Ok     { Write-Host "[OK]    $args" -ForegroundColor Green }
function Write-Warn   { Write-Host "[WARN]  $args" -ForegroundColor Yellow }
function Write-Error  { Write-Host "[ERROR] $args" -ForegroundColor Red; exit 1 }

# ──────────────────────────────────────────────
# Required secrets check
# ──────────────────────────────────────────────
$REQUIRED_SECRETS = @(
  "JWT_SECRET",
  "JWT_REFRESH_SECRET",
  "OPENAI_API_KEY",
  "COMPOSIO_API_KEY"
)

Write-Info "Checking required secrets..."

Push-Location "$ROOT_DIR\backend"
try {
  $existingSecrets = npx wrangler secret list 2>$null
  $MISSING_SECRETS = @()

  foreach ($secret in $REQUIRED_SECRETS) {
    if ($existingSecrets -match $secret) {
      Write-Ok "$secret is set"
    } else {
      $MISSING_SECRETS += $secret
    }
  }

  if ($MISSING_SECRETS.Count -gt 0) {
    Write-Warn "The following secrets are not set:"
    foreach ($s in $MISSING_SECRETS) {
      Write-Host "  - $s" -ForegroundColor Yellow
    }
    ""
    Write-Host "Set them with:"
    Write-Host '  echo "your-value" | npx wrangler secret put SECRET_NAME'
    ""
    $confirm = Read-Host "Continue anyway? (y/N)"
    if ($confirm -notmatch '^[Yy]') {
      Write-Error "Deployment cancelled."
    }
  }
} finally {
  Pop-Location
}

# ──────────────────────────────────────────────
# Deploy backend Workers
# ──────────────────────────────────────────────
""
$WORKERS = @(
  @{ Name = "API";      Config = "workers/api/wrangler.jsonc" }
  @{ Name = "Auth";     Config = "workers/auth/wrangler.jsonc" }
  @{ Name = "Composio"; Config = "workers/composio/wrangler.jsonc" }
  @{ Name = "Sync";     Config = "workers/sync/wrangler.jsonc" }
)

foreach ($worker in $WORKERS) {
  Write-Info "Deploying $($worker.Name) Worker..."
  Push-Location "$ROOT_DIR\backend"
  try {
    npx wrangler deploy --config $worker.Config
    if ($LASTEXITCODE -ne 0) { throw "$($worker.Name) deploy failed" }
  } finally {
    Pop-Location
  }
}

# ──────────────────────────────────────────────
# Database migrations (remote)
# ──────────────────────────────────────────────
""
Write-Info "Running remote database migrations..."
Push-Location "$ROOT_DIR\backend"
try {
  npx wrangler d1 migrations apply pinkz-db --remote
  if ($LASTEXITCODE -ne 0) { throw "D1 migrations failed" }
} finally {
  Pop-Location
}

# ──────────────────────────────────────────────
# Build Flutter app
# ──────────────────────────────────────────────
""
Write-Info "Building Flutter web app for production..."
Push-Location "$ROOT_DIR\apps\mobile"
try {
  flutter build web --release
  if ($LASTEXITCODE -ne 0) { throw "Flutter web build failed" }
} finally {
  Pop-Location
}

Write-Info "Building Flutter Android APK..."
Push-Location "$ROOT_DIR\apps\mobile"
try {
  flutter build apk --release
  if ($LASTEXITCODE -ne 0) { throw "Flutter Android build failed" }
} finally {
  Pop-Location
}

# ──────────────────────────────────────────────
# Print deployment URLs
# ──────────────────────────────────────────────
""
Write-Host "═══════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "  Deployment complete!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════" -ForegroundColor Magenta
""
Write-Host "  Backend URLs:"
Write-Host "    API Worker:      https://api.pinkz.app"
Write-Host "    Auth Worker:     https://auth.pinkz.app"
Write-Host "    Composio Worker: https://composio.pinkz.app"
Write-Host "    Sync Worker:     https://sync.pinkz.app"
""
Write-Host "  Build outputs:"
Write-Host "    Web:    apps\mobile\build\web\"
Write-Host "    Android: apps\mobile\build\app\outputs\flutter-apk\"
""
Write-Host "  Dashboard:"
Write-Host "    https://dash.cloudflare.com/?to=workers"
""
