# System Error-Handling Strategy — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | system-error-handling-strategy |
| **Version** | 1.0.0 |
| **Purpose** | Defines system-level error handling strategy across services, layers, and dependencies. Classifies errors into eight categories (programmer, validation, domain rejection, transient dependency, resource exhaustion, poison data, external contract, unknown) with per-class strategy: programmer → fail-fast + alert + fix; validation → 4xx + RFC 7807 + no retry; domain → 4xx user-visible + no retry; transient → retry with exponential backoff + jitter + max attempts + deadline, idempotency required, circuit breaker, optional fallback; resource exhaustion → shed-load with 503 + Retry-After, bulkhead, autoscale signal, queue caps; poison → N retries then DLQ with full context; external contract → schema-validate at boundary, circuit-break, partner comms; unknown → fail-safe + escalate + classify later. Retry budget parameters (base delay, backoff, jitter, max attempts, deadline propagation via gRPC deadlines or HTTP context). Circuit breaker states (Closed / Open / Half-open) with thresholds + recovery. Timeout cascade rule (inner < outer) + cancellation propagation. Idempotency patterns (Idempotency-Key, natural key, outbox, exactly-once producer + idempotent consumer). Propagation + translation rules per layer (domain → application → HTTP → external), no stack-trace leakage, trace_id correlation. DLQ per source with ops UI + alerting. Observability via SLO-burn alerts + DLQ depth + unknown-error spikes. User-facing vs operator-facing message split. Runbook-per-alert coupling. Hand-offs to `logging-tracing-design`, `observability-strategy`, `disaster-recovery-planning`, `error-handling-design` (UX microcopy). Mermaid classification-flowchart + circuit-breaker-state with PNG export. |
| **Primary category** | `planning` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- New service / system needing a coherent error model
- Existing system with ad-hoc error handling
- Multi-service resilience work
- Pre-SRE review

## When not to use

- UX error microcopy → `error-handling-design`
- Logging/tracing only → `logging-tracing-design`
- Full observability stack → `observability-strategy`
- DR plan → `disaster-recovery-planning`
- Incident-management process → (future skill)

---

## Required input

| Field | Description |
|---|---|
| **System scope** | Service / system-of-services |
| **Dependencies** | DBs, brokers, external APIs |

## Optional input

| Field | Description | Default |
|---|---|---|
| **SLOs** | Availability / latency | Asked |
| **Consumer types** | End-user / internal / partner | Asked |
| **Existing patterns** | Retry lib, breaker lib | Asked |
| **Regulatory** | Audit / breach | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/system-error-handling-strategy/` |

## Input schema

```
input:
  required:
    system_scope: string
    dependencies: array[string]
  optional:
    slos: object
    consumer_types: array[string]
    existing_patterns: array[string]
    regulatory: array[string]
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
System, deps, SLOs, consumers, existing patterns.

### Phase 2 — Classification
8 classes with definitions + examples.

### Phase 3 — Per-class strategy
Fail-fast / reject / retry+budget / shed / DLQ / circuit-break / escalate.

### Phase 4 — Retry budgets
Params + propagation via deadlines.

### Phase 5 — Circuit breakers
State model + thresholds + recovery.

### Phase 6 — Timeouts
Cascade rule + cancellation.

### Phase 7 — Idempotency
Patterns in use.

### Phase 8 — Propagation + translation
Layer rules + no leakage.

### Phase 9 — DLQ
Per source + ops UI + alerts.

### Phase 10 — Observability
Metrics + alerts + dashboards.

### Phase 11 — User vs operator
Message policy.

### Phase 12 — Runbooks
Per alert.

### Phase 13 — Diagrams
Classification flow + breaker state.

### Phase 14 — Diagram rendering
Per mixin.

### Phase 15 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# System Error-Handling Strategy: [System]

**Date**: [date]
**System**: [...]
**Dependencies**: [...]

## Scope
## Error Classification
## Per-Class Strategy
## Retry Budgets
## Circuit Breakers
## Timeouts
## Idempotency
## Propagation + Translation
## Dead-Letter Queue
## Observability
## User-Facing vs Operator-Facing
## Runbooks
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Classification flow** — Mermaid `flowchart TD`
- **Circuit-breaker state** — Mermaid `stateDiagram-v2`

---

## Assessment and planning policy

- Every error mapped
- Retry budgeted + idempotent
- Circuit breaker per external
- Timeout cascade rule
- DLQ for poison
- Translation at boundaries
- User vs operator split
- Runbooks coupled
- No fabricated deps

---

## Self-check

```
[] Classification covers sources
[] Per-class strategy clear
[] Retry budgets concrete
[] Breakers per external dep
[] Timeouts with cascade rule
[] Idempotency in place
[] DLQ per source
[] Observability + alerts
[] User vs operator split
[] Runbook links
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No deps listed | Interview mode (§7) |
| Unbounded retry | Require budget |
| No DLQ | Add |
| Stack traces to users | Require translation |
| Missing idempotency | Add requirement |
| No breaker | Flag |
| UX microcopy | Redirect to `error-handling-design` |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] All error sources classified
- [ ] Per-class strategies concrete
- [ ] Retry budgets + idempotency
- [ ] Breaker states + thresholds
- [ ] Timeouts < upstream
- [ ] Translation at boundaries
- [ ] DLQ + alerts + ops UI
- [ ] Runbooks per alert

---

## Examples

### Normal cases

**1. New e-commerce service**
- Input: Orders service + DB + Kafka + Payment API
- Expected: Classification table; retry with budget for DB/Kafka; breaker on Payment API; outbox for publish; DLQ on consumer; RFC 7807 at HTTP edge

**2. Legacy service refactor**
- Input: Ad-hoc try/catch, no DLQ, stack traces leak
- Expected: Classification gap analysis; add breakers + DLQ; translation layer; runbook links

**3. Partner integration hardening**
- Input: Partner API flaky
- Expected: Breaker + timeout + fallback; contract monitoring; partner-comms runbook

**4. High-throughput streaming consumer**
- Input: Kafka consumer
- Expected: Per-partition DLQ; skip-on-poison; backpressure; lag alerts

**5. Compliance-heavy audit path**
- Input: Financial transactions
- Expected: Full audit trail on errors; operator logs retain; user sees generic + trace_id

### Edge cases

**6. Cascade amplification**
- Input: Service with retries cascading downstream
- Expected: Retry budget tight; retry only where idempotent; deadlines cascade; document anti-pattern risk

**7. DLQ overflow**
- Input: Mass poison influx
- Expected: Depth alert; DLQ partitioning per cause; runbook for triage

**8. Dual-write detected**
- Input: Service writes DB + publishes event non-atomically
- Expected: Recommend outbox; hand off to `integration-pattern-selection`

### Failure cases

**9. No deps listed**
- Input: "Make error handling better"
- Expected: Interview — system + deps + SLO

**10. UX request**
- Input: "Design error toast messages"
- Expected: Redirect to `error-handling-design`
