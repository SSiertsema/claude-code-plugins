# State Machine Diagramming (Domain Entities) — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | state-machine-diagramming |
| **Version** | 1.0.0 |
| **Purpose** | Models the lifecycle of a business / domain entity as a finite state machine. Distinct from `state-transition-mapping` (UI component states: idle / loading / error): this skill handles **domain** states — the business lifecycle of entities like Order (pending → paid → shipped → delivered), User Account (invited → active → suspended → closed), Subscription (trial → active → cancelled → expired), Document (draft → review → published → archived), Claim (filed → investigating → approved / denied → paid / disputed), Shipment, Loan Application, etc. Per state: name in business vocabulary, type (initial / normal / terminal), invariants true while in state, allowed and disallowed operations, optional entry and exit effects, optional time limit. Per transition: from/to, trigger (event / time / condition / composite), guard condition, side effect, actor, rollback path on failure, idempotency flag. Supports three formats: flat (single-level FSM), hierarchical (nested sub-states), parallel (orthogonal regions for independent dimensions like Fulfillment vs Payment on an Order). Produces transition matrix exposing gaps, explicit invalid-transition list to prevent illegal state changes, side-effect catalog with idempotency notes. Mermaid `stateDiagram-v2` with optional PNG export. |
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

- Defining the lifecycle of a new domain entity (order, subscription, account)
- Refactoring legacy entity logic where illegal transitions are happening
- Regulatory workflows (claim, application, approval) requiring auditable state
- Integration design where state transitions trigger side effects to external systems
- Testing foundation — every state + transition becomes a test case

## When not to use

- UI component state → `state-transition-mapping`
- Business process with multiple actors → `business-process-modeling`
- User flow through UI → `user-flow-diagramming`
- Data model / entity fields → `data-dictionary-definition`
- Use-case behavioral spec → `use-case-writing`

---

## Required input

| Field | Description |
|---|---|
| **Entity** | Named business entity |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Lifecycle scope** | When entity created → terminal | Elicit |
| **Known states / transitions** | Existing spec | Elicit |
| **Format** | flat / hierarchical / parallel | Inferred |
| **Trigger types** | event / time / condition / mixed | mixed |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/state-machine-diagramming/` |

## Input schema

```
input:
  required:
    entity:
      type: string | document_reference
  optional:
    lifecycle_scope: string
    states: list[object]
    transitions: list[object]
    format:
      type: string
      enum: [flat, hierarchical, parallel]
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
Collect entity + lifecycle scope + format.

### Phase 2 — State enumeration
Per state: invariants, allowed / disallowed ops, effects, time limits.

### Phase 3 — Transitions
Per transition: trigger + guard + effect + rollback + idempotency.

### Phase 4 — Hierarchical / parallel structure
Nested or orthogonal when domain requires.

### Phase 5 — Transition matrix
From × Trigger table exposing gaps.

### Phase 6 — Invalid transitions
Explicit disallowed list.

### Phase 7 — Side effects & integration
Per event / transition with idempotency.

### Phase 8 — Diagrams
state-diagram-v2 (flat / hierarchical / parallel as applicable).

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# State Machine: [Entity]

**Date**: [date]
**Entity**: [name]
**Format**: [flat / hierarchical / parallel]

## Scope
[Entity, lifecycle, format, trigger types]

## States
[Per state]

## Transitions
[Per transition]

## Transition Matrix
[From × Trigger table]

## Invalid Transitions
[Explicit disallowed]

## Side Effects & Integration Hooks
[With idempotency]

## Hierarchical / Parallel Structure
[If applicable]

## Diagrams
[state-diagram-v2]

## Assumptions & Limitations
[Elicitation gaps, domain assumptions]
```

### Diagrams

- **State diagram** — Mermaid `stateDiagram-v2` (flat / hierarchical / parallel)

---

## Generation and planning policy

- Business-domain vocabulary
- States with invariants
- Transitions typed
- Invalid transitions explicit
- Side effects idempotent
- No fabricated states

---

## Self-check

```
[] Entity declared
[] Format chosen
[] States with invariants + ops
[] Transitions complete
[] Transition matrix
[] Invalid transitions
[] Side effects with idempotency
[] No deadlocks
[] Domain vocabulary (not UI)
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No entity | Interview mode (§7) |
| UI states mixed in | Separate; UI → state-transition-mapping |
| Deadlock | Require outbound |
| Non-idempotent side effects | Flag reliability risk |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out-of-scope |

---

## Quality checks

- [ ] One entity
- [ ] Per-state complete
- [ ] Per-transition complete
- [ ] Matrix
- [ ] Invalid list
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Order entity (parallel regions)**
- Input: Order with fulfillment + payment dimensions
- Expected: Two parallel regions; fulfillment (Pending → Picked → Packed → Shipped → Delivered); payment (Unpaid → Authorized → Captured); transitions include gateway calls + idempotency keys.

**2. User account (hierarchical)**
- Input: User account lifecycle with "Active" containing sub-states
- Expected: Top-level: Invited → Active → Suspended → Deactivated; Active contains sub-states (Onboarding → Normal → Power-user); invalid transitions Deactivated → Active explicit.

**3. Claim (flat)**
- Input: Insurance claim
- Expected: Filed → InvestigationStarted → InvestigationComplete → Approved / Denied → Paid / Disputed → Closed. Time-based transitions for SLA escalation.

**4. Subscription with trial**
- Input: SaaS subscription
- Expected: Trial → Active → Past-due → Cancelled → Expired; grace-period transitions; reactivation path from Cancelled → Active within N days.

**5. Document workflow**
- Input: Content workflow
- Expected: Draft → InReview → (Approved / Rejected) → Published → Archived; re-review cycle; version history implicit.

### Edge cases

**6. Entity with >20 states**
- Input: Highly-granular process
- Expected: Flag likely over-modeling; suggest hierarchical grouping or consolidating near-identical states.

**7. Non-deterministic transitions**
- Input: Two valid transitions from same state on same event
- Expected: Require guard condition to disambiguate OR mark as non-deterministic and note resolution strategy (e.g., priority order, race condition tolerance).

**8. External-system-driven states**
- Input: State transitions driven by payment gateway webhooks
- Expected: External triggers documented; webhook idempotency + retry semantics; compensating transitions for webhook failures.

### Failure cases

**9. No entity**
- Input: "Model state machine"
- Expected: Interview — "Which domain entity?"

**10. Out of scope**
- Input: "Model + implement the state machine in code"
- Expected: "Modeling only. Implementation is engineering work."
