# Vue Reorder Plugin

Refactor Vue 3 Single File Components (SFCs) for optimal readability and maintainability.

## Usage

```
/vue-reorder
```

The command automatically detects the currently open `.vue` file and proposes refactoring changes.

## What It Does

### 1. Reorders SFC Sections

Enforces the recommended order:
```vue
<template>...</template>
<script setup>...</script>
<style scoped>...</style>
```

### 2. Reorganizes Script Content

Applies Composition API ordering convention:

1. Imports (external first, then internal)
2. Props & Emits (`defineProps`, `defineEmits`, `defineModel`)
3. Injections (`inject`, composables like `useRouter`)
4. Reactive State (`ref`, `reactive`)
5. Computed (`computed`)
6. Functions (helpers, event handlers)
7. Watchers (`watch`, `watchEffect`)
8. Lifecycle (`onMounted`, `onUnmounted`, etc.)

### 3. Improves Naming

| Type | Convention | Example |
|------|------------|---------|
| Files | PascalCase | `UserProfile.vue` |
| Variables | camelCase | `userData`, `selectedItem` |
| Booleans | is/has/can prefix | `isLoading`, `hasError` |
| Event handlers | handle/on prefix | `handleClick`, `onSubmit` |
| Data fetching | fetch/load/get prefix | `fetchUsers`, `loadData` |
| Constants | UPPER_SNAKE_CASE | `MAX_ITEMS`, `API_URL` |

## Requirements

- Vue 3 Composition API (`<script setup>`)
- Options API is not supported

## Example

**Before:**
```vue
<script setup>
import { onMounted, ref } from 'vue'
import api from '@/api'

const x = ref([])
const load = async () => { /* ... */ }
const y = ref(false)

onMounted(() => load())
</script>

<style>.container { }</style>

<template>
  <div class="container">...</div>
</template>
```

**After:**
```vue
<template>
  <div class="container">...</div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import api from '@/api'

const items = ref([])
const isLoading = ref(false)

async function fetchItems() { /* ... */ }

onMounted(() => fetchItems())
</script>

<style scoped>
.container { }
</style>
```
