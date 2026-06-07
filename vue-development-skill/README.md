# Vue Development Skill

A Claude Code skill for Vue 3 and Nuxt 3 development with **test-driven development (TDD)**, **QA gates**, and **E2E validation against Gherkin acceptance criteria**.

## Overview

This skill enforces quality-driven development by:

1. **Writing tests before implementation** (TDD)
2. **Validating against an ISO/IEC 25010:2023 QA checklist** (9 characteristics, ~40 sub-characteristics) mapped to concrete Vue/Nuxt checks
3. **Executing E2E tests via Playwright MCP** to validate Gherkin acceptance criteria
4. **Producing JSON reports** with complete validation results

## Self-Validating Workflow

Agents using this skill can **autonomously complete user stories** by implementing and validating their own work:

```
User Story (with Gherkin AC)
    ↓
┌─────────────────────────────────────────────────────────┐
│  Vue Development Agent (this skill)                     │
│                                                         │
│  1. Parse user story + acceptance criteria              │
│  2. Write unit tests first (TDD)                        │
│  3. Implement minimal code                              │
│  4. Run unit tests (Vitest)                             │
│  5. Validate QA checklist                               │
│  6. Execute E2E via Playwright MCP  ← Self-validation   │
│  7. Generate completion report                          │
└─────────────────────────────────────────────────────────┘
    ↓
✅ Self-validated completion (all AC pass)
```

## Input: User Stories with Gherkin

The skill accepts user stories with Gherkin acceptance criteria:

```markdown
## US-001: User Login

> **As a** registered user,
> **I want** to login with my credentials,
> **So that** I can access my account.

### Acceptance Criteria

#### AC1: Successful login

```gherkin
Given I am on the login page
When I fill "email" with "user@example.com"
And I fill "password" with "password123"
And I click "Login"
Then I am redirected to the dashboard
And I see "Welcome back"
```

#### AC2: Invalid password

```gherkin
Given I am on the login page
When I fill "email" with "user@example.com"
And I fill "password" with "wrong"
And I click "Login"
Then I see "Invalid credentials"
```
```

## E2E Test Generation

The skill generates **persistent Playwright test files** from Gherkin acceptance criteria:

**Output:** `tests/e2e/{story-id}-{feature-slug}.spec.ts`

| Gherkin | Playwright Code |
|---------|-----------------|
| `Given I am on "{url}"` | `await page.goto('{url}')` |
| `When I click "{text}"` | `await page.click('text={text}')` |
| `When I fill "{field}" with "{value}"` | `await page.fill('[name="{field}"]', '{value}')` |
| `Then I see "{text}"` | `await expect(page.locator('text={text}')).toBeVisible()` |

**Benefits:**
- Tests are **version-controlled** and persistent
- Can be **re-run** during CI/CD
- Other developers can **review and extend** them
- Builds a **regression test suite** over time

See `e2e/playwright-patterns.md` for the complete mapping reference.

## Installation

Add this plugin to your Claude Code configuration:

```json
{
  "plugins": [
    "https://github.com/your-org/claude-code-plugins/vue-development-skill"
  ]
}
```

## Complete Workflow

```
1. UNDERSTAND  → Parse user story + Gherkin acceptance criteria
2. TEST FIRST  → Write failing unit tests (Vitest + Vue Test Utils)
3. IMPLEMENT   → Write minimal code to pass tests
4. REFACTOR    → Clean up while keeping tests green
5. QA CHECK    → Validate against Vue checklist
6. E2E WRITE   → Generate Playwright test files from Gherkin AC
7. E2E RUN     → Execute tests and verify all AC pass
8. REPORT      → Generate JSON report with all results
```

## QA Checklist — ISO/IEC 25010:2023

The skill validates code against the **ISO/IEC 25010:2023 product quality model**: all 9 characteristics, with one checklist item per sub-characteristic (~40 total), each expressed as a concrete Vue 3 / Nuxt 3 check. Sub-characteristics that don't apply to a given component are marked **N/A** and excluded from scoring (never counted as failures).

| # | Characteristic | Items | Front-end focus |
|---|----------------|-------|-----------------|
| 1 | Functional Suitability | 3 | AC→test coverage, correctness, no scope creep |
| 2 | Performance Efficiency | 3 | computed memoization, cleanup, list capacity |
| 3 | Compatibility | 2 | scoped styles, typed public contract |
| 4 | Interaction Capability | 8 | keyboard, WCAG 2.2 AA, feedback states |
| 5 | Reliability | 4 | edge cases, SSR/hydration, error handling, recovery |
| 6 | Security | 6 | no secrets, no XSS sinks, auth guards, input hardening |
| 7 | Maintainability | 5 | SRP, composables, typing, no prop mutation, TDD |
| 8 | Flexibility | 4 | responsive/tokens, scalability, replaceability |
| 9 | Safety | 5 | confirm destructive actions, fail-safe, boundary validation |

Score per characteristic and overall: `score = (items_passed / total_applicable_items) × 10`.

## Completion Report

After completing work, Claude generates a JSON report with all validation results:

**Location:** `.qa-reports/{uuid}.vue-development-skill.json`

```json
{
  "id": "uuid-v4",
  "skill": "vue-development",
  "timestamp": "2025-12-01T10:30:00Z",
  "task_description": "Implemented user login feature",

  "user_story": {
    "id": "US-001",
    "title": "User Login",
    "persona": "registered user"
  },

  "tdd": {
    "tests_written_first": true,
    "tests_passing": true
  },

  "qa": {
    "standard": "ISO/IEC 25010:2023",
    "score": 9.1,
    "status": "PASS"
  },

  "e2e_validation": {
    "test_file": "tests/e2e/us-001-user-login.spec.ts",
    "test_command": "npx playwright test tests/e2e/us-001-user-login.spec.ts",
    "executed": true,
    "acceptance_criteria": [
      {
        "id": "AC1",
        "title": "Successful login",
        "status": "PASS"
      },
      {
        "id": "AC2",
        "title": "Invalid password",
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

## Included Documentation

### E2E Testing
- `e2e/playwright-patterns.md` - Gherkin to Playwright MCP mapping
- `e2e/acceptance-criteria.md` - Parsing user stories and AC

### Patterns
- `patterns/composition-api.md` - Vue 3 Composition API best practices
- `patterns/nuxt3.md` - Nuxt 3 specific patterns
- `patterns/typescript.md` - TypeScript with Vue

### Testing
- `tdd/workflow.md` - Complete TDD process
- `tdd/testing-patterns.md` - Vitest and Vue Test Utils examples

### Quality
- `qa/vue-checklist.md` - Full QA checklist (ISO/IEC 25010:2023)
- `qa/report-template.json` - JSON schema for reports

### Debugging
- `debugging/common-issues.md` - Troubleshooting guide

## Quality Thresholds

| Score | Status | Meaning |
|-------|--------|---------|
| 9-10 | PASS | All validations passed |
| 7-8 | ACCEPTABLE | Minor issues noted |
| 0-6 | NEEDS_WORK | Must fix before completion |

## Completion Requirements

For `overall: "COMPLETE"`, all gates must pass:

- ✅ Unit tests passing
- ✅ QA checklist score ≥ 7
- ✅ All acceptance criteria validated via Playwright

## Tech Stack

This skill assumes:

- **Vue 3** with Composition API and `<script setup>`
- **Nuxt 3** (optional, patterns included)
- **TypeScript** (required, no JavaScript)
- **Vitest** for unit testing
- **Vue Test Utils** for component testing
- **Playwright MCP** for E2E validation

## License

MIT
