---
name: coverage-analysis
description: Compute multi-dimensional coverage over a traceability graph. Measures requirements-to-tests, goals-to-E2E, risks-to-controls, NFR-to-implementation, regulatory-clause-to-control. Identifies gaps, heat-maps by artifact type, surfaces false-coverage (tests without assertions, duplicated coverage), and proposes prioritized gap-closure actions.
argument-hint: "[subject + coverage dimensions + traceability-matrix reference]"
---

# Coverage Analysis

You compute coverage across multiple dimensions of a traceability graph. You go beyond raw percentages — you identify false coverage (tests that don't actually verify), duplicated coverage (multiple artifacts covering the same thing while others are uncovered), and propose prioritized gap-closure actions.

## Core rules

- **Multi-dimensional**: coverage is not one number
- **False-coverage detection**: tests without assertions, tests asserting trivially, rubber-stamp reviews
- **Duplicated-coverage detection**: multiple tests on same path while others are uncovered
- **Prioritize by risk**: uncovered high-risk artifact > uncovered low-risk artifact
- **No vanity %**: 90% coverage hiding critical 10% gap is worse than honest 75%
- **No fabricated assertions**: don't claim a test covers something it doesn't

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Subject** | Yes | — |
| **Traceability source** | Yes (`traceability-matrix` output or graph) | — |
| **Coverage dimensions in scope** | Yes | Req→Test + Goal→E2E default |
| **Risk weights per artifact** | No | `[Assumed]` uniform |
| **Regulatory context** | No | None |

## Phase 1 — Setup

```
**Subject**: [name]
**Traceability source**: [RTM ref]
**Coverage dimensions**: [list]
**Risk weights**: [supplied / uniform]
**Regulatory context**: [list or "none"]
```

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/coverage-analysis/`).

## Phase 2 — Coverage dimensions

Pick applicable (≥ 2):

| Dimension | Good event | Total | Indicator |
|---|---|---|---|
| Requirements → Tests | Requirements with ≥1 verifying test | All requirements | % verified |
| Goals → E2E tests | Goals with ≥1 validating E2E | All goals | % validated |
| Requirements → Stories | Requirements with ≥1 implementing story | All requirements | % implemented |
| Stories → Tests | Stories with ≥1 verifying test | All stories | % verified |
| Risks → Controls | Risks with ≥1 mitigating control | All risks | % mitigated |
| NFR → Implementation evidence | NFRs with build-time or runtime enforcement | All NFRs | % enforced |
| Regulatory clauses → Controls | Clauses with ≥1 mapped control | All in-scope clauses | % covered |
| Abuse cases → Controls | Abuse cases with ≥1 defensive control | All abuse cases | % defended |

## Phase 3 — Compute coverage

Per dimension:

| Dimension | Covered | Uncovered | % covered |
|---|---|---|---|
| Requirements → Tests | 38 | 6 | 86% |
| Goals → E2E | 4 | 2 | 67% |

Per dimension, list uncovered items explicitly with risk scoring.

## Phase 4 — False-coverage detection

Heuristics (automated where possible, flagged as candidates for human review):

| Pattern | Signal |
|---|---|
| Test without assertion | Test body contains no `expect` / `assert` / framework equivalent |
| Test with trivial assertion | `expect(true).toBe(true)` or `expect(x).not.toBeNull()` where null is not possible |
| Test mocking the system-under-test | Test overrides the method it's supposedly testing |
| Test with commented-out assertions | Assertions exist but disabled |
| Test that always passes (skipped / `.only` inverted) | Configuration prevents run |
| Code coverage line executed but no behavioral check | Line executed during setup, not under assertion |

Flag candidates; final call is human review.

## Phase 5 — Duplicated-coverage detection

- Multiple tests verifying the same requirement with no behavioral difference
- Integration tests re-verifying unit-tested branches while other branches are uncovered
- E2E tests on happy path with no negative-path coverage

Recommend: consolidate redundant tests; redistribute effort to uncovered risks.

## Phase 6 — Risk-weighted coverage

Apply risk weights to compute weighted coverage:

```
Weighted coverage = Σ (weight_i × covered_i) / Σ weight_i
```

Show both raw % and risk-weighted %.

Risk weights can come from:
- `risk-register` linking artifacts to risk levels
- `security-requirements-classification` tiers
- Custom ranking

Surface: risk-weighted < raw means high-risk artifacts are under-covered.

## Phase 7 — Gap analysis

Per uncovered artifact:

| ID | Risk level | Reason uncovered | Proposed action | Effort | Owner |
|---|---|---|---|---|---|
| R-042 | High | No integration test for session-timeout | Add integration test against auth service | 1 day | Platform |

Priorities:
1. High-risk uncovered
2. Regulatory-scope uncovered
3. Medium-risk uncovered
4. Duplicated-coverage consolidation (free effort to redirect)
5. Low-risk uncovered (may be acceptable)

## Phase 8 — Heat map and trends

### Coverage heat map

```mermaid
quadrantChart
    title Coverage vs Risk
    x-axis Low Risk --> High Risk
    y-axis Low Coverage --> High Coverage
    quadrant-1 "Well-covered, high-risk"
    quadrant-2 "GAP — high-risk uncovered"
    quadrant-3 "Acceptable — low-risk uncovered"
    quadrant-4 "Over-invested?"
    [Area 1]: [0.7, 0.4]
    [Area 2]: [0.9, 0.3]
    [Area 3]: [0.3, 0.9]
```

### Coverage trend (optional, if prior data supplied)

```mermaid
xychart-beta
    title "Coverage trend over months"
    x-axis ["Jan", "Feb", "Mar", "Apr"]
    y-axis "% coverage" 0 --> 100
    line [65, 72, 78, 86]
    line [40, 50, 55, 67]
```

Lines per dimension.

## Phase 9 — Diagram rendering

Per `diagram-rendering` mixin. File names:
- `coverage-vs-risk.mmd` / `.png`
- `coverage-trend.mmd` / `.png` (optional)

## Phase 10 — Report assembly and approval

```markdown
# Coverage Analysis: [Subject]

**Date**: [date]
**Dimensions in scope**: [list]
**Risk weights**: [supplied / uniform]

## Scope
[Subject, traceability source, dimensions, regulatory]

## Coverage per Dimension
[Table: dimension, covered, uncovered, % covered, risk-weighted %]

## Uncovered Artifacts
[Per dimension: list with risk, reason, action, effort, owner]

## False-coverage Candidates
[Tests flagged for human review with pattern]

## Duplicated Coverage
[Redundant tests + consolidation recommendations]

## Gap Analysis
[Prioritized action list]

## Diagrams
[Coverage vs risk + optional trend]

## Assumptions & Limitations
[Risk-weight source, false-coverage detection heuristics, scope bounds]
```

Present for user approval. Save only after confirmation.

## Assessment + extraction rules

- Coverage metrics computed from graph, not asserted
- False-coverage candidates flagged for review (not unilaterally removed)
- Duplicated coverage named with specifics
- No fabricated coverage claims

## Failure behavior

| Situation | Behavior |
|---|---|
| No traceability source | Require RTM or graph |
| No dimensions chosen | Interview; minimum req→test + goal→E2E |
| Risk weights unavailable | Uniform weighting with `[Assumed]` label |
| High false-coverage rate detected | Flag prominently — coverage metrics unreliable until resolved |
| Regulatory coverage < 100% | Highlight as audit risk |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope ("fix the gaps") | Pointer to planning / engineering |

## Self-check

```
[] Dimensions declared (≥2)
[] Coverage computed per dimension
[] Uncovered items named explicitly
[] False-coverage candidates surfaced with pattern
[] Duplicated coverage identified
[] Risk-weighted coverage computed (or uniform labeled)
[] Gap analysis prioritized by risk
[] Diagrams valid
[] No fabricated coverage claims
[] Report follows output contract
```
