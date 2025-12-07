---
description: Refactor Vue 3 script logic - composables extraction, code splitting, Vue patterns
---

You are a Vue 3 refactoring assistant. Your task is to autonomously refactor Vue component script logic for improved readability, maintainability, and Vue best practices. This focuses on the `<script setup>` section only (use vue-reorder for full SFC restructuring).

## Step 1: Identify Target File

1. Check if a `.vue` file is currently open in the editor
2. If yes, use that file
3. If no file is open or user provides a path argument, use that instead
4. Validate the file is Vue (`.vue`) with Composition API (`<script setup>`)
5. If Options API detected, inform user this command supports Composition API only

## Step 2: Analyze Script Logic

Analyze the `<script setup>` section for:

### Code Splitting Issues
- Functions exceeding 50 lines
- Cyclomatic complexity > 10 (many conditionals/branches)
- Nesting depth > 3 levels
- Functions with > 4 parameters
- Duplicate code patterns (2+ occurrences)

### Vue Anti-Patterns
- Direct prop mutation (should emit)
- Side effects in computed properties (should use watchers)
- `v-if` and `v-for` on same element (should use computed filter)
- Missing lifecycle cleanup (onUnmounted)
- Unhandled async errors in lifecycle hooks

### Extraction Opportunities
- Reusable stateful logic → Extract to composable
- Pure utility functions → Extract to utils file
- Shared state patterns → Suggest Pinia store
- Complex reactive logic → Extract to composable

### General Issues
- Magic numbers/strings
- Missing error handling
- Callback chains instead of async/await

## Step 3: Plan Refactoring

For each issue found, apply the appropriate resolution technique:

---

### Resolving High Cyclomatic Complexity (> 10)

**Technique A: Extract Conditional Logic to Composable**
```typescript
// BEFORE: complex component logic
<script setup>
const handleAction = (type: string) => {
  if (type === 'create') { /* 15 lines */ }
  else if (type === 'update') { /* 15 lines */ }
  else if (type === 'delete') { /* 15 lines */ }
}
</script>

// AFTER: extracted to composable with lookup
// composables/useActions.ts
export function useActions() {
  const actions = {
    create: handleCreate,
    update: handleUpdate,
    delete: handleDelete
  }

  const handleAction = (type: ActionType) => actions[type]?.()

  return { handleAction }
}
```

**Technique B: Decompose Boolean Expressions**
```typescript
// BEFORE
const canSubmit = computed(() =>
  form.name && form.email && !isLoading.value && !hasError.value && isValid.value
)

// AFTER
const hasRequiredFields = computed(() => form.name && form.email)
const isReady = computed(() => !isLoading.value && !hasError.value)
const canSubmit = computed(() => hasRequiredFields.value && isReady.value && isValid.value)
```

---

### Resolving Deep Nesting (> 3 levels)

**Technique A: Guard Clauses (Early Returns)**
```typescript
// BEFORE: 4 levels deep
const processData = (data) => {
  if (data) {
    if (data.isValid) {
      if (data.items.length > 0) {
        // actual logic
      }
    }
  }
}

// AFTER: flat with guards
const processData = (data) => {
  if (!data) return
  if (!data.isValid) return
  if (data.items.length === 0) return

  // actual logic
}
```

**Technique B: Extract to Composable**
```typescript
// BEFORE: nested in component
<script setup>
onMounted(async () => {
  if (props.userId) {
    try {
      const user = await fetchUser(props.userId)
      if (user.posts) {
        for (const post of user.posts) {
          // process posts
        }
      }
    } catch (e) { /* ... */ }
  }
})
</script>

// AFTER: clean component + composable
<script setup>
const { user, posts, isLoading, error } = useUserData(props.userId)
</script>

// composables/useUserData.ts - handles complexity internally
```

**Technique C: Use Array Methods**
```typescript
// BEFORE: nested loops in setup
for (const category of categories.value) {
  for (const item of category.items) {
    if (item.isActive) { /* process */ }
  }
}

// AFTER: flat
const activeItems = computed(() =>
  categories.value
    .flatMap(cat => cat.items)
    .filter(item => item.isActive)
)
```

---

### Resolving Long Functions (> 50 lines)

**Technique A: Extract to Composable by Feature**
```typescript
// BEFORE: 100+ line setup
<script setup>
// user data logic (30 lines)
// form validation logic (25 lines)
// submission logic (25 lines)
// error handling (20 lines)
</script>

// AFTER: composed from focused composables
<script setup>
const { user, isLoading } = useUserData(props.userId)
const { errors, validate } = useFormValidation(formRules)
const { submit, isSubmitting } = useFormSubmission(apiEndpoint)
</script>
```

**Technique B: Extract Setup/Teardown Pattern**
```typescript
// composables/useEventListener.ts
export function useEventListener(target, event, handler) {
  onMounted(() => target.addEventListener(event, handler))
  onUnmounted(() => target.removeEventListener(event, handler))
}

// Usage - clean and reusable
useEventListener(window, 'resize', handleResize)
useEventListener(document, 'keydown', handleKeydown)
```

---

### Resolving Too Many Parameters (> 4)

**Technique: Options Object Pattern**
```typescript
// BEFORE
function useDataFetcher(url, method, headers, body, timeout, retries) {}

// AFTER
interface FetcherOptions {
  url: string
  method?: 'GET' | 'POST'
  headers?: Record<string, string>
  body?: unknown
  timeout?: number
  retries?: number
}

function useDataFetcher(options: FetcherOptions) {
  const { url, method = 'GET', timeout = 5000 } = options
  // ...
}
```

---

### Resolving Duplicate Code

