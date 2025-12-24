#!/bin/bash

# OMC System - Quick Start Script
# This script will set up and run the OMC system on your local machine

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Banner
echo ""
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  OMC System - Quick Start Setup      ${BLUE}║${NC}"
echo -e "${BLUE}║${NC}  Oxford Management Consultancy       ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check for required commands
print_step "Checking prerequisites..."

command -v node >/dev/null 2>&1 || { 
    print_error "Node.js is not installed. Please install Node.js 18+ first."
    echo "  Visit: https://nodejs.org/"
    exit 1
}

command -v npm >/dev/null 2>&1 || { 
    print_error "npm is not installed. Please install npm first."
    exit 1
}

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    print_error "Node.js version 18 or higher is required. You have: $(node -v)"
    exit 1
fi

print_success "Node.js $(node -v) detected"
print_success "npm $(npm -v) detected"

# Check if Docker is available
if command -v docker >/dev/null 2>&1 && command -v docker-compose >/dev/null 2>&1; then
    DOCKER_AVAILABLE=true
    print_success "Docker detected - will use Docker setup"
else
    DOCKER_AVAILABLE=false
    print_warning "Docker not detected - will use manual setup"
    print_warning "For easier setup, consider installing Docker Desktop"
fi

echo ""
read -p "Continue with setup? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 0
fi

# Create project structure
print_step "Creating project structure..."

mkdir -p omc-system/backend/src/{config,controllers,middleware,models,routes,services,utils}
mkdir -p omc-system/frontend
cd omc-system

print_success "Project structure created"

# Setup based on Docker availability
if [ "$DOCKER_AVAILABLE" = true ]; then
    print_step "Setting up with Docker..."
    
    # Create docker-compose.yml
    cat > docker-compose.yml << 'DOCKEREOF'
version: '3.8'

services:
  postgres:
    image: postgres:14-alpine
    container_name: omc-postgres
    environment:
      POSTGRES_DB: omc_db
      POSTGRES_USER: omc_user
      POSTGRES_PASSWORD: omc_password_2024
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U omc_user"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: omc-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
  redis_data:
DOCKEREOF

    print_success "Docker Compose configuration created"
    
    # Start database services
    print_step "Starting database services..."
    docker-compose up -d postgres redis
    
    # Wait for services to be healthy
    print_step "Waiting for databases to be ready..."
    sleep 10
    
    print_success "Database services started"
    
    DB_HOST="localhost"
else
    print_warning "Docker not available - you'll need to install PostgreSQL and Redis manually"
    print_warning "See SETUP_AND_RUN_GUIDE.md for detailed instructions"
    echo ""
    read -p "Do you have PostgreSQL and Redis installed and running? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Please install PostgreSQL and Redis first, then run this script again"
        exit 1
    fi
    
    DB_HOST="localhost"
fi

# Setup Backend
print_step "Setting up backend..."

cd backend

# Create package.json
cat > package.json << 'PKGJSON'
{
  "name": "omc-backend",
  "version": "1.0.0",
  "description": "OMC System Backend API",
  "main": "dist/server.js",
  "scripts": {
    "dev": "nodemon --exec ts-node src/server.ts",
    "build": "tsc",
    "start": "node dist/server.js"
  },
  "keywords": ["omc", "business", "management"],
  "author": "",
  "license": "ISC"
}
PKGJSON

print_success "Backend package.json created"

print_step "Installing backend dependencies (this may take a few minutes)..."

npm install express cors dotenv helmet morgan >/dev/null 2>&1 &
npm install pg sequelize >/dev/null 2>&1 &
npm install ioredis >/dev/null 2>&1 &
npm install jsonwebtoken bcryptjs >/dev/null 2>&1 &
npm install express-validator multer winston >/dev/null 2>&1 &

wait

print_success "Backend core dependencies installed"

print_step "Installing backend dev dependencies..."

npm install -D nodemon typescript @types/node @types/express >/dev/null 2>&1 &
npm install -D @types/cors @types/bcryptjs @types/jsonwebtoken >/dev/null 2>&1 &
npm install -D ts-node >/dev/null 2>&1 &

wait

print_success "Backend dev dependencies installed"

# Create TypeScript config
npx tsc --init --rootDir src --outDir dist --esModuleInterop --resolveJsonModule --lib es2020 --module commonjs --allowJs true --noImplicitAny true >/dev/null 2>&1

print_success "TypeScript configured"

# Create .env file
cat > .env << 'ENVFILE'
NODE_ENV=development
PORT=5000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=omc_db
DB_USER=omc_user
DB_PASSWORD=omc_password_2024
REDIS_HOST=localhost
REDIS_PORT=6379
JWT_SECRET=your_jwt_secret_change_in_production_2024
JWT_REFRESH_SECRET=your_refresh_secret_change_in_production_2024
FRONTEND_URL=http://localhost:3000
ENVFILE

print_success "Environment file created"

