# Change Impact Assessment — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | change-impact-assessment |
| **Version** | 1.0.0 |
| **Purpose** | Assesses impact of a proposed change across seven dimensions: (A) stakeholder impact with magnitude + reach per stakeholder + required action; (B) systems/technical — services touched, data model, API versioning implications (hand-off to `api-versioning-strategy`), perf + capacity, security + compliance, observability, dependencies; (C) process — internal workflows, escalation paths, SLAs, approval chains; (D) data — schema backward-compat, historical-data treatment, retention + residency, GDPR re-consent triggers; (E) training + ability — who + on what + format + cadence (hand-off to `training-adoption-planning`); (F) compliance + legal — regulatory review, audit-trail, DPIA, contract implications; (G) financial — one-time + ongoing + revenue + penalty costs. Applies change-classification frame (ADKAR for individual adoption, Prosci 7-step for org-wide formal programs, Kotter 8-step for transformational, lightweight for small). Magnitude × reach prioritization matrix drives program management decision (broad + high requires explicit program + exec sponsor). Reversibility classification (reversible / mostly / hard / one-way) with irreversible-change 2x scrutiny rule. Urgency classification (low / medium / high) with warning against urgency bypassing assessment. Risk register specific to this change (probability × impact × mitigation × owner) with mitigation strategies (pilot/canary, feature flag, dress rehearsal, training + comms, parallel run, extended hypercare). Sequencing + dependencies feeding `release-planning`. Go/no-go evidence checklist (impact understood, program management if needed, risks reviewed, legal signoff, training ready, rollback tested, teams aligned, freeze windows) — produces inputs, not decision. Hand-offs to `training-adoption-planning`, `communication-plan`, `support-rollback-planning`, `release-planning`, `api-versioning-strategy`, Phase-2 risk skills. Mermaid impact-heatmap + reversibility×urgency quadrant with PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `professional` |
| **Audience** | `mixed` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Before committing to a significant change
- Evidence for go/no-go meeting
- Post-incident remediation affecting multiple systems
- Regulatory-driven program assessment

## When not to use

- Risk register itself → Phase 2 risk skills
- Training plan → `training-adoption-planning`
- Comms plan → `communication-plan`
- Rollback detail → `support-rollback-planning`
- Scheduling → `release-planning`
- Full scope doc → `scope-statement-writing`

---

## Required input

| Field | Description |
|---|---|
| **Change** | Concise description |
| **Scope** | Systems / teams / customers |
| **Timeline** | Target + hard-deadline flag |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Driver** | Regulatory / strategy / incident | Asked |
| **Reversibility hypothesis** | Reversible / mostly / hard / one-way | Asked |
| **Urgency** | Low / medium / high | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/change-impact-assessment/` |

## Input schema

```
input:
  required:
    change: string
    scope: object
    timeline: string
  optional:
    driver: string
    reversibility_hypothesis:
      type: string
      enum: [reversible, mostly, hard, one-way]
    urgency:
      type: string
      enum: [low, medium, high]
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
Change, driver, scope, timeline, urgency, reversibility.

### Phase 2 — Frame selection
ADKAR / Prosci / Kotter / lightweight.

### Phase 3 — Seven impact dimensions
Stakeholder / systems / process / data / training / compliance / financial.

### Phase 4 — Magnitude × reach
Prioritization matrix.

### Phase 5 — Reversibility + urgency
Classification + scrutiny rules.

### Phase 6 — Risk register
Change-specific with mitigations + owners.

### Phase 7 — Mitigations
Pilot / flag / dress / training / parallel / hypercare.

### Phase 8 — Sequencing + deps
Hard + soft dependencies.

### Phase 9 — Go/no-go inputs
Checklist, not decision.

### Phase 10 — Hand-offs
Training / comms / rollback / scheduling / versioning / risk.

### Phase 11 — Diagrams
Impact heatmap + reversibility/urgency quadrant.

### Phase 12 — Diagram rendering
Per mixin.

### Phase 13 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Change Impact Assessment: [Change]

**Date**: [date]
**Change**: [...]
**Driver**: [...]
**Sponsor**: [...]

## Scope + Timeline + Urgency
## Change-Classification Frame
## Stakeholder Impact
## Systems / Technical Impact
## Process Impact
## Data Impact
## Training + Ability Impact
## Compliance + Legal Impact
## Financial Impact
## Magnitude × Reach Matrix
## Reversibility + Urgency
## Risk Register + Mitigations
## Sequencing + Dependencies
## Go/No-Go Inputs
## Hand-offs
## Diagrams
## Assumptions & Limitations
```

### Diagrams
- **Impact heatmap** — Mermaid `xychart-beta`
- **Reversibility × urgency** — Mermaid `quadrantChart`

---

## Assessment and planning policy

- All 7 dimensions
- Stakeholder-first
- Reversibility + urgency
- Risks + mitigations
- Go/no-go inputs (not decision)
- Hand-offs
- No fabricated stakeholders

---

## Self-check

```
[] 7 dimensions covered
[] Stakeholder map with magnitude + reach
[] Reversibility + urgency
[] Risk register + mitigations + owners
[] Sequencing + deps
[] Go/no-go checklist
[] Hand-offs listed
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No change | Interview mode (§7) |
| Tech-only framing | Extend |
| Irreversible skipped | 2x review |
| Urgency bypass | Produce assessment + waiver log |
| Training detail | Hand off |
| Rollback detail | Hand off |
| Comms detail | Hand off |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Every dimension has a finding or "not applicable"
- [ ] Stakeholder reach accurate
- [ ] Reversibility stated honestly
- [ ] Each risk has mitigation + owner
- [ ] Go/no-go checklist actionable
- [ ] Hand-offs specific

---

## Examples

### Normal cases

**1. Refactor of checkout flow**
- Expected: All 7 dimensions; stakeholder-heavy; mostly-reversible with flag; training for support; canary strategy

**2. Regulatory GDPR remediation**
- Expected: Compliance-heavy; multi-system; hard-to-reverse once data migrated; DPIA; legal signoff

**3. Vendor migration**
- Expected: Process + data + financial heavy; one-way after cutover; parallel run; hypercare post-migration

**4. API deprecation**
- Expected: Reach to all API consumers; hand off to `api-versioning-strategy`; comms-heavy; sunset headers

**5. Org-wide tool change**
- Expected: Prosci-style assessment; training + adoption; staged rollout; exec sponsorship

### Edge cases

**6. Incident-driven hotfix with broad impact**
- Expected: Short assessment + post-change retrospective; ACK urgency didn't skip the dimensions

**7. Silent scope addition mid-project**
- Expected: Assess before acceptance; waiver log if bypassed

**8. Irreversible public announcement**
- Expected: Pre-announce dress-rehearsal; comms approval chain; legal review

### Failure cases

**9. No change described**
- Input: "Assess this"
- Expected: Interview — change + scope + timeline

**10. Decision request**
- Input: "Tell us whether to proceed"
- Expected: "Produce inputs; decision is elsewhere."
