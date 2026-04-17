# Performance Budgeting — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | performance-budgeting |
| **Version** | 1.0.0 |
| **Purpose** | Sets concrete, measurable performance budgets for a web page / flow, mobile app, API / service, or backend / data pipeline. Defines targets with percentiles (p50 / p75 / p95 / p99), decomposes the top-level target into per-component allocations that must sum, names a measurement plan per budget (RUM / synthetic / CI check / load test with specific tool and cadence), attaches a violation policy with concrete triggers and actions (warn / block / rollback / page), and declares a degradation strategy for graceful failure under load. Covers Core Web Vitals (LCP / INP / CLS / TTFB), payload sizes (JS / CSS / images / fonts / third-party), API latency and throughput, cold-start, mobile app-start and frame rate, backend job duration, queue latency, and CPU / memory. Segments budgets by device tier, network, and geography where relevant. Mermaid stacked allocation and measurement-coverage diagrams with PNG export. |
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

- Setting measurable non-functional requirements for performance before build
- Pre-release performance gating in CI/CD
- Production reliability review with concrete SLIs below user expectations
- Post-incident tightening: translating a production issue into budgets

## When not to use

- Availability / reliability SLO/SLI → `slo-sli-definition`
- Customer-facing SLA agreement → `sla-definition`
- Scalability modeling → `scalability-modeling`
- Security requirements → `security-requirements-classification`

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Product / page / flow / API / service / pipeline |
| **Context type** | web / mobile / API / backend / data-pipeline |

## Optional input

| Field | Description | Default |
|---|---|---|
| **User expectations / research** | Field evidence for target selection | Category defaults with `[Assumed]` |
| **Target environments** | Device / network / geography | Desktop + 4G mobile for web |
| **Traffic profile** | Peak RPS, average, bursts | Asked |
| **Existing budgets** | Current thresholds | Elicited |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/performance-budgeting/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    context_type:
      type: string
      enum: [web, mobile, api, backend, data-pipeline]
  optional:
    target_environments: list[string]
    traffic_profile: object
    existing_budgets: object
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
Collect subject + context; interview mode (§7) if missing.

### Phase 2 — Budget categories
Apply category defaults tailored to context type; adjust per user expectations.

### Phase 3 — Decomposition
Per top-level budget: allocate to components; totals must sum.

### Phase 4 — Measurement plan
Per budget: method (RUM / synthetic / CI / load test), tool, cadence, owner. ≥2 methods for critical budgets.

### Phase 5 — Violation policy
Warn / block / rollback / page triggers.

### Phase 6 — Degradation strategy
What degrades before failing; user impact named.

### Phase 7 — Segmentation
Device / network / geography splits.

### Phase 8 — Diagrams
Budget allocation stacked, measurement coverage flowchart.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Performance Budget: [Subject]

**Date**: [date]
**Context**: [type]
**Target environments**: [list]

## Scope
[Subject, context, environments, traffic]

## Budgets
[Category + metric + target percentile + rationale]

## Decomposition
[Component allocations summing to top-level]

## Measurement Plan
[Method, tool, cadence, owner per budget]

## Violation Policy
[Warn / block / rollback / page triggers]

## Degradation Strategy
[Degradation steps with user impact]

## Segmentation
[Device / network / geography]

## Diagrams
[Allocation + coverage]

## Assumptions & Limitations
[`[Assumed]` targets, data gaps]
```

### Diagrams

- **Budget allocation** — Mermaid `xychart-beta`
- **Measurement coverage** — Mermaid `flowchart`

---

## Generation and planning policy

- Percentiles always stated
- Totals must sum
- No fabricated field benchmarks
- Measurement tooling named
- Violation policy concrete

---

## Self-check

```
[] Subject + context
[] Percentiles on every target
[] Decomposition sums
[] Measurement plan complete
[] Violation policy
[] Degradation strategy
[] Segmentation if relevant
[] `[Assumed]` where no field data
[] Diagrams valid
[] No fabricated benchmarks
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject | Interview mode (§7) |
| No traffic profile | Category defaults with `[Assumed]` |
| Target below physical limits | Flag infeasible |
| Decomposition mismatch | Surface and ask |
| Measurement tooling absent | List as prerequisite |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | "Budgets only; optimization is build work." |

---

## Quality checks

- [ ] Percentiles named
- [ ] Sums match
- [ ] Measurement tools named
- [ ] Violation policy concrete
- [ ] Degradation strategy
- [ ] Segmentation
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. E-commerce product page**
- Input: Product page, web, peak 5k RPS, mobile + desktop
- Expected: LCP p75 ≤ 2.5s, INP p75 ≤ 200ms, CLS ≤ 0.1, JS ≤ 170kb, images ≤ 500kb; decomposition by component; RUM + CI bundle-size check.

**2. API service**
- Input: Payment API, p50 ≤ 100ms, p99 ≤ 500ms
- Expected: Per-endpoint budgets, error rate < 0.1%, throughput 2k RPS, APM + load-test measurement, rollback on p99 > 800ms for 5 min.

**3. Mobile app**
- Input: iOS app, cold start, frame rate
- Expected: Cold start ≤ 2s p95, 60fps sustained, dropped-frame rate < 1%, binary size < 50mb, segmented by device tier.

**4. Batch pipeline**
- Input: Daily ETL job, freshness budget
- Expected: Job duration p95, queue latency, data freshness target (e.g., fresh by 09:00 CET), CPU/memory per worker, Page on SLA miss.

**5. Web flow with third-party**
- Input: Checkout flow with payment processor + analytics
- Expected: Third-party budget (200kb) split per vendor with ownership; degradation: disable analytics first if budget breached.

### Edge cases

**6. Geographically split users**
- Input: Global product with LatAm + APAC tail
- Expected: Segmented budgets per region; CDN strategy prerequisite; `[Assumed]` targets for regions without RUM data.

**7. Legacy product with unknown baseline**
- Input: No existing RUM
- Expected: Recommend RUM install as prerequisite; propose budgets as targets with confidence low; plan first-30-day measurement before committing violations.

**8. Hard physical constraint**
- Input: "LCP must be < 500ms globally" on a product with Asian users
- Expected: Flag infeasible (speed-of-light to Asia ≈ 250ms RTT); recommend regional CDN or loosened target.

### Failure cases

**9. No subject**
- Input: "Set performance budgets"
- Expected: Interview — "Which product / page / flow / service, and what context type?"

**10. Out of scope**
- Input: "Optimize the app and set budgets"
- Expected: "Budgets only. Optimization is implementation — budgets are the target for that work."
