# Webhook Design — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | webhook-design |
| **Version** | 1.0.0 |
| **Purpose** | Designs webhook-based event notifications (outbound, inbound, or both). Defines event catalog + payload references (hand-off to `event-schema-design`), request envelope with canonical headers (`X-Webhook-Id`, `X-Webhook-Timestamp`, `X-Webhook-Signature` as `v1=HMAC-SHA256(secret, timestamp + "." + raw_body)`, `X-Webhook-Event`, `X-Webhook-Version`), at-least-once delivery semantics requiring receiver idempotency, retry schedule (exponential backoff with jitter, ceiling of N attempts then DLQ, honoring `Retry-After`), replay + redelivery endpoint with auth + rate-limit + max window, subscription management CRUD API (create / list / enable-disable / rotate-secret / test), security (HMAC + ±5-min timestamp tolerance + two-active-secrets rotation, optional mTLS, optional IP allowlist, no secrets in URLs), consumer idempotency guidance (idempotency_key + TTL ≥ max retry horizon), versioning (header + parallel v1+v2 window + RFC 8594 sunset), per-endpoint rate limiting, observability (dashboard + delivery log + alerts). Covers inbound-webhook reception (verify before parse, ack in < 2s, queue work, defend against replays). Mermaid delivery + retry/DLQ sequence diagrams with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Design outbound webhooks for partners / customers
- Receive inbound webhooks from third parties
- Add replay + redelivery to existing webhook product
- Upgrade security (unsigned → HMAC / mTLS)

## When not to use

- Internal async integration → `integration-pattern-selection`
- Broker choice → `message-broker-selection`
- Event payload schema → `event-schema-design`
- API versioning strategy → `api-versioning-strategy`
- Rate limiting detail → `rate-limiting-throttling-strategy`

---

## Required input

| Field | Description |
|---|---|
| **Producer** | Source service |
| **Consumers** | Partners / internal / user-configurable |
| **Events to deliver** | List |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Delivery SLA** | e.g. 99%/1 min, 100%/24 h | Asked |
| **Security constraints** | HMAC / mTLS | Asked |
| **Existing auth model** | OAuth2 / API key | Asked |
| **Volume** | events/s peak | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/webhook-design/` |

## Input schema

```
input:
  required:
    producer: string
    consumers: array[string]
    events: array[string]
  optional:
    direction:
      type: string
      enum: [outbound, inbound, both]
    delivery_sla: string
    security_constraints: array[string]
    existing_auth_model: string
    volume: object
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
Producer, consumers, events, SLA, security, volume.

### Phase 2 — Event catalog
Event list + payload summary + urgency (payloads via `event-schema-design`).

### Phase 3 — Request format
Headers + envelope + status-code semantics.

### Phase 4 — Security
HMAC + timestamp + rotation + mTLS + IP allowlist + no-secrets-in-URL.

### Phase 5 — Retry + DLQ
Schedule + ceiling + `Retry-After` + endpoint disabling + DLQ.

### Phase 6 — Subscription management
CRUD API + test + rotate-secret.

### Phase 7 — Idempotency
Receiver guidance (dedupe key + TTL).

### Phase 8 — Versioning
Header + parallel window + sunset header.

### Phase 9 — Rate limiting
Per-endpoint; hand off to rate-limiting skill.

### Phase 10 — Observability
Dashboard + log + alerts.

### Phase 11 — Inbound webhooks
Verify + fast ack + replay defense.

### Phase 12 — Diagrams
Delivery + retry/DLQ.

### Phase 13 — Diagram rendering
Per mixin.

### Phase 14 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Webhook Design: [Producer → Consumers]

**Date**: [date]
**Producer**: [...]
**Consumers**: [...]
**Direction**: [outbound / inbound / both]

## Scope
## Event Catalog
## Request Format
## Security
## Retry + DLQ
## Replay Endpoint
## Subscription Management
## Idempotency (receiver guidance)
## Versioning
## Rate Limiting
## Observability
## Inbound Webhooks (if applicable)
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Delivery flow** — Mermaid `sequenceDiagram`
- **Retry + DLQ** — Mermaid `sequenceDiagram`

---

## Assessment and planning policy

- At-least-once + idempotent receiver
- HMAC + timestamp + replay window
- Retry ceiling + DLQ
- Replay endpoint
- Versioning explicit
- Subscription management API
- No secrets in URLs
- No fabricated events

---

## Self-check

```
[] Event catalog declared
[] Request envelope + headers defined
[] HMAC + timestamp + rotation specified
[] Retry schedule + DLQ specified
[] Replay endpoint + subscription API
[] Idempotency guidance
[] Versioning explicit
[] Rate limiting + observability plan
[] Inbound concerns if applicable
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No events listed | Interview mode (§7) |
| Unsigned webhook request | Challenge — HMAC minimum |
| Infinite retries | Enforce ceiling + DLQ |
| Secret in URL | Reject |
| Receiver not idempotent | Flag with guidance |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] Signature scheme versioned (`v1=`)
- [ ] Timestamp tolerance within ±5 minutes
- [ ] Secret rotation window supports two active secrets
- [ ] Retry ceiling + DLQ defined
- [ ] Replay endpoint authenticated + rate-limited
- [ ] Subscription management CRUD complete
- [ ] Receiver idempotency guidance included
- [ ] Observability alerts defined

---

## Examples

### Normal cases

**1. Outbound to partners**
- Input: Payments producer, external partner consumers
- Expected: HMAC + 5-min window, retry ceiling, DLQ, replay endpoint, subscription API, per-endpoint rate limit

**2. User-configurable webhooks (SaaS)**
- Input: SaaS app allowing customer endpoints
- Expected: UI-managed endpoints via subscription API; test endpoint; rotating secrets; observability dashboard per endpoint

**3. Inbound from Stripe**
- Input: Payment events from Stripe
- Expected: Verify signature before parse; queue work; ack < 2s; idempotency on our side; handle replay

**4. Internal service notifications**
- Input: Internal events to other services, low external risk
- Expected: Prefer internal broker/integration-pattern-selection; webhooks only if consumer can't subscribe to broker

**5. Breaking payload change**
- Input: v2 payload required
- Expected: Parallel v1+v2 window, sunset header, per-endpoint version selection, changelog

### Edge cases

**6. Consumer endpoint flaps**
- Input: 100 consecutive failures
- Expected: Disable endpoint + notify owner + keep history

**7. Replay request for old events**
- Input: Consumer asks for 6 months replay
- Expected: Enforce max window (e.g. 30 days); require archival pathway for older

**8. Multi-region delivery**
- Input: Consumers globally distributed
- Expected: Regional workers + geo-aware retries; dashboard per region

### Failure cases

**9. Unsigned webhook proposal**
- Input: "Just POST JSON, no signing"
- Expected: Challenge — HMAC minimum; cite replay + tamper risk

**10. Secret in URL**
- Input: `?token=abc123` in URL
- Expected: Reject — token belongs in header or body
