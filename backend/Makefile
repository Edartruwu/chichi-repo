# ============================================================================
# Environment Variables - Server Configuration
# ============================================================================

export SERVER_PORT = 8080
export ENVIRONMENT = development
export LOG_LEVEL = debug
export BASE_URL = http://localhost:$(SERVER_PORT)
export CORS_ORIGINS = http://localhost:3000,http://localhost:5173

# ============================================================================
# Environment Variables - Database Configuration
# ============================================================================

export POSTGRES_DB = backenddb
export POSTGRES_USER = backend
export POSTGRES_PASSWORD = supersecret
export POSTGRES_HOST = localhost
export POSTGRES_PORT = 5432

export DB_HOST = $(POSTGRES_HOST)
export DB_PORT = $(POSTGRES_PORT)
export DB_USER = $(POSTGRES_USER)
export DB_PASSWORD = $(POSTGRES_PASSWORD)
export DB_NAME = $(POSTGRES_DB)
export DB_SSL_MODE = disable
export DB_MAX_OPEN_CONNS = 25
export DB_MAX_IDLE_CONNS = 5
export DB_CONN_MAX_LIFETIME = 5m

# ============================================================================
# Environment Variables - Redis Configuration
# ============================================================================

export REDIS_HOST = localhost
export REDIS_PORT = 6379
export REDIS_PASSWORD =
export REDIS_DB = 0

# ============================================================================
# Environment Variables - Storage Configuration
# ============================================================================

export STORAGE_MODE = local
export UPLOAD_DIR = ./uploads
export AWS_REGION = us-east-1
export AWS_BUCKET = backend-uploads

# ============================================================================
# Environment Variables - JWT Configuration
# ============================================================================

export JWT_SECRET_KEY = development-supersecret-key-must-be-at-least-32-characters-long-change-in-prod
export JWT_ACCESS_TOKEN_TTL = 15m
export JWT_REFRESH_TOKEN_TTL = 168h
export JWT_ISSUER = backend
export JWT_AUDIENCE = backend-api,backend-web

# ============================================================================
# Environment Variables - API Key Configuration
# ============================================================================

export API_KEY_LIVE_PREFIX = backend_live
export API_KEY_TEST_PREFIX = backend_test
export API_KEY_TOKEN_LENGTH = 32

# ============================================================================
# Environment Variables - Session Configuration
# ============================================================================

export SESSION_EXPIRATION_TIME = 24h
export SESSION_CLEANUP_INTERVAL = 1h
export SESSION_MAX_PER_USER = 10

# ============================================================================
# Environment Variables - OTP Configuration
# ============================================================================

export OTP_CODE_LENGTH = 6
export OTP_EXPIRATION_TIME = 10m
export OTP_MAX_ATTEMPTS = 5
export OTP_RATE_LIMIT_WINDOW = 1m
export OTP_TOKEN_BYTE_LENGTH = 3

# ============================================================================
# Environment Variables - Invitation Configuration
# ============================================================================

export INVITATION_DEFAULT_EXPIRATION_DAYS = 7
export INVITATION_TOKEN_BYTE_LENGTH = 32
export INVITATION_MAX_PENDING_PER_TENANT = 100

# ============================================================================
# Environment Variables - Password Configuration
# ============================================================================

export PASSWORD_RESET_TOKEN_BYTE_LENGTH = 32
export PASSWORD_RESET_EXPIRATION_TIME = 1h
export PASSWORD_RESET_RATE_LIMIT_WINDOW = 15m
export PASSWORD_RESET_MAX_ATTEMPTS = 3
export BCRYPT_COST = 10

# ============================================================================
# Environment Variables - Cookie Configuration
# ============================================================================

export COOKIE_ACCESS_TOKEN_NAME = access_token
export COOKIE_REFRESH_TOKEN_NAME = refresh_token
export COOKIE_DOMAIN =
export COOKIE_PATH = /
export COOKIE_SECURE = false
export COOKIE_HTTP_ONLY = true
export COOKIE_SAME_SITE = Lax

