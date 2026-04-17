# Work Breakdown Structure — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | work-breakdown-structure |
| **Version** | 1.0.0 |
| **Purpose** | Produces a work breakdown structure (WBS) from a scope statement and known deliverables. Enforces the 100% rule (WBS covers the whole scope, no more), mutually exclusive siblings, deliverable-oriented decomposition (nodes are artifacts, verbs only at leaves if at all), 8/80-hour work-package sizing (relax to ~1 sprint in agile), depth-by-need (usually 3–5 levels). Supports decomposition axes (deliverable default, phase when lifecycle governance drives, responsibility when teams own vertical slices, hybrid). Every node has a WBS dictionary entry with description, deliverable, acceptance, assumptions, size, dependencies, risks. Milestones distinguished from work packages (zero-duration markers tied to which WBS nodes must be done). Intra-WBS dependencies table (predecessor → successor + type FS/SS/FF/SF) feeds downstream scheduling. Coverage matrix validates scope→WBS completeness. Anti-patterns flagged: activity nodes instead of deliverables, mixed axes per branch, excessive depth without payoff, WBS-as-schedule, missing dictionary, unbalanced-depth bias. Hands off scope definition to `scope-statement-writing`, scheduling/Gantt to `release-planning`, estimation to Phase-3 estimation skills, responsibility mapping to `raci-responsibility-definition`. Mermaid tree + milestone timeline with PNG export. |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Project kickoff: translating scope into a structured work tree
- Re-baselining a project after significant scope change
- Verifying scope coverage with a coverage matrix
- Pre-schedule structural planning

## When not to use

- Full scope document → `scope-statement-writing`
- Scheduling / Gantt → `release-planning`
- Effort estimation per package → Phase 3 estimation skills
- Responsibility assignment → `raci-responsibility-definition`

---

## Required input

| Field | Description |
|---|---|
| **Project name** | Identifier |
| **Scope summary** | One-paragraph scope or link to scope document |
| **Known deliverables** | List |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Decomposition axis** | deliverable / phase / responsibility / hybrid | deliverable |
| **Target depth** | Max levels | 3–4 |
| **Sizing rule** | Hours / story points / days | 8/80 hours |
| **Existing WBS** | None / partial / refactor | None |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/work-breakdown-structure/` |

## Input schema

```
input:
  required:
    project: string
    scope_summary: string
    deliverables: array[string]
  optional:
    decomposition_axis:
      type: string
      enum: [deliverable, phase, responsibility, hybrid]
    target_depth: integer
    sizing_rule: string
    existing_wbs: string
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
Project, scope, deliverables, axis, depth, sizing, existing WBS.

### Phase 2 — Decomposition axis
Deliverable / phase / responsibility / hybrid; consistent within branches.

### Phase 3 — Hierarchy + 100% rule
Level 1 summing to whole scope; siblings ME + CE; numbering.

### Phase 4 — Work-package sizing
8/80 rule with guidance to relax per context.

### Phase 5 — WBS dictionary
Entry per node: description + deliverable + acceptance + size + deps + risks.

### Phase 6 — Milestones
Zero-duration markers tied to WBS nodes.

### Phase 7 — Intra-WBS dependencies
Predecessor → successor with type.

### Phase 8 — Coverage check
Scope deliverable → WBS node matrix; fix gaps and overlaps.

### Phase 9 — Anti-patterns
Activity nodes, mixed axes, excessive depth, WBS-as-schedule, missing dict, unbalanced depth.

### Phase 10 — Diagrams
Tree + milestone timeline.

### Phase 11 — Diagram rendering
Per mixin.

### Phase 12 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Work Breakdown Structure: [Project]

**Date**: [date]
**Project**: [...]
**Decomposition axis**: [...]
**Depth**: [levels]

## Scope Summary
## WBS Tree
## WBS Dictionary
## Milestones
## Intra-WBS Dependencies
## Coverage Matrix
## Assumptions & Limitations
## Diagrams
## Hand-offs
```

### Diagrams
- **Tree view** — Mermaid `graph TD`
- **Milestones** — Mermaid `timeline`

---

## Assessment and planning policy

- 100% rule
- ME + CE siblings
- Deliverable-oriented
- 8/80 respected (or alternative)
- Dictionary per node
- Milestones vs work
- Coverage matrix
- No fabricated deliverables

---

## Self-check

```
[] 100% rule
[] Siblings mutually exclusive
[] Deliverable-oriented nodes
[] 8/80 sizing or alternative
[] Dictionary per node
[] Milestones separate from work
[] Dependencies listed
[] Coverage matrix
[] Depth justified
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No scope supplied | Interview mode or `scope-statement-writing` first |
| Vague scope | Mark low-confidence `[speculative]` |
| Activity-named nodes | Rename |
| Mixed axes in branch | Refactor |
| WP > 80 h | Decompose |
| Coverage gap | Extend WBS |
| Scope creep in WBS | Reject |
| Schedule request | Redirect to `release-planning` |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Scope coverage 100% (matrix)
- [ ] No sibling overlap
- [ ] Work packages within sizing rule
- [ ] Dictionary entries complete
- [ ] Milestones tied to nodes
- [ ] Dependency table present
- [ ] Diagrams render

---

## Examples

### Normal cases

**1. E-commerce platform build**
- Input: Scope with catalog, cart, checkout, payments, fulfilment; 6-month window
- Expected: 7 level-1 branches; level-2 per domain; work packages 8–80h; milestones for alpha/beta/GA

**2. Compliance project**
- Input: GDPR remediation across 5 products
- Expected: Phase-based level 1 (discovery / remediation / audit / close-out); deliverable-based beneath

**3. Cloud migration**
- Input: Lift-and-shift for 40 services
- Expected: Deliverable-based by service group; extra branch for platform foundation; milestones per wave

**4. Research + PoC phase**
- Input: Early-stage spike
- Expected: Shallow WBS (2 levels); spikes marked; placeholders for future decomposition

**5. Launch-readiness subproject**
- Input: Narrow slice
- Expected: Focused 3-level WBS with training, docs, support, comms branches

### Edge cases

**6. Activity-named nodes supplied**
- Input: "Develop login", "Build homepage"
- Expected: Rename to "Login capability", "Homepage" deliverables with verbs at leaves only

**7. Missing deliverables**
- Input: Scope incomplete
- Expected: Mark `[placeholder]` branches + recommend `scope-statement-writing`

**8. Mixed axes inside a branch**
- Input: Discovery + Build + Checkout under same parent
- Expected: Flag + refactor; phases at level 1, deliverables beneath

### Failure cases

**9. No scope**
- Input: "Create a WBS"
- Expected: Interview or recommend scope skill first

**10. Schedule request**
- Input: "Give me dates for each node"
- Expected: Redirect to `release-planning`
