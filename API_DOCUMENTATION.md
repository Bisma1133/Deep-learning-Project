# OMC System - API Documentation

## Table of Contents

1. [API Overview](#api-overview)
2. [Authentication](#authentication)
3. [Error Handling](#error-handling)
4. [Pagination](#pagination)
5. [API Endpoints](#api-endpoints)

---

## API Overview

### Base URL
```
Development: http://localhost:5000/api/v1
Production: https://api.omc.com/api/v1
```

### Response Format

**Success Response**:
```json
{
  "success": true,
  "data": { /* response data */ },
  "message": "Operation successful"
}
```

**Error Response**:
```json
{
  "success": false,
  "error": "Error message",
  "errors": [ /* validation errors if applicable */ ]
}
```

### HTTP Status Codes

| Code | Description |
|------|-------------|
| 200 | OK - Request successful |
| 201 | Created - Resource created successfully |
| 400 | Bad Request - Invalid input |
| 401 | Unauthorized - Authentication required or failed |
| 403 | Forbidden - Insufficient permissions |
| 404 | Not Found - Resource doesn't exist |
| 422 | Unprocessable Entity - Validation failed |
| 429 | Too Many Requests - Rate limit exceeded |
| 500 | Internal Server Error - Server error |

---

## Authentication

### Register

**Endpoint**: `POST /auth/register`

**Request Body**:
```json
{
  "email": "john@example.com",
  "password": "SecurePass123!",
  "first_name": "John",
  "last_name": "Doe",
  "phone": "+447123456789"
}
```

**Response** (201):
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "uuid": "550e8400-e29b-41d4-a716-446655440000",
      "email": "john@example.com",
      "first_name": "John",
      "last_name": "Doe",
      "role": "client",
      "is_verified": false
    }
  },
  "message": "Registration successful. Please check your email to verify your account."
}
```

---

### Login

**Endpoint**: `POST /auth/login`

**Request Body**:
```json
{
  "email": "john@example.com",
  "password": "SecurePass123!"
}
```

**Response** (200):
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "uuid": "550e8400-e29b-41d4-a716-446655440000",
      "email": "john@example.com",
      "first_name": "John",
      "last_name": "Doe",
      "role": "client"
    },
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 3600
  }
}
```

---

### Google OAuth

**Endpoint**: `POST /auth/google`

**Request Body**:
```json
{
  "token": "google_oauth_token"
}
```

**Response**: Same as login

---

### Refresh Token

**Endpoint**: `POST /auth/refresh`

**Request Body**:
```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response** (200):
```json
{
  "success": true,
  "data": {
    "access_token": "new_access_token",
    "expires_in": 3600
  }
}
```

---

### Logout

**Endpoint**: `POST /auth/logout`

**Headers**: `Authorization: Bearer {access_token}`

**Response** (200):
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

## Error Handling

### Validation Error Example

**Response** (422):
```json
{
  "success": false,
  "error": "Validation failed",
  "errors": [
    {
      "field": "email",
      "message": "Email is required"
    },
    {
      "field": "password",
      "message": "Password must be at least 8 characters"
    }
  ]
}
```

### Authentication Error

**Response** (401):
```json
{
  "success": false,
  "error": "Invalid credentials"
}
```

### Authorization Error

**Response** (403):
```json
{
  "success": false,
  "error": "Forbidden. Insufficient permissions."
}
```

---

## Pagination

### Query Parameters

- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20, max: 100)
- `sort`: Sort field
- `order`: Sort order (asc/desc)

### Example Request

```
GET /companies?page=2&limit=10&sort=created_at&order=desc
```

### Paginated Response

```json
{
  "success": true,
  "data": [
    { /* company object */ },
    { /* company object */ }
  ],
  "meta": {
    "current_page": 2,
    "per_page": 10,
    "total_pages": 5,
    "total_count": 48,
    "has_next_page": true,
    "has_prev_page": true
  }
}
```

---

## API Endpoints

### User & Profile

#### Get Current User

**Endpoint**: `GET /users/me`

**Headers**: `Authorization: Bearer {token}`

**Response** (200):
```json
{
  "success": true,
  "data": {
    "id": 1,
    "uuid": "550e8400-e29b-41d4-a716-446655440000",
    "email": "john@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "phone": "+447123456789",
    "role": "client",
    "profile": {
      "avatar_url": "https://...",
      "date_of_birth": "1990-01-15",
      "address_line1": "123 High Street",
      "city": "London",
      "postal_code": "E1 6AN",
      "country": "UK"
    }
  }
}
```

---

#### Update Profile

**Endpoint**: `PUT /users/profile`

**Headers**: `Authorization: Bearer {token}`

**Request Body**:
```json
{
  "first_name": "John",
  "last_name": "Smith",
  "phone": "+447987654321",
  "date_of_birth": "1990-01-15",
  "address_line1": "456 New Street",
  "city": "Manchester",
  "postal_code": "M1 1AA"
}
```

**Response** (200):
```json
{
  "success": true,
  "data": { /* updated user */ },
  "message": "Profile updated successfully"
}
```

---

#### Upload Avatar

**Endpoint**: `POST /users/avatar`

**Headers**: 
- `Authorization: Bearer {token}`
- `Content-Type: multipart/form-data`

**Request Body** (form-data):
- `avatar`: File

**Response** (200):
```json
{
  "success": true,
  "data": {
    "avatar_url": "https://storage.omc.com/avatars/user_1_avatar.jpg"
  }
}
```

---

### Companies

#### Get All Companies

**Endpoint**: `GET /companies`

**Headers**: `Authorization: Bearer {token}`

**Query Parameters**:
- `page`: Page number
- `limit`: Items per page
- `status`: Filter by status (pending, in_progress, completed, rejected)
- `search`: Search by company name

**Example**: `GET /companies?status=completed&search=Tech`

**Response** (200):
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "company_name": "Tech Innovations Ltd",
      "company_number": "12345678",
      "company_type": "Ltd",
      "status": "completed",
      "incorporation_date": "2025-11-15",
      "registered_address": "123 High Street, London, E1 6AN",
      "assigned_admin": {
        "id": 5,
        "name": "Admin Name"
      },
      "created_at": "2025-10-01T10:00:00Z",
      "updated_at": "2025-11-15T14:30:00Z"
    }
  ],
  "meta": { /* pagination */ }
}
```

---

#### Get Company by ID

**Endpoint**: `GET /companies/:id`

**Headers**: `Authorization: Bearer {token}`

**Response** (200):
```json
{
  "success": true,
  "data": {
    "id": 1,
    "company_name": "Tech Innovations Ltd",
    "company_number": "12345678",
    "company_type": "Ltd",
    "incorporation_date": "2025-11-15",
    "registered_address_line1": "123 High Street",
    "registered_city": "London",
    "registered_postal_code": "E1 6AN",
    "status": "completed",
    "directors": [
      {
        "id": 1,
        "first_name": "John",
        "last_name": "Smith",
        "date_of_birth": "1985-05-15",
        "nationality": "British"
      }
    ],
    "documents": [
      {
        "id": 1,
        "document_type": "incorporation_certificate",
        "file_name": "certificate.pdf",
        "file_url": "https://storage.omc.com/documents/certificate.pdf",
        "uploaded_at": "2025-11-15T14:30:00Z"
      }
    ],
    "created_at": "2025-10-01T10:00:00Z",
    "updated_at": "2025-11-15T14:30:00Z"
  }
}
```

---

#### Create Company

**Endpoint**: `POST /companies`

**Headers**: `Authorization: Bearer {token}`

**Request Body**:
```json
{
  "company_name": "Tech Innovations Ltd",
  "company_type": "Ltd",
  "business_description": "Software development and consulting",
  "sic_code": "62011",
  "registered_address_line1": "123 High Street",
  "registered_city": "London",
  "registered_postal_code": "E1 6AN",
  "registered_country": "UK",
  "trading_address_same_as_registered": true,
  "website": "https://techinnovations.com",
  "email": "info@techinnovations.com",
  "phone": "+442012345678",
  "directors": [
    {
      "first_name": "John",
      "last_name": "Smith",
      "date_of_birth": "1985-05-15",
      "nationality": "British",
      "address_line1": "123 High Street",
      "city": "London",
      "postal_code": "E1 6AN",
      "country": "UK"
    }
  ]
}
```

**Response** (201):
```json
{
  "success": true,
  "data": { /* created company */ },
  "message": "Company formation application submitted successfully"
}
```

---

#### Update Company

**Endpoint**: `PUT /companies/:id`

**Headers**: `Authorization: Bearer {token}`

**Request Body**: Same as create (partial updates allowed)

**Response** (200):
```json
{
  "success": true,
  "data": { /* updated company */ },
  "message": "Company updated successfully"
}
```

---

#### Update Company Status (Admin Only)

**Endpoint**: `PUT /companies/:id/status`

**Headers**: `Authorization: Bearer {token}`

**Permissions**: admin, super_admin

**Request Body**:
```json
{
  "status": "in_progress",
  "notes": "Started processing the application"
}
```

**Response** (200):
```json
{
  "success": true,
  "data": { /* updated company */ },
  "message": "Company status updated successfully"
}
```

---

#### Upload Company Document

**Endpoint**: `POST /companies/:id/documents`

**Headers**: 
- `Authorization: Bearer {token}`
- `Content-Type: multipart/form-data`

**Request Body** (form-data):
- `file`: File
- `document_type`: string (e.g., "id_proof", "incorporation_certificate")

**Response** (201):
```json
{
  "success": true,
  "data": {
    "id": 1,
    "document_type": "id_proof",
    "file_name": "passport.pdf",
    "file_url": "https://storage.omc.com/documents/passport.pdf"
  }
}
```

---

### VAT Registration

#### Get All VAT Registrations

**Endpoint**: `GET /vat-registrations`

**Headers**: `Authorization: Bearer {token}`

**Response** (200):
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "company": {
        "id": 1,
        "company_name": "Tech Innovations Ltd"
      },
      "vat_number": "GB123456789",
      "application_date": "2025-12-01",
      "registration_date": "2025-12-15",
      "effective_date": "2026-01-01",
      "scheme": "Standard",
      "status": "active",
      "created_at": "2025-12-01T10:00:00Z"
    }
  ],
  "meta": { /* pagination */ }
}
```

---

#### Create VAT Registration

**Endpoint**: `POST /vat-registrations`

**Headers**: `Authorization: Bearer {token}`

**Request Body**:
```json
{
  "company_id": 1,
  "application_date": "2025-12-01",
  "expected_turnover": 120000.00,
  "taxable_supplies_date": "2026-01-01",
  "scheme": "Standard",
  "business_activity": "Software development services"
}
```

**Response** (201):
```json
{
  "success": true,
  "data": { /* created VAT registration */ },
  "message": "VAT registration application submitted successfully"
}
```

---

#### Approve VAT Registration (Admin Only)

**Endpoint**: `PUT /vat-registrations/:id/approve`

**Headers**: `Authorization: Bearer {token}`

**Permissions**: admin, super_admin

**Request Body**:
```json
{
  "vat_number": "GB123456789",
  "registration_date": "2025-12-15",
  "effective_date": "2026-01-01"
}
```

**Response** (200):
```json
{
  "success": true,
  "data": { /* updated VAT registration */ },
  "message": "VAT registration approved successfully"
}
```

---

### Bookkeeping

#### Get All Transactions

**Endpoint**: `GET /transactions`

**Headers**: `Authorization: Bearer {token}`

**Query Parameters**:
- `company_id`: Filter by company
- `type`: Filter by type (income/expense)
- `category`: Filter by category
- `from_date`: Start date (YYYY-MM-DD)
- `to_date`: End date (YYYY-MM-DD)

**Example**: `GET /transactions?company_id=1&type=income&from_date=2026-01-01&to_date=2026-01-31`

**Response** (200):
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "company_id": 1,
      "transaction_date": "2026-01-15",
      "type": "income",
      "category": "Sales Revenue",
      "description": "Consulting services for ABC Corp",
      "amount": 2500.00,
      "vat_amount": 500.00,
      "currency": "GBP",
      "payment_method": "bank_transfer",
      "created_at": "2026-01-15T10:00:00Z"
    }
  ],
  "meta": { /* pagination */ }
}
```

