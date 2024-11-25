# Variables
DB_CONTAINER_NAME = local-postgres
DB_PORT = 5432
DB_USER = postgres
DB_PASSWORD = password
DB_NAME = mydatabase
FRONTEND_DIR = ./front
BACKEND_DIR = ./back
DATABASE_URL = postgresql://$(DB_USER):$(DB_PASSWORD)@localhost:$(DB_PORT)/$(DB_NAME)

# PM2 Ecosystem File
PM2_CONFIG = pm2.config.js

# Start all processes with hot reload, including database
start:
	pm2 start $(PM2_CONFIG)

# Stop all processes
stop:
	pm2 stop all

# Restart all processes
restart:
	pm2 restart all

# Monitor PM2 processes
monitor:
	pm2 monit

# View logs for all processes
logs:
	pm2 logs

# View logs for the backend
logs-backend:
	pm2 logs backend

# View logs for the frontend
logs-frontend:
	pm2 logs frontend

# Delete all PM2-managed applications
delete:
	pm2 delete all

# Start the database using PM2
start-db:
	pm2 start $(PM2_CONFIG) --only database

# Stop and remove the database container
stop-db:
	docker stop $(DB_CONTAINER_NAME) && docker rm $(DB_CONTAINER_NAME) || echo "Database container not running."

# Run Prisma migrations (if using Prisma in the backend)
migrate-backend:
	export DATABASE_URL=$(DATABASE_URL) && \
	cd $(BACKEND_DIR) && npx prisma migrate dev

# Lint backend (NestJS)
lint-backend:
	cd $(BACKEND_DIR) && npm run lint

# Lint frontend (Next.js)
lint-frontend:
	cd $(FRONTEND_DIR) && npm run lint

# Test backend (NestJS)
test-backend:
	cd $(BACKEND_DIR) && npm run test

# Test frontend (Next.js)
test-frontend:
	cd $(FRONTEND_DIR) && npm run test
