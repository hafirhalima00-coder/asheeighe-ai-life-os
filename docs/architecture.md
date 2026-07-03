# PINKZ Architecture

## Project Overview

PINKZ is an open-source, AI-powered life operating system. It helps users manage tasks, track habits, organize knowledge, and optimize daily routines. The system combines a Flutter mobile/web frontend with a Cloudflare Workers backend, orchestrated by intelligent agents that learn and adapt to user workflows.

---

## Clean Architecture Layers

Each feature follows Clean Architecture with three layers:

```
┌─────────────────────────────────────────────────┐
│                 Presentation                     │
│  (providers/ - Riverpod, screens/, widgets/)     │
├─────────────────────────────────────────────────┤
│                   Domain                         │
│  (entities/, repositories/ (abstract),           │
│   usecases/)                                     │
├─────────────────────────────────────────────────┤
│                   Data                           │
│  (datasources/ - remote + local,                 │
│   models/, repositories/ - impl)                 │
└─────────────────────────────────────────────────┘
```

### Presentation Layer (`lib/features/<feature>/presentation/`)

- **`providers/`** — Riverpod StateNotifier providers (feature state + logic)
- **`screens/`** — Full-page widgets (one per route)
- **`widgets/`** — Reusable UI components for the feature

### Domain Layer (`lib/features/<feature>/domain/`)

- **`entities/`** — Business objects (used across all layers) — shared from `packages/core`
- **`repositories/`** — Abstract repository contracts (interfaces)
- **`usecases/`** — Single-responsibility business logic classes

### Data Layer (`lib/features/<feature>/data/`)

- **`datasources/`** — Remote (Dio API calls) and local (Drift/Hive) data sources
- **`models/`** — JSON-serializable DTOs with `fromJson`/`toJson` (generated via `json_serializable`)
- **`repositories/`** — Concrete implementations of domain repository interfaces

---

## Feature-First Organization

```
lib/
├── main.dart
├── app/                          # App-wide setup
│   ├── app.dart                  # MaterialApp.router
│   ├── app_config.dart           # Constants (API URL, timeouts)
│   ├── navigation/
│   │   ├── app_shell.dart        # ShellRoute with bottom nav + drawer
│   │   ├── app_drawer.dart
│   │   ├── bottom_nav.dart       # Custom bottom nav bar
│   │   └── quick_action_fab.dart
│   └── theme/
│       └── app_theme.dart
├── core/                         # Shared infrastructure
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── network/
│   │   ├── api_client.dart       # Dio setup + interceptors
│   │   └── api_exceptions.dart
│   ├── notifications/
│   ├── router/
│   │   ├── app_router.dart       # GoRouter config
│   │   └── route_names.dart
│   └── utils/
└── features/                     # Feature modules
    ├── auth/                     # (data/domain/presentation)
    ├── calendar/
    ├── chat/
    ├── composio/
    ├── dashboard/
    ├── notes/
    ├── reminders/
    ├── settings/
    └── tasks/
```

### Shared Packages

```
packages/
├── core/                         # Shared domain models, providers, services
│   └── lib/src/
│       ├── models/               # User, Task, CalendarEvent, Reminder, Note, etc.
│       ├── providers/            # Auth, connectivity, theme, preferences providers
│       ├── services/             # Connectivity, local storage, notifications, prefs
│       └── utils/
├── ui/                           # Design system
│   └── lib/src/
│       ├── theme/                # PinkzColors, PinkzTypography, PinkzTheme
│       ├── tokens/               # Design tokens
│       └── widgets/              # Reusable components (buttons, inputs, cards, etc.)
├── features/                     # Cross-cutting feature logic (future)
└── services/                     # Shared service logic (future)
```

---

## State Management (Riverpod)

```
┌──────────────────────────────────────────────┐
│                   Widget                       │
│  ref.watch(provider) / ref.read(provider)     │
└─────────────────┬────────────────────────────┘
                  │
┌─────────────────▼────────────────────────────┐
│               Provider                         │
│  StateNotifierProvider / FutureProvider /      │
│  StreamProvider / Provider                     │
└─────────────────┬────────────────────────────┘
                  │
┌─────────────────▼────────────────────────────┐
│            StateNotifier                       │
│  emit(state.copyWith(...))                    │
│  (business logic + state mutation)            │
└─────────────────┬────────────────────────────┘
                  │
┌─────────────────▼────────────────────────────┐
│            Repository                          │
│  (abstract in domain, impl in data)           │
└─────────────────┬────────────────────────────┘
                  │
    ┌─────────────┴─────────────┐
    │           │               │
┌───▼───┐  ┌───▼───┐     ┌─────▼─────┐
│Remote │  │ Local │     │ Cache     │
│Source │  │Source │     │(Hive/SP)  │
└───────┘  └───────┘     └───────────┘
```

