#!/usr/bin/env pwsh
<#
.SYNOPSIS
    PINKZ Development Setup Script (Windows)
.DESCRIPTION
    Installs dependencies, generates code, and runs database migrations
    for PINKZ local development on Windows.
#>

$ErrorActionPreference = "Stop"
$ROOT_DIR = Split-Path -Parent (Split-Path -Parent $PSCommandPath)

function Write-Info   { Write-Host "[INFO]  $args" -ForegroundColor Blue }
function Write-Ok     { Write-Host "[OK]    $args" -ForegroundColor Green }
function Write-Warn   { Write-Host "[WARN]  $args" -ForegroundColor Yellow }
function Write-Error  { Write-Host "[ERROR] $args" -ForegroundColor Red; exit 1 }

# ──────────────────────────────────────────────
# Prerequisite checks
# ──────────────────────────────────────────────
Write-Info "Checking prerequisites..."

$prereqs = @(
  @{ Name = "flutter"; Command = "flutter --version" }
  @{ Name = "node";    Command = "node --version" }
  @{ Name = "npm";     Command = "npm --version" }
)

foreach ($p in $prereqs) {
  try {
    $ver = Invoke-Expression $p.Command
    Write-Ok "$($p.Name) found: $($ver.Trim().Split("`n")[0])"
  } catch {
    Write-Error "$($p.Name) is not installed. Please install it first."
  }
}

try {
  $wranglerVer = npx wrangler --version 2>&1
  Write-Ok "wrangler found: $($wranglerVer.Trim())"
} catch {
  Write-Warn "wrangler will be available via npx after npm ci."
}

# ──────────────────────────────────────────────
# Install dependencies
# ──────────────────────────────────────────────
""
Write-Info "Installing Flutter dependencies..."

Push-Location "$ROOT_DIR\apps\mobile"
try {
  flutter pub get
  if ($LASTEXITCODE -ne 0) { throw "flutter pub get failed" }
} finally {
  Pop-Location
}

$pkgDirs = @("packages\core", "packages\ui")
foreach ($pkg in $pkgDirs) {
  $pubspec = "$ROOT_DIR\$pkg\pubspec.yaml"
  if (Test-Path $pubspec) {
    Write-Info "Installing $pkg dependencies..."
    Push-Location "$ROOT_DIR\$pkg"
    try {
      flutter pub get
      if ($LASTEXITCODE -ne 0) { throw "flutter pub get failed for $pkg" }
    } finally {
      Pop-Location
    }
  }
}

Write-Info "Installing backend dependencies..."
Push-Location "$ROOT_DIR\backend"
try {
  npm ci
  if ($LASTEXITCODE -ne 0) { throw "npm ci failed" }
} finally {
  Pop-Location
}

# ──────────────────────────────────────────────
# Environment setup
# ──────────────────────────────────────────────
$envFile = "$ROOT_DIR\.env"
$envExample = "$ROOT_DIR\.env.example"

if (-not (Test-Path $envFile)) {
  if (Test-Path $envExample) {
    Copy-Item $envExample $envFile
    Write-Info "Created .env from .env.example"
    Write-Warn "Please edit .env with your configuration values."
  } else {
    Write-Warn "No .env.example found. Skipping .env creation."
  }
} else {
  Write-Ok ".env already exists"
}

# ──────────────────────────────────────────────
# Code generation
# ──────────────────────────────────────────────
""
Write-Info "Running code generation for packages/core..."
Push-Location "$ROOT_DIR\packages\core"
try {
  dart run build_runner build --delete-conflicting-outputs
  if ($LASTEXITCODE -ne 0) { throw "build_runner failed" }
} catch {
  Write-Warn "build_runner skipped (run manually if needed)"
} finally {
  Pop-Location
}

# ──────────────────────────────────────────────
# Database migrations
# ──────────────────────────────────────────────
""
Write-Info "Running database migrations..."
Push-Location "$ROOT_DIR\backend"
try {
  npx wrangler d1 migrations apply pinkz-db --local
  if ($LASTEXITCODE -ne 0) { throw "D1 migrations failed" }
} catch {
  Write-Warn "D1 migrations skipped (configure wrangler and run manually)"
} finally {
  Pop-Location
}

# ──────────────────────────────────────────────
# Success
# ──────────────────────────────────────────────
""
Write-Host "═══════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "  PINKZ setup complete!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════" -ForegroundColor Magenta
""
Write-Host "  Next steps:"
""
Write-Host "  1. Edit .env with your secrets"
Write-Host "  2. Start the backend:"
Write-Host "     cd backend; npm run dev:api"
""
Write-Host "  3. Start the mobile app:"
Write-Host "     cd apps\mobile; flutter run"
""
Write-Host "  4. Run code generation when models change:"
Write-Host "     cd packages\core; dart run build_runner build"
""
Write-Host "  5. Apply DB migrations to remote:"
Write-Host "     cd backend; npx wrangler d1 migrations apply pinkz-db --remote"
""
