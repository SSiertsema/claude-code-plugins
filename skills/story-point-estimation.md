# Story Point Estimation — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | story-point-estimation |
| **Version** | 1.0.0 |
| **Purpose** | Defines and applies story-point methodology — the criteria and reasoning behind relative sizing. Distinct from `planning-poker-protocol` (how a session is facilitated) — this skill is the substance: what points mean, how to calibrate, how to interpret velocity. Points compound three dimensions: complexity (cognitive + architectural reach) × uncertainty (unknowns) × effort (time — but as input, not sole factor). Fibonacci progression (1, 2, 3, 5, 8, 13, 21) encodes exponential uncertainty with size — larger items are less distinguishable, so granularity drops. Team-specific calibration via 3–5 reference stories spanning the size range, with re-calibration quarterly or on team-composition change. Four modes: `estimate` (new items via reference comparison), `calibrate` (establish or refresh references), `forecast` (velocity-based release planning with range — mean / min / max / std), `audit` (evaluate existing estimates for anti-patterns). Explicitly surfaces anti-patterns: hours-to-points conversion, velocity-as-productivity, cross-team comparison, epic-level estimation, velocity-driven inflation, ignoring `?` cards, velocity-to-hours conversion. Mermaid velocity trend, release forecast, and size distribution diagrams with PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Establishing or refreshing story-point calibration for a team
- Forecasting a release based on velocity + backlog
- Auditing existing estimates for quality / anti-patterns
- Coaching team on what story points actually mean
- Complement to `planning-poker-protocol` (the how) — this is the what and why

## When not to use

- Facilitating the estimation session itself → `planning-poker-protocol`
- Splitting stories too big to estimate → `story-splitting`
- Ab-initio time estimation (no relative reference) → `cost-estimation` / `timeline-estimation`
- Capacity / resource planning → future resource-planning skill
- OKR / goal sizing at strategic level → `okr-definition`

---

## Required input

| Field | Description |
|---|---|
| **Team context** | Team name + composition |
| **Mode** | estimate / calibrate / forecast / audit |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Stories to estimate** | Required in estimate mode | — |
| **Existing references** | For calibration | Elicit or establish |
| **Velocity history** | Recent sprint velocities | Required for forecast mode |
| **Backlog** | For forecast | Points or story list |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/story-point-estimation/` |

## Input schema

```
input:
  required:
    team:
      type: object
      properties:
        name: string
        composition: string
    mode:
      type: string
      enum: [estimate, calibrate, forecast, audit]
  optional:
    stories: list[object]
    references: list[object]
    velocity_history: list[number]
    backlog: object
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
Collect team + mode.

### Phase 2 — Points definition
Complexity × uncertainty × effort.

### Phase 3 — Fibonacci rationale
Exponential-uncertainty encoding.

### Phase 4 — Reference calibration
3–5 references across range.

### Phase 5 — Per-story estimate
Reference comparison + confidence.

### Phase 6 — Velocity & forecast
Mean / min / max / std; range not point.

### Phase 7 — Anti-patterns
Surface + mitigations.

### Phase 8 — Diagrams
Velocity trend + release forecast + size distribution.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Story Point Estimation: [Team / Subject]

**Date**: [date]
**Team**: [name + composition]
**Mode**: [mode]

## Scope
[Team, mode, references, velocity history]

## What Story Points Mean
[Team-specific: complexity × uncertainty × effort]

## Reference Stories
[Calibrated with rationale]

## Per-story Estimates (estimate mode)
[Story / reference / rationale / size / confidence]

## Velocity & Forecast (forecast mode)
[Mean / min / max / std + release range]

## Anti-patterns Surfaced
[Observed or prevented]

## Diagrams
[Velocity + forecast + distribution]

## Assumptions & Limitations
[Team assumptions, forecast caveats]
```

### Diagrams

- **Velocity trend** — Mermaid `xychart-beta`
- **Release forecast** — Mermaid `xychart-beta`
- **Size distribution** — Mermaid `pie`

---

## Assessment and planning policy

- Per-story rationale across three dimensions
- Reference-comparison based
- Fibonacci only
- Velocity as range
- No fabricated history

---

## Self-check

```
[] Team + mode declared
[] Points definition stated
[] Fibonacci values only
[] Per-story 3-dim rationale + reference
[] Velocity range (not point)
[] Forecast as range
[] Anti-patterns surfaced
[] No hours-to-points
[] No cross-team comparison
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No references | Calibrate first |
| Hours conversion | Refuse + explain |
| Performance use | Refuse + explain |
| Cross-team comparison | Refuse + explain |
| Epic estimation | Split first |
| mmdc failure | See `diagram-rendering` mixin |
| Delivery guarantee | Out-of-scope |

---

## Quality checks

- [ ] Points definition
- [ ] References
- [ ] Fibonacci only
- [ ] Reference-based estimates
- [ ] Velocity range
- [ ] Anti-patterns
- [ ] No fabrication

---

## Examples

### Normal cases

**1. New team calibration**
- Input: Team just formed, mode = calibrate
- Expected: Establish 3–5 references; team agrees on each size; output: reference document for future estimation sessions; recommendation to re-calibrate after 1 quarter.

**2. Backlog estimation**
- Input: 25 stories to estimate, existing references available
- Expected: Per-story 3-dimension rationale + closest reference + size + confidence; flag 3 items at size 13+ for splitting; low-confidence items marked for refinement.

**3. Release forecast**
- Input: Backlog 120 points, last 6 sprints: 18, 22, 20, 15, 24, 19
- Expected: Mean 19.7, range 15–24, std ~3; forecast 5–8 sprints (optimistic–conservative); communicate as range; flag velocity volatility if std > 25% of mean.

**4. Audit existing estimates**
- Input: 40 story estimates from recent 3 months
- Expected: Find 8 non-Fibonacci values (4, 6, 10) — recommend snapping to Fibonacci; flag 2 items that showed hours-based rationale in comments; velocity increased 20% over period without team-size change → possible inflation.

**5. Re-calibration after team change**
- Input: 2 new engineers joined, team doubled
- Expected: Re-run calibration with new team; likely reference sizes shift (more parallelism possible); update velocity baseline; communicate that old velocity ≠ new velocity.

### Edge cases

**6. Very small stories dominate backlog**
- Input: 80% of backlog is 1s and 2s
- Expected: Either stories are too granular (recommend grouping) OR work is truly small-slice; check for missing mid-size work; velocity will be noisy.

**7. Very large stories (21+) dominate**
- Input: Multiple 21s in backlog
- Expected: Recommend splitting all 21s before committing to release forecast; 21s have too much embedded uncertainty.

**8. Team requests stopping story points**
- Input: Team wants to try no-estimates / #noestimates approach
- Expected: Valid alternative for some contexts; document trade-offs (forecast granularity, planning rituals); recommend experimenting with count-of-stories velocity as alternative before abandoning entirely.

### Failure cases

**9. Hours-to-points conversion request**
- Input: "Let's say 1 point = 4 hours"
- Expected: Refuse — "Points are relative, not time-based. Reference stories calibrate size. Hours-to-points conversion defeats the purpose."

**10. Out of scope**
- Input: "Estimate + commit team to finish all these in Q3"
- Expected: "Estimate informs forecast as range. Commitment is capacity decision, not estimate consequence. Communicate release ranges, not dates."
