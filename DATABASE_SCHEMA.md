# OMC System - Database Schema Design

## Overview

This document outlines the complete database schema for the OMC (Oxford Management Consultancy) system. The schema is designed for PostgreSQL but can be adapted for other relational databases.

## Entity Relationship Diagram (ERD) Overview

```
Users (Super Admin, Admin, Client)
  │
  ├── Profiles
  ├── Sessions
  ├── ActivityLogs
  ├── Subscriptions
  │     └── SubscriptionPackages
  ├── Companies
  │     ├── VATRegistrations
  │     ├── CTRegistrations
  │     ├── VATFilings
  │     └── CTFilings
  ├── Bookkeeping
  │     ├── Transactions
  │     ├── Invoices
  │     └── Expenses
  ├── SocialMediaAccounts
  │     └── SocialMediaPosts
  ├── TelephonyNumbers
  │     ├── CallLogs
  │     └── SMSLogs
  ├── Messages
  ├── Payments
  ├── Documents
  ├── SupportTickets
  └── Notifications
```

## Core Tables

### 1. Users Table

Primary table for all system users (Super Admin, Admin, Client).

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255), -- NULL for OAuth users
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) NOT NULL CHECK (role IN ('super_admin', 'admin', 'client')),
    auth_provider VARCHAR(50) DEFAULT 'email', -- 'email', 'google'
    google_id VARCHAR(255) UNIQUE,
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    email_verified_at TIMESTAMP,
    last_login_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP -- Soft delete
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_google_id ON users(google_id);
```

### 2. Profiles Table

Extended user information.

```sql
CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    avatar_url VARCHAR(500),
    date_of_birth DATE,
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100) DEFAULT 'UK',
    timezone VARCHAR(50) DEFAULT 'Europe/London',
    language VARCHAR(10) DEFAULT 'en',
    bio TEXT,
    website VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_profiles_user_id ON profiles(user_id);
```

### 3. Sessions Table

User session management.

```sql
CREATE TABLE sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT UNIQUE NOT NULL,
    refresh_token TEXT UNIQUE,
    ip_address VARCHAR(45),
    user_agent TEXT,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    revoked_at TIMESTAMP
);

CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_token ON sessions(token);
CREATE INDEX idx_sessions_expires_at ON sessions(expires_at);
```

### 4. Activity Logs Table

Track all user and admin activities.

```sql
CREATE TABLE activity_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50), -- 'company', 'vat', 'booking', etc.
    entity_id INTEGER,
    description TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    metadata JSONB, -- Additional context data
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_activity_logs_user_id ON activity_logs(user_id);
CREATE INDEX idx_activity_logs_entity ON activity_logs(entity_type, entity_id);
CREATE INDEX idx_activity_logs_created_at ON activity_logs(created_at);
```

## Subscription Management

### 5. Subscription Packages Table

Define different subscription tiers.

```sql
CREATE TABLE subscription_packages (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL, -- 'Basic', 'Professional', 'Enterprise'
    slug VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    billing_cycle VARCHAR(20) NOT NULL, -- 'monthly', 'yearly'
    features JSONB, -- List of features included
    max_companies INTEGER,
    max_users INTEGER,
    storage_gb INTEGER,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_packages_slug ON subscription_packages(slug);
CREATE INDEX idx_packages_is_active ON subscription_packages(is_active);
```

### 6. Subscriptions Table

User subscription records.

```sql
CREATE TABLE subscriptions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    package_id INTEGER NOT NULL REFERENCES subscription_packages(id),
    status VARCHAR(20) NOT NULL DEFAULT 'active', -- 'active', 'cancelled', 'expired', 'trial'
    trial_ends_at TIMESTAMP,
    current_period_start TIMESTAMP NOT NULL,
    current_period_end TIMESTAMP NOT NULL,
    cancel_at_period_end BOOLEAN DEFAULT false,
    cancelled_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_period_end ON subscriptions(current_period_end);
```

## Company Formation Module

### 7. Companies Table

Client company information.

```sql
CREATE TABLE companies (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    company_name VARCHAR(255) NOT NULL,
    company_number VARCHAR(50) UNIQUE,
    company_type VARCHAR(50), -- 'Ltd', 'LLP', 'Sole Trader'
    incorporation_date DATE,
    registered_address_line1 VARCHAR(255),
    registered_address_line2 VARCHAR(255),
    registered_city VARCHAR(100),
    registered_postal_code VARCHAR(20),
    registered_country VARCHAR(100) DEFAULT 'UK',
    trading_address_same_as_registered BOOLEAN DEFAULT true,
    trading_address_line1 VARCHAR(255),
    trading_address_line2 VARCHAR(255),
    trading_city VARCHAR(100),
    trading_postal_code VARCHAR(20),
    trading_country VARCHAR(100),
    sic_code VARCHAR(10),
    business_description TEXT,
    website VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'in_progress', 'completed', 'rejected'
    assigned_admin_id INTEGER REFERENCES users(id),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_companies_user_id ON companies(user_id);
CREATE INDEX idx_companies_company_number ON companies(company_number);
CREATE INDEX idx_companies_status ON companies(status);
CREATE INDEX idx_companies_assigned_admin_id ON companies(assigned_admin_id);
```

### 8. Company Directors Table

Directors for each company.

```sql
CREATE TABLE company_directors (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    nationality VARCHAR(100),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    appointment_date DATE,
    resignation_date DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_directors_company_id ON company_directors(company_id);
```

## VAT & Corporate Tax Modules

### 9. VAT Registrations Table

```sql
CREATE TABLE vat_registrations (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    vat_number VARCHAR(50) UNIQUE,
    application_date DATE NOT NULL,
    registration_date DATE,
    effective_date DATE,
    scheme VARCHAR(50), -- 'Standard', 'Flat Rate', 'Cash Accounting'
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'approved', 'rejected', 'active'
    assigned_admin_id INTEGER REFERENCES users(id),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_vat_registrations_company_id ON vat_registrations(company_id);
CREATE INDEX idx_vat_registrations_vat_number ON vat_registrations(vat_number);
CREATE INDEX idx_vat_registrations_status ON vat_registrations(status);
```

### 10. CT Registrations Table

```sql
CREATE TABLE ct_registrations (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    utr_number VARCHAR(50) UNIQUE, -- Unique Taxpayer Reference
    application_date DATE NOT NULL,
    registration_date DATE,
    accounting_period_start DATE,
    accounting_period_end DATE,
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'approved', 'rejected', 'active'
    assigned_admin_id INTEGER REFERENCES users(id),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_ct_registrations_company_id ON ct_registrations(company_id);
CREATE INDEX idx_ct_registrations_utr_number ON ct_registrations(utr_number);
CREATE INDEX idx_ct_registrations_status ON ct_registrations(status);
```

### 11. VAT Filings Table

```sql
CREATE TABLE vat_filings (
    id SERIAL PRIMARY KEY,
    vat_registration_id INTEGER NOT NULL REFERENCES vat_registrations(id) ON DELETE CASCADE,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    due_date DATE NOT NULL,
    submission_date DATE,
    vat_due_sales DECIMAL(12, 2),
    vat_due_acquisitions DECIMAL(12, 2),
    total_vat_due DECIMAL(12, 2),
    vat_reclaimed DECIMAL(12, 2),
    net_vat_due DECIMAL(12, 2),
    total_value_sales DECIMAL(12, 2),
    total_value_purchases DECIMAL(12, 2),
    status VARCHAR(20) DEFAULT 'draft', -- 'draft', 'submitted', 'accepted', 'rejected'
    assigned_admin_id INTEGER REFERENCES users(id),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_vat_filings_registration_id ON vat_filings(vat_registration_id);
CREATE INDEX idx_vat_filings_due_date ON vat_filings(due_date);
CREATE INDEX idx_vat_filings_status ON vat_filings(status);
```

### 12. CT Filings Table

```sql
CREATE TABLE ct_filings (
    id SERIAL PRIMARY KEY,
    ct_registration_id INTEGER NOT NULL REFERENCES ct_registrations(id) ON DELETE CASCADE,
    accounting_period_start DATE NOT NULL,
    accounting_period_end DATE NOT NULL,
    due_date DATE NOT NULL,
    submission_date DATE,
    turnover DECIMAL(15, 2),
    trading_profits DECIMAL(15, 2),
    taxable_profits DECIMAL(15, 2),
    tax_due DECIMAL(12, 2),
    tax_paid DECIMAL(12, 2),
    status VARCHAR(20) DEFAULT 'draft', -- 'draft', 'submitted', 'accepted', 'rejected'
    assigned_admin_id INTEGER REFERENCES users(id),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_ct_filings_registration_id ON ct_filings(ct_registration_id);
CREATE INDEX idx_ct_filings_due_date ON ct_filings(due_date);
CREATE INDEX idx_ct_filings_status ON ct_filings(status);
```

## Bookkeeping Module

### 13. Transactions Table

```sql
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    transaction_date DATE NOT NULL,
    type VARCHAR(20) NOT NULL, -- 'income', 'expense'
    category VARCHAR(100),
    description TEXT NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    vat_amount DECIMAL(12, 2) DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'GBP',
    payment_method VARCHAR(50), -- 'cash', 'bank_transfer', 'card', 'cheque'
    reference VARCHAR(100),
    invoice_id INTEGER REFERENCES invoices(id),
    bank_reconciled BOOLEAN DEFAULT false,
    reconciled_at TIMESTAMP,
    assigned_admin_id INTEGER REFERENCES users(id),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_transactions_company_id ON transactions(company_id);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);
CREATE INDEX idx_transactions_type ON transactions(type);
```

### 14. Invoices Table

```sql
CREATE TABLE invoices (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    invoice_date DATE NOT NULL,
    due_date DATE NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    customer_email VARCHAR(255),
    customer_address TEXT,
    subtotal DECIMAL(12, 2) NOT NULL,
    vat_amount DECIMAL(12, 2) DEFAULT 0,
    total_amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'GBP',
    status VARCHAR(20) DEFAULT 'draft', -- 'draft', 'sent', 'paid', 'overdue', 'cancelled'
    paid_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_invoices_company_id ON invoices(company_id);
CREATE INDEX idx_invoices_invoice_number ON invoices(invoice_number);
CREATE INDEX idx_invoices_status ON invoices(status);
```

### 15. Invoice Items Table

```sql
CREATE TABLE invoice_items (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
    description TEXT NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL DEFAULT 1,
    unit_price DECIMAL(12, 2) NOT NULL,
    vat_rate DECIMAL(5, 2) DEFAULT 20.00,
    amount DECIMAL(12, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_invoice_items_invoice_id ON invoice_items(invoice_id);
```

### 16. Expenses Table

```sql
CREATE TABLE expenses (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    expense_date DATE NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    vat_amount DECIMAL(12, 2) DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'GBP',
    payment_method VARCHAR(50),
    supplier_name VARCHAR(255),
    reference VARCHAR(100),
    receipt_url VARCHAR(500),
    is_reimbursable BOOLEAN DEFAULT false,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_expenses_company_id ON expenses(company_id);
CREATE INDEX idx_expenses_date ON expenses(expense_date);
CREATE INDEX idx_expenses_category ON expenses(category);
```

## Social Media Module

### 17. Social Media Accounts Table

```sql
CREATE TABLE social_media_accounts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    platform VARCHAR(50) NOT NULL, -- 'facebook', 'instagram', 'twitter', 'linkedin'
    account_id VARCHAR(255) NOT NULL,
    account_name VARCHAR(255),
    access_token TEXT,
    refresh_token TEXT,
    token_expires_at TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    last_synced_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, platform, account_id)
);

CREATE INDEX idx_social_accounts_user_id ON social_media_accounts(user_id);
CREATE INDEX idx_social_accounts_platform ON social_media_accounts(platform);
```

### 18. Social Media Posts Table

```sql
CREATE TABLE social_media_posts (
    id SERIAL PRIMARY KEY,
    account_id INTEGER NOT NULL REFERENCES social_media_accounts(id) ON DELETE CASCADE,
    post_id VARCHAR(255), -- Platform-specific post ID
    content TEXT NOT NULL,
    media_urls TEXT[], -- Array of image/video URLs
    scheduled_at TIMESTAMP,
    published_at TIMESTAMP,
    status VARCHAR(20) DEFAULT 'draft', -- 'draft', 'scheduled', 'published', 'failed'
    engagement_likes INTEGER DEFAULT 0,
    engagement_comments INTEGER DEFAULT 0,
    engagement_shares INTEGER DEFAULT 0,
    engagement_impressions INTEGER DEFAULT 0,
    last_synced_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_social_posts_account_id ON social_media_posts(account_id);
CREATE INDEX idx_social_posts_status ON social_media_posts(status);
CREATE INDEX idx_social_posts_scheduled_at ON social_media_posts(scheduled_at);
```

## Telephony Module

### 19. Telephony Numbers Table

```sql
CREATE TABLE telephony_numbers (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    country_code VARCHAR(5),
    provider VARCHAR(50) DEFAULT 'twilio',
    provider_sid VARCHAR(255),
    capabilities JSONB, -- {voice: true, sms: true, mms: false}
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_telephony_user_id ON telephony_numbers(user_id);
CREATE INDEX idx_telephony_phone_number ON telephony_numbers(phone_number);
```

### 20. Call Logs Table

```sql
CREATE TABLE call_logs (
    id SERIAL PRIMARY KEY,
    telephony_number_id INTEGER NOT NULL REFERENCES telephony_numbers(id) ON DELETE CASCADE,
    direction VARCHAR(10) NOT NULL, -- 'inbound', 'outbound'
    from_number VARCHAR(20) NOT NULL,
    to_number VARCHAR(20) NOT NULL,
    status VARCHAR(20), -- 'completed', 'busy', 'no-answer', 'failed'
    duration_seconds INTEGER,
    recording_url VARCHAR(500),
    call_sid VARCHAR(255),
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_call_logs_telephony_id ON call_logs(telephony_number_id);
CREATE INDEX idx_call_logs_started_at ON call_logs(started_at);
```

### 21. SMS Logs Table

```sql
CREATE TABLE sms_logs (
    id SERIAL PRIMARY KEY,
    telephony_number_id INTEGER NOT NULL REFERENCES telephony_numbers(id) ON DELETE CASCADE,
    direction VARCHAR(10) NOT NULL, -- 'inbound', 'outbound'
    from_number VARCHAR(20) NOT NULL,
    to_number VARCHAR(20) NOT NULL,
    message TEXT NOT NULL,
    status VARCHAR(20), -- 'sent', 'delivered', 'failed'
    sms_sid VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_sms_logs_telephony_id ON sms_logs(telephony_number_id);
CREATE INDEX idx_sms_logs_created_at ON sms_logs(created_at);
```

## Unified Messaging Module

### 22. Messages Table

```sql
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    conversation_id INTEGER NOT NULL,
    sender_type VARCHAR(20) NOT NULL, -- 'client', 'admin'
    sender_id INTEGER NOT NULL REFERENCES users(id),
    recipient_id INTEGER NOT NULL REFERENCES users(id),
    platform VARCHAR(50) NOT NULL, -- 'whatsapp', 'facebook', 'instagram', 'internal'
    platform_message_id VARCHAR(255),
    message_type VARCHAR(20) DEFAULT 'text', -- 'text', 'image', 'video', 'audio', 'file'
    content TEXT,
    media_url VARCHAR(500),
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_recipient_id ON messages(recipient_id);
CREATE INDEX idx_messages_platform ON messages(platform);
CREATE INDEX idx_messages_created_at ON messages(created_at);
```

### 23. Conversations Table

```sql
CREATE TABLE conversations (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES users(id),
    admin_id INTEGER REFERENCES users(id),
    platform VARCHAR(50) NOT NULL,
    status VARCHAR(20) DEFAULT 'open', -- 'open', 'closed', 'archived'
    last_message_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_conversations_client_id ON conversations(client_id);
CREATE INDEX idx_conversations_admin_id ON conversations(admin_id);
CREATE INDEX idx_conversations_status ON conversations(status);
```

## Payment Module

### 24. Payments Table

```sql
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    subscription_id INTEGER REFERENCES subscriptions(id),
    invoice_id INTEGER REFERENCES invoices(id),
    amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'GBP',
    payment_method VARCHAR(50), -- 'stripe', 'paypal', 'bank_transfer'
    payment_provider_id VARCHAR(255), -- Stripe charge ID, PayPal transaction ID
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'completed', 'failed', 'refunded'
    payment_date TIMESTAMP,
    failure_reason TEXT,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_payments_user_id ON payments(user_id);
CREATE INDEX idx_payments_subscription_id ON payments(subscription_id);
CREATE INDEX idx_payments_status ON payments(status);
```

## Documents Module

### 25. Documents Table

```sql
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    entity_type VARCHAR(50), -- 'company', 'vat', 'ct', 'bookkeeping', 'invoice'
    entity_id INTEGER,
    document_type VARCHAR(50) NOT NULL, -- 'incorporation_certificate', 'id_proof', 'receipt', etc.
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size INTEGER, -- In bytes
    mime_type VARCHAR(100),
    uploaded_by INTEGER REFERENCES users(id),
    is_verified BOOLEAN DEFAULT false,
    verified_by INTEGER REFERENCES users(id),
    verified_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_documents_user_id ON documents(user_id);
CREATE INDEX idx_documents_entity ON documents(entity_type, entity_id);
CREATE INDEX idx_documents_uploaded_by ON documents(uploaded_by);
```

## Support Module

### 26. Support Tickets Table

```sql
CREATE TABLE support_tickets (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(50), -- 'billing', 'technical', 'general'
    priority VARCHAR(20) DEFAULT 'medium', -- 'low', 'medium', 'high', 'urgent'
    status VARCHAR(20) DEFAULT 'open', -- 'open', 'in_progress', 'resolved', 'closed'
    assigned_admin_id INTEGER REFERENCES users(id),
    resolved_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_support_tickets_user_id ON support_tickets(user_id);
CREATE INDEX idx_support_tickets_status ON support_tickets(status);
CREATE INDEX idx_support_tickets_assigned_admin_id ON support_tickets(assigned_admin_id);
```

### 27. Ticket Responses Table

```sql
CREATE TABLE ticket_responses (
    id SERIAL PRIMARY KEY,
    ticket_id INTEGER NOT NULL REFERENCES support_tickets(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id),
    response TEXT NOT NULL,
    is_internal BOOLEAN DEFAULT false, -- Internal note visible only to admins
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_ticket_responses_ticket_id ON ticket_responses(ticket_id);
CREATE INDEX idx_ticket_responses_user_id ON ticket_responses(user_id);
```

## Notifications Module

### 28. Notifications Table

```sql
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL, -- 'system', 'message', 'payment', 'deadline'
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    action_url VARCHAR(500),
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);
```

## API Integration Tables

### 29. Integration Credentials Table

```sql
CREATE TABLE integration_credentials (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    integration_type VARCHAR(50) NOT NULL, -- 'zoho', 'quickbooks', 'whatsapp'
    client_id VARCHAR(255),
    client_secret TEXT, -- Encrypted
    access_token TEXT, -- Encrypted
    refresh_token TEXT, -- Encrypted
    token_expires_at TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    last_synced_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, integration_type)
);

CREATE INDEX idx_integration_credentials_user_id ON integration_credentials(user_id);
CREATE INDEX idx_integration_credentials_type ON integration_credentials(integration_type);
```

### 30. Integration Sync Logs Table

```sql
CREATE TABLE integration_sync_logs (
    id SERIAL PRIMARY KEY,
    integration_credential_id INTEGER NOT NULL REFERENCES integration_credentials(id) ON DELETE CASCADE,
    sync_type VARCHAR(50) NOT NULL, -- 'transactions', 'invoices', 'customers'
    status VARCHAR(20) NOT NULL, -- 'success', 'failed', 'partial'
    records_synced INTEGER DEFAULT 0,
    error_message TEXT,
    started_at TIMESTAMP NOT NULL,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_sync_logs_credential_id ON integration_sync_logs(integration_credential_id);
CREATE INDEX idx_sync_logs_started_at ON integration_sync_logs(started_at);
```

## System Settings

### 31. System Settings Table

```sql
CREATE TABLE system_settings (
    id SERIAL PRIMARY KEY,
    key VARCHAR(100) UNIQUE NOT NULL,
    value TEXT,
    data_type VARCHAR(20) DEFAULT 'string', -- 'string', 'number', 'boolean', 'json'
    description TEXT,
    is_public BOOLEAN DEFAULT false, -- Can be accessed by non-admin users
    updated_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_system_settings_key ON system_settings(key);
```

## Database Functions and Triggers

### Update Timestamp Trigger

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to all tables with updated_at column
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Repeat for all other tables with updated_at
```

### Generate Invoice Number Function

```sql
CREATE OR REPLACE FUNCTION generate_invoice_number()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.invoice_number IS NULL THEN
        NEW.invoice_number := 'INV-' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || LPAD(NEXTVAL('invoice_sequence')::TEXT, 5, '0');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE SEQUENCE invoice_sequence START 1;

CREATE TRIGGER set_invoice_number BEFORE INSERT ON invoices
    FOR EACH ROW EXECUTE FUNCTION generate_invoice_number();
```

## Initial Data Seeds

### Default Super Admin

```sql
INSERT INTO users (email, password_hash, first_name, last_name, role, is_active, is_verified)
VALUES ('admin@omc.com', '$2b$10$...', 'Super', 'Admin', 'super_admin', true, true);
```

### Default Subscription Packages

```sql
INSERT INTO subscription_packages (name, slug, description, price, billing_cycle, features, max_companies, max_users, storage_gb)
VALUES 
    ('Basic', 'basic', 'Perfect for startups', 29.99, 'monthly', '["Company Formation", "VAT Registration"]', 1, 2, 5),
    ('Professional', 'professional', 'For growing businesses', 79.99, 'monthly', '["Company Formation", "VAT Registration", "Bookkeeping", "Social Media"]', 3, 5, 20),
    ('Enterprise', 'enterprise', 'Full-featured solution', 199.99, 'monthly', '["All Features", "Priority Support", "API Access"]', 10, 20, 100);
```

---

**Document Version**: 1.0  
**Database**: PostgreSQL 14+  
**Last Updated**: December 24, 2025
