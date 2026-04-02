# Front-End Engineering

## Metadata

| Field | Value |
|---|---|
| `name` | front-end-engineering |
| `purpose` | Generates production-ready front-end web solutions from a complete user story. Analyzes the story, detects the project context, produces a traceability matrix, generates source and test files, and delivers a test report proving acceptance criteria are met. |
| `primary_category` | `generation` |
| `secondary_category` | `assessment` |
| `output_mode` | `hybrid` |
| `version` | `1.0.0` |

---

## When to Use

- User provides a complete user story with acceptance criteria for a front-end feature.
- Building pages, components, layouts, client-side logic, styling.
- Working in any major front-end framework (React, Vue, Angular, Nuxt, Next.js) or vanilla HTML/CSS/TS/JS/SCSS.
- Existing codebase provides sufficient context for framework and convention detection.

## When Not to Use

- Backend code generation.
- Database schema design.
- DevOps/CI configuration.
- API design.
- User story is incomplete — the skill rejects with a report instead.
- User story requires non-front-end work — the skill rejects with a scope report instead.

---

## Required Input

| Field | Description |
|---|---|
| `user_story` | Complete user story containing: narrative (As a... I want... So that...), acceptance criteria (testable), technical constraints, definition of done. This is the contract between assigner and assignee. |

## Optional Input

None. The user story is the full contract.

## Input Schema

```yaml
user_story:
  type: string
  required: true
  description: >
    A well-formed user story that serves as the contract between assigner
    and assignee. Must contain: narrative, acceptance criteria, technical
    constraints, and definition of done. Incomplete stories are rejected
    with a structured report.
```

---

## Processing Rules

### Phase 1 — Analyze

1. **Validate user story completeness.** Check for:
   - Narrative (As a... I want... So that...)
   - Acceptance criteria (must be testable and unambiguous)
   - Technical constraints
   - Definition of done
   - If any required elements are missing or acceptance criteria are vague/untestable, **reject** with a structured report. Do not suggest fixes.
2. **Scope check.** Determine if the user story requires non-front-end work (backend, database, DevOps, API). If so, **reject** with a scope report listing which elements are out of scope.
3. **Detect project structure.** Scan the codebase:
   - `package.json` for framework and dependency detection
   - Existing directory structure and file organization patterns
   - Configuration files (tsconfig, vite.config, next.config, nuxt.config, angular.json, etc.)
4. **Detect frameworks.** Identify which framework(s) are in use. If no codebase exists or detection is ambiguous, ask the user.
5. **Detect practices.** Identify existing code conventions: naming patterns, styling approach, state management, testing patterns, component patterns.
6. **Load best practices.** Read the relevant best practice files from `context/best-practices/` based on detected technologies. Always load `quality-attributes.md`.
7. **Produce analysis document** containing:
   - Story validation result (pass/fail with details)
   - Project structure detection results
   - Frameworks detected
   - Practices detected
   - Best practices that will be applied

### Phase 2 — Plan

1. **Create traceability matrix** mapping each acceptance criterion to:
   - Planned implementation (which files, components, functions)
   - Planned tests (which test files, test cases)
2. The matrix serves as the contract for the remaining phases.

### Phase 3 — Produce

1. **Generate source files** following:
   - Existing project structure and conventions (even if they deviate from best practices)
   - Detected framework patterns
   - Best practices from loaded reference files
   - Quality attributes from `quality-attributes.md`
2. Files include: components, pages, styles, types, utilities as needed by the user story.
3. Place files according to the detected project structure.

### Phase 4 — Test

1. **Generate test files** with:
   - Unit tests mapping to each acceptance criterion
   - Integration tests where acceptance criteria span multiple components
   - Each test traceable to the traceability matrix
2. **Generate acceptance checklist** showing how each criterion is addressed in code.

### Phase 5 — Report

1. **Produce test report** containing:
   - Pass/fail status per acceptance criterion
   - Each test mapped back to the traceability matrix
   - Any existing codebase patterns that deviate from best practices (flagged as notes, not blocking)

---

## Output Contract

Five artifacts delivered sequentially:

### 1. Analysis Document

```markdown
## Analysis

### Story Validation
[Pass or Reject with details]

### Project Structure
[Detected directory layout and conventions]

### Frameworks Detected
[Framework name(s) and version(s)]

### Practices Detected
[Naming conventions, styling approach, state management, testing, component patterns]

### Best Practices Applied
[Which reference files are loaded and relevant]
```

### 2. Traceability Matrix

```markdown
## Traceability Matrix

| # | Acceptance Criterion | Implementation | Test(s) |
|---|---|---|---|
| AC-1 | [criterion text] | [file:function/component] | [test file:test name] |
| AC-2 | ... | ... | ... |
```

### 3. Source Files

Generated code files placed in the detected project structure.

### 4. Test Files

Generated test files with tests traceable to the matrix.

### 5. Test Report

```markdown
## Test Report

### Results

| # | Acceptance Criterion | Test | Status | Notes |
|---|---|---|---|---|
| AC-1 | [criterion] | [test name] | Pass/Fail | [details] |

### Best Practice Deviations

| # | Pattern | Best Practice | Severity | Notes |
|---|---|---|---|---|
| 1 | [detected pattern] | [recommended practice] | Info | [explanation] |
```

