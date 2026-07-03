# Contributing to PINKZ

## Code Style Guide

- Follow the [Flutter style guide](https://dart.dev/effective-dart)
- Use `dart format` before committing (line length: 80 chars)
- Prefer `const` constructors where possible
- Avoid `dynamic` — use proper typing or `Object?`
- Use `sealed class` / `freezed` for state classes
- Keep widget build methods small — extract widgets or methods

## Naming Conventions

| Category | Convention | Example |
|----------|-----------|---------|
| Files | `snake_case` | `task_model.dart`, `auth_provider.dart` |
| Classes | `PascalCase` | `TaskRepository`, `AuthNotifier` |
| Variables | `camelCase` | `currentUser`, `isLoading` |
| Private members | `_camelCase` | `_dio`, `_handleError` |
| Constants | `camelCase` | `connectTimeout`, `maxRetries` |
| Providers | `camelCase` | `authProvider`, `tasksProvider` |
| Routes | `camelCase` | `RouteNames.taskDetail` |
| Directories | `snake_case` | `data/`, `domain/`, `presentation/` |
| SQL tables | `snake_case` | `calendar_events`, `composio_connections` |
| SQL columns | `snake_case` | `user_id`, `created_at` |
| Enums | `PascalCase` values | `TaskPriority.high`, `TaskStatus.done` |

## Riverpod Best Practices

### Provider Organization

```
lib/features/<feature>/presentation/providers/
├── <feature>_state.dart        # State class (freezed)
├── <feature>_notifier.dart     # StateNotifier
└── <feature>_provider.dart     # Provider definitions
```

### Patterns

- Use `StateNotifierProvider` for mutable feature state
- Use `Provider` for dependency injection (services, repositories)
- Use `FutureProvider` for one-shot async data loading
- Use `StreamProvider` for reactive streams (connectivity, real-time)
- Use `ref.watch` for reactively rebuilding widgets
- Use `ref.read` only in callbacks (button presses, etc.)
- Prefer `.autoDispose` for ephemeral state (list screens, forms)
- Keep notifiers testable — inject dependencies via constructor

```dart
// GOOD
final tasksProvider = StateNotifierProvider.autoDispose<TasksNotifier, TasksState>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TasksNotifier(repository);
});

// AVOID
class TasksNotifier extends StateNotifier<TasksState> {
  TasksNotifier() : super(const TasksState()); // no DI
}
```

## Testing Guide

### Unit Tests

Located next to source files as `*.test.dart`.

```bash
cd apps/mobile
flutter test

cd packages/core
flutter test
```

### Widget Tests

```bash
flutter test test/widgets/
```

### Integration Tests

```bash
flutter test integration_test/
```

### Backend Tests

```bash
cd backend
npx vitest run
npx vitest  # watch mode
```

### Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### What to Test

| Layer | What | Tools |
|-------|------|-------|
| Domain (use cases) | Business logic, edge cases | `mocktail` for repository mocks |
| Data (repositories) | API + DB integration, error handling | `mocktail`, `DioMock` |
| Data (models) | JSON serialization round-trip | `json_serializable` |
| Presentation (providers) | State transitions | `mocktail`, Riverpod `ProviderContainer` |
| Presentation (widgets) | Rendering, user interaction | `flutter_test`, `WidgetTester` |
| Backend (routes) | Request/response, validation | `vitest`, Hono testing utilities |

## PR Review Process

1. **Create a feature branch** from `main`:
   ```bash
   git checkout -b feat/my-feature
   ```
2. **Write tests** for new functionality
3. **Run typecheck and tests**:
   ```bash
   cd apps/mobile && flutter analyze && flutter test
   cd backend && npm run typecheck && npm test
   ```
4. **Keep PRs focused** — one feature/fix per PR
5. **Link related issues** in the PR description
6. **Request review** from at least one maintainer
7. **Address feedback** with additional commits (no squash until merge)
8. **Squash merge** with a clean commit message

## Commit Message Conventions

PINKZ uses **Conventional Commits**:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

| Type | Usage |
|------|-------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code change with no feature/fix |
| `docs` | Documentation only |
| `style` | Formatting, missing semicolons, etc. |
| `test` | Adding or fixing tests |
| `chore` | Build, CI, dependencies |
| `perf` | Performance improvement |
| `db` | Database migration |

### Scopes

`mobile`, `web`, `api`, `auth`, `composio`, `sync`, `core`, `ui`, `ai`, `db`

### Examples

```
feat(tasks): add drag-and-drop reordering

fix(auth): handle token refresh race condition

docs(api): update calendar endpoint examples

db: add composio_connections table

refactor(core): extract base repository class
```

## Feature Development Workflow

```
1. Identify need ─► Create GitHub Issue
2. Discuss ─► Comment on issue, gather requirements
3. Branch ─► git checkout -b feat/feature-name
4. Domain first ─► Define entities, repository interface, use cases
5. Data layer ─► Implement remote/local datasources + repository
6. Presentation ─► Create provider (StateNotifier), screens, widgets
7. Tests ─► Unit tests for all layers
8. Typecheck ─► dart analyze, npm run typecheck
9. PR ─► Push, open PR, request review
10. Merge ─► Squash into main
```

### Feature Structure Checklist

```
lib/features/<feature>/
├── data/
│   ├── datasources/
│   │   ├── <feature>_remote_datasource.dart
│   │   └── <feature>_local_datasource.dart
│   ├── models/
│   │   └── <feature>_model.dart     # DTO with json_serializable
│   └── repositories/
│       └── <feature>_repository_impl.dart
├── domain/
│   ├── entities/                     # (re-exported from core or defined here)
│   ├── repositories/
│   │   └── <feature>_repository.dart # abstract interface
│   └── usecases/                     # optional, for complex logic
└── presentation/
    ├── providers/
    │   ├── <feature>_state.dart      # freezed state
    │   ├── <feature>_notifier.dart   # StateNotifier
    │   └── <feature>_provider.dart   # Provider definitions
    ├── screens/
    │   └── <feature>_screen.dart
    └── widgets/
        └── <feature>_widget.dart
```
