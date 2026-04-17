# User Flow Diagramming — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | user-flow-diagramming |
| **Version** | 1.0.0 |
| **Purpose** | Produces UI-task-level user flow diagrams that sit between strategic journey mapping (`user-journey-management`) and screen layout (`wireframing`). A user flow is the step-by-step sequence of actions, decisions, and system responses for a single task. Decomposes each flow into steps with actor (user / system / third party), action, input data, system response, preconditions, postconditions, possible errors, and next-step transitions. Distinguishes flow types: happy path (primary success), edge cases (valid-but-uncommon variants), error paths (validation / network / timeout / third-party / auth / rate-limit with recovery), and abandonment (state retention + re-entry). Every decision point has an explicit condition and all branches — no implicit else. Names instrumentation events per step for downstream analytics setup. Supports multi-flow composition and swimlane views per actor. Mermaid flowchart and optional swimlane diagrams with PNG export. |
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

- Designing a new task flow before wireframing screens
- Auditing an existing task flow for edge / error coverage
- Documenting a flow for implementation and QA
- Setting up analytics instrumentation around a task
- Communicating a flow to cross-functional team

## When not to use

- Strategic journey with emotions / pains / opportunities → `user-journey-management`
- Screen layout / UI composition → `wireframing`
- Site hierarchy → `site-mapping`
- Component state logic → `state-transition-mapping`
- Multi-actor service flows (backstage-heavy) → future service-blueprinting

---

## Required input

| Field | Description |
|---|---|
| **Task / flow name** | Single task |
| **Actors** | user + system + third parties |
| **Entry points** | Where users arrive |
| **Outcomes** | Success / failure / alternate |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Flow types in scope** | happy / edges / errors / abandonment | happy + 1–3 edges/errors |
| **Existing steps** | Known step list | Elicit |
| **Instrumentation focus** | Events to emphasize | Entry + decisions + outcomes |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/user-flow-diagramming/` |

## Input schema

```
input:
  required:
    flow_name:
      type: string
    actors:
      type: list[string]
    entry_points:
      type: list[string]
    outcomes:
      type: list[string]
  optional:
    flow_types: list[string]
    existing_steps: list[object]
    instrumentation_focus: list[string]
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
Collect flow name + actors + entry + outcomes.

### Phase 2 — Flow decomposition
Per step: actor / action / input / system response / pre- + post-conditions / errors / next.

### Phase 3 — Decision points
Condition explicit; all branches named.

### Phase 4 — Flow types
Happy + edges + errors + abandonment.

### Phase 5 — Instrumentation
Events per step with purpose + funnel stage.

### Phase 6 — Composition (if multiple flows)
Sequential / conditional / parallel.

### Phase 7 — Diagrams
Flowchart per flow type; swimlane if multi-actor.

### Phase 8 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 9 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# User Flow: [Task]

**Date**: [date]
**Actors**: [list]
**Entry points**: [list]
**Outcomes**: [list]
**Flow types**: [list]

## Scope
[Task, actors, entry, outcomes, flow types]

## Happy Path
[Diagram + step table]

## Edge Cases
[Per variant]

## Error Paths
[Per scenario + recovery]

## Abandonment
[State retention + re-entry]

## Instrumentation Points
[Event table]

## Flow Composition
[If multi-flow]

## Swimlane View
[If multi-actor]

## Assumptions & Limitations
[`[Assumed]` steps; UI deferred to wireframing]
```

### Diagrams

- **User flow per type** — Mermaid `flowchart`
- **Swimlane** — Mermaid `flowchart` with subgraphs (optional)

---

## Generation and planning policy

- Explicit branches
- Error recovery named
- Abandonment handled
- No fabricated UI / API details
- Instrumentation events named

---

## Self-check

```
[] Scoped to one task
[] Actors declared
[] Entry + outcomes explicit
[] Happy path complete
[] Decisions have conditions + all branches
[] Edge cases named
[] Error paths with recovery
[] Abandonment handled
[] Instrumentation events named
[] Diagrams valid
[] Swimlane if multi-actor
[] No fabricated UI / APIs
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No task | Interview mode (§7) |
| Task too broad | Recommend journey mapping first |
| Implicit else | Require explicit branches |
| UI specifics creep | Defer to `wireframing` |
| Missing error paths | Prompt for ≥1 per external-dependency step |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] One task
- [ ] Actors
- [ ] Entry + outcome
- [ ] Happy path
- [ ] Explicit branches
- [ ] Edges + errors + abandonment
- [ ] Instrumentation events
- [ ] Diagrams valid
- [ ] No UI / API fabrication

---

## Examples

### Normal cases

**1. Signup flow**
- Input: Task = "Sign up for account", actors = user + system + email service
- Expected: Happy path (form → validate → create → verify email → welcome), 2 edges (SSO, invite-based), 4 errors (invalid input, duplicate email, rate-limit, email-send failure), abandonment (tab close mid-form). 6 instrumentation events.

**2. Checkout**
- Input: Task = "Complete purchase"
- Expected: Happy path with cart → address → payment → confirm → receipt. Edges: guest, saved card, split shipment. Errors: card declined, stock unavailable, fraud check. Abandonment: cart retention, recovery email point.

**3. Password reset**
- Input: Task = "Reset forgotten password"
- Expected: Flow with email → token → new password; edges (SSO account → redirect), errors (token expired, no account with email). Security instrumentation events called out.

**4. Complex multi-actor flow**
- Input: Procurement approval flow (requester + approver + vendor)
- Expected: Swimlane view, handoffs labeled, SLA timers, escalation errors.

**5. Feature flag gated flow**
- Input: Flow with variant A/B
- Expected: Branching at entry on flag evaluation; variants documented separately; shared convergent end.

### Edge cases

**6. Single-step flow**
- Input: Task is a one-click action
- Expected: Flow still has entry / action / response / outcome; minimal but complete; emphasize error paths (timeout, offline).

**7. Nested task**
- Input: Task includes a sub-task that's itself complex
- Expected: Parent flow + child flow separated; composition view shows hand-off.

**8. Long-running flow**
- Input: Flow spans multiple sessions (e.g., loan application)
- Expected: State retention between sessions documented; re-entry points per session; abandonment rules for long pauses.

### Failure cases

**9. No task**
- Input: "Make a user flow"
- Expected: Interview — "Which task, what actors, entry points, and outcomes?"

**10. Out of scope**
- Input: "Flow + wireframe every screen"
- Expected: "Flow only. Screen layouts in `wireframing`."
