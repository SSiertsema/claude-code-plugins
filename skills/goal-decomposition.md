# Goal Decomposition — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | goal-decomposition |
| **Version** | 1.0.0 |
| **Purpose** | Decomposes a top-level goal (vision or strategic objective) into sub-goals down to operational / measurable level. Supports four decomposition methods: `goal-tree` (default — vision → strategic → tactical → operational with time-horizon conventions), `GQM` (Goal-Question-Metric, measurement-driven), `i*` (actor-goal model with softgoals / hardgoals / dependency arrows), and `means-ends` (recursive means-to-end analysis). Per goal produces stable ID, level, verb-led statement, parent ID, contribution-type to parent (`necessary` / `sufficient` / `contributing`), success criteria, owner (required at operational level), horizon, measure (quantitative metric or observable milestone), status, dependencies, and risks. Surfaces tensions (conflicts between sibling goals) with explicit resolution notes rather than hiding them. Maps cross-goal dependencies beyond parent-child. Verifies operational leaves against SMART criteria. Feeds `okr-definition`, `metric-definition`, and roadmap skills. Mermaid goal-tree, dependency overlay, and conflict map with PNG export. |
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

- Translating a vision / strategy into actionable goals
- Aligning teams on goal hierarchy before OKR setting
- Pre-measurement-plan work (GQM for engineering / quality programs)
- Multi-actor strategic alignment (i* for cross-team dependencies)
- Surfacing goal conflicts that often stay hidden

## When not to use

- OKR definition itself → `okr-definition` (this skill feeds it)
- Metric design across a program → `metric-definition` (feeds this)
- Roadmap / theme planning → `theme-roadmapping`
- Prioritization of already-defined items → `prioritization`
- Risk management → risk skills (but dependencies / risks flagged here)

---

## Required input

| Field | Description |
|---|---|
| **Top-level goal** | Vision or strategic objective |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Method** | goal-tree / GQM / i* / means-ends | goal-tree |
| **Horizon** | Time scope for each level | Level-defaults |
| **Existing structure** | Partial tree | Elicit |
| **Stakeholders / owners** | Known assignees | Asked |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/goal-decomposition/` |

## Input schema

```
input:
  required:
    top_goal:
      type: string | document_reference
  optional:
    method:
      type: string
      enum: [goal-tree, GQM, i-star, means-ends]
      default: goal-tree
    horizon: object
    existing_structure: list[object]
    stakeholders: list[string]
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
Collect top goal + method + horizon.

### Phase 2 — Method selection
goal-tree / GQM / i* / means-ends conventions.

### Phase 3 — Per-goal spec
ID / level / statement / parent / contribution / criteria / owner / horizon / measure / status / deps / risks.

### Phase 4 — Contribution semantics
Necessary / sufficient / contributing per sub-goal.

### Phase 5 — Conflict surfacing
Tensions + resolution notes.

### Phase 6 — Dependencies
Cross-goal dependencies (beyond parent-child).

### Phase 7 — Measurability
SMART at operational level; qualitative OK at higher levels with observable conditions.

### Phase 8 — Diagrams
Tree + dependency overlay + conflict map.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Goal Decomposition: [Top-level goal]

**Date**: [date]
**Method**: [method]
**Horizon**: [period]
**Goal count**: [N]

## Scope
[Top-level, method, horizon, stakeholders]

## Goals
[Full table]

## Contribution Semantics
[N / S / C per sub-goal]

## Conflicts
[Tensions + resolutions]

## Dependencies
[Cross-goal deps + criticality]

## Measurability
[SMART check at ops]

## Diagrams
[Tree + dependency + conflict]

## Assumptions & Limitations
[`[Assumed]` goals, gaps]
```

### Diagrams

- **Goal tree** — Mermaid `flowchart`
- **Dependency overlay** — Mermaid `flowchart` (dashed arrows)
- **Conflict map** — Mermaid `flowchart` (bidirectional tension arrows, if conflicts)

---

## Generation and planning policy

- Every goal: level + parent + measure
- Contribution type from vocabulary
- Conflicts surfaced
- Owners at ops level
- No fabricated goals

---

## Self-check

```
[] Top goal declared
[] Method selected
[] Multi-level tree
[] Per-goal complete
[] Contribution type
[] Conflicts surfaced with resolution
[] Dependencies mapped
[] SMART at ops
[] Diagrams valid
[] No fabricated goals
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No top-level goal | Interview mode (§7) |
| Method mismatch | Offer default or ask for method-specific input |
| Ops goals without owners | Flag |
| All leaves qualitative | Push for quantitative |
| Conflicts unresolved | Force explicit note |
| mmdc failure | See `diagram-rendering` mixin |
| OKR writing | Pointer to `okr-definition` |

---

## Quality checks

- [ ] Method declared
- [ ] Multi-level decomposition
- [ ] Per-goal spec
- [ ] Contribution type
- [ ] Conflicts
- [ ] Dependencies
- [ ] Measurability
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Company vision → strategy decomposition**
- Input: "Be the trusted productivity tool for creative teams"
- Expected: Vision → 3 strategic (trust / adoption / differentiation) → 6 tactical → 15 operational. Conflicts: "differentiation" vs "adoption" (complex features slow adoption). Owners assigned at ops level.

**2. GQM for engineering quality**
- Input: Goal = "Reduce production defects", method = GQM
- Expected: Goal → Questions (which defects most common? introduced where? detected where?) → Metrics (defect count by severity by module by phase). Feeds metric-definition.

**3. i* for cross-team dependency**
- Input: Actor goals for product + engineering + sales
- Expected: Actors with softgoals and hardgoals; dependency arrows showing sales depends on product for demo readiness, engineering depends on product for scope stability; conflicts surfaced.

**4. Means-ends for feasibility**
- Input: Goal = "Achieve < 100ms p95 latency", means-ends
- Expected: Means = (caching / DB optimization / CDN / code optimization / compute upgrade); each decomposed; leaves are concrete actions.

**5. Strategic reset**
- Input: Existing goal tree + company pivot
- Expected: Tree annotated with status (achieved / abandoned / modified / new); transition plan.

### Edge cases

**6. Vague top-level goal**
- Input: "Grow"
- Expected: Interview — "Grow what? Revenue? Users? Markets? Headcount?" Refuse to decompose without specificity.

**7. Goals with strong tension**
- Input: Product goals include "ship fast" + "zero defects"
- Expected: Surface tension explicitly; decomposition must include quality floor + speed target that are reconcilable; decision needed.

**8. 200-leaf decomposition**
- Input: Very detailed decomposition proposed
- Expected: Flag over-decomposition; recommend collapsing operational leaves with common owners into tactical clusters.

### Failure cases

**9. No top-level goal**
- Input: "Decompose some goals"
- Expected: Interview — "What's the top-level goal?"

**10. OKR writing**
- Input: "Decompose + write OKRs"
- Expected: "Decomposition here; OKR format/structure in `okr-definition`."
