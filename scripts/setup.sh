#!/bin/bash
#
# PINKZ Development Setup Script
# Usage: ./scripts/setup.sh
#
# This script installs all dependencies, generates code,
# and runs database migrations for local development.
#

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# ──────────────────────────────────────────────
# Colors
# ──────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info()  { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_ok()    { echo -e "${GREEN}[OK]${NC}    $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ──────────────────────────────────────────────
# Prerequisite checks
# ──────────────────────────────────────────────
check_command() {
  if ! command -v "$1" &> /dev/null; then
    log_error "$1 is not installed. Please install it first."
    exit 1
  fi
  log_ok "$1 found: $($1 --version 2>&1 | head -n 1)"
}

log_info "Checking prerequisites..."

check_command flutter
check_command node
check_command npm

if command -v npx &> /dev/null && npx wrangler --version &> /dev/null 2>&1; then
  log_ok "wrangler found: $(npx wrangler --version 2>&1 | head -n 1)"
else
  log_warn "wrangler not found globally. It will be available via npx after npm ci."
fi

# ──────────────────────────────────────────────
# Install dependencies
# ──────────────────────────────────────────────
echo ""
log_info "Installing Flutter dependencies..."

cd apps/mobile
flutter pub get
cd "$ROOT_DIR"

for pkg in packages/core packages/ui; do
  if [ -f "$pkg/pubspec.yaml" ]; then
    log_info "Installing $pkg dependencies..."
    cd "$pkg"
    flutter pub get
    cd "$ROOT_DIR"
  fi
done

log_info "Installing backend dependencies..."
cd backend
npm ci
cd "$ROOT_DIR"

# ──────────────────────────────────────────────
# Environment setup
# ──────────────────────────────────────────────
if [ ! -f .env ]; then
  if [ -f .env.example ]; then
    cp .env.example .env
    log_info "Created .env from .env.example"
    log_warn "Please edit .env with your configuration values."
  else
    log_warn "No .env.example found. Skipping .env creation."
  fi
else
  log_ok ".env already exists"
fi

# ──────────────────────────────────────────────
# Code generation
# ──────────────────────────────────────────────
echo ""
log_info "Running code generation for packages/core..."
cd packages/core
dart run build_runner build --delete-conflicting-outputs 2>/dev/null || \
  log_warn "build_runner skipped (run 'dart run build_runner build' manually if needed)"
cd "$ROOT_DIR"

# ──────────────────────────────────────────────
# Database migrations
# ──────────────────────────────────────────────
echo ""
log_info "Running database migrations..."
cd backend
npx wrangler d1 migrations apply pinkz-db --local 2>/dev/null || \
  log_warn "D1 migrations skipped (ensure wrangler is configured and run manually)"
cd "$ROOT_DIR"

# ──────────────────────────────────────────────
# Success
# ──────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════"
echo -e "  ${GREEN}PINKZ setup complete!${NC}"
echo "═══════════════════════════════════════════"
echo ""
echo "  Next steps:"
echo ""
echo "  1. Edit .env with your secrets"
echo "  2. Start the backend:"
echo "     cd backend && npm run dev:api"
echo ""
echo "  3. Start the mobile app:"
echo "     cd apps/mobile && flutter run"
echo ""
echo "  4. Run code generation when models change:"
echo "     cd packages/core && dart run build_runner build"
echo ""
echo "  5. Apply DB migrations to remote:"
echo "     cd backend && npx wrangler d1 migrations apply pinkz-db --remote"
echo ""
