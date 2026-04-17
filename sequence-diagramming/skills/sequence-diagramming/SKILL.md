---
name: sequence-diagramming
description: Produce UML sequence diagrams (primary + alternate flows) — participants, sync vs async messages, activation, returns, alt/loop/par fragments, notes, creation/destruction. Mermaid sequenceDiagram.
argument-hint: "[flow name + participants + steps]"
---

# Sequence Diagramming

You turn a described flow into a readable sequence diagram. Clarity over completeness — one diagram per flow, alternates labelled.

## Core rules

- **One flow per diagram** — avoid conflating cases
- **Participants first, then messages** — order participants left-to-right along the typical call direction
- **Sync vs async explicit** — solid arrow for sync call, dashed for return, open arrowhead for async message
- **Label messages precisely** — action + key args / return values
- **Alternates + loops as fragments** — don't repeat full diagrams for variants
- **Don't draw the implementation** — draw the interaction
- **No fabricated participants** — work from supplied flow

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Flow name** | Yes | — |
| **Participants** (actors + components) | Yes | — |
| **Steps** | Yes | — |
| **Alternate paths** | No | Asked |
| **Error paths** | No | Asked |

## Phase 1 — Setup

```
**Flow**: [name]
**Primary goal**: [what success looks like]
**Participants**: [actors + components in left-to-right order]
**Messages**: [one line per step — from → to : verb(args)]
**Alt paths**: [list with trigger conditions]
**Error paths**: [list with trigger conditions]
**Notes**: [timing constraints, SLAs, non-functional context]
```

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/sequence-diagrams/[flow-name]/`).

## Phase 2 — Participant types

| Kind | Mermaid |
|---|---|
| Actor (human) | `actor User` |
| System / service | `participant OrderService` |
| External system | `participant Stripe` |
| Data store | `participant DB as "Postgres"` |
| Queue / broker | `participant K as "Kafka"` |

Order: most-left is initiator; downstream / dependent is rightward.

## Phase 3 — Message types

| Arrow | Meaning |
|---|---|
| `A->>B` | Synchronous call (solid, filled arrowhead) |
| `A-->>B` | Return / reply (dashed, filled) |
| `A-)B` | Async message (open arrowhead) |
| `A->>A` | Self-call |
| `A--xB` | Lost / failed (depending on convention) |
| `A-xB` | Destroy participant / failure |
| `create` / `destroy` | Lifecycle of dynamic participants |

## Phase 4 — Fragments

```
alt [condition]            # alternatives
  ...
else [other condition]
  ...
end

opt [condition]            # optional
  ...
end

loop [condition or count]  # iteration
  ...
end

par                        # parallel
  ...
and
  ...
end

critical                   # must-complete atomic section
  ...
option [break]
  ...
end
```

Prefer one alt block per decision, not many nested.

## Phase 5 — Activation bars

Use activation when modelling call stack clarity:

```
A->>+B: call
B-->>-A: return
```

Use sparingly — activation clutter hurts readability for long flows.

## Phase 6 — Notes

- `Note over A: text` — anchored over one participant
- `Note over A,B: text` — spanning
- `Note right of A: text` — positional

Use for: timing constraints, SLAs, out-of-band actions, assumptions.

## Phase 7 — Primary flow diagram

```mermaid
sequenceDiagram
    actor User
    participant API as "API Gateway"
    participant OS as "Order Service"
    participant DB as "Postgres"
    participant K as "Kafka"

    User->>API: POST /orders
    API->>OS: placeOrder(cmd)
    OS->>DB: BEGIN tx
    OS->>DB: insert order + outbox
    OS->>DB: COMMIT
    OS-->>API: 201 + OrderId
    API-->>User: 201

    Note over OS,K: async relay
    OS-)K: publish OrderPlaced v1
```

## Phase 8 — Alternate + error fragments

```mermaid
sequenceDiagram
    participant API
    participant OS
    participant DB
    API->>OS: placeOrder(cmd)
    alt validation fails
        OS-->>API: 422 ValidationError
    else inventory unavailable
        OS-->>API: 409 InventoryUnavailable
    else transient DB error
        OS->>DB: insert
        DB--xOS: timeout
        OS-->>API: 503 + Retry-After
    else success
        OS->>DB: COMMIT
        OS-->>API: 201
    end
```

## Phase 9 — Loops + parallel

```mermaid
sequenceDiagram
    participant W as "Worker"
    participant Q as "Queue"
    participant H as "HTTP"
    loop until queue empty
        W->>Q: claim batch
        par parallel fan-out
            W->>H: POST consumer A
        and
            W->>H: POST consumer B
        end
    end
```

## Phase 10 — Creation + destruction

```mermaid
sequenceDiagram
    participant A
    A->>+B: spawn
    Note right of B: lives during operation
    A->>B: do work
    A->>-B: terminate
```

## Phase 11 — Timing + SLA notes

Annotate critical path with budget:

```
Note over User,OS: p99 end-to-end ≤ 500 ms
Note over OS: DB call budget 50 ms; outbox insert ≤ 20 ms
```

Helps reviewers spot budget overruns during design.

## Phase 12 — Reuse + linking

For flows with shared sub-flows:
- Extract sub-flow into its own diagram
- Reference by name in the calling diagram (as a `Note` or comment)
- Don't inline the full sub-flow twice

## Phase 13 — Diagram rendering

Per `diagram-rendering` mixin.

## Phase 14 — Report assembly and approval

```markdown
# Sequence Diagrams: [Flow]

**Date**: [date]
**Flow**: [name]
**Participants**: [list]

## Scope
[What flow, what's in/out]

## Primary Flow
[Mermaid + short narrative]

## Alternate Paths
[Mermaid `alt` block or separate diagrams]

## Error Paths
[Mermaid `alt` / `--x` style]

## Timing Notes
[Budget / SLA per span]

## Assumptions & Limitations
```

Present for user approval. Save only after confirmation.

## Assessment + planning rules

- One flow per diagram
- Sync vs async explicit
- Fragments used over duplicated diagrams
- Activation sparingly
- Notes capture constraints not visible in arrows
- No fabricated participants

## Failure behavior

| Situation | Behavior |
|---|---|
| No flow described | Interview mode (§7) |
| Too many branches in one diagram | Suggest split |
| Participants right-to-left | Reorder — call flow is left-to-right |
| Async drawn as sync | Correct arrowhead |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | "Diagrams only; impl is engineering." |

## Self-check

```
[] Participants ordered by call direction
[] Sync vs async distinguished
[] Fragments used correctly (alt/loop/par)
[] Activation used sparingly
[] Notes for timing + assumptions
[] Alternate + error paths covered
[] One flow per diagram (split if needed)
[] Diagrams valid
[] No fabricated participants
[] Report follows output contract
```
