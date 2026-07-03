# Contributing to PINKZ

First off, thank you for considering contributing to PINKZ! We welcome contributions from everyone, whether it's a bug report, feature suggestion, documentation improvement, or a pull request.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Code Style](#code-style)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Commit Convention](#commit-convention)

## Code of Conduct

This project and everyone participating in it is governed by the [PINKZ Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How to Contribute

### Reporting Bugs

- Check existing issues to avoid duplicates
- Use the bug report template
- Include steps to reproduce, expected behavior, and actual behavior
- Include screenshots if applicable

### Suggesting Features

- Check existing issues and discussions first
- Describe the feature and its use case
- Explain why it would benefit the project

### Submitting Changes

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/amazing-feature`)
3. Commit your changes
4. Push to your fork (`git push origin feat/amazing-feature`)
5. Open a Pull Request

## Development Setup

1. Fork and clone the repository
2. Install dependencies:
   ```bash
   pnpm install
   ```
3. Set up environment variables:
   ```bash
   cp .env.example .env
   ```
4. Start the development environment:
   ```bash
   docker compose up -d
   pnpm dev
   ```

## Code Style

- **TypeScript / JavaScript**: We use ESLint and Prettier with the project's configuration. Run `pnpm lint` before committing.
- **Python**: Follow PEP 8 with a line length of 88 characters. We use `ruff` for linting and formatting.
- **CSS / Tailwind**: Follow the existing utility-first patterns. Avoid custom CSS unless necessary.
- **General**: Write clean, readable code with appropriate naming. Avoid deeply nested conditionals. Prefer early returns. Keep functions small and focused.

Run `pnpm format` to format your code automatically.

## Pull Request Process

1. Ensure your PR is focused on a single concern
2. Update documentation if you're changing behavior
3. Add or update tests as needed
4. Ensure all checks pass (CI / lint / tests / build)
5. Request review from at least one maintainer
6. Address review feedback promptly

## Testing

- **Frontend**: Vitest + React Testing Library
  ```bash
  cd apps/web && pnpm test
  ```
- **Backend**: Jest + Supertest
  ```bash
  cd backend && pnpm test
  ```
- **E2E**: Playwright
  ```bash
  pnpm test:e2e
  ```
- All new features should include tests covering success and error paths.

## Commit Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `chore`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `revert`

Examples:
- `feat(tasks): add recurrence support for task scheduling`
- `fix(auth): handle token refresh race condition`
- `docs(readme): update architecture diagram`

---

Thank you for helping make PINKZ better!
