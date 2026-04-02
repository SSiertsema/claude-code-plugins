# Vue Testing Patterns with Vitest

This guide covers common testing patterns for Vue 3 components using Vitest and Vue Test Utils.

## Setup

### Dependencies

```bash
npm install -D vitest @vue/test-utils @vitejs/plugin-vue happy-dom
```

### Vitest Config

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  test: {
    environment: 'happy-dom',
    globals: true,
  },
})
```

---

## Basic Component Testing

### Mounting Components

```typescript
import { mount, shallowMount } from '@vue/test-utils'
import MyComponent from '../MyComponent.vue'

// Full mount - renders child components
const wrapper = mount(MyComponent)

// Shallow mount - stubs child components
const shallow = shallowMount(MyComponent)
```

### Testing Props

```typescript
describe('Button', () => {
  it('renders label prop', () => {
    const wrapper = mount(Button, {
      props: { label: 'Click me' }
    })
    expect(wrapper.text()).toBe('Click me')
  })

  it('applies variant class', () => {
    const wrapper = mount(Button, {
      props: { variant: 'primary' }
    })
    expect(wrapper.classes()).toContain('btn-primary')
  })

  it('is disabled when disabled prop is true', () => {
    const wrapper = mount(Button, {
      props: { disabled: true }
    })
    expect(wrapper.attributes('disabled')).toBeDefined()
  })
})
```

### Testing Emits

```typescript
describe('Button', () => {
  it('emits click event', async () => {
    const wrapper = mount(Button)

    await wrapper.trigger('click')

    expect(wrapper.emitted('click')).toBeTruthy()
    expect(wrapper.emitted('click')).toHaveLength(1)
  })

  it('emits with payload', async () => {
    const wrapper = mount(ItemCard, {
      props: { item: { id: 1, name: 'Test' } }
    })

    await wrapper.trigger('click')

    expect(wrapper.emitted('select')?.[0]).toEqual([{ id: 1, name: 'Test' }])
  })

  it('does not emit when disabled', async () => {
    const wrapper = mount(Button, {
      props: { disabled: true }
    })

    await wrapper.trigger('click')

    expect(wrapper.emitted('click')).toBeFalsy()
  })
})
```

---

## Testing Reactivity

### Testing Computed Properties

```typescript
describe('CartTotal', () => {
  it('calculates total correctly', async () => {
    const wrapper = mount(CartTotal, {
      props: {
        items: [
          { price: 10, quantity: 2 },
          { price: 5, quantity: 3 }
        ]
      }
    })

    // Total = (10 * 2) + (5 * 3) = 35
    expect(wrapper.text()).toContain('$35')
  })

  it('updates when items change', async () => {
    const wrapper = mount(CartTotal, {
      props: {
        items: [{ price: 10, quantity: 1 }]
      }
    })

    expect(wrapper.text()).toContain('$10')

    await wrapper.setProps({
      items: [{ price: 10, quantity: 2 }]
    })

    expect(wrapper.text()).toContain('$20')
  })
})
```

### Testing v-model

```typescript
describe('TextInput', () => {
  it('updates modelValue on input', async () => {
    const wrapper = mount(TextInput, {
      props: { modelValue: '' }
    })

    await wrapper.find('input').setValue('Hello')

    expect(wrapper.emitted('update:modelValue')?.[0]).toEqual(['Hello'])
  })

  it('displays modelValue', () => {
    const wrapper = mount(TextInput, {
      props: { modelValue: 'Initial' }
    })

    expect(wrapper.find('input').element.value).toBe('Initial')
  })
})
```

---

## Testing Async Operations

### Using flushPromises

```typescript
import { flushPromises } from '@vue/test-utils'

describe('UserList', () => {
  it('loads users on mount', async () => {
    const wrapper = mount(UserList)

    // Wait for all promises to resolve
    await flushPromises()

    expect(wrapper.findAll('.user-item')).toHaveLength(3)
  })
})
```

### Mocking API Calls

```typescript
import { vi } from 'vitest'

// Mock the API module
vi.mock('@/api/users', () => ({
  fetchUsers: vi.fn(() => Promise.resolve([
    { id: 1, name: 'John' },
    { id: 2, name: 'Jane' }
  ]))
}))

