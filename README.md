# asheeighe - AI Life OS

Built by **Halima Hafir**

**Your intelligent operating system for life.**

asheeighe is an open-source, AI-powered life operating system that helps you manage tasks, track habits, organize knowledge, and optimize your daily routines. It combines a modern Flutter frontend with a scalable Cloudflare Workers backend, all orchestrated by intelligent agents that learn and adapt to your unique workflow.

## Live Deployment

| Component | URL |
|-----------|-----|
| **Frontend** | https://asheeighe.pages.dev |
| **Backend API** | https://asheeighe-backend.asheeighe.workers.dev |
| **GitHub** | https://github.com/hafirhalima00-coder/pinkz-ai-life-os |

## Features

- **AI Task Manager** — Intelligent task prioritization and scheduling powered by machine learning
- **AI Chat** — Talk to your AI assistant about anything, get personalized advice
- **Smart Calendar** — AI-powered calendar with automatic event detection and conflict resolution
- **Knowledge Base** — Personal wiki with semantic search and auto-tagging
- **Islamic Hub** — Prayer times, Quran reader, Hadith collection, and Dhikr tracker
- **AI Code Tutor** — Learn to code with an AI tutor that adapts to your level (Premium)
- **Voice Engine** — Text-to-speech and speech-to-text in multiple languages
- **Social & Sharing** — Templates marketplace, referrals, and achievement sharing
- **Gamification** — XP, levels, badges, streaks, and leaderboards
- **Subscription System** — Free, Pro ($9.99/mo), and Premium ($19.99/mo) tiers

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile App | Flutter (iOS & Android) |
| Web App | Flutter Web (PWA) |
| Backend | Cloudflare Workers + Hono |
| Database | Cloudflare D1 (SQLite) |
| Storage | Cloudflare KV, R2 |
| AI | OpenAI, Gemini, Anthropic, Ollama, OpenRouter |
| Authentication | JWT with refresh tokens |
| CI/CD | GitHub Actions |
| E2E Testing | TestSprite |

## Test Coverage

This project uses [TestSprite](https://testsprite.com) for end-to-end testing against the live deployment.

### Test Results

| Test | Steps | Status |
|------|-------|--------|
| Homepage hero section | 3/3 | Passed |
| Features section cards | 3/3 | Passed |
| AI Chat demo | 12/12 | **PASSED** |
| Pricing section | 2/2 | Passed |
| Footer with credit | 2/2 | Passed |

All tests verify elements are visible and correctly rendered at https://asheeighe.pages.dev.

### Running Tests Locally

```bash
# Install TestSprite CLI
npm install -g @testsprite/testsprite-cli

# Setup
testsprite setup --api-key YOUR_API_KEY

# Run all tests
testsprite test run --all --project PROJECT_ID --wait --timeout 600
```

## Getting Started

### Prerequisites

- Flutter SDK 3.27+
- Node.js 20+
- Wrangler CLI

### Installation

```bash
# Clone the repository
git clone https://github.com/hafirhalima00-coder/pinkz-ai-life-os.git
cd pinkz-ai-life-os

# Install Flutter dependencies
cd apps/mobile
flutter pub get

# Run the app
flutter run
```

### Backend Deployment

```bash
cd backend

# Install dependencies
npm install

# Run migrations
npx wrangler d1 migrations apply asheeighe-db

# Deploy to Cloudflare Workers
npx wrangler deploy
```

## Project Structure

```
asheeighe/
├── apps/
│   ├── mobile/       # Flutter mobile app
│   └── web/          # Flutter web app (PWA)
├── backend/
│   ├── workers/      # Cloudflare Workers (API, Auth, Sync)
│   ├── packages/     # Shared packages (AI, DB, Social, etc.)
│   └── schemas/      # D1 SQL migrations
├── packages/
│   ├── ui/           # Shared UI components (AsheeigheTheme, AsheeigheColors)
│   ├── core/         # Core utilities and services
│   ├── services/     # Shared services layer
│   └── features/     # Feature modules
├── deploy/           # Static deployment files
├── testsprite/       # TestSprite test plans
├── docs/             # Documentation
└── .github/          # CI/CD workflows
```

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## License

Distributed under the Apache 2.0 License. See [LICENSE](LICENSE) for more information.

## Community

- [GitHub Issues](https://github.com/hafirhalima00-coder/pinkz-ai-life-os/issues) — Report bugs
- [GitHub Discussions](https://github.com/hafirhalima00-coder/pinkz-ai-life-os/discussions) — Ask questions

---

Built with love by **Halima Hafir**
