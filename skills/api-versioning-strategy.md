# API Versioning Strategy — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | api-versioning-strategy |
| **Version** | 1.0.0 |
| **Purpose** | Selects an API versioning strategy per API style: REST (URL path `/v1/`, custom header `X-API-Version`, media-type `application/vnd.example.v2+json`, query param `?v=2`, or evolutionary with client-pinned date e.g. Stripe `X-API-Version: 2026-01-15`), GraphQL (prefer `@deprecated` + additive; parallel schemas or federation swap for large breaks; `graphql-inspector` in CI), gRPC (package versioning `orders.v1` / `orders.v2`; field-number + `reserved` rules; `buf breaking` in CI), events (hand-off to `event-schema-design`: topic name with version, parallel topics, upcasting). Defines breaking-vs-non-breaking taxonomy with examples (safe: additive optional fields, new endpoints, new enum values if clients tolerate unknowns; breaking: remove/rename, type change, required-on-existing-optional, error envelope change, auth change; grey: default changes, tightening validation, rate-limit tightening). Deprecation policy: lifecycle (announced → deprecated → sunset → removed → 410 Gone), RFC 8594 `Deprecation` + `Sunset` + `Link rel=deprecation` headers, timelines per consumer type (public 12–24 mo, partner 6–12 mo, internal 1–3 mo), parallel support + traffic metrics + migration guide, multi-channel communication (changelog, email, headers, newsletter, personalized reachout for last 10%). Optional Stripe-style client pinning pattern. Mermaid lifecycle timeline + traffic-migration chart with PNG export. |
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

- Designing a new API's versioning approach
- Retrofitting versioning onto an existing API
- Planning a breaking change + migration
- Deprecating an old version

## When not to use

- Event schema only → `event-schema-design`
- Contract specification only → `api-contract-specification`
- API surface design → `api-design`

---

## Required input

| Field | Description |
|---|---|
| **API style** | REST / GraphQL / gRPC / events |
| **Consumer base** | Internal / partner / public / mobile |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Consumer update control** | We / they control | Asked |
| **Change profile** | Breaking cadence | Asked |
| **Existing scheme** | Current versioning | Asked |
| **Deprecation tolerance** | Months | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/api-versioning-strategy/` |

## Input schema

```
input:
  required:
    api_style:
      type: string
      enum: [rest, graphql, grpc, events, hybrid]
    consumer_base: array[string]
  optional:
    consumer_update_control: string
    change_profile: string
    existing_scheme: string
    deprecation_tolerance_months: integer
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
API style, consumers, update control, change profile, existing scheme, tolerance.

### Phase 2 — Strategy catalog
REST / GraphQL / gRPC / events.

### Phase 3 — Breaking vs non-breaking
Safe / breaking / grey with examples.

### Phase 4 — Deprecation policy
Lifecycle + headers + timelines + parallel window + comms.

### Phase 5 — Events
Hand off to `event-schema-design`.

### Phase 6 — Client pinning (optional)
Stripe-style date-pinned version.

### Phase 7 — Recommendation
Chosen + tooling + comms plan.

### Phase 8 — Diagrams
Lifecycle timeline + traffic migration.

### Phase 9 — Diagram rendering
Per mixin.

### Phase 10 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# API Versioning Strategy: [API]

**Date**: [date]
**API style**: [...]
**Strategy**: [...]

## Scope
## Strategy Catalog
## Recommendation
## Breaking vs Non-Breaking Taxonomy
## Deprecation Policy
## Client Pinning (if adopted)
## Tooling
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Lifecycle** — Mermaid `timeline`
- **Traffic migration** — Mermaid `xychart-beta`

---

## Assessment and planning policy

- Strategy matches API style
- Breaking taxonomy defined
- Deprecation policy concrete
- Parallel window feasible
- Tooling listed
- No fabricated consumers

---

## Self-check

```
[] API style declared
[] Strategy chosen per style
[] Breaking taxonomy documented
[] Deprecation policy with timelines
[] Parallel window feasible
[] Communication plan
[] Tooling listed
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No API style | Interview mode (§7) |
| Version bump per change | Challenge — additive evolution |
| Hard cutover | Require parallel window |
| No deprecation headers | Require RFC 8594 |
| GraphQL URL versioning | Challenge — `@deprecated` |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] Strategy per API style stated
- [ ] Non-breaking vs breaking taxonomy documented
- [ ] Deprecation lifecycle with dates
- [ ] Headers (`Deprecation`, `Sunset`, `Link`)
- [ ] Parallel window feasible
- [ ] Tooling for breaking-change detection
- [ ] Communication plan

---

## Examples

### Normal cases

**1. Public REST API**
- Input: Public consumers, quarterly breaking possible
- Expected: URL path `/v1/` + date-pinned `X-API-Version` hybrid; 18-month parallel; `Deprecation` + `Sunset`

**2. GraphQL public schema**
- Input: GraphQL Admin API for partners
- Expected: No URL version; `@deprecated` directives; parallel fields; `graphql-inspector` CI; sunset comms

**3. Internal gRPC mesh**
- Input: 40 services, TS/Go clients
- Expected: `orders.v1` / `orders.v2` packages; `buf breaking`; 3-month parallel for internal

**4. Event streams**
- Input: Kafka events consumed by multiple teams
- Expected: Hand off to `event-schema-design`; parallel topic strategy; upcasting guidance

**5. Stripe-style rolling**
- Input: Want URL stability + continuous evolution
- Expected: `X-API-Version` date header; server dispatches per pinned version; internal version matrix documented

### Edge cases

**6. Mixed REST + GraphQL + events**
- Expected: Per-style strategy; single deprecation policy across; unified comms plan

**7. Partner demands 3-year support**
- Input: Regulated finance partner
- Expected: Extended parallel window; LTS tier; contract dependency

**8. Need to remove a field immediately for security**
- Expected: Emergency deprecation path: mark deprecated + security-notice comms + shortened sunset; document exception

### Failure cases

**9. No API style**
- Input: "How should we version?"
- Expected: Interview — what style, who are consumers

**10. Implementation request**
- Input: "Implement the versioning"
- Expected: "Strategy only; implementation is engineering."