---

#### Create Transaction

**Endpoint**: `POST /transactions`

**Headers**: `Authorization: Bearer {token}`

**Request Body**:
```json
{
  "company_id": 1,
  "transaction_date": "2026-01-15",
  "type": "income",
  "category": "Sales Revenue",
  "description": "Consulting services for ABC Corp",
  "amount": 2500.00,
  "vat_amount": 500.00,
  "payment_method": "bank_transfer",
  "reference": "INV-001"
}
```

**Response** (201):
```json
{
  "success": true,
  "data": { /* created transaction */ },
  "message": "Transaction recorded successfully"
}
```

---

#### Get All Invoices

**Endpoint**: `GET /invoices`

**Headers**: `Authorization: Bearer {token}`

**Query Parameters**:
- `company_id`: Filter by company
- `status`: Filter by status (draft, sent, paid, overdue, cancelled)

**Response** (200):
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "company_id": 1,
      "invoice_number": "INV-20260115-00001",
      "invoice_date": "2026-01-15",
      "due_date": "2026-02-14",
      "customer_name": "ABC Corporation",
      "customer_email": "accounts@abc.com",
      "subtotal": 2500.00,
      "vat_amount": 500.00,
      "total_amount": 3000.00,
      "status": "sent",
      "items": [
        {
          "description": "Consulting Services - January",
          "quantity": 10,
          "unit_price": 250.00,
          "vat_rate": 20.00,
          "amount": 2500.00
        }
      ],
      "created_at": "2026-01-15T10:00:00Z"
    }
  ],
  "meta": { /* pagination */ }
}
```

---

#### Create Invoice

**Endpoint**: `POST /invoices`

**Headers**: `Authorization: Bearer {token}`

**Request Body**:
```json
{
  "company_id": 1,
  "invoice_date": "2026-01-15",
  "due_date": "2026-02-14",
  "customer_name": "ABC Corporation",
  "customer_email": "accounts@abc.com",
  "customer_address": "456 Business Park, London",
  "items": [
    {
      "description": "Consulting Services - January",
      "quantity": 10,
      "unit_price": 250.00,
      "vat_rate": 20.00
    }
  ],
  "notes": "Payment due within 30 days"
}
```

**Response** (201):
```json
{
  "success": true,
  "data": { /* created invoice */ },
  "message": "Invoice created successfully"
}
```

---

#### Send Invoice

**Endpoint**: `POST /invoices/:id/send`

**Headers**: `Authorization: Bearer {token}`

**Response** (200):
```json
{
  "success": true,
  "message": "Invoice sent to customer successfully"
}
```

---

#### Mark Invoice as Paid

**Endpoint**: `POST /invoices/:id/mark-paid`

**Headers**: `Authorization: Bearer {token}`

**Request Body**:
```json
{
  "paid_date": "2026-02-10",
  "payment_method": "bank_transfer"
}
```

**Response** (200):
```json
{
  "success": true,
  "data": { /* updated invoice */ },
  "message": "Invoice marked as paid"
}
```

---

### Reports

#### Get Profit & Loss Report

**Endpoint**: `GET /reports/profit-loss`

**Headers**: `Authorization: Bearer {token}`

**Query Parameters**:
- `company_id`: Company ID (required)
- `from_date`: Start date (required)
- `to_date`: End date (required)
- `format`: Response format (json/pdf/csv, default: json)

**Example**: `GET /reports/profit-loss?company_id=1&from_date=2026-01-01&to_date=2026-01-31`

**Response** (200):
```json
{
  "success": true,
  "data": {
    "company": {
      "id": 1,
      "name": "Tech Innovations Ltd"
    },
    "period": {
      "from": "2026-01-01",
      "to": "2026-01-31"
    },
    "income": {
      "Sales Revenue": 15000.00,
      "Service Income": 8000.00,
      "total": 23000.00
    },
    "expenses": {
      "Office Supplies": 1200.00,
      "Marketing": 2500.00,
      "Professional Fees": 1000.00,
      "total": 4700.00
    },
    "net_profit": 18300.00
  }
}
```

---

### Messages (Unified Inbox)

#### Get Conversations

**Endpoint**: `GET /conversations`

**Headers**: `Authorization: Bearer {token}`

**Query Parameters**:
- `platform`: Filter by platform (whatsapp, facebook, instagram, internal)
- `status`: Filter by status (open, closed, archived)

**Response** (200):
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "client": {
        "id": 10,
        "name": "John Smith"
      },
      "admin": {
        "id": 5,
        "name": "Admin Name"
      },
      "platform": "whatsapp",
      "status": "open",
      "unread_count": 2,
      "last_message": {
        "content": "Hi, I need help with my VAT registration",
        "created_at": "2026-01-15T14:30:00Z"
      },
      "created_at": "2026-01-15T10:00:00Z",
      "updated_at": "2026-01-15T14:30:00Z"
    }
  ],
  "meta": { /* pagination */ }
}
```

