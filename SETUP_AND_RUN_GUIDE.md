# OMC System - Complete Setup and Run Guide

## 🎯 Goal

Get the complete OMC system running on your local machine (localhost) with both backend and frontend operational.

**Estimated Time**: 2-4 hours (first time setup)

---

## 📋 Prerequisites Checklist

Before starting, ensure you have:

### Required Software
- [ ] **Node.js 18+** and npm
- [ ] **PostgreSQL 14+**
- [ ] **Redis 7+**
- [ ] **Git**
- [ ] **Code Editor** (VS Code recommended)

### Optional but Recommended
- [ ] **Docker Desktop** (makes setup much easier)
- [ ] **Postman** or **Insomnia** (for API testing)
- [ ] **pgAdmin** or **DBeaver** (database GUI)

---

## 🚀 Two Setup Methods

Choose the method that works best for you:

### Method 1: Docker Setup (Recommended - Easiest) ⭐
- **Pros**: Automatic setup, no manual configuration, consistent environment
- **Cons**: Requires Docker Desktop
- **Time**: 30 minutes

### Method 2: Manual Setup (Full Control)
- **Pros**: Complete control, learn each component
- **Cons**: More steps, OS-specific
- **Time**: 2-3 hours

---

## 🐳 Method 1: Docker Setup (Recommended)

This is the fastest way to get everything running!

### Step 1: Install Docker Desktop

**macOS**:
```bash
# Download from: https://www.docker.com/products/docker-desktop
# Or install with Homebrew:
brew install --cask docker
```

**Windows**:
```bash
# Download from: https://www.docker.com/products/docker-desktop
# Run the installer and follow the wizard
```

**Linux**:
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker
```

**Verify Installation**:
```bash
docker --version
docker-compose --version
```

### Step 2: Create Project Structure

```bash
# Create main project directory
mkdir omc-system
cd omc-system

# Create subdirectories
mkdir -p backend frontend
```

### Step 3: Create Docker Compose File

Create `docker-compose.yml` in the project root:

```bash
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  # PostgreSQL Database
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
    networks:
      - omc-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U omc_user"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: omc-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - omc-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Backend API (will be added after creating the code)
  backend:
    build: ./backend
    container_name: omc-backend
    ports:
      - "5000:5000"
    environment:
      - NODE_ENV=development
      - PORT=5000
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=omc_db
      - DB_USER=omc_user
      - DB_PASSWORD=omc_password_2024
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - JWT_SECRET=your_jwt_secret_change_in_production_2024
      - JWT_REFRESH_SECRET=your_refresh_secret_change_in_production_2024
      - FRONTEND_URL=http://localhost:3000
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    volumes:
      - ./backend:/app
      - /app/node_modules
    networks:
      - omc-network
    command: npm run dev

  # Frontend (will be added after creating the code)
  frontend:
    build: ./frontend
    container_name: omc-frontend
    ports:
      - "3000:3000"
    environment:
      - NEXT_PUBLIC_API_URL=http://localhost:5000/api/v1
    depends_on:
      - backend
    volumes:
      - ./frontend:/app
      - /app/node_modules
      - /app/.next
    networks:
      - omc-network
    command: npm run dev

volumes:
  postgres_data:
  redis_data:

networks:
  omc-network:
    driver: bridge
EOF
```

### Step 4: Create Backend Project

```bash
cd backend

# Initialize npm project
npm init -y

# Install dependencies
npm install express cors dotenv helmet morgan
npm install pg sequelize
npm install ioredis
npm install jsonwebtoken bcryptjs
npm install express-validator
npm install multer winston

# Install dev dependencies
npm install -D nodemon typescript @types/node @types/express
npm install -D @types/cors @types/bcryptjs @types/jsonwebtoken
npm install -D ts-node

# Initialize TypeScript
npx tsc --init
```

### Step 5: Configure TypeScript

Create or update `backend/tsconfig.json`:

```bash
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "moduleResolution": "node",
    "declaration": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF
```

### Step 6: Create Backend Structure

```bash
# Create directories
mkdir -p src/{config,controllers,middleware,models,routes,services,utils}

