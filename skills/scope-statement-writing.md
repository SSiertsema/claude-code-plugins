# Scope Statement Writing — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | scope-statement-writing |
| **Version** | 1.0.0 |
| **Purpose** | Produces a project scope statement that governs what will and won't be delivered. Defines purpose (why this, why now) addressed to the sponsor, SMART objectives with measurable success criteria, deliverables with per-deliverable acceptance criteria, explicit in-scope list, explicit out-of-scope list (highest-leverage section: prevents creep arguments later), assumptions (facts treated as given, with confirm-by dates), constraints (budget / time / people / regulatory / technical hard limits), boundaries across organizational / geographic / temporal / technical / customer-segment dimensions, stakeholders + approval authority (sponsor + approvers + RACI hints), scope-change protocol (request → impact assessment → decision → baseline update; no silent changes), coverage check against WBS when available (every in-scope item maps to ≥ 1 WBS branch; nothing outside), open questions / placeholders for decisions pending. Distinct from business case (handoff to `business-case-management` for ROI / investment rationale / market), from WBS (`work-breakdown-structure` for structural decomposition), from stakeholder analysis (`stakeholder-mapping` for deeper work), from change modelling (`change-impact-assessment`). Mermaid scope-boundary + objective→deliverable mapping with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `professional` |
| **Audience** | `mixed` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Project kickoff document
- Re-baselining after significant change
- Before contracting / vendor selection
- Alignment with sponsor on what's in / out

## When not to use

- Business case / ROI → `business-case-management`
- Structural decomposition → `work-breakdown-structure`
- Deep stakeholder analysis → `stakeholder-mapping`
- Scope-change impact analysis → `change-impact-assessment`

---

## Required input

| Field | Description |
|---|---|
| **Project name + sponsor** | Identifier + owner |
| **Purpose** | Why this, why now |
| **Objectives** | 3–5 measurable aims |
| **Known deliverables** | List |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Known exclusions** | Out-of-scope items | Asked |
| **Constraints** | Budget / time / people | Asked |
| **Stakeholders** | List + roles | Asked |
| **Approval authority** | Who signs | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/scope-statement/` |

## Input schema

```
input:
  required:
    project: string
    sponsor: string
    purpose: string
    objectives: array[object]
    deliverables: array[object]
  optional:
    known_exclusions: array[string]
    constraints: object
    stakeholders: array[object]
    approval_authority: array[string]
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path: string
```

---

## Processing rules

### Phase 1 — Setup
Project, sponsor, purpose, objectives, deliverables, exclusions, constraints, stakeholders.

### Phase 2 — Purpose + objectives
One-paragraph purpose; SMART objectives with success criteria.

### Phase 3 — Deliverables + acceptance
Per-deliverable description + acceptance criteria.

### Phase 4 — In-scope
Concrete + contestable.

### Phase 5 — Out-of-scope
Explicit exclusions (most important section).

### Phase 6 — Assumptions
Separated from facts with confirm-by dates.

### Phase 7 — Constraints
Budget / time / people / regulatory / technical.

### Phase 8 — Boundaries
Organizational / geographic / temporal / technical / segments.

### Phase 9 — Stakeholders + approval
Approver + decision rights.

### Phase 10 — Scope-change protocol
Request → impact → decision → baseline.

### Phase 11 — Coverage check
Scope ↔ WBS (if WBS exists).

### Phase 12 — Open questions
Pending decisions.

### Phase 13 — Diagrams
Scope boundary + objective→deliverable.

### Phase 14 — Diagram rendering
Per mixin.

### Phase 15 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Scope Statement: [Project]

**Date**: [date]
**Project**: [...]
**Sponsor**: [...]
**Approver(s)**: [...]
**Baseline version**: v1.0

## Purpose
## Objectives & Success Criteria
## Deliverables & Acceptance
## In-Scope
## Out-of-Scope
## Assumptions
## Constraints
## Boundaries
## Stakeholders & Approval Authority
## Scope-Change Protocol
## Coverage Check (with WBS)
## Open Questions / Placeholders
## Diagrams
## Hand-offs
```

### Diagrams
- **Scope boundary** — Mermaid `graph LR`
- **Objective→deliverable mapping** — Mermaid `graph LR`

---

## Assessment and planning policy

- Explicit out-of-scope
- Deliverables + acceptance
- SMART objectives
- Assumptions separated
- Constraints enumerated
- Boundaries multi-dimensional
- Approver named + change protocol
- No fabricated deliverables

---

## Self-check

```
[] Purpose for sponsor audience
[] SMART objectives
[] Deliverables + acceptance
[] Explicit in-scope
[] Explicit out-of-scope
[] Assumptions separated
[] Constraints enumerated
[] Boundaries ≥ 4 dimensions
[] Stakeholders + approver
[] Change protocol
[] Open questions
[] Coverage check if WBS
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No purpose / objectives | Interview mode (§7) |
| "Everything in scope" | Challenge; ask exclusions |
| Deliverables without acceptance | Ask criteria |
| No approver | Require |
| Business-case request | Redirect |
| Stakeholder-map request | Redirect |
| Change-impact request | Redirect |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Out-of-scope list substantive (≥ 4 items typical)
- [ ] Every deliverable has measurable acceptance
- [ ] Objectives not aspirational ("best-in-class" without criterion)
- [ ] Boundaries cover multiple dimensions
- [ ] Approver + change protocol named

---

## Examples

### Normal cases

**1. SaaS feature launch**
- Input: Self-service refund flow
- Expected: 3–5 objectives, 4 deliverables, substantive out-of-scope (partial refunds, backoffice redesign, analytics), PSD2 constraint

**2. Compliance project**
- Input: GDPR remediation
- Expected: Regulatory constraint dominant; explicit scope per system; audit-ready output acceptance

**3. Cloud migration**
- Input: Lift-and-shift 40 services
- Expected: Boundaries around which services; out-of-scope: re-architecting, decommissioning

**4. Integration project**
- Input: New partner API integration
- Expected: Explicit partners in-scope; other partners out; fallback mechanisms in/out decided

**5. Re-baselining existing project**
- Input: Scope creep needs rewrite
- Expected: New baseline v2.0; change log; approver sign-off; updated out-of-scope

### Edge cases

**6. Vague purpose**
- Input: "Improve checkout"
- Expected: Ask for measurable objectives; decline to proceed without criteria

**7. Overlapping project**
- Input: Two ongoing projects touching same system
- Expected: Boundary explicit; coordination with other approvers; cross-project exclusions listed

**8. Regulated industry**
- Input: Healthcare / financial
- Expected: Regulatory constraints prominent; compliance sign-off in approval path

### Failure cases

**9. No sponsor**
- Input: Project without sponsor named
- Expected: Require sponsor before proceeding

**10. Business-case request**
- Input: "Include ROI and market sizing"
- Expected: Redirect to `business-case-management`
