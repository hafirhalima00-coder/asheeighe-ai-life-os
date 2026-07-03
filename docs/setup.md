# PINKZ Setup Guide

## Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Flutter | 3.4+ | Mobile/web app |
| Dart SDK | ^3.4.0 | Inherited from Flutter |
| Node.js | 22+ | Backend (Workers) |
| npm | 10+ | Package management |
| Wrangler | ^4.14.0 | Cloudflare Workers CLI |

## Clone Repository

```bash
git clone https://github.com/your-org/pinkz.git
cd pinkz
```

## Install Flutter Dependencies

```bash
# Mobile application
cd apps/mobile
flutter pub get
cd ../..

# Shared packages
cd packages/core
flutter pub get
cd ../..

cd packages/ui
flutter pub get
cd ../..
```

## Install Backend Dependencies

```bash
cd backend
npm ci
cd ..
```

## Environment Variables

```bash
# Copy the example env file
cp .env.example .env
```

Required variables:

| Variable | Description | Source |
|----------|-------------|--------|
| `JWT_SECRET` | JWT signing secret (access tokens) | Generate via `openssl rand -hex 32` |
| `JWT_REFRESH_SECRET` | JWT signing secret (refresh tokens) | Generate via `openssl rand -hex 32` |
| `OPENAI_API_KEY` | OpenAI API key | [platform.openai.com](https://platform.openai.com) |
| `GEMINI_API_KEY` | Google Gemini API key | [makersuite.google.com](https://makersuite.google.com) |
| `ANTHROPIC_API_KEY` | Anthropic API key | [console.anthropic.com](https://console.anthropic.com) |
| `OPENROUTER_API_KEY` | OpenRouter API key | [openrouter.ai](https://openrouter.ai) |
| `COMPOSIO_API_KEY` | Composio API key | [composio.dev](https://composio.dev) |

For local development with Ollama, set `OLLAMA_BASE_URL=http://localhost:11434` (default).

### Setting Worker Secrets

```bash
cd backend
echo "my-jwt-secret" | npx wrangler secret put JWT_SECRET
echo "my-refresh-secret" | npx wrangler secret put JWT_REFRESH_SECRET
echo "sk-..." | npx wrangler secret put OPENAI_API_KEY
```

## Running Mobile App

### Android

```bash
cd apps/mobile
flutter run
```

### iOS

```bash
cd apps/mobile
flutter run
```

### Web

```bash
cd apps/mobile
flutter run -d chrome
```

## Running Backend

Start individual Workers in development mode:

```bash
cd backend

# API Worker (main endpoints)
npx wrangler dev --config workers/api/wrangler.jsonc

# Auth Worker (separate)
npx wrangler dev --config workers/auth/wrangler.jsonc

# Or use npm scripts:
npm run dev:api
npm run dev:auth
npm run dev:composio
npm run dev:sync
```

The API will be available at `http://localhost:8787`.

## Database Migrations

```bash
cd backend

# Create a new migration
npx wrangler d1 migrations create pinkz-db <migration_name>

# Apply migrations
npx wrangler d1 migrations apply pinkz-db

# Apply to local/remote DB
npx wrangler d1 migrations apply pinkz-db --local
npx wrangler d1 migrations apply pinkz-db --remote
```

## Code Generation

Freezed and JSON serializable models need code generation:

```bash
cd packages/core
dart run build_runner build --delete-conflicting-outputs
```

## Building for Production

### Mobile (Android)

```bash
cd apps/mobile
flutter build apk --release
```

### Mobile (iOS)

```bash
cd apps/mobile
flutter build ios --release
```

### Web

```bash
cd apps/mobile
flutter build web --release
```

### Backend

```bash
cd backend
npx wrangler deploy --config workers/api/wrangler.jsonc
npx wrangler deploy --config workers/auth/wrangler.jsonc
npx wrangler deploy --config workers/composio/wrangler.jsonc
npx wrangler deploy --config workers/sync/wrangler.jsonc
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `flutter pub get` fails | Check Dart SDK version (`dart --version`). Ensure Flutter 3.4+ |
| Build runner conflicts | Use `dart run build_runner build --delete-conflicting-outputs` |
| CORS errors | Ensure `APP_URL` matches your local dev URL |
| D1 migration fails | Run `npx wrangler d1 migrations apply pinkz-db --local` to test locally |
| Worker not found | Run `npx wrangler deploy` first, or use `--local` for local dev |
| Missing secrets | All secrets must be set via `wrangler secret put` before deploy |
| Port already in use | Use `--port <PORT>` flag with `wrangler dev` |
| Hive initialization error | Ensure `Hive.initFlutter()` is called before any box operations |
| Dio timeout | Check `AppConfig.connectTimeout` (default 30s). Verify backend is running |