### Provider Patterns

| Type | Usage | Example |
|------|-------|---------|
| `StateNotifierProvider` | Mutable feature state | `AuthNotifier`, `ThemeModeNotifier` |
| `StreamProvider` | Reactive streams | `connectivityProvider` |
| `FutureProvider` | Async data loading | User profile fetch |
| `Provider` | Singletons / DI | `ApiClient`, `ConnectivityService` |

---

## Navigation (GoRouter)

```dart
GoRouter(
  redirect: (context, state) {
    // Check auth status on every navigation
    if (!authenticated && !isAuthRoute) return '/auth/login';
    if (authenticated && isAuthRoute) return '/dashboard';
    return null;
  },
  routes: [
    GoRoute('/splash'),
    GoRoute('/auth', routes: [
      GoRoute('login'),
      GoRoute('register'),
      GoRoute('forgot-password'),
    ]),
    ShellRoute(
      builder: AppShell,  // Bottom nav + drawer shell
      routes: [
        GoRoute('/dashboard'),
        GoRoute('/calendar'),
        GoRoute('/tasks'),
        GoRoute('/chat'),
        GoRoute('/settings', routes: [
          GoRoute('profile'),
          GoRoute('composio'),
        ]),
      ],
    ),
  ],
)
```

The `AppShell` renders the `PinkzNavigationBar` (compact) or `NavigationRail` (wide) plus an `AppDrawer` and `QuickActionFab`. It uses `LayoutBuilder` to switch layouts at 600px width.

Route names are centralized in `RouteNames` to avoid string duplication.

---

## Data Flow (Text-Based Diagrams)

### Read Flow (e.g., loading tasks)

```
Screen
  │ ref.watch(tasksProvider)
  ▼
TaskListProvider (StateNotifierProvider)
  │ calls repository.getTasks()
  ▼
TaskRepository (interface in domain)
  │
  ├──► TaskRepositoryImpl (in data)
  │       │
  │       ├──► RemoteDataSource (Dio → API)
  │       └──► LocalDataSource (Drift)
  │
  ├──► Returns Result<List<Task>>
  ▼
State: AsyncValue<List<Task>> → widget rebuilds
```

### Write Flow (e.g., creating a note)

```
User taps "Save"
  │
  ▼
TextEditingController.text
  │ref.read(notesProvider.notifier).createNote(title, content)
  ▼
NoteNotifier.createNote()
  │ state = copyWith(isLoading: true)
  │ repository.createNote(note)
  ▼
NoteRepositoryImpl
  │
  ├──► RemoteDataSource: POST /notes
  ├──► LocalDataSource: INSERT in Drift
  │
  ▼
state = copyWith(notes: [...notes, newNote], isLoading: false)
```

### Auth Flow

```
LoginScreen
  │ ref.read(authNotifierProvider.notifier).login(email, password)
  ▼
AuthNotifier.login()
  │ POST /auth/login
  ▼
API → JWT (access + refresh)
  │ Store tokens in FlutterSecureStorage
  │ Set Dio auth header
  ▼
state = AuthState(user: authenticatedUser)
  │
  ▼
GoRouter redirect detects authenticated → /dashboard
```

---

## Offline-First Strategy

```
┌─────────────┐     Online?     ┌─────────────┐
│   API Call  │ ──────┬──────►  │   Remote    │
│  (Repository)│      │yes      │  DataSource │
└─────────────┘      │         └──────┬──────┘
                     │                │
                     │no              ▼
                     │         ┌──────────────┐
                     │         │  Response    │
                     │         │  + cache to  │
                     │         │  local DB    │
                     ▼         └──────┬──────┘
              ┌─────────────┐         │
              │ Local       │◄────────┘
              │ DataSource  │
              │ (Drift +    │
              │  Hive)      │
              └─────────────┘
```

