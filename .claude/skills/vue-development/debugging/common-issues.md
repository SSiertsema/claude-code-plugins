# Common Vue/Nuxt Issues & Debugging

This guide covers frequent issues and how to debug them effectively.

## Reactivity Issues

### Problem: Changes Not Reflecting in UI

**Symptom:** You update a value but the template doesn't update.

**Common Causes:**

1. **Replacing reactive object instead of modifying:**
```typescript
// Bad - loses reactivity
let user = reactive({ name: 'John' })
user = { name: 'Jane' }  // Broken!

// Good - modify properties
const user = reactive({ name: 'John' })
user.name = 'Jane'

// Or use ref for reassignment
const user = ref({ name: 'John' })
user.value = { name: 'Jane' }  // Works!
```

2. **Adding new properties to reactive object:**
```typescript
// Bad - new property not reactive in some cases
const state = reactive({ count: 0 })
state.newProp = 'value'  // May not be reactive

// Good - define all properties upfront
const state = reactive({
  count: 0,
  newProp: ''
})
```

3. **Destructuring reactive objects:**
```typescript
// Bad - loses reactivity
const { count } = reactive({ count: 0 })

// Good - use toRefs
const state = reactive({ count: 0 })
const { count } = toRefs(state)

// Or use computed
const count = computed(() => state.count)
```

### Problem: Infinite Update Loop

**Symptom:** Console shows "Maximum recursive updates exceeded"

**Common Causes:**

1. **Modifying reactive state in watch without guard:**
```typescript
// Bad - infinite loop
watch(count, () => {
  count.value++  // Triggers watch again!
})

// Good - add condition
watch(count, (newVal, oldVal) => {
  if (newVal < 100) {
    count.value++
  }
})
```

2. **Computed with side effects:**
```typescript
// Bad - don't modify state in computed
const doubled = computed(() => {
  count.value = count.value * 2  // Side effect!
  return count.value
})

// Good - pure computed
const doubled = computed(() => count.value * 2)
```

---

## Props Issues

### Problem: Prop Not Updating

**Symptom:** Parent changes prop but child doesn't reflect change.

**Common Causes:**

1. **Caching prop in local state:**
```typescript
// Bad - only captures initial value
const props = defineProps<{ value: string }>()
const localValue = ref(props.value)  // Not reactive to prop changes!

// Good - use computed
const localValue = computed(() => props.value)

// Or watch for updates
watch(() => props.value, (newVal) => {
  localValue.value = newVal
})
```

2. **Object/Array prop mutation:**
```typescript
// Bad - mutating prop
props.items.push(newItem)

// Good - emit to parent
emit('update:items', [...props.items, newItem])
```

### Problem: Default Props Not Working

```typescript
// Wrong - defaults don't work with interface-only props
const props = defineProps<{ count?: number }>()
// props.count is undefined, not 0

// Correct - use withDefaults
const props = withDefaults(defineProps<{ count?: number }>(), {
  count: 0
})
```

---

## Lifecycle Issues

### Problem: DOM Element is Null

**Symptom:** `ref.value` is null when trying to access DOM element.

**Cause:** Accessing before component is mounted.

```typescript
// Bad - runs before mount
const inputRef = ref<HTMLInputElement | null>(null)
inputRef.value?.focus()  // null!

// Good - wait for mount
onMounted(() => {
  inputRef.value?.focus()
})
```

### Problem: Event Listeners Not Removed

**Symptom:** Memory leaks, duplicate handlers.

```typescript
// Bad - listener never removed
onMounted(() => {
  window.addEventListener('resize', handleResize)
})

// Good - cleanup on unmount
onMounted(() => {
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
})

// Best - use composable
function useWindowResize(callback: () => void) {
  onMounted(() => window.addEventListener('resize', callback))
  onUnmounted(() => window.removeEventListener('resize', callback))
}
```

---

## Nuxt-Specific Issues

### Problem: Hydration Mismatch

**Symptom:** Console warning about hydration mismatch.

**Common Causes:**

1. **Using browser-only APIs during SSR:**
```typescript
// Bad - window doesn't exist on server
const width = ref(window.innerWidth)

// Good - check for client
const width = ref(0)
onMounted(() => {
  width.value = window.innerWidth
})

// Or use process.client
if (process.client) {
  width.value = window.innerWidth
}
```

