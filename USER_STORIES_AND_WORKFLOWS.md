# OMC System - User Stories and Workflows

## Table of Contents

1. [Client User Stories](#client-user-stories)
2. [Admin User Stories](#admin-user-stories)
3. [Super Admin User Stories](#super-admin-user-stories)
4. [Detailed User Workflows](#detailed-user-workflows)
5. [System Interaction Diagrams](#system-interaction-diagrams)

---

## Client User Stories

### Authentication & Onboarding

**US-C001: Register Account**
- **As a** new visitor
- **I want to** create an account using my email or Google account
- **So that** I can access OMC services

**Acceptance Criteria**:
- User can register with email and password
- User can register with Google OAuth
- Email verification email is sent
- User is redirected to dashboard after verification
- Password must meet security requirements

**US-C002: Login to Account**
- **As a** registered user
- **I want to** log in to my account
- **So that** I can access my dashboard and services

**Acceptance Criteria**:
- User can login with email and password
- User can login with Google
- "Remember me" option available
- JWT tokens are issued
- User is redirected to role-specific dashboard

**US-C003: Reset Password**
- **As a** user who forgot password
- **I want to** reset my password
- **So that** I can regain access to my account

**Acceptance Criteria**:
- User receives password reset email
- Reset link expires after 1 hour
- New password must meet security requirements
- All existing sessions are invalidated

### Company Formation

**US-C004: Submit Company Formation Request**
- **As a** client
- **I want to** submit a company formation application
- **So that** I can incorporate my business

**Acceptance Criteria**:
- Multi-step form with progress indicator
- Can save as draft and continue later
- Can add multiple directors
- Documents can be uploaded
- Validation prevents submission of incomplete data
- Confirmation email sent upon submission

**US-C005: Track Company Formation Status**
- **As a** client
- **I want to** view the status of my company formation
- **So that** I know when it's completed

**Acceptance Criteria**:
- Status is visible on dashboard
- Status updates trigger notifications
- Timeline shows progress stages
- Can view admin comments/notes
- Can download incorporation certificate when complete

### VAT & Tax Management

**US-C006: Apply for VAT Registration**
- **As a** client with an incorporated company
- **I want to** apply for VAT registration
- **So that** I can legally charge VAT

**Acceptance Criteria**:
- Form validates company is incorporated
- Can select VAT scheme
- Application is submitted to admin for processing
- Notification sent when VAT number is assigned
- VAT certificate downloadable

**US-C007: View VAT Filing Deadlines**
- **As a** client with VAT registration
- **I want to** see upcoming VAT filing deadlines
- **So that** I don't miss submissions

**Acceptance Criteria**:
- Dashboard shows next filing deadline
- Calendar view shows all deadlines
- Email reminders sent 7 days before deadline
- Overdue filings are highlighted in red

### Bookkeeping

**US-C008: Record Income Transaction**
- **As a** client
- **I want to** record an income transaction
- **So that** I can track my revenue

**Acceptance Criteria**:
- Simple form with date, amount, category, description
- VAT is calculated automatically or can be entered manually
- Can attach receipt/invoice
- Transaction appears in bookkeeping list immediately

**US-C009: Create and Send Invoice**
- **As a** client
- **I want to** create a professional invoice
- **So that** I can bill my customers

**Acceptance Criteria**:
- Can add multiple line items
- VAT is calculated automatically
- Invoice number is auto-generated
- PDF is generated
- Can email invoice to customer
- Invoice is recorded as income transaction

**US-C010: View Financial Reports**
- **As a** client
- **I want to** view my Profit & Loss statement
- **So that** I can understand my business performance

**Acceptance Criteria**:
- Can select date range
- Report shows income, expenses, and net profit
- Can download as PDF or CSV
- Charts visualize data

### Communication

**US-C011: Message Admin**
- **As a** client
- **I want to** send a message to my admin
- **So that** I can get help or ask questions

**Acceptance Criteria**:
- Message interface on dashboard
- Can attach files
- Receives notification when admin replies
- Message history is preserved

### Subscription Management

**US-C012: View and Upgrade Subscription**
- **As a** client on Basic plan
- **I want to** upgrade to Professional plan
- **So that** I can access more features

**Acceptance Criteria**:
- Can view current plan and features
- Can compare all plans
- Upgrade is processed immediately with prorated charge
- Features are unlocked automatically
- Confirmation email sent

**US-C013: Cancel Subscription**
- **As a** client
- **I want to** cancel my subscription
- **So that** I'm not charged next month

**Acceptance Criteria**:
- Can cancel from subscription page
- Cancellation takes effect at end of billing period
- Receives confirmation email
- Can still access features until period ends
- Data is retained for 30 days

---

## Admin User Stories

### Client Management

**US-A001: View Assigned Clients**
- **As an** admin
- **I want to** see all my assigned clients
- **So that** I can manage their requests

**Acceptance Criteria**:
- List shows all assigned clients
- Can search and filter
- Shows client status and subscription tier
- Quick access to client details

**US-A002: Review Company Formation Request**
- **As an** admin
- **I want to** review a company formation application
- **So that** I can approve or request changes

**Acceptance Criteria**:
- Can view all submitted information
- Can view uploaded documents
- Can change status to in_progress, completed, or rejected
- Can add internal notes
- Can request additional documents
- Client is notified of status changes

**US-A003: Assign VAT Number**
- **As an** admin
- **I want to** assign a VAT number to an approved registration
- **So that** the client can start charging VAT

**Acceptance Criteria**:
- Can enter VAT number in registration record
- Can set registration and effective dates
- Can upload VAT certificate
- Status changes to 'active'
- Client is notified automatically

### Communication

**US-A004: Respond to Client Messages**
- **As an** admin
- **I want to** see all client messages in one inbox
- **So that** I can respond efficiently

**Acceptance Criteria**:
- Inbox shows messages from WhatsApp, Facebook, Instagram, internal
- Can filter by platform or client
- Can see conversation history
- Can send replies that go to appropriate platform
- Unread count is displayed
- Real-time updates when new messages arrive

**US-A005: Use Message Templates**
- **As an** admin
- **I want to** use pre-written message templates
- **So that** I can respond faster

**Acceptance Criteria**:
- Can select from template list
- Templates can be customized before sending
- Can create new templates
- Variables like client name are auto-filled

### Task Management

**US-A006: View Task Queue**
- **As an** admin
- **I want to** see all pending tasks
- **So that** I don't miss important deadlines

**Acceptance Criteria**:
- Tasks are categorized by type
- Shows priority and due date
- Can filter and sort
- Can mark tasks as complete
- Dashboard shows task count

### Financial Operations

**US-A007: Process Refund**
- **As an** admin
- **I want to** refund a client's payment
- **So that** I can resolve disputes

**Acceptance Criteria**:
- Can initiate full or partial refund
- Must provide reason
- Refund is processed via Stripe
- Client is notified
- Transaction is logged

---

## Super Admin User Stories

### System Management

**US-SA001: Manage Admin Users**
- **As a** super admin
- **I want to** create, edit, and deactivate admin accounts
- **So that** I can control who has admin access

**Acceptance Criteria**:
- Can create new admin accounts
- Can assign permissions
- Can deactivate admins
- Can view admin activity logs
- Can reset admin passwords

**US-SA002: Configure Subscription Packages**
- **As a** super admin
- **I want to** create and edit subscription packages
- **So that** I can adjust pricing and features

**Acceptance Criteria**:
- Can add new packages
- Can edit price and features
- Can enable/disable packages
- Changes are reflected immediately
- Active subscriptions are not affected

**US-SA003: View System Analytics**
- **As a** super admin
- **I want to** see system-wide analytics
- **So that** I can monitor business performance

**Acceptance Criteria**:
- Dashboard shows total users, revenue, subscriptions
- Charts show trends over time
- Can export reports
- Real-time data where applicable

**US-SA004: Configure API Integrations**
- **As a** super admin
- **I want to** set up third-party integrations
- **So that** the system can connect to external services

**Acceptance Criteria**:
- Can enter API credentials for ZOHO, QuickBooks, etc.
- Can test connections
- Can enable/disable integrations
- Status indicators show connection health

**US-SA005: View User Activity Logs**
- **As a** super admin
- **I want to** see all user login and activity logs
- **So that** I can ensure security and compliance

**Acceptance Criteria**:
- Shows login times and IP addresses
- Shows actions performed
- Can filter by user, date, action type
- Can export logs

---

## Detailed User Workflows

### Workflow 1: Client Registration and First Company Formation

```
1. Client visits OMC website
   ↓
2. Clicks "Sign Up"
   ↓
3. Chooses registration method:
   a) Email + Password
      - Fills form
      - Receives verification email
      - Clicks verification link
      - Account activated
   b) Google OAuth
      - Redirects to Google
      - Authorizes app
      - Returns to OMC
      - Account created automatically
   ↓
4. Redirected to client dashboard
   - Sees welcome message
   - Sees "Add Company" widget
   ↓
5. Clicks "Add Company"
   ↓
6. Multi-step company formation wizard:
   
   Step 1: Company Details
   - Company Name: "Tech Innovations Ltd"
   - Company Type: Limited Company
   - Business Description: "Software development"
   - SIC Code: 62011
   - Contact info
   
   Step 2: Registered Address
   - Address Line 1: "123 High Street"
   - City: "London"
   - Postal Code: "E1 6AN"
   
   Step 3: Trading Address
   - Same as registered: ✓
   
   Step 4: Directors
   - Add Director:
     * Name: "John Smith"
     * DOB: "1985-05-15"
     * Nationality: "British"
     * Address: "123 High Street, London"
   - Can add more directors
   
   Step 5: Review & Submit
   - Reviews all information
   - Uploads ID proof
   - Accepts terms
   - Clicks "Submit"
   ↓
7. Confirmation shown
   - Application reference number displayed
   - Email confirmation sent
   - Status: "Pending Review"
   ↓
8. Admin receives notification
   - Reviews application
   - Changes status to "In Progress"
   - Begins formation process
   ↓
9. Client receives status update notification
   ↓
10. Admin completes formation
    - Uploads incorporation certificate
    - Enters company number
    - Changes status to "Completed"
    ↓
11. Client receives completion notification
    - Can download certificate from dashboard
    - Company now appears as "Active"
    ↓
12. Client can now apply for VAT registration using this company
```

### Workflow 2: VAT Registration and Filing

```
1. Client navigates to VAT Registration
   ↓
2. Selects company: "Tech Innovations Ltd"
   ↓
3. Fills VAT registration form:
   - Expected annual turnover: £120,000
   - Taxable supplies start date: 2026-01-01
   - VAT Scheme: Standard VAT
   - Business activity description
   ↓
4. Submits application
   ↓
5. Admin receives task notification
   ↓
6. Admin reviews and approves:
   - Enters VAT number: GB 123456789
   - Sets registration date: 2026-01-15
   - Uploads VAT certificate
   - Changes status to "Approved"
   ↓
7. Client receives notification and email
   ↓
8. System automatically creates first VAT filing record:
   - Period: Q1 2026 (Jan-Mar)
   - Due date: 2026-05-07 (1 month + 7 days after period end)
   - Status: Draft
   ↓
9. Client records transactions in bookkeeping throughout Q1
   ↓
10. Before due date, client opens VAT filing:
    - Clicks "Import from Bookkeeping"
    - System auto-fills boxes 1-9 from transactions
    - Client reviews figures
    - Makes adjustments if needed
    ↓
11. Client clicks "Submit VAT Return"
    - System generates PDF
    - Changes status to "Submitted"
    - Submission date recorded
    ↓
12. Client receives confirmation email
    ↓
13. System creates next period's filing (Q2 2026) automatically
```

### Workflow 3: Unified Inbox - Admin Responding to Multi-Channel Messages

```
1. Client sends WhatsApp message to OMC number
   - "Hi, I need help with my VAT registration"
   ↓
2. WhatsApp webhook sends message to OMC system
   ↓
3. System processes webhook:
   - Identifies client by phone number
   - Creates or finds existing conversation
   - Stores message in database
   ↓
4. Admin dashboard updates in real-time:
   - Unread count increases
   - New conversation appears in inbox
   - Platform icon shows WhatsApp
   - Desktop notification (if enabled)
   ↓
5. Admin clicks conversation
   - Right sidebar shows client info:
     * Name: John Smith
     * Company: Tech Innovations Ltd
     * Subscription: Professional
     * Recent activity
   ↓
6. Admin views message in thread:
   - WhatsApp icon next to message
   - Timestamp shown
   ↓
7. Admin types response:
   - "Hi John, I'd be happy to help. What specifically do you need assistance with?"
   - Can use emoji picker
   - Can attach files
   ↓
8. Admin sends message
   ↓
9. System sends message via WhatsApp API
   ↓
10. Client receives message on WhatsApp
    ↓
11. Meanwhile, same client sends Facebook message:
    - "Also, when will my company formation be complete?"
    ↓
12. Facebook webhook triggers same process
    ↓
13. Admin sees new message in SAME conversation thread:
    - Facebook icon next to this message
    - All messages from this client in one place
    ↓
14. Admin responds via appropriate channel
    ↓
15. Admin can add internal note (not visible to client):
    - "Client seems anxious about timeline. Follow up tomorrow."
    ↓
16. Admin can assign conversation to another admin if needed
    ↓
17. Conversation can be marked as closed when resolved
```

### Workflow 4: Bookkeeping and Financial Reports

```
1. Client records regular income:
   - Date: 2026-01-15
   - Type: Income
   - Category: Sales Revenue
   - Description: "Consulting services for ABC Corp"
   - Amount: £2,500
   - VAT: £500 (calculated automatically at 20%)
   - Payment Method: Bank Transfer
   - Attaches invoice PDF
   ↓
2. Client records expenses:
   - Date: 2026-01-16
   - Type: Expense
   - Category: Office Supplies
   - Description: "Laptop and accessories"
   - Amount: £1,000
   - VAT: £200
   - Payment Method: Company Card
   - Attaches receipt photo
   ↓
3. Throughout the month, client records more transactions
   ↓
4. End of month, client wants to see performance:
   - Navigates to Reports section
   - Selects "Profit & Loss Statement"
   - Date range: January 2026
   - Clicks "Generate Report"
   ↓
5. System calculates:
   
   PROFIT & LOSS STATEMENT
   Tech Innovations Ltd
   Period: January 2026
   
   INCOME
   Sales Revenue          £15,000
   Service Income         £8,000
   Total Income           £23,000
   
   EXPENSES
   Office Supplies        £1,200
   Marketing              £2,500
   Professional Fees      £1,000
   Total Expenses         £4,700
   
   NET PROFIT             £18,300
   
   ↓
6. Client views report:
   - Chart shows income vs expenses
   - Can drill down into categories
   - Downloads PDF for records
   - Exports CSV for accountant
   ↓
7. Client also generates VAT Summary report:
   - VAT due on sales: £3,000
   - VAT reclaimed on purchases: £940
   - Net VAT payable: £2,060
   ↓
8. This data is used for next VAT return
```

### Workflow 5: Subscription Upgrade

```
1. Client on Basic plan wants more features
   ↓
2. Navigates to Subscription page from profile settings
   ↓
3. Current plan displayed:
   - Basic Plan - £29.99/month
   - 1 Company allowed
   - 5GB Storage
   - Basic Support
   ↓
4. Clicks "View Plans" or "Upgrade"
   ↓
5. Comparison table shown:
   
   | Feature              | Basic  | Professional | Enterprise |
   |---------------------|--------|--------------|------------|
   | Price               | £29.99 | £79.99       | £199.99    |
   | Companies           | 1      | 3            | 10         |
   | Storage             | 5GB    | 20GB         | 100GB      |
   | Social Media Mgmt   | ✗      | ✓            | ✓          |
   | Priority Support    | ✗      | ✗            | ✓          |
   
   ↓
6. Client clicks "Upgrade" on Professional plan
   ↓
7. System calculates prorated charge:
   - Days remaining in current period: 20 days
   - Unused Basic credit: £19.99
   - Professional cost for 20 days: £53.33
   - Charge today: £33.34
   ↓
8. Confirmation shown:
   - "You'll be charged £33.34 today"
   - "Your next bill on Feb 1 will be £79.99"
   ↓
9. Client confirms
   ↓
10. Payment processed via Stripe:
    - Uses saved payment method
    - Payment successful
    ↓
11. System updates subscription:
    - Changes package to Professional
    - Updates feature flags
    - Increases limits
    ↓
12. Client sees success message
    ↓
13. Dashboard immediately reflects new features:
    - Social Media Management module now visible
    - Can add up to 3 companies
    - Storage limit increased
    ↓
14. Confirmation email sent with receipt
```

### Workflow 6: Social Media Post Scheduling

```
1. Client navigates to Social Media module
   ↓
2. First time: No accounts connected
   - Sees "Connect Account" buttons
   - Facebook, Instagram, Twitter, LinkedIn
   ↓
3. Clicks "Connect Facebook"
   ↓
4. OAuth flow:
   - Redirects to Facebook
   - Client logs in to Facebook
   - Selects business page to connect
   - Authorizes OMC app
   - Redirects back to OMC
   ↓
5. Account now connected:
   - Shows page name: "Tech Innovations Official"
   - Shows follower count: 1,234
   - Shows last sync time
   ↓
6. Repeats for Instagram
   ↓
7. Now clicks "Create Post"
   ↓
8. Post creation form:
   - Text area: "Exciting news! We're launching a new product next week. Stay tuned! 🚀"
   - Upload images: [uploads 2 images]
   - Platform selection:
     ☑ Facebook
     ☑ Instagram
     ☐ Twitter
   - Scheduling:
     ○ Post Now
     ● Schedule for Later
       Date: 2026-01-25
       Time: 10:00 AM
   ↓
9. Preview shows how post will look on each platform:
   - Facebook preview (with images)
   - Instagram preview (optimized for square)
   ↓
10. Clicks "Schedule Post"
    ↓
11. Post saved with status "Scheduled"
    - Appears in content calendar
    - Yellow indicator on Jan 25
    ↓
12. On Jan 25 at 10:00 AM:
    - System's cron job runs
    - Finds scheduled posts due
    - Publishes to Facebook via Graph API
    - Publishes to Instagram via Graph API
    - Updates status to "Published"
    - Records post IDs
    ↓
13. Client checks post performance:
    - Navigates to Social Media > Analytics
    - Sees post metrics:
      * Facebook: 45 likes, 12 comments, 8 shares
      * Instagram: 67 likes, 23 comments
    - System syncs metrics every hour
```

---

## System Interaction Diagrams

### Client-Admin Interaction Flow

```
┌─────────┐                              ┌─────────┐
│ Client  │                              │  Admin  │
└────┬────┘                              └────┬────┘
     │                                        │
     │ 1. Submit Company Formation            │
     ├──────────────────────────────────────>│
     │                                        │
     │ 2. Receive Confirmation                │
     │<───────────────────────────────────────┤
     │                                        │
     │                                        │ 3. Review Application
     │                                        ├─────────┐
     │                                        │         │
     │                                        │<────────┘
     │                                        │
     │ 4. Status Update: In Progress          │
     │<───────────────────────────────────────┤
     │                                        │
     │ 5. Send Question via WhatsApp          │
     ├──────────────────────────────────────>│
     │                                        │
     │ 6. Receive Answer via WhatsApp         │
     │<───────────────────────────────────────┤
     │                                        │
     │                                        │ 7. Complete Formation
     │                                        ├─────────┐
     │                                        │         │
     │                                        │<────────┘
     │                                        │
     │ 8. Status Update: Completed            │
     │<───────────────────────────────────────┤
     │                                        │
     │ 9. Download Certificate                │
     ├──────────────────────────────────────>│
     │                                        │
     │ 10. Receive Certificate PDF            │
     │<───────────────────────────────────────┤
     │                                        │
```

### Payment Processing Flow

```
┌────────┐    ┌─────────┐    ┌────────┐    ┌────────┐
│ Client │    │   OMC   │    │ Stripe │    │  Bank  │
└───┬────┘    └────┬────┘    └───┬────┘    └───┬────┘
    │              │              │             │
    │ 1. Select    │              │             │
    │ Professional │              │             │
    │ Plan         │              │             │
    ├─────────────>│              │             │
    │              │              │             │
    │ 2. Show      │              │             │
    │ Checkout     │              │             │
    │<─────────────┤              │             │
    │              │              │             │
    │ 3. Enter     │              │             │
    │ Card Details │              │             │
    ├─────────────>│              │             │
    │              │              │             │
    │              │ 4. Create    │             │
    │              │ Payment      │             │
    │              │ Intent       │             │
    │              ├─────────────>│             │
    │              │              │             │
    │              │ 5. Return    │             │
    │              │ Client Secret│             │
    │              │<─────────────┤             │
    │              │              │             │
    │ 6. Confirm   │              │             │
    │ Payment      │              │             │
    ├─────────────>│              │             │
    │              │              │             │
    │              │ 7. Process   │             │
    │              │ Payment      │             │
    │              ├─────────────>│             │
    │              │              │             │
    │              │              │ 8. Charge   │
    │              │              │ Card        │
    │              │              ├────────────>│
    │              │              │             │
    │              │              │ 9. Success  │
    │              │              │<────────────┤
    │              │              │             │
    │              │ 10. Webhook: │             │
    │              │ payment_     │             │
    │              │ succeeded    │             │
    │              │<─────────────┤             │
    │              │              │             │
    │              │ 11. Update   │             │
    │              │ Subscription │             │
    │              ├────────┐     │             │
    │              │        │     │             │
    │              │<───────┘     │             │
    │              │              │             │
    │ 12. Success  │              │             │
    │ + Receipt    │              │             │
    │<─────────────┤              │             │
    │              │              │             │
```

### Multi-Channel Messaging Flow

```
┌────────┐   ┌──────────┐   ┌──────────┐   ┌─────────┐   ┌─────────┐
│ Client │   │ WhatsApp │   │   OMC    │   │Facebook │   │  Admin  │
└───┬────┘   └────┬─────┘   └────┬─────┘   └────┬────┘   └────┬────┘
    │             │              │              │             │
    │ 1. Send     │              │              │             │
    │ WhatsApp    │              │              │             │
    │ Message     │              │              │             │
    ├────────────>│              │              │             │
    │             │              │              │             │
    │             │ 2. Webhook   │              │             │
    │             ├─────────────>│              │             │
    │             │              │              │             │
    │             │              │ 3. Store &   │             │
    │             │              │ Notify       │             │
    │             │              ├──────────────────────────>│
    │             │              │              │             │
    │             │              │              │             │ 4. View in
    │             │              │              │             │ Unified
    │             │              │              │             │ Inbox
    │             │              │              │             ├────┐
    │             │              │              │             │    │
    │             │              │              │             │<───┘
    │             │              │              │             │
    │ (Meanwhile, same client sends Facebook message)        │
    │             │              │              │             │
    │ 5. Send FB  │              │              │             │
    │ Message     │              │              │             │
    ├────────────────────────────────────────>│             │
    │             │              │              │             │
    │             │              │ 6. Webhook   │             │
    │             │              │<─────────────┤             │
    │             │              │              │             │
    │             │              │ 7. Add to    │             │
    │             │              │ Same Thread  │             │
    │             │              ├──────────────────────────>│
    │             │              │              │             │
    │             │              │              │             │ 8. Admin
    │             │              │              │             │ Sees Both
    │             │              │              │             │ in One
    │             │              │              │             │ Thread
    │             │              │              │             ├────┐
    │             │              │              │             │    │
    │             │              │              │             │<───┘
    │             │              │              │             │
    │             │              │              │ 9. Reply    │
    │             │              │              │ (WhatsApp)  │
    │             │              │<────────────────────────────┤
    │             │              │              │             │
    │             │ 10. Send via │              │             │
    │             │ WhatsApp API │              │             │
    │             │<─────────────┤              │             │
    │             │              │              │             │
    │ 11. Receive │              │              │             │
    │ on WhatsApp │              │              │             │
    │<────────────┤              │              │             │
    │             │              │              │             │
```

---

## User Journey Maps

### Journey 1: From Visitor to Active Client

**Stage 1: Awareness**
- Visitor hears about OMC from friend
- Searches Google for "UK company formation services"
- Finds OMC website
- Reads about services

**Stage 2: Consideration**
- Views pricing page
- Compares packages
- Reads FAQ
- Watches demo video

**Stage 3: Decision**
- Clicks "Sign Up"
- Registers with Google (quick and easy)
- Lands on dashboard

**Stage 4: Onboarding**
- Sees welcome tour/tooltip
- Starts company formation wizard
- Fills detailed form
- Uploads documents
- Submits application

**Stage 5: Active Use**
- Receives notifications about progress
- Messages admin with questions
- Application approved
- Downloads incorporation certificate
- Applies for VAT registration
- Starts using bookkeeping
- Records transactions regularly

**Stage 6: Expansion**
- Business grows
- Needs social media management
- Upgrades to Professional plan
- Connects Facebook and Instagram
- Schedules posts
- Monitors analytics

**Stage 7: Loyalty**
- Happy with service
- Refers friend (referral program - future feature)
- Renews subscription
- Adds second company
- Continues using platform actively

---

**Document Version**: 1.0  
**Last Updated**: December 24, 2025  
**Status**: Complete User Stories and Workflows
