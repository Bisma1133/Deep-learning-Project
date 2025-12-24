# OMC System - Sitemap and Development Roadmap

## Table of Contents

1. [Complete System Sitemap](#complete-system-sitemap)
2. [Detailed Development Roadmap](#detailed-development-roadmap)
3. [Feature Priority Matrix](#feature-priority-matrix)
4. [Technical Milestones](#technical-milestones)
5. [Risk Assessment](#risk-assessment)

---

## Complete System Sitemap

### Landing & Public Pages

```
Landing Page (/)
├── About Us (/about)
├── Services (/services)
├── Pricing (/pricing)
├── Help Center (/help)
│   ├── FAQ (/help/faq)
│   ├── Guides (/help/guides)
│   └── Contact (/help/contact)
└── Blog (/blog) [Future]

Authentication
├── Login (/login)
├── Register (/register)
├── Forgot Password (/forgot-password)
└── Reset Password (/reset-password)
```

### Client Portal

```
Client Dashboard (/dashboard)
├── Overview
│   ├── Welcome Banner
│   ├── Quick Stats Cards
│   ├── Recent Activity
│   ├── Upcoming Deadlines
│   └── Quick Actions
│
├── Companies (/dashboard/companies)
│   ├── Companies List
│   ├── Add New Company (/dashboard/companies/new)
│   │   ├── Step 1: Company Details
│   │   ├── Step 2: Registered Address
│   │   ├── Step 3: Trading Address
│   │   ├── Step 4: Directors
│   │   └── Step 5: Review & Submit
│   └── Company Details (/dashboard/companies/:id)
│       ├── Overview Tab
│       ├── Directors Tab
│       ├── Documents Tab
│       └── Activity Tab
│
├── VAT Management (/dashboard/vat)
│   ├── VAT Registrations List
│   ├── Apply for VAT (/dashboard/vat/apply)
│   ├── VAT Registration Details (/dashboard/vat/registrations/:id)
│   ├── VAT Filings List (/dashboard/vat/filings)
│   └── VAT Filing Detail (/dashboard/vat/filings/:id)
│       ├── Filing Form
│       └── Submission Confirmation
│
├── Corporate Tax (/dashboard/corporate-tax)
│   ├── CT Registrations List
│   ├── Apply for CT (/dashboard/corporate-tax/apply)
│   ├── CT Registration Details (/dashboard/corporate-tax/registrations/:id)
│   ├── CT Filings List (/dashboard/corporate-tax/filings)
│   └── CT Filing Detail (/dashboard/corporate-tax/filings/:id)
│
├── Bookkeeping (/dashboard/bookkeeping)
│   ├── Dashboard
│   │   ├── Financial Summary
│   │   ├── Recent Transactions
│   │   └── Quick Add Transaction
│   ├── Transactions (/dashboard/bookkeeping/transactions)
│   │   ├── List View
│   │   ├── Add Transaction (/dashboard/bookkeeping/transactions/new)
│   │   └── Edit Transaction (/dashboard/bookkeeping/transactions/:id/edit)
│   ├── Invoices (/dashboard/bookkeeping/invoices)
│   │   ├── List View
│   │   ├── Create Invoice (/dashboard/bookkeeping/invoices/new)
│   │   ├── Invoice Detail (/dashboard/bookkeeping/invoices/:id)
│   │   └── Edit Invoice (/dashboard/bookkeeping/invoices/:id/edit)
│   ├── Expenses (/dashboard/bookkeeping/expenses)
│   │   ├── List View
│   │   └── Add Expense (/dashboard/bookkeeping/expenses/new)
│   └── Reports (/dashboard/bookkeeping/reports)
│       ├── Profit & Loss
│       ├── Balance Sheet
│       ├── Cash Flow
│       ├── VAT Summary
│       └── Expense Analysis
│
├── Social Media (/dashboard/social-media)
│   ├── Dashboard
│   │   ├── Overview Stats
│   │   ├── Recent Posts
│   │   └── Analytics Summary
│   ├── Connected Accounts (/dashboard/social-media/accounts)
│   │   └── Connect New Account
│   ├── Posts (/dashboard/social-media/posts)
│   │   ├── List View
│   │   └── Create Post (/dashboard/social-media/posts/new)
│   ├── Calendar (/dashboard/social-media/calendar)
│   │   └── Scheduled Posts View
│   └── Analytics (/dashboard/social-media/analytics)
│       ├── Engagement Metrics
│       ├── Follower Growth
│       └── Top Performing Posts
│
├── Telephony (/dashboard/telephony)
│   ├── Dashboard
│   ├── Phone Numbers (/dashboard/telephony/numbers)
│   │   └── Purchase Number
│   ├── Call Logs (/dashboard/telephony/calls)
│   ├── SMS (/dashboard/telephony/sms)
│   │   ├── Conversations
│   │   └── Send SMS
│   └── Settings (/dashboard/telephony/settings)
│
├── Messages (/dashboard/messages)
│   ├── Inbox (All Platforms)
│   ├── Conversation View
│   └── Compose Message
│
├── Documents (/dashboard/documents)
│   ├── All Documents
│   ├── By Category
│   └── Upload Document
│
├── Subscription (/dashboard/subscription)
│   ├── Current Plan
│   ├── Usage Stats
│   ├── Upgrade/Downgrade
│   ├── Billing History
│   ├── Payment Methods
│   └── Invoices
│
├── Support (/dashboard/support)
│   ├── Submit Ticket
│   ├── My Tickets
│   ├── Ticket Details (/dashboard/support/tickets/:id)
│   ├── Knowledge Base
│   └── Contact Admin
│
└── Settings (/dashboard/settings)
    ├── Profile
    ├── Security
    │   ├── Change Password
    │   └── Two-Factor Auth [Future]
    ├── Notifications
    ├── Integrations
    │   ├── ZOHO Books
    │   └── QuickBooks
    └── Preferences
```

### Admin Portal

```
Admin Dashboard (/admin/dashboard)
├── Overview
│   ├── Stats Cards
│   ├── Recent Activity
│   ├── Task Summary
│   └── Client Overview
│
├── Clients (/admin/clients)
│   ├── All Clients List
│   ├── Client Detail (/admin/clients/:id)
│   │   ├── Profile
│   │   ├── Companies
│   │   ├── Registrations
│   │   ├── Bookkeeping
│   │   ├── Messages
│   │   └── Activity Log
│   └── Assign Client
│
├── Unified Inbox (/admin/inbox)
│   ├── All Conversations
│   ├── By Platform
│   │   ├── WhatsApp
│   │   ├── Facebook
│   │   ├── Instagram
│   │   └── Internal
│   ├── Conversation View
│   └── Message Templates
│
├── Tasks (/admin/tasks)
│   ├── All Tasks
│   ├── By Type
│   │   ├── Company Formations
│   │   ├── VAT Registrations
│   │   ├── CT Registrations
│   │   ├── Document Verifications
│   │   └── Support Tickets
│   ├── By Priority
│   └── Kanban View
│
├── Company Management (/admin/companies)
│   ├── All Companies
│   ├── Pending Approvals
│   ├── Company Detail (/admin/companies/:id)
│   └── Process Application
│
├── VAT Management (/admin/vat)
│   ├── All Registrations
│   ├── Pending Approvals
│   ├── Process Registration (/admin/vat/registrations/:id)
│   ├── All Filings
│   └── Review Filing (/admin/vat/filings/:id)
│
├── CT Management (/admin/corporate-tax)
│   ├── All Registrations
│   ├── Pending Approvals
│   ├── Process Registration
│   ├── All Filings
│   └── Review Filing
│
├── Reports (/admin/reports)
│   ├── Client Reports
│   ├── Revenue Reports
│   ├── Performance Metrics
│   └── Export Data
│
└── Settings (/admin/settings)
    ├── Profile
    ├── Notification Preferences
    └── Working Hours
```

### Super Admin Portal

```
Super Admin Dashboard (/superadmin/dashboard)
├── System Overview
│   ├── User Statistics
│   ├── Revenue Analytics
│   ├── System Health
│   └── Recent Activity
│
├── User Management (/superadmin/users)
│   ├── All Users
│   ├── Clients (/superadmin/users/clients)
│   ├── Admins (/superadmin/users/admins)
│   ├── User Detail (/superadmin/users/:id)
│   ├── Create User (/superadmin/users/new)
│   └── Bulk Actions
│
├── Admin Management (/superadmin/admins)
│   ├── All Admins
│   ├── Create Admin (/superadmin/admins/new)
│   ├── Admin Detail (/superadmin/admins/:id)
│   ├── Performance Metrics
│   └── Assign Clients
│
├── Subscription Management (/superadmin/subscriptions)
│   ├── All Subscriptions
│   ├── Active Subscriptions
│   ├── Cancelled Subscriptions
│   ├── Package Management (/superadmin/subscriptions/packages)
│   │   ├── All Packages
│   │   ├── Create Package
│   │   └── Edit Package (/superadmin/subscriptions/packages/:id/edit)
│   └── Subscription Detail (/superadmin/subscriptions/:id)
│
├── Financial Management (/superadmin/financial)
│   ├── Revenue Dashboard
│   ├── All Payments (/superadmin/financial/payments)
│   ├── Payment Detail (/superadmin/financial/payments/:id)
│   ├── Refunds (/superadmin/financial/refunds)
│   ├── Process Refund
│   └── Financial Reports
│       ├── MRR (Monthly Recurring Revenue)
│       ├── Churn Analysis
│       └── Revenue by Package
│
├── System Analytics (/superadmin/analytics)
│   ├── User Growth
│   ├── Engagement Metrics
│   ├── Feature Usage
│   ├── Performance Metrics
│   └── Custom Reports
│
├── Activity Logs (/superadmin/logs)
│   ├── User Activity
│   ├── Admin Activity
│   ├── System Events
│   ├── API Logs
│   └── Error Logs
│
├── Integration Management (/superadmin/integrations)
│   ├── ZOHO Books
│   │   ├── Configuration
│   │   ├── Connection Status
│   │   └── Sync History
│   ├── QuickBooks
│   │   ├── Configuration
│   │   ├── Connection Status
│   │   └── Sync History
│   ├── WhatsApp
│   │   ├── Configuration
│   │   └── Webhook Settings
│   ├── Facebook/Instagram
│   │   ├── Configuration
│   │   └── App Settings
│   ├── Stripe
│   │   ├── Configuration
│   │   └── Webhook Settings
│   └── Twilio
│       ├── Configuration
│       └── Phone Numbers
│
├── System Settings (/superadmin/settings)
│   ├── General Settings
│   ├── Email Configuration
│   ├── SMS Configuration
│   ├── Storage Settings
│   ├── Security Settings
│   │   ├── Password Policies
│   │   ├── Session Management
│   │   └── Rate Limiting
│   ├── Maintenance Mode
│   └── Backup & Restore
│
└── Support Management (/superadmin/support)
    ├── All Tickets
    ├── Escalated Tickets
    ├── Ticket Detail (/superadmin/support/tickets/:id)
    ├── FAQ Management
    └── Knowledge Base Editor
```

---

## Detailed Development Roadmap

### Phase 1: Foundation (Weeks 1-3)

**Week 1: Project Setup & Environment**
- ✅ Day 1-2: Initialize project structure
  - Create backend and frontend folders
  - Set up Git repository
  - Configure package.json files
  - Install core dependencies

- ✅ Day 3-4: Database Setup
  - Install PostgreSQL
  - Create database and user
  - Design and implement schema
  - Create all database models (30+ tables)
  - Set up migrations

- ✅ Day 5-7: Authentication Foundation
  - Implement JWT authentication
  - Create User model
  - Build registration endpoint
  - Build login endpoint
  - Set up password hashing
  - Create auth middleware

**Week 2: Core Backend APIs**
- Day 1-2: User Management APIs
  - Profile CRUD endpoints
  - Avatar upload
  - Password reset flow
  - Email verification

- Day 3-4: Role-Based Access Control
  - Implement RBAC middleware
  - Create permission system
  - Test access controls

- Day 5-7: Company Formation APIs
  - Company CRUD endpoints
  - Director management
  - Document upload
  - Status management

**Week 3: Frontend Foundation**
- Day 1-2: Next.js Setup
  - Initialize Next.js project
  - Configure Tailwind CSS
  - Install Shadcn/ui components
  - Set up routing structure

- Day 3-4: Authentication UI
  - Login page
  - Registration page
  - Password reset pages
  - Google OAuth button

- Day 5-7: State Management & API Integration
  - Configure Zustand stores
  - Set up React Query
  - Create Axios instance
  - Implement auth flow

---

### Phase 2: Core Modules (Weeks 4-8)

**Week 4: Dashboard Development**
- Day 1-3: Client Dashboard
  - Layout components (Header, Sidebar)
  - Dashboard widgets
  - Stats cards
  - Recent activity feed

- Day 4-7: Admin Dashboard
  - Admin layout
  - Client list view
  - Task summary widgets
  - Stats overview

**Week 5-6: Company Formation Module**
- Week 5:
  - Multi-step form wizard (frontend)
  - Form validation with Zod
  - Director management UI
  - Document upload component

- Week 6:
  - Company list view (cards + table)
  - Company detail page
  - Status timeline component
  - Admin approval interface
  - Testing and refinement

**Week 7: VAT Registration Module**
- Day 1-3: VAT Registration
  - Application form
  - VAT registration list
  - Detail view
  - Admin approval flow

- Day 4-7: CT Registration Module
  - CT application form
  - CT registration list
  - Detail view
  - Admin approval flow

**Week 8: Profile & Settings**
- Day 1-3: Profile Management
  - Profile edit form
  - Avatar upload
  - Address management
  - Preferences

- Day 4-7: User Settings
  - Change password
  - Notification settings
  - Security settings
  - Testing Phase 2

---

### Phase 3: Advanced Modules (Weeks 9-14)

**Week 9-10: Bookkeeping Module - Part 1**
- Week 9:
  - Transaction model and APIs
  - Transaction CRUD
  - Transaction list UI
  - Add/Edit transaction forms
  - Category management

- Week 10:
  - Income vs Expense views
  - Filtering and search
  - Export to CSV
  - Transaction attachments

**Week 11-12: Bookkeeping Module - Part 2**
- Week 11:
  - Invoice model and APIs
  - Invoice builder UI
  - Line items management
  - Invoice preview
  - PDF generation

- Week 12:
  - Invoice list view
  - Send invoice via email
  - Mark as paid functionality
  - Expense tracking
  - Receipt upload

**Week 13: VAT/CT Filing Module**
- Day 1-3: VAT Filing
  - VAT filing form (9-box format)
  - Auto-calculation logic
  - Import from bookkeeping
  - Filing list view
  - Deadline reminders

- Day 4-7: CT Filing
  - CT filing form
  - P&L data import
  - Filing list view
  - Submission workflow

**Week 14: Reports Module**
- Day 1-3: Financial Reports
  - Profit & Loss report
  - Balance Sheet
  - Cash Flow statement
  - Report filters (date range, company)

- Day 4-7: Report Generation
  - PDF generation
  - CSV export
  - Charts and visualizations
  - Report scheduling (future)

---

### Phase 4: Communication & Integration (Weeks 15-18)

**Week 15: Payment Integration**
- Day 1-3: Stripe Setup
  - Stripe account setup
  - Stripe SDK integration
  - Payment intent creation
  - Webhook handling

- Day 4-7: Subscription System
  - Subscription package management
  - Checkout flow
  - Payment methods management
  - Upgrade/downgrade logic
  - Cancellation flow

**Week 16: Unified Messaging - Part 1**
- Day 1-3: WhatsApp Integration
  - WhatsApp Business API setup
  - Webhook configuration
  - Receive messages
  - Send messages
  - Media support

- Day 4-7: Facebook Messenger Integration
  - Facebook app setup
  - Messenger webhook
  - Receive messages
  - Send messages
  - Page integration

**Week 17: Unified Messaging - Part 2**
- Day 1-3: Instagram Integration
  - Instagram API setup
  - DM webhook
  - Receive DMs
  - Send DMs

- Day 4-7: Unified Inbox UI
  - Conversation list
  - Message thread view
  - Platform indicators
  - Real-time updates (WebSocket)
  - Message input with emoji picker

**Week 18: Accounting Integrations**
- Day 1-4: ZOHO Books Integration
  - OAuth setup
  - Sync transactions
  - Sync invoices
  - Sync customers
  - Two-way sync logic

- Day 5-7: QuickBooks Integration
  - OAuth setup
  - Sync transactions
  - Sync invoices
  - Error handling
  - Sync status UI

---

### Phase 5: Additional Features (Weeks 19-22)

**Week 19-20: Social Media Management**
- Week 19:
  - Facebook/Instagram OAuth
  - Connect accounts
  - Account list view
  - Post creation form
  - Media upload

- Week 20:
  - Post scheduling
  - Content calendar
  - Post to multiple platforms
  - Analytics dashboard
  - Engagement metrics

**Week 21: Telephony Module**
- Day 1-4: Twilio Integration
  - Twilio account setup
  - Purchase phone number
  - Incoming call webhook
  - Outgoing call API
  - Call logs

- Day 5-7: SMS Management
  - Send SMS
  - Receive SMS
  - SMS conversations
  - SMS templates

**Week 22: Assistance & Support**
- Day 1-3: FAQ System
  - FAQ CRUD
  - FAQ categories
  - FAQ search
  - FAQ display

- Day 4-7: Support Ticket System
  - Create ticket
  - Ticket list
  - Ticket detail
  - Ticket responses
  - Ticket status management
  - Email notifications

---

### Phase 6: Testing & Deployment (Weeks 23-26)

**Week 23: Testing**
- Day 1-2: Unit Tests
  - Backend API tests
  - Service layer tests
  - Utility function tests

- Day 3-4: Integration Tests
  - API integration tests
  - Database tests
  - Third-party API mocks

- Day 5-7: Frontend Tests
  - Component tests
  - Hook tests
  - E2E tests setup

**Week 24: Security & Performance**
- Day 1-3: Security Audit
  - Input validation review
  - SQL injection prevention
  - XSS prevention
  - CSRF protection
  - Rate limiting
  - API security

- Day 4-7: Performance Optimization
  - Database query optimization
  - Caching implementation
  - Code splitting
  - Image optimization
  - Load testing

**Week 25: Documentation & Polish**
- Day 1-3: Documentation
  - API documentation (Swagger)
  - User guide
  - Admin guide
  - Developer documentation

- Day 4-7: UI/UX Polish
  - Responsive design check
  - Accessibility audit
  - Loading states
  - Error handling
  - User feedback

**Week 26: Deployment**
- Day 1-2: Production Setup
  - Server configuration
  - Database setup
  - Environment variables
  - SSL certificates
  - Domain configuration

- Day 3-4: Deployment
  - Docker images
  - Deploy backend
  - Deploy frontend
  - Configure CDN
  - Set up monitoring

- Day 5-7: Post-Deployment
  - Smoke testing
  - Performance monitoring
  - Bug fixes
  - User onboarding
  - Launch!

---

## Feature Priority Matrix

### Must-Have (P0) - Launch Blockers

| Feature | Module | Complexity | Weeks |
|---------|--------|------------|-------|
| User Authentication | Auth | Medium | 1 |
| Role-Based Access | Auth | Medium | 1 |
| Client Dashboard | Dashboard | Medium | 1 |
| Company Formation | Company | High | 2 |
| Basic Bookkeeping | Bookkeeping | High | 2 |
| Payment Processing | Payment | High | 1 |
| Subscription Management | Subscription | High | 1 |

### Should-Have (P1) - Important

| Feature | Module | Complexity | Weeks |
|---------|--------|------------|-------|
| VAT Registration | VAT | Medium | 1 |
| CT Registration | CT | Medium | 1 |
| VAT/CT Filing | Tax | Medium | 1 |
| Unified Messaging | Messaging | High | 2 |
| Admin Dashboard | Admin | Medium | 1 |
| Document Management | Documents | Medium | 1 |
| Reports | Bookkeeping | Medium | 1 |

### Could-Have (P2) - Nice to Have

| Feature | Module | Complexity | Weeks |
|---------|--------|------------|-------|
| Social Media Mgmt | Social Media | High | 2 |
| Telephony | Telephony | Medium | 1 |
| ZOHO Integration | Integration | Medium | 1 |
| QuickBooks Integration | Integration | Medium | 1 |
| Support Tickets | Support | Medium | 1 |
| Analytics Dashboard | Analytics | Medium | 1 |

### Won't-Have (P3) - Future Releases

| Feature | Module | Complexity | Future |
|---------|--------|------------|--------|
| Mobile App | Mobile | High | v2.0 |
| AI Chatbot | Support | High | v2.0 |
| Advanced Analytics | Analytics | Medium | v1.5 |
| Multi-language Support | i18n | Medium | v1.5 |
| White-label Solution | System | High | v3.0 |

---

## Technical Milestones

### Milestone 1: Alpha Release (Week 8)
**Deliverables**:
- ✅ User authentication working
- ✅ Company formation module complete
- ✅ Basic dashboards functional
- ✅ Database fully set up
- ✅ Core APIs implemented

**Success Criteria**:
- Users can register and login
- Users can submit company formation
- Admins can review and approve
- All CRUD operations work

### Milestone 2: Beta Release (Week 14)
**Deliverables**:
- ✅ Bookkeeping module complete
- ✅ VAT/CT registration working
- ✅ Filing modules functional
- ✅ Payment integration complete
- ✅ Reports generation working

**Success Criteria**:
- Users can record transactions
- Users can create invoices
- Users can file VAT returns
- Users can subscribe and pay
- Financial reports generate correctly

### Milestone 3: Release Candidate (Week 20)
**Deliverables**:
- ✅ Unified messaging complete
- ✅ Social media management working
- ✅ ZOHO/QuickBooks integrated
- ✅ Telephony functional
- ✅ Support system implemented

**Success Criteria**:
- Multi-channel messaging works
- Social posts can be scheduled
- Accounting data syncs
- Phone calls work
- Support tickets functional

### Milestone 4: Production Launch (Week 26)
**Deliverables**:
- ✅ All testing complete
- ✅ Security audit passed
- ✅ Performance optimized
- ✅ Documentation complete
- ✅ Production deployment successful

**Success Criteria**:
- All features working in production
- Performance meets targets
- Security standards met
- Users successfully onboarded
- No critical bugs

---

## Risk Assessment

### High Risk

| Risk | Impact | Mitigation |
|------|--------|------------|
| Third-party API changes | High | Use versioned APIs, implement abstraction layer |
| Data security breach | Critical | Regular security audits, encryption, access controls |
| Payment processing failures | High | Comprehensive error handling, fallback mechanisms |
| Database performance issues | High | Query optimization, caching, read replicas |

### Medium Risk

| Risk | Impact | Mitigation |
|------|--------|------------|
| WhatsApp API rate limits | Medium | Implement queuing, monitor usage, optimize messages |
| Scope creep | Medium | Strict phase planning, MVP focus, feature freeze periods |
| Integration complexity | Medium | Thorough testing, sandbox environments, phased rollout |
| Team availability | Medium | Cross-training, documentation, modular architecture |

### Low Risk

| Risk | Impact | Mitigation |
|------|--------|------------|
| UI/UX changes | Low | User testing, iterative design, feedback loops |
| Browser compatibility | Low | Use modern frameworks, progressive enhancement |
| Documentation gaps | Low | Continuous documentation, code comments |

---

## Success Metrics

### User Engagement
- **Target**: 70% of registered users active monthly
- **Measure**: Track login frequency, feature usage

### Performance
- **Target**: Page load < 2 seconds
- **Measure**: Lighthouse scores, real user monitoring

### Reliability
- **Target**: 99.9% uptime
- **Measure**: Server monitoring, error tracking

### User Satisfaction
- **Target**: NPS score > 50
- **Measure**: In-app surveys, support ticket sentiment

### Business Metrics
- **Target**: 100 active subscriptions in 6 months
- **Measure**: Subscription dashboard, revenue tracking

---

**Document Version**: 1.0  
**Last Updated**: December 24, 2025  
**Status**: Complete Development Roadmap
