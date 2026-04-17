# Logging + Tracing Design — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | logging-tracing-design |
| **Version** | 1.0.0 |
| **Purpose** | Designs logging + distributed tracing for a service. Structured JSON log schema with baseline fields (timestamp RFC 3339 UTC, level TRACE/DEBUG/INFO/WARN/ERROR/FATAL, service, env, version, message, trace_id, span_id, tenant_id, user_id, request_id, event code, error object). Log-level policy (ERROR requires trace_id + actionable info; validation failures are INFO/WARN, not ERROR; rate-limit noisy loggers). OpenTelemetry tracing with spans forming parent/child tree, attributes following OTel semantic conventions (http.*, db.*, messaging.*, rpc.*, exception.*), events (timestamped marks within span), links (across traces, e.g. batch processor). W3C Trace Context propagation (traceparent, tracestate) over HTTP + gRPC; baggage for cross-cutting context (tenant_id, feature flags); propagation across async boundaries via queue headers. Export via OTLP to `opentelemetry-collector` (avoid direct-to-vendor for swap flexibility). Sampling strategy: head (parent-based / rate / probabilistic) and tail (keep 100% errors + slow, 1–10% happy); always-on for critical paths during incidents. Log ↔ trace linking via trace_id + span_id on every record. PII redaction via central library with allowlist + fail-closed default; retention tiers (hot 24–72h full fidelity, warm 30d sampled, cold 90d–7y archived). Health + lifecycle events beyond request logs. Mermaid log/trace pipeline + context-propagation sequence with PNG export. Hand-offs to `observability-strategy` (system-wide) and `data-governance-policy` (PII/retention deeper). |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Component-level logging + tracing design
- Green-lighting a service pre-production
- Migrating from unstructured to structured logs
- Adopting OpenTelemetry

## When not to use

- System-wide observability strategy → `observability-strategy`
- Error strategy → `system-error-handling-strategy`
- PII / retention governance → `data-governance-policy`
- UX error messages → `error-handling-design`

---

## Required input

| Field | Description |
|---|---|
| **Component / service** | Name |
| **Runtime + language** | Go / Node / Python / JVM / .NET / Rust |
| **Dependencies** | DBs, brokers, external APIs |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Traffic profile** | Peak req/s | Asked |
| **Existing backend** | Datadog / Grafana / Honeycomb | Asked |
| **Regulatory** | GDPR / HIPAA / PCI | Asked |
| **Budget** | Ingestion / retention | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/logging-tracing-design/[component]/` |

## Input schema

```
input:
  required:
    component: string
    runtime_language: string
    dependencies: array[string]
  optional:
    traffic_profile: object
    existing_backend: string
    regulatory: array[string]
    budget: string
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
Component, runtime, deps, traffic, backend, regulatory, budget.

### Phase 2 — Structured log schema
Baseline fields + extras.

### Phase 3 — Log levels
Policy per level.

### Phase 4 — Tracing with OpenTelemetry
Spans + attributes + events + links + propagation + export via collector.

### Phase 5 — Sampling
Head + tail; defaults.

### Phase 6 — Log ↔ trace linking
trace_id + span_id everywhere.

### Phase 7 — PII + sensitive
Redaction + allowlist + retention.

### Phase 8 — Retention + cost
Tiers + controls.

### Phase 9 — Health + lifecycle
Process, worker, dep health.

### Phase 10 — Testing + validation
Unit + integration + chaos.

### Phase 11 — Diagrams
Pipeline + propagation.

### Phase 12 — Diagram rendering
Per mixin.

### Phase 13 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Logging + Tracing Design: [Component]

**Date**: [date]
**Component**: [...]
**Runtime**: [...]

## Scope
## Structured Log Schema
## Log Levels
## Tracing with OpenTelemetry
## Sampling
## Log ↔ Trace Linking
## PII + Sensitive Data
## Retention + Cost
## Health + Lifecycle Events
## Testing + Validation
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Pipeline** — Mermaid `flowchart LR`
- **Context propagation** — Mermaid `sequenceDiagram`

---

## Assessment and planning policy

- Structured JSON only
- trace_id in every log
- OTel with collector
- Sampling documented
- PII redacted
- Retention tiered
- Propagation across async
- No fabricated events

---

## Self-check

```
[] JSON schema with baseline fields
[] trace_id + span_id present
[] Log levels policy
[] OTel spans + attributes + propagation
[] Sampling documented
[] PII redaction
[] Retention tiers
[] Health events
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No runtime / deps | Interview mode (§7) |
| Free-text logs | Challenge — JSON required |
| Direct-to-vendor | Recommend collector |
| No PII policy | Ask first |
| No sampling | Propose defaults |
| mmdc failure | See `diagram-rendering` mixin |
| System-wide request | Redirect to `observability-strategy` |

---

## Quality checks

- [ ] Baseline log fields complete
- [ ] OTel semantic conventions used
- [ ] Trace context propagated HTTP + gRPC + async
- [ ] Sampling covers errors + slow
- [ ] PII allowlist + fail-closed
- [ ] Retention tiers match regulatory
- [ ] Collector in path

---

## Examples

### Normal cases

**1. Go HTTP service**
- Input: Gin-based service, Postgres, Kafka, external REST
- Expected: Structured slog schema; OTel SDK; traceparent propagation HTTP + Kafka headers; 10% head sampling + 100% error tail

**2. Node.js worker**
- Input: Async worker consuming SQS
- Expected: Pino JSON logs; OTel Node SDK; SQS attribute propagation; DLQ + retry log events

**3. Python FastAPI service**
- Input: Handles PII (email, phone)
- Expected: Redaction library; allowlist; `user_id` included, `email` redacted to domain; full-context in audit store

**4. Polyglot mesh**
- Input: Go + Java + Python services
- Expected: OTel SDKs per language; shared collector; semantic conventions; baggage for tenant_id

**5. Regulated payments**
- Input: PCI environment
- Expected: Card data never logged; tokenization upstream; audit trail in separate store; 7y retention tier for audit logs

### Edge cases

**6. High-volume event pipeline**
- Input: 1M events/s
- Expected: Sampling aggressive; metrics preferred over logs for per-event detail; retention cold after 7 d

**7. Vendor swap**
- Input: Moving from Datadog to Grafana Cloud
- Expected: Collector already in place → swap exporter; spot-check dashboards + queries

**8. Missing propagation across async**
- Input: Queue consumer starts new trace
- Expected: Flag — propagate via message headers; link to producer span if needed

### Failure cases

**9. Free-text concat logging**
- Input: `log.info(f"user {email} did {action}")`
- Expected: Challenge — structured fields + redaction; rewrite guidance

**10. System-wide observability**
- Input: "Design our observability stack"
- Expected: Redirect to `observability-strategy`
