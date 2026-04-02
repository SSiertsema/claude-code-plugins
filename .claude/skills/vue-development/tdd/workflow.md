# TDD Workflow for Vue Components

Test-Driven Development ensures quality by writing tests before implementation. This document outlines the exact process for Vue 3 and Nuxt 3 development.

## The TDD Cycle

```
┌─────────────┐
│   RED       │  Write a failing test
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   GREEN     │  Write minimal code to pass
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  REFACTOR   │  Clean up, keep tests green
└──────┬──────┘
       │
       └───────► Repeat
```

## Step 1: RED - Write Failing Tests

### Before any Vue code exists, create the test file:

```typescript
// src/components/__tests__/UserProfile.spec.ts
import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import UserProfile from '../UserProfile.vue'

describe('UserProfile', () => {
  // Test 1: Basic rendering
  it('renders user name', () => {
    const wrapper = mount(UserProfile, {
      props: {
        user: { id: 1, name: 'John Doe', email: 'john@example.com' }
      }
    })
    expect(wrapper.text()).toContain('John Doe')
  })

  // Test 2: Props affect output
  it('displays user email', () => {
    const wrapper = mount(UserProfile, {
      props: {
        user: { id: 1, name: 'John', email: 'john@example.com' }
      }
    })
    expect(wrapper.text()).toContain('john@example.com')
  })

  // Test 3: Event emission
  it('emits edit event when edit button clicked', async () => {
    const user = { id: 1, name: 'John', email: 'john@example.com' }
    const wrapper = mount(UserProfile, {
      props: { user }
    })

    await wrapper.find('button.edit-btn').trigger('click')

    expect(wrapper.emitted('edit')).toBeTruthy()
    expect(wrapper.emitted('edit')?.[0]).toEqual([user])
  })

  // Test 4: Edge case - loading state
  it('shows loading indicator when loading prop is true', () => {
    const wrapper = mount(UserProfile, {
      props: {
        user: { id: 1, name: 'John', email: 'john@example.com' },
        loading: true
      }
    })
    expect(wrapper.find('.loading-spinner').exists()).toBe(true)
  })
})
```

### Run tests - they should FAIL:

```bash
npm run test -- UserProfile.spec.ts
```

Expected output: All tests fail (component doesn't exist yet).

## Step 2: GREEN - Minimal Implementation

Now write the component with **just enough code** to pass tests:

```vue
<!-- src/components/UserProfile.vue -->
<script setup lang="ts">
interface User {
  id: number
  name: string
  email: string
}

interface Props {
  user: User
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  loading: false
})

const emit = defineEmits<{
  edit: [user: User]
}>()

function handleEdit() {
  emit('edit', props.user)
}
</script>

<template>
  <div class="user-profile">
    <div v-if="loading" class="loading-spinner">Loading...</div>
    <template v-else>
      <h2>{{ user.name }}</h2>
      <p>{{ user.email }}</p>
      <button class="edit-btn" @click="handleEdit">Edit</button>
    </template>
  </div>
</template>
```

### Run tests - they should PASS:

```bash
npm run test -- UserProfile.spec.ts
```

Expected output: All 4 tests pass.

## Step 3: REFACTOR - Improve Quality

With green tests as your safety net, improve the code:

```vue
<script setup lang="ts">
interface User {
  id: number
  name: string
  email: string
  avatar?: string
}

interface Props {
  user: User
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  loading: false
})

const emit = defineEmits<{
  edit: [user: User]
}>()

// Computed for derived state
const displayName = computed(() => props.user.name || 'Unknown User')
const hasAvatar = computed(() => Boolean(props.user.avatar))

function handleEdit() {
  emit('edit', props.user)
}
</script>

<template>
  <div class="user-profile">
    <div v-if="loading" class="loading-spinner" aria-busy="true">
      Loading...
    </div>
    <template v-else>
      <img
        v-if="hasAvatar"
        :src="user.avatar"
        :alt="`${displayName}'s avatar`"
        class="avatar"
      />
      <div v-else class="avatar-placeholder" />

      <h2>{{ displayName }}</h2>
      <p>{{ user.email }}</p>

      <button
        class="edit-btn"
        type="button"
        @click="handleEdit"
      >
        Edit
      </button>
    </template>
  </div>
</template>
```

### Run tests after refactoring:

```bash
npm run test -- UserProfile.spec.ts
```

Tests must still pass. If any fail, you broke something - fix it!

## Step 4: Add More Tests (Repeat Cycle)

Now add tests for the new functionality:

```typescript
it('shows avatar when provided', () => {
  const wrapper = mount(UserProfile, {
    props: {
      user: {
        id: 1,
        name: 'John',
        email: 'john@example.com',
        avatar: 'https://example.com/avatar.jpg'
      }
    }
  })
  expect(wrapper.find('.avatar').exists()).toBe(true)
  expect(wrapper.find('.avatar-placeholder').exists()).toBe(false)
})

it('shows placeholder when no avatar', () => {
  const wrapper = mount(UserProfile, {
    props: {
      user: { id: 1, name: 'John', email: 'john@example.com' }
    }
  })
  expect(wrapper.find('.avatar-placeholder').exists()).toBe(true)
})
```

## Common Test Patterns

### Testing async operations:

```typescript
it('fetches data on mount', async () => {
  const wrapper = mount(UserList)

  // Wait for async operations
  await flushPromises()

  expect(wrapper.findAll('.user-item')).toHaveLength(3)
})
```

### Testing with Pinia stores:

```typescript
import { setActivePinia, createPinia } from 'pinia'

beforeEach(() => {
  setActivePinia(createPinia())
})

it('updates store on action', async () => {
  const wrapper = mount(Counter)
  const store = useCounterStore()

  await wrapper.find('button.increment').trigger('click')

  expect(store.count).toBe(1)
})
```

### Testing slots:

```typescript
it('renders slot content', () => {
  const wrapper = mount(Card, {
    slots: {
      default: '<p>Card content</p>',
      header: '<h1>Title</h1>'
    }
  })

  expect(wrapper.text()).toContain('Card content')
  expect(wrapper.text()).toContain('Title')
})
```

## Checklist Before Moving On

- [ ] All tests written BEFORE implementation
- [ ] All tests passing
- [ ] No skipped tests (`.skip`)
- [ ] Edge cases covered (empty, error, loading states)
- [ ] Tests are readable and maintainable
