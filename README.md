# asheeighe - AI Life OS

Built by Halima Hafir

**Your intelligent operating system for life.**

asheeighe is an open-source, AI-powered life operating system that helps you manage tasks, track habits, organize knowledge, and optimize your daily routines. It combines a modern web frontend with a scalable backend, all orchestrated by intelligent agents that learn and adapt to your unique workflow.

## Features

- **AI Task Manager** — Intelligent task prioritization and scheduling powered by machine learning
- **Habit Tracker** — Build and maintain healthy routines with adaptive reminders and streak analytics
- **Knowledge Base** — Personal wiki with semantic search and auto-tagging
- **Dashboard** — At-a-glance overview of your day, week, and month with customizable widgets
- **Smart Insights** — Pattern recognition and productivity recommendations
- **Cross-Platform Sync** — Seamless synchronization across all your devices
- **Privacy First** — End-to-end encryption and self-hosting support
- **Extensible** — Plugin system for custom integrations and workflows

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Next.js 14+ (App Router), React 18, TypeScript, Tailwind CSS |
| Mobile | React Native (iOS & Android) |
| Backend | Node.js / Express, Python (AI/ML microservices) |
| Database | PostgreSQL (primary), Redis (caching & queues), vector store (embeddings) |
| AI/ML | LangChain, OpenAI API, custom fine-tuned models |
| Infrastructure | Docker, Kubernetes, GitHub Actions CI/CD |
| Monitoring | Prometheus, Grafana, Sentry |

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│                   Clients                        │
│  Web (Next.js)  │  Mobile (React Native)        │
└──────────────────────┬──────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────┐
│                API Gateway                       │
│         (Express / GraphQL)                      │
└────┬─────────┬──────────┬──────────────┬────────┘
     │         │          │              │
┌────▼──┐ ┌───▼────┐ ┌───▼──────┐ ┌─────▼──────┐
│ Auth  │ │ Tasks  │ │ Habits   │ │ Knowledge  │
│Service│ │Service │ │ Service  │ │ Service    │
└──┬────┘ └───┬────┘ └───┬──────┘ └─────┬──────┘
   │          │          │              │
┌──▼──────────▼──────────▼──────────────▼──────┐
│              AI Orchestrator                   │
│     (LangChain Agents + Vector Store)          │
└───────────────────────────────────────────────┘
```

The system follows a microservices architecture with an AI orchestrator layer that powers intelligent features across all domains.

## Getting Started

### Prerequisites

- Node.js 20+
- Python 3.11+
- Docker & Docker Compose
- PostgreSQL 16
- Redis 7+

### Installation

```bash
# Clone the repository
git clone https://github.com/your-org/asheeighe.git
cd asheeighe

# Install frontend dependencies
cd apps/web
pnpm install

# Install backend dependencies
cd ../../backend
pnpm install
pip install -r requirements.txt

# Configure environment
cp .env.example .env
# Edit .env with your configuration

# Start development environment
docker compose up -d
pnpm dev
```

Visit `http://localhost:3000` to see the app running.

## Project Structure

```
asheeighe/
├── apps/
│   ├── web/          # Next.js web application
│   └── mobile/       # React Native mobile app
├── backend/
│   ├── api/          # API gateway & services
│   ├── ai/           # AI/ML microservices
│   └── workers/      # Background job processors
├── packages/
│   ├── shared/       # Shared types and utilities
│   ├── ui/           # Design system components
│   └── sdk/          # Client SDK
├── docs/             # Documentation
├── scripts/          # Development and deployment scripts
└── .github/          # CI/CD workflows
```

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

Please note that this project follows a [Code of Conduct](CODE_OF_CONDUCT.md) to foster an inclusive community.

## Roadmap

Check out our [ROADMAP.md](ROADMAP.md) to see what's coming next.

## License

Distributed under the Apache 2.0 License. See [LICENSE](LICENSE) for more information.

## Community

- [Discord](https://discord.gg/asheeighe) — Join the discussion
- [Twitter](https://twitter.com/asheeighe_os) — Follow for updates
- [GitHub Discussions](https://github.com/your-org/asheeighe/discussions) — Ask questions and share ideas

---

Built with love by Halima Hafir