# ============================================================================
# Environment Variables - OAuth Configuration
# ============================================================================

# Google OAuth
export OAUTH_GOOGLE_ENABLED = false
export OAUTH_GOOGLE_CLIENT_ID =
export OAUTH_GOOGLE_CLIENT_SECRET =
export OAUTH_GOOGLE_REDIRECT_URL = http://localhost:5173/auth/callback/?provider=google
export OAUTH_GOOGLE_SCOPES = openid,email,profile
export OAUTH_GOOGLE_AUTH_URL = https://accounts.google.com/o/oauth2/auth
export OAUTH_GOOGLE_TOKEN_URL = https://oauth2.googleapis.com/token
export OAUTH_GOOGLE_USER_INFO_URL = https://www.googleapis.com/oauth2/v2/userinfo
export OAUTH_GOOGLE_TIMEOUT = 30s

# Microsoft OAuth
export OAUTH_MICROSOFT_ENABLED = false
export OAUTH_MICROSOFT_CLIENT_ID =
export OAUTH_MICROSOFT_CLIENT_SECRET =
export OAUTH_MICROSOFT_REDIRECT_URL = http://localhost:$(SERVER_PORT)/api/v1/auth/callback/microsoft
export OAUTH_MICROSOFT_SCOPES = openid,email,profile,User.Read
export OAUTH_MICROSOFT_AUTH_URL = https://login.microsoftonline.com/common/oauth2/v2.0/authorize
export OAUTH_MICROSOFT_TOKEN_URL = https://login.microsoftonline.com/common/oauth2/v2.0/token
export OAUTH_MICROSOFT_USER_INFO_URL = https://graph.microsoft.com/v1.0/me
export OAUTH_MICROSOFT_TIMEOUT = 30s

# OAuth State Manager
export OAUTH_STATE_MANAGER_TYPE = redis
export OAUTH_STATE_TTL = 10m

# ============================================================================
# Environment Variables - Tenant Configuration
# ============================================================================

export TENANT_TRIAL_DAYS = 30
export TENANT_SUBSCRIPTION_YEARS = 1
export TENANT_MAX_USERS_BASIC = 5
export TENANT_MAX_USERS_PROFESSIONAL = 50
export TENANT_MAX_USERS_ENTERPRISE = 500

# ============================================================================
# Environment Variables - Job Queue Configuration
# ============================================================================

export JOBX_CONCURRENCY = 4
export JOBX_QUEUES = default
export JOBX_POLL_INTERVAL = 1s
export JOBX_SHUTDOWN_TIMEOUT = 30s
export JOBX_DEQUEUE_TIMEOUT = 5s
export JOBX_DEFAULT_RETRY_DELAY = 30s

# ============================================================================
# Environment Variables - Notification Configuration
# ============================================================================

export NOTIFX_PROVIDER = console
export NOTIFX_FROM_ADDRESS = noreply@backend.com
export NOTIFX_FROM_NAME = backend
export NOTIFX_AWS_REGION = us-east-1

# manifesto:env-config

# ============================================================================
# Internal Variables
# ============================================================================

CONN_STRING = postgres://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@$(POSTGRES_HOST):$(POSTGRES_PORT)/$(POSTGRES_DB)?sslmode=disable
CONTAINER_NAME = chichi-postgres
REDIS_CONTAINER_NAME = chichi-redis

# Postgres + Redis are defined once, in the repo-root compose file.
COMPOSE = docker compose -f ../docker-compose.yml

# ============================================================================
# Help
# ============================================================================

.PHONY: help
help: ## Show this help message
	@echo ""
	@echo "╔════════════════════════════════════════════════════════════════╗"
	@echo "║                  backend - Makefile                          ║"
	@echo "╚════════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2}'
	@echo ""

# ============================================================================
# Development
# ============================================================================

.PHONY: dev
dev: ## Run the development server
	@echo "🚀 Starting development server..."
	go mod tidy
	go run ./cmd

