# Rate Limiting + Throttling Strategy — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | rate-limiting-throttling-strategy |
| **Version** | 1.0.0 |
| **Purpose** | Designs rate-limiting + throttling + backpressure for an API or service. Selects algorithm (token bucket / leaky bucket / fixed window counter / sliding window log / sliding window counter / concurrency semaphore / GCRA) and maps to traffic profile. Layers scopes: global > per-tenant > per-user > per-IP > per-endpoint > per-method-on-resource. Enforces across CDN/WAF → API gateway → service → data layer. Defines response contract per IETF `RateLimit-Limit` / `RateLimit-Remaining` / `RateLimit-Reset` + `Retry-After` headers + RFC 7807 `application/problem+json` body with scope indicator. Tier + quota model (rate vs monthly quota, burst, concurrency, overage behavior per tier). Backpressure patterns: capped queues, shed-load on CPU threshold, bulkhead isolation per tenant, circuit breaker with half-open probes, adaptive concurrency (latency-driven autotuning). Storage backend selection (in-process / Redis+GCRA / DynamoDB / Envoy ratelimit / gateway-native). Special cases: bulk endpoints (weighted cost in header + docs), streaming (concurrency not rate), retries + idempotency, webhook outbound (hand-off to `webhook-design`). Observability: per-scope 429 metrics + sustained-429 alert + audit log of adjustments. Mermaid enforcement-layers + bucket-state sequence with PNG export. |
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

- New API / service needing limits
- Existing service hit by abuse / scraping / runaway clients
- Multi-tenant fairness issues
- Pre-launch traffic-profile validation

## When not to use

- DDoS / volumetric attack protection only → security / WAF skills
- Authentication / credential-stuffing protection → security skills
- API design first → `api-design`
- Webhook-specific rates → `webhook-design`

---

## Required input

| Field | Description |
|---|---|
| **API / service** | Name |
| **Traffic profile** | Sustained + peak + burst + sources |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Consumer tiers** | Free / pro / enterprise / internal | Asked |
| **SLO** | Latency + availability targets | Asked |
| **Existing infra** | CDN / gateway / mesh | Asked |
| **Threats** | Scraping / credential stuffing | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/rate-limiting-throttling-strategy/` |

## Input schema

```
input:
  required:
    api: string
    traffic_profile: object
  optional:
    tiers: array
    slo: object
    existing_infra: array[string]
    threats: array[string]
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
API, tiers, traffic, SLO, infra, threats.

### Phase 2 — Algorithm selection
Token bucket / leaky / fixed window / sliding log / sliding counter / concurrency / GCRA.

### Phase 3 — Scope
Global / per-tenant / per-user / per-IP / per-endpoint; layered.

### Phase 4 — Enforcement layers
CDN / gateway / service / data.

### Phase 5 — Response contract
`RateLimit-*` + `Retry-After` + RFC 7807 body.

### Phase 6 — Tier + quota model
Rates + bursts + concurrency + monthly cap + overage.

### Phase 7 — Backpressure
Queue caps, shed-load, bulkhead, circuit breaker, adaptive concurrency.

### Phase 8 — Storage backend
In-process / Redis+GCRA / DynamoDB / Envoy / gateway-native.

### Phase 9 — Special cases
Bulk, streaming, retries, webhooks.

### Phase 10 — Observability
Metrics + alerts + audit log.

### Phase 11 — Diagrams
Enforcement layers + bucket state sequence.

### Phase 12 — Diagram rendering
Per mixin.

### Phase 13 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Rate Limiting + Throttling Strategy: [API / Service]

**Date**: [date]
**API**: [...]

## Scope
## Algorithm Selection
## Scope Model
## Enforcement Layers
## Response Contract
## Tier + Quota Model
## Backpressure
## Storage Backend
## Special Cases
## Observability
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Enforcement layers** — Mermaid `graph TD`
- **Bucket state** — Mermaid `sequenceDiagram`

---

## Assessment and planning policy

- Algorithm fits traffic
- Scope layered
- `RateLimit-*` + `Retry-After` in responses
- Backpressure defined
- Tiers + quotas specified
- Storage justified
- No fabricated traffic

---

## Self-check

```
[] Algorithm chosen
[] Scope layered
[] Enforcement layers defined
[] RateLimit-* + Retry-After
[] Tier + quota model
[] Backpressure patterns
[] Storage backend
[] Observability + alerts
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No traffic profile | Interview mode (§7) |
| Fixed window for precision | Challenge — sliding / GCRA |
| Unbounded queue | Challenge |
| No 429 body | Require |
| DDoS protection via app-rate-limits only | Flag — security hand-off |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] Traffic profile declared
- [ ] Algorithm justified
- [ ] Scopes + layers fit threats
- [ ] Headers per IETF draft
- [ ] Tiers with overage behavior
- [ ] Backpressure across queue + CPU + pool
- [ ] Storage backend matches scale + infra

---

## Examples

### Normal cases

**1. Public REST API**
- Input: Free + Pro + Enterprise tiers, 5k rps sustained, 20k burst
- Expected: Token bucket (GCRA on Redis) per API key + per-tenant; `RateLimit-*` headers; per-tier bursts; gateway + service enforcement

**2. Multi-tenant SaaS**
- Input: Shared backend, tenants with different usage patterns
- Expected: Per-tenant bucket + bulkhead; noisy-neighbor protection; circuit breaker on shared dependency

**3. Webhook producer outbound**
- Input: Sending webhooks to many consumer endpoints
- Expected: Per-endpoint rate; honor `Retry-After`; backoff; hand off to `webhook-design`

**4. Internal service mesh**
- Input: 40 services, gRPC
- Expected: Envoy global rate-limit service + concurrency limits per route; adaptive concurrency at call sites

**5. Streaming / long-polling**
- Input: Persistent connections
- Expected: Concurrency limit (not rate) + per-tenant cap + shed-load when saturated

### Edge cases

**6. Bulk endpoint**
- Input: `POST /bulk` processes up to 100 items
- Expected: Weighted cost (e.g. `X-Cost: 10`); documented; headers reflect true remaining

**7. Slow consumer causing backpressure**
- Input: DB pool saturating under retry storm
- Expected: Bulkhead pools; shed-load at service edge; circuit-break to DB; adaptive concurrency

**8. Shared Redis single-region latency**
- Input: Global API with US-only Redis
- Expected: Regional limit buckets + eventually-consistent global; trade-off documented

### Failure cases

**9. Unsafe infinite retry on 429**
- Input: Clients retry without backoff
- Expected: Challenge — publish `Retry-After`; recommend jittered backoff; cite danger of cascade

**10. DDoS expectation on app layer only**
- Input: "Our rate limits will stop DDoS"
- Expected: Flag — volumetric DDoS needs WAF / CDN upstream; hand-off to security skills
