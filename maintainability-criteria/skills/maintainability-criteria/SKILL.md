---
name: maintainability-criteria
description: Define maintainability criteria for a codebase or service. Covers code complexity caps (cyclomatic / cognitive / file size), test coverage thresholds (unit / integration / E2E), documentation requirements, modularity rules, review gates, refactoring budget, dependency policy, and deprecation playbook. Wires to CI checks and review process.
argument-hint: "[codebase / service + language/stack]"
---

# Maintainability Criteria

You define measurable maintainability criteria for a codebase or service. Output is a set of enforceable rules (CI-checkable where possible), with explicit tolerance for legacy code and a refactoring budget.

## Core rules

- **Measurable**: every criterion maps to a metric or CI check
- **Stack-aware**: thresholds tuned to language/framework norms
- **Legacy tolerance**: existing violations grandfathered with a drawdown schedule — no boiling-the-ocean
- **Refactoring budget**: named share of each iteration
- **No vanity coverage**: coverage thresholds by test layer and risk, not blanket 80%
- **No fabricated industry averages**: comparisons grounded or labeled `[Assumed]`

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Codebase / service** | Yes | — |
| **Language / stack** | Yes | — |
| **Team size** | No | Asked |
| **Existing CI tooling** | No | Asked |
| **Legacy state** | No | Greenfield default |

## Phase 1 — Setup

```
**Codebase**: [name]
**Language / stack**: [e.g., TypeScript + React + Node]
**Team size**: [N]
**Existing CI tooling**: [list]
**State**: [greenfield / existing]
```

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/maintainability-criteria/`).

## Phase 2 — Complexity caps

| Metric | Threshold (default) | Tool |
|---|---|---|
| Cyclomatic complexity per function | ≤ 10 (CI warn at 8) | ESLint complexity / flake8 mccabe / SonarQube |
| Cognitive complexity | ≤ 15 | SonarQube cognitive |
| File length | ≤ 500 lines | lint rule |
| Function length | ≤ 50 lines | lint rule |
| Module depth (nesting) | ≤ 4 | lint rule |
| Parameters per function | ≤ 4 | lint rule |

Adjust per stack:
- Strongly-typed languages may allow higher function length
- Test files exempt from some rules

## Phase 3 — Test coverage

Per test layer:

| Layer | Coverage target | Rationale |
|---|---|---|
| Unit | ≥ 70% statements, ≥ 60% branches | Fast feedback; catches logic bugs |
| Integration | ≥ critical path coverage (declare paths) | Detects wiring issues |
| E2E | Cover top user journeys (enumerate) | User-visible regression |
| Contract | All external API contracts | Prevents cross-service breakage |

Rule: don't aim for 100% on any layer; diminishing returns, encourages gaming.

Critical-path coverage means named paths are covered, not just a %.

## Phase 4 — Documentation requirements

| Artifact | When required |
|---|---|
| README | Every repo / service |
| ADR (Architecture Decision Record) | Non-reversible architectural choices |
| API docs | Every public / internal-shared API |
| Runbook | Every on-call-paged service |
| Onboarding | Update quarterly or on major change |

## Phase 5 — Modularity rules

- **Bounded contexts**: named boundaries; no cross-import of internals
- **Dependency direction**: acyclic (detect with tooling, e.g., madge / deptree)
- **Public API**: explicit exports; internal marked private
- **Coupling metric**: afferent × efferent watched; avoid god modules

## Phase 6 — Review gates

| Gate | Required check |
|---|---|
| PR | ≥ 1 reviewer (≥ 2 for sensitive paths) |
| Tests | New code has tests; no net-decrease in coverage |
| Complexity | CI fails if thresholds exceeded on new code |
| Docs | If behavior changes, docs updated |
| Performance | Budget check (link `performance-budgeting`) |
| Security | SAST + dependency audit on PR |

Legacy code exceptions allowed but tracked.

## Phase 7 — Refactoring budget

Declare a share of each iteration for maintenance work:

| Work type | Share |
|---|---|
| Features | ~70% |
| Refactoring | ~15% |
| Tech debt reduction | ~10% |
| Upkeep (deps, minor fixes) | ~5% |

Rule: never 0% on maintenance; short-term wins become medium-term paralysis.

## Phase 8 — Dependency policy

- **Version pinning**: exact for libraries; ranges allowed for dev tooling
- **License allow-list**: declared (e.g., MIT / Apache-2.0 / BSD / ISC)
- **Deprecated / unmaintained flagging**: scanning (e.g., npm audit / deprecated flag)
- **Review cadence**: dependency updates weekly / monthly
- **Security advisories**: patched within SLA (critical ≤ 7 days, high ≤ 30 days)
- **SBOM**: generated on build (especially for regulated products)

## Phase 9 — Deprecation playbook

For internal APIs / modules / services being phased out:
- **Deprecation notice**: minimum N months warning
- **Migration guide**: provided
- **Sunset date**: named
- **Removal criteria**: metrics on usage to justify removal
- **Communication plan**: internal + external

## Phase 10 — Legacy tolerance & drawdown

For existing codebase with violations:
- Grandfather existing violations — don't boil the ocean
- CI checks apply to new + modified code only
- Drawdown schedule: violation count decreases over time
- Named hot-spots get priority (high-complexity + high-change files)

## Phase 11 — Diagrams

### 1. Coverage targets per layer

```mermaid
xychart-beta
    title "Coverage targets per layer (%)"
    x-axis ["Unit", "Integration", "E2E critical paths", "Contract"]
    y-axis "%" 0 --> 100
    bar [70, 85, 100, 100]