# Create main files
touch src/server.ts
touch src/app.ts
```

### Step 7: Create Environment File

```bash
cat > .env << 'EOF'
# Server
NODE_ENV=development
PORT=5000
API_VERSION=v1

# Database
DB_HOST=postgres
DB_PORT=5432
DB_NAME=omc_db
DB_USER=omc_user
DB_PASSWORD=omc_password_2024

# Redis
REDIS_HOST=redis
REDIS_PORT=6379

# JWT
JWT_SECRET=your_jwt_secret_change_in_production_2024
JWT_REFRESH_SECRET=your_refresh_secret_change_in_production_2024
JWT_EXPIRE=1h
JWT_REFRESH_EXPIRE=30d

# Frontend URL
FRONTEND_URL=http://localhost:3000

# Email (optional for now)
EMAIL_PROVIDER=console
EMAIL_FROM=noreply@omc.com
EOF
```

### Step 8: Create Database Configuration

Create `backend/src/config/database.ts`:

```typescript
import { Sequelize } from 'sequelize';
import dotenv from 'dotenv';

dotenv.config();

export const sequelize = new Sequelize({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT) || 5432,
  database: process.env.DB_NAME || 'omc_db',
  username: process.env.DB_USER || 'omc_user',
  password: process.env.DB_PASSWORD || 'omc_password_2024',
  dialect: 'postgres',
  logging: process.env.NODE_ENV === 'development' ? console.log : false,
  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000
  }
});

export const connectDB = async () => {
  try {
    await sequelize.authenticate();
    console.log('✅ Database connected successfully');
    
    // Sync models (for development)
    if (process.env.NODE_ENV === 'development') {
      await sequelize.sync({ alter: true });
      console.log('✅ Database synchronized');
    }
  } catch (error) {
    console.error('❌ Database connection failed:', error);
    process.exit(1);
  }
};
```

### Step 9: Create User Model

Create `backend/src/models/User.ts`:

```typescript
import { DataTypes, Model } from 'sequelize';
import { sequelize } from '../config/database';

export interface UserAttributes {
  id: number;
  uuid: string;
  email: string;
  password_hash?: string;
  first_name: string;
  last_name: string;
  phone?: string;
  role: 'super_admin' | 'admin' | 'client';
  auth_provider: 'email' | 'google';
  google_id?: string;
  is_active: boolean;
  is_verified: boolean;
  email_verified_at?: Date;
  last_login_at?: Date;
  created_at: Date;
  updated_at: Date;
}

export class User extends Model<UserAttributes> implements UserAttributes {
  public id!: number;
  public uuid!: string;
  public email!: string;
  public password_hash?: string;
  public first_name!: string;
  public last_name!: string;
  public phone?: string;
  public role!: 'super_admin' | 'admin' | 'client';
  public auth_provider!: 'email' | 'google';
  public google_id?: string;
  public is_active!: boolean;
  public is_verified!: boolean;
  public email_verified_at?: Date;
  public last_login_at?: Date;
  public created_at!: Date;
  public updated_at!: Date;
}

User.init(
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true
    },
    uuid: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      unique: true
    },
    email: {
      type: DataTypes.STRING(255),
      allowNull: false,
      unique: true,
      validate: { isEmail: true }
    },
    password_hash: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    first_name: {
      type: DataTypes.STRING(100),
      allowNull: false
    },
    last_name: {
      type: DataTypes.STRING(100),
      allowNull: false
    },
    phone: {
      type: DataTypes.STRING(20),
      allowNull: true
    },
    role: {
      type: DataTypes.ENUM('super_admin', 'admin', 'client'),
      allowNull: false,
      defaultValue: 'client'
    },
    auth_provider: {
      type: DataTypes.STRING(50),
      defaultValue: 'email'
    },
    google_id: {
      type: DataTypes.STRING(255),
      allowNull: true,
      unique: true
    },
    is_active: {
      type: DataTypes.BOOLEAN,
      defaultValue: true
    },
    is_verified: {
      type: DataTypes.BOOLEAN,
      defaultValue: false
    },
    email_verified_at: {
      type: DataTypes.DATE,
      allowNull: true
    },
    last_login_at: {
      type: DataTypes.DATE,
      allowNull: true
    },
    created_at: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW
    },
    updated_at: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW
    }
  },
  {
    sequelize,
    tableName: 'users',
    timestamps: true,
    underscored: true,
    indexes: [
      { fields: ['email'] },
      { fields: ['role'] },
      { fields: ['google_id'] }
    ]
  }
);
```

### Step 10: Create Express App

Create `backend/src/app.ts`:

```typescript
import express, { Application, Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';

const app: Application = express();

// Middleware
app.use(helmet());
app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  credentials: true
}));
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check
app.get('/health', (req: Request, res: Response) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    service: 'OMC Backend API'
  });
});

