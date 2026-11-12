# Root Makefile: local infrastructure (Postgres + Redis) and the entry points
# for backend/ and frontend/.
#
# Backend settings (database credentials, ports, JWT, OAuth, ...) live in
# backend/Makefile. Targets that need them delegate there, so there is a single
# place to change them. Any backend target is reachable as `make backend-<name>`.

.DEFAULT_GOAL := help

COMPOSE  := docker compose
BACKEND  := $(MAKE) --no-print-directory -C backend
FRONTEND := cd frontend && bun

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z0-9_%-]+:.*## / {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# ----------------------------------------------------------------------------
# Setup
# ----------------------------------------------------------------------------

.PHONY: setup
setup: install up migrate ## First-time setup: install deps, start services, run migrations

.PHONY: install
install: ## Install backend and frontend dependencies
	cd backend && go mod download
	$(FRONTEND) install

# ----------------------------------------------------------------------------
# Infrastructure (docker-compose.yml)
# ----------------------------------------------------------------------------

.PHONY: up
up: ## Start Postgres + Redis and wait until both are healthy
	$(COMPOSE) up -d --wait

.PHONY: down
down: ## Stop Postgres + Redis (data is kept)
	$(COMPOSE) down

.PHONY: ps
ps: ## Show service status
	$(COMPOSE) ps

.PHONY: logs
logs: ## Follow Postgres + Redis logs
	$(COMPOSE) logs -f

.PHONY: reset
reset: ## Delete ALL local Postgres + Redis data, then start fresh and migrate
	@printf "This deletes all local Postgres and Redis data. Type 'yes' to continue: "; \
	read answer; [ "$$answer" = "yes" ] || { echo "Cancelled"; exit 1; }
	$(COMPOSE) down -v
	$(MAKE) --no-print-directory up migrate

# ----------------------------------------------------------------------------
# Database
# ----------------------------------------------------------------------------

.PHONY: migrate
migrate: ## Apply pending database migrations (backend/migrations)
	$(BACKEND) migrate

.PHONY: psql
psql: ## Open a psql shell in the Postgres container
	$(BACKEND) psql

.PHONY: redis-cli
redis-cli: ## Open redis-cli in the Redis container
	$(BACKEND) redis-cli

# ----------------------------------------------------------------------------
# Development
# ----------------------------------------------------------------------------

.PHONY: dev
dev: up ## Run backend (:8080) and frontend (:3000) together; Ctrl-C stops both
	@$(MAKE) --no-print-directory -j2 dev-backend dev-frontend

.PHONY: dev-backend
dev-backend: ## Run only the API server (http://localhost:8080)
	$(BACKEND) dev

.PHONY: dev-frontend
dev-frontend: ## Run only the web app (http://localhost:3000)
	$(FRONTEND) run dev

# ----------------------------------------------------------------------------
# Quality
# ----------------------------------------------------------------------------

.PHONY: test
test: ## Run backend tests
	$(BACKEND) test

.PHONY: lint
lint: ## Lint backend and frontend (runs both even if one fails)
	@$(MAKE) --no-print-directory -k lint-backend lint-frontend

.PHONY: lint-backend
lint-backend: ## Lint the backend (golangci-lint)
	$(BACKEND) lint

.PHONY: lint-frontend
lint-frontend: ## Lint the frontend (eslint + tsc)
	$(FRONTEND) run lint
	$(FRONTEND) run typecheck

.PHONY: build
build: ## Build the backend binary and the frontend bundle
	$(BACKEND) build
	$(FRONTEND) run build

# ----------------------------------------------------------------------------
# Passthrough
# ----------------------------------------------------------------------------

backend-%: ## Run any backend/Makefile target, e.g. `make backend-env`
	$(BACKEND) $*
