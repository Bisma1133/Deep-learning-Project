# OMC System - Quick Reference Card

## 🎯 System At A Glance

**Name**: OMC (Oxford Management Consultancy)  
**Type**: Business Management Platform  
**Users**: 3 roles (Client, Admin, Super Admin)  
**Modules**: 13 core modules  
**Tech**: Next.js + Node.js + PostgreSQL  
**Timeline**: 26 weeks to production  

---

## 📁 Documentation Quick Links

| Document | Purpose | When to Read |
|----------|---------|--------------|
| [README.md](./README.md) | Project overview | First thing |
| [GETTING_STARTED.md](./GETTING_STARTED.md) | How to use docs | Start here |
| [OMC_SYSTEM_OVERVIEW.md](./OMC_SYSTEM_OVERVIEW.md) | Architecture | Planning phase |
| [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) | Database design | Building models |
| [MODULE_SPECIFICATIONS.md](./MODULE_SPECIFICATIONS.md) | Feature details | Building features |
| [USER_STORIES_AND_WORKFLOWS.md](./USER_STORIES_AND_WORKFLOWS.md) | User flows | UX design/testing |
| [FRONTEND_ARCHITECTURE.md](./FRONTEND_ARCHITECTURE.md) | UI structure | Frontend dev |
| [IMPLEMENTATION_GUIDE.md](./IMPLEMENTATION_GUIDE.md) | Step-by-step code | Starting development |
| [API_DOCUMENTATION.md](./API_DOCUMENTATION.md) | API reference | API integration |
| [SYSTEM_SITEMAP_AND_ROADMAP.md](./SYSTEM_SITEMAP_AND_ROADMAP.md) | Pages + timeline | Navigation/planning |

---

## 👥 Stakeholders

### 1. Client (Business Owner)
**Can do**:
- Register companies
- Apply for VAT/CT
- Record bookkeeping
- Create invoices
- Message admin
- Schedule social media posts
- Manage subscription

### 2. Admin (Consultant)
**Can do**:
- Manage assigned clients
- Approve applications
- Unified inbox (all platforms)
- Update statuses
- Process payments
- View client analytics

### 3. Super Admin (System Owner)
**Can do**:
- Everything admins can do
- Manage users and admins
- Configure system settings
- View system analytics
- Manage subscriptions packages
- Configure integrations

---

## 🧩 13 Core Modules

| # | Module | Key Features |
|---|--------|-------------|
| 1 | **Authentication** | Login, Register, OAuth, RBAC |
| 2 | **Dashboard** | Role-specific widgets, stats, activity |
| 3 | **Company Formation** | Multi-step form, directors, documents |
| 4 | **VAT Registration** | Apply, track status, get VAT number |
| 5 | **CT Registration** | Apply, track status, get UTR |
| 6 | **VAT/CT Filing** | File returns, track deadlines |
| 7 | **Bookkeeping** | Transactions, invoices, expenses, reports |
| 8 | **Social Media** | Multi-platform posting, scheduling, analytics |
| 9 | **Telephony** | Virtual numbers, calls, SMS |
| 10 | **Messaging** | Unified inbox (WhatsApp, FB, IG) |
| 11 | **Payment** | Subscriptions, Stripe, invoices |
| 12 | **Support** | Tickets, FAQ, knowledge base |
| 13 | **Admin Tools** | Client management, task queue |

---

## 💻 Technology Stack

### Frontend
```
Framework:    Next.js 14 (App Router)
Language:     TypeScript
Styling:      Tailwind CSS + Shadcn/ui
State:        Zustand + React Query
Forms:        React Hook Form + Zod
Icons:        Lucide React
Charts:       Recharts
```

### Backend
```
Runtime:      Node.js 18+
Framework:    Express.js
Language:     TypeScript
ORM:          Sequelize
Auth:         JWT + OAuth2.0
Validation:   express-validator
Upload:       Multer
```

### Database & Storage
```
Database:     PostgreSQL 14+
Cache:        Redis 7+
File Storage: AWS S3 or Local
```

### Third-Party Services
```
Payment:      Stripe
SMS/Calls:    Twilio
WhatsApp:     WhatsApp Business API
Social:       Facebook Graph API, Instagram Graph API
Accounting:   ZOHO Books API, QuickBooks API
Auth:         Google OAuth
Email:        SendGrid or SMTP
```

---

## 🗄️ Database Overview

**Total Tables**: 31

