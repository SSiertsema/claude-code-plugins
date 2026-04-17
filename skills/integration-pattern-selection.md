# Integration Pattern Selection — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | integration-pattern-selection |
| **Version** | 1.0.0 |
| **Purpose** | Selects integration pattern between services: synchronous request-response (HTTP/gRPC), asynchronous point-to-point queue, pub/sub fan-out, event streaming (log-based, e.g. Kafka), saga orchestration (Temporal / Step Functions / Camunda), saga choreography (events + reactions), transactional outbox, change data capture (Debezium / DMS / Maxwell), polling, webhook callback, RPC over queue. Scores on decision factors: consistency need (strong / read-your-write / eventual), latency tolerance, coupling, ownership boundary (same team / cross-team / external partner), failure isolation, observability, ordering, throughput, complexity budget. Flags anti-patterns: dual-write (recommend outbox/CDC instead), distributed transactions across services (recommend saga instead), sync chains > 3 hops, retry without idempotency, no DLQ, no retry budget. Produces recommendation with failure handling (retry + idempotency + DLQ + circuit breaker) and observability plan (correlation ids + tracing). Hands off broker choice → `message-broker-selection`, event payload → `event-schema-design`, webhook design → `webhook-design`. Mermaid sync + async + saga sequence diagrams with PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Designing integration between two or more services
- Evaluating existing integration for consistency / failure issues
- Pre-broker decision (pattern drives broker selection)
- Saga vs 2PC decision

## When not to use

- Broker choice only → `message-broker-selection`
- Event schema only → `event-schema-design`
- Webhook design only → `webhook-design`
- API surface design → `api-design`

---

## Required input

| Field | Description |
|---|---|
| **Source + target services** | Identifiers |
| **What's integrated** | Data / event / command / workflow |
| **Consistency need** | Strong / read-your-write / eventual / none |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Latency tolerance** | ms budget | Asked |
| **Ownership** | Same team / cross-team / external | Asked |
| **Volume** | events/s / calls/s | Asked |
| **Existing infra** | Broker / API | Asked |
| **Failure tolerance** | Can't lose / retry / lossy ok | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/integration-pattern-selection/` |

## Input schema

```
input:
  required:
    source: string
    targets: array[string]
    integration_kind:
      type: string
      enum: [data-sync, event-notification, command, workflow]
    consistency_need:
      type: string
      enum: [strong, read-your-write, eventual, none]
  optional:
    latency_ms: number
    ownership: string
    volume: object
    existing_infra: object
    failure_tolerance: string
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
Services, what's integrated, consistency, latency, ownership, volume, infra.

### Phase 2 — Pattern catalog
Sync / async queue / pub-sub / streaming / saga-orchestration / saga-choreography / outbox / CDC / polling / webhook / async-RPC.

### Phase 3 — Decision factors
Consistency, latency, coupling, ownership, failure isolation, observability, ordering, throughput, complexity.

### Phase 4 — Anti-pattern checks
Dual-write, 2PC across services, sync chain > 3 hops, retry without idempotency, no DLQ, no budget.

### Phase 5 — Recommendation
Pattern + trade-offs + failure handling + observability + hand-offs.

### Phase 6 — Diagrams
Sync sequence + async+outbox sequence + saga orchestration.

### Phase 7 — Diagram rendering
Per mixin.

### Phase 8 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Integration Pattern Selection: [Source → Target(s)]

**Date**: [date]
**Source**: [...]
**Target(s)**: [...]
**Chosen pattern**: [...]

## Scope
## Pattern Catalog
## Decision Factors
## Anti-Pattern Check
## Recommendation
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Sync flow** — Mermaid `sequenceDiagram`
- **Async + outbox flow** — Mermaid `sequenceDiagram`
- **Saga orchestration** — Mermaid `sequenceDiagram`

---

## Assessment and planning policy

- Consistency drives sync vs async
- Dual-write flagged; outbox / CDC recommended
- Idempotency + retry + DLQ mandatory for async
- Saga over 2PC
- No fabricated relationships

---

## Self-check

```
[] Services declared
[] Consistency + latency + ownership considered
[] Pattern selected with trade-offs
[] Anti-patterns checked
[] Idempotency + retry + DLQ required for async
[] Observability plan stated
[] Diagrams valid
[] Hand-offs listed
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No service context | Interview mode (§7) |
| Dual-write proposed | Recommend outbox / CDC |
| 2PC across services | Recommend saga |
| Sync chain > 3 hops | Challenge |
| No DLQ / idempotency | Flag as required |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] Consistency need explicit
- [ ] Pattern matches consistency + latency
- [ ] Dual-write detected + remediated
- [ ] Idempotency strategy stated
- [ ] DLQ + retry budget in place
- [ ] Observability across the flow
- [ ] Escape hatch described

---

## Examples

### Normal cases

**1. Service A updates DB + notifies B**
- Input: Event notification, cross-team, can't lose
- Expected: Transactional outbox + pub/sub; idempotent consumer in B; DLQ + observability plan

**2. Workflow: Order → Payment → Fulfilment → Ship**
- Input: 4 steps, cross-team, need central visibility
- Expected: Saga orchestration (Temporal / Step Functions); compensations per step

**3. Legacy DB → analytics lake**
- Input: Legacy source with no app events; need near-real-time analytics
- Expected: CDC (Debezium); leak-schema risk flagged; downstream contract recommended

**4. Partner notification on order creation**
- Input: External partner needs to know when orders created
- Expected: Webhook callback (hand-off to `webhook-design`); signature + retry + DLQ; fallback polling endpoint

**5. Low-throughput internal status check**
- Input: Admin UI needs service health
- Expected: Sync HTTP; circuit breaker; low risk

### Edge cases

**6. Team proposes dual-write**
- Input: Proposed code writes DB + publishes event non-atomically
- Expected: Flag dual-write; recommend outbox; show failure mode

**7. Distributed transaction across 3 services**
- Input: 2PC proposal
- Expected: Recommend saga; explain why 2PC is rarely worth it

**8. Sync chain of 5 services**
- Input: A→B→C→D→E synchronous
- Expected: Challenge — introduce aggregation or async boundary; latency + failure amplification diagram

### Failure cases

**9. No context**
- Input: "Pick an integration pattern"
- Expected: Interview — source, target, consistency, latency

**10. Implementation request**
- Input: "Pattern + code"
- Expected: "Pattern only; implementation is engineering."
