# Event Schema Design — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | event-schema-design |
| **Version** | 1.0.0 |
| **Purpose** | Designs event schemas for event-driven / pub-sub / streaming systems. Separates envelope (CloudEvents 1.0 with `id`, `source`, `type`, `subject`, `time`, `dataschema`, `traceparent`, `correlationid`, `causationid`, `partitionkey`) from payload (JSON Schema / Avro / Protobuf). Classifies events per axis: fact vs delta, domain vs integration, notification vs state-transfer, command vs event. Enforces naming (past-tense reverse-DNS: `com.example.orders.order.placed.v1`). Defines partition key + ordering guarantee + idempotency key + out-of-order handling. Versioning strategy (additive evolution, parallel topics for breaking changes, upcasting, translator services). Schema-registry compatibility mode (backward / forward / full / none) per event. PII marking + retention + crypto-erasure for GDPR. Registry selection (Confluent / Apicurio / Glue / none). Mermaid event-lineage + schema-evolution-timeline with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `assessment` |
| **Output mode** | `machine_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- New event-driven system — event inventory + schemas
- Existing events lacking formal schemas
- Breaking-change planning for in-flight events
- Pre-registry migration

## When not to use

- Broker selection → `message-broker-selection`
- Integration pattern choice → `integration-pattern-selection`
- Event sourcing + CQRS domain design → `event-sourcing-cqrs-design`
- Webhook callback design → `webhook-design`
- AsyncAPI contract → `api-contract-specification`

---

## Required input

| Field | Description |
|---|---|
| **Domain + aggregates** | Bounded context + entities |
| **Events** | List of events to design |
| **Consumers** | Who reads |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Serialization format** | JSON Schema / Avro / Protobuf | Asked (JSON default) |
| **Broker** | Kafka / RabbitMQ / ... | Asked |
| **Registry** | Confluent / Apicurio / ... | Asked |
| **PII present** | Yes/no + fields | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/event-schema-design/` |

## Input schema

```
input:
  required:
    domain: string
    aggregates: array[string]
    events: array[string]
    consumers: array[string]
  optional:
    serialization:
      type: string
      enum: [json-schema, avro, protobuf]
    broker: string
    registry: string
    pii: object
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
Domain, aggregates, events, consumers.

### Phase 2 — Event classification
Fact/delta, domain/integration, notification/state, command/event.

### Phase 3 — Envelope
CloudEvents 1.0 + extensions.

### Phase 4 — Naming
Past-tense reverse-DNS with major version.

### Phase 5 — Payload
JSON Schema / Avro / Protobuf per event.

### Phase 6 — Keys + ordering
Partition key, ordering, idempotency, out-of-order.

### Phase 7 — Versioning + compatibility
Additive; parallel topics / upcasting for breaking; compatibility mode.

### Phase 8 — PII + retention
Fields marked; retention per topic; crypto-erasure for GDPR.

### Phase 9 — Schema registry
Registry selection + workflow.

### Phase 10 — Diagrams
Event lineage + evolution timeline.

### Phase 11 — Diagram rendering
Per mixin.

### Phase 12 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Event Schema Design: [Domain]

**Date**: [date]
**Domain**: [...]
**Serialization**: [...]
**Registry**: [...]

## Scope
## Event Classification
## Envelope
## Naming
## Per-Event Schema
## Keys + Ordering
## Versioning + Compatibility
## PII + Retention
## Schema Registry
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Event lineage** — Mermaid `graph LR`
- **Schema evolution** — Mermaid `timeline`

---

## Assessment and planning policy

- Events past-tense
- Envelope + payload separated
- Versioning declared
- Compatibility mode per event
- Keys + ordering explicit
- PII marked
- Registry chosen
- No fabricated events

---

## Self-check

```
[] Events past-tense + reverse-DNS
[] CloudEvents envelope
[] Classification per event
[] Keys + ordering explicit
[] Versioning + compatibility mode
[] PII + retention documented
[] Registry decision
[] Diagrams valid
[] No fabricated events
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No domain / events | Interview mode (§7) |
| Command-style names | Challenge — events are facts |
| Breaking change without strategy | Recommend parallel topic / upcasting |
| Mixed formats | Challenge — one primary per domain |
| PII undeclared | Ask first |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] Event inventory complete
- [ ] Envelope structure defined
- [ ] Per-event payload schema
- [ ] Partition key + ordering documented
- [ ] Versioning strategy concrete
- [ ] Compatibility mode matches consumer upgrade pattern
- [ ] PII fields marked with retention
- [ ] Registry selection justified

---

## Examples

### Normal cases

**1. E-commerce order domain**
- Input: Events `OrderPlaced`, `OrderCancelled`, `OrderFulfilled`; Kafka + Confluent registry
- Expected: Avro schemas, `order_id` partition key, backward compatibility, `com.example.orders.*.v1` names

**2. Payments stream**
- Input: PaymentCaptured, PaymentRefunded; JSON + Apicurio
- Expected: JSON Schema, idempotency key in payload, integration-event variants for external partners

**3. Breaking change request**
- Input: OrderPlaced v1 to v2 — split total into subtotal + tax + shipping
- Expected: Parallel topic strategy, consumer migration plan, upcasting guidance

**4. PII-heavy user events**
- Input: UserRegistered with email + phone
- Expected: Fields marked PII; retention 7 years with crypto-erasure; legal basis documented

**5. Notification vs state-carried**
- Input: Large catalog updates
- Expected: Notification events (id + timestamp); fetch state via REST to avoid multi-MB events

### Edge cases

**6. Domain events leaking to external consumers**
- Input: Sending rich internal events to partners
- Expected: Translator pattern; integration-event variants with slim payload + stable contract

**7. Out-of-order events**
- Input: Multi-region producers, global consumer
- Expected: Version field + last-writer-wins; or per-aggregate ordering with aggregate-id partition key

**8. Multiple formats in one domain**
- Input: Some events Avro, others JSON
- Expected: Challenge — pick one primary; allow format-translation at boundaries only

### Failure cases

**9. Command-style event name**
- Input: "CreateOrder" event
- Expected: Challenge — rename to `OrderPlaced`; events are facts

**10. No domain / events**
- Input: "Design events for a system"
- Expected: Interview — "What domain? What events? What consumers?"
