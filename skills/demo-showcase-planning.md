# Demo + Showcase Planning — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | demo-showcase-planning |
| **Version** | 1.0.0 |
| **Purpose** | Plans demos + showcases. Frames purpose first (discovery / feedback / alignment / sales / celebration / training) — different purposes require different agendas + time allocation + success criteria. Adapts language + pace + depth per audience (sprint review / customer advisory board / investor update / internal show-and-tell / external webinar / partner demo / regulator/auditor). Uses narrative arc with time-boxes (hook 30s, context 1–2min, demo 60% of total, insights 2–3min, ask 1–2min, Q&A time-boxed). Scripts each demo segment (action + what to show + what to say + fallback) — no winging. Plans failure recovery with break-glass paths (backend down → pre-recorded video; laggy network → local-first or offline; auth flake → fresh test accounts + reset; data wrong → reset scripts; time overrun → flagged optional segments; live-code breaks → known-good branch). Environment + data prep (stable dedicated env, representative real-shaped data via `test-data-management-strategy`, pre-seeded scenarios with idempotent fast reset, credentials ready + feature-flag states correct, verified 30 min before). Rehearsal cadence (content review T−1w, dry-run 1 technical T−3d, dry-run 2 full-timing T−1d, sound/video check T−30min) with named observer + feedback checklist per run. Structured feedback capture in-session (dedicated scribe with template, polls for online) + post-session (short survey within 24h, interview opt-in, team retro) + close-the-loop (published summary within 1 week, actions announced, decisions looped back). Follow-up actions (owners + dates, decisions with rationale, feedback in backlog, thank-you, recording distribution if policy allows, metrics reviewed). Accessibility built-in (captions live + recorded, screen-reader slides, color-blind-safe visuals, post-session content). Anti-patterns flagged (click-around-without-script, no-failure-backup, too-much-content-for-time, corner-cases-when-golden-path-broken, live-code+live-network, silent-post-demo, bugs-for-honesty-in-sales-demo). Produces demo plan document + post-demo follow-up template. Mermaid narrative-timing chart + rehearsal timeline with PNG export. Hand-offs to `communication-plan`, `training-adoption-planning`, `change-impact-assessment`, `test-data-management-strategy`. |
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

- Sprint review planning
- CAB / customer advisory demo
- Investor update demo
- Product launch demo
- Any live demo where stakes > low

## When not to use

- Broader comms strategy → `communication-plan`
- Training delivery → `training-adoption-planning`
- Change impact analysis → `change-impact-assessment`
- Test data setup → `test-data-management-strategy`

---

## Required input

| Field | Description |
|---|---|
| **Purpose** | Discovery / feedback / alignment / sales / celebration / training |
| **Audience** | Who attends |
| **Content** | What's shown |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Time budget** | Minutes | Asked |
| **Setting** | Live / remote / hybrid / recorded | Asked |
| **Maturity** | Prototype / beta / GA | Asked |
| **Recording policy** | Yes / no / embargo | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/demo-showcase-planning/[demo]/` |

## Input schema

```
input:
  required:
    purpose:
      type: string
      enum: [discovery, feedback, alignment, sales, celebration, training]
    audience: string
    content: array[string]
  optional:
    time_budget_minutes: integer
    setting: string
    maturity: string
    recording_policy: string
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
Purpose, audience, content, maturity, time, setting, recording.

### Phase 2 — Purpose framing
Emphasis per purpose.

### Phase 3 — Audience adaptation
Language + pace + depth.

### Phase 4 — Narrative arc
Time-boxed.

### Phase 5 — Demo script
Per segment.

### Phase 6 — Failure recovery
Break-glass paths.

### Phase 7 — Environment + data
Stable + scripted.

### Phase 8 — Rehearsal cadence
Named observers.

### Phase 9 — Feedback capture
Scribe + survey + close-the-loop.

### Phase 10 — Follow-up
Owners + decisions + recording.

### Phase 11 — Anti-patterns
Catalog + fixes.

### Phase 12 — Accessibility
Captions + screen readers + post-session.

### Phase 13 — Diagrams
Timing + rehearsal.

### Phase 14 — Diagram rendering
Per mixin.

### Phase 15 — Report assembly and approval
Plan + follow-up template. Approval before save.

---

## Output contract

**Two artifacts**:

**A. Demo plan**

```markdown
# Demo Plan: [Name]

**Date**: [...]
**Purpose**: [...]
**Audience**: [...]
**Time budget**: [...]
**Setting**: [...]

## Narrative Arc + Time Allocation
## Script (per segment)
## Failure Recovery Plan
## Environment + Data Prep
## Rehearsal Schedule
## Feedback Capture Plan
## Follow-Up Actions Process
## Accessibility
## Anti-Patterns Avoided
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

**B. Post-demo follow-up template**

```markdown
# Demo Follow-up: [Name] · [Date]

## Attendance
## Key Feedback
## Decisions
## Action Items
## Recording Distribution
## Next Iteration Plan
```

### Diagrams
- **Narrative timing** — Mermaid `xychart-beta`
- **Rehearsal timeline** — Mermaid `timeline`

---

## Assessment and planning policy

- Purpose-driven
- Audience-adapted
- Golden-path scripted
- Failure recovery
- Rehearsed
- Feedback structured
- Follow-up closed
- Accessibility
- No fabricated data

---

## Self-check

```
[] Purpose declared
[] Audience-adapted narrative
[] Time-boxed agenda
[] Script per segment
[] Failure recovery
[] Environment + data prep
[] Rehearsal cadence
[] Feedback structured
[] Follow-up closed
[] Accessibility
[] Anti-patterns
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No purpose | Interview mode (§7) |
| "Wing it" demo | Require script |
| No backup | Require break-glass |
| No feedback capture | Add scribe + survey |
| Broader comms | Redirect |
| Training detail | Redirect |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Purpose + audience alignment
- [ ] Script has fallback per segment
- [ ] Rehearsals scheduled + named observers
- [ ] Feedback capture has owner + template
- [ ] Follow-up publish window committed
- [ ] Accessibility addressed

---

## Examples

### Normal cases

**1. Sprint review**
- Expected: Short informal; golden path; scribe for feedback; next-sprint retro input

**2. Customer Advisory Board**
- Expected: Strategic narrative; 1–2 deep topics; structured feedback; close-the-loop 1w

**3. Investor update**
- Expected: Outcomes + metrics + asks; polished; Q&A reserved

**4. Internal show-and-tell**
- Expected: Cross-team celebration; variety; light Q&A

**5. Product launch demo (external)**
- Expected: Rehearsed + pre-recorded fallback + captions; structured Q&A; recording published

### Edge cases

**6. Technical demo prone to breakage**
- Expected: Heavy pre-recorded backup + local-first path + reset scripts

**7. Regulated audience**
- Expected: Precise language + evidence + controls; recording policy strict

**8. Post-incident stakeholder demo**
- Expected: Transparent narrative + facts + actions; not a sales pitch

### Failure cases

**9. No purpose**
- Input: "Plan a demo"
- Expected: Interview — purpose + audience + content

**10. Training request**
- Input: "Plan training"
- Expected: Redirect to `training-adoption-planning`
