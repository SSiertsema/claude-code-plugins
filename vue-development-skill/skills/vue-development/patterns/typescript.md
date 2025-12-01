# TypeScript Patterns for Vue

This guide covers TypeScript best practices specifically for Vue 3 and Nuxt 3 development.

## Type-Safe Props

### Basic Props

```typescript
interface Props {
  // Required
  title: string

  // Optional
  subtitle?: string

  // With specific values
  variant: 'primary' | 'secondary' | 'danger'

  // Complex types
  user: User

  // Arrays
  items: Item[]

  // Functions
  onSelect?: (item: Item) => void
}

const props = withDefaults(defineProps<Props>(), {
  subtitle: '',
  variant: 'primary',
  items: () => []
})
```

### Generic Props

```typescript
// Generic component for lists
interface Props<T> {
  items: T[]
  keyField: keyof T
}

const props = defineProps<Props<Item>>()
```

---

## Type-Safe Emits

### Simple Events

```typescript
const emit = defineEmits<{
  // No payload
  close: []

  // Single payload
  select: [item: Item]

  // Multiple payloads
  update: [field: string, value: unknown]
}>()

// Usage
emit('close')
emit('select', selectedItem)
emit('update', 'name', 'John')
```

### v-model Events

```typescript
const props = defineProps<{
  modelValue: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

// In template or script
emit('update:modelValue', newValue)
```

---

## Type-Safe Composables

### Return Type

```typescript
interface UseCounterReturn {
  count: Readonly<Ref<number>>
  increment: () => void
  decrement: () => void
  reset: () => void
}

export function useCounter(initial = 0): UseCounterReturn {
  const count = ref(initial)

  return {
    count: readonly(count),
    increment: () => count.value++,
    decrement: () => count.value--,
    reset: () => count.value = initial
  }
}
```

### Generic Composables

```typescript
interface UseFetchReturn<T> {
  data: Ref<T | null>
  loading: Ref<boolean>
  error: Ref<Error | null>
  refetch: () => Promise<void>
}

export function useFetchData<T>(url: string): UseFetchReturn<T> {
  const data = ref<T | null>(null) as Ref<T | null>
  const loading = ref(false)
  const error = ref<Error | null>(null)

  async function refetch() {
    loading.value = true
    error.value = null
    try {
      data.value = await $fetch<T>(url)
    } catch (e) {
      error.value = e as Error
    } finally {
      loading.value = false
    }
  }

  refetch()

  return { data, loading, error, refetch }
}
```

### MaybeRef Pattern

```typescript
import { unref, type MaybeRef } from 'vue'

export function useUser(userId: MaybeRef<number>) {
  // Works with both ref and plain value
  const id = computed(() => unref(userId))

  // ...
}

// Usage
useUser(123)           // Plain number
useUser(ref(123))      // Ref<number>
useUser(userId)        // Can be either
```

---

## Type-Safe Refs

### Template Refs

```typescript
// Single element
const inputRef = ref<HTMLInputElement | null>(null)

// Component ref
const modalRef = ref<InstanceType<typeof Modal> | null>(null)

// Access after mount
onMounted(() => {
  inputRef.value?.focus()
  modalRef.value?.open()
})
```

### Typed Reactive

```typescript
interface FormState {
  username: string
  email: string
  age: number
}

const form = reactive<FormState>({
  username: '',
  email: '',
  age: 0
})
```

---

## Type-Safe API Calls

### Response Types

```typescript
interface User {
  id: number
  name: string
  email: string
}

interface ApiResponse<T> {
  data: T
  meta: {
    total: number
    page: number
  }
}

// In Nuxt
const { data } = await useFetch<ApiResponse<User[]>>('/api/users')

// Type-safe access
const users = data.value?.data ?? []
const total = data.value?.meta.total ?? 0
```

### Error Types

```typescript
interface ApiError {
  statusCode: number
  message: string
  errors?: Record<string, string[]>
}

const { error } = await useFetch('/api/users')

if (error.value) {
  const apiError = error.value.data as ApiError
  console.log(apiError.message)
}
```

---

## Type-Safe Pinia Stores

