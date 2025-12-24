# OMC System - Frontend Architecture Guide

## Table of Contents

1. [Technology Stack](#technology-stack)
2. [Project Structure](#project-structure)
3. [State Management](#state-management)
4. [Routing](#routing)
5. [Component Library](#component-library)
6. [API Integration](#api-integration)
7. [Authentication Flow](#authentication-flow)
8. [Key Components](#key-components)
9. [Styling Guidelines](#styling-guidelines)
10. [Performance Optimization](#performance-optimization)

---

## Technology Stack

### Core Framework
- **Next.js 14+** with App Router
- **React 18+**
- **TypeScript** for type safety

### UI & Styling
- **Tailwind CSS** for utility-first styling
- **Shadcn/ui** for accessible component primitives
- **Lucide React** for icons
- **Recharts** for data visualization

### State Management
- **Zustand** for global state
- **React Query (TanStack Query)** for server state
- **React Hook Form** for form state

### API & Data
- **Axios** for HTTP requests
- **Socket.io Client** for real-time features
- **React Query** for caching and synchronization

### Authentication
- **NextAuth.js** for authentication
- **JWT** token management
- **Google OAuth** integration

### Payments
- **Stripe.js** and **Stripe React Elements**

### Utilities
- **date-fns** for date manipulation
- **zod** for validation schemas
- **react-hot-toast** for notifications
- **react-dropzone** for file uploads

---

## Project Structure

```
frontend/
├── public/
│   ├── images/
│   ├── icons/
│   └── favicon.ico
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── (auth)/            # Auth layout group
│   │   │   ├── login/
│   │   │   ├── register/
│   │   │   └── reset-password/
│   │   ├── (dashboard)/       # Dashboard layout group
│   │   │   ├── layout.tsx
│   │   │   ├── page.tsx       # Main dashboard
│   │   │   ├── companies/
│   │   │   ├── vat/
│   │   │   ├── bookkeeping/
│   │   │   ├── social-media/
│   │   │   ├── messages/
│   │   │   ├── subscription/
│   │   │   └── settings/
│   │   ├── (admin)/           # Admin layout group
│   │   │   ├── layout.tsx
│   │   │   ├── dashboard/
│   │   │   ├── clients/
│   │   │   ├── inbox/
│   │   │   └── tasks/
│   │   ├── (superadmin)/      # Super admin layout
│   │   │   ├── layout.tsx
│   │   │   ├── dashboard/
│   │   │   ├── users/
│   │   │   ├── admins/
│   │   │   ├── subscriptions/
│   │   │   └── settings/
│   │   ├── api/               # API routes (if needed)
│   │   ├── layout.tsx         # Root layout
│   │   └── page.tsx           # Landing page
│   ├── components/
│   │   ├── ui/               # Shadcn components
│   │   │   ├── button.tsx
│   │   │   ├── input.tsx
│   │   │   ├── dialog.tsx
│   │   │   └── ...
│   │   ├── layout/           # Layout components
│   │   │   ├── Header.tsx
│   │   │   ├── Sidebar.tsx
│   │   │   ├── Footer.tsx
│   │   │   └── DashboardLayout.tsx
│   │   ├── auth/             # Auth components
│   │   │   ├── LoginForm.tsx
│   │   │   ├── RegisterForm.tsx
│   │   │   └── GoogleAuthButton.tsx
│   │   ├── companies/        # Company components
│   │   │   ├── CompanyCard.tsx
│   │   │   ├── CompanyFormWizard.tsx
│   │   │   └── CompanyList.tsx
│   │   ├── dashboard/        # Dashboard widgets
│   │   │   ├── WelcomeBanner.tsx
│   │   │   ├── StatsCard.tsx
│   │   │   └── RecentActivity.tsx
│   │   ├── bookkeeping/      # Bookkeeping components
│   │   │   ├── TransactionForm.tsx
│   │   │   ├── InvoiceBuilder.tsx
│   │   │   └── ReportViewer.tsx
│   │   ├── messaging/        # Messaging components
│   │   │   ├── ConversationList.tsx
│   │   │   ├── MessageThread.tsx
│   │   │   └── MessageInput.tsx
│   │   └── common/           # Shared components
│   │       ├── DataTable.tsx
│   │       ├── FileUpload.tsx
│   │       ├── DatePicker.tsx
│   │       └── LoadingSpinner.tsx
│   ├── lib/
│   │   ├── api/              # API client
│   │   │   ├── axios.ts
│   │   │   ├── auth.ts
│   │   │   ├── companies.ts
│   │   │   ├── bookkeeping.ts
│   │   │   └── ...
│   │   ├── hooks/            # Custom hooks
│   │   │   ├── useAuth.ts
│   │   │   ├── useCompanies.ts
│   │   │   ├── useMessages.ts
│   │   │   └── ...
│   │   ├── store/            # Zustand stores
│   │   │   ├── authStore.ts
│   │   │   ├── uiStore.ts
│   │   │   └── messageStore.ts
│   │   ├── utils/            # Utility functions
│   │   │   ├── format.ts
│   │   │   ├── validation.ts
│   │   │   └── helpers.ts
│   │   └── constants/        # Constants
│   │       ├── routes.ts
│   │       ├── api-endpoints.ts
│   │       └── config.ts
│   ├── types/
│   │   ├── user.ts
│   │   ├── company.ts
│   │   ├── transaction.ts
│   │   └── ...
│   └── styles/
│       └── globals.css
├── .env.local
├── next.config.js
├── tailwind.config.js
├── tsconfig.json
└── package.json
```

---

## State Management

### 1. Zustand for Global State

**Auth Store** (`src/lib/store/authStore.ts`):
```typescript
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface User {
  id: number;
  email: string;
  first_name: string;
  last_name: string;
  role: 'super_admin' | 'admin' | 'client';
}

interface AuthState {
  user: User | null;
  accessToken: string | null;
  refreshToken: string | null;
  isAuthenticated: boolean;
  login: (user: User, accessToken: string, refreshToken: string) => void;
  logout: () => void;
  updateUser: (user: Partial<User>) => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      accessToken: null,
      refreshToken: null,
      isAuthenticated: false,
      login: (user, accessToken, refreshToken) =>
        set({ user, accessToken, refreshToken, isAuthenticated: true }),
      logout: () =>
        set({ user: null, accessToken: null, refreshToken: null, isAuthenticated: false }),
      updateUser: (userData) =>
        set((state) => ({
          user: state.user ? { ...state.user, ...userData } : null,
        })),
    }),
    {
      name: 'auth-storage',
    }
  )
);
```

**UI Store** (`src/lib/store/uiStore.ts`):
```typescript
import { create } from 'zustand';

interface UIState {
  sidebarOpen: boolean;
  theme: 'light' | 'dark';
  toggleSidebar: () => void;
  setTheme: (theme: 'light' | 'dark') => void;
}

export const useUIStore = create<UIState>((set) => ({
  sidebarOpen: true,
  theme: 'light',
  toggleSidebar: () => set((state) => ({ sidebarOpen: !state.sidebarOpen })),
  setTheme: (theme) => set({ theme }),
}));
```

### 2. React Query for Server State

**Query Client Setup** (`src/lib/api/queryClient.ts`):
```typescript
import { QueryClient } from '@tanstack/react-query';

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 60 * 1000, // 1 minute
      cacheTime: 5 * 60 * 1000, // 5 minutes
      refetchOnWindowFocus: false,
      retry: 1,
    },
  },
});
```

**Custom Hook Example** (`src/lib/hooks/useCompanies.ts`):
```typescript
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { companiesApi } from '../api/companies';

export function useCompanies() {
  return useQuery({
    queryKey: ['companies'],
    queryFn: companiesApi.getAll,
  });
}

export function useCompany(id: number) {
  return useQuery({
    queryKey: ['companies', id],
    queryFn: () => companiesApi.getById(id),
    enabled: !!id,
  });
}

export function useCreateCompany() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: companiesApi.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['companies'] });
    },
  });
}
```

---

## Routing

### Route Groups and Layouts

**Dashboard Layout** (`src/app/(dashboard)/layout.tsx`):
```typescript
'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useAuthStore } from '@/lib/store/authStore';
import Header from '@/components/layout/Header';
import Sidebar from '@/components/layout/Sidebar';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const router = useRouter();
  const { isAuthenticated, user } = useAuthStore();

  useEffect(() => {
    if (!isAuthenticated) {
      router.push('/login');
    }
  }, [isAuthenticated, router]);

  if (!isAuthenticated) {
    return null; // or loading spinner
  }

  return (
    <div className="flex h-screen bg-gray-50">
      <Sidebar />
      <div className="flex-1 flex flex-col overflow-hidden">
        <Header />
        <main className="flex-1 overflow-y-auto p-6">
          {children}
        </main>
      </div>
    </div>
  );
}
```

**Protected Route Higher-Order Component**:
```typescript
// src/components/auth/ProtectedRoute.tsx
'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useAuthStore } from '@/lib/store/authStore';

interface ProtectedRouteProps {
  children: React.ReactNode;
  allowedRoles?: string[];
}

export default function ProtectedRoute({
  children,
  allowedRoles,
}: ProtectedRouteProps) {
  const router = useRouter();
  const { isAuthenticated, user } = useAuthStore();

  useEffect(() => {
    if (!isAuthenticated) {
      router.push('/login');
      return;
    }

    if (allowedRoles && user && !allowedRoles.includes(user.role)) {
      router.push('/dashboard');
    }
  }, [isAuthenticated, user, allowedRoles, router]);

  if (!isAuthenticated || (allowedRoles && user && !allowedRoles.includes(user.role))) {
    return null;
  }

  return <>{children}</>;
}
```

---

## Component Library

### Using Shadcn/ui

**Installation**:
```bash
npx shadcn-ui@latest init
npx shadcn-ui@latest add button
npx shadcn-ui@latest add input
npx shadcn-ui@latest add dialog
npx shadcn-ui@latest add dropdown-menu
npx shadcn-ui@latest add table
npx shadcn-ui@latest add form
```

**Example Component** (`src/components/companies/CompanyCard.tsx`):
```typescript
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Building2, Calendar, FileText } from 'lucide-react';
import { Company } from '@/types/company';

interface CompanyCardProps {
  company: Company;
  onView: (id: number) => void;
}

export default function CompanyCard({ company, onView }: CompanyCardProps) {
  const statusColor = {
    pending: 'bg-yellow-100 text-yellow-800',
    in_progress: 'bg-blue-100 text-blue-800',
    completed: 'bg-green-100 text-green-800',
    rejected: 'bg-red-100 text-red-800',
  }[company.status];

  return (
    <Card className="hover:shadow-lg transition-shadow">
      <CardHeader>
        <div className="flex items-start justify-between">
          <div className="flex items-center gap-2">
            <Building2 className="h-5 w-5 text-blue-600" />
            <CardTitle className="text-lg">{company.company_name}</CardTitle>
          </div>
          <Badge className={statusColor}>
            {company.status.replace('_', ' ')}
          </Badge>
        </div>
      </CardHeader>
      <CardContent>
        <div className="space-y-2 text-sm text-gray-600">
          {company.company_number && (
            <div className="flex items-center gap-2">
              <FileText className="h-4 w-4" />
              <span>#{company.company_number}</span>
            </div>
          )}
          <div className="flex items-center gap-2">
            <Calendar className="h-4 w-4" />
            <span>Registered: {new Date(company.created_at).toLocaleDateString()}</span>
          </div>
        </div>
        <Button 
          className="w-full mt-4" 
          variant="outline"
          onClick={() => onView(company.id)}
        >
          View Details
        </Button>
      </CardContent>
    </Card>
  );
}
```

---

## API Integration

### Axios Setup

**Axios Instance** (`src/lib/api/axios.ts`):
```typescript
import axios from 'axios';
import { useAuthStore } from '../store/authStore';

const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5000/api/v1',
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor
api.interceptors.request.use(
  (config) => {
    const { accessToken } = useAuthStore.getState();
    if (accessToken) {
      config.headers.Authorization = `Bearer ${accessToken}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;

    // If 401 and haven't retried yet
    if (error.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;

      try {
        // Attempt to refresh token
        const { refreshToken } = useAuthStore.getState();
        const response = await axios.post(
          `${process.env.NEXT_PUBLIC_API_URL}/auth/refresh`,
          { refresh_token: refreshToken }
        );

        const { access_token } = response.data;
        useAuthStore.getState().login(
          useAuthStore.getState().user!,
          access_token,
          refreshToken!
        );

        originalRequest.headers.Authorization = `Bearer ${access_token}`;
        return api(originalRequest);
      } catch (refreshError) {
        // Refresh failed, logout user
        useAuthStore.getState().logout();
        window.location.href = '/login';
        return Promise.reject(refreshError);
      }
    }

    return Promise.reject(error);
  }
);

export default api;
```

**API Module Example** (`src/lib/api/companies.ts`):
```typescript
import api from './axios';
import { Company, CreateCompanyDTO } from '@/types/company';

export const companiesApi = {
  getAll: async (): Promise<Company[]> => {
    const response = await api.get('/companies');
    return response.data.data;
  },

  getById: async (id: number): Promise<Company> => {
    const response = await api.get(`/companies/${id}`);
    return response.data.data;
  },

  create: async (data: CreateCompanyDTO): Promise<Company> => {
    const response = await api.post('/companies', data);
    return response.data.data;
  },

  update: async (id: number, data: Partial<CreateCompanyDTO>): Promise<Company> => {
    const response = await api.put(`/companies/${id}`, data);
    return response.data.data;
  },

  delete: async (id: number): Promise<void> => {
    await api.delete(`/companies/${id}`);
  },

  uploadDocument: async (id: number, file: File): Promise<void> => {
    const formData = new FormData();
    formData.append('file', file);
    await api.post(`/companies/${id}/documents`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
  },
};
```

---

## Authentication Flow

### Login Page

**Login Component** (`src/app/(auth)/login/page.tsx`):
```typescript
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useAuthStore } from '@/lib/store/authStore';
import { authApi } from '@/lib/api/auth';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { useForm } from 'react-hook-form';
import { toast } from 'react-hot-toast';
import GoogleAuthButton from '@/components/auth/GoogleAuthButton';

interface LoginForm {
  email: string;
  password: string;
}

export default function LoginPage() {
  const router = useRouter();
  const login = useAuthStore((state) => state.login);
  const [loading, setLoading] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<LoginForm>();

  const onSubmit = async (data: LoginForm) => {
    setLoading(true);
    try {
      const response = await authApi.login(data.email, data.password);
      login(response.user, response.access_token, response.refresh_token);
      toast.success('Login successful!');
      
      // Redirect based on role
      if (response.user.role === 'super_admin') {
        router.push('/superadmin/dashboard');
      } else if (response.user.role === 'admin') {
        router.push('/admin/dashboard');
      } else {
        router.push('/dashboard');
      }
    } catch (error: any) {
      toast.error(error.response?.data?.message || 'Login failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-gray-50">
      <div className="w-full max-w-md space-y-8 rounded-lg bg-white p-8 shadow-lg">
        <div className="text-center">
          <h2 className="text-3xl font-bold">Welcome to OMC</h2>
          <p className="mt-2 text-gray-600">Sign in to your account</p>
        </div>

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
          <div>
            <Label htmlFor="email">Email</Label>
            <Input
              id="email"
              type="email"
              {...register('email', { required: 'Email is required' })}
              placeholder="you@example.com"
            />
            {errors.email && (
              <p className="mt-1 text-sm text-red-600">{errors.email.message}</p>
            )}
          </div>

          <div>
            <Label htmlFor="password">Password</Label>
            <Input
              id="password"
              type="password"
              {...register('password', { required: 'Password is required' })}
              placeholder="••••••••"
            />
            {errors.password && (
              <p className="mt-1 text-sm text-red-600">{errors.password.message}</p>
            )}
          </div>

          <Button type="submit" className="w-full" disabled={loading}>
            {loading ? 'Signing in...' : 'Sign In'}
          </Button>
        </form>

        <div className="relative">
          <div className="absolute inset-0 flex items-center">
            <div className="w-full border-t border-gray-300" />
          </div>
          <div className="relative flex justify-center text-sm">
            <span className="bg-white px-2 text-gray-500">Or continue with</span>
          </div>
        </div>

        <GoogleAuthButton />

        <div className="text-center text-sm">
          <a href="/forgot-password" className="text-blue-600 hover:underline">
            Forgot password?
          </a>
          <span className="mx-2 text-gray-400">|</span>
          <a href="/register" className="text-blue-600 hover:underline">
            Create account
          </a>
        </div>
      </div>
    </div>
  );
}
```

---

## Key Components

### Data Table Component

**Reusable Data Table** (`src/components/common/DataTable.tsx`):
```typescript
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Button } from '@/components/ui/button';
import { ChevronLeft, ChevronRight } from 'lucide-react';

interface Column<T> {
  key: string;
  header: string;
  render?: (item: T) => React.ReactNode;
}

interface DataTableProps<T> {
  data: T[];
  columns: Column<T>[];
  currentPage: number;
  totalPages: number;
  onPageChange: (page: number) => void;
  loading?: boolean;
}

export default function DataTable<T extends { id: number }>({
  data,
  columns,
  currentPage,
  totalPages,
  onPageChange,
  loading,
}: DataTableProps<T>) {
  if (loading) {
    return <div className="text-center py-8">Loading...</div>;
  }

  return (
    <div className="space-y-4">
      <div className="rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              {columns.map((column) => (
                <TableHead key={column.key}>{column.header}</TableHead>
              ))}
            </TableRow>
          </TableHeader>
          <TableBody>
            {data.length === 0 ? (
              <TableRow>
                <TableCell colSpan={columns.length} className="text-center py-8">
                  No data available
                </TableCell>
              </TableRow>
            ) : (
              data.map((item) => (
                <TableRow key={item.id}>
                  {columns.map((column) => (
                    <TableCell key={column.key}>
                      {column.render
                        ? column.render(item)
                        : String(item[column.key as keyof T])}
                    </TableCell>
                  ))}
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>

      {totalPages > 1 && (
        <div className="flex items-center justify-between">
          <p className="text-sm text-gray-600">
            Page {currentPage} of {totalPages}
          </p>
          <div className="flex gap-2">
            <Button
              variant="outline"
              size="sm"
              onClick={() => onPageChange(currentPage - 1)}
              disabled={currentPage === 1}
            >
              <ChevronLeft className="h-4 w-4" />
              Previous
            </Button>
            <Button
              variant="outline"
              size="sm"
              onClick={() => onPageChange(currentPage + 1)}
              disabled={currentPage === totalPages}
            >
              Next
              <ChevronRight className="h-4 w-4" />
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}
```

---

## Styling Guidelines

### Tailwind Configuration

**tailwind.config.js**:
```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ['class'],
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        // ... more colors
      },
      borderRadius: {
        lg: 'var(--radius)',
        md: 'calc(var(--radius) - 2px)',
        sm: 'calc(var(--radius) - 4px)',
      },
    },
  },
  plugins: [require('tailwindcss-animate')],
};
```

### Design Tokens

Use consistent spacing, colors, and typography:
- **Spacing**: Use Tailwind's spacing scale (4px increments)
- **Colors**: Use the defined color palette
- **Typography**: Use defined text sizes (text-sm, text-base, text-lg, etc.)
- **Shadows**: Use shadow utilities consistently

---

## Performance Optimization

### 1. Code Splitting
```typescript
// Dynamic imports for heavy components
import dynamic from 'next/dynamic';

const ChartComponent = dynamic(() => import('@/components/charts/LineChart'), {
  loading: () => <p>Loading chart...</p>,
  ssr: false,
});
```

### 2. Image Optimization
```typescript
import Image from 'next/image';

<Image
  src="/company-logo.png"
  alt="Company Logo"
  width={200}
  height={50}
  priority={true} // For above-the-fold images
/>
```

### 3. Memoization
```typescript
import { useMemo, useCallback } from 'react';

const ExpensiveComponent = ({ data }) => {
  const processedData = useMemo(() => {
    return data.map(item => /* expensive operation */);
  }, [data]);

  const handleClick = useCallback(() => {
    // Handler logic
  }, [/* dependencies */]);

  return <div>{/* render */}</div>;
};
```

### 4. React Query Optimization
```typescript
// Prefetch data
queryClient.prefetchQuery({
  queryKey: ['companies'],
  queryFn: companiesApi.getAll,
});

// Optimistic updates
const mutation = useMutation({
  mutationFn: updateCompany,
  onMutate: async (newCompany) => {
    await queryClient.cancelQueries({ queryKey: ['companies', newCompany.id] });
    const previousCompany = queryClient.getQueryData(['companies', newCompany.id]);
    queryClient.setQueryData(['companies', newCompany.id], newCompany);
    return { previousCompany };
  },
  onError: (err, newCompany, context) => {
    queryClient.setQueryData(
      ['companies', newCompany.id],
      context?.previousCompany
    );
  },
  onSettled: (newCompany) => {
    queryClient.invalidateQueries({ queryKey: ['companies', newCompany?.id] });
  },
});
```

---

**Document Version**: 1.0  
**Last Updated**: December 24, 2025  
**Status**: Complete Frontend Architecture Guide