// API routes placeholder
app.get('/api/v1', (req: Request, res: Response) => {
  res.json({
    success: true,
    message: 'OMC API v1',
    version: '1.0.0'
  });
});

// 404 handler
app.use((req: Request, res: Response) => {
  res.status(404).json({ 
    success: false,
    error: 'Route not found' 
  });
});

// Error handler
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error(err.stack);
  res.status(500).json({ 
    success: false,
    error: 'Internal server error' 
  });
});

export default app;
```

### Step 11: Create Server Entry Point

Create `backend/src/server.ts`:

```typescript
import dotenv from 'dotenv';
import app from './app';
import { connectDB } from './config/database';

dotenv.config();

const PORT = process.env.PORT || 5000;

async function startServer() {
  try {
    // Connect to database
    await connectDB();

    // Start server
    app.listen(PORT, () => {
      console.log('=================================');
      console.log(`🚀 OMC Backend Server Started`);
      console.log(`📝 Environment: ${process.env.NODE_ENV}`);
      console.log(`🌐 Server: http://localhost:${PORT}`);
      console.log(`🏥 Health: http://localhost:${PORT}/health`);
      console.log(`📡 API: http://localhost:${PORT}/api/v1`);
      console.log('=================================');
    });
  } catch (error) {
    console.error('❌ Failed to start server:', error);
    process.exit(1);
  }
}

startServer();
```

### Step 12: Update package.json

Update `backend/package.json` to add scripts:

```bash
npm pkg set scripts.dev="nodemon --exec ts-node src/server.ts"
npm pkg set scripts.build="tsc"
npm pkg set scripts.start="node dist/server.js"
```

### Step 13: Create Backend Dockerfile

Create `backend/Dockerfile`:

```bash
cat > Dockerfile << 'EOF'
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 5000

CMD ["npm", "run", "dev"]
EOF
```

### Step 14: Test Backend Locally (Without Docker)

```bash
# Make sure you're in the backend directory
cd backend

# Install dependencies if not already done
npm install

# Start the backend
npm run dev
```

You should see:
```
✅ Database connected successfully
✅ Database synchronized
🚀 OMC Backend Server Started
📝 Environment: development
🌐 Server: http://localhost:5000
```

**Test it**:
```bash
# In a new terminal
curl http://localhost:5000/health
```

### Step 15: Create Frontend Project

```bash
# Go back to project root
cd ..

# Create Next.js app in frontend directory
cd frontend
npx create-next-app@latest . --typescript --tailwind --app --src-dir --import-alias "@/*"

