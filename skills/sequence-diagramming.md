# Sequence Diagramming — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | sequence-diagramming |
| **Version** | 1.0.0 |
| **Purpose** | Produces UML sequence diagrams for flows between actors, services, and components using Mermaid `sequenceDiagram` syntax. Orders participants left-to-right along the typical call direction (initiator leftmost). Distinguishes message types: sync call (`->>`), return (`-->>`), async (`-)`), self-call (`->>A`), destroy/fail (`-x`). Uses fragments (`alt`/`else`, `opt`, `loop`, `par`/`and`, `critical`/`option`) for alternatives and iteration instead of duplicating diagrams per variant. Uses activation bars sparingly (only where call-stack clarity helps). Annotates with `Note over`/`Note right of` for timing constraints, SLAs, out-of-band actions, and assumptions. Supports participant lifecycle (`create`/`destroy`) for dynamic participants. Timing annotations on the critical path help reviewers spot budget overruns. Extracts shared sub-flows into their own diagrams rather than inlining twice. One flow per diagram — splits rather than conflates cases. Validates via `diagram-rendering` mixin with optional PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `transformation` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Document request / event / workflow flows
- Review-ready artifact for a design doc
- Debug analysis: show actual observed flow
- Training / onboarding material

## When not to use

- Class / module structure → `class-module-diagramming`
- Component context → `component-design-documentation`
- BPMN / business process → `business-process-modeling`

---

## Required input

| Field | Description |
|---|---|
| **Flow name** | Identifier |
| **Participants** | Actors + components in left-to-right order |
| **Steps** | Ordered messages |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Alternate paths** | Trigger + sequence per variant | Asked |
| **Error paths** | Trigger + sequence per failure | Asked |
| **Timing notes** | SLA / budget on spans | None |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/sequence-diagrams/[flow]/` |

## Input schema

```
input:
  required:
    flow_name: string
    participants: array[string]
    steps: array[object]
  optional:
    alt_paths: array[object]
    error_paths: array[object]
    timing_notes: array[string]
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
Flow, goal, participants, steps, alts, errors, timing.

### Phase 2 — Participant types
Actor / service / external / store / broker; order by call direction.

### Phase 3 — Message types
Sync / return / async / self / destroy.

### Phase 4 — Fragments
`alt`, `opt`, `loop`, `par`, `critical`.

### Phase 5 — Activation bars
Sparingly for call-stack clarity.

### Phase 6 — Notes
Over / right-of for constraints.

### Phase 7 — Primary flow diagram
One per diagram.

### Phase 8 — Alternate + error fragments
Within same diagram via `alt` or as separate diagrams if complex.

### Phase 9 — Loops + parallel
`loop` + `par/and`.

### Phase 10 — Creation + destruction
For dynamic participants.

### Phase 11 — Timing + SLA notes
Budget per span.

### Phase 12 — Reuse + linking
Extract shared sub-flows.

### Phase 13 — Diagram rendering
Per mixin.

### Phase 14 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Sequence Diagrams: [Flow]

**Date**: [date]
**Flow**: [...]
**Participants**: [...]

## Scope
## Primary Flow
## Alternate Paths
## Error Paths
## Timing Notes
## Assumptions & Limitations
```

### Diagrams
- **Primary flow** — Mermaid `sequenceDiagram`
- **Alt / error flows** — Mermaid `sequenceDiagram` with fragments

---

## Assessment and planning policy

- One flow per diagram
- Sync vs async distinct
- Fragments over duplication
- Activation sparingly
- Notes capture constraints
- No fabricated participants

---

## Self-check

```
[] Participants ordered left-to-right by call direction
[] Sync vs async distinguished
[] Fragments used correctly
[] Activation sparingly
[] Timing notes for critical path
[] Alt + error paths covered
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No flow described | Interview mode (§7) |
| Too many branches | Suggest split |
| Participants misordered | Reorder |
| Async as sync | Correct arrowhead |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] Every message has correct arrow type
- [ ] Fragments used over duplicated flows
- [ ] Timing / SLA noted where critical
- [ ] Error paths represented
- [ ] Participant creation + destruction only where dynamic
- [ ] Diagram renders valid Mermaid

---

## Examples

### Normal cases

**1. Place-order happy path**
- Input: User → API → Order Service → DB → Kafka
- Expected: Sequence with sync 201 + async outbox relay

**2. Payment capture with retries**
- Input: Payment service → Stripe with retries
- Expected: `loop` with exponential backoff; `alt` success vs exhausted

**3. Saga orchestration**
- Input: Orchestrator → Order → Payment → Fulfilment with compensations
- Expected: Sequence with `alt` compensations per failed step

**4. Webhook delivery with retries**
- Input: Producer → Worker → Consumer + DLQ
- Expected: Retry loop + DLQ fork via `alt`

**5. Auth flow (OAuth2 code)**
- Input: User + IdP + API
- Expected: Primary OAuth2 sequence; `alt` for error_uri

### Edge cases

**6. Dynamic worker spawn**
- Input: Service spawns workers
- Expected: `create`/`destroy` activations

**7. Parallel fan-out**
- Input: Producer to multiple consumers simultaneously
- Expected: `par/and` fragment

**8. Timing-critical path**
- Input: SLA of 500 ms end-to-end
- Expected: `Note over User,Service` with budget + sub-budgets

### Failure cases

**9. No flow**
- Input: "Draw a sequence diagram"
- Expected: Interview — flow + participants + steps

**10. Not-sequence request**
- Input: "Class diagram for orders"
- Expected: Redirect to `class-module-diagramming`
