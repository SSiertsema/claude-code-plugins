---
name: vue-development
description: Vue 3 and Nuxt 3 development with TDD workflow and QA-first approach. Enforces unit testing before implementation and produces JSON reports for QA agent handoff.
---

# Vue Development Skill

This skill guides development of Vue 3 and Nuxt 3 applications using a **test-driven development** approach with **quality assurance gates**.

## When This Skill Activates

Use this skill when:
- Creating or modifying `.vue` files
- Writing composables (`use*.ts`)
- Working with Nuxt-specific files (`pages/`, `layouts/`, `middleware/`, `composables/`)
- User mentions Vue, Nuxt, or component development
- Building reactive UI components

## Core Workflow: TDD + QA

**ALWAYS follow this workflow:**

```
1. UNDERSTAND  → Read requirements, identify component behavior
2. TEST FIRST  → Write failing unit tests (Vitest + Vue Test Utils)
3. IMPLEMENT   → Write minimal code to pass tests
4. REFACTOR    → Clean up while keeping tests green
5. QA CHECK    → Validate against Vue checklist (see qa/vue-checklist.md)
6. REPORT      → Generate JSON report for QA agent handoff
```

## Step-by-Step Instructions

### Step 1: Understand Requirements

Before writing any code:
- Clarify what the component should do
- Identify props, emits, and slots needed
- Determine reactive state requirements
- List expected behaviors for testing

### Step 2: Write Tests First

**Create test file BEFORE implementation:**

```typescript
// src/components/__tests__/MyComponent.spec.ts
import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import MyComponent from '../MyComponent.vue'

describe('MyComponent', () => {
  it('renders with default props', () => {
    const wrapper = mount(MyComponent)
    expect(wrapper.exists()).toBe(true)
  })

  it('displays label prop correctly', () => {
    const wrapper = mount(MyComponent, {
      props: { label: 'Click me' }
    })
    expect(wrapper.text()).toContain('Click me')
  })

  it('emits click event when clicked', async () => {
    const wrapper = mount(MyComponent)
    await wrapper.trigger('click')
    expect(wrapper.emitted('click')).toBeTruthy()
  })
})
```

**Run tests to confirm they fail:**
```bash
npm run test -- MyComponent.spec.ts
```

### Step 3: Implement Component

Write the **minimal code** to make tests pass:

```vue
<script setup lang="ts">
interface Props {
  label?: string
}

const props = withDefaults(defineProps<Props>(), {
  label: 'Button'
})

const emit = defineEmits<{
  click: []
}>()

function handleClick() {
  emit('click')
}
</script>

<template>
  <button @click="handleClick">
    {{ label }}
  </button>
</template>
```

### Step 4: Verify Tests Pass

```bash
npm run test -- MyComponent.spec.ts
```

All tests must be green before proceeding.

### Step 5: QA Validation

Go through the **Vue QA Checklist** (see `qa/vue-checklist.md`):

- [ ] Props typed with TypeScript
- [ ] Emits typed with `defineEmits<{...}>()`
- [ ] No `any` types
- [ ] Computed for derived state
- [ ] Single responsibility
- [ ] Tests cover all behaviors

### Step 6: Generate Handoff Report

**REQUIRED:** Create a JSON report for QA agent validation.

**Location:** `.qa-reports/{uuid}.vue-development-skill.json`

Generate a UUID and write the report:

```json
{
  "id": "generated-uuid-here",
  "skill": "vue-development",
  "timestamp": "2025-12-01T10:30:00Z",
  "task_description": "Created MyComponent button with click handling",

  "files": {
    "created": ["src/components/MyComponent.vue"],
    "modified": [],
    "test_files": ["src/components/__tests__/MyComponent.spec.ts"]
  },

  "tdd": {
    "tests_written_first": true,
    "test_command": "npm run test -- MyComponent.spec.ts",
    "tests_passing": true,
    "coverage_estimate": "high"
  },

  "qa": {
    "score": 9.0,
    "status": "PASS",
    "checklist": {
      "component_quality": { "passed": 5, "total": 5, "issues": [] },
      "reactivity": { "passed": 4, "total": 4, "issues": [] },
      "composables": { "passed": 0, "total": 0, "issues": ["N/A"] },
      "nuxt_specific": { "passed": 0, "total": 0, "issues": ["N/A - plain Vue"] },
      "typescript": { "passed": 4, "total": 4, "issues": [] },
      "unit_tests": { "passed": 6, "total": 6, "issues": [] }
    }
  },

  "e2e_scenarios": [
    {
      "description": "Button click triggers expected action",
      "route": "/page-where-used",
      "actions": ["click button"],
      "expected": "Action is triggered"
    }
  ],

  "ready_for_e2e": true
}
```

## Quality Thresholds

| Score | Status | Action |
|-------|--------|--------|
| 9-10 | PASS | Ready for E2E validation |
| 7-8 | ACCEPTABLE | Ready, but note issues |
| 0-6 | NEEDS_WORK | Fix issues before handoff |

**Formula:** `score = (checks_passed / total_applicable_checks) × 10`

## File References

- **QA Checklist:** See `qa/vue-checklist.md` for full criteria
- **Report Schema:** See `qa/report-template.json` for JSON structure
- **TDD Guide:** See `tdd/workflow.md` for detailed process
- **Testing Patterns:** See `tdd/testing-patterns.md` for Vitest examples
- **Vue Patterns:** See `patterns/composition-api.md`
- **Nuxt Patterns:** See `patterns/nuxt3.md`
- **TypeScript:** See `patterns/typescript.md`
- **Debugging:** See `debugging/common-issues.md`

## Important Rules

1. **NEVER skip tests** - Write tests before implementation
2. **NEVER skip the report** - QA agent depends on it
3. **NEVER leave tests failing** - All tests must pass
4. **ALWAYS use TypeScript** - No JavaScript, no `any`
5. **ALWAYS follow Composition API** - No Options API