# Answer the prompts:
# ✔ Would you like to use ESLint? … Yes
# ✔ Would you like to use Turbopack? … No
# ✔ Would you like to customize the default import alias? … No
```

### Step 16: Install Frontend Dependencies

```bash
# Still in frontend directory
npm install axios
npm install @tanstack/react-query
npm install zustand
npm install react-hook-form
npm install zod
npm install react-hot-toast
npm install lucide-react
npm install date-fns
```

### Step 17: Create Frontend Environment File

Create `frontend/.env.local`:

```bash
cat > .env.local << 'EOF'
NEXT_PUBLIC_API_URL=http://localhost:5000/api/v1
NEXT_PUBLIC_APP_NAME=OMC System
EOF
```

### Step 18: Create Simple Landing Page

Create `frontend/src/app/page.tsx`:

```typescript
export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <div className="text-center space-y-6">
        <h1 className="text-6xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
          OMC System
        </h1>
        <p className="text-xl text-gray-600">
          Oxford Management Consultancy
        </p>
        <p className="text-lg text-gray-500 max-w-2xl">
          Complete business management platform for company formation, 
          tax registration, bookkeeping, and more.
        </p>
        <div className="flex gap-4 justify-center mt-8">
          <a 
            href="/login" 
            className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
          >
            Login
          </a>
          <a 
            href="/register" 
            className="px-6 py-3 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition"
          >
            Sign Up
          </a>
        </div>
        <div className="mt-12 p-6 bg-green-50 rounded-lg">
          <p className="text-green-800 font-semibold">
            ✅ System is running successfully!
          </p>
          <p className="text-green-600 text-sm mt-2">
            Backend API: http://localhost:5000
          </p>
        </div>
      </div>
    </main>
  );
}
```

### Step 19: Create Frontend Dockerfile

Create `frontend/Dockerfile`:

```bash
cat > Dockerfile << 'EOF'
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]
EOF
```

### Step 20: Start Everything with Docker

```bash
# Go back to project root
cd ..

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f
```

### Step 21: Verify Everything is Running

**Check containers**:
```bash
docker-compose ps
```

You should see:
- omc-postgres (healthy)
- omc-redis (healthy)
- omc-backend (running)
- omc-frontend (running)

**Test the services**:

```bash
# Test backend
curl http://localhost:5000/health

# Test database (should see tables)
docker exec -it omc-postgres psql -U omc_user -d omc_db -c "\dt"

# Test Redis
docker exec -it omc-redis redis-cli ping
```

**Access the application**:
- Frontend: http://localhost:3000
- Backend: http://localhost:5000
- Backend Health: http://localhost:5000/health
- API: http://localhost:5000/api/v1

### Step 22: Stop Everything

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (clean slate)
docker-compose down -v
```

---

## 🛠️ Method 2: Manual Setup (Without Docker)

### Part A: Install Prerequisites

#### Install Node.js

**macOS**:
```bash
# Using Homebrew
brew install node@18

# Or using nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18
```

**Windows**:
```bash
# Download from: https://nodejs.org/
# Or use nvm-windows: https://github.com/coreybutler/nvm-windows
```

**Linux**:
```bash
# Using nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18
```

**Verify**:
```bash
node --version  # Should show v18.x.x
npm --version   # Should show 9.x.x or higher
```

#### Install PostgreSQL

**macOS**:
```bash
brew install postgresql@14
brew services start postgresql@14

# Create database and user
psql postgres
```

**Windows**:
```bash
# Download from: https://www.postgresql.org/download/windows/
# Run installer
# Use pgAdmin or command line
```

**Linux (Ubuntu/Debian)**:
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

**Create Database**:
```bash
# Connect to PostgreSQL
sudo -u postgres psql

# Run these commands:
CREATE DATABASE omc_db;
CREATE USER omc_user WITH PASSWORD 'omc_password_2024';
GRANT ALL PRIVILEGES ON DATABASE omc_db TO omc_user;
\q
```

#### Install Redis

**macOS**:
```bash
brew install redis
brew services start redis
```

**Windows**:
```bash
# Download from: https://github.com/microsoftarchive/redis/releases
# Or use WSL2 + Linux method
```

**Linux (Ubuntu/Debian)**:
```bash
sudo apt update
sudo apt install redis-server
sudo systemctl start redis-server
sudo systemctl enable redis-server
```

**Verify**:
```bash
redis-cli ping  # Should return PONG
```

### Part B: Setup Backend

