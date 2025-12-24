# How to Run the OMC System

## 🎯 Quick Overview

There are **3 ways** to get the OMC system running on your computer:

1. **Quick Start Script** ⚡ - Automated setup (5 minutes)
2. **Docker Method** 🐳 - Easiest, most reliable (30 minutes)
3. **Manual Method** 🛠️ - Full control, learn everything (2-3 hours)

---

## ⚡ Method 1: Quick Start Script (Recommended for Testing)

**Best for**: Quick demo, testing the concept

### Prerequisites
- Node.js 18+ installed
- Terminal/Command Prompt

### Steps

1. **Make the script executable** (Mac/Linux only):
```bash
chmod +x quick-start.sh
```

2. **Run the script**:
```bash
./quick-start.sh
```

3. **Follow the prompts** - the script will:
   - Check your system
   - Install dependencies
   - Set up database (if Docker available)
   - Create project files
   - Guide you to start the servers

4. **Start the system** (in separate terminals):
```bash
# Terminal 1 - Backend
cd omc-system/backend
npm run dev

# Terminal 2 - Frontend  
cd omc-system/frontend
npm run dev
```

5. **Open in browser**:
   - Frontend: http://localhost:3000
   - Backend: http://localhost:5000/health

⏱️ **Time**: ~5-10 minutes

---

## 🐳 Method 2: Docker Setup (Recommended for Development)

**Best for**: Full development, team collaboration, production-like environment

### Prerequisites
- Docker Desktop installed
- 8GB RAM minimum
- 10GB free disk space

### Quick Docker Start

1. **Install Docker Desktop**:
   - Mac: https://www.docker.com/products/docker-desktop
   - Windows: https://www.docker.com/products/docker-desktop
   - Linux: `curl -fsSL https://get.docker.com | sh`

2. **Clone/Create project** (if not already done):
```bash
mkdir omc-system && cd omc-system
```

3. **Get the docker-compose.yml** from SETUP_AND_RUN_GUIDE.md or create it

4. **Start everything**:
```bash
docker-compose up -d
```

5. **That's it!** Everything is running:
   - Frontend: http://localhost:3000
   - Backend: http://localhost:5000
   - PostgreSQL: localhost:5432
   - Redis: localhost:6379

### Docker Commands

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Restart specific service
docker-compose restart backend

# Rebuild and start
docker-compose up -d --build

# Clean everything
docker-compose down -v
```

⏱️ **Time**: ~30 minutes (first time setup)

---

## 🛠️ Method 3: Manual Setup

**Best for**: Learning, customization, no Docker available

### Prerequisites
- Node.js 18+
- PostgreSQL 14+
- Redis 7+
- Git

### Installation Steps

**See detailed guide**: [SETUP_AND_RUN_GUIDE.md](./SETUP_AND_RUN_GUIDE.md) - Method 2

**Summary**:

1. Install Node.js, PostgreSQL, Redis
2. Create database and user
3. Setup backend project
4. Setup frontend project
5. Start both servers separately

⏱️ **Time**: 2-3 hours (first time)

---

## 📊 Comparison

| Feature | Quick Start | Docker | Manual |
|---------|-------------|--------|--------|
| **Setup Time** | 5-10 min | 30 min | 2-3 hours |
| **Difficulty** | Easy | Easy | Medium |
| **Prerequisites** | Node.js only | Docker only | Node, PG, Redis |
| **Best For** | Quick test | Development | Learning |
| **Reliability** | Medium | High | Medium |
| **Team Use** | No | Yes | Yes |
| **Production-like** | No | Yes | Yes |

---

## ✅ Verification Steps

After starting the system, verify it's working:

### 1. Check Backend
```bash
curl http://localhost:5000/health
```
**Expected**: `{"status":"OK","timestamp":"...","service":"OMC Backend API"}`

### 2. Check Frontend
- Open http://localhost:3000 in browser
- Should see "OMC System" landing page
- Should see green "✅ System is running successfully!"

### 3. Check Database (if using Docker)
```bash
docker exec -it omc-postgres psql -U omc_user -d omc_db -c "\dt"
```
**Expected**: List of tables (including `users`)

### 4. Check Redis (if using Docker)
```bash
docker exec -it omc-redis redis-cli ping
```
**Expected**: `PONG`

---

## 🐛 Common Issues

### Port Already in Use

**Error**: `Port 5000 is already in use`

**Solution**:
```bash
# Find what's using the port
lsof -i :5000  # Mac/Linux
netstat -ano | findstr :5000  # Windows

