---
name: test-automation-strategy
description: Automation + regression strategy — ROI-driven candidate selection, pyramid discipline, framework + tooling per level, flakiness policy, shared fixtures, CI integration (shard / parallel), regression cadence, visual / a11y / contract.
argument-hint: "[product + current automation state + risk]"
---

# Test Automation Strategy

You design what the team automates, at which level, with which framework, and how automation integrates into CI. Automation is investment — focus on ROI, not test-count.

## Core rules

- **Automate candidates with ROI** — stable requirements + repetitive execution + value of prevention
- **Pyramid discipline** — push coverage down: unit > component > integration > E2E
- **Flaky tests are bugs** — quarantine + root-cause; a flaky suite destroys trust
- **Shared infra (fixtures, factories, page objects)** — DRY for tests too
- **CI time matters** — shard + parallel + timeout; slow suites rot
- **Regression is a system, not a list** — curated, versioned, maintained
- **No fabricated automation state** — work from supplied code/test reality

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Product + stack** | Yes | — |
| **Current automation state** | Yes | — |
| **Risk profile** | Yes | — |
| **CI tooling** | No | Asked |
| **Pain points** (flakes / slow / low coverage) | No | Asked |
| **Existing test frameworks** | No | Asked |

## Phase 1 — Setup

```
**Product**: [name + stack]
**Current state**: [coverage %, E2E count, flake rate, CI time]
**Risk profile**: [low / medium / high]
**CI**: [GitHub Actions / GitLab / Jenkins / Buildkite]
**Pain**: [flakes / slow / low coverage / duplication]
**Existing frameworks**: [list]
```

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/test-automation-strategy/`).

## Phase 2 — Automation candidate selection

Score candidates by ROI:

| Factor | What to look for |
|---|---|
| Stable requirements | Automation pays back only if behavior is stable |
| Repetitive execution | High-frequency regression target |
| Value-of-prevention | High-risk / high-cost-of-defect flows |
| Cost to automate | Complexity + dependencies |
| Manual-effort saved | Time + error rate today |

High ROI:
- Payment flows
- Auth + authorization
- Data integrity / migrations
- Contract compatibility between services
- Critical user journeys

Low ROI:
- One-off reports
- UX tweaks likely to change
- Admin-only flows used rarely

## Phase 3 — Pyramid discipline

Target distribution (illustrative):

| Level | Count share | Run time |
|---|---|---|
| Unit | 70% | seconds |
| Component | 15% | tens of seconds |
| Integration | 8% | minutes |
| Contract | 5% | seconds |
| E2E | 2% | minutes |

Anti-pattern — "ice cream cone" (heavy E2E, few units). Flip it.

Push coverage down:
- New bug at E2E? Add regression test one layer down.
- Duplicate coverage? Remove at upper layers.

## Phase 4 — Framework + tooling per level

| Level | Framework (examples) |
|---|---|
| Unit (TS) | Vitest / Jest |
| Unit (Java/Kotlin) | JUnit 5 + AssertJ + Mockito |
| Unit (Go) | stdlib testing + testify + mockery |
| Unit (Python) | pytest + hypothesis |
| Integration | testcontainers (DB / broker / Redis) |
| Contract | Pact Broker / Spring Cloud Contract |
| E2E (web) | Playwright (stable, parallel, tracing) |
| E2E (mobile) | Detox / Espresso / XCUITest |
| Load | k6 / Gatling / Locust |
| Visual | Chromatic / Percy / Applitools |
| Accessibility | axe-core + pa11y-ci |

Pick one per level; avoid multiple E2E frameworks.

## Phase 5 — Shared test infrastructure

- **Fixtures**: builders / factories per domain aggregate (e.g., `OrderFactory`)
- **Page / component objects** for UI E2E
- **Request/response helpers** for API tests
- **Environment + config** via test-only `.env.test` + per-suite reset
- **Seeds**: deterministic + fast + idempotent
- **Containers**: shared `testcontainers` setup with reuse flags for speed

Hand off data strategy to `test-data-management-strategy`.

## Phase 6 — Flakiness policy

Flaky = passes and fails without code change. Unacceptable in main.

Protocol:

1. **Detect**: CI flags retries; suite metrics
2. **Quarantine**: auto-skip flaky test; ticket opened; stays out until fixed or deleted
3. **Root-cause**: categorize (timing / race / order-dependence / env / test-smell / product bug)
4. **Fix or delete**: no eternal quarantine; age-out policy (e.g., 30 days)
5. **Trend**: track flake rate — spike triggers retro

Budget: flake rate target (e.g., < 0.5%) with alarms.

## Phase 7 — CI integration

- **Shard + parallel** long suites across runners
- **Fail-fast** or **fail-late** deliberately (fail-late gives full picture; fail-fast saves compute)
- **Timeouts** per test + per suite
- **Retries allowed** only with justification + visibility
- **Caches** for deps + containers
- **Trace + artifact capture** on failure (screenshots / HAR / logs)
- **Matrix** for browsers / Node versions / OS where applicable

Target: PR CI < 10 min median.

## Phase 8 — Regression strategy

| Strategy | When |
|---|---|
| **Full regression every PR** | Small codebase; fast suites |
| **Full regression nightly** | Medium suite; PR runs impact-based |
| **Impact-based (TIA)** | Large codebase; compute which tests matter per change |
| **Smoke + full on release branch** | Release-based delivery |
| **Production canary as final regression** | Mature trunk-based |

TIA tools: test-impact-analysis in Azure DevOps, Launchable, Gradle Enterprise Test Distribution.

## Phase 9 — Contract testing

- Producer + consumer pact via Pact
- Published to broker; verification in producer CI
- Contract versioning aligned with API versioning (`api-versioning-strategy`)
- Breaking contract change blocks deploy until consumer upgrades or compat shim added

## Phase 10 — Visual + accessibility automation

### Visual regression

- Component-level snapshots (Storybook + Chromatic)
- Page-level visual checks only for stable flows
- Approve changes explicitly; avoid rubber-stamp
- Browser/viewport matrix defined

### Accessibility

- axe-core in unit / component tests for new UI
- pa11y-ci on representative pages in CI
- Manual audit quarterly for complex components
- Target: AA conformance

## Phase 11 — Maintenance

- Ownership — tests have owners (team or codeowner)
- Deletion is healthy — obsolete tests removed
- Refactor tests alongside code
- Periodic review of suite health metrics

## Phase 12 — Metrics

- Test-count per level
- Run time per level
- Flake rate
- Mean time to green after failure
- Automation share of regression
- Bug-find rate per level (bugs found at the cheapest layer is a win)

## Phase 13 — Diagrams

### Automation pyramid (target ratio)

```mermaid
xychart-beta
    title "Target test distribution"
    x-axis ["Unit", "Component", "Integration", "Contract", "E2E"]
    y-axis "% of suite" 0 --> 80
    bar [70, 15, 8, 5, 2]
