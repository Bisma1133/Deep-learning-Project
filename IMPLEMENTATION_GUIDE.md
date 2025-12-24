# OMC System - Step-by-Step Implementation Guide

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Development Environment Setup](#development-environment-setup)
3. [Project Initialization](#project-initialization)
4. [Phase 1: Foundation](#phase-1-foundation)
5. [Phase 2: Core Modules](#phase-2-core-modules)
6. [Phase 3: Advanced Modules](#phase-3-advanced-modules)
7. [Phase 4: Communication & Integration](#phase-4-communication--integration)
8. [Phase 5: Additional Features](#phase-5-additional-features)
9. [Phase 6: Testing & Deployment](#phase-6-testing--deployment)
10. [Localhost Deployment Instructions](#localhost-deployment-instructions)

---

## Prerequisites

Before starting development, ensure you have the following installed:

### Required Software
- **Node.js**: v18.x or higher (LTS recommended)
- **npm** or **yarn**: Latest version
- **PostgreSQL**: v14 or higher
- **Redis**: v7 or higher
- **Git**: Latest version
- **Docker** & **Docker Compose**: For containerization (optional but recommended)

### Recommended Tools
- **VS Code** or **WebStorm**: IDE with TypeScript support
- **Postman** or **Insomnia**: API testing
- **pgAdmin** or **DBeaver**: Database management
- **Redis Commander**: Redis GUI

### Accounts Needed
- **Google Cloud**: For OAuth (create OAuth 2.0 credentials)
- **Stripe**: For payment processing (test account)
- **Twilio**: For telephony (trial account)
- **Facebook Developer**: For Facebook/Instagram API
- **Meta WhatsApp Business**: For WhatsApp API
- **ZOHO**: For ZOHO Books integration
- **QuickBooks**: For QuickBooks Online integration

---

## Development Environment Setup

### Step 1: Install Node.js and npm

```bash
# Check if Node.js is installed
node --version

# Check npm version
npm --version

# If not installed, download from https://nodejs.org/
# Or use nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18
```

### Step 2: Install PostgreSQL

#### On macOS:
```bash
brew install postgresql@14
brew services start postgresql@14
```

#### On Ubuntu/Debian:
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

#### On Windows:
- Download installer from https://www.postgresql.org/download/windows/
- Run installer and follow setup wizard

#### Create Database:
```bash
# Log into PostgreSQL
sudo -u postgres psql

# Create database and user
CREATE DATABASE omc_db;
CREATE USER omc_user WITH PASSWORD 'your_secure_password';
GRANT ALL PRIVILEGES ON DATABASE omc_db TO omc_user;
\q
```

### Step 3: Install Redis

#### On macOS:
```bash
brew install redis
brew services start redis
```

#### On Ubuntu/Debian:
```bash
sudo apt update
sudo apt install redis-server
sudo systemctl start redis-server
sudo systemctl enable redis-server
```

#### On Windows:
- Download from https://github.com/microsoftarchive/redis/releases
- Or use WSL (Windows Subsystem for Linux)

### Step 4: Install Docker (Optional but Recommended)

```bash
# On macOS/Windows: Download Docker Desktop
# https://www.docker.com/products/docker-desktop

# On Linux:
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

---

## Project Initialization

### Step 1: Create Project Directory Structure

```bash
# Create main project directory
mkdir omc-system
cd omc-system

# Initialize Git
git init

# Create subdirectories
mkdir backend frontend docs

# Create .gitignore
cat > .gitignore << 'EOF'
# Node modules
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment files
.env
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Build outputs
dist/
build/
*.log

# Database
*.sqlite

# Uploads
uploads/
tmp/
EOF
```

### Step 2: Initialize Backend

```bash
cd backend

# Initialize npm project
npm init -y

# Install core dependencies
npm install express cors dotenv helmet morgan
npm install pg pg-hstore sequelize
npm install redis ioredis
npm install jsonwebtoken bcryptjs
npm install express-validator
npm install multer
npm install winston

# Install dev dependencies
npm install -D nodemon typescript @types/node @types/express
npm install -D @types/cors @types/bcryptjs @types/jsonwebtoken
npm install -D eslint prettier

# Initialize TypeScript
npx tsc --init
```

### Step 3: Configure TypeScript

Edit `backend/tsconfig.json`:

```json
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
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### Step 4: Create Backend Project Structure

```bash
# Create directory structure
mkdir -p src/{config,controllers,middleware,models,routes,services,utils,types}

# Create main files
touch src/server.ts
touch src/app.ts
touch .env.example
```

### Step 5: Setup Environment Variables

Create `backend/.env.example`:

```bash
# Server
NODE_ENV=development
PORT=5000
API_VERSION=v1

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=omc_db
DB_USER=omc_user
DB_PASSWORD=your_secure_password

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# JWT
JWT_SECRET=your_jwt_secret_key_change_in_production
JWT_REFRESH_SECRET=your_refresh_secret_key_change_in_production
JWT_EXPIRE=1h
JWT_REFRESH_EXPIRE=30d

# Google OAuth
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
GOOGLE_CALLBACK_URL=http://localhost:5000/api/v1/auth/google/callback

# Stripe
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_publishable_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret

# Twilio
TWILIO_ACCOUNT_SID=your_twilio_account_sid
TWILIO_AUTH_TOKEN=your_twilio_auth_token
TWILIO_PHONE_NUMBER=+1234567890

# WhatsApp
WHATSAPP_TOKEN=your_whatsapp_token
WHATSAPP_PHONE_NUMBER_ID=your_phone_number_id
WHATSAPP_VERIFY_TOKEN=your_verify_token

# Facebook/Instagram
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret

# ZOHO
ZOHO_CLIENT_ID=your_zoho_client_id
ZOHO_CLIENT_SECRET=your_zoho_client_secret
ZOHO_REDIRECT_URI=http://localhost:5000/api/v1/integrations/zoho/callback

# QuickBooks
QUICKBOOKS_CLIENT_ID=your_quickbooks_client_id
QUICKBOOKS_CLIENT_SECRET=your_quickbooks_client_secret
QUICKBOOKS_REDIRECT_URI=http://localhost:5000/api/v1/integrations/quickbooks/callback

# Email (SendGrid or SMTP)
EMAIL_PROVIDER=smtp
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_app_password
EMAIL_FROM=noreply@omc.com

# File Storage
STORAGE_TYPE=local
UPLOAD_DIR=./uploads
MAX_FILE_SIZE=10485760

# AWS S3 (if using cloud storage)
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=us-east-1
AWS_S3_BUCKET=

# Frontend URL
FRONTEND_URL=http://localhost:3000

# Admin Email
ADMIN_EMAIL=admin@omc.com
```

Copy to actual `.env`:
```bash
cp .env.example .env
# Edit .env with your actual credentials
```

### Step 6: Initialize Frontend

```bash
cd ../frontend

# Create React app with TypeScript
npx create-next-app@latest . --typescript --tailwind --app --src-dir --import-alias "@/*"

# Or if using Vite:
npm create vite@latest . -- --template react-ts

# Install additional dependencies
npm install axios
npm install react-query
npm install zustand
npm install react-hook-form
npm install @stripe/stripe-js @stripe/react-stripe-js
npm install socket.io-client
npm install date-fns
npm install react-calendar
npm install recharts
npm install react-dropzone
npm install react-hot-toast

# UI Libraries (choose one)
npm install @mui/material @mui/icons-material @emotion/react @emotion/styled
# OR
npm install @radix-ui/react-dialog @radix-ui/react-dropdown-menu
npm install class-variance-authority clsx tailwind-merge lucide-react
```

---

## Phase 1: Foundation

### Week 1-3: Core Backend Setup

#### Day 1-2: Database Setup

**Task**: Create database models using Sequelize ORM

1. **Install Sequelize CLI**:
```bash
cd backend
npm install -D sequelize-cli
npx sequelize-cli init
```

2. **Configure Sequelize** (`src/config/database.ts`):
```typescript
import { Sequelize } from 'sequelize';
import dotenv from 'dotenv';

dotenv.config();

export const sequelize = new Sequelize({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT),
  database: process.env.DB_NAME,
  username: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
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
  } catch (error) {
    console.error('❌ Database connection failed:', error);
    process.exit(1);
  }
};
```

3. **Create User Model** (`src/models/User.ts`):
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
  deleted_at?: Date;
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
  public deleted_at?: Date;
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
      validate: {
        isEmail: true
      }
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
    },
    deleted_at: {
      type: DataTypes.DATE,
      allowNull: true
    }
  },
  {
    sequelize,
    tableName: 'users',
    timestamps: true,
    underscored: true,
    paranoid: true,
    indexes: [
      { fields: ['email'] },
      { fields: ['role'] },
      { fields: ['google_id'] }
    ]
  }
);
```

4. **Create all other models** following the DATABASE_SCHEMA.md document.

#### Day 3-5: Authentication System

1. **Create Auth Service** (`src/services/authService.ts`):
```typescript
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { User } from '../models/User';

export class AuthService {
  // Register new user
  async register(data: {
    email: string;
    password: string;
    first_name: string;
    last_name: string;
    phone?: string;
  }) {
    // Check if user exists
    const existingUser = await User.findOne({ where: { email: data.email } });
    if (existingUser) {
      throw new Error('User with this email already exists');
    }

    // Hash password
    const password_hash = await bcrypt.hash(data.password, 10);

    // Create user
    const user = await User.create({
      ...data,
      password_hash,
      role: 'client',
      auth_provider: 'email'
    });

    // Generate verification token
    const verificationToken = this.generateToken(user.id, '24h');

    // Send verification email (implement later)
    // await emailService.sendVerificationEmail(user.email, verificationToken);

    return { user, verificationToken };
  }

  // Login
  async login(email: string, password: string) {
    // Find user
    const user = await User.findOne({ where: { email } });
    if (!user) {
      throw new Error('Invalid credentials');
    }

    // Check if user is active
    if (!user.is_active) {
      throw new Error('Account is deactivated');
    }

    // Verify password
    const isValid = await bcrypt.compare(password, user.password_hash || '');
    if (!isValid) {
      throw new Error('Invalid credentials');
    }

    // Generate tokens
    const accessToken = this.generateToken(user.id, process.env.JWT_EXPIRE || '1h');
    const refreshToken = this.generateToken(user.id, process.env.JWT_REFRESH_EXPIRE || '30d', true);

    // Update last login
    await user.update({ last_login_at: new Date() });

    return {
      user: this.sanitizeUser(user),
      accessToken,
      refreshToken
    };
  }

  // Generate JWT token
  generateToken(userId: number, expiresIn: string, isRefresh: boolean = false) {
    const secret = isRefresh ? process.env.JWT_REFRESH_SECRET : process.env.JWT_SECRET;
    return jwt.sign({ userId, isRefresh }, secret!, { expiresIn });
  }

  // Verify token
  verifyToken(token: string, isRefresh: boolean = false) {
    const secret = isRefresh ? process.env.JWT_REFRESH_SECRET : process.env.JWT_SECRET;
    return jwt.verify(token, secret!) as { userId: number };
  }

  // Sanitize user data
  sanitizeUser(user: User) {
    const { password_hash, ...sanitized } = user.toJSON();
    return sanitized;
  }
}
```

2. **Create Auth Controller** (`src/controllers/authController.ts`):
```typescript
import { Request, Response } from 'express';
import { AuthService } from '../services/authService';
import { validationResult } from 'express-validator';

const authService = new AuthService();

export class AuthController {
  async register(req: Request, res: Response) {
    try {
      // Validate input
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const { user, verificationToken } = await authService.register(req.body);

      res.status(201).json({
        success: true,
        message: 'User registered successfully. Please check your email to verify your account.',
        data: { user }
      });
    } catch (error: any) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  async login(req: Request, res: Response) {
    try {
      const { email, password } = req.body;
      const { user, accessToken, refreshToken } = await authService.login(email, password);

      res.json({
        success: true,
        data: {
          user,
          access_token: accessToken,
          refresh_token: refreshToken,
          expires_in: 3600
        }
      });
    } catch (error: any) {
      res.status(401).json({
        success: false,
        message: error.message
      });
    }
  }

  async logout(req: Request, res: Response) {
    // Implement session invalidation
    res.json({
      success: true,
      message: 'Logged out successfully'
    });
  }
}
```

3. **Create Auth Routes** (`src/routes/authRoutes.ts`):
```typescript
import { Router } from 'express';
import { body } from 'express-validator';
import { AuthController } from '../controllers/authController';

const router = Router();
const authController = new AuthController();

// Register
router.post(
  '/register',
  [
    body('email').isEmail().normalizeEmail(),
    body('password').isLength({ min: 8 }),
    body('first_name').notEmpty().trim(),
    body('last_name').notEmpty().trim()
  ],
  authController.register.bind(authController)
);

// Login
router.post(
  '/login',
  [
    body('email').isEmail().normalizeEmail(),
    body('password').notEmpty()
  ],
  authController.login.bind(authController)
);

// Logout
router.post('/logout', authController.logout.bind(authController));

export default router;
```

4. **Create Auth Middleware** (`src/middleware/auth.ts`):
```typescript
import { Request, Response, NextFunction } from 'express';
import { AuthService } from '../services/authService';
import { User } from '../models/User';

const authService = new AuthService();

export interface AuthRequest extends Request {
  user?: User;
}

export const authenticate = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const token = authHeader.substring(7);
    const { userId } = authService.verifyToken(token);

    const user = await User.findByPk(userId);
    if (!user || !user.is_active) {
      return res.status(401).json({ error: 'Invalid token' });
    }

    req.user = user;
    next();
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
};

export const requireRole = (roles: string[]) => {
  return (req: AuthRequest, res: Response, next: NextFunction) => {
    if (!req.user || !roles.includes(req.user.role)) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    next();
  };
};
```

#### Day 6-7: Setup Express Server

**Create App** (`src/app.ts`):
```typescript
import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import authRoutes from './routes/authRoutes';

const app: Application = express();

// Middleware
app.use(helmet());
app.use(cors({
  origin: process.env.FRONTEND_URL,
  credentials: true
}));
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/v1/auth', authRoutes);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Error handler
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Internal server error' });
});

export default app;
```

**Create Server** (`src/server.ts`):
```typescript
import dotenv from 'dotenv';
import app from './app';
import { connectDB, sequelize } from './config/database';

dotenv.config();

const PORT = process.env.PORT || 5000;

async function startServer() {
  try {
    // Connect to database
    await connectDB();

    // Sync models (development only)
    if (process.env.NODE_ENV === 'development') {
      await sequelize.sync({ alter: true });
      console.log('✅ Database synchronized');
    }

    // Start server
    app.listen(PORT, () => {
      console.log(`🚀 Server running on http://localhost:${PORT}`);
      console.log(`📝 Environment: ${process.env.NODE_ENV}`);
    });
  } catch (error) {
    console.error('❌ Failed to start server:', error);
    process.exit(1);
  }
}

startServer();
```

**Update package.json scripts**:
```json
{
  "scripts": {
    "dev": "nodemon --exec ts-node src/server.ts",
    "build": "tsc",
    "start": "node dist/server.js",
    "lint": "eslint src --ext .ts",
    "format": "prettier --write 'src/**/*.ts'"
  }
}
```

**Run the server**:
```bash
npm run dev
```

Test authentication endpoints:
```bash
# Register
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Test1234!","first_name":"John","last_name":"Doe"}'

# Login
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Test1234!"}'
```

---

## Phase 2-6: Continue Implementation

Due to the extensive nature of this guide, the remaining phases follow similar patterns:

### Phase 2: Core Modules (Weeks 4-8)
- Implement Company Formation module
- Implement VAT Registration module
- Implement CT Registration module
- Create role-specific dashboards
- Implement profile management

### Phase 3: Advanced Modules (Weeks 9-14)
- Implement Bookkeeping module
- Implement VAT/CT Filing module
- Integrate Stripe for payments
- Implement subscription management
- Create admin management interface

### Phase 4: Communication & Integration (Weeks 15-18)
- Build unified messaging inbox
- Integrate WhatsApp Business API
- Integrate Facebook/Instagram APIs
- Integrate ZOHO Books
- Integrate QuickBooks Online

### Phase 5: Additional Features (Weeks 19-22)
- Implement Social Media Management
- Implement Telephony module (Twilio)
- Create assistance/help pages
- Build notification system
- Setup email notifications

### Phase 6: Testing & Deployment (Weeks 23-26)
- Write unit tests
- Write integration tests
- Perform security audit
- Optimize performance
- Create deployment scripts

---

## Localhost Deployment Instructions

### Using Docker Compose (Recommended)

1. **Create `docker-compose.yml`** in project root:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:14-alpine
    environment:
      POSTGRES_DB: omc_db
      POSTGRES_USER: omc_user
      POSTGRES_PASSWORD: your_secure_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  backend:
    build: ./backend
    ports:
      - "5000:5000"
    environment:
      - NODE_ENV=development
      - DB_HOST=postgres
      - REDIS_HOST=redis
    depends_on:
      - postgres
      - redis
    volumes:
      - ./backend:/app
      - /app/node_modules

  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - NEXT_PUBLIC_API_URL=http://localhost:5000/api/v1
    depends_on:
      - backend
    volumes:
      - ./frontend:/app
      - /app/node_modules

volumes:
  postgres_data:
  redis_data:
```

2. **Create Dockerfile for backend**:
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 5000
CMD ["npm", "run", "dev"]
```

3. **Start all services**:
```bash
docker-compose up -d
```

### Manual Setup

1. **Start PostgreSQL**:
```bash
# Make sure PostgreSQL is running
sudo systemctl start postgresql
# Or on macOS
brew services start postgresql
```

2. **Start Redis**:
```bash
# Make sure Redis is running
sudo systemctl start redis
# Or on macOS
brew services start redis
```

3. **Start Backend**:
```bash
cd backend
npm install
npm run dev
```

4. **Start Frontend** (in new terminal):
```bash
cd frontend
npm install
npm run dev
```

5. **Access the application**:
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000
- API Health: http://localhost:5000/health

---

## Next Steps After Initial Setup

1. **Configure third-party integrations** (Google OAuth, Stripe, etc.)
2. **Create seed data** for testing
3. **Build frontend components** following the UI specifications
4. **Implement WebSocket** for real-time features
5. **Set up email service** for notifications
6. **Configure file upload** for documents
7. **Implement logging** and monitoring
8. **Create API documentation** using Swagger/OpenAPI

---

**Document Version**: 1.0  
**Last Updated**: December 24, 2025  
**Status**: Implementation Guide - Foundation Complete
