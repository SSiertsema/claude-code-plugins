# Planning Poker Protocol — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | planning-poker-protocol |
| **Version** | 1.0.0 |
| **Purpose** | Facilitates a planning-poker estimation session with an anti-anchoring, consensus-driven protocol. Produces a facilitator guide (opening / per-item estimation / closing agenda with timeboxes) plus a documentation template for recording outcomes. Per-item protocol: introduce (2 min) → questions (2 min) → silent card selection (1 min, prevents anchoring) → reveal (30 sec) → outlier discussion driven by highest + lowest estimators (3 min, not averaging) → re-vote (1 min) → converge or park (1 min, max 3 rounds). Default Fibonacci card set (0/1/2/3/5/8/13/21/?/∞/☕) with alternatives (t-shirt / powers-of-2). Reference stories for calibration required or strongly recommended. Per-item outcome log: rounds, per-round spread, final estimate, confidence, discussion notes, open questions, outcome (estimated / parked / split). Surfaces common anti-patterns (anchoring, authority bias, averaging, hours-to-points conversion, velocity-as-productivity, estimating-without-splitting) with mitigations. Two modes: `facilitation` (live session structure) and `documentation` (structure a completed session's data). Feeds `story-point-estimation` (criteria behind points) and `story-splitting` (when items size ≥13 or ∞). Mermaid session-flow diagram and optional per-item card-distribution chart with PNG export. |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Running a sprint-planning estimation session
- Structuring a team's first planning-poker meeting (protocol scaffolding)
- Documenting a completed informal estimation session rigorously
- Coaching team on anti-pattern avoidance
- Pairs with `story-point-estimation` (criteria) + `story-splitting` (when items too big)

## When not to use

- Defining what story points mean → `story-point-estimation`
- Splitting oversized items → `story-splitting`
- Writing the stories being estimated → `user-story-generator` / `acceptance-criteria-writing`
- Planning at release / roadmap level → `theme-roadmapping`
- Capacity / velocity forecasting → future capacity-planning skill

---

## Required input

| Field | Description |
|---|---|
| **Mode** | facilitation / documentation |

In facilitation mode: session structure sufficient.
In documentation mode: items + per-item outcome data required.

## Optional input

| Field | Description | Default |
|---|---|---|
| **Items to estimate** | For facilitation (planned) or documentation (completed) | — |
| **Participants** | Roles + count | Asked |
| **Card set** | Fibonacci / t-shirt / powers-of-2 / custom | Fibonacci |
| **Reference stories** | Calibration pairs | Strongly recommend ≥2 |
| **Timebox per item** | Per-item limit | 10 min |
| **Session duration** | Total target | Computed |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/planning-poker-protocol/` |

## Input schema

```
input:
  required:
    mode:
      type: string
      enum: [facilitation, documentation]
  optional:
    items: list[object]
    participants: object
    card_set:
      type: string
      enum: [fibonacci, t-shirt, powers-of-2, custom]
      default: fibonacci
    reference_stories: list[object]
    timebox_per_item_minutes:
      type: integer
      default: 10
    session_duration_minutes: integer
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
Collect mode + participants + card set + reference stories.

### Phase 2 — Card sets
Fibonacci default with meaning per value.

### Phase 3 — Reference stories
Calibration with 2–3 references.

### Phase 4 — Per-item protocol
Introduce → questions → silent → reveal → outlier discussion → re-vote → converge or park.

### Phase 5 — Anti-patterns
Surface + mitigate.

### Phase 6 — Per-item outcome log
Rounds / spread / final / confidence / notes / open questions.

### Phase 7 — Session summary
Counts + follow-ups.

### Phase 8 — Facilitation artifacts
Agenda + live-session materials list.

### Phase 9 — Documentation
Retrospective structuring of completed session.

### Phase 10 — Diagrams
Session flow + card distribution.

### Phase 11 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 12 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Planning Poker: [Session name]

**Date**: [date]
**Mode**: [facilitation / documentation]
**Participants**: [count + roles]
**Card set**: [set]

## Scope
[Mode, participants, card set, references, timebox]

## Reference Stories
[Calibration]

## Protocol (facilitation) / Outcomes (documentation)
[Per-item]

## Session Summary
[Counts + follow-ups + retrospect]

## Anti-patterns Called Out
[Observed or prevented]

## Diagrams
[Session flow + distributions]

## Assumptions & Limitations
[Gaps]
```

### Diagrams

- **Session flow** — Mermaid `flowchart`
- **Card distribution per item** — Mermaid `xychart-beta` (optional)

---

## Planning and generation policy

- Silent card selection required
- Outlier-driven discussion (not averaging)
- Reference stories for calibration
- Timebox per item
- Relative (not hours)
- No fabricated outcomes

---

## Self-check

```
[] Mode declared
[] Participants + card set + timebox
[] Reference stories identified or recommended
[] Per-item protocol followed
[] Outcome log per item
[] Session summary
[] Anti-patterns named
[] Relative points (no hours)
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No items | Interview mode (§7) |
| No references | Recommend ≥2 before starting |
| Session too long | Split across sessions or reduce items |
| Averaging behavior | Flag; re-vote |
| Item always `∞` | Recommend `story-splitting` |
| mmdc failure | See `diagram-rendering` mixin |
| Velocity-commit request | Out-of-scope |

---

## Quality checks

- [ ] Mode declared
- [ ] Protocol followed per item
- [ ] Outcome log complete
- [ ] Anti-patterns addressed
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Sprint planning facilitation**
- Input: 12 items, 6 participants, 2-hour session
- Expected: Agenda with 10 min opening + 10 min × 12 items + 10 min closing = ~140 min; realistic fit warning if overrun; reference stories recommended upfront.

**2. Distributed team via digital tool**
- Input: Remote team using planning-poker web app
- Expected: Protocol adapted for digital (silent-selection via app) + video call etiquette (muted during silent, "show of hands" for reveal consensus); timer enforced.

**3. Documentation of completed session**
- Input: Session already held; user supplies notes
- Expected: Structure into outcome log per item; identify anti-patterns if raw notes show them (e.g., all items converged round 1 = maybe no silent selection).

**4. High-divergence item**
- Input: Item with round-1 spread of 2 to 21
- Expected: Outlier discussion mandatory; likely assumptions differ; 2–3 rounds; recommendation: probably needs splitting regardless of final estimate.

**5. Team new to planning poker**
- Input: First-time session
- Expected: Add opening "rules review" (10 min); pick reference stories together as first exercise; estimate only 5 items in first session to learn protocol.

### Edge cases

**6. No reference stories available**
- Input: Greenfield team, nothing to reference
- Expected: Start session with "pick 3 items we all know, agree on sizes" as reference-building exercise before estimating new items.

**7. Single-person team**
- Input: Solo estimator
- Expected: Planning poker is a group protocol; solo estimation falls back to personal judgment. Document rationale instead of pretending voting.

**8. Items all timeboxed (spikes)**
- Input: Research spikes to estimate
- Expected: Spikes are typically timeboxed not sized; estimate time directly (2-day, 1-week); note exception to standard protocol.

### Failure cases

**9. No mode**
- Input: "Do planning poker"
- Expected: Interview — "Facilitate a session or document a completed one?"

**10. Out of scope**
- Input: "Planning poker + commit team to deliver all estimated in sprint"
- Expected: "Protocol only. Commitment is capacity planning — use estimates as input, not contract."
