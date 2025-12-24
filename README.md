# OMC (Oxford Management Consultancy) - Complete Business Management System

![OMC Logo](https://via.placeholder.com/150x50?text=OMC+Logo)

**Version**: 1.0.0  
**Status**: Development  
**License**: Proprietary

---

## 📋 Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [System Architecture](#system-architecture)
- [Technology Stack](#technology-stack)
- [Documentation](#documentation)
- [Quick Start](#quick-start)
- [Development](#development)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [Support](#support)
- [License](#license)

---

## 🎯 Overview

OMC is a comprehensive business management platform designed to provide end-to-end consultancy services for businesses in the UK. The system manages company formation, tax registrations, bookkeeping, social media, telephony, and multi-channel communication through a unified interface.

### System Purpose

OMC aims to be a **one-stop solution** for businesses to:
- Register and incorporate companies
- Handle VAT and Corporate Tax registrations
- Manage bookkeeping and financial reporting
- Control social media presence across multiple platforms
- Communicate with clients through WhatsApp, Facebook, Instagram
- Process payments and manage subscriptions
- Access professional support and assistance

### Target Users

1. **Clients**: Business owners seeking consultancy services
2. **Admins**: Service providers managing client requests
3. **Super Admins**: System administrators with full control

---

## ✨ Key Features

### For Clients

- ✅ **Company Formation**: Complete wizard-based company registration
- ✅ **VAT/CT Registration**: Apply for tax registrations with status tracking
- ✅ **Bookkeeping**: Record income/expenses, create invoices, generate reports
- ✅ **Social Media Management**: Schedule posts, track analytics
- ✅ **Multi-Channel Messaging**: Communicate via WhatsApp, Facebook, Instagram
- ✅ **Subscription Management**: Flexible pricing tiers with upgrade/downgrade options
- ✅ **Document Management**: Secure upload and storage
- ✅ **Real-Time Notifications**: Stay updated on application progress

### For Admins

- ✅ **Client Management**: View and manage assigned clients
- ✅ **Unified Inbox**: All client messages in one place (WhatsApp, FB, IG)
- ✅ **Task Queue**: Organized workflow for pending approvals
- ✅ **Status Management**: Update application statuses
- ✅ **Document Verification**: Review and approve uploads
- ✅ **Performance Dashboard**: Track metrics and KPIs

### For Super Admins

- ✅ **User Management**: Create, edit, deactivate users and admins
- ✅ **System Analytics**: Comprehensive business intelligence
- ✅ **Subscription Configuration**: Manage packages and pricing
- ✅ **Integration Settings**: Configure third-party APIs
- ✅ **Activity Logs**: Audit trail of all system actions
- ✅ **Financial Oversight**: Monitor revenue and transactions

### Integrations

- 🔗 **ZOHO Books**: Sync transactions and invoices
- 🔗 **QuickBooks Online**: Two-way accounting sync
- 🔗 **WhatsApp Business API**: Real-time messaging
- 🔗 **Facebook Messenger**: Social media communication
- 🔗 **Instagram Direct**: DM management
- 🔗 **Stripe**: Payment processing
- 🔗 **Twilio**: Telephony and SMS
- 🔗 **Google OAuth**: Single sign-on

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────┐
│              Frontend (Next.js)                 │
│  - React 18 + TypeScript                       │
│  - Tailwind CSS + Shadcn/ui                    │
│  - React Query + Zustand                       │
└──────────────────┬──────────────────────────────┘
                   │ REST API + WebSocket
┌──────────────────┴──────────────────────────────┐
│           Backend (Node.js/Express)             │
│  - TypeScript                                   │
│  - JWT Authentication                           │
│  - Role-Based Access Control                   │
└──────────────────┬──────────────────────────────┘
                   │
    ┌──────────────┼──────────────┐
    │              │              │
┌───┴────┐  ┌──────┴─────┐  ┌────┴─────┐
│PostGres│  │   Redis    │  │File Store│
│  SQL   │  │   Cache    │  │  (S3/    │
│        │  │            │  │  Local)  │
└────────┘  └────────────┘  └──────────┘
                   │
    ┌──────────────┼──────────────┐
    │              │              │
┌───┴────┐  ┌──────┴─────┐  ┌────┴─────┐
│  ZOHO  │  │ QuickBooks │  │ WhatsApp │
│  API   │  │    API     │  │   API    │
└────────┘  └────────────┘  └──────────┘
```

---

## 🛠️ Technology Stack

### Frontend
- **Framework**: Next.js 14 (React 18)
- **Language**: TypeScript
- **Styling**: Tailwind CSS, Shadcn/ui
- **State**: Zustand (global), React Query (server)
- **Forms**: React Hook Form + Zod
- **Charts**: Recharts
- **Icons**: Lucide React

### Backend
- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Language**: TypeScript
- **ORM**: Sequelize
- **Authentication**: JWT + OAuth2.0
- **Validation**: express-validator
- **File Upload**: Multer

### Database
- **Primary**: PostgreSQL 14+
- **Cache**: Redis 7+
- **Storage**: AWS S3 or Local

### DevOps
- **Containerization**: Docker + Docker Compose
- **Version Control**: Git
- **CI/CD**: GitHub Actions (planned)

---

## 📚 Documentation

Comprehensive documentation is available in the following files:

1. **[OMC_SYSTEM_OVERVIEW.md](./OMC_SYSTEM_OVERVIEW.md)** - High-level system overview, stakeholders, architecture
2. **[DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md)** - Complete database design with all tables
3. **[MODULE_SPECIFICATIONS.md](./MODULE_SPECIFICATIONS.md)** - Detailed specifications for each module
4. **[USER_STORIES_AND_WORKFLOWS.md](./USER_STORIES_AND_WORKFLOWS.md)** - User stories, workflows, journey maps
5. **[FRONTEND_ARCHITECTURE.md](./FRONTEND_ARCHITECTURE.md)** - Frontend structure, components, state management
6. **[IMPLEMENTATION_GUIDE.md](./IMPLEMENTATION_GUIDE.md)** - Step-by-step development guide
7. **[API_DOCUMENTATION.md](./API_DOCUMENTATION.md)** - Complete API reference

---

## 🚀 Quick Start

### Prerequisites

- Node.js 18+ and npm
- PostgreSQL 14+
- Redis 7+
- Docker and Docker Compose (optional but recommended)

### Installation

#### 1. Clone the Repository

```bash
git clone https://github.com/your-org/omc-system.git
cd omc-system
```

#### 2. Using Docker (Recommended)

```bash
# Start all services
docker-compose up -d

# The application will be available at:
# - Frontend: http://localhost:3000
# - Backend: http://localhost:5000
# - PostgreSQL: localhost:5432
# - Redis: localhost:6379
```

#### 3. Manual Setup

**Backend**:
```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your configuration
npm run dev
```

**Frontend**:
```bash
cd frontend
npm install
cp .env.local.example .env.local
# Edit .env.local with your configuration
npm run dev
```

### Initial Setup

1. **Create Database**:
```bash
psql -U postgres
CREATE DATABASE omc_db;
CREATE USER omc_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE omc_db TO omc_user;
\q
```

2. **Run Migrations** (when implemented):
```bash
cd backend
npm run migrate
```

3. **Seed Data** (optional):
```bash
npm run seed
```

4. **Access the Application**:
- Open http://localhost:3000
- Register a new account or use default credentials:
  - Email: `admin@omc.com`
  - Password: `Admin123!`

---

## 💻 Development

### Project Structure

```
omc-system/
├── backend/                 # Node.js/Express backend
│   ├── src/
│   │   ├── config/         # Configuration files
│   │   ├── controllers/    # Route controllers
│   │   ├── middleware/     # Express middleware
│   │   ├── models/         # Database models
│   │   ├── routes/         # API routes
│   │   ├── services/       # Business logic
│   │   └── utils/          # Utility functions
│   ├── .env.example
│   ├── package.json
│   └── tsconfig.json
├── frontend/               # Next.js frontend
│   ├── src/
│   │   ├── app/           # Next.js app router
│   │   ├── components/    # React components
│   │   ├── lib/           # Utilities, hooks, API
│   │   └── types/         # TypeScript types
│   ├── public/            # Static assets
│   ├── .env.local.example
│   ├── package.json
│   └── next.config.js
├── docs/                   # Additional documentation
├── docker-compose.yml
└── README.md
```

### Development Workflow

1. **Create Feature Branch**:
```bash
git checkout -b feature/your-feature-name
```

2. **Make Changes**:
- Follow TypeScript best practices
- Write unit tests for new features
- Update documentation as needed

3. **Test Changes**:
```bash
# Backend tests
cd backend
npm test

# Frontend tests
cd frontend
npm test
```

4. **Commit Changes**:
```bash
git add .
git commit -m "feat: add your feature description"
```

5. **Push and Create PR**:
```bash
git push origin feature/your-feature-name
```

### Coding Standards

- **TypeScript**: Strict mode enabled
- **Linting**: ESLint with recommended rules
- **Formatting**: Prettier with 2-space indentation
- **Commits**: Conventional Commits format
- **Testing**: Jest for unit tests, Cypress for E2E (planned)

---

## 🚢 Deployment

### Production Deployment (Planned)

1. **Build Frontend**:
```bash
cd frontend
npm run build
```

2. **Build Backend**:
```bash
cd backend
npm run build
```

3. **Set Environment Variables**:
- Configure production database
- Set JWT secrets
- Configure third-party API keys
- Set up file storage (S3)

4. **Deploy**:
- Use Docker containers
- Set up reverse proxy (Nginx)
- Configure SSL certificates
- Set up monitoring and logging

### Environment Variables

See `.env.example` files in backend and frontend directories for required environment variables.

---

## 🤝 Contributing

We welcome contributions from the development team! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**
3. **Make your changes**
4. **Write or update tests**
5. **Update documentation**
6. **Submit a pull request**

### Code Review Process

- All PRs require at least one approval
- CI/CD checks must pass
- Code must follow style guidelines
- Documentation must be updated

---

## 📞 Support

### For Developers

- **Documentation**: See `/docs` folder
- **Issues**: Create an issue on GitHub
- **Email**: dev-team@omc.com

### For Users

- **Help Center**: http://localhost:3000/help (when running)
- **Support Email**: support@omc.com
- **Support Tickets**: Create from dashboard

---

## 📄 License

This project is proprietary software owned by Oxford Management Consultancy. All rights reserved.

Unauthorized copying, distribution, or use of this software is strictly prohibited.

---

## 🙏 Acknowledgments

- **Development Team**: [Your Team Names]
- **Third-Party Libraries**: See package.json files
- **API Providers**: ZOHO, QuickBooks, Stripe, Twilio, Meta

---

## 📈 Project Status

- **Phase 1 (Foundation)**: ✅ Complete
- **Phase 2 (Core Modules)**: 🚧 In Progress
- **Phase 3 (Advanced Modules)**: ⏳ Planned
- **Phase 4 (Integrations)**: ⏳ Planned
- **Phase 5 (Additional Features)**: ⏳ Planned
- **Phase 6 (Testing & Deployment)**: ⏳ Planned

---

## 📝 Changelog

### Version 1.0.0 (In Development)
- Initial system design and architecture
- Complete documentation created
- Database schema designed
- Development environment setup
- Authentication module (in progress)

---

**Built with ❤️ by the OMC Development Team**

Last Updated: December 24, 2025
