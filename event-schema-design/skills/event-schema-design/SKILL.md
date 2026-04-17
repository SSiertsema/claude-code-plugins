---
name: event-schema-design
description: Design event schemas: envelope (CloudEvents 1.0) + payload (JSON Schema / Avro / Protobuf), naming, keys, versioning, compatibility modes, schema registry. Fact vs delta, domain vs integration.
argument-hint: "[domain events + consumers]"
---

# Event Schema Design

You design event schemas that stay readable + evolvable over years. Events are contracts; once published they are hard to change.

## Core rules

- **Events are facts, not commands** — name past-tense (`OrderPlaced`, not `PlaceOrder`)
- **Envelope + payload separation** — envelope is generic, payload domain-specific
- **Version everything** — schemas evolve; treat each version as a contract
- **Compatibility deliberate** — pick a mode (backward / forward / full / none) per event
- **Registry, not tribal knowledge** — schemas live in a registry, not a README
- **PII declared** — sensitive fields marked; retention policy stated
- **Keys + ordering explicit** — partition key + ordering guarantee documented
- **Correlation + causation ids mandatory** — for tracing + replay
- **No fabricated events** — work from supplied domain facts

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Domain + aggregates** | Yes | — |
| **Events to design** | Yes | — |
| **Consumers** | Yes | — |
| **Serialization format** | No | JSON (asked) |
| **Broker** | No | Asked; hand off to `message-broker-selection` |
| **Registry** | No | Asked |
| **PII present** | No | Asked |

## Phase 1 — Setup

```
**Domain**: [e.g. Orders]
**Aggregates**: [Order, OrderLine, Payment]
**Events**: [OrderPlaced, OrderCancelled, PaymentCaptured, ...]
**Consumers**: [fulfilment, analytics, audit, external partners]
**Serialization**: [JSON Schema / Avro / Protobuf]
**Broker**: [Kafka / RabbitMQ / ...]  (or "to be decided")
**Registry**: [Confluent / Apicurio / none]
**PII**: [yes/no; fields]
**Retention**: [e.g. 30 days / 7 years]
```

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/event-schema-design/`).

## Phase 2 — Event classification

| Axis | Options | Guidance |
|---|---|---|
| **Fact vs delta** | Fact (full state snapshot) vs delta (what changed) | Facts simpler for late-arrivers; deltas smaller |
| **Domain vs integration** | Domain (rich, internal) vs integration (slim, external contract) | Don't leak internal events externally — translate |
| **Notification vs state-transfer** | Notification (id only, fetch state) vs state-carried | State-carried reduces coupling but grows payload |
| **Command vs event** | Commands = intent (future), events = fact (past) | Don't publish commands as events |

State classification per event explicitly.

## Phase 3 — Envelope (CloudEvents 1.0)

```json
{
  "specversion": "1.0",
  "id": "01HXYZ...",
  "source": "/orders/v1",
  "type": "com.example.orders.placed.v1",
  "subject": "order/9f3a...",
  "time": "2026-04-17T12:34:56Z",
  "datacontenttype": "application/json",
  "dataschema": "https://schemas.example.com/orders/placed/v1.json",
  "traceparent": "00-...-...-01",
  "data": { ... }
}
```

Extensions used:
- `traceparent` / `tracestate` — W3C Trace Context
- `correlationid` — end-to-end workflow
- `causationid` — the event that caused this one
- `partitionkey` — broker partition key if applicable

## Phase 4 — Naming

```
com.<org>.<bounded-context>.<aggregate>.<action-past-tense>.v<major>
com.example.orders.order.placed.v1
com.example.payments.payment.captured.v1
```

Rules:
- Past-tense verb (placed, cancelled, captured, refunded)
- Aggregate noun before verb
- `v1`, `v2`, ... for major versions (breaking changes)
- Reverse-DNS for global uniqueness

## Phase 5 — Payload schema

### JSON Schema example (OrderPlaced v1)

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://schemas.example.com/orders/placed/v1.json",
  "title": "OrderPlaced v1",
  "type": "object",
  "required": ["order_id", "customer_id", "placed_at", "total", "lines"],
  "properties": {
    "order_id":    { "type": "string", "format": "uuid" },
    "customer_id": { "type": "string", "format": "uuid" },
    "placed_at":   { "type": "string", "format": "date-time" },
    "total":       { "$ref": "#/$defs/Money" },
    "lines": {
      "type": "array",
      "minItems": 1,
      "items": { "$ref": "#/$defs/OrderLine" }
    },
    "idempotency_key": { "type": "string" }
  },
  "additionalProperties": false,
  "$defs": {
    "Money": {
      "type": "object",
      "required": ["amount_minor", "currency"],
      "properties": {
        "amount_minor": { "type": "integer", "minimum": 0 },
        "currency":     { "type": "string", "pattern": "^[A-Z]{3}$" }
      }
    },
    "OrderLine": {
      "type": "object",
      "required": ["sku", "quantity", "unit_price"],
      "properties": {
        "sku":        { "type": "string" },
        "quantity":   { "type": "integer", "minimum": 1 },
        "unit_price": { "$ref": "#/$defs/Money" }
      }
    }
  }
}
```

### Avro example

```json
{
  "type": "record",
  "name": "OrderPlaced",
  "namespace": "com.example.orders.v1",
  "fields": [
    { "name": "order_id",    "type": "string" },
    { "name": "customer_id", "type": "string" },
    { "name": "placed_at",   "type": { "type": "long", "logicalType": "timestamp-millis" } },
    { "name": "total",       "type": "Money" },
    { "name": "lines",       "type": { "type": "array", "items": "OrderLine" } }
  ]
}
```

### Protobuf example

