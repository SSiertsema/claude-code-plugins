# State Transition Mapping — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | state-transition-mapping |
| **Version** | 1.0.0 |
| **Purpose** | Maps UI state machines for a component, screen, or flow. Enumerates every state (idle / focused / active / loading / success / error / empty / partial / stale / offline / disabled / hidden) with visual expectation, entry/exit conditions, accessibility expectation per state (focus behavior, screen-reader announcement, keyboard handling, aria attributes), and telemetry event on entry. Types every transition with trigger, guard, action (side effect), and rollback path. Detects invalid-state combinations (mutually exclusive states visible together, logical impossibilities like empty + has-data). Handles guards, race conditions, and ordering (priority / first-match). Classifies states as transient (always has outbound transition) or terminal (ends the machine) and flags deadlocks. Produces Given/When/Then acceptance per state + per invalid-state detection. Mermaid state diagram and optional invalid-state matrix with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Designing or refactoring a component / screen / flow's state logic
- Pre-implementation spec for complex interactive components
- Auditing existing UI for missing states (the common "no one thought about the empty state" problem)
- Test plan derivation (every state and transition becomes a test case)
- Handoff from design to engineering with unambiguous state contract

## When not to use

- Task-level flow (multi-screen / multi-step) → `user-flow-diagramming`
- Single interaction unit → `micro-interaction-design`
- Error design across product → `error-handling-design`
- Full screen layout → `wireframing`
- Backend state machine (domain / workflow) → architecture / domain modelling

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Component / screen / flow |
| **Scope** | Where the machine starts and ends |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Platforms** | web / iOS / Android | web |
| **Known states** | Pre-identified | Elicit |
| **External triggers** | System / user / time | Elicit |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/state-transition-mapping/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    scope:
      type: string
  optional:
    platforms: list[string]
    known_states: list[string]
    external_triggers: list[string]
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
Collect subject + scope.

### Phase 2 — State enumeration
Exhaustive; common states prompted.

### Phase 3 — Transitions
Typed with trigger + guard + action + rollback.

### Phase 4 — Invalid-state detection
Impossible combinations enumerated.

### Phase 5 — Guards + concurrency
Race conditions, priority.

### Phase 6 — Terminal vs transient
Deadlocks flagged.

### Phase 7 — A11y per state
Focus + announcement + keyboard.

### Phase 8 — Acceptance criteria
Given/When/Then per state.

### Phase 9 — Diagrams
State diagram + optional invalid-state matrix.

### Phase 10 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 11 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# State Transition Map: [Subject]

**Date**: [date]
**Subject**: [name]
**Scope**: [boundaries]

## Scope
[Subject, scope, platforms]

## State Inventory
[Per state: description, entry, exit, a11y, telemetry]

## Transitions
[Table with trigger / guard / action / rollback]

## Invalid States
[Impossible combinations + detection + response]

## Guards & Concurrency
[Race-condition handling, priority]

## Terminal vs Transient
[Classification]

## Accessibility per State
[Matrix]

## Acceptance Criteria
[Given/When/Then per state]

## Diagrams
[State diagram + optional invalid-state matrix]

## Assumptions & Limitations
[Boundary / platform notes]
```

### Diagrams

- **State diagram** — Mermaid `stateDiagram-v2`
- **Invalid-state matrix** — Mermaid `flowchart` or markdown (optional)

---

## Generation and planning policy

- Exhaustive states
- Typed transitions
- Invalid states surfaced
- No deadlock transient states
- A11y per state
- No fabricated states

---

## Self-check

```
[] Subject + scope declared
[] Exhaustive states (loading / success / error / empty required when applicable)
[] Per-state entry / exit / a11y / telemetry
[] Transitions typed
[] Invalid states listed with detection
[] Race conditions handled
[] No transient deadlocks
[] A11y per state
[] Given/When/Then per state
[] Diagrams valid
[] No fabricated states
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject | Interview mode (§7) |
| Missing common states | Prompt; require justification for skip |
| Deadlock transient | Require outbound transition |
| Invalid states allowed by code | Recommend type-system / reducer refactor |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope (backend) | "UI states only." |

---

## Quality checks

- [ ] Exhaustive states
- [ ] Typed transitions
- [ ] Invalid-state matrix
- [ ] No deadlocks
- [ ] A11y per state
- [ ] Acceptance criteria
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Form submission component**
- Input: Submit-form component
- Expected: States idle → focused → loading → success/error; error can transition to loading (retry); a11y: error state focus-moved to error summary + role=alert.

**2. Data list component**
- Input: List displaying user data
- Expected: States loading → empty / partial / full / error / stale; invalid: empty + has-data impossible. Refresh action transitions full → loading.

**3. Modal dialog**
- Input: Confirmation dialog
- Expected: States hidden → visible (open) → closing → hidden; focus trapped when visible; Escape handled; a11y role=dialog + aria-labelledby.

**4. Search input**
- Input: Search box with autocomplete
- Expected: States idle → typing → debounced → results-loading → results (with / without) → error / offline; race conditions: new query cancels prior fetch.

**5. Payment flow**
- Input: Payment screen
- Expected: States idle → validating → processing → success / declined / fraud-check → terminal; rollback if processing fails mid-way.

### Edge cases

**6. Offline-capable app**
- Input: Component that works offline
- Expected: Offline state with queued actions; a11y announcement on connectivity change; reconnection triggers sync transition.

**7. Stale data**
- Input: Cache-heavy component
- Expected: Stale state with visible indicator; user-triggered refresh or TTL-based re-fetch transition.

**8. Optimistic UI**
- Input: Like-button with optimistic update
- Expected: States idle → optimistic (assumed success) → confirmed / reverted; transitions handle failure with rollback to prior state.

### Failure cases

**9. No subject**
- Input: "Map states"
- Expected: Interview — "Which component / screen / flow, and what's the scope?"

**10. Out of scope**
- Input: "Map UI state + backend workflow state"
- Expected: "UI only. Backend workflow state is domain modelling."