**Core Tables**:
- users, profiles, sessions, activity_logs
- subscription_packages, subscriptions
- companies, company_directors
- vat_registrations, ct_registrations
- vat_filings, ct_filings
- transactions, invoices, invoice_items, expenses
- social_media_accounts, social_media_posts
- telephony_numbers, call_logs, sms_logs
- messages, conversations
- payments, documents
- support_tickets, ticket_responses
- notifications, integration_credentials
- system_settings

---

## 🚀 Development Phases

| Phase | Weeks | Focus | Status |
|-------|-------|-------|--------|
| **Phase 1** | 1-3 | Foundation: Auth, Database, Core APIs | ⏳ Planned |
| **Phase 2** | 4-8 | Core: Company, VAT, CT, Dashboard | ⏳ Planned |
| **Phase 3** | 9-14 | Advanced: Bookkeeping, Filing, Reports | ⏳ Planned |
| **Phase 4** | 15-18 | Integration: Messaging, Payments, APIs | ⏳ Planned |
| **Phase 5** | 19-22 | Extra: Social Media, Telephony, Support | ⏳ Planned |
| **Phase 6** | 23-26 | Polish: Testing, Security, Deployment | ⏳ Planned |

---

## 📋 Key Endpoints (Examples)

### Authentication
```
POST   /api/v1/auth/register
POST   /api/v1/auth/login
POST   /api/v1/auth/logout
POST   /api/v1/auth/google
POST   /api/v1/auth/refresh
```

### Companies
```
GET    /api/v1/companies
POST   /api/v1/companies
GET    /api/v1/companies/:id
PUT    /api/v1/companies/:id
DELETE /api/v1/companies/:id
PUT    /api/v1/companies/:id/status  (admin)
POST   /api/v1/companies/:id/documents
```

### Bookkeeping
```
GET    /api/v1/transactions
POST   /api/v1/transactions
GET    /api/v1/invoices
POST   /api/v1/invoices
POST   /api/v1/invoices/:id/send
POST   /api/v1/invoices/:id/mark-paid
```

### Messaging
```
GET    /api/v1/conversations
GET    /api/v1/conversations/:id/messages
POST   /api/v1/messages/send
```

### Subscriptions
```
GET    /api/v1/subscription-packages
GET    /api/v1/subscriptions/current
POST   /api/v1/subscriptions/subscribe
POST   /api/v1/subscriptions/cancel
```

**Full API docs**: See [API_DOCUMENTATION.md](./API_DOCUMENTATION.md)

---

## 🎨 UI Routes (Main Pages)

### Public
```
/                    - Landing page
/login               - Login
/register            - Register
/pricing             - Subscription packages
/help                - Help center
```

### Client Portal
```
/dashboard                        - Main dashboard
/dashboard/companies              - Companies list
/dashboard/companies/new          - Add company (wizard)
/dashboard/companies/:id          - Company details
/dashboard/vat                    - VAT management
/dashboard/vat/apply              - Apply for VAT
/dashboard/bookkeeping            - Bookkeeping home
/dashboard/bookkeeping/transactions  - Transactions
/dashboard/bookkeeping/invoices   - Invoices
/dashboard/bookkeeping/reports    - Reports
/dashboard/social-media           - Social media
/dashboard/social-media/posts/new - Create post
/dashboard/messages               - Messages
/dashboard/subscription           - Subscription
/dashboard/settings               - Settings
```

### Admin Portal
```
/admin/dashboard         - Admin dashboard
/admin/clients           - Client list
/admin/clients/:id       - Client detail
/admin/inbox             - Unified inbox
/admin/tasks             - Task queue
```

### Super Admin
```
/superadmin/dashboard    - System dashboard
/superadmin/users        - User management
/superadmin/admins       - Admin management
/superadmin/subscriptions  - Subscription management
/superadmin/financial    - Financial management
/superadmin/analytics    - System analytics
/superadmin/logs         - Activity logs
/superadmin/integrations - Integration settings
/superadmin/settings     - System settings
```

---

## 🔐 Security Checklist

- [x] JWT authentication with refresh tokens
- [x] Password hashing (bcrypt)
- [x] Role-based access control (RBAC)
- [x] Input validation on all endpoints
- [x] SQL injection prevention (ORM)
- [x] XSS prevention (React escaping)
- [x] CSRF tokens
- [x] Rate limiting
- [x] HTTPS in production
- [x] Environment variables for secrets
- [x] File upload restrictions
- [x] API key encryption
- [x] Audit logging