.PHONY: dev-watch
dev-watch: ## Run dev server with hot reload (requires air)
	@echo "🔥 Starting development server with hot reload..."
	@if command -v air > /dev/null; then \
		air; \
	else \
		echo "❌ 'air' not installed. Install with: go install github.com/cosmtrek/air@latest"; \
		echo "Falling back to regular dev mode..."; \
		make dev; \
	fi

.PHONY: build
build: ## Build the application binary
	@echo "🔨 Building application..."
	go mod tidy
	go build -o bin/server ./cmd
	@echo "✅ Binary created: bin/server"

.PHONY: prod
prod: build ## Build and run production server
	@echo "🚀 Starting production server..."
	./bin/server

.PHONY: test
test: ## Run tests
	@echo "🧪 Running tests..."
	go test -v ./...

.PHONY: test-coverage
test-coverage: ## Run tests with coverage
	@echo "🧪 Running tests with coverage..."
	go test -v -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html
	@echo "✅ Coverage report: coverage.html"

.PHONY: test-race
test-race: ## Run tests with race detector
	@echo "🧪 Running tests with race detector..."
	go test -race -v ./...

.PHONY: lint
lint: ## Run linter
	@echo "🔍 Running linter..."
	@if command -v golangci-lint > /dev/null; then \
		golangci-lint run; \
	else \
		echo "❌ golangci-lint not installed"; \
		echo "Install: https://golangci-lint.run/usage/install/"; \
	fi

.PHONY: fmt
fmt: ## Format code
	@echo "✨ Formatting code..."
	go fmt ./...
	@echo "✅ Code formatted"

.PHONY: vet
vet: ## Run go vet
	@echo "🔍 Running go vet..."
	go vet ./...

.PHONY: tidy
tidy: ## Tidy go modules
	@echo "🧹 Tidying go modules..."
	go mod tidy
	@echo "✅ Modules tidied"

# ============================================================================
# Docker - All Services
# ============================================================================

.PHONY: up
up: ## Start all services (postgres + redis)
	@echo "🐳 Starting all services..."
	$(COMPOSE) up -d --remove-orphans
	@echo "⏳ Waiting for services to be ready..."
	@sleep 3
	@make health

.PHONY: down
down: ## Stop all services
	@echo "🛑 Stopping all services..."
	$(COMPOSE) down
	@echo "✅ Services stopped"

.PHONY: down-v
down-v: ## Stop all services and remove volumes
	@echo "🛑 Stopping services and removing volumes..."
	$(COMPOSE) down -v
	@echo "✅ Services stopped and volumes removed"

.PHONY: restart
restart: down up ## Restart all services

.PHONY: logs
logs: ## Show logs for all services
	$(COMPOSE) logs -f

.PHONY: health
health: ## Check health of all services
	@echo "🏥 Checking service health..."
	@echo ""
	@echo "PostgreSQL:"
	@docker exec $(CONTAINER_NAME) pg_isready -U $(POSTGRES_USER) && echo "  ✅ Healthy" || echo "  ❌ Not ready"
	@echo ""
	@echo "Redis:"
	@docker exec $(REDIS_CONTAINER_NAME) redis-cli ping > /dev/null 2>&1 && echo "  ✅ Healthy" || echo "  ❌ Not ready"

# ============================================================================
# Docker - PostgreSQL
# ============================================================================

.PHONY: postgres-up
postgres-up: ## Start PostgreSQL only
	@echo "🐘 Starting PostgreSQL..."
	$(COMPOSE) up -d postgres
	@echo "⏳ Waiting for PostgreSQL to be ready..."
	@sleep 3
	@docker exec $(CONTAINER_NAME) pg_isready -U $(POSTGRES_USER)
	@echo "✅ PostgreSQL ready"

.PHONY: postgres-down
postgres-down: ## Stop PostgreSQL
	$(COMPOSE) stop postgres

.PHONY: postgres-restart
postgres-restart: postgres-down postgres-up ## Restart PostgreSQL