---

#### Get Messages in Conversation

**Endpoint**: `GET /conversations/:id/messages`

**Headers**: `Authorization: Bearer {token}`

**Response** (200):
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "conversation_id": 1,
      "sender_type": "client",
      "sender": {
        "id": 10,
        "name": "John Smith"
      },
      "platform": "whatsapp",
      "message_type": "text",
      "content": "Hi, I need help with my VAT registration",
      "is_read": true,
      "read_at": "2026-01-15T14:32:00Z",
      "created_at": "2026-01-15T14:30:00Z"
    },
    {
      "id": 2,
      "conversation_id": 1,
      "sender_type": "admin",
      "sender": {
        "id": 5,
        "name": "Admin Name"
      },
      "platform": "whatsapp",
      "message_type": "text",
      "content": "Hi John, I'd be happy to help. What specifically do you need?",
      "is_read": false,
      "created_at": "2026-01-15T14:35:00Z"
    }
  ]
}
```

---

#### Send Message

**Endpoint**: `POST /messages/send`

**Headers**: `Authorization: Bearer {token}`

**Request Body**:
```json
{
  "conversation_id": 1,
  "content": "Your VAT registration has been approved!",
  "message_type": "text"
}
```

**Response** (201):
```json
{
  "success": true,
  "data": { /* sent message */ },
  "message": "Message sent successfully"
}
```

---

### Subscriptions

#### Get Subscription Packages

**Endpoint**: `GET /subscription-packages`

**Response** (200):
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Basic",
      "slug": "basic",
      "description": "Perfect for startups",
      "price": 29.99,
      "billing_cycle": "monthly",
      "features": [
        "Company Formation",
        "VAT Registration",
        "Basic Support",
        "5GB Storage"
      ],
      "max_companies": 1,
      "max_users": 2,
      "storage_gb": 5
    }
  ]
}
```

