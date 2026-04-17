# Test Strategy + Plan — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | test-strategy-plan |
| **Version** | 1.0.0 |
| **Purpose** | Produces a test strategy + plan. Defines measurable objectives + quality goals (escape-defect rate, PR CI time, compliance evidence, rollback confidence) linked to business drivers. Scope with explicit in/out. Test levels distinct + layered (unit / component / contract / integration / system-E2E / acceptance-UAT / exploratory) with purpose, owner, and tools per level; non-functional hand-off. Environment matrix (local / CI / integration / staging / performance / UAT) with data + stability per env. Objective entry + exit criteria per level (coverage thresholds, flake policy, pass rates, dependency health). Risk-based prioritization with probability × impact matrix driving test depth per item (P0 gets regression automation + NFR + exploratory + prod asserts; P2 minimal). Tool + framework choices per level. Roles + governance (engineer owns unit/component/contract/integration, QA owns E2E + plan stewardship, SDET owns automation framework, specialists for perf/security/a11y, release manager calls go/no-go, PO signs UAT). Requirement → test case → result traceability matrix. Test plan cadence + schedule per release/sprint (cases allocated, charters, regression runs, env bookings, UAT windows, go/no-go). Defect management: severity (S1–S4) × priority (P0–P3) independent axes; triage cadence (continuous for S1, daily for S2); response + resolution SLAs; root-cause categories (missing coverage, wrong test, env/config, data, timing, third-party, requirements unclear, prod-only config); tracked + trended. Metrics dashboards (escape rate, execution time, flakiness, coverage, automation share, MTTD/MTTR) per audience. Living document with quarterly review. Hand-offs to `test-automation-strategy`, `test-data-management-strategy`, `non-functional-test-planning`, `definition-of-ready-done`, `quality-gate-definition`. Mermaid pyramid + defect lifecycle with PNG export. |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `professional` |
| **Audience** | `mixed` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- New product / feature test strategy
- Re-baselining after incident / retro
- Compliance uplift requiring codified strategy
- Onboarding a new team to a product

## When not to use

- Automation framework detail → `test-automation-strategy`
- Test data only → `test-data-management-strategy`
- Performance or security test plan → `non-functional-test-planning`
- DoR / DoD → `definition-of-ready-done`
- Review process mechanics → `quality-gate-definition`

---

## Required input

| Field | Description |
|---|---|
| **Product** | Service / feature / system |
| **Delivery model** | Trunk / release-branch / PI / waterfall |
| **Risk profile** | Low / medium / high |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Compliance** | GDPR / SOC2 / HIPAA / PCI | Asked |
| **Team skills** | Specialists available | Asked |
| **Existing tools** | Frameworks in use | Asked |
| **Current pain** | Escape defects / flakes / slow CI | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/test-strategy-plan/` |

## Input schema

```
input:
  required:
    product: string
    delivery_model: string
    risk_profile:
      type: string
      enum: [low, medium, high]
  optional:
    compliance: array[string]
    team_skills: array[string]
    existing_tools: array[string]
    current_pain: string
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
Product, delivery, risk, compliance, tools, pain.

### Phase 2 — Objectives + goals
Measurable, linked to drivers.

### Phase 3 — Scope
In / out / assumptions.

### Phase 4 — Levels
Unit / component / contract / integration / system / UAT / exploratory / NFR.

### Phase 5 — Environments
Purpose + data + stability.

### Phase 6 — Entry + exit criteria
Objective per level.

### Phase 7 — Risk-based prioritization
Probability × impact → depth.

### Phase 8 — Tools + frameworks
Per level.

### Phase 9 — Roles + governance
Whole-team responsibility.

### Phase 10 — Traceability
Req → cases → result.

### Phase 11 — Test plan
Cadence + schedule + UAT.

### Phase 12 — Defect management
Severity × priority + SLA + RCA categories.

### Phase 13 — Metrics
Escape / time / flake / coverage / MTTD.

### Phase 14 — Living documents
Quarterly review + versioning.

### Phase 15 — Diagrams
Pyramid + defect lifecycle.

### Phase 16 — Diagram rendering
Per mixin.

### Phase 17 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Test Strategy + Plan: [Product]

**Date**: [date]
**Product**: [...]
**Delivery model**: [...]
**Risk profile**: [...]
**Version**: v1.0

## Scope
## Objectives + Quality Goals
## In/Out of Scope
## Test Levels
## Environments
## Entry + Exit Criteria per Level
## Risk-Based Prioritization
## Tools + Framework Choices
## Roles + Governance
## Traceability
## Test Plan / Cadence
## Defect Management
## Metrics
## Living Documents / Review Cadence
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Pyramid** — Mermaid `graph TD`
- **Defect lifecycle** — Mermaid `stateDiagram-v2`

---

## Assessment and planning policy

- Objectives measurable
- Levels distinct
- Entry/exit objective
- Risk-based
- Defect classification + SLA + RCA
- Traceability
- Metrics
- Hand-offs
- No fabricated scope

---

## Self-check

```
[] Objectives measurable
[] Levels distinct
[] Entry/exit objective
[] Risk-based prioritization
[] Tools per level
[] Roles + governance
[] Traceability
[] Defect classification
[] Metrics dashboards
[] Living-document cadence
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No product/risk | Interview mode (§7) |
| Automation detail | Hand off |
| Perf/security | Hand off |
| Test data | Hand off |
| DoD/DoR | Redirect |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Goals tied to business drivers
- [ ] Each level has distinct purpose
- [ ] Entry/exit criteria programmatic where possible
- [ ] Risk matrix applied
- [ ] Roles cover full lifecycle
- [ ] Defect SLAs realistic
- [ ] Metrics chosen can actually be collected

---

## Examples

### Normal cases

**1. E-commerce backend**
- Input: Medium risk, trunk-based
- Expected: Pyramid + Pact contracts + Playwright E2E on P0 flows + k6 for perf spikes + SAST+SCA gates

**2. Mobile app (iOS/Android)**
- Input: Moderate risk, app-store review latency
- Expected: Detox/Espresso E2E + device matrix + visual regression + app-review staged rollout

**3. Data pipeline**
- Input: Batch + streaming
- Expected: Schema contract tests + replay suite + SLA-bound integration tests + data-quality monitors

**4. Regulated SaaS**
- Input: SOC2 + HIPAA
- Expected: Evidence-captured per release; pen-test cadence; encrypted test data

**5. Legacy refactor**
- Input: Untested codebase
- Expected: Characterization tests first; strangler boundaries with contract tests; gradual pyramid build-up

### Edge cases

**6. Flakiness epidemic**
- Expected: Flaky-test policy; auto-quarantine; weekly retrospective; root-cause trended

**7. Third-party heavy**
- Input: Many upstream vendors
- Expected: Contract tests + sandbox stubs + resiliency tests + recorded fixtures

**8. Small team, high risk**
- Expected: Hard prioritization on P0; exploratory-heavy; strong observability in prod; hand-off to on-call

### Failure cases

**9. No risk profile**
- Input: "Write a test strategy"
- Expected: Interview — product + delivery + risk

**10. Implementation**
- Input: "Write the tests"
- Expected: "Strategy + plan only."