.PHONY: postgres-logs
postgres-logs: ## Show PostgreSQL logs
	$(COMPOSE) logs -f postgres

.PHONY: postgres-shell
postgres-shell: ## Open shell in PostgreSQL container
	docker exec -it $(CONTAINER_NAME) /bin/sh

# ============================================================================
# Docker - Redis
# ============================================================================

.PHONY: redis-up
redis-up: ## Start Redis only
	@echo "🔴 Starting Redis..."
	$(COMPOSE) up -d redis
	@echo "⏳ Waiting for Redis to be ready..."
	@sleep 2
	@docker exec $(REDIS_CONTAINER_NAME) redis-cli ping
	@echo "✅ Redis ready"

.PHONY: redis-down
redis-down: ## Stop Redis
	$(COMPOSE) stop redis

.PHONY: redis-restart
redis-restart: redis-down redis-up ## Restart Redis

.PHONY: redis-logs
redis-logs: ## Show Redis logs
	$(COMPOSE) logs -f redis

.PHONY: redis-cli
redis-cli: ## Open Redis CLI
	@if [ -z "$(REDIS_PASSWORD)" ]; then \
		docker exec -it $(REDIS_CONTAINER_NAME) redis-cli; \
	else \
		docker exec -it $(REDIS_CONTAINER_NAME) redis-cli -a $(REDIS_PASSWORD); \
	fi

.PHONY: redis-flush
redis-flush: ## Flush all Redis data
	@echo "⚠️  Flushing all Redis data..."
	@read -p "Are you sure? (y/N) " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		docker exec $(REDIS_CONTAINER_NAME) redis-cli FLUSHALL; \
		echo "✅ Redis data flushed"; \
	else \
		echo "❌ Cancelled"; \
	fi

.PHONY: redis-info
redis-info: ## Show Redis info
	docker exec $(REDIS_CONTAINER_NAME) redis-cli INFO

# ============================================================================
# Database Operations
# ============================================================================

.PHONY: psql
psql: ## Open psql in the PostgreSQL container
	docker exec -it $(CONTAINER_NAME) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

.PHONY: conn
conn: ## Show the PostgreSQL connection string
	@echo "$(CONN_STRING)"

