# RACI / RAPID / DACI Responsibility Definition — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | raci-responsibility-definition |
| **Version** | 1.0.0 |
| **Purpose** | Clarifies who does what via the appropriate framework: RACI (Responsible / Accountable / Consulted / Informed) for task-level responsibility across ongoing activities — exactly one A per row; RAPID (Recommend / Agree / Perform / Input / Decide) for high-stakes decisions with one D + one R + sparing A veto-equivalents; DACI (Driver / Approver / Contributors / Informed) for lighter single-decision frameworks. Default: RACI for ongoing + RAPID for consequential decisions; hybrid rare. Row-level grain check (not too coarse — "Build product" — and not too fine — "Rename a variable"); rows target activities / decisions where confusion or gaps exist today. Anti-patterns flagged: multiple As, nobody A, all-Cs committee paralysis, same-person R+A bottleneck, every-stakeholder-C, stale unmaintained matrix, wrong-framework-for-question (RACI-for-decisions or RAPID-for-day-to-day). Combines with Team Topologies (platform team = A for platform service, stream = R for usage; enabling team A reverts to stream after engagement). Quarterly review + owner + version + change log + retirement of stale rows. Explicit limits: not a staffing plan, not an org chart. Mermaid role-activity heatmap + RAPID decision flow with PNG export. Hand-offs to `team-topology-design`, `onboarding-plan`, `change-impact-assessment`, `quality-gate-definition`. |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `professional` |
| **Audience** | `mixed` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Ongoing confusion about who owns what
- Setting up cross-team activities
- Major decision requiring explicit rights
- Post-reorg clarification

## When not to use

- Team structure itself → `team-topology-design`
- Onboarding specifically → `onboarding-plan`
- Headcount / staffing plan → HR scope
- Change impact → `change-impact-assessment`

---

## Required input

| Field | Description |
|---|---|
| **Scope** | Product / project / process |
| **Roles or teams** | Columns |
| **Key activities or decisions** | Rows |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Framework preference** | RACI / RAPID / DACI | Chosen per fit |
| **Current pain** | Who owns X? | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/raci-responsibility-definition/` |

## Input schema

```
input:
  required:
    scope: string
    roles: array[string]
    activities_or_decisions: array[string]
  optional:
    framework_preference:
      type: string
      enum: [raci, rapid, daci, hybrid, let-skill-choose]
    current_pain: string
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
Scope + roles + activities + pain + preference.

### Phase 2 — Framework selection
RACI / RAPID / DACI per fit.

### Phase 3 — RACI mechanics
Exactly one A; rules.

### Phase 4 — RAPID mechanics
One D; sparing A.

### Phase 5 — DACI mechanics
Lightweight.

### Phase 6 — Grain check
Meaningful rows.

### Phase 7 — Anti-patterns
Catalog + fixes.

### Phase 8 — Team-topology combo
Platform A + stream R.

### Phase 9 — Review + governance
Owner + quarterly + version.

### Phase 10 — Diagrams
Heatmap + RAPID flow.

### Phase 11 — Diagram rendering
Per mixin.

### Phase 12 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Responsibility Definition: [Scope]

**Date**: [date]
**Scope**: [...]
**Framework**: [...]
**Owner**: [...]
**Version**: v1.0

## Purpose
## Roles
## Matrix
## Notes + Caveats per Row
## Anti-Patterns Avoided
## Review Cadence
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Heatmap** — Mermaid `xychart-beta`
- **Decision flow** — Mermaid `flowchart LR`

---

## Assessment and planning policy

- Right framework
- One A per RACI row
- Meaningful grain
- Anti-patterns avoided
- Quarterly review
- Owner named
- No fabricated roles

---

## Self-check

```
[] Framework matches
[] One A per RACI row
[] Rows meaningful grain
[] Anti-patterns avoided
[] Notes for non-obvious rows
[] Owner + review cadence
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No scope / roles | Interview mode (§7) |
| RACI for single decision | Switch to RAPID/DACI |
| Multiple As | Require single A |
| All-C rows | Reduce to I |
| Generic rows | Require grain |
| Staffing | Out of scope |
| Team design | Redirect |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Every row has exactly one A (RACI)
- [ ] Every RAPID row has one D + one R
- [ ] No all-C rows
- [ ] Rows tied to real decisions / activities
- [ ] Owner + review cadence set
- [ ] Diagram renders

---

## Examples

### Normal cases

**1. Cross-team delivery activities**
- Input: Product / eng / design / security / ops
- Expected: RACI matrix for refine / implement / review / deploy / incident / PIR

**2. High-stakes vendor decision**
- Input: Payment provider choice
- Expected: RAPID with CTO=D, Eng director=R, CFO=A, Security=I, Legal=I

**3. Incident response**
- Input: P0 handling
- Expected: Incident commander=A; on-call=R; comms=R; engineering leads=C; execs=I

**4. Cross-team platform adoption**
- Input: Adopting internal platform
- Expected: Platform A on platform services; stream R on usage; enabling R during adoption

**5. Post-reorg clarification**
- Input: Teams restructured
- Expected: Refresh RACI for changed activities; deprecate stale rows

### Edge cases

**6. Single-person A + R**
- Input: Bottleneck shows up
- Expected: Redistribute R or split activity; flag sustainability

**7. Everyone wants C**
- Input: Committee tendency
- Expected: Reduce to I for routine; consult only where decision depends on input

**8. Framework mismatch**
- Input: RACI for one-off launch-go decision
- Expected: Switch to RAPID; clarify decider + veto holders

### Failure cases

**9. No activities / decisions**
- Input: "Write RACI for our team"
- Expected: Interview — what activities or decisions?

**10. Staffing request**
- Input: "Assign headcount"
- Expected: Out of scope
