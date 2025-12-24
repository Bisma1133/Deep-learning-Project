# OMC (Oxford Management Consultancy) - System Overview

## Executive Summary

OMC is a comprehensive business management platform designed to provide end-to-end consultancy services including company formation, tax registration, bookkeeping, social media management, and telephony services. The system serves multiple stakeholders with role-based access and integrates with popular third-party services.

## System Vision

A unified platform where clients can:
- Manage all business compliance requirements (company formation, VAT, corporate tax)
- Handle bookkeeping and financial operations
- Manage social media presence
- Access telephony services
- Communicate through multiple channels (WhatsApp, Facebook, Instagram)
- Subscribe to different service tiers
- Receive professional assistance

## Core Objectives

1. **Centralized Management**: Single dashboard for all business operations
2. **Multi-Channel Communication**: Unified inbox for all messaging platforms
3. **Automation**: Integration with ZOHO, QuickBooks for seamless data flow
4. **Scalability**: Support multiple subscription tiers
5. **Role-Based Access**: Different interfaces for users, admins, and super admins
6. **Compliance**: Automated VAT/CT filing and tracking

## System Stakeholders

### 1. **Super Admin**
- **Role**: System-wide administrator with highest privileges
- **Responsibilities**:
  - Manage all admins and users
  - Configure system settings
  - Monitor system health and analytics
  - Manage subscription packages
  - Financial oversight of all transactions
  - Configure integrations (ZOHO, QuickBooks, WhatsApp)

### 2. **Admin**
- **Role**: Service provider/consultant for clients
- **Responsibilities**:
  - Manage assigned clients
  - Respond to client messages from unified inbox
  - Update client company formation details
  - Process VAT/CT registrations and filings
  - Manage bookkeeping for clients
  - Handle social media management
  - Process client payments
  - Access client dashboards

### 3. **Client/User**
- **Role**: Business owner using OMC services
- **Responsibilities**:
  - View personal dashboard
  - Submit company formation requests
  - Apply for VAT/CT registration
  - Upload bookkeeping documents
  - Monitor social media analytics
  - Use telephony services
  - Communicate with admin via messaging
  - Make payments for services
  - Upgrade/downgrade subscription

### 4. **Guest**
- **Role**: Unregistered visitor
- **Responsibilities**:
  - View landing page
  - Access assistance/help pages
  - Sign up for account
  - View subscription packages

## Technology Stack Recommendations

### Frontend
- **Framework**: React.js or Next.js
- **UI Library**: Material-UI or Tailwind CSS + Shadcn/ui
- **State Management**: Redux Toolkit or Zustand
- **Authentication**: NextAuth.js or Firebase Auth

### Backend
- **Framework**: Node.js with Express.js OR Django (Python)
- **API Architecture**: RESTful API + WebSockets for real-time messaging
- **Authentication**: JWT + OAuth2.0 (Google Sign-In)

### Database
- **Primary Database**: PostgreSQL (relational data)
- **Cache**: Redis (sessions, real-time data)
- **File Storage**: AWS S3 or local storage for development

### Third-Party Integrations
- **Accounting**: ZOHO Books API, QuickBooks API
- **Messaging**: WhatsApp Business API, Facebook Messenger API, Instagram Graph API
- **Payments**: Stripe or PayPal
- **Email**: SendGrid or AWS SES
- **SMS/Telephony**: Twilio

### DevOps & Deployment
- **Containerization**: Docker
- **Local Development**: docker-compose
- **Version Control**: Git
- **Environment Management**: dotenv

## High-Level System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Client Layer                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Web App │  │ Mobile   │  │  Admin   │  │  Super   │   │
│  │          │  │   App    │  │  Panel   │  │  Admin   │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    API Gateway / Load Balancer               │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Auth Service │  │  API Server  │  │  WebSocket   │
│              │  │              │  │   Server     │
└──────────────┘  └──────────────┘  └──────────────┘
        │                   │                   │
        └───────────────────┼───────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    Business Logic Layer                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Company  │  │   VAT    │  │Bookkeep  │  │  Social  │   │
