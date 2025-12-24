# OMC System - Detailed Module Specifications

## Table of Contents

1. [Authentication & User Management Module](#1-authentication--user-management-module)
2. [Dashboard Module](#2-dashboard-module)
3. [Company Formation Module](#3-company-formation-module)
4. [VAT Registration Module](#4-vat-registration-module)
5. [Corporate Tax Registration Module](#5-corporate-tax-registration-module)
6. [VAT/CT Filing Module](#6-vatct-filing-module)
7. [Bookkeeping Module](#7-bookkeeping-module)
8. [Social Media Management Module](#8-social-media-management-module)
9. [Telephony Module](#9-telephony-module)
10. [Unified Messaging Module](#10-unified-messaging-module)
11. [Payment & Subscription Module](#11-payment--subscription-module)
12. [Assistance & Support Module](#12-assistance--support-module)
13. [Admin Management Module](#13-admin-management-module)

---

## 1. Authentication & User Management Module

### Purpose
Secure user registration, authentication, and profile management with role-based access control.

### Features

#### 1.1 User Registration
**Endpoint**: `POST /api/auth/register`

**Fields**:
- First Name (required)
- Last Name (required)
- Email (required, unique)
- Password (required, min 8 characters, must include uppercase, lowercase, number, special char)
- Phone (optional)
- Terms & Conditions acceptance (required)

**Process**:
1. Validate input data
2. Check if email already exists
3. Hash password using bcrypt
4. Create user record with role='client'
5. Send verification email with token
6. Return success message

**Validation Rules**:
- Email must be valid format
- Password strength: min 8 chars, 1 uppercase, 1 lowercase, 1 number, 1 special char
- Phone must be valid UK format (optional)

#### 1.2 Google OAuth Registration/Login
**Endpoint**: `POST /api/auth/google`

**Process**:
1. Receive Google OAuth token from frontend
2. Verify token with Google API
3. Extract user info (email, name, google_id)
4. Check if user exists by email or google_id
5. If exists, log in; if not, create new user
6. Generate JWT token
7. Return user data and token

**Fields Captured**:
- Email from Google
- First Name from Google
- Last Name from Google
- Google ID
- Avatar URL

#### 1.3 User Login
**Endpoint**: `POST /api/auth/login`

**Fields**:
- Email (required)
- Password (required)
- Remember Me (optional)

**Process**:
1. Validate credentials
2. Check if user is active and verified
3. Compare password hash
4. Generate JWT access token (expires in 1 hour)
5. Generate refresh token (expires in 30 days)
6. Log activity
7. Return tokens and user data

**Response**:
```json
{
  "user": {
    "id": 123,
    "uuid": "...",
    "email": "user@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "role": "client"
  },
  "access_token": "eyJhbG...",
  "refresh_token": "eyJhbG...",
  "expires_in": 3600
}
```

#### 1.4 Email Verification
**Endpoint**: `POST /api/auth/verify-email`

**Process**:
1. Receive verification token
2. Verify token validity and expiration
3. Update user.is_verified = true
4. Update user.email_verified_at
5. Redirect to dashboard

#### 1.5 Password Reset
**Endpoints**:
- `POST /api/auth/forgot-password` - Request reset
- `POST /api/auth/reset-password` - Submit new password

**Process**:
1. User requests password reset with email
2. Generate reset token (expires in 1 hour)
3. Send reset email with link
4. User clicks link, enters new password
5. Verify token, update password hash
6. Invalidate all existing sessions
7. Send confirmation email

#### 1.6 Profile Management
**Endpoints**:
- `GET /api/users/profile` - Get current user profile
- `PUT /api/users/profile` - Update profile
- `PUT /api/users/change-password` - Change password
- `PUT /api/users/avatar` - Upload avatar

**Editable Fields**:
- First Name, Last Name
- Phone
- Date of Birth
- Address (line1, line2, city, state, postal code, country)
- Timezone
- Language preference
- Bio
- Website

#### 1.7 Role-Based Access Control (RBAC)

**Roles**:
- **super_admin**: Full system access
- **admin**: Access to assigned clients and management tools
- **client**: Access to personal data and services

**Permissions Matrix**:

| Action | Super Admin | Admin | Client |
|--------|-------------|-------|--------|
| View all users | ✓ | ✗ | ✗ |
| Manage admins | ✓ | ✗ | ✗ |
| View assigned clients | ✓ | ✓ | ✗ |
| Manage own company | ✓ | ✓ | ✓ |
| Access unified inbox | ✓ | ✓ | ✗ |
| Configure integrations | ✓ | ✗ | ✗ |
| Process payments | ✓ | ✓ | ✗ |
| View system settings | ✓ | ✗ | ✗ |

**Middleware Implementation**:
```javascript
// Example: requireRole(['admin', 'super_admin'])
function requireRole(allowedRoles) {
  return (req, res, next) => {
    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    next();
  };
}
```

#### 1.8 Session Management
- JWT-based authentication
- Access tokens expire after 1 hour
- Refresh tokens expire after 30 days
- Refresh token rotation on use
- Session tracking in database
- Logout invalidates session
- "Logout all devices" option

### UI Pages

#### Registration Page
- Email/Password form
- Google Sign-In button
- Terms & Conditions checkbox
- Link to Login page

#### Login Page
- Email/Password form
- Google Sign-In button
- "Remember Me" checkbox
- "Forgot Password" link
- Link to Registration page

#### Profile Settings Page
- Personal Information section
- Contact Information section
- Address section
- Change Password section
- Upload Avatar
- Language/Timezone preferences

---

## 2. Dashboard Module

### Purpose
Centralized view for users, admins, and super admins with role-specific widgets and analytics.

### 2.1 Client Dashboard

**URL**: `/dashboard`

**Widgets**:

1. **Welcome Banner**
   - Personalized greeting
   - Current subscription tier
   - Quick action buttons

2. **Company Status Widget**
   - Active companies count
   - Pending registrations
   - Quick links to company details

3. **VAT/CT Status Widget**
   - Registration status
   - Upcoming filing deadlines
   - Recent filings

4. **Financial Summary Widget**
   - Current month income/expenses
   - Pending invoices
   - Recent transactions

5. **Messages Widget**
   - Unread message count
   - Recent conversations
   - Quick reply option

6. **Notifications Widget**
   - Recent notifications
   - Action items
   - Mark as read functionality

7. **Subscription Widget**
   - Current plan details
   - Usage statistics
   - Upgrade button

8. **Quick Actions Panel**
   - Add Company
   - Apply for VAT Registration
   - Upload Documents
   - Contact Support

**API Endpoint**: `GET /api/dashboard/client`

**Response Example**:
```json
{
  "user": {...},
  "subscription": {
    "package": "Professional",
    "status": "active",
    "expires_at": "2026-01-24"
  },
  "companies": {
    "total": 2,
    "pending": 1,
    "active": 1
  },
  "vat_filings_due": [
    {
      "id": 5,
      "period": "Q4 2025",
      "due_date": "2026-01-31"
    }
  ],
  "financial_summary": {
    "income": 15000.00,
    "expenses": 8500.00,
    "profit": 6500.00
  },
  "unread_messages": 3,
  "notifications": [...]
}
```

### 2.2 Admin Dashboard

**URL**: `/admin/dashboard`

**Widgets**:

1. **Overview Statistics**
   - Total assigned clients
   - Active tasks
   - Pending approvals
   - This month's revenue

2. **Client List Widget**
   - Search and filter
   - Client status indicators
   - Quick access to client details

3. **Task Queue Widget**
   - Pending company formations
   - VAT/CT registrations to process
   - Filings due soon
   - Documents to review

4. **Unified Inbox Widget**
   - Unread messages by platform
   - Recent conversations
   - Quick reply

5. **Calendar Widget**
   - Upcoming deadlines
   - Scheduled calls
   - Filing due dates

6. **Performance Metrics**
   - Response time average
   - Client satisfaction score
   - Tasks completed this month

**API Endpoint**: `GET /api/dashboard/admin`

### 2.3 Super Admin Dashboard

**URL**: `/superadmin/dashboard`

**Widgets**:

1. **System Analytics**
   - Total users (clients, admins)
   - Active subscriptions
   - Total revenue (MTD, YTD)
   - System health status

2. **Revenue Chart**
   - Monthly recurring revenue (MRR)
   - Revenue by subscription tier
   - Payment success rate

3. **User Growth Chart**
   - New registrations
   - Churn rate
   - Active users

4. **Admin Performance Table**
   - Admin list with metrics
   - Response times
   - Client assignments
   - Performance scores

5. **Recent Activity Log**
   - User registrations
   - Subscription changes
   - Payment transactions
   - System errors

6. **Integration Status**
   - ZOHO connection status
   - QuickBooks connection status
   - WhatsApp API status
   - Payment gateway status

7. **Pending Approvals**
   - Admin applications
   - Refund requests
   - Support escalations

**API Endpoint**: `GET /api/dashboard/superadmin`

### UI Components

#### Dashboard Layout
- Responsive grid layout
- Drag-and-drop widget repositioning (optional)
- Collapsible widgets
- Full-screen widget view
- Export to PDF option

#### Charts & Graphs
- Line charts for trends
- Bar charts for comparisons
- Pie charts for distributions
- Real-time updates via WebSocket

---

## 3. Company Formation Module

### Purpose
Manage the complete lifecycle of company formation requests from application to incorporation.

### Features

#### 3.1 Company Registration Form

**Endpoint**: `POST /api/companies`

**Multi-Step Form**:

**Step 1: Company Details**
- Company Name (required)
- Company Type (Ltd, LLP, Sole Trader)
- Business Description (required)
- SIC Code (required)
- Website (optional)
- Email (required)
- Phone (required)

**Step 2: Registered Address**
- Address Line 1 (required)
- Address Line 2 (optional)
- City (required)
- Postal Code (required)
- Country (default: UK)

**Step 3: Trading Address**
- Same as Registered? (checkbox)
- If different, collect full address

**Step 4: Directors**
- Add multiple directors
- For each director:
  - First Name, Last Name
  - Date of Birth
  - Nationality
  - Residential Address
  - Appointment Date

**Step 5: Review & Submit**
- Summary of all information
- Terms acceptance
- Submit button

**Validation**:
- Company name must be unique (check Companies House API)
- At least one director required
- Director must be 16+ years old
- Valid UK postal code format
- SIC code must be valid

#### 3.2 Company List View

**Endpoint**: `GET /api/companies`

**Features**:
- Paginated list
- Search by name/number
- Filter by status (pending, in_progress, completed, rejected)
- Sort by date, name, status
- Bulk actions (for admin)

**Response**:
```json
{
  "data": [
    {
      "id": 1,
      "company_name": "Tech Solutions Ltd",
      "company_number": "12345678",
      "status": "completed",
      "incorporation_date": "2025-11-15",
      "assigned_admin": {
        "id": 5,
        "name": "Admin Name"
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "total_pages": 5,
    "total_count": 48
  }
}
```

#### 3.3 Company Detail View

**Endpoint**: `GET /api/companies/:id`

**Sections**:
- Company Information Card
- Directors List
- Status Timeline
- Documents Section
- Activity Log
- Actions (Edit, Download Certificate, Archive)

#### 3.4 Company Update

**Endpoint**: `PUT /api/companies/:id`

**Permissions**:
- Client: Can update only if status is 'pending' or 'rejected'
- Admin: Can update at any time
- Can add/remove directors
- Can update addresses

#### 3.5 Status Management (Admin Only)

**Endpoint**: `PUT /api/companies/:id/status`

**Status Flow**:
```
pending → in_progress → completed
                ↓
            rejected
```

**Actions by Status**:
- **pending**: Assign to admin
- **in_progress**: Add notes, request documents
- **completed**: Upload incorporation certificate, set company number
- **rejected**: Provide rejection reason

#### 3.6 Document Management

**Endpoints**:
- `POST /api/companies/:id/documents` - Upload
- `GET /api/companies/:id/documents` - List
- `DELETE /api/documents/:id` - Delete

**Document Types**:
- ID Proof (Passport, Driver's License)
- Proof of Address
- Incorporation Certificate (admin uploads)
- Memorandum of Association
- Articles of Association

### UI Pages

#### Companies List Page
- Cards or table view toggle
- Search bar
- Filter dropdowns
- "Add Company" button (client)
- Status badges with colors

#### Company Formation Wizard
- Multi-step form with progress indicator
- Save as draft functionality
- Back/Next buttons
- Field validation with error messages
- Help tooltips

#### Company Detail Page
- Tabbed interface:
  - Overview
  - Directors
  - Documents
  - Activity
- Edit button (if allowed)
- Status update dropdown (admin)
- Print/Download button

---

## 4. VAT Registration Module

### Purpose
Handle VAT registration applications and track status.

### Features

#### 4.1 VAT Registration Form

**Endpoint**: `POST /api/vat-registrations`

**Fields**:
- Company Selection (dropdown of user's companies)
- Application Date (auto-filled)
- Expected Turnover (annual)
- Taxable Supplies Date (when started or will start making taxable supplies)
- VAT Scheme Selection:
  - Standard VAT
  - Flat Rate Scheme
  - Cash Accounting Scheme
- Business Activity Description
- Additional Information

**Validation**:
- Company must be incorporated
- Turnover must meet VAT threshold (£90,000+)
- Application date cannot be in future

#### 4.2 VAT Registration List

**Endpoint**: `GET /api/vat-registrations`

**Display**:
- Company Name
- Application Date
- Status (pending, approved, rejected, active)
- VAT Number (if approved)
- Assigned Admin

#### 4.3 VAT Registration Detail

**Endpoint**: `GET /api/vat-registrations/:id`

**Information**:
- All application details
- Status history
- VAT number (if issued)
- Registration date
- Effective date
- Documents
- Admin notes

#### 4.4 VAT Number Assignment (Admin)

**Endpoint**: `PUT /api/vat-registrations/:id/approve`

**Process**:
1. Review application
2. Enter VAT number
3. Set registration date
4. Set effective date
5. Change status to 'approved'
6. Send notification to client

#### 4.5 VAT Certificate Upload (Admin)

**Endpoint**: `POST /api/vat-registrations/:id/certificate`

Upload VAT certificate PDF received from HMRC.

### UI Pages

#### VAT Registration Form Page
- Single-page form
- Company selector
- VAT scheme information cards
- Submit button

#### VAT Registrations List Page
- Table view
- Status filters
- Search by company name
- "Apply for VAT" button

#### VAT Detail Page
- Application summary
- Status timeline
- Certificate download (if available)
- Edit option (if pending/rejected)

---

## 5. Corporate Tax Registration Module

### Purpose
Manage Corporate Tax (CT) registration applications.

### Features

#### 5.1 CT Registration Form

**Endpoint**: `POST /api/ct-registrations`

**Fields**:
- Company Selection
- Application Date
- First Accounting Period Start
- First Accounting Period End
- Business Activity
- Expected Turnover
- Expected Profit
- Additional Information

#### 5.2 CT Registration List

**Endpoint**: `GET /api/ct-registrations`

**Display**:
- Company Name
- Application Date
- Status
- UTR Number (if assigned)
- Assigned Admin

#### 5.3 UTR Assignment (Admin)

**Endpoint**: `PUT /api/ct-registrations/:id/approve`

**Process**:
1. Review application
2. Enter UTR (Unique Taxpayer Reference)
3. Set registration date
4. Set accounting periods
5. Update status to 'approved'
6. Notify client

### UI Pages

Similar structure to VAT module:
- CT Registration Form
- CT List Page
- CT Detail Page

---

## 6. VAT/CT Filing Module

### Purpose
Track and manage VAT and Corporate Tax filing obligations.

### Features

#### 6.1 VAT Filing Creation

**Endpoint**: `POST /api/vat-filings`

**Auto-Generation**:
- System automatically creates filing records based on VAT registration
- Quarterly or monthly based on scheme
- Due dates calculated automatically (1 month and 7 days after period end)

**Manual Fields (filled by admin/client)**:
- VAT Due on Sales (Box 1)
- VAT Due on Acquisitions (Box 2)
- Total VAT Due (Box 3 = Box 1 + Box 2)
- VAT Reclaimed (Box 4)
- Net VAT Due (Box 5 = Box 3 - Box 4)
- Total Value of Sales (Box 6)
- Total Value of Purchases (Box 7)
- Total Value of Supplies (Box 8)
- Total Value of Acquisitions (Box 9)

**Integration with Bookkeeping**:
- Auto-populate from bookkeeping transactions
- Calculate VAT from invoices and expenses
- One-click import from ZOHO/QuickBooks

#### 6.2 VAT Filing List

**Endpoint**: `GET /api/vat-filings`

**Display**:
- Period (Q1 2025, Q2 2025, etc.)
- Company Name
- Due Date
- Status (draft, submitted, accepted, overdue)
- Net VAT Due
- Actions (Edit, Submit, View)

**Filters**:
- By company
- By status
- By period
- Overdue only

#### 6.3 VAT Return Submission

**Endpoint**: `POST /api/vat-filings/:id/submit`

**Process**:
1. Validate all fields are filled
2. Calculate totals
3. Generate VAT return PDF
4. Change status to 'submitted'
5. Set submission date
6. Send notification
7. (Future) Submit to HMRC via MTD API

#### 6.4 CT Filing

Similar to VAT Filing but for Corporation Tax:
- Annual filings based on accounting period
- Due date: 12 months after accounting period end
- Fields: Turnover, Trading Profits, Taxable Profits, Tax Due, Tax Paid
- Integration with bookkeeping for P&L data

### UI Pages

#### VAT Filings Dashboard
- Calendar view of all due dates
- List view with filters
- Color-coded status indicators
- "Overdue" badge for late filings

#### VAT Filing Form
- 9-box format (matching HMRC VAT return)
- Auto-calculate totals
- Import from bookkeeping button
- Save as draft
- Submit button with confirmation

#### CT Filings Dashboard
- Annual filing list
- Due dates
- Status tracking

---

## 7. Bookkeeping Module

### Purpose
Complete bookkeeping solution for income, expenses, invoicing, and financial reporting.

### Features

#### 7.1 Transaction Management

**Endpoints**:
- `POST /api/transactions` - Create
- `GET /api/transactions` - List
- `GET /api/transactions/:id` - Detail
- `PUT /api/transactions/:id` - Update
- `DELETE /api/transactions/:id` - Delete

**Transaction Fields**:
- Date
- Type (Income/Expense)
- Category (dropdown: Sales, Office Supplies, Marketing, etc.)
- Description
- Amount
- VAT Amount (auto-calculated or manual)
- Currency (default GBP)
- Payment Method (Cash, Bank Transfer, Card, Cheque)
- Reference Number
- Attach Receipt/Invoice
- Notes

**Categories**:

*Income Categories*:
- Sales Revenue
- Service Income
- Interest Income
- Other Income

*Expense Categories*:
- Office Supplies
- Marketing & Advertising
- Travel & Transportation
- Professional Fees
- Rent & Utilities
- Salaries & Wages
- Insurance
- Bank Charges
- Depreciation
- Other Expenses

#### 7.2 Invoice Management

**Endpoints**:
- `POST /api/invoices` - Create
- `GET /api/invoices` - List
- `GET /api/invoices/:id` - Detail
- `PUT /api/invoices/:id` - Update
- `POST /api/invoices/:id/send` - Email to customer
- `POST /api/invoices/:id/mark-paid` - Mark as paid

**Invoice Structure**:
- Invoice Number (auto-generated)
- Invoice Date
- Due Date
- Customer Information:
  - Name
  - Email
  - Address
- Line Items:
  - Description
  - Quantity
  - Unit Price
  - VAT Rate
  - Amount
- Subtotal
- VAT Amount
- Total Amount
- Payment Terms
- Notes

**Invoice Statuses**:
- Draft
- Sent
- Paid
- Overdue
- Cancelled

**Invoice Template**:
- PDF generation with company branding
- Customizable template
- Download/Print/Email options

#### 7.3 Expense Tracking

**Endpoint**: `POST /api/expenses`

**Features**:
- Quick expense entry
- Receipt photo upload (OCR for data extraction - future feature)
- Recurring expenses
- Expense categories
- Reimbursable expenses flag
- Mileage tracking

#### 7.4 Financial Reports

**Endpoints**:
- `GET /api/reports/profit-loss` - P&L Statement
- `GET /api/reports/balance-sheet` - Balance Sheet
- `GET /api/reports/cash-flow` - Cash Flow Statement
- `GET /api/reports/vat-summary` - VAT Summary
- `GET /api/reports/expense-summary` - Expenses by Category

**Report Parameters**:
- Company ID
- Date Range (from_date, to_date)
- Format (JSON, PDF, CSV)

**Profit & Loss Report**:
```
Income
  Sales Revenue: £50,000
  Service Income: £30,000
  Total Income: £80,000

Expenses
  Office Supplies: £2,000
  Marketing: £5,000
  Salaries: £40,000
  Total Expenses: £47,000

Net Profit: £33,000
```

#### 7.5 Bank Reconciliation

**Endpoint**: `POST /api/bank-reconciliation`

**Features**:
- Upload bank statement (CSV/PDF)
- Match transactions automatically
- Manual matching interface
- Mark as reconciled
- Reconciliation report

#### 7.6 Integration with Accounting Software

**ZOHO Books Integration**:
- Sync customers
- Sync invoices
- Sync expenses
- Sync chart of accounts
- Two-way sync

**QuickBooks Integration**:
- OAuth authentication
- Sync transactions
- Sync invoices
- Sync customers
- Sync tax rates

**Endpoints**:
- `POST /api/integrations/zoho/connect` - Connect ZOHO
- `POST /api/integrations/zoho/sync` - Trigger sync
- `GET /api/integrations/zoho/status` - Sync status
- Similar endpoints for QuickBooks

### UI Pages

#### Transactions Page
- List view with filters
- Search by description
- Date range picker
- Type filter (Income/Expense)
- Category filter
- Add Transaction button
- Export to CSV

#### Transaction Form
- Modal or separate page
- Income/Expense toggle
- Date picker
- Category dropdown
- Amount input with VAT calculation
- File upload for receipt
- Save button

#### Invoices Page
- Invoice list with status badges
- Search and filter
- Create Invoice button
- Quick actions: Send, Mark Paid, Download

#### Invoice Create/Edit Page
- Professional form layout
- Add line items dynamically
- Auto-calculate totals
- Preview invoice
- Save as draft or Send options

#### Reports Page
- Report selector dropdown
- Date range selector
- Generate button
- View in browser
- Download as PDF
- Export as CSV
- Print option

---

## 8. Social Media Management Module

### Purpose
Manage social media accounts, schedule posts, and track engagement.

### Features

#### 8.1 Social Media Account Connection

**Endpoints**:
- `POST /api/social-accounts/connect` - OAuth connection
- `GET /api/social-accounts` - List connected accounts
- `DELETE /api/social-accounts/:id` - Disconnect

**Supported Platforms**:
- Facebook Pages
- Instagram Business
- Twitter/X (optional)
- LinkedIn Company Pages (optional)

**Connection Process**:
1. Click "Connect [Platform]" button
2. OAuth redirect to platform
3. User authorizes app
4. Receive access token
5. Store encrypted token
6. Fetch account details
7. Display as connected

#### 8.2 Post Creation

**Endpoint**: `POST /api/social-posts`

**Fields**:
- Content (text, max length varies by platform)
- Media Upload (images/videos, up to 10)
- Platform Selection (multi-select)
- Scheduling:
  - Post Now
  - Schedule for Later (date & time)
- Tags/Mentions
- Location (optional)

**Preview**:
- Show how post will look on each platform
- Character count
- Image preview

#### 8.3 Content Calendar

**Endpoint**: `GET /api/social-posts/calendar`

**Features**:
- Monthly calendar view
- Drag-and-drop rescheduling
- Color-coded by platform
- Filter by platform
- Filter by status (draft, scheduled, published)

#### 8.4 Post Management

**Endpoints**:
- `GET /api/social-posts` - List all posts
- `GET /api/social-posts/:id` - Post detail
- `PUT /api/social-posts/:id` - Edit (before publishing)
- `DELETE /api/social-posts/:id` - Delete
- `POST /api/social-posts/:id/publish` - Publish immediately

#### 8.5 Analytics & Insights

**Endpoint**: `GET /api/social-analytics`

**Metrics per Platform**:
- Followers count (trend)
- Impressions
- Engagements (likes, comments, shares)
- Reach
- Click-through rate

**Post Performance**:
- Individual post metrics
- Best performing posts
- Engagement rate
- Best time to post analysis

**Dashboard Widgets**:
- Total followers across platforms
- Engagement rate chart
- Recent posts performance
- Top performing post

### UI Pages

#### Social Accounts Page
- Connected accounts list
- Platform logos
- Connection status
- Account name and handle
- Last synced timestamp
- Connect/Disconnect buttons

#### Create Post Page
- Large text area for content
- Media upload zone (drag-and-drop)
- Platform checkboxes with icons
- Schedule date/time picker
- Preview pane (live preview for each platform)
- Save as Draft / Schedule / Post Now buttons

#### Content Calendar Page
- Full calendar layout
- Month/Week/Day view toggle
- Post indicators on dates
- Click to view/edit post
- Filter sidebar

#### Analytics Page
- Date range selector
- Platform selector
- Key metrics cards
- Engagement chart (line graph)
- Followers growth chart
- Top posts table
- Export report button

---

## 9. Telephony Module

### Purpose
Provide virtual phone numbers, call management, and SMS functionality via Twilio integration.

### Features

#### 9.1 Virtual Number Purchase

**Endpoint**: `POST /api/telephony/numbers/purchase`

**Process**:
1. Search available numbers by area code
2. Display available numbers with capabilities
3. User selects number
4. Purchase via Twilio API
5. Store in database
6. Assign to user

**Number Capabilities**:
- Voice calls (inbound/outbound)
- SMS (inbound/outbound)
- MMS (if supported)

#### 9.2 Call Management

**Endpoints**:
- `GET /api/calls` - Call logs
- `GET /api/calls/:id` - Call detail
- `POST /api/calls/make` - Initiate outbound call
- `GET /api/calls/:id/recording` - Get recording URL

**Call Features**:
- Click-to-call from dashboard
- Call forwarding to user's mobile
- Voicemail
- Call recording (with consent)
- Call notes

**Call Log Display**:
- Direction (inbound/outbound)
- From/To numbers
- Duration
- Status (completed, missed, busy)
- Timestamp
- Recording playback
- Transcript (if available)

#### 9.3 SMS Management

**Endpoints**:
- `GET /api/sms` - SMS list
- `POST /api/sms/send` - Send SMS
- `GET /api/sms/conversations/:number` - Conversation thread

**Features**:
- Send SMS to any number
- Receive SMS
- Conversation threads
- SMS templates
- Bulk SMS (for marketing)

#### 9.4 IVR (Interactive Voice Response) - Future

Configure call routing:
- Press 1 for Sales
- Press 2 for Support
- Press 3 for Billing

### UI Pages

#### Telephony Dashboard
- Active numbers list
- Recent calls widget
- Recent SMS widget
- Usage statistics
- Purchase new number button

#### Call Logs Page
- Table with filters
- Search by number
- Date range filter
- Direction filter (inbound/outbound)
- Play recording button
- Call details modal

#### SMS Page
- Conversation list (left sidebar)
- Message thread (main area)
- Send message input (bottom)
- Search conversations
- New message button

---

## 10. Unified Messaging Module

### Purpose
Aggregate messages from WhatsApp, Facebook Messenger, Instagram DMs into single inbox for admin response.

### Features

#### 10.1 Platform Integrations

**WhatsApp Business API**:
- Connect WhatsApp Business account
- Receive messages via webhook
- Send messages via API
- Media support (images, videos, documents)
- Message templates (for initial contact)

**Facebook Messenger**:
- Connect Facebook Page
- Receive messages via webhook
- Send messages via Graph API
- Rich media support

**Instagram Direct Messages**:
- Connect Instagram Business account
- Receive DMs via webhook
- Send messages via Graph API
- Story replies support

**Endpoints**:
- `POST /api/integrations/whatsapp/connect`
- `POST /api/integrations/facebook/connect`
- `POST /api/integrations/instagram/connect`

#### 10.2 Unified Inbox

**Endpoint**: `GET /api/messages/inbox`

**Features**:
- All conversations in one place
- Filter by platform
- Filter by status (open, closed, archived)
- Filter by assigned admin
- Search messages
- Real-time updates via WebSocket

**Inbox Layout**:
- **Left Sidebar**: Conversation list
  - Client avatar
  - Client name
  - Last message preview
  - Platform icon
  - Unread badge
  - Timestamp
- **Main Area**: Message thread
  - All messages in conversation
  - Platform indicators
  - Sent/Delivered/Read status
  - Admin response field
  - File attachment button
  - Emoji picker
- **Right Sidebar**: Client info
  - Client details
  - Associated companies
  - Recent activity
  - Tags
  - Assign to admin dropdown

#### 10.3 Sending Messages

**Endpoint**: `POST /api/messages/send`

**Request**:
```json
{
  "conversation_id": 123,
  "content": "Hello, how can I help you?",
  "media_url": "https://...", // optional
  "platform": "whatsapp"
}
```

**Process**:
1. Validate message
2. Send via platform API
3. Store in database
4. Update conversation last_message_at
5. Send real-time update to frontend
6. Notify client (platform-specific)

#### 10.4 Message Templates

**Endpoint**: `GET /api/message-templates`

Predefined templates for common responses:
- Welcome message
- Application received
- Documents requested
- Status update
- Thank you message

Admin can select template and personalize before sending.

#### 10.5 Webhooks for Incoming Messages

**Webhook Endpoint**: `POST /api/webhooks/messages/:platform`

**Process**:
1. Receive webhook from platform
2. Verify webhook signature
3. Extract message data
4. Find or create conversation
5. Store message in database
6. Send real-time notification to admin dashboard
7. Send push notification to admin (if enabled)

#### 10.6 Conversation Management

**Endpoints**:
- `PUT /api/conversations/:id/status` - Update status (open/closed/archived)
- `PUT /api/conversations/:id/assign` - Assign to admin
- `POST /api/conversations/:id/tags` - Add tags
- `POST /api/conversations/:id/notes` - Add internal notes

### UI Pages

#### Unified Inbox Page
- Three-column layout
- Platform filter tabs at top
- Conversation list (scrollable)
- Message thread with send field
- Client sidebar
- Keyboard shortcuts for efficiency

#### Integration Settings Page
- List of platforms
- Connection status
- Connect/Disconnect buttons
- Webhook URLs
- Test connection button

---

## 11. Payment & Subscription Module

### Purpose
Handle payments for subscriptions and services with Stripe integration.

### Features

#### 11.1 Subscription Packages Display

**Endpoint**: `GET /api/subscription-packages`

**Response**:
```json
{
  "packages": [
    {
      "id": 1,
      "name": "Basic",
      "price": 29.99,
      "billing_cycle": "monthly",
      "features": [
        "1 Company Formation",
        "VAT Registration",
        "Basic Support",
        "5GB Storage"
      ],
      "max_companies": 1,
      "max_users": 2
    },
    {...}
  ]
}
```

**Package Display Page**:
- Three-column layout (Basic, Professional, Enterprise)
- Feature comparison table
- "Current Plan" badge
- "Upgrade" or "Select Plan" buttons
- FAQ section

#### 11.2 Subscription Purchase

**Endpoint**: `POST /api/subscriptions/subscribe`

**Process**:
1. User selects package
2. Redirect to checkout page
3. Collect payment details (Stripe Elements)
4. Create Stripe customer
5. Create Stripe subscription
6. Store subscription in database
7. Activate user features
8. Send confirmation email
9. Redirect to dashboard

**Free Trial**:
- 14-day free trial for first subscription
- No payment required upfront
- Auto-charge after trial unless cancelled

#### 11.3 Subscription Management

**Endpoints**:
- `GET /api/subscriptions/current` - Current subscription
- `PUT /api/subscriptions/upgrade` - Upgrade plan
- `PUT /api/subscriptions/downgrade` - Downgrade plan
- `POST /api/subscriptions/cancel` - Cancel subscription

**Upgrade/Downgrade**:
- Immediate upgrade with prorated charge
- Downgrade takes effect at end of billing period
- Refund for unused time (upgrade only)

**Cancellation**:
- Cancel at end of period (no refund)
- Immediate cancellation with refund (optional)
- Retain data for 30 days after cancellation
- Re-activation option

#### 11.4 Payment History

**Endpoint**: `GET /api/payments`

**Display**:
- Date
- Description (e.g., "Professional Plan - Monthly")
- Amount
- Status (completed, failed, refunded)
- Invoice download link

#### 11.5 Invoice Generation

**Automatic**:
- Generate invoice for each successful payment
- Email to user
- Available in payment history

**Manual** (for additional services):
- Admin can create manual invoice
- Client receives email
- Client can pay via payment page

#### 11.6 Payment Methods

**Stripe Integration**:
- Credit/Debit cards
- Apple Pay / Google Pay
- Bank transfer (manual confirmation)

**Endpoints**:
- `POST /api/payment-methods` - Add payment method
- `GET /api/payment-methods` - List saved methods
- `DELETE /api/payment-methods/:id` - Remove method
- `PUT /api/payment-methods/:id/set-default` - Set default

#### 11.7 Refunds (Admin Only)

**Endpoint**: `POST /api/payments/:id/refund`

**Process**:
1. Admin initiates refund
2. Specify amount (full or partial)
3. Provide reason
4. Process via Stripe API
5. Update payment status
6. Notify user

### UI Pages

#### Subscription Packages Page
- Pricing comparison cards
- Toggle: Monthly / Yearly (with discount)
- Feature checkmarks
- Highlighted recommended plan
- Select button

#### Checkout Page
- Selected plan summary
- Stripe card element
- Billing address form
- Apply coupon code field
- Terms acceptance
- "Subscribe" button

#### Subscription Management Page
- Current plan details
- Usage statistics (companies, storage, etc.)
- Upgrade/Downgrade buttons
- Cancel subscription button
- Payment method section
- Billing history table

#### Payment History Page
- Table of all payments
- Download invoice button
- Filter by date
- Search

---

## 12. Assistance & Support Module

### Purpose
Provide help resources and support ticket system.

### Features

#### 12.1 FAQ Section

**Endpoint**: `GET /api/faqs`

**Categories**:
- Getting Started
- Company Formation
- VAT & Tax
- Bookkeeping
- Billing & Subscriptions
- Technical Issues

**FAQ Structure**:
- Question
- Answer (rich text with formatting)
- Related articles
- Helpful thumbs up/down

#### 12.2 Knowledge Base

**Endpoint**: `GET /api/knowledge-base/articles`

**Articles Include**:
- Step-by-step guides
- Video tutorials
- Screenshots
- Best practices
- Common issues and solutions

**Search**:
- Full-text search across all articles
- Filter by category
- Popular articles section

#### 12.3 Support Ticket System

**Endpoints**:
- `POST /api/support-tickets` - Create ticket
- `GET /api/support-tickets` - List tickets
- `GET /api/support-tickets/:id` - Ticket detail
- `POST /api/support-tickets/:id/responses` - Add response
- `PUT /api/support-tickets/:id/close` - Close ticket

**Ticket Fields**:
- Subject
- Category (Billing, Technical, General)
- Priority (Low, Medium, High, Urgent)
- Description
- Attachments
- Status (Open, In Progress, Resolved, Closed)

**Ticket Workflow**:
1. User creates ticket
2. System auto-assigns to available admin (or user selects)
3. Admin reviews and responds
4. User can reply
5. Thread continues until resolved
6. Admin closes ticket
7. User can reopen if needed

#### 12.4 Live Chat (Future Feature)

- Real-time chat widget
- Available during business hours
- Queue system
- Chat history saved as support ticket

#### 12.5 Contact Form

**Endpoint**: `POST /api/contact`

Simple contact form for inquiries:
- Name
- Email
- Subject
- Message
- Sends email to support team

### UI Pages

#### Help Center Page
- Search bar at top
- FAQ categories grid
- Popular articles
- Contact support button

#### FAQ Page
- Accordion-style Q&A
- Category navigation
- Search within FAQs

#### Knowledge Base Article Page
- Article content with rich formatting
- Table of contents sidebar
- Related articles footer
- Feedback buttons (Was this helpful?)

#### Support Tickets List Page
- User's tickets in table
- Filter by status
- Search
- Create new ticket button

#### Ticket Detail Page
- Ticket information card
- Conversation thread
- Reply field
- Attach file button
- Close ticket button (if user)

---

## 13. Admin Management Module

### Purpose
Tools for admins to manage clients, view inbox, and track tasks.

### Features

#### 13.1 Client Management

**Endpoint**: `GET /api/admin/clients`

**Features**:
- List all assigned clients
- Search by name, email, company
- Filter by subscription tier
- Sort by registration date, last activity
- View client dashboard link

**Client Actions**:
- View full profile
- Impersonate client (view as client)
- Assign/Reassign to another admin
- Add notes
- View activity history

#### 13.2 Task Queue

**Endpoint**: `GET /api/admin/tasks`

**Task Types**:
- Company Formation (pending review)
- VAT Registration (pending approval)
- CT Registration (pending approval)
- Document Verification (new uploads)
- Filing Reminders (upcoming deadlines)
- Support Tickets (unassigned)

**Task Display**:
- Task description
- Client name
- Priority (high, medium, low)
- Due date
- Action buttons

#### 13.3 Admin Activity Log

**Endpoint**: `GET /api/admin/activity`

Track admin's own activity:
- Actions performed
- Clients served
- Time spent
- Performance metrics

#### 13.4 Admin-to-Admin Communication

**Internal messaging**:
- Message other admins
- Tag in conversations
- Transfer client ownership

### UI Pages

#### Admin Dashboard
- See section 2.2

#### Client List Page
- Table/Cards view
- Search and filters
- Quick actions dropdown
- Pagination

#### Task Queue Page
- Kanban board layout
- Columns: To Do, In Progress, Completed
- Drag-and-drop
- Filter by type
- Sort by priority/due date

#### Client Detail Page (Admin View)
- Full client profile
- All client's companies
- All client's registrations
- Bookkeeping summary
- Message history
- Admin notes section
- Edit client details

---

**Document Version**: 1.0  
**Last Updated**: December 24, 2025  
**Status**: Complete Module Specifications
