# ADR Writing — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | adr-writing |
| **Version** | 1.0.0 |
| **Purpose** | Writes, reviews, supersedes, or indexes Architecture Decision Records. Default format is Michael Nygard (Title / Status / Context / Decision / Consequences with positive + negative + neutral + risks-accepted). Alternative: Y-statement (Zimmermann compact format). Stable IDs (`ADR-NNN`, zero-padded, never reused). Status lifecycle: Proposed → Accepted → (Deprecated / Superseded by ADR-XXX). Supersession chain preserves old ADR content immutably — new decisions create new ADRs pointing to old; old ADR status updates to "Superseded by ADR-NNN"; content never edited. ADR index / log tracks all ADRs chronologically with supersession chains visible. Four modes: `write` (new ADR), `supersede` (new decision replacing existing), `review` (periodic log refresh flagging stale ADRs + missing consequences + informally-made decisions), `index` (produce or refresh ADR log). Integrates with `traceability-matrix` — ADRs become first-class linkable artifacts (requirement → ADR via `decided-by`, ADR → component via "affects", ADR → ADR via `supersedes` / `related-to`). Mermaid supersession timeline + status distribution pie with PNG export. |
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

- Recording a significant architectural / technical decision
- Establishing ADR practice in a team
- Superseding an outdated decision with new rationale
- Periodic review of ADR log for staleness
- Building ADR index for onboarding / audit

## When not to use

- Simple routine tech choices (library pick within team standard) — ADR overhead disproportionate
- Tracking bug fixes or feature specs → commits / PRs / specs
- Business decisions (not architecture) → business case / decision-log skills
- Detailed design specs → `component-design-documentation` (future Phase 5)

---

## Required input

| Field | Description |
|---|---|
| **Mode** | write / supersede / review / index |

For write / supersede: decision subject + context.
For supersede: target ADR being superseded.
For review / index: ADR log reference.

## Optional input

| Field | Description | Default |
|---|---|---|
| **Decision subject** | What's being decided | Required write / supersede |
| **Existing ADR log** | Reference | — |
| **Format** | Nygard / Y-statement | Nygard |
| **Target ADR to supersede** | Required supersede mode | — |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/adr-writing/` |

## Input schema

```
input:
  required:
    mode:
      type: string
      enum: [write, supersede, review, index]
  optional:
    decision_subject: string
    existing_log: document_reference
    format:
      type: string
      enum: [nygard, y-statement]
      default: nygard
    target_adr_to_supersede: string
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
Collect mode + subject + existing log.

### Phase 2 — Nygard format
Title + Status + Context + Decision + Consequences.

### Phase 3 — Y-statement (alternative)
Compact Zimmermann template.

### Phase 4 — Status lifecycle
Proposed / Accepted / Deprecated / Superseded.

### Phase 5 — Supersession
New ADR points to old; old status updated; content preserved.

### Phase 6 — Index / log
Chronological list with supersession chains visible.

### Phase 7 — Review mode
Flag stale + missing consequences + informal decisions.

### Phase 8 — Traceability integration
Link ADRs in `traceability-matrix`.

### Phase 9 — Diagrams
Timeline + status distribution.

### Phase 10 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 11 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

### Write mode

```markdown
# ADR-[NNN]: [Title]

## Status
[Status]

## Context
[Rich factors]

## Decision
[Clear statement]

## Consequences
- Positive
- Negative / trade-offs
- Neutral
- Risks accepted

## Related
[Supersession + related ADRs]
```

### Review / Index mode

```markdown
# ADR Management: [Subject]

**Date**: [date]
**Mode**: [mode]

## ADR Index
[Table]

## Supersession Chains
[Per chain]

## Review Findings
[Stale + missing consequences + informal]

## Diagrams
[Timeline + status]
```

### Diagrams

- **Supersession timeline** — Mermaid `timeline`
- **Status distribution** — Mermaid `pie`

---

## Generation and planning policy

- Format declared
- Immutable once accepted
- Supersession chain preserved
- Consequences include trade-offs
- Stable IDs
- No fabricated decisions

---

## Self-check

```
[] Mode declared
[] Format chosen
[] Stable ID
[] Status controlled
[] Context rich
[] Decision clear
[] Consequences with trade-offs
[] Supersession preserved
[] Index updated
[] Diagrams valid
[] No edits to accepted
[] No fabricated decisions
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject (write) | Interview mode (§7) |
| Supersede without target | Ask for target ADR |
| Edit to accepted | Block; require supersession |
| Missing consequences | Require before accepting |
| Informal decision | Recommend retroactive ADR |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out-of-scope |

---

## Quality checks

- [ ] Title imperative + outcome-focused
- [ ] Context rich ≥3 factors
- [ ] Decision clear
- [ ] Consequences balanced (+ / − / neutral)
- [ ] Status lifecycle respected
- [ ] Supersession chain correct
- [ ] Index maintained
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. First ADR for a product**
- Input: Record decision to use Postgres as primary datastore
- Expected: ADR-001 with context (data model relational, need transactions, team familiarity), decision (Postgres 14+ primary), consequences (pros: SQL ecosystem, trade-offs: sharding complexity at scale, neutral: need read-replicas sooner), status Accepted.

**2. Supersession**
- Input: Supersede ADR-003 (session-auth) with ADR-007 (signed-cookie session)
- Expected: ADR-007 written referencing ADR-003; ADR-003 status changed to "Superseded by ADR-007"; ADR-003 content preserved; index updated with both.

**3. Review mode**
- Input: Review existing 20-ADR log after 12 months
- Expected: 2 marked Deprecated (system moved past), 1 missing Consequences analysis (flag for rewrite-or-accept-as-is), 3 informally-made decisions flagged for retroactive ADRs.

**4. Y-statement for small team**
- Input: "We're picking a test framework — want quick record"
- Expected: Y-statement: "In the context of new service needing tests, facing framework choice between Jest and Vitest, we decided Vitest, neglecting Jest, to achieve faster test runs, accepting newer ecosystem maturity."

**5. Multi-ADR architectural shift**
- Input: Moving from monolith to microservices (multiple ADRs)
- Expected: ADR-010 (adopt microservices pattern), ADR-011 (service boundaries follow bounded contexts), ADR-012 (event-driven integration), etc. Related-to chain visible in index.

### Edge cases

**6. ADR that's really a proposal**
- Input: User drafts decision but team hasn't committed
- Expected: Status = Proposed; flag that content can still change until Accepted; review cycle recommended.

**7. Retroactive ADR for old decision**
- Input: Team made decision 2 years ago, wants to record now
- Expected: Accept as legitimate; date reflects original decision; context should note retroactive nature ("Recorded 2026; original decision made 2024").

**8. ADR with wide blast radius**
- Input: Decision affects many teams / systems
- Expected: Consequences section expanded; link to `impact-analysis`; recommend wider stakeholder review before Accepted.

### Failure cases

**9. Edit to accepted ADR**
- Input: "Update ADR-003 content"
- Expected: Block — "Accepted ADRs are immutable. Write ADR-NNN to supersede with new content."

**10. No decision subject**
- Input: "Write an ADR"
- Expected: Interview — "Which architectural decision are you recording?"