```

### CI pipeline

```mermaid
flowchart LR
    PR[PR opened] --> Unit[Unit + component]
    Unit --> Int[Integration]
    Int --> Con[Contract verify]
    Con --> E2E[E2E smoke]
    E2E --> Vis[Visual]
    Vis --> A11y[a11y]
    A11y --> Ready[Ready to merge]
    Ready --> Nightly[Nightly full regression]
```

## Phase 14 — Diagram rendering

Per `diagram-rendering` mixin.

## Phase 15 — Report assembly and approval

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

Present for user approval. Save only after confirmation.

## Assessment + planning rules

- ROI-driven candidate selection
- Pyramid discipline
- Flakiness policy strict
- Shared infra DRY
- CI time targeted
- Regression as a system
- Metrics observed
- No fabricated state

## Failure behavior

| Situation | Behavior |
|---|---|
| No product state | Interview mode (§7) |
| Ice-cream-cone automation | Flag + propose inversion |
| Eternal quarantine | Enforce age-out |
| E2E-everything | Challenge; push down |
| Manual-only defence | Identify automation candidates |
| Test-data request | Redirect to `test-data-management-strategy` |
| NFR request | Redirect to `non-functional-test-planning` |
| mmdc failure | See `diagram-rendering` mixin |

## Self-check

```
[] ROI-based candidates
[] Pyramid target ratio
[] Framework per level
[] Shared fixtures + page objects
[] Flakiness policy with age-out
[] CI time target
[] Regression strategy chosen
[] Contract testing + versioning
[] Visual + a11y covered
[] Metrics + dashboards
[] Diagrams valid
[] No fabricated state
[] Report follows output contract
```
