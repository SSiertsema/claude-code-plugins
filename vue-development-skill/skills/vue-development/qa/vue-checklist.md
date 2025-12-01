# Vue/Nuxt QA Checklist

This checklist is specifically designed for Vue 3 and Nuxt 3 development. All items must be validated before generating the handoff report.

---

## 1. Component Quality (5 items)

- [ ] **Props typed**: All props have TypeScript types via `defineProps<Props>()`
- [ ] **Props validated**: Required props marked, defaults provided where appropriate
- [ ] **Emits typed**: All emits defined with `defineEmits<{...}>()`
- [ ] **Single responsibility**: Component does ONE thing well
- [ ] **Template simplicity**: No complex logic in template (use computed/methods)

### Examples

**Good - Typed props:**
```typescript
interface Props {
  label: string
  disabled?: boolean
  variant?: 'primary' | 'secondary'
}

const props = withDefaults(defineProps<Props>(), {
  disabled: false,
  variant: 'primary'
})
```

**Bad - Untyped props:**
```typescript
const props = defineProps(['label', 'disabled']) // No types!
```

---

## 2. Reactivity (4 items)

- [ ] **Correct ref usage**: `ref()` for primitives, `reactive()` for objects
- [ ] **Computed for derived state**: Not methods or inline calculations
- [ ] **No prop mutation**: Never modify props directly, emit instead
- [ ] **Cleanup on unmount**: Watchers/listeners cleaned up in `onUnmounted`

### Examples

**Good - Computed for derived state:**
```typescript
const items = ref<Item[]>([])
const itemCount = computed(() => items.value.length)
const hasItems = computed(() => itemCount.value > 0)
```

**Bad - Method for derived state:**
```typescript
function getItemCount() {
  return items.value.length // Recalculates every render!
}
```

---

## 3. Composables (4 items)

*Mark N/A if no composables are created*

- [ ] **Extracted reusable logic**: Shared logic in `use*.ts` files
- [ ] **Returns reactive refs**: Not raw values
- [ ] **Typed return**: Explicit TypeScript return type
- [ ] **Side effects cleaned**: Intervals, listeners cleaned on unmount

### Examples

**Good - Composable structure:**
```typescript
// composables/useCounter.ts
export function useCounter(initial = 0) {
  const count = ref(initial)

  function increment() {
    count.value++
  }

  function decrement() {
    count.value--
  }

  return {
    count: readonly(count),
    increment,
    decrement
  }
}
```

---

## 4. Nuxt-Specific (4 items)

*Mark N/A if not using Nuxt*

- [ ] **Auto-imports used**: Using Nuxt auto-imports correctly (no manual imports for composables)
- [ ] **Data fetching**: Using `useFetch` or `useAsyncData` (not raw fetch)
- [ ] **Error handling**: Handling `.error` ref from data fetching
- [ ] **SEO configured**: `useSeoMeta` or `useHead` for meta tags on pages

### Examples

**Good - Nuxt data fetching:**
```typescript
const { data: users, pending, error } = await useFetch('/api/users')

if (error.value) {
  // Handle error
}
```

**Bad - Raw fetch in Nuxt:**
```typescript
const users = ref([])
onMounted(async () => {
  users.value = await fetch('/api/users').then(r => r.json())
})
```

---

## 5. TypeScript (4 items)

- [ ] **No `any` types**: Use specific types or `unknown`
- [ ] **Interfaces defined**: Props, emits, and data shapes have interfaces
- [ ] **Generics used**: Where reusability benefits (composables, utilities)
- [ ] **Explicit return types**: Functions have return type annotations

### Examples

**Good - Typed function:**
```typescript
interface User {
  id: number
  name: string
  email: string
}

async function fetchUser(id: number): Promise<User> {
  const response = await fetch(`/api/users/${id}`)
  return response.json()
}
```

**Bad - Untyped:**
```typescript
async function fetchUser(id: any) { // any! No return type!
  return await fetch(`/api/users/${id}`).then(r => r.json())
}
```

---

## 6. Unit Tests (6 items)

- [ ] **Tests written first**: Tests existed before implementation (TDD)
- [ ] **Component renders**: Basic render test passes
- [ ] **Props tested**: Props affect output as expected
- [ ] **Emits tested**: Events fire correctly with correct payloads
- [ ] **Edge cases covered**: Empty states, error states, boundaries
- [ ] **All tests passing**: No failing tests

### Examples

**Good - Comprehensive tests:**
```typescript
describe('UserCard', () => {
  it('renders user name', () => {
    const wrapper = mount(UserCard, {
      props: { user: { name: 'John' } }
    })
    expect(wrapper.text()).toContain('John')
  })

  it('emits select event on click', async () => {
    const wrapper = mount(UserCard, {
      props: { user: { id: 1, name: 'John' } }
    })
    await wrapper.trigger('click')
    expect(wrapper.emitted('select')).toEqual([[{ id: 1, name: 'John' }]])
  })

  it('shows placeholder for missing avatar', () => {
    const wrapper = mount(UserCard, {
      props: { user: { name: 'John' } } // No avatar
    })
    expect(wrapper.find('.avatar-placeholder').exists()).toBe(true)
  })
})
```

---

## Scoring

**Calculate score:**
```
score = (items_passed / total_applicable_items) × 10
```

**Thresholds:**

| Score | Status | Meaning |
|-------|--------|---------|
| 9-10 | PASS | Excellent quality, ready for E2E |
| 7-8 | ACCEPTABLE | Good quality, minor issues noted |
| 0-6 | NEEDS_WORK | Must fix issues before handoff |

**Note:** Mark categories as N/A if not applicable (e.g., "Nuxt-Specific" for plain Vue projects). N/A items don't count toward the total.
