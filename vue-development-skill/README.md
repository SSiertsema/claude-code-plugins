# Vue Development Skill

A Claude Code skill for Vue 3 and Nuxt 3 development with a **test-driven development (TDD)** workflow and **QA-first** approach.

## Overview

This skill enforces quality-driven development by:

1. **Writing tests before implementation** (TDD)
2. **Validating against a Vue-specific QA checklist**
3. **Producing JSON reports** for QA agent handoff

## Multi-Agent Workflow

```
┌─────────────────────┐     ┌─────────────────────┐
│  Vue Dev Agent      │     │  QA Validation      │
│  (this skill)       │────▶│  Agent (Playwright) │
│                     │     │                     │
│  - Write unit tests │     │  - Read report      │
│  - Implement        │     │  - Sanity check     │
│  - Run unit tests   │     │  - Write E2E tests  │
│  - Self-QA          │     │  - Run Playwright   │
│  - Produce report   │     │  - Validate feature │
└─────────────────────┘     └─────────────────────┘
```

## Installation

Add this plugin to your Claude Code configuration:

```json
{
  "plugins": [
    "https://github.com/your-org/claude-code-plugins/vue-development-skill"
  ]
}
```

## What This Skill Does

When you work on Vue or Nuxt files, Claude will:

1. **Write unit tests first** using Vitest and Vue Test Utils
2. **Run tests** to confirm they fail (RED phase)
3. **Implement** minimal code to pass tests (GREEN phase)
4. **Refactor** while keeping tests green
5. **Validate** against the Vue QA checklist
6. **Generate a handoff report** in `.qa-reports/`

## TDD Workflow

```
1. UNDERSTAND  → Read requirements, identify component behavior
2. TEST FIRST  → Write failing unit tests (Vitest + Vue Test Utils)
3. IMPLEMENT   → Write minimal code to pass tests
4. REFACTOR    → Clean up while keeping tests green
5. QA CHECK    → Validate against Vue checklist
6. REPORT      → Generate JSON report for QA agent
```

## QA Checklist Categories

The skill validates code against these Vue-specific criteria:

| Category | Items | Focus |
|----------|-------|-------|
| Component Quality | 5 | Props, emits, single responsibility |
| Reactivity | 4 | ref/reactive, computed, no prop mutation |
| Composables | 4 | Structure, return types, cleanup |
| Nuxt-Specific | 4 | useFetch, auto-imports, SEO |
| TypeScript | 4 | No any, interfaces, generics |
| Unit Tests | 6 | Coverage, TDD compliance |

## Handoff Report

After completing work, Claude generates a JSON report:

**Location:** `.qa-reports/{uuid}.vue-development-skill.json`

```json
{
  "id": "uuid-v4",
  "skill": "vue-development",
  "timestamp": "2025-12-01T10:30:00Z",
  "task_description": "Created UserProfile component",
  "files": {
    "created": ["src/components/UserProfile.vue"],
    "test_files": ["src/components/__tests__/UserProfile.spec.ts"]
  },
  "tdd": {
    "tests_written_first": true,
    "tests_passing": true
  },
  "qa": {
    "score": 9.0,
    "status": "PASS"
  },
  "e2e_scenarios": [
    {
      "description": "User profile displays correctly",
      "route": "/profile",
      "actions": ["navigate to /profile"],
      "expected": "User info is displayed"
    }
  ],
  "ready_for_e2e": true
}
```

## Included Documentation

### Patterns
- `patterns/composition-api.md` - Vue 3 Composition API best practices
- `patterns/nuxt3.md` - Nuxt 3 specific patterns
- `patterns/typescript.md` - TypeScript with Vue

### Testing
- `tdd/workflow.md` - Complete TDD process
- `tdd/testing-patterns.md` - Vitest and Vue Test Utils examples

### Quality
- `qa/vue-checklist.md` - Full QA checklist
- `qa/report-template.json` - JSON schema for reports

### Debugging
- `debugging/common-issues.md` - Troubleshooting guide

## Quality Thresholds

| Score | Status | Meaning |
|-------|--------|---------|
| 9-10 | PASS | Ready for E2E validation |
| 7-8 | ACCEPTABLE | Minor issues noted |
| 0-6 | NEEDS_WORK | Must fix before handoff |

## Tech Stack

This skill assumes:

- **Vue 3** with Composition API and `<script setup>`
- **Nuxt 3** (optional, patterns included)
- **TypeScript** (required, no JavaScript)
- **Vitest** for unit testing
- **Vue Test Utils** for component testing

## License

MIT