---

## ⚡ Performance Targets

| Metric | Target |
|--------|--------|
| Page Load Time | < 2 seconds |
| API Response Time | < 500ms |
| Database Query Time | < 100ms |
| Uptime | 99.9% |
| Concurrent Users | 1000+ |

---

## 🧪 Testing Strategy

### Unit Tests
- Backend: Jest
- Frontend: Jest + React Testing Library
- Coverage: 80%+

### Integration Tests
- API endpoints
- Database operations
- Third-party integrations

### E2E Tests
- Cypress (planned)
- Critical user flows
- Cross-browser testing

---

## 🚢 Deployment Checklist

### Pre-Production
- [ ] All tests passing
- [ ] Security audit complete
- [ ] Performance optimization done
- [ ] Documentation up to date
- [ ] Database backup strategy
- [ ] Monitoring set up
- [ ] Error tracking configured

### Production
- [ ] Environment variables set
- [ ] Database migrated
- [ ] SSL certificates installed
- [ ] CDN configured
- [ ] Domain configured
- [ ] Email service configured
- [ ] Third-party APIs configured

### Post-Production
- [ ] Smoke tests passed
- [ ] Monitoring active
- [ ] Backup verified
- [ ] Rollback plan ready

---

## 📊 Key Metrics to Track

### Business Metrics
- Total users (clients)
- Active subscriptions
- Monthly recurring revenue (MRR)
- Churn rate
- Customer acquisition cost

### Technical Metrics
- API response times
- Error rates
- Database query performance
- Cache hit rates
- Server uptime

### User Metrics
- Daily active users (DAU)
- Feature usage
- User satisfaction (NPS)
- Support ticket volume
- Average session duration

---

## 🛠️ Useful Commands

### Backend
```bash
# Development
npm run dev

# Build
npm run build

# Start production
npm start

# Run tests
npm test

# Database migrations
npm run migrate

# Seed data
npm run seed
```

### Frontend
```bash
# Development
npm run dev

# Build
npm run build

# Start production
npm start

# Run tests
npm test

# Lint
npm run lint
```

### Docker
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild
docker-compose up -d --build
```

---

## 🔧 Environment Variables

### Backend (.env)
```bash
NODE_ENV=development
PORT=5000
DB_HOST=localhost
DB_NAME=omc_db
DB_USER=omc_user
DB_PASSWORD=your_password
JWT_SECRET=your_jwt_secret
STRIPE_SECRET_KEY=sk_test_...
TWILIO_ACCOUNT_SID=AC...
WHATSAPP_TOKEN=...
FRONTEND_URL=http://localhost:3000
```

### Frontend (.env.local)
```bash
NEXT_PUBLIC_API_URL=http://localhost:5000/api/v1
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
NEXT_PUBLIC_GOOGLE_CLIENT_ID=...
```

---

## 🎯 Success Criteria

### By End of Phase 2 (Week 8)
✅ Users can register and manage companies  
✅ Admins can approve applications  
✅ Basic dashboards functional  

### By End of Phase 4 (Week 18)
✅ Full bookkeeping functional  
✅ VAT/CT filing works  
✅ Payments and subscriptions work  
✅ Multi-channel messaging operational  

### By Production (Week 26)
✅ All features complete and tested  
✅ Performance optimized  
✅ Security hardened  
✅ Documentation complete  
✅ Ready for users  

---

## 📞 Support & Resources

**Documentation**: All `.md` files in project root  
**Code Examples**: See IMPLEMENTATION_GUIDE.md  
**API Reference**: See API_DOCUMENTATION.md  
**User Flows**: See USER_STORIES_AND_WORKFLOWS.md  

**Need help?** Check the documentation first, then ask the team!

---

## 🎉 Pro Tips

1. **Keep docs open**: Have relevant docs in browser tabs
2. **Follow the roadmap**: Don't skip phases
3. **Test with user stories**: Validate against actual workflows
4. **Write clean code**: TypeScript + ESLint + Prettier
5. **Document as you go**: Update docs when making changes
6. **Security first**: Never commit secrets
7. **Performance matters**: Optimize early
8. **User experience**: Think like the end user

---

**Print this page and keep it handy! 🚀**

---

**Document Version**: 1.0  
**Last Updated**: December 24, 2025  
**Quick Reference for**: OMC Development Team
