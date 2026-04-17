# Build vs Buy Analysis — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | build-vs-buy-analysis |
| **Version** | 1.0.0 |
| **Purpose** | Structured analysis of whether a capability or component should be built, bought, adopted (open-source), rented (SaaS), combined (hybrid), or deferred (non-consumption). Evaluates each option on 7 weighted criteria (strategic fit, TCO over 3–5 years, time to value, control & flexibility, risk, switching cost, opportunity cost) with per-cell justification. Produces a scored decision matrix, TCO breakdown per option with ranges and confidence, a recommendation with named trade-off and key risk, and 3–5 reversal conditions that would trigger revisiting the decision. Renders a decision matrix bar chart, a cost-over-time line chart, and an optional strategic fit quadrant with optional PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Deciding whether to build, buy, adopt OSS, rent SaaS, or combine for a specific capability
- Evaluating existing build vs migration to a third-party solution (or vice versa)
- Framing a procurement decision with strategic and financial rigor
- Pre-work for vendor selection or engineering estimation
- Input to a business case or roadmap decision

## When not to use

- Vendor selection between shortlisted products → future `vendor-evaluation` skill
- Cost estimation in isolation → `cost-estimation`
- Timeline estimation in isolation → `timeline-estimation`
- Dependency analysis → `dependency-mapping`
- ROI modeling → `roi-modeling`
- Full business case → `business-case-management`

---

## Required input

| Field | Description |
|---|---|
| **Capability** | The function / component being evaluated |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Context** | Team size, stack, industry, data sensitivity | Inferred |
| **Known options** | Vendors, OSS projects, or existing builds | Model adds build + non-consumption; rest as relevant |
| **Constraints** | Budget ceiling, timeline, compliance | None |
| **Strategic importance** | `core` / `adjacent` / `commodity` | Ask or `adjacent` default |
| **Evaluation horizon** | 1–5 years | 3 years |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/build-vs-buy/` |

## Input schema

```
input:
  required:
    capability:
      type: string | document_reference
  optional:
    context:
      type: string
    known_options:
      type: list[string]
    constraints:
      type: object
      properties:
        budget_ceiling: number
        timeline_deadline: string
        compliance: list[string]
    strategic_importance:
      type: string
      enum: [core, adjacent, commodity]
    evaluation_horizon_years:
      type: integer
      min: 1
      max: 5
      default: 3
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

1. Collect capability; interview mode (§7) if missing or vague
2. Detect context, strategic importance, constraints, horizon
3. Confirm scope
4. Ask render mode and output path

### Phase 2 — Option generation

Always: build, buy, non-consumption. Add open-source, rent/SaaS, hybrid where relevant. Name concretely or use `[Assumed]` vendor-class placeholders.

### Phase 3 — Evaluation criteria

Score each option on 7 criteria (1–5 with justification):
- Strategic fit
- TCO (3-year, or horizon)
- Time to value
- Control & flexibility
- Risk
- Switching cost
- Opportunity cost

No score inflation; assumptions labeled.

### Phase 4 — TCO breakdown

Per option: upfront / development / operations / people / opportunity / risk-adjusted costs over horizon, with optimistic/realistic/pessimistic ranges.

### Phase 5 — Decision matrix

Weighted total per option. Default equal weights; adjust based on strategic importance (core → strategic fit + control doubled; adjacent → TCO + TTV doubled; commodity → TCO + opportunity cost doubled). Weights shown explicitly.

### Phase 6 — Recommendation

Chosen option + runner-up + key trade-off + biggest risk + mitigation.

### Phase 7 — Reversal conditions

3–5 concrete, observable triggers.

### Phase 8 — Diagrams

- Decision matrix (xychart-beta)
- Cost over time (xychart-beta)
- Strategic fit matrix (quadrantChart, optional)

### Phase 9 — Diagram rendering

Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval

Full report; present for approval; save only after confirmation.

---

## Output contract

### Report structure

```markdown
# Build vs Buy Analysis: [Capability]

**Date**: [date]
**Capability**: [name]
**Strategic importance**: [core / adjacent / commodity]
**Evaluation horizon**: [N years]
**Options evaluated**: [list]

## Context
[Team, stack, industry, constraints]

## Options
[Per option: description, concrete candidates, characteristics]

## Evaluation Criteria & Weights
[Weights with rationale]

## Decision Matrix
[Scored matrix with per-cell justification]

## TCO Breakdown
[Per option: cost categories with ranges and confidence]

## Diagrams
[Decision matrix + cost over time + optional strategic fit matrix]

## Recommendation
[Chosen + runner-up + trade-off + risk + mitigation]

## Reversal Conditions
[3–5 triggers]

## Evidence & Assumptions
[`[Assumed]` items with rationale and confidence]

## Limitations
[Gaps, sensitivity notes]
```

### Diagrams