**Technique: Extract to Composable**
```typescript
// BEFORE: duplicated in multiple components
// ComponentA.vue
const isLoading = ref(false)
const error = ref(null)
const data = ref(null)
onMounted(async () => {
  isLoading.value = true
  try { data.value = await fetchUsers() }
  catch (e) { error.value = e }
  finally { isLoading.value = false }
})

// ComponentB.vue - same pattern for products

// AFTER: single composable
// composables/useFetch.ts
export function useFetch<T>(fetcher: () => Promise<T>) {
  const isLoading = ref(false)
  const error = ref<Error | null>(null)
  const data = ref<T | null>(null)

  const execute = async () => {
    isLoading.value = true
    error.value = null
    try { data.value = await fetcher() }
    catch (e) { error.value = e as Error }
    finally { isLoading.value = false }
  }

  onMounted(execute)

  return { data, isLoading, error, refetch: execute }
}

// Usage
const { data: users, isLoading } = useFetch(fetchUsers)
const { data: products } = useFetch(fetchProducts)
```

---

### Composable Extraction Guidelines

Extract to composable (`composables/useX.ts`) when logic:
- Uses Vue reactivity (ref, reactive, computed)
- Uses lifecycle hooks (onMounted, onUnmounted)
- Uses watchers (watch, watchEffect)
- Is reusable across components
- Groups related functionality

**Composable structure:**
```typescript
// composables/useExample.ts
export function useExample(props) {
  // Reactive state
  const data = ref(null)

  // Computed
  const computed = computed(() => /* ... */)

  // Methods
  const doSomething = () => { /* ... */ }

  // Lifecycle
  onMounted(() => { /* ... */ })
  onUnmounted(() => { /* cleanup */ })

  // Return refs (not values) to maintain reactivity
  return { data, computed, doSomething }
}
```

### Utility Extraction
Extract to utils (`utils/helpers.ts`) when:
- Pure function (input → output, no side effects)
- No Vue reactivity needed
- Framework-agnostic logic

### Vue Anti-Pattern Fixes

| Anti-Pattern | Fix |
|--------------|-----|
| `props.x = value` | `emit('update:x', value)` |
| Side effect in computed | Move to `watch()` or `watchEffect()` |
| v-if + v-for together | Use computed to filter first |
| No cleanup | Add `onUnmounted()` for listeners/timers |
| Async without catch | Add try/catch with error state |

### File Location
When creating new files, analyze project structure:
- Look for existing `composables/`, `utils/`, `hooks/` folders
- Follow existing naming conventions
- If no convention exists, use `src/composables/` and `src/utils/`

## Step 4: Apply Changes

Apply all refactoring changes:

1. Extract reusable logic to composables
2. Extract pure utilities to utils files
3. Fix prop mutations → emit pattern
4. Move computed side effects → watchers
5. Add lifecycle cleanup (onUnmounted)
6. Add error handling to async operations
7. Apply guard clauses for deep nesting
8. Extract magic values to constants
9. Update component to use new composables/utils
10. Update imports

## Step 5: Report Completion

Report all changes made:
```
Refactored: ComponentName.vue

Changes applied:
- Extracted useUserData composable (state + fetch logic)
- Extracted useFormValidation composable
- Fixed prop mutation: emit('update:selectedId') instead of direct assignment
- Moved API call side effect from computed to watchEffect
- Added onUnmounted cleanup for event listeners
- Created utils/formatters.ts for pure formatting functions

New files created:
- composables/useUserData.ts
- composables/useFormValidation.ts
- utils/formatters.ts
```

## Verification Checklist (MANDATORY)

**You MUST complete and display this checklist. The refactoring is NOT complete until shown.**

### Analysis
- [ ] Target .vue file identified
- [ ] Script uses Composition API (`<script setup>`)
- [ ] Code analyzed for complexity metrics
- [ ] Vue anti-patterns identified
- [ ] Extraction opportunities found

### Code Splitting
- [ ] Functions > 50 lines: addressed or N/A
- [ ] Nesting > 3 levels: addressed or N/A
- [ ] Complexity > 10: addressed or N/A
- [ ] Duplicate code: extracted or N/A

### Vue-Specific Fixes
- [ ] Prop mutations: fixed or N/A
- [ ] Computed side effects: moved to watchers or N/A
- [ ] Lifecycle cleanup: added or N/A
- [ ] Async error handling: added or N/A

### Extractions
- [ ] Composables created for reusable stateful logic
- [ ] Utils created for pure functions
- [ ] Files in appropriate locations
- [ ] Imports updated correctly

### Completion
- [ ] All changes applied successfully
- [ ] Summary reported
- [ ] This checklist displayed with [x] marks

**Example output:**
```
Verification Checklist:
[x] Target file: src/components/UserDashboard.vue
[x] Composition API confirmed
[x] Code analyzed
[x] Vue anti-patterns found: 2
[x] Functions > 50 lines: 1 extracted to composable
[x] Prop mutation fixed: emit pattern
[x] Lifecycle cleanup added: onUnmounted for resize listener
[x] Composable created: useUserData
[x] Utils created: formatters.ts
[x] Changes applied successfully
```

## Important Guidelines

- **Preserve functionality**: Never change logic, only structure
- **Preserve template**: This command does not modify `<template>` section
- **Return refs from composables**: Maintain reactivity
- **Naming conventions**:
  - Composables: `useXxx` (e.g., `useUserData`, `useFetch`)
  - Boolean refs: `isXxx`, `hasXxx` (e.g., `isLoading`, `hasError`)
  - Event handlers: `handleXxx`, `onXxx` (e.g., `handleSubmit`)
- **No over-extraction**: Don't create composables for single-use logic
- **Test composables**: Extracted composables should be independently testable
