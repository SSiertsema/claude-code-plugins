---
name: risk-matrix
description: Classic likelihood × impact risk matrix. Assigns likelihood (rare / unlikely / possible / likely / almost-certain) and impact (negligible / minor / moderate / major / catastrophic), computes risk level (low / medium / high / critical), plots the heat map, and recommends response type (accept / reduce / transfer / avoid) per cell. Mermaid diagrams with optional PNG export.
argument-hint: "[subject + list of risks OR a risk register reference]"
---

# Risk Matrix

You produce a qualitative likelihood × impact risk matrix for a set of supplied risks. Output is a scored register, a heat map, and a response recommendation per risk.

## Core rules

- **5×5 default grid** — user can switch to 3×3 for simpler contexts
- **Calibrated scales** — use anchored definitions so scores are comparable
- **Evidence or `[Assumed]`** — every score traces to input or is `[Assumed]` with rationale
- **No fabricated risks** — do not invent risks not in the input; if eliciting, flag as elicitation
- **Response per risk** — every risk gets an explicit response type (accept / reduce / transfer / avoid)

## Input handling

Follow shared foundation §7. Gather at minimum:

| Dimension | Required | Default |
|---|---|---|
| **Subject** (project / product / org) | Yes | — |
| **Risks** (≥3) | Yes (or elicit via interview) | — |
| **Grid size** | No | 5×5 |
| **Risk appetite** | No | Asked if thresholds matter |
| **Time horizon** | No | 12 months |

**Exit interview when**: subject + ≥3 risks are clear.

## Phase 1 — Setup

### 1. Collect input

- Subject + risk list
- Reference to `risk-register` output
- Business case / project document
- No / vague input → interview mode (§7); elicit risks by asking about goals, dependencies, single points of failure, recent incidents, known unknowns

### 2. Detect scope

- Subject
- Risk list (each with ID: `R-01`, …)
- Grid size (3×3 or 5×5)
- Risk appetite (low / medium / high) — affects response thresholds
- Time horizon

### 3. Confirm scope

```
**Subject**: [name]
**Risks**: [N]
**Grid**: [3×3 / 5×5]
**Risk appetite**: [low / medium / high]
**Horizon**: [N months]
```

Ask for confirmation. Ask render mode (per `diagram-rendering` mixin) and output path (default: `/documentation/[case]/risk-matrix/`).

## Phase 2 — Scales

### Likelihood (5×5)

| Level | Label | Anchored definition |
|---|---|---|
| 1 | Rare | <5% within horizon; would surprise most experts |
| 2 | Unlikely | 5–25% within horizon; known but not expected |
| 3 | Possible | 25–50% within horizon; realistic scenario |
| 4 | Likely | 50–80% within horizon; more likely than not |
| 5 | Almost certain | >80% within horizon; expected unless action taken |

### Impact (5×5)

| Level | Label | Anchored definition (scale to subject) |
|---|---|---|
| 1 | Negligible | Minor inconvenience; no material cost |
| 2 | Minor | Local impact; recoverable within days |
| 3 | Moderate | Functional impact; weeks to recover |
| 4 | Major | Cross-functional; significant cost / reputational |
| 5 | Catastrophic | Existential; long-term recovery if at all |

For 3×3: collapse (Rare+Unlikely / Possible / Likely+Almost-certain; Minor / Moderate / Major).

## Phase 3 — Scoring

Per risk:

| Field | Description |
|---|---|
| **ID** | `R-01`, ... |
| **Risk statement** | "If X happens, Y impact." — not just a vague topic |
| **Category** | Strategic / Operational / Financial / Regulatory / Technical / People / External |
| **Likelihood (1–5)** | With rationale + evidence or `[Assumed]` |
| **Impact (1–5)** | With rationale + evidence or `[Assumed]` |
| **Score** | Likelihood × Impact (1–25) |
| **Level** | Low (1–4) / Medium (5–10) / High (11–16) / Critical (17–25) — adjust per risk appetite |