describe('UserList', () => {
  it('displays fetched users', async () => {
    const wrapper = mount(UserList)
    await flushPromises()

    expect(wrapper.text()).toContain('John')
    expect(wrapper.text()).toContain('Jane')
  })
})
```

### Testing Loading States

```typescript
describe('DataLoader', () => {
  it('shows loading state initially', () => {
    const wrapper = mount(DataLoader)

    expect(wrapper.find('.loading').exists()).toBe(true)
    expect(wrapper.find('.content').exists()).toBe(false)
  })

  it('shows content after loading', async () => {
    const wrapper = mount(DataLoader)

    await flushPromises()

    expect(wrapper.find('.loading').exists()).toBe(false)
    expect(wrapper.find('.content').exists()).toBe(true)
  })
})
```

---

## Testing with Pinia

### Setup

```typescript
import { setActivePinia, createPinia } from 'pinia'
import { useUserStore } from '@/stores/user'

describe('UserProfile', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('displays user from store', () => {
    const store = useUserStore()
    store.user = { id: 1, name: 'John' }

    const wrapper = mount(UserProfile)

    expect(wrapper.text()).toContain('John')
  })

  it('calls store action on button click', async () => {
    const store = useUserStore()
    const logoutSpy = vi.spyOn(store, 'logout')

    const wrapper = mount(UserProfile)
    await wrapper.find('.logout-btn').trigger('click')

    expect(logoutSpy).toHaveBeenCalled()
  })
})
```

---

## Testing Slots

### Default Slot

```typescript
describe('Card', () => {
  it('renders default slot content', () => {
    const wrapper = mount(Card, {
      slots: {
        default: '<p>Card content</p>'
      }
    })

    expect(wrapper.html()).toContain('<p>Card content</p>')
  })
})
```

### Named Slots

```typescript
describe('Layout', () => {
  it('renders header and footer slots', () => {
    const wrapper = mount(Layout, {
      slots: {
        header: '<h1>Title</h1>',
        default: '<main>Content</main>',
        footer: '<footer>Footer</footer>'
      }
    })

    expect(wrapper.find('h1').text()).toBe('Title')
    expect(wrapper.find('main').text()).toBe('Content')
    expect(wrapper.find('footer').text()).toBe('Footer')
  })
})
```

### Scoped Slots

```typescript
describe('List', () => {
  it('passes item to scoped slot', () => {
    const wrapper = mount(List, {
      props: {
        items: [{ id: 1, name: 'Item 1' }]
      },
      slots: {
        item: `<template #item="{ item }">
          <span class="item-name">{{ item.name }}</span>
        </template>`
      }
    })

    expect(wrapper.find('.item-name').text()).toBe('Item 1')
  })
})
```

---

## Testing Composables

```typescript
// composables/useCounter.ts
export function useCounter(initial = 0) {
  const count = ref(initial)
  const increment = () => count.value++
  const decrement = () => count.value--
  return { count, increment, decrement }
}

// composables/__tests__/useCounter.spec.ts
import { useCounter } from '../useCounter'

describe('useCounter', () => {
  it('starts with initial value', () => {
    const { count } = useCounter(5)
    expect(count.value).toBe(5)
  })

  it('increments count', () => {
    const { count, increment } = useCounter()
    increment()
    expect(count.value).toBe(1)
  })

  it('decrements count', () => {
    const { count, decrement } = useCounter(5)
    decrement()
    expect(count.value).toBe(4)
  })
})
```

---

## Testing Error States

```typescript
describe('ErrorBoundary', () => {
  it('shows error message on fetch failure', async () => {
    vi.mock('@/api', () => ({
      fetchData: vi.fn(() => Promise.reject(new Error('Network error')))
    }))

    const wrapper = mount(DataComponent)
    await flushPromises()

    expect(wrapper.find('.error').exists()).toBe(true)
    expect(wrapper.text()).toContain('Network error')
  })
})
```

---

## Test Organization Best Practices

### File Structure

```
src/
├── components/
│   ├── Button.vue
│   └── __tests__/
│       └── Button.spec.ts
├── composables/
│   ├── useCounter.ts
│   └── __tests__/
│       └── useCounter.spec.ts
```

### Describe Blocks

```typescript
describe('Button', () => {
  describe('rendering', () => {
    it('renders label')
    it('applies variant class')
  })

  describe('interactions', () => {
    it('emits click on click')
    it('does not emit when disabled')
  })

  describe('accessibility', () => {
    it('has correct aria attributes')
    it('is keyboard accessible')
  })
})
```

### Helpers

```typescript
// test/helpers.ts
export function mountButton(props = {}) {
  return mount(Button, {
    props: {
      label: 'Default',
      ...props
    }
  })
}

// Usage
const wrapper = mountButton({ variant: 'primary' })
```