- **Connectivity monitoring**: `connectivity_plus` via `ConnectivityService` — exposes `Stream<bool>` via Riverpod
- **Local database**: Drift (SQLite) for structured data
- **Key-value cache**: Hive for lightweight caching
- **Secure storage**: `flutter_secure_storage` for JWT tokens
- **Retry mechanism**: Dio interceptor with exponential backoff (max 3 retries)

---

## Backend Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   Cloudflare Workers                      │
│                                                          │
│   auth worker         api worker         sync worker     │
│   (auth.pinkz.app)    (api.pinkz.app)  (sync.pinkz.app) │
│   JWT / PBKDF2        REST endpoints    CRDT sync        │
│                                                          │
│   composio worker                                        │
│   (composio.pinkz.app)                                   │
│   OAuth integrations                                     │
└─────────┬────────────┬──────────────┬───────────────────┘
          │            │              │
          ▼            ▼              ▼
┌─────────────────────────────────────────────────────────┐
│                    Cloudflare D1                          │
│                    (SQLite Database)                      │
│   users │ calendar_events │ tasks │ reminders │ notes    │
│   composio_connections                                   │
├─────────────────────────────────────────────────────────┤
│                    Cloudflare KV                          │
│   Session cache, rate limit counters, API keys           │
├─────────────────────────────────────────────────────────┤
│                    Cloudflare R2                          │
│   User avatars, note attachments, images                 │
└─────────────────────────────────────────────────────────┘
```

### Framework

The API uses **Hono** — a lightweight, fast web framework for Cloudflare Workers.

```
backend/
├── workers/
│   ├── api/          # Main REST API (Hono)
│   │   ├── src/
│   │   │   ├── index.ts          # App entry, middleware, route mounts
│   │   │   ├── types.ts          # AppEnv (bindings + variables)
│   │   │   ├── middleware/
│   │   │   │   ├── auth.ts       # JWT verification
│   │   │   │   └── rate-limit.ts # KV-based rate limiting
│   │   │   ├── routes/
│   │   │   │   ├── auth.ts
│   │   │   │   ├── calendar.ts
│   │   │   │   ├── tasks.ts
│   │   │   │   ├── reminders.ts
│   │   │   │   ├── notes.ts
│   │   │   │   ├── chat.ts
│   │   │   │   ├── composio.ts
│   │   │   │   └── users.ts
│   │   │   └── services/
│   │   │       └── skill-registry.ts
│   │   └── wrangler.jsonc
│   ├── auth/         # Dedicated auth worker (separate deployment)
│   ├── composio/     # Composio integration worker
│   └── sync/         # Cross-device sync worker
├── packages/
│   ├── core/         # Shared types, error classes, utilities
│   ├── ai/           # AI provider abstraction
│   │   └── src/providers/
│   │       ├── openai.ts
│   │       ├── gemini.ts
│   │       ├── anthropic.ts
│   │       ├── ollama.ts
│   │       └── openrouter.ts
│   ├── db/           # Database abstraction layer
│   └── composio-client/  # Composio HTTP client
├── schemas/          # D1 migration files
├── wrangler.jsonc    # Root wrangler config
└── package.json
```

### Environment Bindings (wrangler.jsonc)

```jsonc
{
  "d1_databases": [{ "binding": "DB", "database_name": "pinkz-db" }],
  "kv_namespaces": [{ "binding": "KV", "id": "pinkz-kv" }],
  "r2_buckets": [{ "binding": "R2", "bucket_name": "pinkz-assets" }],
  "vars": {
    "JWT_SECRET": "",
    "JWT_REFRESH_SECRET": "",
    "OPENAI_API_KEY": "",
    "GEMINI_API_KEY": "",
    "ANTHROPIC_API_KEY": "",
    "OLLAMA_BASE_URL": "http://localhost:11434",
    "OPENROUTER_API_KEY": "",
    "COMPOSIO_API_KEY": "",
    "APP_URL": "http://localhost:8787"
  }
}
```

### Database Schema (D1 Migrations)

| Migration | Table | Purpose |
|-----------|-------|---------|
| `001_users.sql` | `users` | Core identity, password hash, preferences |
| `002_calendar_events.sql` | `calendar_events` | Events with recurrence, external provider links |
| `003_tasks.sql` | `tasks` | Tasks with priority, status, recurrence, subtasks |
| `004_reminders.sql` | `reminders` | Time-based reminders linked to entities |
| `005_notes.sql` | `notes` | Rich text / markdown notes with pin/archive |
| `006_composio_connections.sql` | `composio_connections` | Third-party OAuth connections |

---

## AI Abstraction Layer

The `backend/packages/ai/` package provides a unified interface for multiple AI providers:

```typescript
interface AIProvider {
  type: AIProviderType;
  chat(messages, options?): Promise<ChatCompletionResponse>;
  chatStream(messages, options?): Promise<ReadableStream>;
  embed?(text): Promise<number[]>;
  isAvailable(): boolean;
}
```

Supported providers: OpenAI | Gemini | Anthropic | Ollama (local) | OpenRouter

Selection happens at runtime based on `AIProviderConfig.type`. The `skill-registry.ts` maps natural language intents to tool-calling actions (e.g., "create a task" triggers the task creation skill).

---

## Composio Integration

Composio is used for third-party service integrations (Google Calendar, Slack, Notion, etc.).

```
App → PINKZ API → Composio Client → Composio Backend → Third-Party API
```

The `ComposioClient` class handles:
- Listing available integrations
- Initiating OAuth connections (returns redirect URL)
- Validating and checking connection status
- Executing actions on connected services
- Managing triggers for real-time events

Connections are stored in the `composio_connections` D1 table with a foreign key to `users`.

---

## Authentication Flow

```
┌──────────┐         ┌──────────┐         ┌──────────┐
│  Mobile  │         │   Auth   │         │   D1     │
│   App    │         │  Worker  │         │  DB      │
└────┬─────┘         └────┬─────┘         └────┬─────┘
     │                    │                    │
     │  POST /register    │                    │
     │  {email, password} │                    │
     │───────────────────►│                    │
     │                    │  Check existing    │
     │                    │───────────────────►│
     │                    │◄───────────────────│
     │                    │  PBKDF2 hash       │
     │                    │  INSERT user       │
     │                    │───────────────────►│
     │                    │◄───────────────────│
     │  {accessToken,     │                    │
     │   refreshToken}    │                    │
     │◄───────────────────│                    │
     │                    │                    │
     │  Store tokens in   │                    │
     │  FlutterSecureStorage                   │
     │                    │                    │
