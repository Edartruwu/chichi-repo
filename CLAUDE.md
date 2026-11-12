# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Layout

Two independent apps plus shared local infrastructure:

- `backend/` — Go API (Fiber v2, sqlx + Postgres, Redis), scaffolded with the `manifesto` CLI. Module path `github.com/Edartruwu/chichi-repo/backend`.
- `frontend/` — TanStack Start (React 19, SSR) + shadcn/ui, managed with **bun**.
- `docker-compose.yml` — Postgres 16 + Redis 7 for local dev. It is the only compose file; `backend/Makefile` points at it.

The frontend does not talk to the backend yet: there is no API client or env config, and `src/routes/index.tsx` is still the starter page.

## Commands

Run from the repo root. `make help` lists every target; any `backend/Makefile` target is reachable as `make backend-<name>`.

| Task | Command |
|------|---------|
| First-time setup (deps, Postgres + Redis, migrations) | `make setup` |
| Run everything (API on :8080, web on :3000) | `make dev` |
| Run one side | `make dev-backend` / `make dev-frontend` |
| Backend tests | `make test` |
| Single backend test | `cd backend && go test ./internal/iam/role/rolesrv -run TestGrantCoverage -v` |
| Lint both (golangci-lint, eslint + tsc) | `make lint` (or `lint-backend` / `lint-frontend`) |
| Build both | `make build` |
| Apply migrations | `make migrate` |
| New migration | `make backend-migrate-create name=add_things` |
| DB / Redis shells | `make psql` / `make redis-cli` |
| Show effective backend config | `make backend-env` |
| Format | `make backend-fmt`; `cd frontend && bun run format` |
| Add a shadcn component | `cd frontend && bunx shadcn@latest add <name>` |

Things that are easy to get wrong:

- **Start the API through make.** All backend configuration is environment variables exported by `backend/Makefile`; nothing loads a `.env` file. A bare `go run ./cmd` starts with an empty `JWT_SECRET_KEY` and other code defaults.
- Backend tests use stub repositories and need neither Postgres nor Redis. The frontend has no test runner.
- `make reset`, `backend-db-clean`, `backend-db-restore` and `backend-redis-flush` wait for a typed confirmation on stdin and destroy local data.
- If 5432 or 6379 is taken: `make up dev POSTGRES_PORT=5433 REDIS_PORT=6380`.
- Lint does not pass on the scaffold as generated: golangci-lint reports about 60 findings (mostly `errcheck`, in `internal/ai` and `internal/iam`), and eslint/tsc fail on generated files under `frontend/src/components/ui` and on `src/lib/highlighter.tsx`. Judge a change by the findings it adds.

## Backend

### Manifesto scaffold

`backend/manifesto.yaml` records the modules installed by the `manifesto` CLI. Comments of the form `// manifesto:<name>` in `cmd/server.go`, `cmd/container.go`, `internal/config/config.go` and `backend/Makefile` are the anchors where `manifesto add <module>` and `manifesto add pkg/<context>/<domain>` inject code. Keep them in place and add hand-written wiring next to them.

### Composition

- `cmd/server.go` builds the Fiber app: middleware, route registration, and `globalErrorHandler`.
- `cmd/container.go` opens Postgres and Redis (both required at startup) and builds the module containers: `IAM`, `JobClient` (jobx), `NotifxClient`, `FileSystem` (fsx).
- `internal/iam/iamcontainer` wires the whole IAM graph in order: repositories → services → handlers → middleware. It exposes services for other modules and handlers for `cmd/`.

Route registration order matters. IAM handlers are registered first on an unauthenticated `/api/v1` group and apply their own auth per route. Application routes go on the `protected` group (`/api/v1` with `Authenticate()`), registered after it; public application routes go above it at the `manifesto:public-routes` marker. Fiber matches in registration order.

### Domain package shape

Every IAM sub-domain (`user`, `tenant`, `role`, `invitation`, `apikey`, `otp`) follows the same split, and new domains should too:

- `<domain>/<domain>.go` — entity, DTOs, request structs with `Validate()`, and the module's `errx` registry with `ErrXxx()` constructors.
- `<domain>/port.go` — repository and collaborator interfaces.
- `<domain>srv/` — service layer (business rules, authorization).
- `<domain>infra/` — Postgres implementation over sqlx.
- `<domain>api/` — Fiber handlers exposing `RegisterRoutes(router, middleware)`.

### Auth and tenancy

