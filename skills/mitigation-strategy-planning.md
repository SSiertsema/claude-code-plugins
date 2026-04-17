# Mitigation Strategy Planning — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | mitigation-strategy-planning |
| **Version** | 1.0.0 |
| **Purpose** | Plans mitigation strategies for a supplied risk set (or `risk-register` reference). Assigns a response to every risk (avoid / reduce / transfer / accept) with rationale, designs 1–3 concrete actions per Reduce/Transfer risk with owner, effort (person-days or months), cost (one-off + recurring), duration, dependencies, target (L / I / L+I), expected residual scores, and monitoring KPI. Runs cost-benefit per action (expected loss before vs after vs cost) with `[Illustrative]` label when value-per-point isn't calibrated. Sequences actions into a roadmap (quick wins ≤ 2 weeks + positive net benefit; structural 1–3 months; long-term >3 months) respecting dependencies and capacity. Maintains an acceptance & transfer register plus a decision register that feeds `risk-register` history. Mermaid diagrams for response distribution, Gantt roadmap, and cost-benefit scatter with PNG export. |
| **Primary category** | `planning` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- After risk scoring (via `risk-matrix`, `fmea`, `monte-carlo-simulation`, or `pre-mortem`), before entering into `risk-register`
- To turn a scored register into an actionable program with owners and dates
- To produce an auditable decision register for accept / transfer responses
- To sequence mitigations against capacity and dependencies

## When not to use

- Qualitative scoring → `risk-matrix`
- Failure-mode analysis → `fmea`
- Probabilistic modeling → `monte-carlo-simulation`
- Persistent inventory → `risk-register`
- Imaginative failure exploration → `pre-mortem`
- Full control-framework work → `control-framework-mapping`

---

## Required input

| Field | Description |
|---|---|
| **Risks or register** | Risk list or `risk-register` reference |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Risk appetite** | low / medium / high | medium |
| **Constraints** | Budget / time / capacity | None |
| **Decision authority** | Who approves responses and actions | Asked |
| **Value per point** | Calibration for cost-benefit | Unlabeled → `[Illustrative]` |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/mitigation-strategy/` |

## Input schema

```
input:
  required:
    risks_or_register:
      type: list[object] | document_reference
  optional:
    risk_appetite:
      type: string
      enum: [low, medium, high]
      default: medium
    constraints: object
    decision_authority: string
    value_per_point: number
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
Collect risks + constraints + authority.

### Phase 2 — Response per risk
Avoid / Reduce / Transfer / Accept with rationale + expected residual + monitoring (Accept).

### Phase 3 — Action design
Per Reduce/Transfer: 1–3 concrete actions with full metadata.

### Phase 4 — Cost-benefit
Expected loss before/after/reduction vs cost; `[Illustrative]` when value-per-point absent.

### Phase 5 — Sequencing
Quick wins / structural / long-term, respecting dependencies.

### Phase 6 — Acceptance & transfer register
For Accept/Transfer responses: monitoring, counterparty, mechanism, review dates.

### Phase 7 — Decision register
Per decision: ID, risk, chosen-by, date, rationale.

### Phase 8 — Diagrams
Response distribution, Gantt roadmap, cost-benefit scatter.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation; feed to `risk-register`.

---

## Output contract

```markdown
# Mitigation Strategy: [Subject]

**Date**: [date]
**Risks addressed**: [N]
**Actions planned**: [N]
**Risk appetite**: [low / medium / high]

## Scope
[Source, constraints, authority]

## Response per Risk
[Table]

## Actions
[Table with full metadata]

## Cost-benefit
[Before / after / reduction / cost / net benefit; `[Illustrative]` if applicable]

## Roadmap
[Quick wins / structural / long-term]

## Acceptance & Transfer Register
[Decisions + monitoring + mechanism]

## Decision Register
[Auditable record]

## Diagrams
[Response + roadmap + cost-benefit]

## Assumptions & Limitations
[Value-per-point, capacity, review cadence]
```

### Diagrams

- **Response distribution** — Mermaid `pie`
- **Mitigation roadmap** — Mermaid `gantt`
- **Cost-benefit scatter** — Mermaid `quadrantChart`

---

## Planning and assessment policy

- Every risk has a response (no silent omission)
- Actions have owner + effort + cost + expected residual
- Cost-benefit computed or labeled `[Illustrative]`
- Roadmap respects dependencies
- Decisions recorded for audit trail

---

## Self-check

```
[] Every risk has response with rationale
[] Reduce / Transfer actions fully specified
[] Accept risks have monitoring
[] Transfer has counterparty + mechanism
[] Cost-benefit or `[Illustrative]`
[] Roadmap respects dependencies
[] Quick wins identified
[] Decision register complete
[] Diagrams valid
[] No silent acceptance
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No risks | Interview or chain from upstream |
| No owner | `[Unassigned]` flagged as gap |
| Action cost > expected loss reduction | Require justification |
| All responses = Accept | Challenge — not a strategy |
| Authority unclear | Ask |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] Response per risk
- [ ] Actions fully specified
- [ ] Cost-benefit or `[Illustrative]`
- [ ] Roadmap with dependencies
- [ ] Accept + Transfer registers
- [ ] Decision register
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Mixed risk set, 12 risks**
- Input: `risk-register` ref, 12 risks spanning Critical to Low
- Expected: 2 Avoid (scope cut), 6 Reduce with 10 actions, 2 Transfer (insurance + vendor SLA), 2 Accept with monitoring. Quick wins: 3 actions (< 2 weeks, positive net benefit). Structural: 5. Long-term: 2.

**2. Regulatory constraint dominant**
- Input: Compliance risks with low apparent expected loss but regulatory must-do
- Expected: Net benefit negative on cost-benefit math; justification "regulatory non-negotiable — must comply regardless"; action proceeds.

**3. Transfer via vendor SLA**
- Input: Availability risk dependent on a single vendor
- Expected: Transfer via SLA + penalty clause; residual retained-risk (service interruption still hurts user) documented; monitoring via uptime dashboard.

**4. Quick-win-heavy**
- Input: 8 risks, several with obvious low-cost detective controls
- Expected: 6 Quick wins + 2 structural; roadmap front-loaded for fast residual reduction.

**5. Chain from pre-mortem**
- Input: `pre-mortem` output surfacing 7 failure modes
- Expected: Translate failure modes to If/Then risks, plan responses, return decisions to `risk-register`.

### Edge cases

**6. Action with cross-risk benefit**
- Input: One action mitigates 3 risks (e.g., centralized logging helps security + debuggability + compliance)
- Expected: Cost-benefit aggregated across risks; flagged as high-leverage; prioritized.

**7. Capacity-constrained org**
- Input: "Only 1 FTE available for next quarter"
- Expected: Roadmap respects capacity; some actions pushed out; trade-offs surfaced explicitly.

**8. Acceptance stacking**
- Input: 5 risks Accept with monitoring, monitoring KPIs overlap
- Expected: Consolidate monitoring into a single dashboard with multi-risk review cadence.

### Failure cases

**9. No risks**
- Input: "Plan mitigations"
- Expected: Interview — source of risks or chain from upstream skill.

**10. Out of scope**
- Input: "Plan mitigations + run Monte Carlo on each"
- Expected: "Monte Carlo for uncertainty belongs in `monte-carlo-simulation`. This skill plans the actions."