```proto
syntax = "proto3";
package com.example.orders.v1;

message OrderPlaced {
  string order_id = 1;
  string customer_id = 2;
  google.protobuf.Timestamp placed_at = 3;
  Money total = 4;
  repeated OrderLine lines = 5;
  reserved 6, 7;
}
```

### Format selection

| Format | When |
|---|---|
| **JSON Schema** | Human-readable, broad tooling, larger payload |
| **Avro** | Kafka + schema registry; efficient; strong compatibility rules |
| **Protobuf** | Cross-language gRPC ecosystem; compact; field numbering discipline |

Pick one primary; don't mix per event type unless gateway-translated.

## Phase 6 — Keys + ordering

| Decision | Guidance |
|---|---|
| **Partition key** | Aggregate id (e.g. `order_id`) for per-aggregate ordering |
| **Ordering guarantee** | Per-partition (Kafka / Kinesis) or none (SQS standard) |
| **Deduplication** | `idempotency_key` in payload; consumer deduplicates by it |
| **Out-of-order handling** | Consumer logic: timestamp-based, version-based, or last-writer-wins |

## Phase 7 — Versioning + compatibility

### Additive evolution (recommended)

- Add new optional field → backward compatible
- Deprecate field → keep writing until all consumers stopped reading → remove in next major
- Never change field semantics — use new name + deprecate

### Compatibility modes (schema registry)

| Mode | Writer vs reader | When |
|---|---|---|
| **Backward** | New reader ↔ old writer | Consumers upgrade first (common default) |
| **Forward** | Old reader ↔ new writer | Producers upgrade first |
| **Full** | Both directions | Safest, most restrictive |
| **None** | Anything goes | Breaking allowed; rolling replacement |

### Breaking-change strategies

1. **Parallel topics**: `orders.placed.v1` + `orders.placed.v2`, consumers migrate topic-by-topic
2. **Upcasting**: consumer reads both versions, upcasts v1 → v2 in-code
3. **Translator service**: publishes v2, republishes as v1 for legacy consumers
4. **Stop-the-world**: coordinate cutover (avoid at scale)

Recommend (1) or (2) by default.

## Phase 8 — PII + retention

| Concern | Decision |
|---|---|
| **PII fields** | Marked with `x-pii: true` (JSON Schema) / doc (Avro/Proto) |
| **Encryption** | Field-level encryption for PII, or tokenization upstream |
| **Retention** | Per topic; GDPR crypto-erasure for right-to-be-forgotten on event streams |
| **Legal basis** | Documented per PII field |

Hand off deep retention / erasure to `data-governance-policy` if applicable.

## Phase 9 — Schema registry

| Registry | When |
|---|---|
| **Confluent Schema Registry** | Kafka + Avro default; compatibility enforcement |
| **Apicurio Registry** | Open-source, multi-format (Avro, JSON Schema, Proto, AsyncAPI) |
| **AWS Glue Schema Registry** | AWS-native |
| **None (files-in-repo)** | Small systems; risk of drift |

Registry workflow:
1. Producer registers schema + version on write
2. Broker/registry rejects incompatible writes
3. Consumer reads schema id from message, fetches schema, deserializes

## Phase 10 — Diagrams

### Event lineage

```mermaid
graph LR
    A[OrderPlaced v1] --> F[Fulfilment]
    A --> AN[Analytics]
    A --> AU[Audit]
    P[PaymentCaptured v1] --> A2[OrderPaid v1]
    A2 --> F
```

### Schema evolution timeline

```mermaid
timeline
    title Schema evolution of OrderPlaced
    v1 : initial fields
    v1.1 : added optional delivery_window (backward-compatible)
    v2 : split total -> subtotal + tax + shipping (parallel topic)
```

## Phase 11 — Diagram rendering

Per `diagram-rendering` mixin.

## Phase 12 — Report assembly and approval

```markdown
# Event Schema Design: [Domain]

**Date**: [date]
**Domain**: [...]
**Serialization**: [JSON Schema / Avro / Protobuf]
**Registry**: [...]

## Scope
[Domain, aggregates, events, consumers]

## Event Classification
[Per event: fact/delta, domain/integration, notification/state-carried]

## Envelope
[CloudEvents 1.0 structure + extensions]

## Naming
[Convention + examples]

## Per-Event Schema
[Payload definitions, required/optional, validation]

## Keys + Ordering
[Partition key, ordering guarantee, idempotency key]

## Versioning + Compatibility
[Mode + evolution strategy]

## PII + Retention
[Fields marked + retention per topic]

## Schema Registry
[Chosen + workflow]

## Diagrams
[Event lineage + evolution]

## Hand-offs
[Broker selection, governance, contract spec]

## Assumptions & Limitations
```

Present for user approval. Save only after confirmation.

## Assessment + planning rules

- Events past-tense
- Envelope + payload separated
- Versioning strategy declared
- Compatibility mode chosen per event
- Keys + ordering explicit
- PII marked
- Registry decision stated
- No fabricated events

## Failure behavior

| Situation | Behavior |
|---|---|
| No domain / events | Interview mode (§7) |
| Command-style naming | Challenge — "Events are facts, not commands" |
| Breaking change without strategy | Recommend parallel-topic or upcasting |
| Mixed formats | Challenge — one primary per domain |
| PII not declared | Ask — cannot publish retention policy without it |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | "Schema only; producers/consumers are engineering." |

## Self-check

```
[] Events past-tense + reverse-DNS
[] Envelope CloudEvents 1.0
[] Classification per event
[] Keys + ordering explicit
[] Versioning + compatibility mode
[] PII + retention documented
[] Registry decision
[] Diagrams valid
[] No fabricated events
[] Report follows output contract
```
