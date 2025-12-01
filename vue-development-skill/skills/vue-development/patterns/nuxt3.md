# Nuxt 3 Patterns

This guide covers Nuxt 3-specific patterns and best practices.

## Auto-Imports

Nuxt 3 auto-imports Vue APIs, composables, and utilities. **Do not manually import these:**

```typescript
// No need to import these - they're auto-imported
const route = useRoute()
const router = useRouter()
const config = useRuntimeConfig()
const count = ref(0)
const doubled = computed(() => count.value * 2)
```

### What's Auto-Imported

- **Vue**: `ref`, `reactive`, `computed`, `watch`, `onMounted`, etc.
- **Nuxt**: `useRoute`, `useRouter`, `useFetch`, `useAsyncData`, `useState`, etc.
- **Your composables**: Files in `composables/` directory
- **Your utilities**: Files in `utils/` directory

---

## Data Fetching

### useFetch - Simple API Calls

```typescript
// Basic usage
const { data, pending, error, refresh } = await useFetch('/api/users')

// With TypeScript
interface User {
  id: number
  name: string
  email: string
}

const { data: users } = await useFetch<User[]>('/api/users')

// With options
const { data } = await useFetch('/api/users', {
  method: 'POST',
  body: { name: 'John' },
  headers: {
    'Authorization': `Bearer ${token}`
  }
})
```

### useFetch with Query Parameters

```typescript
const page = ref(1)
const search = ref('')

const { data: users, refresh } = await useFetch('/api/users', {
  query: {
    page,
    search,
    limit: 10
  },
  watch: [page, search]  // Auto-refetch when these change
})
```

### useAsyncData - Custom Async Operations

```typescript
// When you need more control
const { data, pending, error } = await useAsyncData(
  'unique-key',
  () => $fetch('/api/users')
)

// With transform
const { data: userNames } = await useAsyncData(
  'user-names',
  () => $fetch<User[]>('/api/users'),
  {
    transform: (users) => users.map(u => u.name)
  }
)
```

### Handling Fetch Errors

```typescript
const { data, error } = await useFetch('/api/users')

// In template
<template>
  <div v-if="error">
    <p class="error">{{ error.message }}</p>
    <button @click="refresh">Retry</button>
  </div>
  <div v-else-if="pending">Loading...</div>
  <div v-else>
    <UserList :users="data" />
  </div>
</template>
```

### Lazy Fetching

```typescript
// Don't block navigation - fetch in background
const { data, pending } = useLazyFetch('/api/users')

// Or with useAsyncData
const { data } = useLazyAsyncData('key', () => fetchData())
```

---

## State Management

### useState - Shared State

```typescript
// composables/useUser.ts
export const useCurrentUser = () => useState<User | null>('user', () => null)

// In any component
const user = useCurrentUser()
user.value = { id: 1, name: 'John' }  // Shared across components
```

### Pinia with Nuxt

```typescript
// stores/user.ts
export const useUserStore = defineStore('user', () => {
  const user = ref<User | null>(null)
  const isLoggedIn = computed(() => user.value !== null)

  async function login(credentials: Credentials) {
    user.value = await $fetch('/api/login', {
      method: 'POST',
      body: credentials
    })
  }

  function logout() {
    user.value = null
    navigateTo('/login')
  }

  return {
    user,
    isLoggedIn,
    login,
    logout
  }
})
```

---

## Pages & Routing

### Page Meta

```vue
<script setup lang="ts">
definePageMeta({
  layout: 'admin',
  middleware: ['auth'],
  title: 'Dashboard'
})
</script>
```

### Dynamic Routes

```
pages/
├── users/
│   ├── index.vue        # /users
│   ├── [id].vue         # /users/123
│   └── [id]/
│       └── edit.vue     # /users/123/edit
```

```vue
<!-- pages/users/[id].vue -->
<script setup lang="ts">
const route = useRoute()
const userId = computed(() => Number(route.params.id))

const { data: user } = await useFetch(`/api/users/${userId.value}`)
</script>
```

### Navigation

```typescript
// Programmatic navigation
const router = useRouter()
router.push('/users')
router.push({ name: 'users-id', params: { id: 123 } })

// Or use navigateTo
navigateTo('/users')
navigateTo({ path: '/users', query: { page: 1 } })
```

---

## Middleware

### Route Middleware

```typescript
// middleware/auth.ts
export default defineNuxtRouteMiddleware((to, from) => {
  const user = useCurrentUser()

  if (!user.value) {
    return navigateTo('/login')
  }
})

// middleware/admin.ts
export default defineNuxtRouteMiddleware((to) => {
  const user = useCurrentUser()

  if (user.value?.role !== 'admin') {
    return abortNavigation()
  }
})
```

