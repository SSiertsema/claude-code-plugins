# Vue Refactor Logic Plugin

Autonomously refactor Vue 3 component script logic for improved readability, maintainability, and Vue best practices.

## Usage

```
/vue-refactor-logic:refactor
```

Automatically detects the currently open `.vue` file and refactors the `<script setup>` section.

**Note:** For full SFC restructuring (section order, script organization), use `vue-reorder` plugin instead.

## What It Does

### Composable Extraction
Extracts reusable stateful logic to `composables/useX.ts`:
- Reactive state (ref, reactive)
- Computed properties
- Watchers
- Lifecycle hooks
- Related methods

### Utility Extraction
Extracts pure functions to `utils/`:
- Formatting functions
- Validation helpers
- Framework-agnostic logic

### Vue Anti-Pattern Fixes
| Anti-Pattern | Fix |
|--------------|-----|
| Direct prop mutation | Emit pattern |
| Side effects in computed | Move to watchers |
| v-if + v-for together | Computed filter |
| Missing cleanup | onUnmounted |
| Unhandled async | Try/catch |

### Code Splitting
- Functions > 50 lines → smaller functions
- Nesting > 3 levels → guard clauses
- Parameters > 4 → object pattern
- Duplicate code → utilities

## Example

**Before:**
```vue
<script setup>
const props = defineProps(['userId'])

const user = ref(null)
const posts = ref([])
const isLoading = ref(false)

onMounted(async () => {
  isLoading.value = true
  user.value = await fetchUser(props.userId)
  posts.value = await fetchPosts(props.userId)
  isLoading.value = false
  window.addEventListener('resize', handleResize)
})

// Missing cleanup!
</script>
```

**After:**
```vue
<script setup>
import { useUserData } from '@/composables/useUserData'

const props = defineProps(['userId'])
const { user, posts, isLoading } = useUserData(props.userId)
</script>
```

```typescript
// composables/useUserData.ts
export function useUserData(userId: Ref<string> | string) {
  const user = ref(null)
  const posts = ref([])
  const isLoading = ref(false)

  const loadData = async () => {
    isLoading.value = true
    try {
      const id = unref(userId)
      user.value = await fetchUser(id)
      posts.value = await fetchPosts(id)
    } finally {
      isLoading.value = false
    }
  }

  onMounted(() => {
    loadData()
    window.addEventListener('resize', handleResize)
  })

  onUnmounted(() => {
    window.removeEventListener('resize', handleResize)
  })

  return { user, posts, isLoading }
}
```

## Verification

Every refactoring ends with a mandatory checklist showing what was done.
