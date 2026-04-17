# Test Automation Strategy — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | test-automation-strategy |
| **Version** | 1.0.0 |
| **Purpose** | Produces an automation + regression strategy. Selects automation candidates by ROI (stable requirements + repetitive execution + high value-of-prevention + reasonable cost + manual-effort saved). Enforces pyramid discipline (target ~70/15/8/5/2 for unit / component / integration / contract / E2E) and flags "ice-cream cone" anti-pattern. Framework + tooling per level (Vitest/Jest, JUnit+AssertJ+Mockito, Go testing+testify+mockery, pytest+hypothesis, testcontainers for integration, Pact for contract, Playwright/Detox for E2E, k6 for load, Chromatic/Percy for visual, axe-core/pa11y-ci for a11y) with one-per-level rule. Shared test infrastructure: domain factories, page/component objects, request/response helpers, test-env config, deterministic fast idempotent seeds, testcontainers reuse. Flakiness policy: detect via retries + metrics, quarantine with ticket, root-cause categories (timing/race/order/env/test-smell/product-bug), 30-day age-out, flake-rate budget. CI integration: shard + parallel, deliberate fail-fast vs fail-late, timeouts, retries with justification, trace/screenshot/HAR on failure, matrix for browsers/Node/OS, PR-CI <10 min median. Regression strategy per context (full per-PR / nightly / impact-based TIA via Launchable or Gradle / smoke+full on release branches / prod canary as final gate). Contract testing with Pact broker + API versioning alignment. Visual regression (component-level snapshots + stable-flow pages) + accessibility (axe-core unit + pa11y-ci CI + quarterly manual audit for complex components) targeting AA. Maintenance (ownership via codeowners + healthy deletion + periodic suite-health review). Metrics (count per level, run-time, flake rate, time-to-green, automation share, bug-find rate per level). Mermaid target pyramid + CI flow with PNG export. Hand-offs to `test-strategy-plan`, `test-data-management-strategy`, `non-functional-test-planning`. |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Adopting automation from scratch
- Re-balancing an inverted pyramid
- Flakiness epidemic
- Adopting Pact / TIA / visual / a11y automation

## When not to use

- Overall test strategy → `test-strategy-plan`
- Test data → `test-data-management-strategy`
- Performance or security → `non-functional-test-planning`
- DoR / DoD → `definition-of-ready-done`

---

## Required input

| Field | Description |
|---|---|
| **Product + stack** | Identifier |
| **Current automation state** | Coverage, E2E count, flake rate, CI time |
| **Risk profile** | Low / medium / high |

## Optional input

| Field | Description | Default |
|---|---|---|
| **CI tooling** | Actions / GitLab / Jenkins | Asked |
| **Pain points** | Flakes / slow / coverage | Asked |
| **Existing frameworks** | List | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/test-automation-strategy/` |

## Input schema

```
input:
  required:
    product_stack: string
    current_state: object
    risk_profile:
      type: string
      enum: [low, medium, high]
  optional:
    ci_tooling: string
    pain_points: array[string]
    existing_frameworks: array[string]
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path: string
```

---

## Processing rules

### Phase 1 — Setup
Product, stack, state, risk, CI, pain, frameworks.

### Phase 2 — Candidate selection
ROI factors.

### Phase 3 — Pyramid discipline
Target ratio + push-down rules.

### Phase 4 — Framework per level
One per level.

### Phase 5 — Shared infrastructure
Factories + page objects + seeds + containers.

### Phase 6 — Flakiness policy
Detect / quarantine / root-cause / age-out / budget.

### Phase 7 — CI integration
Shard / parallel / timeouts / retries / capture / matrix.

### Phase 8 — Regression strategy
Full / nightly / TIA / smoke+full / prod canary.

### Phase 9 — Contract testing
Pact + versioning alignment.

### Phase 10 — Visual + a11y
Scope + tools + review cadence.

### Phase 11 — Maintenance
Ownership + deletion + review.

### Phase 12 — Metrics
Test-count / run-time / flake / MTTG / automation share / bug-find rate.

### Phase 13 — Diagrams
Pyramid + CI flow.

### Phase 14 — Diagram rendering
Per mixin.

### Phase 15 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Test Automation Strategy: [Product]

**Date**: [date]
**Product**: [...]
**Current state**: [...]
**Target state**: [...]

## Scope
## Candidate Selection (ROI)
## Pyramid Discipline
## Framework + Tooling per Level
## Shared Test Infrastructure
## Flakiness Policy
## CI Integration
## Regression Strategy
## Contract Testing
## Visual + Accessibility
## Maintenance
## Metrics
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Target pyramid** — Mermaid `xychart-beta`
- **CI flow** — Mermaid `flowchart LR`

---

## Assessment and planning policy

- ROI-based candidates
- Pyramid discipline
- Flakiness strict
- Shared infra
- CI time targeted
- Regression as a system
- Metrics observed
- No fabricated state

---

## Self-check

```
[] ROI-based candidates
[] Pyramid target
[] Framework per level
[] Shared fixtures + page objects
[] Flakiness policy + age-out
[] CI time target
[] Regression strategy
[] Contract testing + versioning
[] Visual + a11y
[] Metrics + dashboards
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No state | Interview mode (§7) |
| Ice-cream-cone | Flag + invert |
| Eternal quarantine | Enforce age-out |
| E2E-everything | Push down |
| Test data request | Redirect |
| NFR request | Redirect |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Coverage targets per level
- [ ] One framework per level
- [ ] Flakiness quarantine + age-out
- [ ] CI time under budget
- [ ] Regression strategy matches scale
- [ ] Contract tests versioned
- [ ] Visual + a11y thresholds

---

## Examples

### Normal cases

**1. New web SaaS**
- Expected: Heavy unit (Vitest) + Playwright smoke + Pact + Chromatic + axe-core; PR CI 7 min; nightly full regression

**2. Legacy Java service**
- Expected: JUnit5 + AssertJ; add characterization tests; Pact producer-side; integration via testcontainers; reduce flaky Selenium E2E

**3. Mobile app**
- Expected: Detox + Espresso + XCUITest on P0 flows; Appium on device cloud; visual + a11y per platform; shard across device matrix

**4. Large monorepo**
- Expected: Impact-based testing via Launchable; per-package shards; cache reuse; matrix strategic

**5. Flakiness epidemic**
- Expected: Policy rollout + auto-quarantine + root-cause trending; temporary moratorium on new E2E

### Edge cases

**6. Contract breaking churn**
- Input: Frequent consumer/provider churn
- Expected: Pact broker + webhook verification; API version pinning; compat shim pattern

**7. Visual regression noise**
- Input: Too many false positives
- Expected: Component-only snapshots; narrow pixel tolerance; explicit baseline review

**8. Small team, tight CI budget**
- Expected: Impact-based; smoke on PR; nightly full; PR pyramid-driven; strict flake budget

### Failure cases

**9. No current state**
- Input: "Automate everything"
- Expected: Interview — state + risk + pain

**10. Implementation request**
- Input: "Write the tests"
- Expected: "Strategy only."