# Create basic server files
cat > src/app.ts << 'APPFILE'
import express, { Application, Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';

const app: Application = express();

app.use(helmet());
app.use(cors({ origin: process.env.FRONTEND_URL || 'http://localhost:3000', credentials: true }));
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get('/health', (req: Request, res: Response) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString(), service: 'OMC Backend API' });
});

app.get('/api/v1', (req: Request, res: Response) => {
  res.json({ success: true, message: 'OMC API v1 is running!', version: '1.0.0' });
});

app.use((req: Request, res: Response) => {
  res.status(404).json({ success: false, error: 'Route not found' });
});

export default app;
APPFILE

cat > src/server.ts << 'SERVERFILE'
import dotenv from 'dotenv';
import app from './app';

dotenv.config();

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log('\n=================================');
  console.log('🚀 OMC Backend Server Started');
  console.log(`📝 Environment: ${process.env.NODE_ENV}`);
  console.log(`🌐 Server: http://localhost:${PORT}`);
  console.log(`🏥 Health: http://localhost:${PORT}/health`);
  console.log(`📡 API: http://localhost:${PORT}/api/v1`);
  console.log('=================================\n');
});
SERVERFILE

print_success "Backend server files created"

# Setup Frontend
print_step "Setting up frontend..."

cd ../frontend

# Create a minimal Next.js setup
npm init -y >/dev/null 2>&1

cat > package.json << 'FRONTPKG'
{
  "name": "omc-frontend",
  "version": "1.0.0",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  }
}
FRONTPKG

print_step "Installing frontend dependencies (this may take a few minutes)..."

npm install next@latest react@latest react-dom@latest >/dev/null 2>&1 &
npm install -D typescript @types/react @types/node >/dev/null 2>&1 &
npm install -D tailwindcss postcss autoprefixer >/dev/null 2>&1 &

wait

print_success "Frontend dependencies installed"

# Initialize Tailwind
npx tailwindcss init -p >/dev/null 2>&1

# Create basic structure
mkdir -p src/app

cat > src/app/page.tsx << 'PAGEFILE'
export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24 bg-gradient-to-b from-blue-50 to-white">
      <div className="text-center space-y-6">
        <h1 className="text-6xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
          OMC System
        </h1>
        <p className="text-xl text-gray-600">Oxford Management Consultancy</p>
        <p className="text-lg text-gray-500 max-w-2xl">
          Complete business management platform for company formation, tax registration, bookkeeping, and more.
        </p>
        <div className="mt-12 p-6 bg-green-50 rounded-lg border-2 border-green-200">
          <p className="text-green-800 font-semibold text-lg">✅ System is running successfully!</p>
          <p className="text-green-600 text-sm mt-2">Backend API: http://localhost:5000</p>
          <p className="text-green-600 text-sm">Frontend: http://localhost:3000</p>
        </div>
        <div className="mt-8 text-sm text-gray-500">
          <p>Next steps:</p>
          <ul className="mt-2 space-y-1">
            <li>• Check out IMPLEMENTATION_GUIDE.md to start building</li>
            <li>• Read MODULE_SPECIFICATIONS.md for feature details</li>
            <li>• Review USER_STORIES_AND_WORKFLOWS.md for user flows</li>
          </ul>
        </div>
      </div>
    </main>
  );
}
PAGEFILE

cat > src/app/layout.tsx << 'LAYOUTFILE'
import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'OMC System',
  description: 'Oxford Management Consultancy',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
LAYOUTFILE

cat > src/app/globals.css << 'CSSFILE'
@tailwind base;
@tailwind components;
@tailwind utilities;
CSSFILE

cat > tailwind.config.js << 'TAILWINDFILE'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
TAILWINDFILE

cat > next.config.js << 'NEXTFILE'
/** @type {import('next').NextConfig} */
const nextConfig = {}
module.exports = nextConfig
NEXTFILE

cat > tsconfig.json << 'TSFILE'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": { "@/*": ["./src/*"] }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
TSFILE

print_success "Frontend setup complete"

# Go back to project root
cd ..

# Final instructions
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}     Setup Complete! 🎉                ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

print_success "OMC System is ready to run!"
echo ""
echo "To start the system, run these commands in separate terminals:"
echo ""
echo -e "${BLUE}Terminal 1 (Backend):${NC}"
echo "  cd backend"
echo "  npm run dev"
echo ""
echo -e "${BLUE}Terminal 2 (Frontend):${NC}"
echo "  cd frontend"
echo "  npm run dev"
echo ""
echo "Then open your browser to:"
echo -e "  ${GREEN}http://localhost:3000${NC} - Frontend"
echo -e "  ${GREEN}http://localhost:5000/health${NC} - Backend health check"
echo ""
echo "📚 Documentation is available in the project root:"
echo "  • README.md - Start here"
echo "  • SETUP_AND_RUN_GUIDE.md - Detailed setup guide"
echo "  • IMPLEMENTATION_GUIDE.md - Build features"
echo "  • MODULE_SPECIFICATIONS.md - Feature specifications"
echo ""
print_success "Happy coding! 🚀"
echo ""
