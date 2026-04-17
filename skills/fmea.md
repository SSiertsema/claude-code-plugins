# FMEA — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | fmea |
| **Version** | 1.0.0 |
| **Purpose** | Performs Failure Mode and Effects Analysis for a process (PFMEA) or system/design (DFMEA). Starts from functions the subject must perform, enumerates failure modes with effects and causes, captures current prevention and detection controls, and scores Severity × Occurrence × Detection on anchored 1–10 scales. Computes Risk Priority Number (RPN = S × O × D) and Action Priority per AIAG-VDA (H / M / L) based on severity-occurrence-detection bands. Flags critical modes against threshold (default RPN ≥ 100 OR AP = High OR S ≥ 9). Recommends actions that explicitly target S, O, or D with expected new scores, and re-scores post-action. Mermaid diagrams for RPN before/after, Action Priority distribution, and optional severity-occurrence scatter with PNG export. |
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

- Process FMEA (PFMEA) — manufacturing, service delivery, operational processes
- Design FMEA (DFMEA) — product or system design
- Systematic evaluation of failure modes before release or deployment
- Input to quality plans, control plans, or safety cases
- Regulated contexts (medical devices, automotive, aerospace) where FMEA is required

## When not to use

- Qualitative project risk → `risk-matrix`
- Probabilistic modeling → `monte-carlo-simulation`
- Persistent risk inventory → `risk-register`
- Designing mitigation strategies alone (without the FM analysis) → `mitigation-strategy-planning`
- Prospective "imagine failure" facilitation → `pre-mortem`
- Security threat modelling → future `stride-threat-modeling` (Phase 5)

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Process or system |
| **Type** | PFMEA or DFMEA |
| **Functions / steps** | ≥3 named functions or process steps |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Known failure modes** | Pre-identified modes | Elicit from functions |
| **Current controls** | Prevention + detection | `[Assumed]` |
| **Action threshold** | RPN and/or AP trigger | RPN ≥ 100 OR AP = High OR S ≥ 9 |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/fmea/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    type:
      type: string
      enum: [PFMEA, DFMEA]
    functions:
      type: list[object]
      min: 3
      properties:
        id: string
        name: string
        purpose: string
  optional:
    known_failure_modes: list[object]
    current_controls: object
    action_threshold:
      type: object
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
Collect subject, type, functions; interview mode (§7) if missing.

### Phase 2 — Function / step list
Per function: ID, name, purpose.

### Phase 3 — Failure modes, effects, causes
Per function: modes (how it fails), effects (impact), causes (root), current controls (prevention / detection).

### Phase 4 — Scoring
Severity (1–10), Occurrence (1–10), Detection (1–10) — anchored definitions. RPN = S × O × D. AP per AIAG-VDA logic. Detection inverse: low = good detection.

### Phase 5 — Critical modes
Flag against threshold.

### Phase 6 — Actions
Per critical mode: action, type (Design change / Prevention / Detection / Compensating control), target score delta, owner, due, expected post-action scores.

### Phase 7 — Post-action re-score
Delta table per mode.

### Phase 8 — Diagrams
RPN before/after, Action Priority distribution, optional severity-occurrence scatter.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# FMEA: [Subject]

**Date**: [date]
**Type**: [PFMEA / DFMEA]
**Functions / steps**: [N]
**Failure modes**: [N]
**Action threshold**: [threshold]

## Scope
[Subject, type, functions]

## Function / Step List
[Table]

## Failure Modes
[Full table with S/O/D/RPN/AP]

## Critical Modes
[Ranked]

## Recommended Actions
[Per mode with target and expected deltas]

## Post-action Re-score
[Delta table]

## Diagrams
[RPN before/after + AP distribution + optional scatter]

## Evidence & Assumptions
[Per score]

## Limitations
[Scoring subjectivity, review cadence]
```

### Diagrams

- **RPN before / after** — Mermaid `xychart-beta` (two-series bar)
- **AP distribution** — Mermaid `pie`
- **Severity / Occurrence** — Mermaid `quadrantChart` (optional)

---

## Assessment policy

- Scores anchored
- RPN and AP computed deterministically
- Evidence or `[Assumed]` per score
- Action deltas defensible
- No inflation/deflation

---

## Self-check

```
[] Subject + type declared
[] Functions enumerated
[] Modes, effects, causes, controls per function
[] S/O/D scored with rationale
[] Detection direction correct (low = good detection)
[] RPN computed
[] AP per AIAG-VDA
[] Critical modes flagged
[] Actions specify S/O/D target + expected scores
[] Post-action re-score present
[] Evidence or `[Assumed]` labels
[] Diagrams valid
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject or type | Interview mode (§7) |
| <3 functions | Decompose or proceed with note |
| Modes without causes | Elicit causes before scoring |
| Detection direction inverted | Reverse with note |
| Actions without target | Ask which of S/O/D |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] Type declared (PFMEA / DFMEA)
- [ ] Functions enumerated
- [ ] Full rows (mode/effect/cause/controls)
- [ ] Anchored S/O/D
- [ ] RPN and AP
- [ ] Critical flagged
- [ ] Actions with target + new scores
- [ ] Post-action deltas
- [ ] Diagrams valid
- [ ] No fabricated modes

---

## Examples

### Normal cases

**1. PFMEA — onboarding process**
- Input: PFMEA on customer onboarding (sign-up → verify identity → provision account → first-use)
- Expected: 6 functions, ~15 failure modes, scoring, 3 critical (stuck verification, provisioning race condition, onboarding drop-off), actions targeting Occurrence (retry), Detection (monitoring), and Design (async verification).

**2. DFMEA — product feature**
- Input: DFMEA on new payment retry logic
- Expected: Function "retry a failed payment", modes include "infinite retries cause cardholder lockout", "exponential backoff lost on restart", actions including idempotency keys, circuit breakers, monitoring.

**3. Regulated device**
- Input: DFMEA for a medical device component
- Expected: Severity dominated by safety; every S ≥ 9 flagged; actions require design change rather than detection; explicit post-action safety rationale.

**4. Service ops**
- Input: PFMEA on a support ticket workflow
- Expected: Modes covering ticket intake misrouting, SLA breach, escalation failure; actions include routing rule review, SLA monitoring, tiered escalation.

**5. Re-score iteration**
- Input: FMEA from 6 months ago + updates on completed actions
- Expected: Old scores preserved, new scores computed, delta table shows RPN reductions, remaining high-priority modes named.

### Edge cases

**6. No controls in place**
- Input: Green-field design with no controls yet
- Expected: Detection scored high (= poor detection) uniformly; actions strongly toward adding detection; threshold triggered for many modes.

**7. Cause traces to a single SPOF**
- Input: Many modes share a single root cause (e.g., one vendor)
- Expected: Flag as concentration; recommendation: actions at the root (vendor redundancy) rather than per-mode detection.

**8. Safety-critical mode with unrealistic "detect" action**
- Input: Proposed action is "detect and alert" on a hazardous mode
- Expected: Reject framing; recommend design change (prevention) since detection alone is insufficient for hazard classes.

### Failure cases

**9. No functions**
- Input: "Do FMEA on our process"
- Expected: Interview — "What is the process? What functions/steps does it perform?"

**10. Out of scope**
- Input: "FMEA and give me a full risk register"
- Expected: "FMEA focuses on failure-mode analysis. Persistent risk inventory belongs in `risk-register` — the FMEA critical modes can feed directly."
