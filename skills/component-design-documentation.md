# Component Design Documentation — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | component-design-documentation |
| **Version** | 1.0.0 |
| **Purpose** | Produces a review-ready design document for a single software component (service / module / library). Covers: purpose + context + owner + non-functional targets, bounded responsibilities with explicit out-of-scope list, public interface before internals (HTTP surface, module function signatures, events published + consumed with hand-offs to contract skills), internal structure (directory layout, key types, internal dependencies as ports + adapters), collaborators (direction + protocol + purpose), data + state (persistent stores, caches, state machine transitions, hand-off to `conceptual-data-modeling` / `data-dictionary-definition`), errors (trigger + external code + internal handling, hand-off to `system-error-handling-strategy`), concurrency + ordering (thread-safety, idempotency, locking, backpressure), observability hooks (logs + metrics + traces + health endpoints, hand-off to `logging-tracing-design` / `observability-strategy`), non-functional characteristics (latency/throughput/availability/recovery/scalability targets with strategy), security (AuthN/AuthZ, data classification, secrets), configuration (hand-off to `configuration-management-design`), tests (unit/integration/contract/load/chaos), trade-offs + rejected alternatives, open questions. Mermaid component-context + primary-sequence diagrams with PNG export. |
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

- New component pre-build (service / module / library)
- Significant refactor of existing component
- Onboarding reference for an undocumented component
- Review artifact for architecture council / ADR input

## When not to use

- ADR only → `adr-writing`
- Interface detail → `interface-specification`
- Sequence diagrams as standalone artifact → `sequence-diagramming`
- Full contract → `api-contract-specification`
- Data schema → `conceptual-data-modeling`

---

## Required input

| Field | Description |
|---|---|
| **Component name + type** | service / module / library |
| **Purpose** | One sentence |
| **Context** | Upstream / downstream system location |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Public interface shape** | APIs + events | Asked |
| **Primary collaborators** | Known dependencies | Asked |
| **Non-functional targets** | Latency / throughput / availability | Asked |
| **Owner** | Team | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/component-design/[name]/` |

## Input schema

```
input:
  required:
    component_name: string
    component_type:
      type: string
      enum: [service, module, library]
    purpose: string
    context: string
  optional:
    public_interface: object
    collaborators: array
    non_functional_targets: object
    owner: string
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
Component, type, purpose, context, owner, NFR targets, constraints.

### Phase 2 — Responsibilities
In-scope + out-of-scope. Flag cohesion if long.

### Phase 3 — Public interface
HTTP surface / module functions / events.

### Phase 4 — Internal structure
Layout + key types + internal ports/adapters.

### Phase 5 — Collaborators
Direction + protocol + purpose.

### Phase 6 — Data + state
Stores + caches + state machine.

### Phase 7 — Errors
Trigger + external code + internal handling.

### Phase 8 — Concurrency + ordering
Thread-safety, idempotency, locking, backpressure.

### Phase 9 — Observability hooks
Logs + metrics + traces + health.

### Phase 10 — Non-functional characteristics
Per-property target + strategy.

### Phase 11 — Security
AuthN / AuthZ / classification / secrets.

### Phase 12 — Configuration + flags
Hand off; list keys + precedence.

### Phase 13 — Tests
Unit / integration / contract / load / chaos.

### Phase 14 — Trade-offs + rejected alternatives
One-liner rationale per rejection.

### Phase 15 — Open questions
What's unresolved.

### Phase 16 — Diagrams
Component context + primary sequence.

### Phase 17 — Diagram rendering
Per mixin.

### Phase 18 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Component Design: [Name]

**Date**: [date]
**Type**: [...]
**Owner**: [...]

## Purpose
## Context
## Responsibilities
## Public Interface
## Internal Structure
## Collaborators
## Data + State
## Errors
## Concurrency + Ordering
## Observability
## Non-Functional Characteristics
## Security
## Configuration
## Tests
## Trade-offs + Rejected Alternatives
## Open Questions
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Component context** — Mermaid `graph LR`
- **Primary sequence** — Mermaid `sequenceDiagram`

---

## Assessment and planning policy

- Purpose + context + responsibilities
- Interface before internals
- Trade-offs + rejected alternatives
- Open questions
- Hand-offs (not duplication)
- No fabricated deps

---

## Self-check

```
[] Purpose + context clear
[] Responsibilities bounded
[] Public interface before internals
[] Collaborators with protocol
[] Errors mapped
[] NFR targets + strategy
[] Security considerations
[] Trade-offs + rejected alternatives
[] Open questions listed
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No purpose / context | Interview mode (§7) |
| Responsibilities long | Flag cohesion; suggest split |
| Internals first | Reorder |
| Data schema deep | Hand off to data-modeling skill |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] One component per doc
- [ ] Responsibilities bounded (≤ 7)
- [ ] Public interface fully specified
- [ ] Non-functional targets with strategy
- [ ] Errors mapped to external codes
- [ ] Trade-offs + alternatives
- [ ] Open questions surfaced

---

## Examples

### Normal cases

**1. New order service**
- Input: Service type, place-orders purpose, e-commerce context
- Expected: Full doc with HTTP surface, outbox pattern, collaborators, state machine, observability hooks

**2. Library (SDK client)**
- Input: Library type, payments SDK
- Expected: Function signatures + config + errors + thread-safety; no runtime ports

**3. Internal module inside monolith**
- Input: Module type, inventory bounded context
- Expected: Package boundaries + public API + internal services; no network surface

**4. Refactor existing service**
- Input: Existing with tech debt
- Expected: Current + target state + migration notes; open questions about cutover

**5. Platform component (rate limiter service)**
- Input: Cross-cutting infra component
- Expected: NFR-heavy doc; backpressure + HA + tenants

### Edge cases

**6. Component that's too big**
- Input: 15+ responsibilities listed
- Expected: Flag cohesion; recommend split into two components; one doc per

**7. Missing NFR targets**
- Input: "Whatever is fine"
- Expected: Ask — "p99 latency? req/s? availability?"; defaults suggested with risks

**8. Component duplicates another**
- Input: Overlapping surface with existing service
- Expected: Call out duplication; recommend consolidation before doc

### Failure cases

**9. No purpose**
- Input: "Document this component"
- Expected: Interview — purpose + context

**10. Implementation request**
- Input: "Design + code it"
- Expected: "Design doc only."
