# Message Broker Selection — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | message-broker-selection |
| **Version** | 1.0.0 |
| **Purpose** | Selects a message broker for a workload by scoring candidates (Apache Kafka, RabbitMQ, NATS+JetStream, AWS SQS+SNS, Google Pub/Sub, Azure Service Bus, Redis Streams, Apache Pulsar, AWS Kinesis Data Streams) against decision factors: throughput fit, ordering match (global/per-key/per-partition/none), delivery guarantee match (at-most-once/at-least-once/exactly-once including scope — within-broker vs end-to-end), replay capability (log-based vs queue-based), fan-out model (1:1/1:N/N:N), durability (replication + fsync), operational burden (managed vs self-hosted), cloud fit (AWS/GCP/Azure native option), cost envelope per message + retention, ecosystem fit (existing broker / team familiarity). Per broker: strengths + weaknesses + delivery semantics + ordering guarantees + ops burden. Supports hybrid recommendations (e.g., Kafka for events + SQS for work queues). Produces recommendation with trade-offs accepted, escape hatch, managed-vs-self-hosted stance. Hands off event payload design → `event-schema-design`, rate-limiting on producers → `rate-limiting-throttling-strategy`. Mermaid broker-fit radar + topology diagram with PNG export. |
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

- New workload needing a broker
- Broker migration evaluation
- Hybrid multi-broker decision
- Cost / ops review of current broker

## When not to use

- Event payload design → `event-schema-design`
- Integration pattern choice → `integration-pattern-selection`
- Event sourcing domain design → `event-sourcing-cqrs-design`
- Webhook design → `webhook-design`

---

## Required input

| Field | Description |
|---|---|
| **Workload description** | What messages, volume |
| **Expected throughput** | Peak + sustained msg/s |
| **Delivery guarantee** | at-most-once / at-least-once / exactly-once |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Ordering** | Global / per-key / none | Asked |
| **Replay** | Needed / not | Asked |
| **Fan-out** | 1:1 / 1:N / N:N | Asked |
| **Retention** | Window | Asked |
| **Cloud** | AWS / GCP / Azure / on-prem | Asked |
| **Team ops capacity** | Managed / some / full | Asked |
| **Existing ecosystem** | Broker already in use | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/message-broker-selection/` |

## Input schema

```
input:
  required:
    workload: string
    throughput: object
    delivery_guarantee:
      type: string
      enum: [at-most-once, at-least-once, exactly-once]
  optional:
    ordering: string
    replay: boolean
    fanout: string
    retention: string
    cloud: string
    team_ops_capacity: string
    existing_ecosystem: string
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
Workload, throughput, delivery, ordering, replay, fan-out, retention, cloud, ops.

### Phase 2 — Broker catalog
Kafka / RabbitMQ / NATS+JetStream / SQS+SNS / Pub/Sub / Service Bus / Redis Streams / Pulsar / Kinesis.

### Phase 3 — Decision factors
Throughput / ordering / delivery / replay / fan-out / durability / ops / cloud / cost / ecosystem.

### Phase 4 — Hybrid consideration
Multi-broker splits per workload class.

### Phase 5 — Recommendation
Chosen + trade-offs + escape hatch + managed vs self-hosted.

### Phase 6 — Diagrams
Broker-fit radar + topology.

### Phase 7 — Diagram rendering
Per mixin.

### Phase 8 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Message Broker Selection: [Workload]

**Date**: [date]
**Workload**: [...]
**Recommended broker**: [...]
**Managed / self-hosted**: [...]

## Scope
## Broker Catalog
## Decision Factors
## Hybrid Assessment
## Recommendation
## Topology
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Broker-fit radar** — Mermaid `xychart-beta`
- **Topology** — Mermaid `graph LR`

---

## Assessment and planning policy

- Workload-driven
- Trade-offs explicit
- Managed vs self-hosted stated
- Hybrid valid
- Escape hatch included
- No fabricated workload

---

## Self-check

```
[] Workload declared
[] Brokers scored
[] Delivery + ordering + replay discussed
[] Managed vs self-hosted stated
[] Hybrid assessed
[] Recommendation with trade-offs + escape hatch
[] Diagrams valid
[] No fabricated workload
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No workload context | Interview mode (§7) |
| Kafka-by-default | Challenge with ops + cost |
| Exactly-once claim | Scope — within broker vs end-to-end |
| Replay on RabbitMQ | Flag: streams plugin or switch |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] Workload facts complete
- [ ] Brokers scored 1–5 per factor
- [ ] Delivery guarantees scoped correctly
- [ ] Replay requirement matched (log vs queue)
- [ ] Ops capacity respected
- [ ] Cost envelope flagged
- [ ] Hybrid evaluated

---

## Examples

### Normal cases

**1. Event-driven e-commerce, 20k msg/s peak**
- Input: High throughput, replay needed, per-key ordering, AWS
- Expected: Kafka (MSK or Confluent Cloud managed); justify with throughput + replay; escape: move to Kinesis if AWS-native preferred

**2. Simple work queue, 100 msg/s**
- Input: Background jobs, at-least-once, no replay, AWS
- Expected: SQS; DLQ; cheap + zero-ops; escape: RabbitMQ if complex routing emerges

**3. Microservice events on Kubernetes**
- Input: K8s-native, moderate throughput, small team
- Expected: NATS+JetStream; lightweight; escape: Kafka if retention grows

**4. GCP streaming pipeline**
- Input: GCP-native, global ingestion
- Expected: Pub/Sub; ordering keys where needed; hand off to BigQuery for analytics

**5. Hybrid — events + jobs**
- Input: E-commerce with events + async jobs
- Expected: Kafka for events + SQS for jobs; justify split; op cost of two brokers flagged

### Edge cases

**6. Exactly-once across services**
- Input: Team requests exactly-once end-to-end
- Expected: Explain — broker exactly-once is within-broker only; end-to-end needs idempotent consumers + transactional outbox

**7. On-prem, no managed options**
- Input: Regulated environment, self-hosted required
- Expected: Kafka (self-hosted) or RabbitMQ; ops capacity check; Pulsar if multi-tenant needed

**8. Retention for 365 days**
- Input: Audit + replay needs
- Expected: Kinesis (up to 365d) or Pulsar tiered storage; cost modeling included

### Failure cases

**9. No workload context**
- Input: "Pick a broker"
- Expected: Interview — "What workload, throughput, delivery, ordering?"

**10. Implementation request**
- Input: "Pick broker + build producers + consumers"
- Expected: "Selection only; implementation is engineering."
