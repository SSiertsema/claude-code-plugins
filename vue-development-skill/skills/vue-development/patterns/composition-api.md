# Vue 3 Composition API Patterns

This guide covers best practices and patterns for the Vue 3 Composition API with `<script setup>`.

## Basic Component Structure

### Standard Template

```vue
<script setup lang="ts">
// 1. Type imports
import type { User } from '@/types'

// 2. Component imports
import UserAvatar from './UserAvatar.vue'

// 3. Composable imports
import { useUser } from '@/composables/useUser'

// 4. Props definition
interface Props {
  userId: number
  showActions?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  showActions: true
})

// 5. Emits definition
const emit = defineEmits<{
  select: [user: User]
  delete: [userId: number]
}>()

// 6. Composables
const { user, loading, error } = useUser(props.userId)

// 7. Reactive state
const isEditing = ref(false)

// 8. Computed properties
const displayName = computed(() => user.value?.name ?? 'Unknown')

// 9. Methods
function handleSelect() {
  if (user.value) {
    emit('select', user.value)
  }
}

// 10. Lifecycle hooks
onMounted(() => {
  console.log('Component mounted')
})
</script>

<template>
  <div class="user-card">
    <!-- Template content -->
  </div>
</template>

<style scoped>
/* Scoped styles */
</style>
```

---

## Props Patterns

### Typed Props with Defaults

```typescript
interface Props {
  // Required prop
  title: string

  // Optional with type
  subtitle?: string

  // Union types
  variant: 'primary' | 'secondary' | 'danger'

  // Complex types
  items: Item[]

  // Optional with default handled by withDefaults
  disabled?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  subtitle: '',
  variant: 'primary',
  items: () => [],  // Use factory for arrays/objects
  disabled: false
})
```

### Props Validation with Runtime Checks

```typescript
// When you need runtime validation beyond types
const props = defineProps({
  age: {
    type: Number,
    required: true,
    validator: (value: number) => value >= 0 && value <= 150
  }
})
```

---

## Emits Patterns

### Typed Emits

```typescript
// Simple events
const emit = defineEmits<{
  click: []
  change: [value: string]
}>()

// Complex payloads
const emit = defineEmits<{
  submit: [data: FormData]
  error: [error: Error, context: string]
  update: [field: string, value: unknown]
}>()

// Usage
emit('submit', formData)
emit('error', new Error('Failed'), 'validation')
```

### v-model Support

```typescript
// Single v-model
const props = defineProps<{
  modelValue: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

// Multiple v-models
const props = defineProps<{
  modelValue: string
  title: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
  'update:title': [value: string]
}>()
```

---

## Reactive State Patterns

### ref vs reactive

```typescript
// Use ref for primitives
const count = ref(0)
const isLoading = ref(false)
const name = ref('')

// Use reactive for objects (when you don't need to reassign)
const form = reactive({
  username: '',
  email: '',
  password: ''
})

// Use ref for objects when you need to reassign
const user = ref<User | null>(null)
user.value = await fetchUser()  // Can reassign
```

### Computed Properties

```typescript
// Basic computed
const fullName = computed(() => `${firstName.value} ${lastName.value}`)

// Writable computed
const fullName = computed({
  get: () => `${firstName.value} ${lastName.value}`,
  set: (value: string) => {
    const [first, last] = value.split(' ')
    firstName.value = first
    lastName.value = last
  }
})
```

### Watchers

```typescript
// Watch single ref
watch(searchQuery, (newValue, oldValue) => {
  performSearch(newValue)
})

// Watch with options
watch(searchQuery, (value) => {
  performSearch(value)
}, { immediate: true, deep: false })

// Watch multiple sources
watch([firstName, lastName], ([newFirst, newLast]) => {
  updateFullName(newFirst, newLast)
})

// Watch reactive object
watch(
  () => form.username,
  (newUsername) => {
    validateUsername(newUsername)
  }
)

// watchEffect - runs immediately and tracks dependencies
watchEffect(() => {
  console.log(`Count is: ${count.value}`)
})
```

---

## Composables

### Basic Composable Structure

