---
name: event-sourcing-cqrs-design
description: Design event sourcing and/or CQRS. Event store, event schema, aggregate boundaries, projections, consistency, snapshotting, versioning / upcasting, replay, GDPR implications.
argument-hint: "[domain + event-sourcing scope + CQRS scope]"
---

# Event Sourcing + CQRS Design

You design event sourcing (state as append-only event log) and/or CQRS (separate command + query models). Often used together but independent patterns.

## When each fits

| Pattern | Use when |
|---|---|
| **CQRS alone** | Different read / write models optimal; no need for audit / replay |
| **Event sourcing alone** | Audit requirements; temporal queries; complex domain logic |
| **Both together** | Domain complex enough for ES + reads diverge from writes |

Both have real cost — don't adopt without justification.

## Event sourcing core

### Events as first-class

- **Events are facts** — happened in the past, immutable
- **Verb-past-tense naming**: "OrderPlaced", "PaymentCaptured", "UserSignedUp"
- **One aggregate per stream** — events for one entity grouped + ordered
- **Append-only** — never update / delete historical events

### Aggregates (from DDD)

Each aggregate = consistency boundary. Events belong to an aggregate stream. Commands validated against current state (replayed from events).

### Event store options

| Option | Best for |
|---|---|
| **EventStoreDB** | Purpose-built for event sourcing |
| **Kafka** | Log-based; long retention possible |
| **Postgres with `events` table** | Simpler; works for low-medium scale |
| **Axon Server** | JVM ecosystem |
| **DynamoDB** | Cloud-native; requires design discipline |

### Event schema

- **Type**: `OrderPlaced.v1`
- **Aggregate ID**: `order-uuid`
- **Sequence number**: per-stream
- **Timestamp**
- **Data**: payload
- **Metadata**: user, correlation ID, causation ID

## CQRS core

### Command side

- Accepts commands (intent to change state)
- Validates against current model
- Produces events (if ES) OR writes to write-model (if non-ES)
- No queries here

### Query side

- Reads from projections / read-models optimized for query patterns
- No commands
- Eventually consistent with write side

### Projections

- Consume events (if ES) or change-log (if non-ES CQRS)
- Build denormalized read-optimized views
- Multiple projections per domain (one per query pattern)
- Rebuildable from scratch (for ES — replay events)

## Consistency

- **Within an aggregate**: strongly consistent (single stream)
- **Across aggregates**: eventually consistent
- **Command → read-model**: eventual (typically < 1s)

Users see eventual consistency; design for it (optimistic UI, read-your-writes session tricks).

## Snapshotting

Rebuilding state by replaying every event is slow for long-lived aggregates. Periodically snapshot state; replay events since last snapshot.

- Snapshot policy: every N events or time-based
- Stored separately; recomputable

## Versioning / upcasting

Event schemas evolve. Strategies:
- **Versioned event types** (`OrderPlaced.v1`, `OrderPlaced.v2`)
- **Upcasting**: transform v1 → v2 on read
- **Never change old events** — only add new versions

## Replay

- Core ES advantage: rebuild any view by replaying events
- Fix a projection bug → drop projection + replay
- Support temporal queries ("what was the state on 2024-06-12?")

## GDPR compliance in immutable stores

Tension: right-to-delete vs immutable events.

Strategies:
- **Crypto-erasure**: encrypt personal data with per-subject key; delete key = data unreadable
- **Redaction events**: emit compensating events removing PII (don't actually delete; mark as unreadable)
- **Separation**: personal data in separate store (deletable); events reference by ID
- **Retention**: delete events after retention period

Choose before first event; retrofit is painful.

## Common anti-patterns

- Using ES for CRUD — overhead without benefit
- Events as "change records" — should be domain facts
- Too-large events (dump entire state) — violates event-as-minimal-fact
- No snapshotting → slow rehydration
- Projections that diverge from events (manual writes) → state drift

## Report

```markdown
# Event Sourcing + CQRS Design: [Domain]

## Scope
[ES scope + CQRS scope + rationale]

## Event Store
[Chosen + rationale]

## Aggregates + Event Schemas
[Per aggregate: events + schemas]

## Command Model
[Validators + event producers]

## Read Models / Projections
[Per query pattern: projection + schema]

## Consistency
[Where strong / where eventual]

## Snapshotting
[Policy]

## Versioning Strategy
[Schema evolution + upcasting]

## Replay Capability
[Use cases + tooling]

## GDPR Compliance
[Strategy for right-to-delete]

## Monitoring
[Event lag / projection health / replay status]

## Diagram
```

## Failure behavior
- ES proposed for simple CRUD → challenge
- No snapshotting → recommend before scale
- GDPR ignored → require strategy
- mmdc failure → see mixin
