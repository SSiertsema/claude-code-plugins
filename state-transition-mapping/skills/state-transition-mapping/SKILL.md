---
name: state-transition-mapping
description: Map UI state machines for a component, screen, or flow. Enumerates states (idle / loading / success / error / empty / partial / stale / offline), transitions with triggers and guards, terminal vs transient states, and invalid-state detection. Produces visual state chart and acceptance criteria per state.
argument-hint: "[component / screen / flow to map]"
---

# State Transition Mapping

You map UI state machines. A state machine makes UI behavior explicit: every possible state, every valid transition, every guard condition. The diagram doubles as a test plan — untested states and transitions are risk.

## Core rules

- **Exhaustive states**: if it can happen, it's a state — don't skip empty / error / partial
- **Transitions typed**: every transition has a trigger + guard
- **Invalid states detected**: impossible-state combinations must be surfaced and eliminated
- **Terminal vs transient**: terminal states end the machine; transient states always have an exit
- **No fabricated states**: only states the component actually has
- **Accessibility per state**: focus, announcement, keyboard behavior differ per state

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Subject** (component / screen / flow) | Yes | — |
| **Scope** (interaction boundary) | Yes | — |
| **Known transitions** | No | Elicit |
| **External triggers** | No | Elicit |

## Phase 1 — Setup

```
**Subject**: [name]
**Scope**: [where the machine starts and ends]
**Platforms**: [web / mobile / desktop]
```

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/state-transition-mapping/`).

## Phase 2 — State enumeration

Common states (include if applicable):

| State | Description |
|---|---|
| **Idle / Initial** | No user action yet; waiting |
| **Focused** | Interactive element has focus |
| **Active / pressed** | User engaging |
| **Loading** | Async work in progress |
| **Success** | Action completed |
| **Error** | Action failed |
| **Empty** | No data to show |
| **Partial** | Some data; gaps visible |
| **Stale** | Cached; may be out of date |
| **Offline** | No connectivity |
| **Disabled** | Cannot be interacted with |
| **Hidden** | Present but not rendered |

Per state:
- **Name**
- **Visual / UI expectation**
- **Entry conditions**
- **Exit conditions / valid transitions**
- **A11y expectation** (focus, announcement, keyboard, aria attributes)
- **Telemetry event fired on entry**

## Phase 3 — Transitions

Per transition:

| Field | Description |
|---|---|
| **From state** | Source |
| **To state** | Target |
| **Trigger** | User action / system event / timer / external event |
| **Guard** | Condition required (e.g., `user.authenticated == true`) |
| **Action** | Side effect during transition (API call, analytics, state mutation) |
| **Rollback path** | What happens if the transition fails mid-way |

## Phase 4 — Invalid-state detection

Enumerate state × external-condition combinations that should never occur:

- "Loading + disabled" — probably a bug (disabling disables any pending response)
- "Success + error visible" — mutual exclusion violation
- "Empty + has-data" — logical impossibility

Per invalid state: detection mechanism + response.

## Phase 5 — Guards and concurrency

- **Guards**: conditions checked before a transition fires; false = transition blocked
- **Race conditions**: what if two triggers fire simultaneously? Debounce / throttle / cancel
- **Ordering**: if multiple transitions possible, which wins? (priority / first-match / explicit)

## Phase 6 — Terminal vs transient

- **Transient** states always have ≥ 1 outbound transition
- **Terminal** states end the machine (success, abandoned, timed-out)
- Any transient state without an outbound transition is a deadlock — flag

## Phase 7 — Accessibility per state

| State | Focus | Announcement | Keyboard |
|---|---|---|---|
| Idle | Visible on interactive | Label only | Tab-accessible |
| Loading | Retain on triggering element | aria-busy + live region | Tab disabled if necessary |
| Error | Move to error summary | role="alert" + live region | Esc to dismiss |
| Success | Retain | aria-live polite | — |
| Empty | Focus on primary CTA | Static description | — |
| Disabled | Skip | aria-disabled | Skip in tab order |

## Phase 8 — Acceptance criteria per state

Given/When/Then per state:
- Given [prior state] + [condition]
- When [trigger]
- Then [new state + visible output + a11y behavior]

And per invalid-state detection.

## Phase 9 — Diagrams

### 1. State diagram

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Loading: submit
    Loading --> Success: api_ok
    Loading --> Error: api_fail
    Loading --> Idle: cancel
    Error --> Loading: retry
    Error --> Idle: dismiss
    Success --> [*]
```

### 2. Guard / trigger table

Markdown table with from / to / trigger / guard / action.

### 3. Invalid-state matrix (optional)

Mermaid or markdown matrix highlighting impossible combinations.

## Phase 10 — Diagram rendering

Per `diagram-rendering` mixin. File names:
- `state-diagram.mmd` / `.png`
- `invalid-state-matrix.mmd` / `.png` (optional)

## Phase 11 — Report assembly and approval

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
[Table: from, to, trigger, guard, action, rollback]

## Invalid States
[Impossible combinations + detection + response]

## Guards & Concurrency
[Race-condition handling, priority rules]

## Terminal vs Transient
[Classification]

## Accessibility per State
[Matrix]

## Acceptance Criteria
[Given/When/Then per state]

## Diagrams
[State diagram + optional invalid-state matrix]

## Assumptions & Limitations
[Boundary assumptions, platform-specific notes]
```

Present for user approval. Save only after confirmation.

## Generation + planning rules

- Exhaustive state enumeration
- Typed transitions with guards
- Invalid states detected
- No orphan (deadlock) transient states
- A11y per state
- No fabricated states

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject | Interview mode (§7) |
| Missing error / empty / loading states | Prompt; don't accept skip without justification |
| Deadlock transient state | Flag; require outbound transition |
| Invalid states possible in code | Recommend type-system or reducer refactor |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope (backend state) | "UI states only. Backend state is system architecture." |

## Self-check

```
[] Subject + scope declared
[] Exhaustive state inventory (idle / loading / success / error / empty / partial as applicable)
[] Per state: entry / exit / a11y / telemetry
[] Transitions typed with trigger + guard + action + rollback
[] Invalid states enumerated with detection
[] Guards + race-condition handling
[] Terminal vs transient classified; no deadlocks
[] A11y per state
[] Given/When/Then acceptance per state
[] Diagrams valid
[] No fabricated states
[] Report follows output contract
```
