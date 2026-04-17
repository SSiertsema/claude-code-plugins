# Definition of Ready + Done — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | definition-of-ready-done |
| **Version** | 1.0.0 |
| **Purpose** | Establishes Definition of Ready (DoR — gate a backlog item passes before sprint commit) and Definition of Done (DoD) at three levels (story / sprint / release). DoR checklist short enough to enforce (5–8 items typical: user-value stated, AC in team format, dependencies identified, designs linked if UI, NFRs identified, data/fixtures available, sized, no blockers). Acceptance-criteria format standardized per team — Given-When-Then / checklist / example-mapping (deep hand-off to `acceptance-criteria-writing` / `example-mapping`). Story-DoD covers merge, CI, tests, SAST, feature-flag safety, AC demoed, docs updated, observability hooks, PO acceptance. Sprint-DoD covers commit outcomes, sprint-goal acknowledgment, retro, release notes, demo. Release-DoD covers regression suite, perf vs baseline, security review, a11y AA, i18n coverage, migration dry run, runbooks updated, on-call briefed, rollback tested (hand-off `support-rollback-planning`), compliance evidence (hand-off `license-compatibility-analysis` / security skills). Separates team-level from org-level DoD (org applies to all; team can be stricter). Waiver process with named approver + expiry + revisit plan; never silent skips. Living document with quarterly review + retro-driven changes + versioning. Anti-patterns flagged (25-item DoD nobody reads, DoR as scope-creep blocker, unverified DoD items, DoD jargon, release DoD assumed but unwritten, exceptions becoming norm). Mermaid Ready→Done lifecycle + DoD-layering with PNG export. |
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

- New team kickoff
- Quality retrospective calling for clearer gates
- Compliance uplift requires codified DoD
- Scaling from one team to many (team vs org DoD)

## When not to use

- Acceptance-criteria deep-dive → `acceptance-criteria-writing`
- Example-mapping workshop → `example-mapping`
- Test strategy → `test-strategy-plan`
- Review process mechanics → `quality-gate-definition`

---

## Required input

| Field | Description |
|---|---|
| **Team** | Identifier + domain |
| **Delivery model** | Scrum / Kanban / SAFe / XP / custom |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Current pain** | What's failing today | Asked |
| **Compliance / regulatory** | GDPR / SOC2 / HIPAA | Asked |
| **Existing DoR / DoD** | Attach or none | None |
| **Levels needed** | Story / sprint / release | All three |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/definition-of-ready-done/` |

## Input schema

```
input:
  required:
    team: string
    delivery_model: string
  optional:
    current_pain: string
    compliance: array[string]
    existing: object
    levels_needed: array[string]
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
Team, model, pain, compliance, existing, levels.

### Phase 2 — DoR
Short checklist gating sprint commit.

### Phase 3 — AC format
GWT / checklist / example-mapping; standardize.

### Phase 4 — Story DoD
Merge / CI / tests / SAST / docs / observability / PO accept.

### Phase 5 — Sprint DoD
Outcomes / retro / demo.

### Phase 6 — Release DoD
Regression / perf / security / a11y / i18n / migration / runbooks / on-call / rollback / compliance.

### Phase 7 — Team vs org DoD
What lives where.

### Phase 8 — Exceptions + waivers
Approver + expiry + revisit.

### Phase 9 — Living documents
Quarterly review + versioning.

### Phase 10 — Anti-patterns
Catalog + fixes.

### Phase 11 — Diagrams
Lifecycle + layering.

### Phase 12 — Diagram rendering
Per mixin.

### Phase 13 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Definition of Ready + Done: [Team]

**Date**: [date]
**Team**: [...]
**Delivery model**: [...]
**Version**: v1.0

## Scope
## Definition of Ready
## Acceptance-Criteria Format
## Definition of Done — Story Level
## Definition of Done — Sprint Level
## Definition of Done — Release Level
## Team-Level vs Org-Level DoD
## Exceptions + Waivers
## Review Cadence
## Anti-Patterns to Avoid
## Diagrams
## Hand-offs
```

### Diagrams
- **Lifecycle** — Mermaid `stateDiagram-v2`
- **DoD layering** — Mermaid `graph TD`

---

## Assessment and planning policy

- DoR pre-commit gate
- DoD per level
- Short + enforceable
- AC format standard
- Team vs org split
- Waiver protocol
- Living document
- No fabricated policies

---

## Self-check

```
[] DoR ≤ 8 items
[] DoD per level
[] AC format standardized
[] Team vs org split
[] Waiver protocol
[] Review cadence
[] Anti-patterns
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No team context | Interview mode (§7) |
| 20+ DoD items | Trim |
| DoR blocking everything | Timeboxed refinement |
| Waiver missing | Add before adopting |
| Test-plan request | Redirect |
| AC deep-dive | Redirect |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] DoR items enforceable
- [ ] Story / sprint / release DoDs distinct
- [ ] Verification attached per DoD item
- [ ] Waiver process named approver + expiry
- [ ] Review cadence set
- [ ] Team and org layered

---

## Examples

### Normal cases

**1. New Scrum team**
- Input: Product team, Scrum, no existing DoR/DoD
- Expected: 6-item DoR, 8-item story DoD, sprint + release DoD, GWT as AC format

**2. Compliance uplift (SOC 2)**
- Input: Org-wide SOC 2 readiness
- Expected: Org DoD with SOC 2 controls; team DoDs inherit; evidence gathering per release

**3. Multi-team program**
- Input: SAFe, 5 teams
- Expected: Team DoDs consistent with program DoD; tribe-level ceremonies reflected

**4. Quality retro output**
- Input: Defects leaking to prod
- Expected: Tightened release DoD; added observability + regression criteria; waiver process for emergencies

**5. Platform team**
- Input: Internal-platform team
- Expected: DoD includes API contract + SDK publication + consumer migration path

### Edge cases

**6. Heavy regulatory product**
- Expected: Release DoD extended with legal + compliance sign-offs; waivers rare + named executive approver

**7. Weekly-release team**
- Expected: Release DoD lean but enforced; sprint DoD may fold into release; regression automation heavy

**8. Early-stage team**
- Expected: Short DoR; minimal release DoD; revisit quarterly as product matures

### Failure cases

**9. 25-item DoD copied from elsewhere**
- Expected: Trim to essentials; explain enforcement > checklist length

**10. Test-plan request**
- Input: "Write our test strategy"
- Expected: Redirect to `test-strategy-plan`