```

- **Password hashing**: PBKDF2 with 100,000 iterations + 128-bit salt
- **Access token**: HS256 JWT, 15-minute expiry
- **Refresh token**: HS256 JWT with `type: 'refresh'`, 7-day expiry
- **Token refresh**: Automatic via Dio interceptor on 401

---

## Sync Strategy

The sync worker handles cross-device data synchronization:

- Conflict resolution via last-write-wins (LWW) using `updated_at` timestamps
- Batched delta sync — only changed records since last sync timestamp
- Offline queue — writes are persisted locally and replayed on reconnection
- KV stores per-device sync cursors

---

## Security Considerations

| Area | Implementation |
|------|---------------|
| Password storage | PBKDF2 + salt, 100k iterations |
| Transport | HTTPS enforced, HSTS |
| Auth tokens | Short-lived access (15m) + refresh (7d) tokens |
| Token storage | `flutter_secure_storage` (Keychain/Keystore) |
| Rate limiting | KV-based per-IP limiting |
| CORS | Whitelist origins (`pinkz.app`, `localhost:5173`) |
| Input validation | Zod schemas on all endpoints |
| SQL injection | Parameterized queries (D1 prepared statements) |
| Secrets | Never committed — wrangler secrets or `.env` |
| External APIs | API keys stored as Worker secrets, not in code |

---

## Performance Considerations

- **Riverpod `autoDispose`**: Providers automatically dispose when no longer watched
- **Lazy loading**: Feature modules only load when navigated to
- **Drift (SQLite)**: Efficient local queries with indexes
- **D1 indexes**: Composite indexes on `(user_id, status)`, `(user_id, start_time)` etc.
- **KV caching**: Rate limit counters and session data in edge cache
- **R2 offload**: File uploads stream directly to R2, not through the Worker
- **Streaming responses**: AI chat uses `ReadableStream` for token-by-token delivery
- **Tree shaking**: Freezed + json_serializable generate compact code