│  │Formation │  │  Module  │  │  Module  │  │  Media   │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │Telephony │  │ Messaging│  │ Payment  │  │  User    │   │
│  │  Module  │  │  Module  │  │  Module  │  │Management│   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  PostgreSQL  │  │    Redis     │  │ File Storage │
│   Database   │  │    Cache     │  │     (S3)     │
└──────────────┘  └──────────────┘  └──────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│              External Integrations Layer                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │   ZOHO   │  │QuickBooks│  │ WhatsApp │  │  Stripe  │   │
│  │   API    │  │   API    │  │   API    │  │   API    │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                  │
│  │ Facebook │  │Instagram │  │  Twilio  │                  │
│  │   API    │  │   API    │  │   API    │                  │
│  └──────────┘  └──────────┘  └──────────┘                  │
└─────────────────────────────────────────────────────────────┘
```

## System Modules Overview

### 1. Authentication & User Management Module
- User registration (email/password + Google OAuth)
- Login/Logout functionality
- Password reset
- Role-based access control (RBAC)
- User profile management
- Session management

### 2. Dashboard Module
- Role-specific dashboards (Super Admin, Admin, User)
- Real-time analytics and metrics
- Quick access to all modules
- Notification center
- Activity logs

### 3. Company Formation Module
- Company details management
- Document upload and storage
- Registration status tracking
- Company verification
- Multi-step form workflow

### 4. VAT Registration Module
- VAT application submission
- Document management
- Status tracking
- HMRC integration (if applicable)
- VAT number verification

### 5. Corporate Tax (CT) Registration Module
- CT application submission
- Registration status tracking
- Tax reference management
- Document upload
- Deadline tracking

### 6. VAT/CT Filing Module
- Automated filing reminders
- Return preparation
- Submission tracking
- Historical filings view
- Integration with ZOHO/QuickBooks for data

### 7. Bookkeeping Module
- Transaction recording
- Invoice management
- Expense tracking
- Financial reports (P&L, Balance Sheet)
- Bank reconciliation
- Integration with ZOHO Books/QuickBooks

### 8. Social Media Management Module
- Multi-platform posting (Facebook, Instagram, LinkedIn)
- Content calendar
- Analytics and insights
- Post scheduling
- Engagement tracking

### 9. Telephony Module
- Virtual phone numbers
- Call logs
- Call recording
- SMS functionality
- Integration with Twilio

### 10. Unified Messaging/Inbox Module
- Multi-channel message aggregation (WhatsApp, Facebook, Instagram)
- Conversation threads by client
- Message tagging and filtering
- Admin response interface
- Real-time notifications

### 11. Payment Module
- Subscription management
- One-time payments
- Payment history
- Invoice generation
- Multiple payment methods (Stripe, PayPal)
- Automatic billing

### 12. Subscription & Packages Module
- Package definition (Basic, Professional, Enterprise)
- Feature toggles by package
- Upgrade/downgrade workflow
- Free trial management
- Usage tracking

### 13. Assistance/Help Module
- FAQ section
- Knowledge base
- Support ticket system
- Live chat (optional)
- Video tutorials

### 14. Admin Management Module
- Client assignment
- Admin activity logs
- Performance metrics
- Task management
- Client communication tools

## Key Features Breakdown

### User Features
✓ Sign up with email or Google  
✓ Personal dashboard with service overview  
✓ Submit company formation requests  
✓ Apply for VAT/CT registration  
✓ Upload bookkeeping documents  
✓ View financial reports  
✓ Monitor social media analytics  
✓ Access telephony services  
✓ Send/receive messages to admin  
✓ View subscription details and upgrade  
✓ Make payments  
✓ Access help and assistance  
✓ Manage profile settings  

### Admin Features
✓ Admin dashboard with client overview  
✓ View all assigned clients  
✓ Access unified inbox for all messages  
✓ Respond to client messages across platforms  
✓ Update company formation details  
✓ Process VAT/CT registrations  
✓ Manage client bookkeeping  
✓ Handle social media management  
✓ Access client data and documents  
✓ Generate reports for clients  
✓ Track task deadlines  
✓ Manage client subscriptions  

### Super Admin Features
✓ Full system dashboard with analytics  
✓ Manage all users (admins and clients)  
✓ Configure system settings  
✓ Manage subscription packages  
✓ View all transactions and payments  
✓ Configure API integrations  
✓ Access system logs  
✓ Generate system-wide reports  
✓ Monitor system health  
✓ Manage admin permissions  
✓ View user login/activity logs  

## Development Phases

### Phase 1: Foundation (Weeks 1-3)
- Project setup and environment configuration
- Database schema design
- Authentication system
- Basic user registration/login
- Role-based access control

### Phase 2: Core Modules (Weeks 4-8)
- Dashboard development (all roles)
- Company Formation module
- VAT Registration module
- CT Registration module
- Profile management

### Phase 3: Advanced Modules (Weeks 9-14)
- Bookkeeping module
- VAT/CT Filing module
- Payment integration
- Subscription management
- Admin management interface

### Phase 4: Communication & Integration (Weeks 15-18)
- Unified messaging inbox
- WhatsApp integration
- Facebook/Instagram integration
- ZOHO integration
- QuickBooks integration

### Phase 5: Additional Features (Weeks 19-22)
- Social media management module
- Telephony module
- Assistance/help pages
- Notification system
- Email notifications

### Phase 6: Testing & Deployment (Weeks 23-26)
- Unit testing
- Integration testing
- User acceptance testing
- Performance optimization
- Documentation
- Localhost deployment setup

## Security Considerations

- **Data Encryption**: All sensitive data encrypted at rest and in transit
- **Authentication**: JWT tokens with refresh mechanism, OAuth2.0
- **Authorization**: Role-based access control (RBAC)
- **API Security**: Rate limiting, API keys for integrations
- **Payment Security**: PCI DSS compliance via Stripe/PayPal
- **Data Privacy**: GDPR compliance for user data
- **Audit Logs**: Track all user and admin actions
- **File Security**: Secure file upload with virus scanning

## Success Metrics

- User registration and retention rate
- Client satisfaction scores
- Number of active subscriptions
- Average response time in unified inbox
- System uptime and performance
- API integration success rates
- Revenue per client
- Admin efficiency metrics

## Next Steps

1. Review and approve system architecture
2. Set up development environment
3. Design database schema in detail
4. Create wireframes and UI mockups
5. Begin Phase 1 implementation
6. Set up CI/CD pipeline

---

**Document Version**: 1.0  
**Last Updated**: December 24, 2025  
**Status**: Draft for Review
