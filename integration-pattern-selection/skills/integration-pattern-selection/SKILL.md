---
name: integration-pattern-selection
description: Select integration pattern between services — sync (request-response, RPC) / async (queue, pub/sub, stream) / saga (orchestration vs choreography) / outbox / CDC / polling / webhook. Trade-offs explicit.
argument-hint: "[source + target services + consistency needs]"
---

# Integration Pattern Selection

You pick the right integration pattern between services. Patterns trade consistency, coupling, latency, and complexity — no free lunch.

## Core rules

- **Sync by default for simple calls; async when decoupling matters**
- **Dual-write is a trap** — use outbox or CDC to avoid losing messages on crash
- **Saga over distributed transactions** — 2PC across services is rarely worth it
- **Idempotency is mandatory** for async + retry-capable flows
- **Retry budgets + DLQs** — retries without a ceiling cause cascading failure
- **No fabricated service relationships** — work from supplied facts

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Source + target services** | Yes | — |
| **What's being integrated** (data / event / command) | Yes | — |
| **Consistency need** | Yes | — |
| **Latency tolerance** | No | Asked |
| **Ownership boundaries** (same team / different team) | No | Asked |
| **Existing broker / API** | No | Asked |

## Phase 1 — Setup

```
**Source**: [service / system]
**Target(s)**: [services / systems]
**What**: [data sync / event notification / command / workflow]
**Consistency**: [strong / read-your-write / eventual / none]
**Latency**: [ms tolerance]
**Ownership**: [same team / cross-team / external partner]
**Volume**: [events/s or calls/s]
**Existing infra**: [broker / API gateway / none]
**Failure tolerance**: [can't lose / can retry / lossy ok]
```

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/integration-pattern-selection/`).

## Phase 2 — Pattern catalog

### Synchronous request-response (HTTP / gRPC)

**When to use**: simple read / command with immediate response / low coordination / small number of dependencies
**When not**: target slow or unreliable, cross-team decoupling desired, long-running workflow
**Trade-offs**: simplicity + strong consistency vs tight coupling + cascade failure risk + latency addition
**Failure mode**: target down → caller down (unless circuit breaker + fallback)
**Idempotency**: required on retries for non-GET

### Asynchronous message queue (point-to-point)

**When to use**: work handoff / load leveling / decoupled processing / can tolerate latency
**When not**: need immediate response / ordering across many consumers required
**Trade-offs**: decoupling + load absorption vs eventual consistency + operational broker + harder debugging
**Failure mode**: consumer slow → queue grows; use backpressure + DLQ
**Idempotency**: mandatory

### Pub/Sub (fan-out)

**When to use**: event notification / multiple consumers / loose coupling
**When not**: strict exactly-once semantics / state-transfer where large payload
**Trade-offs**: broadcast + loose coupling vs downstream coupling to event shape + schema evolution discipline
**Failure mode**: slow consumer → lag; monitor consumer lag
**Idempotency**: mandatory

### Event streaming (log-based, e.g. Kafka)

**When to use**: replay / audit / multiple consumers / ordering per key / real-time analytics
**When not**: small scale (broker ops overkill) / simple work queue
**Trade-offs**: replay + ordering + scale vs ops burden + partition-key discipline
**Failure mode**: consumer crash → resume from offset; partition skew if key distribution uneven
**Idempotency**: mandatory

### Saga (orchestration)

**When to use**: distributed workflow with coordination + compensations / need central visibility / complex branching
**When not**: trivial 2-step workflow / teams reject central coordinator
**Trade-offs**: central visibility + easier monitoring vs orchestrator becomes coupling point / SPOF
**Failure mode**: orchestrator down → workflow stalled; compensations run on step failure
**Tools**: Camunda, Temporal, AWS Step Functions

### Saga (choreography)

**When to use**: simple workflow / each service reacts to events / team autonomy prioritized
**When not**: complex branching / need single source of workflow truth
**Trade-offs**: decentralized + team autonomy vs emergent complexity + hard to trace
**Failure mode**: skipped event → workflow diverges; needs strong observability

### Transactional outbox

**When to use**: you need to write DB + publish event atomically
**When not**: producer doesn't own a relational DB that can do the outbox table
**Trade-offs**: avoids dual-write problem + exactly-once producer-side vs extra moving part (relay) + DB bloat if not purged
**Failure mode**: relay down → events delayed; consumer deduplicates by event id

### Change Data Capture (CDC)

**When to use**: integrate with legacy systems owning the DB / stream DB changes as events / replicate to analytics store
**When not**: application events are semantically richer than DB changes / DB tightly coupled to internal model
**Trade-offs**: no app changes required + comprehensive vs leaks internal schema + downstream couples to table structure
**Failure mode**: schema change breaks downstream — governance + contract needed
**Tools**: Debezium, AWS DMS, Maxwell

### Polling

**When to use**: target can't push / partner lacks webhook / simple + low volume
**When not**: high-volume, real-time needed — wasteful + latent
**Trade-offs**: simple + works anywhere vs wasteful + latent + load on target
**Failure mode**: poll storm if many clients; add jitter + backoff

### Webhook callback

**When to use**: external event delivery / async notification to partner / async job completion
**When not**: caller can't host HTTP / strict ordering needed
**Trade-offs**: push to consumers + real-time vs delivery guarantees harder to enforce without retry + signature
**Hand-off**: `webhook-design` for full treatment

### RPC over queue (async RPC)

**When to use**: request-response semantics over async transport / rare but applicable for bursty loads
**When not**: simple low-latency RPC (use gRPC direct)
**Trade-offs**: decoupling + buffering vs adds correlation-id plumbing + latency

## Phase 3 — Decision factors

| Factor | What it captures |
|---|---|
| **Consistency need** | Strong / read-your-write / eventual |
| **Latency tolerance** | ms budget |
| **Coupling** | How tightly coupled do services become? |
| **Ownership** | Same team / cross-team / external |
| **Failure isolation** | Does target going down block source? |
| **Observability** | Can we trace the flow? |
| **Ordering** | Does order matter? |
| **Throughput** | Peak + sustained |
| **Complexity budget** | Team capacity for ops |

## Phase 4 — Anti-pattern checks

| Anti-pattern | Flag if |
|---|---|
| **Dual-write** | Code writes DB + publishes event without outbox/CDC |
| **Distributed transaction across services** | 2PC across service boundaries proposed |
| **Synchronous chain > 3 hops** | Latency + failure amplification |
| **Retry without idempotency** | Retries will duplicate effects |
| **No DLQ** | Poison messages will block pipeline |
| **No retry budget** | Retries amplify during outage |

Raise these explicitly when present.

## Phase 5 — Recommendation

One paragraph:
- **Chosen pattern(s)**
- **Why**: top 2–3 factors
- **Trade-offs accepted**
- **Failure handling**: retry + idempotency + DLQ + circuit breaker / fallback
- **Observability plan**: correlation ids + tracing
- **Hand-offs**: `message-broker-selection`, `event-schema-design`, `webhook-design`

## Phase 6 — Diagrams

### Pattern flow (sync)

```mermaid
sequenceDiagram
    A->>B: call
    B->>C: call
    C-->>B: result
    B-->>A: result