```typescript
interface User {
  id: number
  name: string
  email: string
  role: 'user' | 'admin'
}

interface UserState {
  user: User | null
  loading: boolean
}

export const useUserStore = defineStore('user', () => {
  const user = ref<User | null>(null)
  const loading = ref(false)

  const isAdmin = computed(() => user.value?.role === 'admin')
  const isLoggedIn = computed(() => user.value !== null)

  async function login(email: string, password: string): Promise<boolean> {
    loading.value = true
    try {
      user.value = await $fetch<User>('/api/login', {
        method: 'POST',
        body: { email, password }
      })
      return true
    } catch {
      return false
    } finally {
      loading.value = false
    }
  }

  function logout(): void {
    user.value = null
  }

  return {
    user: readonly(user),
    loading: readonly(loading),
    isAdmin,
    isLoggedIn,
    login,
    logout
  }
})
```

---

## Type-Safe Provide/Inject

```typescript
import type { InjectionKey, Ref } from 'vue'

// Define typed key
interface ThemeContext {
  theme: Ref<'light' | 'dark'>
  toggle: () => void
}

export const ThemeKey: InjectionKey<ThemeContext> = Symbol('theme')

// Provider
const theme = ref<'light' | 'dark'>('light')
const toggle = () => {
  theme.value = theme.value === 'light' ? 'dark' : 'light'
}
provide(ThemeKey, { theme, toggle })

// Consumer
const themeContext = inject(ThemeKey)
if (themeContext) {
  themeContext.toggle()
}

// With default
const themeContext = inject(ThemeKey, {
  theme: ref('light'),
  toggle: () => {}
})
```

---

## Utility Types

### Common Patterns

```typescript
// Make all properties optional
type PartialUser = Partial<User>

// Make all properties required
type RequiredUser = Required<User>

// Pick specific properties
type UserCredentials = Pick<User, 'email' | 'password'>

// Omit specific properties
type PublicUser = Omit<User, 'password'>

// Extract function return type
type FetchResult = ReturnType<typeof useFetch>

// Extract component props
type ButtonProps = InstanceType<typeof Button>['$props']
```

### Mapped Types for Forms

```typescript
interface User {
  name: string
  email: string
  age: number
}

// Form errors: each field has string[] of errors
type FormErrors<T> = {
  [K in keyof T]?: string[]
}

const errors: FormErrors<User> = {
  email: ['Invalid email format'],
  age: ['Must be 18 or older']
}

// Form touched state
type FormTouched<T> = {
  [K in keyof T]?: boolean
}

const touched: FormTouched<User> = {
  email: true,
  name: false
}
```

---

## Type Guards

```typescript
interface User {
  type: 'user'
  name: string
}

interface Admin {
  type: 'admin'
  name: string
  permissions: string[]
}

type Person = User | Admin

// Type guard function
function isAdmin(person: Person): person is Admin {
  return person.type === 'admin'
}

// Usage
function getPermissions(person: Person): string[] {
  if (isAdmin(person)) {
    return person.permissions  // TypeScript knows it's Admin
  }
  return []
}
```

---

## Avoid These Anti-Patterns

### Never Use `any`

```typescript
// Bad
const data: any = await fetchData()

// Good
interface Data {
  items: Item[]
}
const data: Data = await fetchData()

// When truly unknown
const data: unknown = await fetchData()
if (isValidData(data)) {
  // Now typed
}
```

### Always Type Function Parameters

```typescript
// Bad
function processUser(user) {
  return user.name
}

// Good
function processUser(user: User): string {
  return user.name
}
```

### Type Event Handlers

```typescript
// Bad
function handleClick(e) {
  console.log(e.target.value)
}

// Good
function handleClick(e: MouseEvent) {
  const target = e.target as HTMLButtonElement
  console.log(target.value)
}

function handleInput(e: Event) {
  const target = e.target as HTMLInputElement
  console.log(target.value)
}
```

---

## Type Declaration Files

### Global Types

```typescript
// types/global.d.ts
declare global {
  interface User {
    id: number
    name: string
    email: string
  }

  interface ApiResponse<T> {
    data: T
    success: boolean
  }
}

export {}  // Make this a module
```

### Module Augmentation

```typescript
// types/vue-shim.d.ts
declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<{}, {}, any>
  export default component
}

// Augment Nuxt
declare module '#app' {
  interface NuxtApp {
    $api: {
      get: <T>(url: string) => Promise<T>
    }
  }
}
```
