# Variables
DB_CONTAINER_NAME = local-postgres
DB_PORT = 5432
DB_USER = postgres
DB_PASSWORD = password
DB_NAME = mydatabase
FRONTEND_DIR = ./front
BACKEND_DIR = ./back
DATABASE_URL = postgresql://$(DB_USER):$(DB_PASSWORD)@localhost:$(DB_PORT)/$(DB_NAME)

# PM2 Ecosystem File (optional, if using one)
PM2_CONFIG = ./pm2.config.js

# Start the database (PostgreSQL using Docker)
start-db:
	docker run --name $(DB_CONTAINER_NAME) -e POSTGRES_USER=$(DB_USER) -e POSTGRES_PASSWORD=$(DB_PASSWORD) -e POSTGRES_DB=$(DB_NAME) -p $(DB_PORT):5432 -d postgres:13

# Stop and remove the database
stop-db:
	docker stop $(DB_CONTAINER_NAME) && docker rm $(DB_CONTAINER_NAME)

# Start the backend (NestJS) using PM2
start-backend:
	cd $(BACKEND_DIR) && pm2 start dist/main.js --name backend --env development --update-env --merge-logs

# Run Prisma migrations (if using Prisma in the backend)
migrate-backend:
	export DATABASE_URL=$(DATABASE_URL) && cd $(BACKEND_DIR) && npx prisma migrate dev

# Start the frontend (Next.js) using PM2
start-frontend:
	pm2 start npm --name frontend -- run dev --prefix $(FRONTEND_DIR)

# Build the frontend (Next.js for production testing)
build-frontend:
	cd $(FRONTEND_DIR) && npm run build && npm run start

# Stop the backend using PM2
stop-backend:
	pm2 stop backend || echo "Backend not running."

# Stop the frontend using PM2
stop-frontend:
	pm2 stop frontend || echo "Frontend not running."

# Start everything together using PM2
start:
	make start-db
	make start-backend
	make start-frontend

# Stop everything using PM2
stop:
	make stop-backend
	make stop-frontend
	make stop-db

# Restart everything using PM2
restart:
	pm2 restart all || echo "No PM2 services running."

# Monitor PM2 processes
monitor:
	pm2 monit

# Save the PM2 process list for auto-restart on reboot
save-pm2:
	pm2 save

# View logs for the backend
logs-backend:
	pm2 logs backend

# View logs for the frontend
logs-frontend:
	pm2 logs frontend

# View all PM2 logs
logs:
	pm2 logs

# Delete all PM2-managed applications
delete:
	pm2 delete all

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