---

#### Get Current Subscription

**Endpoint**: `GET /subscriptions/current`

**Headers**: `Authorization: Bearer {token}`

**Response** (200):
```json
{
  "success": true,
  "data": {
    "id": 1,
    "package": {
      "id": 2,
      "name": "Professional",
      "price": 79.99
    },
    "status": "active",
    "current_period_start": "2026-01-01T00:00:00Z",
    "current_period_end": "2026-02-01T00:00:00Z",
    "cancel_at_period_end": false,
    "created_at": "2025-12-01T10:00:00Z"
  }
}
```

---

#### Subscribe to Package

**Endpoint**: `POST /subscriptions/subscribe`

**Headers**: `Authorization: Bearer {token}`

**Request Body**:
```json
{
  "package_id": 2,
  "payment_method_id": "pm_1234567890"
}
```

**Response** (201):
```json
{
  "success": true,
  "data": { /* subscription */ },
  "message": "Subscription created successfully"
}
```

---

#### Cancel Subscription

**Endpoint**: `POST /subscriptions/cancel`

**Headers**: `Authorization: Bearer {token}`

**Request Body**:
```json
{
  "immediate": false
}
```

**Response** (200):
```json
{
  "success": true,
  "message": "Subscription will be cancelled at the end of the billing period"
}
```