```

### Pattern flow (async + outbox)

```mermaid
sequenceDiagram
    participant A
    participant ADB as A.db
    participant Relay
    participant Broker
    participant B
    A->>ADB: BEGIN tx
    A->>ADB: update aggregate
    A->>ADB: insert outbox row
    A->>ADB: COMMIT
    Relay->>ADB: read outbox
    Relay->>Broker: publish
    Broker-->>B: deliver
    B->>B: process (idempotent)
    B-->>Broker: ack
```

### Saga (orchestration)

```mermaid
sequenceDiagram
    Orchestrator->>Order: reserve
    Order-->>Orchestrator: ok
    Orchestrator->>Payment: charge
    Payment--xOrchestrator: fail
    Orchestrator->>Order: compensate (release)
```

## Phase 7 — Diagram rendering

Per `diagram-rendering` mixin.

## Phase 8 — Report assembly and approval

```markdown
# Integration Pattern Selection: [Source → Target(s)]

**Date**: [date]
**Source**: [...]
**Target(s)**: [...]
**Chosen pattern**: [...]

## Scope
[Services, consistency, latency, ownership, volume, infra]

## Pattern Catalog
[Patterns evaluated]

## Decision Factors
[Per-factor analysis]

## Anti-Pattern Check
[Dual-write / 2PC / chains / retries]

## Recommendation
[Chosen + trade-offs + failure handling + observability]

## Diagrams
[Flow diagrams]

## Hand-offs
[Broker, event schema, webhook, rate-limiting]

## Assumptions & Limitations
```

Present for user approval. Save only after confirmation.

## Assessment + planning rules

- Consistency need drives sync vs async
- Dual-write flagged; outbox / CDC recommended
- Idempotency + retry + DLQ mandatory for async
- Saga over 2PC
- No fabricated relationships

## Failure behavior

| Situation | Behavior |
|---|---|
| No service context | Interview mode (§7) |
| Dual-write proposed | Recommend outbox or CDC |
| Distributed tx across services | Recommend saga |
| Sync chain > 3 hops | Challenge — async boundaries or aggregation |
| No DLQ / no idempotency | Flag as required |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | "Pattern only; impl is engineering." |

## Self-check

```
[] Services + purpose declared
[] Consistency + latency + ownership considered
[] Pattern selected with trade-offs
[] Anti-patterns checked
[] Idempotency + retry + DLQ required for async
[] Observability plan stated
[] Diagrams valid
[] Hand-offs listed
[] No fabricated services
[] Report follows output contract
```