---

## Generation Policy

| Aspect | Declaration |
|---|---|
| **What may be invented** | Implementation details: component structure, function bodies, styling, test assertions, file organization within detected patterns |
| **What must be grounded** | Acceptance criteria (from user story), project conventions (from codebase detection), framework patterns (from best practice files) |
| **What assumptions are allowed** | Default styling approach if not detectable, test framework if not configured, component granularity |
| **What must never be fabricated** | Acceptance criteria not in the user story, test results, framework features that do not exist |

**Creativity level:** `low` — implementation choices constrained by user story and existing codebase patterns.

---

## Self-Check

```
□ Does the output satisfy all acceptance criteria from the user story?
□ Is every acceptance criterion traceable through matrix → code → test?
□ Are grounded claims traceable to the user story or codebase?
□ Are assumptions labeled as assumptions?
□ Does generated code follow detected project conventions?
□ Does generated code comply with loaded best practices?
□ Does generated code comply with quality attributes (accessibility, performance, security, etc.)?
□ Are no fabricated acceptance criteria or test results present?
□ Does the output match the declared format?
```

---

## Failure Behavior

| Situation | Behavior |
|---|---|
| Incomplete user story | Reject with structured report: missing required elements and vague/untestable acceptance criteria. No suggestions. |
| Out-of-scope work required | Reject with scope report: list which elements require backend, database, DevOps, or API work. |
| No codebase detected | Ask which framework to use. |
| Ambiguous framework | Ask the user to clarify. |
| Required input missing | Return structured error per foundation §7. |
| Input is not a user story | Reject: "This skill requires a well-formed user story as input." |

---

## Quality Checks

- [ ] Every acceptance criterion has at least one test.
- [ ] Every test maps back to exactly one acceptance criterion in the traceability matrix.
- [ ] Generated code follows the detected project conventions.
- [ ] Generated code complies with the relevant best practice files.
- [ ] Generated code complies with quality attributes: accessibility, performance, security, maintainability, testability, scalability, usability, reliability, portability.
- [ ] Framework-specific best practices are applied per the detected framework.
- [ ] Analysis document accurately reflects the codebase state.
- [ ] Rejection reports (when applicable) are factual and specific.

---

## Examples

### Normal Cases

**N1: React component from user story**
- Input: Complete user story for a search bar with autocomplete in a Next.js project.
- Output: Analysis (Next.js 14, App Router, Tailwind detected), traceability matrix (3 ACs → 3 components → 6 tests), source files (SearchBar client component, SearchResults server component, styles), test files (RTL tests), test report (all pass).

**N2: Vue page from user story**
- Input: Complete user story for a product listing page in a Nuxt 3 project.
- Output: Analysis (Nuxt 3, Pinia, SCSS detected), traceability matrix, page component with composable, Vitest tests, report.

**N3: Angular form component**
- Input: Complete user story for a multi-step registration form in an Angular 18 project.
- Output: Analysis (Angular 18, signals, reactive forms detected), traceability matrix, standalone components with signal inputs, Jasmine/Karma tests, report.

**N4: Vanilla HTML/CSS/JS feature**
- Input: Complete user story for an accessible accordion in a vanilla project.
- Output: Analysis (no framework, vanilla HTML/CSS/JS), semantic HTML with details/summary or ARIA, CSS with progressive enhancement, unit tests, report.

**N5: Styling-focused story**
- Input: Complete user story for responsive dashboard layout in a React project with CSS Modules.
- Output: Analysis (React, CSS Modules detected), grid/flexbox layout with container queries, responsive tests, visual checklist, report.

### Edge Cases

**E1: Mixed framework detection**
- Input: User story in a project with both Vue and React dependencies.
- Behavior: Ask user which framework applies for this feature.

**E2: Minimal codebase**
- Input: User story in a project with only `package.json` and no existing components.
- Behavior: Detect framework from dependencies, use framework defaults for conventions, note assumptions in analysis.

**E3: Story with many acceptance criteria**
- Input: User story with 15+ acceptance criteria.
- Behavior: Process all criteria. Traceability matrix has 15+ rows. All get tests.

### Failure Cases

**F1: Incomplete user story**
- Input: "Build a login page"
- Output: Rejection report listing missing elements: no narrative format, no acceptance criteria, no technical constraints, no definition of done.

**F2: Backend work required**
- Input: Complete user story that includes "Create REST API endpoint for user data"
- Output: Scope rejection report: "The following elements require non-front-end work: REST API endpoint creation (backend)."

---

## Best Practice Reference Files

The skill reads static best practice files from `best-practices/` based on detected technologies:

| File | Loaded When |
|---|---|
| `html.md` | Always |
| `css.md` | Always |
| `scss.md` | SCSS/Sass detected in project |
| `javascript.md` | Always |
| `typescript.md` | TypeScript detected in project |
| `react.md` | React detected |
| `vue.md` | Vue detected |
| `angular.md` | Angular detected |
| `nuxt.md` | Nuxt detected |
| `nextjs.md` | Next.js detected |
| `quality-attributes.md` | Always |

These files are **read-only** and contain 2025+ best practices for each technology.
