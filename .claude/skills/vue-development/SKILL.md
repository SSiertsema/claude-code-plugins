---
name: vue-development
description: Vue 3 and Nuxt 3 development with TDD workflow, QA gates, and E2E test generation. Enforces unit testing before implementation, generates Playwright E2E tests from Gherkin acceptance criteria, and produces JSON reports.
---

# Vue Development Skill

This skill guides development of Vue 3 and Nuxt 3 applications using a **test-driven development** approach with **quality assurance gates** and **E2E test generation from acceptance criteria**.

## When This Skill Activates

Use this skill when:
- Creating or modifying `.vue` files
- Writing composables (`use*.ts`)
- Working with Nuxt-specific files (`pages/`, `layouts/`, `middleware/`, `composables/`)
- User mentions Vue, Nuxt, or component development
- Building reactive UI components
- **Implementing user stories with Gherkin acceptance criteria**

## Core Workflow: TDD + QA + E2E

**ALWAYS follow this workflow:**

```
1. UNDERSTAND  → Parse user story + Gherkin acceptance criteria
2. TEST FIRST  → Write failing unit tests (Vitest + Vue Test Utils)
3. IMPLEMENT   → Write minimal code to pass tests
4. REFACTOR    → Clean up while keeping tests green
5. QA CHECK    → Validate against Vue checklist (see qa/vue-checklist.md)
6. E2E WRITE   → Generate Playwright test files from Gherkin AC
7. E2E RUN     → Execute tests and verify all AC pass
8. REPORT      → Generate JSON report with E2E results
```

---

## Input: User Story Format

This skill accepts user stories with Gherkin acceptance criteria:

```markdown
## US-001: {Story Title}

> **As a** {persona},
> **I want** {goal},
> **So that** {benefit}.

### Acceptance Criteria

#### AC1: {Happy Path}

```gherkin
Given {precondition}
When {action}
Then {expected result}
```

#### AC2: {Error Scenario}

```gherkin
Given {precondition}
When {invalid action}
Then {error handling}
```
```

**See:** `e2e/acceptance-criteria.md` for detailed parsing guide.

## Step-by-Step Instructions

### Step 1: Understand Requirements

Before writing any code:
- **Parse the user story** to understand persona, goal, and benefit
- **Extract acceptance criteria** (Gherkin Given/When/Then)
- Identify props, emits, and slots needed
- Determine reactive state requirements
- Map acceptance criteria to testable behaviors

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

### Step 6: Write E2E Test Files

**Generate Playwright test files from Gherkin acceptance criteria.**

For each user story, create a test file:

**Location:** `tests/e2e/{feature-slug}.spec.ts`

#### Test File Structure

```typescript
// tests/e2e/user-login.spec.ts
import { test, expect } from '@playwright/test'

/**
 * US-001: User Login
 * As a registered user, I want to login with my credentials,
 * so that I can access my account.
 */
test.describe('US-001: User Login', () => {

  test('AC1: Successful login', async ({ page }) => {
    // Given I am on the login page
    await page.goto('/login')

    // When I fill "email" with "user@example.com"
    await page.fill('[name="email"]', 'user@example.com')

    // And I fill "password" with "password123"
    await page.fill('[name="password"]', 'password123')

    // And I click "Login"
    await page.click('button:has-text("Login")')

    // Then I am redirected to the dashboard
    await expect(page).toHaveURL(/dashboard/)

    // And I see "Welcome back"
    await expect(page.locator('text=Welcome back')).toBeVisible()
  })

  test('AC2: Invalid password', async ({ page }) => {
    // Given I am on the login page
    await page.goto('/login')

    // When I fill "email" with "user@example.com"
    await page.fill('[name="email"]', 'user@example.com')

    // And I fill "password" with "wrong"
    await page.fill('[name="password"]', 'wrong')

    // And I click "Login"
    await page.click('button:has-text("Login")')

    // Then I see "Invalid credentials"
    await expect(page.locator('text=Invalid credentials')).toBeVisible()
  })

})
```

#### Gherkin to Playwright Mapping