---

### Payments

#### Get Payment History

**Endpoint**: `GET /payments`

**Headers**: `Authorization: Bearer {token}`

**Response** (200):
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "amount": 79.99,
      "currency": "GBP",
      "payment_method": "stripe",
      "status": "completed",
      "payment_date": "2026-01-01T10:00:00Z",
      "invoice_url": "https://invoices.omc.com/invoice_1.pdf",
      "description": "Professional Plan - Monthly"
    }
  ],
  "meta": { /* pagination */ }
}
```

---

### Admin Endpoints

#### Get All Clients (Admin Only)

**Endpoint**: `GET /admin/clients`

**Headers**: `Authorization: Bearer {token}`

**Permissions**: admin, super_admin

**Response** (200):
```json
{
  "success": true,
  "data": [
    {
      "id": 10,
      "name": "John Smith",
      "email": "john@example.com",
      "subscription": "Professional",
      "companies_count": 2,
      "last_activity": "2026-01-15T14:30:00Z",
      "created_at": "2025-10-01T10:00:00Z"
    }
  ],
  "meta": { /* pagination */ }
}
```

---

#### Get Admin Dashboard Stats

**Endpoint**: `GET /admin/dashboard`

**Headers**: `Authorization: Bearer {token}`

**Permissions**: admin, super_admin

**Response** (200):
```json
{
  "success": true,
  "data": {
    "total_clients": 45,
    "active_tasks": 12,
    "pending_approvals": 5,
    "unread_messages": 8,
    "revenue_this_month": 3599.55,
    "recent_activity": [ /* activity logs */ ]
  }
}
```

---

### Super Admin Endpoints

#### Get All Users

**Endpoint**: `GET /superadmin/users`

**Headers**: `Authorization: Bearer {token}`

**Permissions**: super_admin

**Query Parameters**:
- `role`: Filter by role (client, admin, super_admin)

**Response** (200):
```json
{
  "success": true,
  "data": [ /* users */ ],
  "meta": { /* pagination */ }
}
```

---

#### Create Admin User

**Endpoint**: `POST /superadmin/admins`

**Headers**: `Authorization: Bearer {token}`

**Permissions**: super_admin

**Request Body**:
```json
{
  "email": "newadmin@omc.com",
  "password": "SecurePass123!",
  "first_name": "Jane",
  "last_name": "Doe",
  "phone": "+447123456789"
}
```

**Response** (201):
```json
{
  "success": true,
  "data": { /* created admin */ },
  "message": "Admin user created successfully"
}
```

---

## Rate Limiting

- **Limit**: 100 requests per 15 minutes per IP
- **Header**: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`

**Response when rate limited** (429):
```json
{
  "success": false,
  "error": "Too many requests. Please try again later.",
  "retry_after": 300
}
```

---

## Webhooks

### Stripe Webhook

**Endpoint**: `POST /webhooks/stripe`

**Events handled**:
- `payment_intent.succeeded`
- `payment_intent.payment_failed`
- `customer.subscription.created`
- `customer.subscription.updated`
- `customer.subscription.deleted`

### WhatsApp Webhook

**Endpoint**: `POST /webhooks/whatsapp`

**Events handled**:
- Incoming messages
- Message status updates

### Facebook Messenger Webhook

**Endpoint**: `POST /webhooks/facebook`

**Events handled**:
- messages
- messaging_postbacks

---

**Document Version**: 1.0  
**Last Updated**: December 24, 2025  
**Status**: Complete API Documentation