.PHONY: migrate
migrate: ## Apply pending migrations (migrations/*.up.sql, in filename order)
	@echo "🔄 Running migrations..."
	@docker exec -i $(CONTAINER_NAME) psql -X -q -v ON_ERROR_STOP=1 -U $(POSTGRES_USER) -d $(POSTGRES_DB) \
		-c "SET client_min_messages = warning" \
		-c "CREATE TABLE IF NOT EXISTS schema_migrations (filename TEXT PRIMARY KEY, applied_at TIMESTAMPTZ NOT NULL DEFAULT now())"
	@set -e; \
	for f in migrations/*.up.sql; do \
		[ -e "$$f" ] || { echo "❌ No migrations found (migrations/*.up.sql)"; exit 1; }; \
		name=$$(basename "$$f"); \
		applied=$$(docker exec -i $(CONTAINER_NAME) psql -X -tA -v ON_ERROR_STOP=1 -U $(POSTGRES_USER) -d $(POSTGRES_DB) \
			-c "SELECT 1 FROM schema_migrations WHERE filename = '$$name'"); \
		if [ "$$applied" = "1" ]; then echo "  ⏭  $$name (already applied)"; continue; fi; \
		echo "  ▶  $$name"; \
		{ cat "$$f"; echo; echo "INSERT INTO schema_migrations (filename) VALUES ('$$name');"; } | \
			docker exec -i $(CONTAINER_NAME) psql -X -q -v ON_ERROR_STOP=1 --single-transaction -U $(POSTGRES_USER) -d $(POSTGRES_DB) -f -; \
	done
	@echo "✅ Migrations completed"

.PHONY: migrate-create
migrate-create: ## Create a new migration file (usage: make migrate-create name=add_users_table)
	@if [ -z "$(name)" ]; then \
		echo "❌ Error: name is required"; \
		echo "Usage: make migrate-create name=add_users_table"; \
		exit 1; \
	fi
	@timestamp=$$(date +%Y%m%d%H%M%S); \
	filename="migrations/$${timestamp}_$(name).up.sql"; \
	mkdir -p migrations; \
	echo "-- Migration: $(name)" > $$filename; \
	echo "-- Created at: $$(date)" >> $$filename; \
	echo "" >> $$filename; \
	echo "-- Add your SQL here" >> $$filename; \
	echo "" >> $$filename; \
	echo "✅ Created migration: $$filename"

.PHONY: seed
seed: ## Seed test data
	@echo "🌱 Seeding test data..."
	@if [ -f migrations/seed_test_data.sql ]; then \
		docker exec -i $(CONTAINER_NAME) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < migrations/seed_test_data.sql; \
		echo "✅ Test data seeded"; \
	else \
		echo "⚠️  No seed file found (migrations/seed_test_data.sql)"; \
	fi

.PHONY: db-clean
db-clean: ## Clean database (drop all tables)
	@echo "⚠️  This will DROP ALL TABLES!"
	@read -p "Are you sure? Type 'yes' to confirm: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		docker exec -i $(CONTAINER_NAME) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO $(POSTGRES_USER); GRANT ALL ON SCHEMA public TO public;"; \
		echo "✅ Database cleaned"; \
	else \
		echo "❌ Cancelled"; \
	fi

.PHONY: db-reset
db-reset: db-clean migrate seed ## Full database reset (clean + migrate + seed)
	@echo "✅ Database reset complete!"

.PHONY: db-backup
db-backup: ## Backup database to file
	@timestamp=$$(date +%Y%m%d_%H%M%S); \
	filename="backups/backup_$${timestamp}.sql"; \
	mkdir -p backups; \
	echo "💾 Creating backup..."; \
	docker exec $(CONTAINER_NAME) pg_dump -U $(POSTGRES_USER) $(POSTGRES_DB) > $$filename; \
	echo "✅ Backup saved to $$filename"

.PHONY: db-restore
db-restore: ## Restore database from backup (usage: make db-restore file=backups/backup.sql)
	@if [ -z "$(file)" ]; then \
		echo "❌ Error: file is required"; \
		echo "Usage: make db-restore file=backups/backup_20240101_120000.sql"; \
		exit 1; \
	fi
	@if [ ! -f "$(file)" ]; then \
		echo "❌ File not found: $(file)"; \
		exit 1; \
	fi
	@echo "⚠️  This will restore database from: $(file)"
	@read -p "Continue? (y/N) " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		docker exec -i $(CONTAINER_NAME) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < $(file); \
		echo "✅ Database restored"; \
	else \
		echo "❌ Cancelled"; \
	fi

# ============================================================================
# Setup & Initialization
# ============================================================================

.PHONY: setup
setup: up migrate seed ## Full setup (start services + migrate + seed)
	@echo ""
	@echo "✅ Setup complete!"
	@echo ""
	@echo "  🐘 PostgreSQL:  localhost:$(POSTGRES_PORT)"
	@echo "  🔴 Redis:       localhost:$(REDIS_PORT)"
	@echo ""
	@echo "Start the server with:"
	@echo "  make dev         (development mode)"
	@echo "  make dev-watch   (with hot reload)"
	@echo ""

.PHONY: init
init: tidy setup ## Initialize project (tidy + setup)
	@echo ""
	@echo "✅ Project initialized!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Run: make dev"
	@echo "  Visit: http://localhost:$(SERVER_PORT)"
	@echo ""

# ============================================================================
# Cleanup
# ============================================================================

.PHONY: clean
clean: down-v ## Stop services and remove volumes
	@echo "🧹 Cleaning up..."
	rm -rf bin/
	rm -f coverage.out coverage.html
	@echo "✅ Cleanup complete"

.PHONY: clean-all
clean-all: clean ## Clean everything including Docker images
	$(COMPOSE) down --rmi all --volumes --remove-orphans
	@echo "✅ Full cleanup complete"

# ============================================================================
# Utility & Info
# ============================================================================

.PHONY: env
env: ## Show current environment variables
	@echo ""
	@echo "╔════════════════════════════════════════════════════════════════╗"
	@echo "║                  Environment Configuration                     ║"
	@echo "╚════════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "Server:"
	@echo "  PORT:              $(SERVER_PORT)"
	@echo "  ENVIRONMENT:       $(ENVIRONMENT)"
	@echo "  LOG_LEVEL:         $(LOG_LEVEL)"
	@echo "  BASE_URL:          $(BASE_URL)"
	@echo ""
	@echo "PostgreSQL:"
	@echo "  HOST:              $(POSTGRES_HOST)"
	@echo "  PORT:              $(POSTGRES_PORT)"
	@echo "  DATABASE:          $(POSTGRES_DB)"
	@echo "  USER:              $(POSTGRES_USER)"
	@echo ""
	@echo "Redis:"
	@echo "  HOST:              $(REDIS_HOST)"
	@echo "  PORT:              $(REDIS_PORT)"
	@echo "  DB:                $(REDIS_DB)"
	@echo ""
	@echo "Storage:"
	@echo "  MODE:              $(STORAGE_MODE)"
	@echo "  UPLOAD_DIR:        $(UPLOAD_DIR)"
	@echo ""
	@echo "JWT:"
	@echo "  ISSUER:            $(JWT_ISSUER)"
	@echo "  ACCESS_TTL:        $(JWT_ACCESS_TOKEN_TTL)"
	@echo "  REFRESH_TTL:       $(JWT_REFRESH_TOKEN_TTL)"
	@echo ""
	@echo "OAuth:"
	@echo "  GOOGLE:            $(OAUTH_GOOGLE_ENABLED)"
	@echo "  MICROSOFT:         $(OAUTH_MICROSOFT_ENABLED)"
	@echo "  STATE_MANAGER:     $(OAUTH_STATE_MANAGER_TYPE)"
	@echo ""
	@echo "Jobx:"
	@echo "  CONCURRENCY:       $(JOBX_CONCURRENCY)"
	@echo "  QUEUES:            $(JOBX_QUEUES)"
	@echo ""
	@echo "Notifx:"
	@echo "  PROVIDER:          $(NOTIFX_PROVIDER)"
	@echo "  FROM:              $(NOTIFX_FROM_ADDRESS)"
	@echo ""
	# manifesto:env-display
	@echo "Connection:"
	@echo "  $(CONN_STRING)"
	@echo ""

.PHONY: ps
ps: ## Show running containers
	$(COMPOSE) ps

.PHONY: version
version: ## Show Go version
	@go version

.PHONY: deps
deps: ## Show project dependencies
	@go list -m all

.PHONY: deps-update
deps-update: ## Update all dependencies
	@echo "📦 Updating dependencies..."
	go get -u ./...
	go mod tidy
	@echo "✅ Dependencies updated"

.PHONY: check-deps
check-deps: ## Check if required tools are installed
	@echo "🔍 Checking dependencies..."
	@echo ""
	@command -v go > /dev/null && echo "✅ Go" || echo "❌ Go not installed"
	@command -v docker > /dev/null && echo "✅ Docker" || echo "❌ Docker not installed"
	@command -v golangci-lint > /dev/null && echo "✅ golangci-lint" || echo "⚠️  golangci-lint (optional)"
	@command -v air > /dev/null && echo "✅ air" || echo "⚠️  air (optional, for hot reload)"
	@echo ""

.PHONY: install-tools
install-tools: ## Install development tools
	@echo "🔧 Installing development tools..."
	go install github.com/cosmtrek/air@latest
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	@echo "✅ Tools installed"

# ============================================================================
# Aliases
# ============================================================================

.PHONY: start stop status config
start: dev ## Alias for dev
stop: down ## Alias for down
status: ps ## Alias for ps
config: env ## Alias for env

.DEFAULT_GOAL := help
