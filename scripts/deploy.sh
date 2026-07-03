#!/bin/bash
#
# PINKZ Deployment Script
# Usage: ./scripts/deploy.sh
#
# Deploys the backend to Cloudflare Workers and builds
# the Flutter app for production.
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
NC='\033[0m'

log_info()  { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_ok()    { echo -e "${GREEN}[OK]${NC}    $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ──────────────────────────────────────────────
# Required secrets check
# ──────────────────────────────────────────────
REQUIRED_SECRETS=(
  "JWT_SECRET"
  "JWT_REFRESH_SECRET"
  "OPENAI_API_KEY"
  "COMPOSIO_API_KEY"
)

log_info "Checking required secrets..."
cd backend

MISSING_SECRETS=()
for secret in "${REQUIRED_SECRETS[@]}"; do
  if npx wrangler secret list 2>/dev/null | grep -q "$secret"; then
    log_ok "$secret is set"
  else
    MISSING_SECRETS+=("$secret")
  fi
done

if [ ${#MISSING_SECRETS[@]} -gt 0 ]; then
  log_warn "The following secrets are not set:"
  for s in "${MISSING_SECRETS[@]}"; do
    echo "  - $s"
  done
  echo ""
  echo "Set them with:"
  echo "  echo \"your-value\" | npx wrangler secret put SECRET_NAME"
  echo ""
  read -rp "Continue anyway? (y/N) " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_error "Deployment cancelled."
    exit 1
  fi
fi

cd "$ROOT_DIR"

# ──────────────────────────────────────────────
# Deploy backend Workers
# ──────────────────────────────────────────────
echo ""
log_info "Deploying API Worker..."
cd backend
npx wrangler deploy --config workers/api/wrangler.jsonc
cd "$ROOT_DIR"

log_info "Deploying Auth Worker..."
cd backend
npx wrangler deploy --config workers/auth/wrangler.jsonc
cd "$ROOT_DIR"

log_info "Deploying Composio Worker..."
cd backend
npx wrangler deploy --config workers/composio/wrangler.jsonc
cd "$ROOT_DIR"

log_info "Deploying Sync Worker..."
cd backend
npx wrangler deploy --config workers/sync/wrangler.jsonc
cd "$ROOT_DIR"

# ──────────────────────────────────────────────
# Database migrations (remote)
# ──────────────────────────────────────────────
echo ""
log_info "Running remote database migrations..."
cd backend
npx wrangler d1 migrations apply pinkz-db --remote
cd "$ROOT_DIR"

# ──────────────────────────────────────────────
# Build Flutter app
# ──────────────────────────────────────────────
echo ""
log_info "Building Flutter web app for production..."
cd apps/mobile
flutter build web --release
cd "$ROOT_DIR"

log_info "Building Flutter Android APK..."
cd apps/mobile
flutter build apk --release
cd "$ROOT_DIR"

# ──────────────────────────────────────────────
# Print deployment URLs
# ──────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════"
echo -e "  ${GREEN}Deployment complete!${NC}"
echo "═══════════════════════════════════════════"
echo ""
echo "  Backend URLs:"
echo "    API Worker:      https://api.pinkz.app"
echo "    Auth Worker:     https://auth.pinkz.app"
echo "    Composio Worker: https://composio.pinkz.app"
echo "    Sync Worker:     https://sync.pinkz.app"
echo ""
echo "  Build outputs:"
echo "    Web:    apps/mobile/build/web/"
echo "    Android: apps/mobile/build/app/outputs/flutter-apk/"
echo ""
echo "  Dashboard:"
echo "    https://dash.cloudflare.com/?to=workers"
echo ""
