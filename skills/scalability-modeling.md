# Scalability Modeling — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | scalability-modeling |
| **Version** | 1.0.0 |
| **Purpose** | Models how a service behaves as load grows. Captures current load across relevant dimensions (request rate, concurrent users, data volume, event rate, throughput, latency targets) with utilization of key resources (CPU / memory / DB / cache / queue / network / external APIs). Projects ≥3 growth scenarios (baseline / 3× / 10× by default), identifies the dominant bottleneck per scenario with evidence, and proposes a scaling strategy that targets the specific bottleneck (vertical / horizontal / partitioning / caching / read-replica / async / CQRS / CDN / batching). Produces a capacity plan per scenario (when reached, actions needed, lead time, readiness), a cost model with per-scenario breakdown and cost-per-unit-of-load, and a risk inventory for scale-specific failure modes (thundering herd, cascading backpressure, retry storms, observability overload, schema migration). Mermaid bottleneck curve and cost-at-scale diagrams with PNG export. |
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

- Planning architecture for expected growth
- Capacity planning for a launch, marketing campaign, or geography expansion
- Post-incident hardening after capacity-related failure
- Input to architectural decisions (when to shard, when to add caching, when to split services)

## When not to use

- Single-request performance → `performance-budgeting`
- Reliability targets → `slo-sli-definition`
- Commercial commitment → `sla-definition`
- Full architecture design → future `c4-modeling` / Phase 5 skills

---

## Required input

| Field | Description |
|---|---|
| **Service** | Named service |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Current load** | RPS / CCU / data / events | `[Assumed]` |
| **Growth scenarios** | 3+ scenarios | baseline / 3× / 10× |
| **Current architecture** | Component overview | Elicited |
| **Horizon** | Months | 12 |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/scalability-modeling/` |

## Input schema

```
input:
  required:
    service:
      type: string | document_reference
  optional:
    current_load: object
    growth_scenarios: list[object]
    current_architecture: string
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
Collect service + load + scenarios.

### Phase 2 — Load dimensions
Pick relevant dimensions.

### Phase 3 — Current state
Values + utilization + headroom.

### Phase 4 — Bottleneck analysis
Per scenario: dominant bottleneck with evidence.

### Phase 5 — Strategy per bottleneck
Specific strategy + effort + cost + risk + prerequisites.

### Phase 6 — Capacity plan
Readiness per scenario.

### Phase 7 — Cost model
€/month per scenario + €/unit-load.

### Phase 8 — Risks at scale
With detection + mitigation.

### Phase 9 — Diagrams
Bottleneck curve, cost at scale.

### Phase 10 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 11 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Scalability Model: [Service]

**Date**: [date]
**Horizon**: [N months]
**Scenarios**: [list]

## Scope
[Service, architecture, horizon, scenarios]

## Load Dimensions
[Per dimension with current + source]

## Bottleneck Analysis
[Per scenario with evidence]

## Scaling Strategy
[Per bottleneck]

## Capacity Plan
[Scenario → action → lead time → readiness]

## Cost Model
[Per scenario + €/unit-load]

## Risks at Scale
[Per risk + detection + mitigation]

## Diagrams
[Bottleneck curve + cost at scale]

## Assumptions & Limitations
[`[Assumed]` values; data gaps]
```

### Diagrams

- **Bottleneck curve** — Mermaid `xychart-beta` (multi-line)
- **Cost at scale** — Mermaid `xychart-beta` (bar)

---

## Generation and planning policy

- ≥3 scenarios including baseline
- One dominant bottleneck per scenario
- Strategy targets the bottleneck specifically
- Cost per scenario + per unit
- No fabricated scaling curves

---

## Self-check

```
[] ≥3 scenarios
[] Dimensions with current + source
[] Bottleneck per scenario with evidence
[] Strategy per bottleneck
[] Capacity plan with readiness
[] Cost model with €/unit
[] Risks at scale with detection + mitigation
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No service | Interview mode (§7) |
| No load data | `[Assumed]` + recommend instrumentation |
| Single scenario only | Require ≥ 3 |
| Bottleneck unclear | Recommend load test / profiling |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | "Modeling only; implementation is engineering work." |

---

## Quality checks

- [ ] Scenarios include baseline
- [ ] Bottleneck per scenario
- [ ] Specific strategy per bottleneck
- [ ] Capacity plan readiness
- [ ] Cost model with unit cost
- [ ] Scale risks with mitigations

---

## Examples

### Normal cases

**1. SaaS growth plan**
- Input: 500 RPS today, expecting 3× in 12 months, 10× in 24
- Expected: Baseline → DB read hot; 3× → DB write + cache; 10× → shard + queue partition. Cost €7k → €18k → €53k. Strategy detailed per bottleneck with effort + lead time.

**2. Event pipeline**
- Input: Event ingestion at 2k/s, growing to 20k/s
- Expected: Baseline → single topic OK; 3× → partition; 10× → multi-region + backpressure. Queue depth alerting as key SLI.

**3. Read-heavy product**
- Input: Content catalog, 100k reads/s peak, projected 5×
- Expected: CDN + cache layer are primary strategies; DB read replicas secondary. Cost-per-RPS dropping with caching efficiency.

**4. Data-volume growth**
- Input: 50 GB today, 500 GB projected over 2 years
- Expected: Partition + retention policy + archival tier; read-latency risk at larger DB; schema migration risk flagged.

**5. Mixed dimensions**
- Input: Both CCU and event rate grow
- Expected: Per-dimension bottleneck analysis; different strategies per dimension; combined cost model.

### Edge cases

**6. Growth is flat**
- Input: No significant growth expected
- Expected: Baseline + small-growth scenario only; recommendation is "stay aware of bottlenecks at headroom boundaries"; cost model short.

**7. Capacity limit is external**
- Input: Depends on third-party API with rate limits
- Expected: External rate limit as hard bottleneck; strategy = negotiate higher limits, batch, cache, circuit-break; cost = pass-through vendor fees.

**8. Cost ceiling binding**
- Input: "Must stay under €20k/month"
- Expected: Cost constraint translated to load ceiling; may require scope or feature trade-offs; flag explicit trade-off.

### Failure cases

**9. No service**
- Input: "Model scalability"
- Expected: Interview — "Which service, and what growth do you expect?"

**10. Out of scope**
- Input: "Model scale + redesign the architecture"
- Expected: "Modeling only. Architectural redesign is future Phase 5 work."
