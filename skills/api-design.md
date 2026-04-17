# API Design — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | api-design |
| **Version** | 1.0.0 |
| **Purpose** | Designs an API by selecting style (REST / GraphQL / gRPC / WebSocket / SSE / tRPC / hybrid) based on consumer profile + payload shape + caching needs + real-time needs + browser reachability + strict-typing needs + team expertise, then applies per-style design: REST (resource modeling, URI conventions, HTTP verbs + status codes, pagination cursor/offset/keyset, filtering, sorting, sparse fields + includes, content negotiation, RFC 7807 error envelope), GraphQL (schema-first + Relay connections + nullability discipline + complexity/depth limits + DataLoader + persisted queries), gRPC (proto contracts + field numbering rules + streaming modes + deadlines + google.rpc.Code). Defines error taxonomy (stable codes + trace ids), cross-cutting concerns (auth, idempotency via Idempotency-Key, optimistic concurrency via ETag). Hands off versioning → `api-versioning-strategy`, rate limiting → `rate-limiting-throttling-strategy`, async callbacks → `webhook-design`, contract formalization → `api-contract-specification`. Mermaid style-fit radar + request-flow sequence with PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- New API design
- Existing API refactor / redesign
- Style evaluation for a new surface
- Pre-contract (before OpenAPI / AsyncAPI)

## When not to use

- Contract specification only → `api-contract-specification`
- Versioning only → `api-versioning-strategy`
- Rate limiting only → `rate-limiting-throttling-strategy`
- Webhook callback design → `webhook-design`
- Third-party API evaluation → `third-party-api-evaluation`

---

## Required input

| Field | Description |
|---|---|
| **API purpose** | What problem it solves |
| **Consumers** | Internal / external / partner / mobile / web / batch |
| **Domain entities / operations** | List |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Latency / throughput targets** | p99, req/s | Asked |
| **Auth model** | Method | Asked |
| **Real-time needs** | None / server-push / bidirectional | Asked |
| **Existing ecosystem style** | REST / GraphQL / gRPC | Asked |
| **Constraints** | Browser / binary / polyglot | None |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/api-design/` |

## Input schema

```
input:
  required:
    api_purpose: string
    consumers: array[string]
    domain_entities_or_operations: array[string]
  optional:
    latency_throughput: object
    auth_model: string
    real_time_needs: string
    existing_style: string
    constraints: object
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
Collect purpose, consumers, domain, latency, throughput, auth, real-time, constraints.

### Phase 2 — Style catalog
REST / GraphQL / gRPC / WebSocket / SSE / tRPC / hybrid.

### Phase 3 — Decision factors
Consumer diversity / payload / caching / real-time / tooling / observability / browser / typing / team expertise.

### Phase 4 — Recommendation
Chosen + trade-offs + hand-offs.

### Phase 5 — Surface design
REST (resources / pagination / filtering / errors) or GraphQL (schema / connections / complexity) or gRPC (proto / streaming / deadlines).

### Phase 6 — Cross-cutting
Auth / idempotency / concurrency. Hand-offs for versioning, rate limits, webhooks, contract.

### Phase 7 — Diagrams
Style-fit radar + request-flow sequence.

### Phase 8 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 9 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# API Design: [Name]

**Date**: [date]
**Purpose**: [...]
**Consumers**: [...]
**Selected style**: [...]

## Scope
## Style Catalog
## Decision Factors
## Recommendation
## Surface Design
## Error Taxonomy
## Pagination / Filtering / Sorting
## Cross-cutting
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Style-fit radar** — Mermaid `xychart-beta`
- **Request flow** — Mermaid `sequenceDiagram`

---

## Assessment and planning policy

- Style choice justified
- Trade-offs explicit
- Error model designed (not improvised)
- Pagination / filtering / sorting defined
- Hand-offs listed
- No fabricated endpoints

---

## Self-check

```
[] Consumers + purpose declared
[] Style recommended with trade-offs
[] Surface designed
[] Error taxonomy defined
[] Pagination + filtering defined
[] Hand-offs identified
[] Diagrams valid
[] No fabricated endpoints
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No consumer context | Interview mode (§7) |
| Style chosen without analysis | Challenge with consumer profile |
| Public GraphQL without complexity limits | Flag risk |
| Browser + raw gRPC | Flag incompatibility |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] Consumer profile declared
- [ ] Style trade-offs stated
- [ ] Surface designed (resources / schema / protos)
- [ ] Error model RFC 7807 or gRPC codes or typed payloads
- [ ] Pagination strategy fit for data volume
- [ ] Hand-offs to downstream skills

---

## Examples

### Normal cases

**1. Public API for a payments product**
- Input: External developers, OAuth2, cacheable reads, heavy webhook usage
- Expected: REST (public + caching + universality); RFC 7807 errors; cursor pagination; hand off to `webhook-design`; hand off to `api-versioning-strategy`

**2. Mobile-first aggregation**
- Input: iOS + Android + web consumers, varied field needs, bandwidth-sensitive
- Expected: GraphQL; persisted queries; DataLoader; complexity limit; error payload unions

**3. Internal service mesh**
- Input: 40+ internal services, polyglot, low-latency
- Expected: gRPC; proto field rules; deadlines; bidirectional streaming where applicable

**4. Real-time collaboration**
- Input: Live cursor + presence + document ops
- Expected: WebSocket for bi-di ops; SSE fallback for presence-only; REST for persistent state

**5. TypeScript monorepo**
- Input: Next.js app, internal only, shared types
- Expected: tRPC; note tight coupling; warn if external consumers emerge

### Edge cases

**6. Public GraphQL without limits**
- Input: Team wants open GraphQL for community
- Expected: Flag query-complexity risk; recommend persisted queries or REST

**7. Hybrid REST + gRPC**
- Input: Public REST + internal gRPC
- Expected: Gateway pattern; REST surface documented separately; gRPC internal only

**8. Browser direct gRPC**
- Input: Web SPA calling gRPC directly
- Expected: Flag — needs gRPC-Web bridge or REST gateway

### Failure cases

**9. No consumers listed**
- Input: "Design me an API"
- Expected: Interview — "Who are consumers? What domain? What latency?"

**10. Implementation request**
- Input: "Design + implement"
- Expected: "Design only. Implementation is engineering."