2. **Random values differing server/client:**
```typescript
// Bad - different on server and client
const id = ref(Math.random())

// Good - generate on client only
const id = ref('')
onMounted(() => {
  id.value = crypto.randomUUID()
})
```

3. **Date formatting:**
```typescript
// Bad - timezone differences
const formatted = new Date().toLocaleString()

// Good - consistent formatting or client-only
const formatted = ref('')
onMounted(() => {
  formatted.value = new Date().toLocaleString()
})
```

### Problem: useFetch Not Triggering

**Symptom:** Data not fetching or not updating.

```typescript
// Issue: Using static URL with dynamic value
const id = ref(1)
const { data } = await useFetch(`/api/users/${id.value}`)  // Only fetches once!

// Solution 1: Use computed URL
const { data } = await useFetch(() => `/api/users/${id.value}`)

// Solution 2: Use watch option
const { data } = await useFetch(`/api/users/${id.value}`, {
  watch: [id]
})
```

### Problem: Nuxt Auto-Import Not Working

**Symptom:** "X is not defined" error.

**Check:**
1. File is in correct directory (`composables/`, `utils/`)
2. File is named correctly (index files need re-export)
3. Restart dev server after adding new composables

```bash
# Restart dev server
npm run dev
```

---

## TypeScript Issues

### Problem: Type 'X' is Not Assignable

**Common in Vue:**

```typescript
// Issue: ref type inference
const count = ref(null)  // Ref<null>
count.value = 5  // Error!

// Fix: explicit type
const count = ref<number | null>(null)
count.value = 5  // OK
```

### Problem: Property Does Not Exist on Type

```typescript
// Issue: accessing possibly undefined
const { data } = await useFetch<User>('/api/user')
console.log(data.value.name)  // Error: possibly undefined

// Fix: optional chaining or guard
console.log(data.value?.name)

// Or type assertion when sure
if (data.value) {
  console.log(data.value.name)
}
```

---

## Performance Issues

### Problem: Slow Rendering

**Debugging Steps:**

1. **Check Vue DevTools Performance tab**
2. **Look for unnecessary re-renders:**
```typescript
// Bad - creates new function each render
<button @click="() => handleClick(item)">

// Good - bind in advance
const handlers = computed(() =>
  items.value.map(item => () => handleClick(item))
)
```

3. **Use `v-once` for static content:**
```vue
<div v-once>{{ staticContent }}</div>
```

4. **Use `v-memo` for expensive lists:**
```vue
<div v-for="item in list" :key="item.id" v-memo="[item.id]">
  <ExpensiveComponent :item="item" />
</div>
```

### Problem: Large Bundle Size

**Debugging:**

```bash
# Analyze bundle
npx nuxi analyze
```

**Solutions:**

1. **Lazy load components:**
```typescript
const HeavyComponent = defineAsyncComponent(() =>
  import('./HeavyComponent.vue')
)
```

2. **Dynamic imports:**
```typescript
const { heavyFunction } = await import('./heavy-utils')
```

---

## Debugging Tools

### Vue DevTools

- **Components Tab:** Inspect component hierarchy and state
- **Timeline Tab:** Track events and state changes
- **Performance Tab:** Profile render performance

### Console Logging

```typescript
// Debug reactive state
console.log(toRaw(reactiveObject))

// Debug computed
watchEffect(() => {
  console.log('Value changed:', someRef.value)
})
```

### Nuxt DevTools

```bash
# Enable in nuxt.config.ts
export default defineNuxtConfig({
  devtools: { enabled: true }
})
```

Features:
- Component inspector
- Route visualization
- API playground
- State management overview

---

## Quick Checklist for Debugging

1. [ ] Check browser console for errors
2. [ ] Check Vue DevTools for component state
3. [ ] Verify reactivity (use `console.log(toRaw(state))`)
4. [ ] Check if issue is SSR-related (disable SSR temporarily)
5. [ ] Verify types match expected values
6. [ ] Check lifecycle timing (mounted vs immediate)
7. [ ] Look for hydration warnings in console
8. [ ] Restart dev server after config changes
