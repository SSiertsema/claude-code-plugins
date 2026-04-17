# Observability Strategy — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | observability-strategy |
| **Version** | 1.0.0 |
| **Purpose** | Design observability across three pillars (metrics / logs / traces) plus events + profiles. OpenTelemetry default for standards-based vendor-neutral instrumentation. Tool selection (Datadog / New Relic managed all-in-one; Prometheus+Grafana+Loki+Tempo self-hosted; Honeycomb / Lightstep for advanced trace exploration; Splunk / Dynatrace enterprise). Structured logging standard (JSON with timestamp + level + service + trace_id + span_id + request_id + message + fields; no PII; redaction). Metric naming convention (namespace_metric_unit_suffix Prometheus-style) with strict cardinality discipline (avoid user_id / session_id / request_id as labels; use traces + logs for per-user data). Distributed tracing via W3C Trace Context propagation + head + tail sampling + span attributes. Alerting on SLO burn (fast + slow from `slo-sli-definition`) not symptom metrics; every alert actionable + runbook-linked + severity-tiered (P1 pages / P2 email / P3 dashboard). Dashboards per audience (oncall / product / leadership / dev / support). Retention + cost management per pillar. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- Greenfield observability setup
- Alert fatigue remediation
- Moving from ad-hoc logging to strategic observability
- Cost reduction in observability tooling

## When not to use
- SLO definition → `slo-sli-definition`
- Performance budgets → `performance-budgeting`
- Incident response process → future IR skills

## Required input
- **System + scale + existing tooling**

## Output contract
Pillars + tools + OTel + logging standard + metrics + tracing + alerting philosophy + dashboards + retention + rollout plan.

## Failure behavior
- Symptom-alert flood → migrate to SLO-burn
- High-cardinality metrics → refactor
- Non-standard logs → apply schema

## Examples
1. Datadog all-in-one for small team — logs + metrics + APM + RUM.
2. Self-hosted stack — Prometheus + Grafana + Loki + Tempo + OTel Collector.
3. Alert fatigue remediation — cut 200 symptom alerts to 30 SLO-burn alerts.
4. High cardinality migration — remove user_id from metrics; use traces + logs.
5. Cross-service tracing rollout — OTel SDK + propagation + Jaeger backend; phased per service.