### Global Middleware

```typescript
// middleware/analytics.global.ts
export default defineNuxtRouteMiddleware((to) => {
  // Runs on every route change
  trackPageView(to.path)
})
```

---

## SEO & Meta

### useSeoMeta

```typescript
useSeoMeta({
  title: 'My Page Title',
  description: 'Page description for SEO',
  ogTitle: 'My Page Title',
  ogDescription: 'Page description for social sharing',
  ogImage: 'https://example.com/image.png',
  twitterCard: 'summary_large_image'
})
```

### Dynamic Meta

```typescript
const { data: article } = await useFetch('/api/articles/1')

useSeoMeta({
  title: () => article.value?.title ?? 'Loading...',
  description: () => article.value?.excerpt ?? ''
})
```

### useHead

```typescript
useHead({
  title: 'My Page',
  meta: [
    { name: 'description', content: 'Page description' }
  ],
  link: [
    { rel: 'canonical', href: 'https://example.com/page' }
  ],
  script: [
    { src: 'https://example.com/script.js', defer: true }
  ]
})
```

---

## Server Routes (API)

### Basic API Route

```typescript
// server/api/users.ts
export default defineEventHandler(async (event) => {
  const users = await db.users.findMany()
  return users
})
```

### With Parameters

```typescript
// server/api/users/[id].ts
export default defineEventHandler(async (event) => {
  const id = getRouterParam(event, 'id')
  const user = await db.users.findUnique({ where: { id: Number(id) } })

  if (!user) {
    throw createError({
      statusCode: 404,
      message: 'User not found'
    })
  }

  return user
})
```

### POST/PUT/DELETE

```typescript
// server/api/users.post.ts
export default defineEventHandler(async (event) => {
  const body = await readBody(event)

  const user = await db.users.create({
    data: body
  })

  return user
})

// server/api/users/[id].delete.ts
export default defineEventHandler(async (event) => {
  const id = getRouterParam(event, 'id')
  await db.users.delete({ where: { id: Number(id) } })
  return { success: true }
})
```

---

## Error Handling

### Error Page

```vue
<!-- error.vue -->
<script setup lang="ts">
const props = defineProps<{
  error: {
    statusCode: number
    message: string
  }
}>()

const handleError = () => clearError({ redirect: '/' })
</script>

<template>
  <div class="error-page">
    <h1>{{ error.statusCode }}</h1>
    <p>{{ error.message }}</p>
    <button @click="handleError">Go Home</button>
  </div>
</template>
```

### Throwing Errors

```typescript
// In API routes
throw createError({
  statusCode: 400,
  message: 'Invalid request'
})

// In pages/components
showError({
  statusCode: 404,
  message: 'Page not found'
})
```

---

## Layouts

### Default Layout

```vue
<!-- layouts/default.vue -->
<template>
  <div>
    <AppHeader />
    <main>
      <slot />
    </main>
    <AppFooter />
  </div>
</template>
```

### Custom Layouts

```vue
<!-- layouts/admin.vue -->
<template>
  <div class="admin-layout">
    <AdminSidebar />
    <div class="admin-content">
      <slot />
    </div>
  </div>
</template>

<!-- pages/admin/dashboard.vue -->
<script setup>
definePageMeta({
  layout: 'admin'
})
</script>
```

---

## Runtime Config

### nuxt.config.ts

```typescript
export default defineNuxtConfig({
  runtimeConfig: {
    // Private keys (server-only)
    apiSecret: process.env.API_SECRET,

    // Public keys (exposed to client)
    public: {
      apiBase: process.env.API_BASE || 'https://api.example.com'
    }
  }
})
```

### Using Config

```typescript
// In composables, pages, components
const config = useRuntimeConfig()
const apiBase = config.public.apiBase

// In server routes
export default defineEventHandler((event) => {
  const config = useRuntimeConfig()
  const secret = config.apiSecret  // Server-only
})
```

---

## Plugins

### Client-Only Plugin

```typescript
// plugins/analytics.client.ts
export default defineNuxtPlugin(() => {
  // Only runs on client
  initAnalytics()
})
```

### Server-Only Plugin

```typescript
// plugins/db.server.ts
export default defineNuxtPlugin(() => {
  // Only runs on server
  initDatabase()
})
```

### Providing Helpers

```typescript
// plugins/api.ts
export default defineNuxtPlugin(() => {
  const api = {
    get: (url: string) => $fetch(url),
    post: (url: string, body: unknown) => $fetch(url, { method: 'POST', body })
  }

  return {
    provide: {
      api
    }
  }
})

// Usage
const { $api } = useNuxtApp()
await $api.get('/users')
```
