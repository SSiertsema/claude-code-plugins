# Timeline Estimation — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | timeline-estimation |
| **Version** | 1.0.0 |
| **Purpose** | Produces a defensible timeline for a project, release, or initiative using multiple techniques: three-point / PERT (`(O + 4M + P) / 6`), analogous, parametric (per-unit × count), and velocity-based (story points ÷ team velocity). Converts effort to duration accounting for parallel FTE and coordination overhead (typical 1.2–1.5×). When dependencies are supplied (or a `dependency-mapping` output is referenced), computes the critical path with forward/backward pass and reports the critical-path duration for O / M / P scenarios. Translates working-day durations into calendar dates, respecting holidays and freezes. Recommends schedule contingency (10–40%) by risk level with placement rationale. Defines 3–7 milestones with target date, range, and entry criteria. Runs ±20% sensitivity on top 3 critical-path items. If a deadline is supplied, assesses probability of meeting. Mermaid Gantt (critical path highlighted), timeline range (xychart), and optional sensitivity diagrams with PNG export. Feeds `business-case-management`, pairs with `cost-estimation`. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Estimating timeline for a project, release, or initiative with labeled confidence
- Producing a milestone plan with date ranges (not a single end-date)
- Computing critical path and schedule sensitivity when dependencies are known
- Assessing deadline feasibility and proposing mitigation when at risk

## When not to use

- Cost estimation → `cost-estimation`
- Dependency identification itself → `dependency-mapping`
- Resource / team planning → future `resource-planning` skill
- Release planning (goals, scope, comms) → future `release-planning` skill
- Business case → `business-case-management`

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Project, release, or initiative being scheduled |
| **Work items** | ≥5 named items that consume time |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Start date** | ISO date | Today |
| **Dependencies** | Supplied list or `dependency-mapping` output reference | Inferred sequential with `[Assumed]` |
| **Team capacity** | FTE per role or velocity | `[Assumed]` |
| **Calendar** | Holidays, freezes | 5-day working week |
| **Deadline** | ISO date | None |
| **Risk level for buffer** | low / medium / high / very-high | medium (20%) |
| **Estimation techniques** | `three-point` / `analogous` / `parametric` / `velocity-based` | `three-point` + `analogous` |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/timeline-estimation/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    work_items:
      type: list[object]
      min: 5
      properties:
        name: string
        effort: string
        role: string
  optional:
    start_date:
      type: string
    dependencies:
      type: list[object] | document_reference
    team_capacity:
      type: object
    calendar:
      type: object
      properties:
        working_days_per_week: integer
        holidays: list[string]
        freezes: list[object]
    deadline:
      type: string
    risk_level:
      type: string
      enum: [low, medium, high, very-high]
      default: medium
    techniques:
      type: list[string]
      enum_values: [three-point, analogous, parametric, velocity-based]
      default: [three-point, analogous]
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

Collect subject and work items; interview mode (§7) if <5. Detect start date, dependencies, capacity, calendar, deadline, risk level, techniques. Confirm scope.

### Phase 2 — Per-item duration

Effort + parallel FTE + overhead factor (1.2–1.5×) → duration O/M/P. PERT expected.

### Phase 3 — Critical path

If dependencies available: topological sort → forward/backward pass → slack → critical path. Otherwise: sequential with `[Assumed]` label, recommend `dependency-mapping`.

### Phase 4 — Calendar translation

Working days → calendar dates, respecting holidays/freezes. ISO dates per scenario.

### Phase 5 — Contingency

Buffer by risk level (10/20/30/40%). Placement justified.

### Phase 6 — Milestones

3–7 milestones with target date (M), range (O–P), entry criteria.

### Phase 7 — Sensitivity

Top 3 critical-path items × ±20%. Identify most sensitive.

### Phase 8 — Deadline analysis (conditional)

Compare scenarios to deadline; qualitative probability; mitigation recommendations.

### Phase 9 — Recommendations

End-date range + critical path + deadline probability + refinement priority + downstream skills.

### Phase 10 — Diagrams

Gantt (critical path highlighted), timeline range (xychart), optional sensitivity.

### Phase 11 — Diagram rendering

Per `diagram-rendering` mixin.

### Phase 12 — Report assembly and approval

Full report; present for approval; save only after confirmation.

---

## Output contract

### Report structure

```markdown
# Timeline Estimation: [Subject]

**Date**: [date]
**Start date**: [ISO date]
**End-date range**: O [date] | M [date] | P [date]
**Critical path duration (M)**: [N days]
**Confidence**: [high / medium / low]

## Scope
[Work items + team capacity + calendar + deadline]

## Techniques
[Per technique: rationale]

## Per-item Duration
[Table: effort, FTE, O/M/P, PERT]

## Dependencies & Critical Path
[Dependency source + critical path + durations O/M/P]

## Calendar Translation
[Scenario end dates, holidays/freezes respected]

## Schedule Contingency
[Buffer + placement + justification]

## Milestones
[3–7 with target, range, entry criteria]

## Diagrams
[Gantt + timeline range + optional sensitivity]

## Sensitivity Analysis
[Top 3 critical-path drivers]

## Deadline Analysis (conditional)
[Deadline vs scenarios, probability, mitigation]

## Recommendations
[End-date range + refinement priority + downstream skills]

## Evidence & Assumptions
[`[Assumed]` durations, capacities, calendars]

## Limitations
[Data gaps, schedule sensitivity]
```