```typescript
// composables/useCounter.ts
import { ref, computed } from 'vue'

export function useCounter(initialValue = 0) {
  const count = ref(initialValue)

  const doubleCount = computed(() => count.value * 2)

  function increment() {
    count.value++
  }

  function decrement() {
    count.value--
  }

  function reset() {
    count.value = initialValue
  }

  return {
    count: readonly(count),  // Expose as readonly
    doubleCount,
    increment,
    decrement,
    reset
  }
}
```

### Composable with Async Data

```typescript
// composables/useUser.ts
export function useUser(userId: MaybeRef<number>) {
  const user = ref<User | null>(null)
  const loading = ref(false)
  const error = ref<Error | null>(null)

  async function fetchUser() {
    loading.value = true
    error.value = null

    try {
      const id = unref(userId)
      user.value = await api.getUser(id)
    } catch (e) {
      error.value = e as Error
    } finally {
      loading.value = false
    }
  }

  // Watch for userId changes
  watch(() => unref(userId), fetchUser, { immediate: true })

  return {
    user: readonly(user),
    loading: readonly(loading),
    error: readonly(error),
    refetch: fetchUser
  }
}
```

### Composable with Cleanup

```typescript
// composables/useEventListener.ts
export function useEventListener<K extends keyof WindowEventMap>(
  event: K,
  handler: (e: WindowEventMap[K]) => void
) {
  onMounted(() => {
    window.addEventListener(event, handler)
  })

  onUnmounted(() => {
    window.removeEventListener(event, handler)
  })
}

// composables/useInterval.ts
export function useInterval(callback: () => void, ms: number) {
  const intervalId = ref<number | null>(null)

  function start() {
    stop()
    intervalId.value = window.setInterval(callback, ms)
  }

  function stop() {
    if (intervalId.value !== null) {
      clearInterval(intervalId.value)
      intervalId.value = null
    }
  }

  onMounted(start)
  onUnmounted(stop)

  return { start, stop }
}
```

---

## Lifecycle Hooks

```typescript
import {
  onMounted,
  onUpdated,
  onUnmounted,
  onBeforeMount,
  onBeforeUpdate,
  onBeforeUnmount
} from 'vue'

// Most common
onMounted(() => {
  // DOM is ready, fetch data, setup listeners
})

onUnmounted(() => {
  // Cleanup: remove listeners, cancel requests
})

// Less common but useful
onBeforeUnmount(() => {
  // Save state before component is removed
})
```

---

## Template Refs

```typescript
// Single element ref
const inputRef = ref<HTMLInputElement | null>(null)

onMounted(() => {
  inputRef.value?.focus()
})

// Component ref
const childRef = ref<InstanceType<typeof ChildComponent> | null>(null)

onMounted(() => {
  childRef.value?.someMethod()
})

// Multiple refs with v-for
const itemRefs = ref<HTMLElement[]>([])

// In template: :ref="(el) => itemRefs[index] = el"
```

---

## Provide/Inject

```typescript
// Parent component
import { provide } from 'vue'
import type { InjectionKey } from 'vue'

// Type-safe injection key
const ThemeKey: InjectionKey<Ref<'light' | 'dark'>> = Symbol('theme')

const theme = ref<'light' | 'dark'>('light')
provide(ThemeKey, theme)

// Child component (any depth)
import { inject } from 'vue'

const theme = inject(ThemeKey)
// theme is Ref<'light' | 'dark'> | undefined

// With default value
const theme = inject(ThemeKey, ref('light'))
```

---

## Slots

### Accessing Slots

```typescript
import { useSlots } from 'vue'

const slots = useSlots()

const hasHeader = computed(() => !!slots.header)
const hasFooter = computed(() => !!slots.footer)
```

### Dynamic Slot Names

```vue
<template>
  <div>
    <slot :name="slotName" :data="slotData" />
  </div>
</template>
```

---

## Performance Patterns

### Avoiding Unnecessary Re-renders

```typescript
// Bad: Creates new object every render
const style = { color: 'red' }

// Good: Memoize with computed
const style = computed(() => ({
  color: isError.value ? 'red' : 'black'
}))

// Good: Static object outside component
const staticStyle = { color: 'red' }
```

### Lazy Computed

```typescript
// For expensive computations
const expensiveResult = computed(() => {
  return heavyCalculation(items.value)
})
```
