# Training + Adoption Planning — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | training-adoption-planning |
| **Version** | 1.0.0 |
| **Purpose** | Plans training materials + adoption measurement for a change / new tool / new process. Performs learning-needs analysis per audience identifying ADKAR gaps (Awareness / Desire / Knowledge / Ability / Reinforcement). Selects content mix per audience (2–4 formats from written docs / videos / live workshops / office hours / in-product tours / guided learning paths / certification + badging / peer coaching / sandbox / cheat sheets). Defines delivery pipeline (authoring + SME review + pedagogy review + accessibility review + publishing + versioning + translation pipeline + update cadence). Staged rollout sequencing (champions pre-launch → power users beta → all at launch → admins/ops post-launch → reinforcement 4–12 weeks). Recruits change-champion network (1 per team / 20–50 users) with early access + deeper training + feedback channel + recognition; not burdened as support queue. Plans reinforcement for 3+ months post-launch (digests, continued office hours, success stories, management 1:1 reinforcement, friction-blocker removal, early-adopter recognition) because ADKAR's R is where programs fail. Measures behavior not attendance (activation rate, active use, retention, time-to-proficiency, task success, NPS/CSAT, support-ticket trend, error rate; training completion is secondary). Accessibility + localization from day 1. Compliance training (data privacy, security awareness, sector-specific) tracked with auditable evidence, attestation, escalation. Feedback loops (in-content helpful? widget, post-workshop surveys, ticket-trend analysis, champion feedback, quarterly review). Anti-patterns flagged (one-workshop-for-everyone, measuring-completion-as-success, ship-and-walk-away, no champions, English-only in multilingual org, docs-are-the-training for complex change, stale content). Mermaid adoption-curve (actual vs target) + learning-journey ADKAR flow with PNG export. Hand-offs to `change-impact-assessment`, `documentation-strategy`, `documentation-tooling-selection`, `communication-plan`. |
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

- New feature / tool / process launch requiring adoption
- Org-wide transformation rollout
- Compliance-driven training program
- Post-launch adoption stagnation

## When not to use

- Change impact analysis → `change-impact-assessment`
- Docs strategy or tooling → `documentation-strategy` / `documentation-tooling-selection`
- Stakeholder comms → `communication-plan`

---

## Required input

| Field | Description |
|---|---|
| **Change / tool / process** | What's being adopted |
| **Audiences** | Who needs to learn |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Baseline** | Current adoption / skill | Asked |
| **Target state** | Proficiency + adoption target | Asked |
| **Timeline** | Launch + reinforcement window | Asked |
| **Compliance mandate** | Regulation requiring training | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/training-adoption-planning/` |

## Input schema

```
input:
  required:
    change: string
    audiences: array[string]
  optional:
    baseline: object
    target_state: object
    timeline: object
    compliance_mandate: string
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
Change, driver, audiences, baseline, target, timeline, compliance.

### Phase 2 — Needs analysis
ADKAR-framed per audience.

### Phase 3 — Content mix
2–4 formats per audience.

### Phase 4 — Delivery pipeline
Authoring / review / publishing / translation / cadence.

### Phase 5 — Rollout sequencing
Champions → power → all → admins → reinforcement.

### Phase 6 — Champion network
1 per team / 20–50 users.

### Phase 7 — Reinforcement
3+ months post-launch.

### Phase 8 — Adoption metrics
Behavior not attendance.

### Phase 9 — Accessibility + localization
From day 1.

### Phase 10 — Compliance training
Tracked + attested.

### Phase 11 — Feedback loops
In-content + survey + tickets + champions + quarterly.

### Phase 12 — Anti-patterns
Catalog + fixes.

### Phase 13 — Diagrams
Adoption curve + learning journey.

### Phase 14 — Diagram rendering
Per mixin.

### Phase 15 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Training + Adoption Plan: [Change]

**Date**: [date]
**Change**: [...]
**Audiences**: [...]
**Target adoption**: [...]

## Scope
## Learning-Needs Analysis
## Content Mix
## Delivery Pipeline
## Rollout Sequencing
## Change-Champion Network
## Reinforcement Plan
## Adoption Metrics
## Accessibility + Localization
## Compliance Training
## Feedback Loops
## Anti-Patterns to Avoid
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Adoption curve** — Mermaid `xychart-beta`
- **Learning journey** — Mermaid `flowchart LR`

---

## Assessment and planning policy

- Needs before content
- Mix per audience
- Reinforcement planned
- Behavior metrics
- Champions recruited
- A11y + localization from day 1
- No fabricated audiences

---

## Self-check

```
[] Needs analysis per audience
[] 2–4 formats per audience
[] Delivery pipeline
[] Rollout sequencing
[] Champion network (if scale)
[] Reinforcement 3+ months
[] Adoption metrics on behavior
[] A11y + localization
[] Compliance tracked
[] Feedback loops
[] Anti-patterns
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No audiences | Interview mode (§7) |
| One-workshop-for-all | Segment |
| No reinforcement | Extend 3+ months |
| Training-completion as success | Redefine |
| Change-impact request | Redirect |
| Docs strategy | Redirect |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Needs analysis based on stated baseline
- [ ] Formats justified per audience
- [ ] Champion network sized to population
- [ ] Reinforcement plan concrete
- [ ] Metrics reflect behavior, not attendance
- [ ] Compliance tracking auditable if applicable

---

## Examples

### Normal cases

**1. New internal tool rollout**
- Expected: 3 audiences (devs / admins / support) with tailored formats; champions per team; 3-month reinforcement; behavior metrics

**2. Regulatory GDPR training**
- Expected: LMS with attestation; annual cadence; multi-language; non-completion escalation

**3. Big UX redesign**
- Expected: In-product tours + digest emails + office hours; activation/retention metrics; champion-led Q&A

**4. Platform adoption**
- Expected: Deep workshops for early adopters; sandbox + office hours; success-story amplification; champion network

**5. Post-launch adoption stagnation**
- Expected: Diagnose gap (Awareness / Desire / Knowledge / Ability / Reinforcement) + targeted intervention

### Edge cases

**6. Multi-language global rollout**
- Expected: Priority-based localization; locale-aware examples; regional champions

**7. Accessibility-driven rollout**
- Expected: All content AA; captions + transcripts; keyboard-navigable tools; accommodations honored

**8. Training fatigue**
- Expected: Reduce mandatory volume; compact + role-scoped; opt-in deepening

### Failure cases

**9. No audiences**
- Input: "Plan training"
- Expected: Interview — who + what + baseline

**10. Docs tooling question**
- Input: "What docs tool?"
- Expected: Redirect to `documentation-tooling-selection`
