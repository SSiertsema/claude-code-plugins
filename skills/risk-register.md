# Risk Register — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | risk-register |
| **Version** | 1.0.0 |
| **Purpose** | Creates, updates, reviews, closes, and exports a persistent risk register for a subject. Each risk row has stable ID, "If X then Y" statement, category, owner, inherent L/I/Score/Level, current controls (optionally linked to `control-framework-mapping`), residual L/I/Score/Level, response strategy (avoid / reduce / transfer / accept), planned actions, status, review cadence, next/last review dates, full change history, source (upstream skill or elicitation), and free-form tags. Operations: `create` / `update` / `review` / `close` / `export`. Ingests risks from `risk-matrix`, `fmea`, `monte-carlo-simulation`, and `pre-mortem`. Produces views (top risks, by owner, by category, overdue reviews, recently changed), Mermaid diagrams (residual heat map, level distribution, optional trend), and Markdown + CSV export. |
| **Primary category** | `extraction` |
| **Secondary category** | `planning` |
| **Output mode** | `hybrid` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Canonical persistent risk inventory for a project, product, or organization
- Central hub that consumes `risk-matrix`, `fmea`, `monte-carlo-simulation`, `pre-mortem` outputs
- Periodic risk review cadence
- Audit / governance requirements for tracked risks
- Ownership accountability and review discipline

## When not to use

- One-shot qualitative scoring → `risk-matrix`
- Failure-mode depth analysis → `fmea`
- Probabilistic modeling → `monte-carlo-simulation`
- Planning mitigations in depth → `mitigation-strategy-planning`
- Imaginative failure exploration → `pre-mortem`

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Project, product, or org |
| **Risks or source** | Risk list, or reference to upstream skill output |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Operation** | create / update / review / close / export | create |
| **Owner defaults** | Default owner per category | Asked |
| **Review cadence** | Per level | Weekly (Critical) / Monthly (High) / Quarterly (Medium/Low) |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/risk-register/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    risks_or_source:
      type: list[object] | document_reference
  optional:
    operation:
      type: string
      enum: [create, update, review, close, export]
      default: create
    owner_defaults:
      type: object
    review_cadence:
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
Collect subject + source; detect operation.

### Phase 2 — Schema
Stable IDs, "If X then Y" statements, category, owner, inherent + residual L/I/Score/Level, controls, response, actions, status, cadence, dates, history, source, tags.

### Phase 3 — Operations
- **Create**: ingest, dedupe, assign IDs, fill inherent/residual, assign owner + cadence
- **Update**: match IDs, record history, adjust residual after controls, shift cadence on level change
- **Close**: require reason, retain ID, mark Closed
- **Review**: surface overdue reviews, residual High+Critical, recent changes

### Phase 4 — Views
Top risks / by owner / by category / overdue / recently changed.

### Phase 5 — Export
Markdown (primary) + CSV (machine-readable).

### Phase 6 — Diagrams
Residual heat map, level distribution, optional trend.

### Phase 7 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 8 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Risk Register: [Subject]

**Date**: [date]
**Operation**: [create / update / review / close / export]
**Risks**: [N open + M closed]
**Residual High+Critical**: [N]

## Scope
[Subject, source, operation]

## Register
[Full table]

## Views
[Top risks / by owner / by category / overdue / recently changed]

## Diagrams
[Residual heat map + level distribution + optional trend]

## History Highlights
[Recent changes]

## Limitations
[Source confidence, review gaps]
```

### Diagrams

- **Residual heat map** — Mermaid `quadrantChart`
- **Level distribution** — Mermaid `pie`
- **Trend** — Mermaid `xychart-beta` (optional)

---

## Extraction and planning policy

- Stable IDs enforced
- History preserved
- Sources cited
- Residual computed from inherent + controls, not invented
- No fabricated risks

---

## Self-check

```
[] Subject declared
[] Stable IDs, no reuse
[] Statements as "If X then Y"
[] Owner + cadence per risk
[] Inherent + residual scored
[] Controls linked or `[Assumed]`
[] Response declared
[] Status in controlled set
[] History on changes
[] Views produced
[] Markdown + CSV
[] Diagrams valid
[] No fabricated risks
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject | Interview mode (§7) |
| No risks, no source | Offer upstream ingest or elicit |
| Update without IDs | Surface mismatches before creating new IDs |
| Close without reason | Require reason |
| Residual > inherent | Flag — controls shouldn't raise residual |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] Subject declared
- [ ] Stable IDs
- [ ] Statements as "If X then Y"
- [ ] Inherent + residual
- [ ] Owner + cadence
- [ ] Controls linked
- [ ] Response declared
- [ ] History kept
- [ ] Views + export
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Create from risk-matrix output**
- Input: `risk-matrix` output (10 risks scored)
- Expected: 10 rows with stable IDs (`RR-001` – `RR-010`), inherent scores from matrix, residual computed against known controls, owners assigned, cadences set by level.

**2. Update after control change**
- Input: "MFA now enforced — update any risks mitigated by it"
- Expected: Identify relevant risks, update current controls list, recompute residual (likely lower), record history entries, adjust cadence if level dropped.

**3. Monthly review**
- Input: Operation = review
- Expected: Review summary — overdue reviews (N), residual High+Critical (N), recently added/closed, history highlights, recommended next actions per owner.

**4. Close risk**
- Input: "Close RR-007 — mitigated"
- Expected: Status → Closed, reason recorded, ID retained, final residual frozen, closed-risk view updated.

**5. Export to CSV**
- Input: Operation = export, format = CSV
- Expected: CSV matching schema columns; round-trips to Markdown without loss.

### Edge cases

**6. Duplicate risk on ingest**
- Input: Ingest overlaps existing risk
- Expected: Surface duplicate candidate; ask user to merge / keep separate; if merged, retain both source references in history.

**7. Residual > inherent**
- Input: Control reduced accidentally, raising residual
- Expected: Flag explicitly; recommend control review before accepting.

**8. Large register (>100 risks)**
- Input: Register with 150 risks
- Expected: Produce summary views by default; detailed table available via export only; offer filtering/tagging recommendations.

### Failure cases

**9. No subject or source**
- Input: "Make a register"
- Expected: Interview — "Which subject, and which source of risks?"

**10. Out of scope**
- Input: "Register + run Monte Carlo on each"
- Expected: "Register lives here. For probabilistic modeling, see `monte-carlo-simulation` — simulation outputs can feed residual L/I."
