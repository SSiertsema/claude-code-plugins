# Architecture Trade-off Analysis — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | architecture-tradeoff-analysis |
| **Version** | 1.0.0 |
| **Purpose** | Performs ATAM-inspired structured trade-off analysis for an architecture decision between ≥2 options. Prioritizes quality attributes (availability / performance / consistency / security / cost / maintainability / scalability / observability / time-to-market) on 1–5 scale. Identifies 1–3 most-relevant classic trade-off dimensions (CAP theorem / PACELC / latency vs throughput / consistency vs availability / strong-consistency vs low-latency / cost vs performance / flexibility vs simplicity / coupling vs cohesion / build vs buy / scalability vs simplicity / security vs usability / availability vs durability / read vs write optimization). Scores per option × attribute with rationale + confidence + source. Computes weighted totals but explicitly rejects reducing to a single "winner" — output framing is "recommendation X, gaining [attribute gains], at the cost of [specific trade-offs accepted]". Runs sensitivity analysis identifying which priority swaps flip the recommendation (= dimension most important to validate with stakeholders). Surfaces non-obvious trade-off patterns: second-order effects, team-level trade-offs, time-horizon differences, implicit coupling. Mermaid trade-off matrix + optional sensitivity diagram with PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Foundational architecture decision with multiple valid options
- Stakeholder disagreement surfaced as trade-off tension
- Decision with high blast radius or reversibility cost
- Feeds `adr-writing` with formal trade-off-analysis rationale
- Pair with `architecture-pattern-selection` or `technology-evaluation-matrix`

## When not to use

- Picking between technologies with similar trade-offs → `technology-evaluation-matrix`
- Build vs buy vs non-consumption → `build-vs-buy-analysis`
- Architectural pattern choice → `architecture-pattern-selection`
- Risk assessment → `risk-matrix`
- Simple decisions where trade-offs are obvious

---

## Required input

| Field | Description |
|---|---|
| **Decision subject** | Architecture choice |
| **Options** | ≥2 alternatives |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Quality attribute priorities** | Ranked | Elicit |
| **System context** | Use case + constraints | Asked |
| **Known benchmarks** | Verified data per option | `[Assumed]` where absent |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/architecture-tradeoff-analysis/` |

## Input schema

```
input:
  required:
    decision_subject:
      type: string
    options:
      type: list[string]
      min: 2
  optional:
    attribute_priorities: object
    system_context: string
    known_benchmarks: object
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
Collect decision + options + context.

### Phase 2 — Classic trade-off dimensions
Identify 1–3 most relevant.

### Phase 3 — Quality attribute prioritization
1–5 ranking with rationale.

### Phase 4 — Per-option scoring
Per attribute: score + rationale + confidence + source.

### Phase 5 — Weighted evaluation
Totals; but NOT as winner reduction.

### Phase 6 — Sensitivity analysis
Priority swaps flipping recommendation.

### Phase 7 — Trade-offs accepted
Prose: "We recommend X, gaining Y, at cost Z".

### Phase 8 — Non-obvious patterns
Second-order effects, team-level, time-horizon, implicit coupling.

### Phase 9 — Diagrams
Trade-off matrix + sensitivity.

### Phase 10 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 11 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Architecture Trade-off Analysis: [Decision]

**Date**: [date]
**Decision**: [subject]
**Options**: [≥2]

## Scope
[Decision, options, context, priorities]

## Quality Attribute Prioritization
[Attribute × priority × rationale]

## Relevant Trade-off Dimensions
[1–3]

## Option Scoring per Attribute
[Matrix]

## Weighted Evaluation
[Totals; no single winner]

## Sensitivity Analysis
[Priority swaps flipping recommendation]

## Recommendation
[Option + gains + trade-offs accepted]

## Non-obvious Patterns
[Second-order / team-level / time-horizon / coupling]

## Diagrams
[Matrix + sensitivity]

## Evidence & Assumptions
[`[Assumed]` + sources]

## Assumptions & Limitations
[Measurement gaps]
```

### Diagrams

- **Trade-off matrix** — Mermaid `xychart-beta` (multi-bar options × attributes)
- **Sensitivity** — Mermaid `xychart-beta` (optional)

---

## Assessment and planning policy

- Priorities ranked
- Per-attribute scoring with confidence
- Sensitivity analysis
- Explicit trade-off acceptance in prose
- Non-obvious patterns
- No fabricated benchmarks

---

## Self-check

```
[] ≥2 options
[] Priorities ranked
[] Trade-off dimensions identified
[] Per-attribute scoring with confidence
[] Weighted evaluation
[] Sensitivity analysis
[] Trade-offs accepted explicitly
[] Non-obvious patterns surfaced
[] Diagrams valid
[] `[Assumed]` labels applied
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| <2 options | Interview mode (§7) |
| Priorities all tied | Force ranking |
| All scores similar | Flag low-stakes |
| Single-winner framing demanded | Insist on trade-off prose |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out-of-scope |

---

## Quality checks

- [ ] Priorities ranked
- [ ] Trade-offs identified
- [ ] Per-attribute scores
- [ ] Sensitivity
- [ ] Trade-offs accepted in prose
- [ ] Non-obvious patterns
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. CAP decision: payments datastore**
- Input: DB choice for payments — Postgres (CP) vs Cassandra (AP)
- Expected: Priority consistency = 1, availability = 2; trade-off dimension = consistency vs availability during partition. Postgres scores 5/3 (consistency/availability), Cassandra 2/5. Recommend Postgres; trade-off accepted: brief window of write-rejection during partition to guarantee no double-charge.

**2. Latency vs cost: CDN strategy**
- Input: Global CDN vs regional-origin
- Expected: Priority latency = 1, cost = 3; recommendation: CDN with tiered cache; sensitivity: if cost priority rises above 2, origin-based wins.

**3. Sync vs async integration**
- Input: Between checkout + fulfillment
- Expected: Relevant trade-off = coupling vs cohesion + availability; async (event-driven) wins on loose coupling; trade-off accepted: eventual consistency for order → fulfillment handoff; recommend 30s SLA for eventual propagation.

**4. Multi-region: active-active vs active-passive**
- Input: Failover strategy
- Expected: Availability vs cost + consistency complexity; active-passive cheaper + simpler but slower RTO; active-active expensive + complex but near-zero RTO; sensitivity on tolerance for 15-min downtime.

**5. Monolith vs microservices for growing team**
- Input: 15→40 engineer growth over 18 months
- Expected: Current priorities favor monolith; priority shift (team coordination rising) in 12-18 months flips to modular monolith or service-based; recommend evolution roadmap via `architecture-pattern-selection`.

### Edge cases

**6. All options close**
- Input: Three near-equivalent options
- Expected: Flag low-stakes; suggest picking based on team preference / operational simplicity; sensitivity shows small shifts swing; explicit "low-stakes, pick and move on".

**7. Non-obvious second-order effect surfaces**
- Input: Option A is faster now; option B is slower but keeps optionality for feature X next year
- Expected: Surface time-horizon trade-off; recommend based on product-roadmap confidence; explicit "accepting near-term speed loss for optionality".

**8. Stakeholder disagreement on priorities**
- Input: Eng says performance first, product says cost first, CTO says availability first
- Expected: Run multiple scenarios per priority-set; identify swap-points; escalate priority-setting as a decision that's more important than the technical choice.

### Failure cases

**9. Single option**
- Input: "Analyze trade-offs of using GraphQL"
- Expected: Interview — "Compared to what? Trade-offs require ≥2 options."

**10. Out of scope**
- Input: "Analyze + implement winner"
- Expected: "Analysis only; implementation is engineering."