- **Decision matrix** — Mermaid `xychart-beta` (weighted score per option)
- **Cost over time** — Mermaid `xychart-beta` (multi-line, top 3–4 options)
- **Strategic fit matrix** — Mermaid `quadrantChart` (optional)

---

## Evidence and planning policy

**Assessment (primary)**:
- Per-cell justification required
- Confidence labels on estimates
- `[Assumed]` for inferred values — never fabricate vendor pricing or feature claims
- Deterministic

**Planning (secondary)**:
- Recommendation grounded in matrix
- Reversal conditions concrete and observable
- Sensitivity flagged if recommendation flips within 20% weight shift

---

## Self-check

```
[] Capability clearly defined
[] ≥3 options (build, buy, non-consumption minimum)
[] All 7 criteria scored with justification
[] Weights shown and tied to strategic importance
[] TCO breakdown per option with categories and ranges
[] Confidence labels on estimates
[] `[Assumed]` values justified
[] Recommendation names trade-off and risk
[] Reversal conditions concrete and observable
[] All Mermaid diagrams valid
[] Sensitivity noted for close decisions
[] No fabricated vendor pricing or claims
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No capability | Interview mode (§7) |
| Strategic importance unclear | Ask; default `adjacent` with `[Assumed]` label |
| No vendor options known | Use vendor-class placeholders, flag need for procurement research |
| Budget / timeline missing | Use open ranges, flag as assumption |
| Weights produce tie | Report honestly, offer sensitivity analysis |
| mmdc failure | See `diagram-rendering` mixin |
| Vendor selection requested | Out of scope — defer to future `vendor-evaluation` |

---

## Quality checks

- [ ] ≥3 options
- [ ] All 7 criteria scored with justification
- [ ] Weights adjusted to strategic importance
- [ ] TCO over horizon with ranges
- [ ] Confidence on estimates
- [ ] Recommendation + runner-up + trade-off + risk
- [ ] Reversal conditions concrete
- [ ] Diagrams valid
- [ ] No fabricated vendor data

---

## Examples

### Normal cases

**1. Core capability — build-favored**
- Input: "Our proprietary recommendation engine — currently evaluating whether to migrate to a vendor"
- Expected: Strategic importance = core; weights double on strategic fit + control. Build wins despite higher TCO. Reversal conditions: "If we lose >2 senior ML engineers", "If a vendor offers comparable differentiation".

**2. Commodity capability — buy/rent favored**
- Input: "Our email sending infrastructure"
- Expected: Commodity; weights double on TCO + opportunity cost. Rent (SendGrid/Postmark class) wins. Reversal: "If volume exceeds threshold making rent TCO surpass build TCO".

**3. Adjacent capability — hybrid**
- Input: "Authentication — currently home-grown, evaluating Auth0 vs keep building"
- Expected: Hybrid option (buy core SSO, build custom tenant model on top) wins. Runner-up: Buy. Trade-off: vendor dependency for core auth flows in exchange for security + speed.

**4. With strict compliance constraint**
- Input: "CRM for a healthcare company with HIPAA requirements"
- Expected: Non-consumption quickly eliminated. Build TCO high due to compliance. Buy (HIPAA-certified vendor like Salesforce Health Cloud) wins. OSS labeled higher risk due to certification gap.

**5. Open-source vs build**
- Input: "Search infrastructure — OSS (Elasticsearch / OpenSearch / Meilisearch) vs build on Postgres FTS"
- Expected: Open-source wins if operational capacity exists; Build on Postgres wins if team is small + search needs are simple. Clear decision driver surfaced.

### Edge cases

**6. Data too sparse to score**
- Input: "Some CRM thing — we need to decide by next week"
- Expected: Interview for strategic importance + team size + budget; proceed with heavy `[Assumed]` labels; low confidence overall; recommendation conditional with explicit "highest uncertainty is X".

**7. Weight sensitivity flips recommendation**
- Input: Build scores 3.9, Buy scores 3.8
- Expected: Explicit sensitivity note: "Recommendation flips if Strategic fit weight decreases by 15% or TCO weight increases by 20%". Present both as viable with trade-off framing.

**8. No viable option meets hard constraint**
- Input: "Must have SOC2 type 2 + launch in 8 weeks + budget €20k"
- Expected: Flag constraint conflict; present constraint-relaxation recommendations ("Either push timeline to 16 weeks, raise budget to €80k, or defer SOC2 to year 2").

### Failure cases

**9. No capability**
- Input: "Build vs buy?"
- Expected: Interview mode — "Which capability or component are you evaluating?"

**10. Vendor-selection request**
- Input: "Pick between Stripe, Adyen, and Braintree for us"
- Expected: "This skill structures the build-vs-buy decision for a capability class. Vendor selection between shortlisted products needs deeper criteria — defer to a `vendor-evaluation` step. I can frame the buy-class decision and score-driving criteria, leaving the specific vendor pick for the next step."