### Diagrams

- **Gantt** — Mermaid `gantt` with critical path highlighted (`:crit`)
- **Timeline range** — Mermaid `xychart-beta`
- **Sensitivity** — Mermaid `xychart-beta` (optional)

---

## Generation and planning policy

**Generation (primary)**:
- Durations may be inferred when sparse, every inference `[Assumed]`
- Never fabricate vendor delivery dates, market launch windows, or velocities

**Planning (secondary)**:
- Critical path deterministic
- Buffer placement justified
- Deadline probability calibrated

---

## Self-check

```
[] ≥5 work items with O/M/P durations
[] Effort → duration with FTE + overhead factor
[] PERT computed
[] Dependencies sourced (supplied / inferred / flagged)
[] Critical path computed when dependencies available
[] Calendar translation respects working days + holidays
[] Buffer applied with rationale
[] 3–7 milestones with target, range, entry criteria
[] Sensitivity on top 3 items
[] Deadline probability stated when supplied
[] `[Assumed]` labels on inferred values
[] End-date range (not single date)
[] All diagrams valid Mermaid
[] Gantt highlights critical path
[] No fabricated dates or velocities
[] Recommendations with refinement priority
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject or <5 items | Interview mode (§7) |
| No dependencies, many items | Offer light dependency mapping, or assume sequential with `[Assumed]` |
| No capacity / velocity | `[Assumed]` defaults with rationale |
| Deadline unachievable in P scenario | Surface clearly, recommend mitigation |
| Deadline unachievable in all scenarios | Flag, propose scope reduction |
| Calendar not supplied | 5-day week, `[Assumed]` label |
| Cycles in dependencies | Block critical path until resolved |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope (e.g., "also cost this") | Pointer to `cost-estimation` |

---

## Quality checks

- [ ] ≥5 items
- [ ] PERT applied
- [ ] Critical path when deps available
- [ ] Calendar-translated dates
- [ ] Buffer with placement justification
- [ ] Milestones with entry criteria
- [ ] Sensitivity on top 3
- [ ] Deadline probability if deadline supplied
- [ ] Diagrams valid
- [ ] No fabricated dates

---

## Examples

### Normal cases

**1. Software release**
- Input: 8 work items with effort (person-days), 4-FTE team, sequential dependencies
- Expected: O/M/P per item, critical path 5 items, M end-date 12 weeks out, 20% buffer added at project end, 5 milestones (kickoff, design done, feature complete, beta, GA), sensitivity: "QA effort" swings end-date ±8 days.

**2. With `dependency-mapping` reference**
- Input: "Use the dependency-mapping output from last week + durations per item"
- Expected: Critical path imported from the dep-map, durations applied, calendar end-dates per scenario, deadline comparison if supplied.

**3. With deadline at risk**
- Input: 6 items + 8-week deadline; M scenario end-date is 9 weeks out
- Expected: Deadline probability `medium — at risk`; mitigation options: "Parallelize items 2 and 3 (saves 1 week)" / "Drop item 4 from scope (saves 5 days)" / "Add 1 FTE to item 5 (saves 4 days)".

**4. Parametric**
- Input: "12 similar API endpoints, past velocity 2 endpoints per week per dev, 3-dev team"
- Expected: Parametric estimate (12 endpoints ÷ 6/week = 2 weeks duration), cross-check with three-point per endpoint, conservative P scenario adjusted for integration overhead.

**5. Velocity-based**
- Input: 80 story points, team velocity 20 points/sprint, 2-week sprints
- Expected: 4-sprint estimate (8 weeks), O/M/P ±20% around velocity uncertainty, milestones mapped to sprint boundaries.

### Edge cases

**6. Holiday overlap**
- Input: Timeline crosses Dec 20 – Jan 3 freeze
- Expected: Working days recalculated to skip freeze; end-dates shifted accordingly; flagged explicitly in report.

**7. No dependencies supplied, large item list**
- Input: 20 items, no dependency info
- Expected: Offer light `dependency-mapping` as first step; if user declines, assume fully sequential, flag as worst-case upper bound, recommend dependency analysis.

**8. Cycles in dependencies**
- Input: Dependency map contains cycles
- Expected: Block critical path computation; refer user to `dependency-mapping` to resolve cycles first.

### Failure cases

**9. Fewer than 5 items**
- Input: 3 tasks
- Expected: Interview — "Timeline estimation is most useful with ≥5 items. Would you like to decompose further, or proceed with a simple sequence?"

**10. Out of scope**
- Input: "Also estimate cost and write the business case"
- Expected: "This skill estimates timeline. For cost: `cost-estimation` (effort per item plugs in directly). For business case: `business-case-management` (this skill's output feeds the timeline section)."
