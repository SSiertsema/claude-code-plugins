# Maintainability Criteria — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | maintainability-criteria |
| **Version** | 1.0.0 |
| **Purpose** | Defines enforceable, CI-checkable maintainability criteria for a codebase or service tuned to its language and stack. Covers complexity caps (cyclomatic / cognitive / file length / function length / nesting / parameters), test coverage per layer (unit / integration / E2E critical paths / contract) with rationale rather than blanket percentage targets, documentation requirements (README / ADR / API docs / runbook / onboarding), modularity rules (bounded contexts / acyclic dependencies / explicit public API / coupling watch), review gates (PR reviewer count / coverage non-regression / complexity CI failure / docs update / perf budget / security scan), refactoring budget as a non-zero share of every iteration (typical 15% refactoring + 10% tech-debt), dependency policy (pinning / license allow-list / advisory SLAs / SBOM), deprecation playbook (notice / migration guide / sunset / removal criteria / communication), and legacy tolerance with an explicit drawdown schedule that grandfathers existing violations rather than boiling the ocean. Mermaid diagrams for coverage targets, refactoring budget, and legacy drawdown with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- New codebase / service: establish maintainability baseline
- Existing codebase: formalize criteria + introduce drawdown
- Engineering standards update across a company
- Post-incident: tighten review gates

## When not to use

- Performance budgets → `performance-budgeting`
- Security requirements → `security-requirements-classification`
- Accessibility → `accessibility-requirements`
- Reliability → `slo-sli-definition`

---

## Required input

| Field | Description |
|---|---|
| **Codebase / service** | Named subject |
| **Language / stack** | Primary language + framework |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Team size** | For review-gate calibration | Asked |
| **Existing CI tooling** | Linters / test runners / SAST | Asked |
| **State** | Greenfield or existing | Greenfield |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/maintainability-criteria/` |

## Input schema

```
input:
  required:
    codebase:
      type: string | document_reference
    language_stack:
      type: string
  optional:
    team_size:
      type: integer
    ci_tooling: list[string]
    state:
      type: string
      enum: [greenfield, existing]
      default: greenfield
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path:
      type: string
```

---

## Processing rules

### Phase 1 — Setup
Collect codebase + stack + state.

### Phase 2 — Complexity caps
Metrics + thresholds + tools.

### Phase 3 — Test coverage
Per-layer targets with critical-path enumeration.

### Phase 4 — Documentation requirements
Artifacts + when required.

### Phase 5 — Modularity rules
Boundaries + dependency direction + public API + coupling.

### Phase 6 — Review gates
PR / tests / complexity / docs / perf / security.

### Phase 7 — Refactoring budget
Non-zero share per iteration.

### Phase 8 — Dependency policy
Pinning + allow-list + vulnerability SLAs + SBOM.

### Phase 9 — Deprecation playbook
Notice + guide + sunset + communication.

### Phase 10 — Legacy tolerance & drawdown
Grandfathering + schedule.

### Phase 11 — Diagrams
Coverage targets, budget, optional legacy drawdown.

### Phase 12 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 13 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Maintainability Criteria: [Codebase]

**Date**: [date]
**Stack**: [stack]
**State**: [greenfield / existing]

## Scope
[Codebase, stack, team, tooling, state]

## Complexity Caps
[Metrics / thresholds / tools]

## Test Coverage
[Per layer with rationale + critical paths]

## Documentation Requirements
[Artifact → when required]

## Modularity Rules
[Boundaries + dependency + public API + coupling]

## Review Gates
[Gate → check]

## Refactoring Budget
[Allocation]

## Dependency Policy
[Pinning + licenses + SLAs + SBOM]

## Deprecation Playbook
[Notice + guide + sunset + communication]

## Legacy Tolerance & Drawdown
[Grandfathering + schedule]

## Diagrams
[Coverage + budget + optional drawdown]

## Assumptions & Limitations
[Stack adjustments, CI-tooling gaps]
```

### Diagrams

- **Coverage targets** — Mermaid `xychart-beta`
- **Refactoring budget** — Mermaid `pie`
- **Legacy drawdown** — Mermaid `xychart-beta` (existing only)

---

## Generation and planning policy

- Measurable / CI-checkable
- Stack-tuned
- Legacy tolerance explicit
- Refactoring budget non-zero
- No fabricated industry averages

---

## Self-check

```
[] Stack-tuned thresholds
[] Coverage per layer with rationale
[] Critical paths named
[] Review gates concrete
[] Refactoring budget > 0
[] Dependency policy with SLAs
[] Deprecation playbook
[] Legacy tolerance + drawdown if existing
[] Metrics map to CI tooling
[] Diagrams valid
[] No fabricated averages
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No codebase or stack | Interview mode (§7) |
| Greenfield with no standards | Propose stack defaults |
| Existing with deep debt | Tolerance + drawdown |
| Zero refactoring budget | Push back; require > 0 |
| CI tooling absent | List as prerequisite |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | "Criteria only; refactor is engineering work." |

---

## Quality checks

- [ ] Stack-tuned caps
- [ ] Per-layer coverage
- [ ] Review gates
- [ ] Non-zero refactoring budget
- [ ] Dependency SLAs
- [ ] Deprecation playbook
- [ ] Legacy drawdown if existing
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. TypeScript / React / Node greenfield**
- Input: Greenfield, TS + React + Node, 8-person team
- Expected: ESLint complexity ≤ 10, coverage: unit 70% / integration on wiring / E2E top 5 journeys; dep pinning exact; MIT/Apache license allow-list; ADR process.

**2. Python data service**
- Input: Python/FastAPI service
- Expected: mccabe / ruff thresholds; type-hint enforcement via mypy; pytest coverage with critical-path E2E; dep policy including pip-audit.

**3. Legacy Java monolith**
- Input: Existing Java monolith with known debt
- Expected: Grandfathered complexity violations; drawdown schedule over 4 quarters; new code subject to full caps; hot-spot priority list.

**4. Mobile app (iOS)**
- Input: iOS Swift app
- Expected: SwiftLint + cognitive complexity; UI test coverage of top flows; dep policy via SPM; deprecation for obsolete API levels.

**5. Monorepo**
- Input: Monorepo with multiple services
- Expected: Per-package thresholds; shared review-gate config; bounded-context rules preventing cross-service imports; acyclic dep enforcement.

### Edge cases

**6. Small team (1–2 devs)**
- Input: Solo dev or pair
- Expected: Review gate adjusted (external reviewer or delay acceptable); still enforce coverage on critical paths; emphasize ADRs for future-me.

**7. High-regulation environment**
- Input: Finance or healthcare
- Expected: Stricter security gates; SBOM mandatory; advisory SLAs tightened; audit-trail requirements on CI.

**8. Very new stack without tooling maturity**
- Input: Cutting-edge language with limited CI tools
- Expected: Flag tooling gap; propose interim manual review; recommend tooling investment.

### Failure cases

**9. No codebase / stack**
- Input: "Set maintainability criteria"
- Expected: Interview — "Which codebase and which language/stack?"

**10. Out of scope**
- Input: "Set criteria + refactor now"
- Expected: "Criteria only; refactoring is engineering work against these criteria."