| Gherkin | Playwright Code |
|---------|-----------------|
| `Given I am on "{url}"` | `await page.goto('{url}')` |
| `When I click "{text}"` | `await page.click('text={text}')` |
| `When I click the "{selector}" button` | `await page.click('{selector}')` |
| `When I fill "{field}" with "{value}"` | `await page.fill('[name="{field}"]', '{value}')` |
| `When I select "{option}" from "{field}"` | `await page.selectOption('[name="{field}"]', '{option}')` |
| `When I press "{key}"` | `await page.keyboard.press('{key}')` |
| `Then I see "{text}"` | `await expect(page.locator('text={text}')).toBeVisible()` |
| `Then I am redirected to "{url}"` | `await expect(page).toHaveURL(/{url}/)` |
| `Then the "{element}" is visible` | `await expect(page.locator('{element}')).toBeVisible()` |
| `Then the "{element}" is not visible` | `await expect(page.locator('{element}')).not.toBeVisible()` |

#### File Naming Convention

- Story ID in filename: `{story-id}-{feature-slug}.spec.ts`
- Examples:
  - `us-001-user-login.spec.ts`
  - `us-042-password-reset.spec.ts`
  - `us-103-checkout-flow.spec.ts`

**See:** `e2e/playwright-patterns.md` for complete mapping reference.

### Step 7: Run E2E Tests

**Execute the generated Playwright tests to validate acceptance criteria.**

#### Run Tests

```bash
# Run specific test file
npx playwright test tests/e2e/user-login.spec.ts

# Run all E2E tests
npx playwright test tests/e2e/

# Run with UI mode for debugging
npx playwright test tests/e2e/user-login.spec.ts --ui
```

#### Verify Results

All acceptance criteria must pass:

```
Running 2 tests using 1 worker

  ✓ US-001: User Login › AC1: Successful login (2.1s)
  ✓ US-001: User Login › AC2: Invalid password (1.8s)

  2 passed (4.2s)
```

#### Handle Failures

If tests fail:

1. **Review the error** - Check which AC failed and why
2. **Fix the implementation** - Update component/page code
3. **Re-run tests** - Verify fix works
4. **Do NOT modify the test** unless the AC was wrong

```
If AC fails → Fix implementation, NOT the test
If AC is wrong → Update user story first, then regenerate test
```

### Step 8: Generate Report

**REQUIRED:** Create a JSON report with E2E validation results.

**Location:** `.qa-reports/{uuid}.vue-development-skill.json`

Generate a UUID and write the report:

```json
{
  "id": "generated-uuid-here",
  "skill": "vue-development",
  "timestamp": "2025-12-01T10:30:00Z",
  "task_description": "Created MyComponent button with click handling",

  "user_story": {
    "id": "US-001",
    "title": "User Login",
    "persona": "registered user",
    "goal": "to login with my credentials",
    "benefit": "I can access my account"
  },

  "files": {
    "created": ["src/components/MyComponent.vue"],
    "modified": [],
    "test_files": ["src/components/__tests__/MyComponent.spec.ts"],
    "e2e_test_files": ["tests/e2e/us-001-user-login.spec.ts"]
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

  "e2e_validation": {
    "test_file": "tests/e2e/us-001-user-login.spec.ts",
    "test_command": "npx playwright test tests/e2e/us-001-user-login.spec.ts",
    "executed": true,
    "acceptance_criteria": [
      {
        "id": "AC1",
        "title": "Successful login",
        "gherkin": "Given I am on login page\nWhen I fill credentials\nThen I see dashboard",
        "status": "PASS"
      },
      {
        "id": "AC2",
        "title": "Invalid password",
        "gherkin": "Given I am on login page\nWhen I enter wrong password\nThen I see error",
        "status": "PASS"
      }
    ],
    "passed": 2,
    "failed": 0,
    "status": "PASS"
  },

  "completion": {
    "unit_tests": "PASS",
    "qa_checklist": "PASS",
    "e2e_validation": "PASS",
    "overall": "COMPLETE"
  }
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
- **E2E Patterns:** See `e2e/playwright-patterns.md` for Gherkin-to-Playwright mapping
- **Acceptance Criteria:** See `e2e/acceptance-criteria.md` for parsing user stories

## Important Rules

1. **NEVER skip tests** - Write tests before implementation
2. **NEVER skip E2E validation** - Validate all acceptance criteria with Playwright
3. **NEVER skip the report** - Include E2E results in report
4. **NEVER leave tests failing** - All unit tests AND E2E must pass
5. **ALWAYS use TypeScript** - No JavaScript, no `any`
6. **ALWAYS follow Composition API** - No Options API
7. **ALWAYS validate against Gherkin AC** - If user story provided, all AC must pass