Follow Steps 4-13 from Method 1 (they're the same).

Then update `.env` file for local setup:

```bash
cat > .env << 'EOF'
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
EOF
```

**Run Backend**:
```bash
cd backend
npm install
npm run dev
```

### Part C: Setup Frontend

Follow Steps 15-18 from Method 1 (they're the same).

**Run Frontend**:
```bash
cd frontend
npm install
npm run dev
```

### Part D: Access the System

- Frontend: http://localhost:3000
- Backend: http://localhost:5000
- Health Check: http://localhost:5000/health

---

## ✅ Verification Checklist

After setup, verify everything works:

### Backend Checks
```bash
# Health check
curl http://localhost:5000/health

# Should return:
# {"status":"OK","timestamp":"...","service":"OMC Backend API"}

# API check
curl http://localhost:5000/api/v1

# Should return:
# {"success":true,"message":"OMC API v1","version":"1.0.0"}
```

### Database Checks
```bash
# Using Docker
docker exec -it omc-postgres psql -U omc_user -d omc_db

# Or locally
psql -U omc_user -d omc_db

# List tables
\dt

# Should see 'users' table
# Exit with \q
```

### Frontend Checks
- Open http://localhost:3000 in browser
- Should see the OMC landing page
- Should see "✅ System is running successfully!"

---

## 🐛 Troubleshooting

### Backend won't start

**Error: "ECONNREFUSED" or "Database connection failed"**
```bash
# Check if PostgreSQL is running
docker-compose ps  # If using Docker
# Or
pg_isadmin  # If local

# Check connection details in .env file
cat backend/.env

# Try connecting manually
psql -U omc_user -d omc_db -h localhost
```

**Error: "Port 5000 already in use"**
```bash
# Find what's using port 5000
lsof -i :5000  # macOS/Linux
netstat -ano | findstr :5000  # Windows

# Kill the process or change PORT in .env
```

### Frontend won't start

**Error: "Port 3000 already in use"**
```bash
# Change port in package.json
npm run dev -- -p 3001

# Or kill the process using port 3000
lsof -i :3000  # macOS/Linux
netstat -ano | findstr :3000  # Windows
```

### Docker issues

**Error: "Cannot connect to Docker daemon"**
```bash
# Start Docker Desktop (macOS/Windows)
# Or start Docker service (Linux)
sudo systemctl start docker
```

**Error: "Port already allocated"**
```bash
# Stop other services using those ports
# Or change ports in docker-compose.yml
```

**Rebuild containers**:
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Database issues

**Error: "relation 'users' does not exist"**
```bash
# The database tables haven't been created yet
# Restart backend - it will auto-create tables in development mode
npm run dev
```

---

## 📚 Next Steps

Once everything is running:

1. **Explore the System**
   - Open http://localhost:3000
   - Check the health endpoint
   - Look at the database tables

2. **Add Authentication**
   - Follow IMPLEMENTATION_GUIDE.md Phase 1
   - Implement register/login endpoints
   - Create auth UI

3. **Build Features**
   - Follow MODULE_SPECIFICATIONS.md
   - Implement one module at a time
   - Test as you build

4. **Configure Integrations**
   - Set up Google OAuth
   - Configure Stripe
   - Add third-party APIs

---

## 🎯 Quick Commands Reference

### Docker
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# View logs for specific service
docker-compose logs -f backend

# Restart a service
docker-compose restart backend

# Rebuild and start
docker-compose up -d --build

# Clean everything
docker-compose down -v
docker system prune -a
```

### Backend
```bash
cd backend
npm run dev      # Start development server
npm run build    # Build for production
npm start        # Start production server
```

### Frontend
```bash
cd frontend
npm run dev      # Start development server
npm run build    # Build for production
npm start        # Start production server
```

### Database
```bash
# Connect to database (Docker)
docker exec -it omc-postgres psql -U omc_user -d omc_db

# Connect to database (Local)
psql -U omc_user -d omc_db

# List tables
\dt

# Describe table
\d users

# Exit
\q
```

---

## 🎉 Success!

You now have the OMC system running on your local machine!

**What you have:**
- ✅ PostgreSQL database with auto-created tables
- ✅ Redis cache
- ✅ Backend API running on port 5000
- ✅ Frontend app running on port 3000
- ✅ All services connected and communicating

**Next steps:**
1. Read IMPLEMENTATION_GUIDE.md for detailed development
2. Follow MODULE_SPECIFICATIONS.md to build features
3. Reference API_DOCUMENTATION.md for endpoints
4. Use USER_STORIES_AND_WORKFLOWS.md for testing

**Happy coding! 🚀**

---

**Document Version**: 1.0  
**Last Updated**: December 24, 2025  
**Status**: Complete Setup Guide