Risk-appetite adjustment:
- `low` appetite: lower thresholds (e.g., Low 1–3, Medium 4–8, High 9–14, Critical 15–25)
- `high` appetite: higher thresholds (e.g., Low 1–6, Medium 7–12, High 13–18, Critical 19–25)

Show the adjusted thresholds explicitly.

## Phase 4 — Response type per risk

| Response | When to use |
|---|---|
| **Avoid** | Eliminate the activity causing the risk |
| **Reduce** | Mitigate likelihood or impact |
| **Transfer** | Insurance, contract clause, outsourcing |
| **Accept** | Explicitly take on the risk (low level, or cost to reduce > expected loss) |

Recommendation per level:
- Critical → Avoid or Reduce (immediately) — escalate
- High → Reduce or Transfer (plan now)
- Medium → Reduce or Accept-with-monitoring
- Low → Accept-with-monitoring or ignore

Every risk gets an explicit response, with a 1-sentence rationale.

## Phase 5 — Heat map

```mermaid
quadrantChart
    title Risk Matrix — [Subject]
    x-axis Rare --> Almost certain
    y-axis Negligible --> Catastrophic
    quadrant-1 High
    quadrant-2 Critical
    quadrant-3 Low
    quadrant-4 Medium
    R-01: [0.4, 0.6]
    R-02: [0.8, 0.9]
```

Notes:
- Mermaid `quadrantChart` is 4-quadrant; use it as an approximation of the 5×5 heat map
- Map risk IDs with x (likelihood normalized 0–1) and y (impact normalized 0–1)
- If >15 risks, produce a summary matrix + detail table

Optionally add a category bar chart:

```mermaid
xychart-beta
    title "Risk count by category"
    x-axis ["Strategic", "Operational", "Financial", "Regulatory", "Technical", "People", "External"]
    y-axis "Count" 0 --> 10
    bar [3, 5, 2, 1, 4, 1, 2]
```

## Phase 6 — Diagram rendering

Per `diagram-rendering` mixin. File names:
- `risk-heat-map.mmd` / `.png`
- `risk-by-category.mmd` / `.png` (optional)

## Phase 7 — Report assembly and approval

```markdown
# Risk Matrix: [Subject]

**Date**: [date]
**Horizon**: [N months]
**Grid**: [3×3 / 5×5]
**Risk appetite**: [low / medium / high]
**Risks assessed**: [N]

## Scope
[Subject, horizon, risk appetite, grid]

## Scales
[Likelihood + Impact anchored definitions]

## Thresholds
[Level thresholds adjusted for risk appetite]

## Heat Map
[Primary diagram]

## Risk Register
[Table: ID, statement, category, likelihood (rationale), impact (rationale), score, level, response, response rationale]

## By Category
[Counts + optional chart]

## Top Risks
[Critical + High risks ranked with suggested immediate action]

## Evidence & Assumptions
[Per risk: evidence references or `[Assumed]` rationale]

## Limitations
[Qualitative matrix limits; recommend `fmea` for process-level or `monte-carlo-simulation` for quantitative]
```

Present for user approval. Save only after confirmation.

## Assessment rules

- Every score justified with evidence or `[Assumed]` rationale
- No score inflation or deflation
- Thresholds shown explicitly; do not change mid-analysis
- Deterministic on same input

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject | Interview mode (§7) |
| Fewer than 3 risks | Elicit via interview or proceed with note |
| Risk appetite unclear | Use `medium` with `[Assumed]` label |
| Risk statements are topics, not scenarios | Rewrite to "If X, then Y"; keep originals |
| Single risk clearly dominant | Flag as concentration risk; recommend decomposition |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope (e.g., "quantify costs") | Pointer to `monte-carlo-simulation` or `cost-estimation` |

## Self-check

```
[] Subject + horizon stated
[] Grid size declared
[] Likelihood and impact scales anchored
[] Thresholds adjusted for risk appetite and shown
[] Each risk stated as "If X, then Y"
[] Each risk has category
[] Each risk scored with rationale (evidence or `[Assumed]`)
[] Level computed and labeled
[] Response type per risk with rationale
[] Top risks surfaced
[] Heat map renders valid Mermaid syntax
[] No fabricated risks
[] Report follows output contract
```
