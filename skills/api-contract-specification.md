# API Contract Specification — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | api-contract-specification |
| **Version** | 1.0.0 |
| **Purpose** | Formalizes an API design into a machine-readable contract in one of four formats: OpenAPI 3.1 (REST), AsyncAPI 3.0 (event-driven / streaming / webhook), GraphQL SDL (GraphQL), Protobuf 3 (gRPC). Contract-first workflow: the spec precedes code. Produces skeleton + operation templates + reusable components (schemas, parameters, responses, security schemes, examples, headers), RFC 7807 error envelope for REST, typed error unions for GraphQL, `google.rpc.Code` mapping for gRPC. Enforces conventions: `operationId` on every REST op, `reserved` on removed proto fields, Relay connections for GraphQL pagination, `*_UNSPECIFIED = 0` for proto enums. Lint rules listed per format (Spectral + Redocly for OpenAPI/AsyncAPI, `graphql-schema-linter` + `graphql-inspector` for GraphQL, `buf lint` + `buf breaking` for proto). Hands off versioning → `api-versioning-strategy`, rate limits → `rate-limiting-throttling-strategy`, webhook callbacks → `webhook-design`, event payload schema → `event-schema-design`. Mermaid contract-structure diagram with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `transformation` |
| **Output mode** | `machine_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Formalize an API design into a spec
- Publish a contract for consumers
- Add contract to existing undocumented API (with supplied endpoint inventory)
- Contract-driven development workflow

## When not to use

- Style selection / surface design → `api-design`
- Versioning only → `api-versioning-strategy`
- Event payload schema only → `event-schema-design`
- Webhook callback design → `webhook-design`

---

## Required input

| Field | Description |
|---|---|
| **API design** | Output of `api-design` or equivalent design document |
| **Contract format** | OpenAPI 3.1 / AsyncAPI 3.0 / GraphQL SDL / Protobuf 3 |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Version** | API version | Asked |
| **Auth schemes** | OAuth2 / API key / mTLS | Asked |
| **Servers** | Env URLs | Asked |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/api-contract-specification/` |

## Input schema

```
input:
  required:
    api_design: document_reference | object
    contract_format:
      type: string
      enum: [openapi-3-1, asyncapi-3-0, graphql-sdl, protobuf-3]
  optional:
    version: string
    auth_schemes: array
    servers: array
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
Format, version, auth, servers.

### Phase 2 — Format selection
Match to API style.

### Phase 3 — OpenAPI 3.1
Skeleton + operation template + reusable components + Problem schema + security.

### Phase 4 — AsyncAPI 3.0
Channels + operations + messages; hand off payload schema.

### Phase 5 — GraphQL SDL
Types + docstrings + Relay connections + typed error unions.

### Phase 6 — Protobuf 3
Service + messages + enums with `*_UNSPECIFIED = 0` + reserved fields.

### Phase 7 — Lint + validation
Spectral / buf / graphql-schema-linter rules.

### Phase 8 — Hand-offs
Versioning / rate-limit / webhook / event-schema skills.

### Phase 9 — Diagrams
Contract structure.

### Phase 10 — Diagram rendering
Per mixin.

### Phase 11 — Report assembly and approval
Full report; approval before save.

---

## Output contract

```markdown
# API Contract: [Name]

**Date**: [date]
**Format**: [OpenAPI 3.1 / AsyncAPI 3.0 / GraphQL SDL / Protobuf 3]
**Version**: [...]

## Scope
## Contract
## Component Reuse
## Error Model
## Examples
## Security Schemes
## Lint Results
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Contract structure** — Mermaid `graph TD`

---

## Assessment and planning policy

- Format matches style
- Every operation documented
- Components reused
- Examples on every schema + operation
- Errors in envelope
- Security declared + applied
- Lint rules listed
- No fabricated fields

---

## Self-check

```
[] Format fits style
[] Full operation coverage
[] Components reused
[] Errors in envelope
[] Examples present
[] Security declared
[] Lint rules listed
[] Hand-offs identified
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No upstream design | Recommend `api-design` first |
| Missing error model | Produce RFC 7807 baseline |
| Lint failures | List; ask fix in-skill or defer |
| Mixed formats | One contract per style + root index |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] Contract format matches API style
- [ ] All operations documented (paths / channels / rpcs / types)
- [ ] Components reused, no duplication
- [ ] Problem envelope (REST) or typed unions (GQL) or `google.rpc.Code` (gRPC)
- [ ] Examples on every schema + operation
- [ ] Security schemes declared + applied per operation
- [ ] Lint-clean (baseline rules pass)

---

## Examples

### Normal cases

**1. REST Orders API**
- Input: `api-design` output with REST choice
- Expected: OpenAPI 3.1 with paths, `components`, RFC 7807 `Problem`, OAuth2 security, examples per operation

**2. Event-driven order events**
- Input: Kafka channels for `orders.placed`, `orders.cancelled`
- Expected: AsyncAPI 3.0 with channels + operations + messages; hand off payloads to `event-schema-design`

**3. GraphQL admin API**
- Input: GraphQL design with Relay pagination
- Expected: SDL with docstrings, `Connection`/`Edge` types, typed mutation payload unions

**4. gRPC internal service**
- Input: Order service with unary + streaming RPCs
- Expected: Proto v1 package, `*_UNSPECIFIED = 0` enums, `reserved` for deprecated fields, `buf lint`/`buf breaking` listed

**5. Hybrid public REST + internal gRPC**
- Input: Public REST + internal gRPC for same domain
- Expected: Two contracts, root index referencing both

### Edge cases

**6. Contract for existing undocumented API**
- Input: Endpoint inventory only
- Expected: Skeleton + TODO markers per missing response; assumption log listing gaps

**7. Mixed auth schemes**
- Input: OAuth2 for users + API key for partners + mTLS for internal
- Expected: Three `securitySchemes`; per-operation `security` references

**8. Breaking change detection request**
- Input: New version vs prior contract
- Expected: Recommend `graphql-inspector` / `buf breaking` / `openapi-diff`; defer detection to tooling

### Failure cases

**9. No upstream design**
- Input: "Write me an OpenAPI spec"
- Expected: Ask for endpoints + domain + auth; or recommend `api-design` first

**10. Implementation request**
- Input: "Write the spec + implement the handlers"
- Expected: "Contract only. Codegen / handlers are engineering."
