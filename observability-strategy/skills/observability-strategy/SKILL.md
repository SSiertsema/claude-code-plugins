---
name: observability-strategy
description: Observability across metrics / logs / traces / events / profiles. Tool selection, structured logging, metric cardinality discipline, distributed tracing via OTel, SLO-burn alerting, dashboards per audience.
argument-hint: "[system + scale + existing tooling]"
---

# Observability Strategy

You design observability: metrics, logs, traces, events, profiling. Goal: understand system behavior in production without redeploy.

## Core rules

- **Three pillars + events + profiles** — no single pillar is enough
- **OpenTelemetry default** — standards-based, vendor-neutral
- **Structured logging** — JSON with common fields
- **Cardinality discipline** — metrics explode with high-cardinality tags; use sparingly
- **Alert on SLO burn, not symptoms** — symptom alerts create fatigue
- **Dashboards per audience** — ops, oncall, product, leadership see different views

## Pillars

| Pillar | Purpose | Good at | Tools |
|---|---|---|---|
| **Metrics** | Aggregate trends over time | "Is something getting worse?" | Prometheus, Datadog, New Relic |
| **Logs** | Discrete events with context | "What happened at time X?" | ELK, Loki, Datadog Logs, Splunk |
| **Traces** | End-to-end request path across services | "Why is this slow?" | Jaeger, Tempo, Honeycomb, Datadog APM |
| **Events** | Business / deploy / incident markers | "Correlate with changes" | Sentry events, PagerDuty, deploys in metrics |
| **Profiles** | Continuous CPU / memory profiling | "Where is time spent?" | Pyroscope, Datadog Continuous Profiler |

## OpenTelemetry

Standard instrumentation:
- **SDK** per language (auto-instrumentation for common libs)
- **Collector** receives + processes + forwards
- **OTLP protocol** vendor-neutral
- Works with any backend (Datadog, Jaeger, Tempo, Prometheus, etc.)

Default to OTel unless specific vendor SDK required.

## Structured logging

JSON logs with common fields:

```json
{
  "timestamp": "2026-04-17T12:00:00.123Z",
  "level": "INFO",
  "service": "order-api",
  "trace_id": "abc...",
  "span_id": "def...",
  "user_id": "hashed",
  "request_id": "req-xyz",
  "message": "Order placed",
  "order_id": "ord-123",
  "duration_ms": 45
}
```

Rules:
- ISO 8601 timestamps with UTC + milliseconds
- Consistent field names across services
- No PII in logs
- Redaction of known sensitive patterns
- Sampling for verbose (DEBUG) logs

## Metric naming + cardinality

Naming convention: `namespace_metric_unit_suffix` (Prometheus style).

Examples:
- `http_requests_total` (counter)
- `http_request_duration_seconds` (histogram)
- `active_users` (gauge)

**Cardinality** = unique combinations of label values.
- Low-cardinality labels safe: env, service, region, status-code bucket
- Avoid: user_id, session_id, request_id as metric labels
- High cardinality → metric DB blows up (Prometheus loses data; Datadog costs explode)

Use **traces + logs** for per-user data; **metrics** for aggregates.

## Distributed tracing

- Every external request → root span
- Trace propagated via W3C Trace Context headers
- Spans for each service call, DB query, external API
- Span attributes: user_id (hashed), request_id, key operations
- Sampling: head-based (sample % at ingress) + tail-based (always keep errors / slow)

## Alerting philosophy

- **Alert on SLO burn** (fast-burn for big outages, slow-burn for leaks) — see `slo-sli-definition`
- **NOT on symptom metrics** (e.g., "CPU > 80%") — these create fatigue without actionability
- **Each alert actionable** — if no action, delete alert
- **Runbook linked** from every alert
- **Severity tiers**: P1 pages, P2 email, P3 dashboard-only

## Dashboards per audience

| Audience | What they see |
|---|---|
| **Oncall** | SLO burn, recent deploys, error-rate, top latencies |
| **Product / PM** | User funnel, feature usage, NPS proxies |
| **Leadership** | Uptime, revenue-impacting incidents, MTTR |
| **Dev team** | Service-specific metrics, latency breakdown, deploy effects |
| **Support** | Per-customer incidents, status-page-aligned |

## Tool selection

For small / greenfield: Datadog / New Relic (managed, all pillars, priced per host).

For self-hosted / cost-conscious: Prometheus + Grafana + Loki + Tempo + OpenTelemetry Collector.

For advanced investigation: Honeycomb / Lightstep (best-in-class traces + exploration).

For enterprise: Splunk / Dynatrace.

## Report

```markdown
# Observability Strategy: [System]

## Pillars Covered
[Metrics / logs / traces / events / profiles]

## Tool Selection
[Chosen + rationale]

## OpenTelemetry Adoption
[Coverage plan]

## Structured Logging Standard
[Field schema + naming]

## Metric Naming + Cardinality
[Naming convention + cardinality rules]

## Distributed Tracing
[Propagation + sampling + span attributes]

## Alerting Philosophy
[SLO-burn + runbooks + severity tiers]

## Dashboards per Audience
[Oncall / PM / leadership / dev / support]

## Data Retention + Cost
[Per pillar + budget]

## Rollout Plan
[Instrumentation phased]
```

## Failure behavior
- Symptom-based alerts flood oncall → migrate to SLO-burn
- High-cardinality metrics → refactor to traces / logs
- Non-standard log format → apply schema
- mmdc failure → see mixin
