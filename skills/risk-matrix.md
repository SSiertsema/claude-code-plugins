# Risk Matrix — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | risk-matrix |
| **Version** | 1.0.0 |
| **Purpose** | Produces a qualitative likelihood × impact risk matrix for a supplied set of risks. Uses a 5×5 grid by default (collapsible to 3×3) with anchored likelihood scales (rare / unlikely / possible / likely / almost-certain) and impact scales (negligible / minor / moderate / major / catastrophic). Computes risk score (L × I, 1–25) and level (low / medium / high / critical) with thresholds adjusted for risk appetite. Assigns an explicit response type per risk (avoid / reduce / transfer / accept) with rationale. Every score must be justified by evidence or labeled `[Assumed]`. Produces a Mermaid quadrantChart heat map and an optional category bar chart with PNG export. Feeds `risk-register` and `mitigation-strategy-planning`. |
| **Primary category** | `assessment` |
| **Secondary category** | `classification` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Quick qualitative risk assessment for a project, product, or initiative
- Input to risk register or mitigation planning
- Kickoff risk workshop where risks need to be prioritized
- Communicating risk levels to non-technical stakeholders

## When not to use

- Quantitative probabilistic modeling → `monte-carlo-simulation`
- Process- or system-level failure analysis → `fmea`
- Full persistent risk inventory → `risk-register`
- Designing response actions → `mitigation-strategy-planning`
- Prospective "imagine failure" analysis → `pre-mortem`

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Project, product, or initiative |
| **Risks** | ≥3 risks (or elicit via interview) |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Grid size** | `3x3` or `5x5` | `5x5` |
| **Risk appetite** | low / medium / high | medium |
| **Time horizon** | Months | 12 |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/risk-matrix/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    risks:
      type: list[object]
      min: 3
      properties:
        statement: string
        category: string
  optional:
    grid_size:
      type: string
      enum: [3x3, 5x5]
      default: 5x5
    risk_appetite:
      type: string
      enum: [low, medium, high]
      default: medium
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
Collect subject + risks; interview mode (§7) if missing. Detect grid size, appetite, horizon.

### Phase 2 — Scales
Anchored likelihood + impact definitions. 3×3 collapses 5×5.

### Phase 3 — Scoring
Per risk: statement "If X then Y", category, likelihood + rationale, impact + rationale, score L×I, level adjusted by appetite thresholds.

### Phase 4 — Response type
Avoid / reduce / transfer / accept per risk with 1-sentence rationale. Recommendations per level.

### Phase 5 — Heat map
Mermaid `quadrantChart` with normalized coordinates. Optional category bar chart.

### Phase 6 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 7 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Risk Matrix: [Subject]

**Date**: [date]
**Horizon**: [N months]
**Grid**: [3×3 / 5×5]
**Risk appetite**: [low / medium / high]
**Risks assessed**: [N]

## Scope
[Subject, horizon, appetite, grid]

## Scales
[Likelihood + Impact anchored definitions]

## Thresholds
[Level thresholds adjusted for appetite]

## Heat Map
[Primary diagram]

## Risk Register
[Table with ID, statement, category, likelihood, impact, score, level, response, rationale]

## By Category
[Counts + optional chart]

## Top Risks
[Critical + High ranked with immediate action]

## Evidence & Assumptions
[Per risk: evidence or `[Assumed]`]

## Limitations
[Qualitative matrix limits; pointers to fmea or monte-carlo-simulation]
```

### Diagrams

- **Heat map** — Mermaid `quadrantChart`
- **Category chart** — Mermaid `xychart-beta` (optional)

---

## Assessment policy

- Every score justified (evidence or `[Assumed]`)
- Thresholds shown and fixed
- Deterministic on same input
- No inflation/deflation

---

## Self-check

```
[] Subject + horizon stated
[] Grid size declared
[] Scales anchored
[] Thresholds shown for appetite
[] Risks as "If X then Y"
[] Category per risk
[] L + I with rationale
[] Level computed
[] Response + rationale per risk
[] Top risks surfaced
[] Diagrams valid
[] No fabricated risks
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject | Interview mode (§7) |
| <3 risks | Elicit via interview or proceed with note |
| Risk appetite unclear | `medium` with `[Assumed]` |
| Risks are topics, not scenarios | Rewrite to If/Then |
| Single dominant risk | Flag as concentration risk; recommend decomposition |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] Anchored scales
- [ ] Appetite-adjusted thresholds
- [ ] Scored with rationale
- [ ] Response + rationale per risk
- [ ] Heat map valid
- [ ] No fabricated content

---

## Examples

### Normal cases

**1. Software project**
- Input: 10 risks for a mobile app launch
- Expected: 5×5 matrix, medium appetite, 2 Critical (3rd-party API deprecation, App Store rejection), 3 High, 4 Medium, 1 Low; responses include Avoid for one, Reduce for most, Transfer (vendor SLA) for one.

**2. Regulatory program**
- Input: 8 risks for a GDPR compliance program
- Expected: Low appetite (compliance sensitivity); thresholds tightened; several Medium risks become High under the adjusted thresholds.

**3. 3×3 simple matrix**
- Input: 5 risks, stakeholder workshop, quick view
- Expected: 3×3 collapsed grid, simpler heat map, accessible for non-technical audience.

**4. Category-heavy**
- Input: 15 risks, mostly Technical category
- Expected: Category bar chart surfaces concentration in Technical; recommendation to decompose Technical into sub-categories or invest in engineering capacity.

**5. With risk-register reference**
- Input: Reference to existing risk-register + "score these"
- Expected: Pull statements from register, score, feed scored levels back to register.

### Edge cases

**6. Risks as topics, not scenarios**
- Input: "data", "vendors", "regulations"
- Expected: Rewrite each as "If X happens, Y impact" — e.g., "data" → "If customer data is exposed in a breach, we face regulatory fines and reputational damage"; keep originals, confirm rewrite with user.

**7. Clear concentration risk**
- Input: All 6 risks depend on a single vendor
- Expected: Flag vendor-dependency as a meta-risk; recommend decomposition to surface different failure modes (pricing, availability, data protection, roadmap divergence).

**8. Appetite mismatch**
- Input: User says "high appetite" but risks include regulatory
- Expected: Honor high appetite for thresholds; note that regulatory risks may require low-appetite treatment regardless of overall appetite.

### Failure cases

**9. No subject**
- Input: "Score some risks"
- Expected: Interview mode — subject + horizon.

**10. Out of scope**
- Input: "Score risks and run Monte Carlo for each"
- Expected: "This skill produces a qualitative matrix. For probabilistic modeling, see `monte-carlo-simulation`."
