# Metric Definition — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | metric-definition |
| **Version** | 1.0.0 |
| **Purpose** | Designs a coherent metric system for a product, initiative, or team: one North Star (user-value oriented, not reflexively revenue), 3–5 input drivers that multiplicatively or additively decompose to the North Star, leading vs lagging signals per driver (with explicit time lag and `[Assumed leading]` label when predictive evidence is absent), guardrails with regression tolerances, counter-metrics paired with leading metrics to prevent gaming, and an operational definition per metric (precise formula, numerator, denominator, time window, population, exclusions, data source, owner, review cadence). Sets target / threshold / range per metric depending on maturity. Produces a measurement-readiness assessment flagging instrumentation gaps rather than hiding them. Mermaid metric tree and optional leading-to-lagging timeline with PNG export. Feeds `ab-hypothesis-framing` and `okr-definition`. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Setting up a metric system for a product, team, or initiative
- Defining OKR key results that require precise operationalization
- Preparing metrics ahead of an experimentation program (`ab-hypothesis-framing`)
- Audit / cleanup of an existing metric set that has drifted into dashboard sprawl

## When not to use

- OKR structure itself → `okr-definition`
- Single experiment design → `ab-hypothesis-framing`
- Opportunity sizing → `opportunity-scoring`
- Financial forecasting → `financial-forecasting`

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Product, initiative, or team |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Purpose** | strategy / OKR / experimentation / ops | Asked |
| **Known metrics** | Existing set | Elicit + propose |
| **Data sources** | Warehouses, analytics, event stream | Asked |
| **Time horizon** | Months | 12 |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/metric-definition/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
  optional:
    purpose:
      type: string
      enum: [strategy, OKR, experimentation, ops]
    known_metrics: list[string]
    data_sources: list[string]
    horizon_months:
      type: integer
      default: 12
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
Collect subject + purpose; interview mode (§7) if missing.

### Phase 2 — North Star
One user-value-oriented top-line outcome.

### Phase 3 — Input drivers
3–5 drivers decomposing to North Star (multiplicative or additive).

### Phase 4 — Leading vs lagging
Per driver: lagging + leading + time lag. `[Assumed leading]` if no predictive evidence.

### Phase 5 — Guardrails
With tolerances.

### Phase 6 — Counter-metrics
Per leading metric.

### Phase 7 — Operational definition
Per metric: formula, source, population, exclusions, owner, cadence.

### Phase 8 — Targets & thresholds
Per metric maturity: target + threshold OR range OR threshold-only (guardrails).

### Phase 9 — Metric tree
Mermaid flowchart.

### Phase 10 — Measurement readiness
Source / definition / baseline / target status per metric.

### Phase 11 — Diagrams
Metric tree, optional leading-to-lagging timeline.

### Phase 12 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 13 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Metric Definition: [Subject]

**Date**: [date]
**Purpose**: [purpose]
**Time horizon**: [N months]

## Scope
[Subject, purpose, horizon, data sources]

## North Star
[Name, formula, rationale]

## Input Drivers
[3–5 with causal link]

## Leading vs Lagging
[Per driver with time lag]

## Guardrails
[With tolerances]

## Counter-metrics
[Per leading]

## Operational Definitions
[Per metric: formula, numerator, denominator, window, population, exclusions, source, owner, cadence]

## Targets & Thresholds
[Per metric]

## Metric Tree
[Diagram]

## Measurement Readiness
[Per metric: source / definition / baseline / target]

## Recommendations
[Instrumentation, cadence, review structure; downstream skill pointers]

## Assumptions & Limitations
[`[Assumed leading]`, gaps, unresolved definitions]
```

### Diagrams

- **Metric tree** — Mermaid `flowchart`
- **Leading → Lagging timeline** — Mermaid `timeline` (optional)

---

## Generation and planning policy

- North Star reflects user value
- Drivers decompose cleanly
- Operational definitions unambiguous
- `[Assumed leading]` when predictive evidence missing
- Counter-metrics paired with leading
- No fabricated data sources

---

## Self-check

```
[] One North Star (user-value)
[] 3–5 drivers decomposing to it
[] Leading + lagging + time lag per driver
[] Guardrails with tolerances
[] Counter-metric per leading
[] Operational definition per metric
[] Target / threshold / range per metric
[] Metric tree diagram valid
[] `[Assumed leading]` labels applied
[] Instrumentation gaps called out
[] No fabricated sources
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject | Interview mode (§7) |
| North Star = revenue reflexively | Challenge; surface user-value alternatives |
| Drivers don't decompose cleanly | Propose alternative decomposition |
| Leading without predictive evidence | `[Assumed leading]` + validation recommendation |
| Data source unavailable | Flag as instrumentation gap |
| Single metric proposed | Elicit guardrails + counter-metrics |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] North Star user-value oriented
- [ ] 3–5 drivers with causal link
- [ ] Leading / lagging with time lag
- [ ] Guardrails + tolerances
- [ ] Counter-metrics
- [ ] Operational definitions complete
- [ ] Targets / thresholds set
- [ ] Metric tree valid
- [ ] Instrumentation gaps surfaced
- [ ] No fabricated sources

---

## Examples

### Normal cases

**1. SaaS product**
- Input: Subject = project-management SaaS, purpose = strategy
- Expected: North Star "WAU completing ≥1 task-update per week"; drivers = activation rate × task-update frequency × team-size growth; leading = onboarding completion, invite-send rate; guardrails = churn, latency, support volume; counters = activation vs signup count.

**2. E-commerce**
- Input: Subject = DTC e-commerce, purpose = OKR
- Expected: North Star "12-month repeat-purchase rate"; drivers = acquisition × first-purchase conversion × repeat-purchase conversion × AOV; guardrails = refund rate, ticket volume; counters = repeat conversion vs discount depth.

**3. Content platform**
- Input: Content/media
- Expected: North Star = "time on quality content"; drivers = content supply × discovery success × retention; counters = quality score per leading engagement metric (prevents clickbait).

**4. Dev tools**
- Input: API / SDK
- Expected: North Star = "weekly successful integrations"; drivers = signups × first-API-call conversion × retention; leading = time-to-first-API-call; guardrails = error rate, docs satisfaction.

**5. Fintech payments**
- Input: Payments platform
- Expected: North Star = "payment volume processed without error"; drivers = merchant count × transaction count per merchant × success rate; guardrails = fraud rate, chargeback rate, regulatory incidents.

### Edge cases

**6. Low-data startup**
- Input: Early-stage with little historical data
- Expected: Drivers proposed but most metrics labeled "range" rather than "target"; instrumentation recommendations dominate.

**7. Platform serving multiple personas**
- Input: Two-sided marketplace
- Expected: North Star per side OR combined "matches" metric; drivers split by side; guardrails include balance metrics (e.g., supply/demand ratio).

**8. Revenue as North Star resisted**
- Input: User insists "revenue is our North Star"
- Expected: Surface trade-off: revenue as lagging outcome; propose underlying user-value driver as North Star and revenue as guardrail / verified outcome.

### Failure cases

**9. No subject**
- Input: "Define some metrics"
- Expected: Interview — "Which subject, and for what purpose (strategy / OKR / experimentation / ops)?"

**10. Out of scope**
- Input: "Define metrics and write our OKRs"
- Expected: "This skill defines metrics. OKR structure (objectives, key results, cadence) belongs in `okr-definition`."