# Kill it or change port in .env file
PORT=5001
```

### Cannot Connect to Database

**Error**: `ECONNREFUSED` or `Database connection failed`

**Solution**:
```bash
# Check if PostgreSQL is running
docker-compose ps  # If Docker
pg_isready  # If local

# Check credentials in .env match database
cat backend/.env
```

### npm Install Fails

**Error**: `EACCES` or permission errors

**Solution**:
```bash
# Clear npm cache
npm cache clean --force

# Try with different node version
nvm install 18
nvm use 18

# Or install without sudo (Linux)
npm config set prefix ~/.npm-global
```

### Docker Won't Start

**Error**: `Cannot connect to Docker daemon`

**Solution**:
- Make sure Docker Desktop is running (Mac/Windows)
- Start Docker service: `sudo systemctl start docker` (Linux)
- Restart Docker Desktop

---

## 🎯 What You Get After Setup

After successful setup, you'll have:

✅ **Backend API** running on port 5000
- Express.js server
- PostgreSQL database with tables
- Redis cache
- Health check endpoint
- RESTful API ready

✅ **Frontend** running on port 3000  
- Next.js app
- Tailwind CSS styled
- Landing page
- Ready for development

✅ **Database** with schema
- Users table
- Auto-migrations (dev mode)
- Seed data (optional)

✅ **Development Environment**
- Hot reload on both frontend and backend
- TypeScript compilation
- ESLint configured
- Prettier ready

---

## 📚 Next Steps After Running

Once your system is running:

### 1. Explore the System
- Visit http://localhost:3000
- Check the landing page
- Test the health endpoint

### 2. Read the Documentation
- **GETTING_STARTED.md** - Where to begin
- **IMPLEMENTATION_GUIDE.md** - Start building features
- **MODULE_SPECIFICATIONS.md** - What to build
- **API_DOCUMENTATION.md** - API reference

### 3. Start Building
- Follow Phase 1 in IMPLEMENTATION_GUIDE.md
- Implement authentication
- Add your first feature
- Test as you build

### 4. Customize
- Update environment variables
- Add third-party API keys (Stripe, Google OAuth, etc.)
- Configure email service
- Set up integrations

---

## 🚀 Production Deployment (Future)

This setup is for **development only**. For production:

1. **Build for production**:
```bash
cd backend && npm run build
cd frontend && npm run build
```

2. **Use production databases** (not localhost)

3. **Set up proper environment variables**

4. **Use PM2 or similar** for process management

5. **Configure nginx** as reverse proxy

6. **Set up SSL certificates**

7. **Configure monitoring** and logging

**See**: Deployment section in IMPLEMENTATION_GUIDE.md (when ready)

---

## 📞 Getting Help

### Documentation Order
1. This file (HOW_TO_RUN.md) - You are here
2. SETUP_AND_RUN_GUIDE.md - Detailed setup instructions
3. GETTING_STARTED.md - How to use all documentation
4. IMPLEMENTATION_GUIDE.md - How to build features

### Troubleshooting
- Check SETUP_AND_RUN_GUIDE.md "Troubleshooting" section
- Review error messages carefully
- Verify prerequisites are installed
- Check .env file configuration

### Resources
- **Quick Reference**: QUICK_REFERENCE.md
- **System Overview**: OMC_SYSTEM_OVERVIEW.md
- **Database Schema**: DATABASE_SCHEMA.md
- **API Docs**: API_DOCUMENTATION.md

---

## ⚡ TL;DR - Super Quick Start

**If you just want to see it working NOW**:

```bash
# Option 1: With Docker (if installed)
docker-compose up -d
# Open http://localhost:3000

# Option 2: Run the script
chmod +x quick-start.sh
./quick-start.sh
# Follow prompts, then start servers
```

That's it! 🎉

---

## 🎊 Success Criteria

Your system is successfully running when:

- ✅ Frontend loads at http://localhost:3000
- ✅ You see "OMC System" heading
- ✅ You see green "✅ System is running successfully!"
- ✅ Backend responds at http://localhost:5000/health
- ✅ No error messages in terminal
- ✅ Both servers show "watching for changes"

**Congratulations!** You now have the OMC system running locally! 🚀

---

**Document Version**: 1.0  
**Last Updated**: December 24, 2025  
**Difficulty**: Easy to Medium  
**Time Required**: 5 minutes - 3 hours (depending on method)