- `auth.UnifiedAuthMiddleware.Authenticate()` accepts a JWT (Bearer header or `access_token` cookie) or an API key, and stores a `kernel.AuthContext` (actor, tenant, scopes) that handlers read with `auth.GetAuthContext(c)`. `AuthenticateUserJWT()` is for routes that must be a human session.
- Authorization is checked twice on purpose: `middleware.RequireScope(...)` on the route, and `authz.Require(authCtx, tenantID, scope)` as the first statement of each service method. The `*srv/authorization_test.go` files assert that no repository is touched before that check.
- The tenant ID always comes from the `AuthContext`, never from the request body, and repository methods for tenant-owned data take a `tenantID` and filter on `tenant_id`.
- Scopes are `resource:action`, with `resource:*` and `*` as wildcards inside one tenant. `kernel.MatchScope` denies anything prefixed `platform:`. New scopes are declared in `internal/iam/scopes/scopes.go`, both as a constant and in `ScopeCategories`.

### Conventions

- Handlers return errors; `globalErrorHandler` renders `*errx.Error` as JSON. Each module creates `errx.NewRegistry("PREFIX")`, and codes come out as `PREFIX_CODE`. `errors.Is` matches `errx` errors by code, so `errors.Is(err, role.ErrRoleNotFound())` works.
- Parse request bodies with `kernel.BindAndValidate[T](c)`; `T` needs a pointer-receiver `Validate() error`.
- IDs are typed strings from `internal/kernel/common_ids.go` (`kernel.UserID`, `kernel.TenantID`, …).
- Log with `internal/logx`.
- A new setting needs a field and loader in `internal/config` plus an `export` line in `backend/Makefile`.

### Migrations

Plain SQL, up-only, in `backend/migrations/*.up.sql`. `make migrate` pipes each unapplied file through `psql` inside the Postgres container, in filename order, one transaction per file, and records it in `schema_migrations`. Editing an applied file has no effect, so add a new one. Existing files are numbered `NNN_`; `migrate-create` generates a timestamp prefix, which sorts after them.

### Getting a logged-in user locally

A fresh database has no tenant and no user. Sign-up (OTP or OAuth) requires an invitation token, and no route creates a tenant (`TenantService.CreateTenant` exists but is not exposed). Exercising authenticated endpoints therefore needs a tenant and invitation inserted with SQL; `make backend-seed` loads `backend/migrations/seed_test_data.sql` if you create it. In development, OTP codes and invitation tokens are printed to the API server's stdout by the console notifiers in `cmd/container.go`.

### Other modules

- `internal/jobx` — Redis-backed job queue; the worker starts with the server. Register handlers with `JobClient.Register`, enqueue with `Enqueue` / `EnqueueDelayed`.
- `internal/notifx` — email client (`console` or `ses`, chosen by `NOTIFX_PROVIDER`). IAM does not use it yet; it gets the console notifiers instead.
- `internal/fsx` — file storage abstraction: local `./uploads` or S3, chosen by `STORAGE_MODE`.
- `internal/asyncx` — concurrency helpers (futures, fan-out, pools, retry); see its `doc.go`.
- `internal/ai/harness` — a self-contained agent harness (Anthropic and OpenAI providers, tool registry, built-in file/shell tools, skills, subagents, compaction). Nothing in `cmd/` uses it yet. Its `README.md` is the reference, but the `examples/` directory and the import path it mentions belong to the upstream manifesto repo and are not present here.

## Frontend

- File-based routing with TanStack Router: routes live in `src/routes/`, and `src/routeTree.gen.ts` is generated — do not edit it.
- `src/router.tsx` creates a `QueryClient` per router instance (so each SSR request has its own cache), puts it in the router context, and wires SSR hydration with `setupRouterSsrQueryIntegration`. Fetch data through TanStack Query in loaders and components.
- `src/routes/__root.tsx` renders the HTML shell and providers.
- UI components in `src/components/ui/` are shadcn's `base-nova` style, built on **Base UI** (`@base-ui/react`), not Radix. Their APIs differ from the Radix-based shadcn components most examples show.
- Tailwind v4 is configured in CSS (`src/styles.css`); there is no `tailwind.config`. Theme tokens are CSS variables there.
- `@/*` resolves to `src/*`.
- Prettier style: no semicolons, double quotes, Tailwind class sorting.
- Use bun. `.cta.json` names pnpm, but the lockfile and Makefile are bun.
