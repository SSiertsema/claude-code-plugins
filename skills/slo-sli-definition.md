# SLO / SLI Definition — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | slo-sli-definition |
| **Version** | 1.0.0 |
| **Purpose** | Defines internal Service Level Objectives and the Service Level Indicators that measure them (SRE / Google-style). Works at the user-journey level — per journey, identifies the critical SLIs across availability, latency, correctness, freshness, durability, and throughput dimensions with concrete `good events / valid events` formulas and explicit valid / invalid event rules. Sets SLO targets tighter than any external SLA with buffer shown. Computes error budget in both time and events over the measurement window (28-day rolling default). Defines two burn-rate alerts per SLO (fast-burn with short window for big outages, slow-burn with long window for leaks) with concrete thresholds. Wires the budget state (healthy / caution / exhausted / below-floor) to concrete policy actions (release velocity, freeze decisions, escalation). Includes review cadence (weekly / quarterly / post-incident). Mermaid error-budget-trend and SLO/SLA relationship diagrams with PNG export. |
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

- Establishing reliability targets for a service or critical user-journey
- Setting up error-budget policy to balance velocity and reliability
- Aligning internal targets tighter than a customer SLA
- Pre-work for SRE practices adoption

## When not to use

- External commercial commitment → `sla-definition`
- Performance budget (build-time / release gate) → `performance-budgeting`
- Scalability modeling → `scalability-modeling`

---

## Required input

| Field | Description |
|---|---|
| **Service** | Named service |
| **Critical user-journeys** | ≥1 journey whose reliability is measured |

## Optional input

| Field | Description | Default |
|---|---|---|
| **External SLA** | Target and window if an SLA exists | None |
| **Historical availability** | Baseline data | `[Assumed]` conservative target |
| **Measurement window** | 28-day rolling or 30-day calendar | 28-day rolling |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/slo-sli-definition/` |

## Input schema

```
input:
  required:
    service:
      type: string | document_reference
    critical_journeys:
      type: list[string]
      min: 1
  optional:
    external_sla: object
    historical_availability: object
    measurement_window:
      type: string
      enum: [28-day-rolling, 30-day-calendar]
      default: 28-day-rolling
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
Collect service + journeys.

### Phase 2 — SLIs per journey
Pick dimensions; formula per SLI with valid event rules.

### Phase 3 — SLO targets
Tighter than SLA; conservative without historical data.

### Phase 4 — Error budget
Time + events.

### Phase 5 — Burn-rate alerts
Fast + slow with concrete windows.

### Phase 6 — Policy
Budget state → actions.

### Phase 7 — Review cadence
Weekly + quarterly + post-incident.

### Phase 8 — Diagrams
Error budget trend + SLO/SLA relationship.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# SLO / SLI Definition: [Service]

**Date**: [date]
**Measurement window**: [window]
**Journeys**: [N]

## Scope
[Service, journeys, external SLA]

## Per-journey SLIs
[Formulas with valid event rules]

## SLO Targets
[Target + error budget + buffer]

## Burn-rate Alerts
[Fast + slow]

## Policy
[State → actions]

## Review Cadence
[Weekly / quarterly / post-incident]

## Diagrams
[Budget trend + SLO/SLA relationship]

## Assumptions & Limitations
[Baselines, data gaps]
```

### Diagrams

- **Error budget trend** — Mermaid `xychart-beta`
- **SLO/SLA relationship** — Mermaid `flowchart`

---

## Generation and planning policy

- SLI formulas concrete
- SLO tighter than SLA
- Error budget in time + events
- Both alerts defined
- Policy concrete
- No fabricated baselines

---

## Self-check

```
[] Journeys and SLIs
[] SLI formulas complete
[] SLO tighter than SLA
[] Error budget in time + events
[] Fast + slow burn-rate alerts
[] Policy concrete
[] Review cadence
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No journeys | Interview mode (§7) |
| SLO tighter than capability | Flag; phased target |
| SLA stricter than SLO | Block — SLO must be tighter |
| Only one burn-rate alert | Require both |
| Policy absent | Require |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | "Targets only; monitoring impl is platform work." |

---

## Quality checks

- [ ] Journey-scoped SLIs
- [ ] Formula concrete
- [ ] SLO > SLA buffer
- [ ] Error budget dual-unit
- [ ] Two burn-rate alerts
- [ ] Policy actions
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Checkout journey, e-commerce**
- Input: Checkout user-journey, external SLA 99.9% monthly
- Expected: SLIs availability (2xx/valid) + latency (<1s/valid); SLO 99.95% (tighter than 99.9%); error budget 20m / 28 days; fast burn 14.4× over 1h; slow burn 6× over 6h; policy freeze-on-exhausted.

**2. Search journey, freshness-critical**
- Input: Search with data-freshness requirement
- Expected: SLIs availability + latency + freshness (`records ≤ 5m old / total`); separate SLO per dimension; policy caution on freshness at 70% budget.

**3. Payments correctness**
- Input: Payment processing
- Expected: Correctness SLI `successfully-reconciled / valid payments`; 99.99% target (tight); zero-tolerance policy on below-floor.

**4. With SLA buffer**
- Input: SLA = 99.9%, service currently at 99.8%
- Expected: Propose SLO 99.95% with roadmap; flag current capability below target; recommend reliability investment.

**5. New service, no baseline**
- Input: No historical data
- Expected: Conservative start (99.5%), `[Assumed]` label, "re-evaluate after 28 days of production data" built into review cadence.

### Edge cases

**6. Multiple journeys with different criticality**
- Input: 5 journeys, some nice-to-have, some mission-critical
- Expected: Different SLOs per journey (99.0% for experimental, 99.99% for revenue-critical); explicit journey-priority mapping.

**7. Third-party dependency limits**
- Input: Service depends on external API with 99.9% SLA
- Expected: Composite SLO cannot exceed dependency without redundancy; document limit; propose matching target or invest in fallback.

**8. Target flips after incident**
- Input: Incident revealed SLO was too tight
- Expected: Quarterly review triggered; propose loosening with explicit trade-off (velocity vs reliability); document decision.

### Failure cases

**9. No service or journeys**
- Input: "Define SLOs"
- Expected: Interview — "Which service and which critical user-journeys?"

**10. Out of scope**
- Input: "Define SLOs and implement the monitoring"
- Expected: "Targets only. Implementation is platform / observability work."
