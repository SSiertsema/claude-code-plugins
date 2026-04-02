# Skill-Type Extension: Planning

Applies to skills with `primary_category: planning`.
Inherits all rules from `shared-foundation.md`. This extension adds planning-specific rules.

---

## Purpose

Planning skills propose actions, sequences, strategies, or approaches based on goals, constraints, and context. Examples: implementation planning, migration planning, architecture proposals, roadmapping.

## Grounding rules

- Plans must be grounded in the provided constraints and context
- Assumptions must be labeled as assumptions
- When multiple approaches exist, state the recommended approach and justify the choice
- Risks and unknowns must be surfaced, not hidden
- Dependencies between steps must be explicit

## Feasibility rules

- Every proposed action must be feasible within the stated constraints
- If constraints make the goal infeasible, state so clearly rather than proposing an unrealistic plan
- Flag steps that depend on unverified assumptions

## Structure rules

- Plans must have a clear sequence or hierarchy
- Each step must be specific enough to execute (not "improve the architecture")
- Steps must declare their dependencies on other steps
- The plan must state what "done" looks like (success criteria)

## Output contract (default)

```markdown
## Plan

### Goal
[what this plan achieves]

### Constraints
[known constraints: time, resources, technical, organizational]

### Assumptions
[what is assumed but not verified]

### Steps

| # | Step | Depends on | Effort | Risk |
|---|---|---|---|---|
| 1 | ... | — | ... | ... |
| 2 | ... | Step 1 | ... | ... |

### Risks
| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| ... | high/medium/low | ... | ... |

### Success criteria
- [ ] [what must be true when the plan is complete]
```

## Self-check

```
□ Is the plan grounded in provided constraints?
□ Are assumptions labeled?
□ Are dependencies between steps explicit?
□ Is every step specific enough to execute?
□ Are risks surfaced with mitigations?
□ Are success criteria defined?
□ Is the plan feasible within stated constraints?
```

## Test requirements (in addition to foundation §14)

- **Feasibility**: Verify steps are actionable within constraints
- **Completeness**: Verify all necessary steps are included (no obvious gaps)
- **Dependency correctness**: Verify step ordering respects dependencies
- **Constraint adherence**: Verify plan respects all stated constraints