```

### 2. Refactoring budget

```mermaid
pie title Iteration allocation
    "Features" : 70
    "Refactoring" : 15
    "Tech debt" : 10
    "Upkeep" : 5
```

### 3. Legacy drawdown (if existing product)

```mermaid
xychart-beta
    title "Complexity violations over quarters"
    x-axis ["Now", "Q1", "Q2", "Q3", "Q4"]
    y-axis "Violations" 0 --> 200
    line [180, 150, 120, 90, 60]
```

## Phase 12 — Diagram rendering

Per `diagram-rendering` mixin. File names:
- `coverage-targets.mmd` / `.png`
- `refactoring-budget.mmd` / `.png`
- `legacy-drawdown.mmd` / `.png` (if existing)

## Phase 13 — Report assembly and approval

```markdown
# Maintainability Criteria: [Codebase]

**Date**: [date]
**Language / stack**: [stack]
**Team size**: [N]
**State**: [greenfield / existing]

## Scope
[Codebase, stack, team, CI tooling, state]

## Complexity Caps
[Metrics + thresholds + tool]

## Test Coverage
[Per layer with rationale]

## Documentation Requirements
[Artifact → when required]

## Modularity Rules
[Boundaries, dependency direction, public API, coupling]

## Review Gates
[PR / tests / complexity / docs / perf / security]

## Refactoring Budget
[Share per iteration]

## Dependency Policy
[Pinning, license allow-list, vulnerability SLAs, SBOM]

## Deprecation Playbook
[Notice, guide, sunset, communication]

## Legacy Tolerance & Drawdown
[Grandfathering + schedule]

## Diagrams
[Coverage + budget + optional drawdown]

## Assumptions & Limitations
[Stack-specific adjustments, CI-tooling gaps]
```

Present for user approval. Save only after confirmation.

## Generation + planning rules

- Every criterion measurable / CI-checkable where possible
- Thresholds tuned to stack
- Legacy tolerance explicit
- Refactoring budget non-zero
- No fabricated industry averages

## Failure behavior

| Situation | Behavior |
|---|---|
| No codebase or stack | Interview mode (§7) |
| Greenfield without standards | Propose defaults for the stack |
| Existing codebase with deep debt | Tolerance + drawdown rather than uniform enforcement |
| Zero refactoring budget proposed | Push back; require non-zero |
| CI tooling absent | List as prerequisite |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope (e.g., "refactor now") | "Criteria only; refactoring is engineering work." |

## Self-check

```
[] Stack-tuned thresholds
[] Coverage per layer with rationale
[] Critical paths named for E2E / integration
[] Review gates concrete
[] Refactoring budget non-zero
[] Dependency policy with SLAs
[] Deprecation playbook
[] Legacy tolerance + drawdown if existing
[] All metrics map to CI tooling
[] Diagrams valid
[] No fabricated industry averages
[] Report follows output contract
```
