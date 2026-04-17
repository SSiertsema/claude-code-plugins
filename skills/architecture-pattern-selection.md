# Architecture Pattern Selection — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | architecture-pattern-selection |
| **Version** | 1.0.0 |
| **Purpose** | Selects an architectural pattern for a system based on context factors (system purpose + team size + scale expectations + latency / consistency needs + change frequency + existing-system situation). Evaluates 8 patterns against decision factors: monolith (single deployable), modular monolith (enforced boundaries + single deploy), microservices (independent services), event-driven architecture (async eventually-consistent), serverless FaaS (no server mgmt), CQRS (command-query separation), service-based (3–10 services middle ground), space-based (in-memory elastic). Per pattern: when-to-use + when-not + key trade-offs + reversibility difficulty. Applies monolith-first bias — recommends simpler patterns unless complexity is justified by concrete context factors. Recommends hybrid combinations (e.g., modular monolith core + microservice edges + event-driven integration + serverless specific workloads) when single pattern doesn't fit all subsystems. Produces evolution roadmap with concrete triggers (team size thresholds, traffic thresholds) when starting pattern is expected to change over time. Mermaid pattern-comparison chart + evolution-roadmap timeline with PNG export. Typically feeds `adr-writing` for decision recording. |
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

- Greenfield system: pick starting architecture
- Existing system growth: evaluate pattern evolution
- Migration planning (monolith to something else — or back)
- Cross-team pattern alignment
- Pre-ADR analysis for a foundational decision

## When not to use

- Technology stack choice (framework / DB / language) → `technology-evaluation-matrix`
- Container / component decomposition → `system-decomposition`
- Domain modeling → `ddd-strategic-modeling`
- Specific trade-off analysis per dimension → `architecture-tradeoff-analysis`
- Infrastructure design → future Phase 5 infrastructure skills

---

## Required input

| Field | Description |
|---|---|
| **System context** | Purpose + scope |
| **Team context** | Size + experience with distributed systems |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Scale expectations** | Req/s + CCU + data volume current + projected | Asked |
| **Latency needs** | p99 target | Asked |
| **Consistency needs** | Strong / eventual / per-aggregate | Asked |
| **Change frequency** | Deploy cadence | Asked |
| **Existing system** | Greenfield / evolution / migration | Greenfield |
| **Constraints** | Regulatory / cost / technical | None |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/architecture-pattern-selection/` |

## Input schema

```
input:
  required:
    system_context:
      type: string | document_reference
    team_context:
      type: object
      properties:
        size: integer
        distributed_experience: string
  optional:
    scale_expectations: object
    latency_needs: object
    consistency_needs: string
    change_frequency: string
    existing_system: string
    constraints: object
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path:
      type: string
```

---

## Processing rules

### Phase 1 — Setup
Collect system + team + scale + latency + consistency + change-velocity + existing.

### Phase 2 — Pattern catalog
Monolith / modular monolith / microservices / event-driven / serverless / CQRS / service-based / space-based.

### Phase 3 — Decision factors
Team-fit / scale / latency / consistency / change-velocity / observability / cost / reversibility.

### Phase 4 — Monolith-first analysis
Justify complexity before accepting distributed patterns.

### Phase 5 — Hybrid recommendation
Combine patterns per subsystem when appropriate.

### Phase 6 — Recommendation
Chosen + rationale + trade-offs + escape hatch + constraints.

### Phase 7 — Evolution roadmap
Triggers + phases if pattern expected to evolve.

### Phase 8 — Diagrams
Pattern comparison + evolution roadmap.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Architecture Pattern Selection: [System]

**Date**: [date]
**System**: [purpose]
**Team**: [size + experience]
**Selected pattern**: [chosen or hybrid]

## Scope
[Context, team, scale, latency, consistency, change velocity, constraints]

## Pattern Catalog
[Patterns evaluated with when-to-use / when-not / trade-offs / reversibility]

## Decision Factors Analysis
[Per-factor scoring]

## Monolith-First Analysis
[Justified complexity]

## Hybrid Assessment
[If hybrid: patterns per subsystem]

## Recommendation
[Chosen + rationale + trade-offs + escape hatch]

## Evolution Roadmap
[Triggers + phases if applicable]

## Diagrams
[Comparison + roadmap]

## Assumptions & Limitations
[Context assumptions]
```

### Diagrams

- **Pattern comparison** — Mermaid `xychart-beta` (multi-bar across decision factors)
- **Evolution roadmap** — Mermaid `timeline`

---

## Assessment and planning policy

- Monolith-first bias
- Every pattern has trade-offs stated
- Hybrid patterns valid
- Reversibility explicit
- Evolution triggers concrete
- No fabricated context

---

## Self-check

```
[] System + team context
[] Patterns evaluated
[] Monolith-first analysis
[] Hybrid assessment
[] Recommendation with trade-offs + escape hatch
[] Evolution roadmap
[] Reversibility stated
[] Diagrams valid
[] No fabricated context
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No context | Interview mode (§7) |
| Microservices without justification | Monolith-first challenge |
| Hybrid without clear boundaries | Recommend `ddd-strategic-modeling` first |
| Pattern preference vs constraints | Surface conflict |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out-of-scope |

---

## Quality checks

- [ ] Context complete
- [ ] Monolith-first considered
- [ ] Per-pattern trade-offs
- [ ] Hybrid assessed
- [ ] Recommendation with escape hatch
- [ ] Evolution triggers if applicable
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Startup, 5 engineers, greenfield**
- Input: Team 5, greenfield SaaS
- Expected: Monolith recommended; modular monolith noted as option if wanting future optionality; evolution roadmap: consider extraction at 15-20 eng or when scale hits X.

**2. Mid-size, 40 engineers, growing e-commerce**
- Input: Team 40, existing monolith strained
- Expected: Modular monolith or service-based recommended; avoid full microservices without ops maturity; event-driven for order-fulfillment subsystem. Hybrid.

**3. Large, 200 engineers, high scale**
- Input: Team 200, 10k RPS peak, independent team ownership
- Expected: Microservices justified by team size + scale + team-ownership model; DDD recommended for service boundaries; event-driven for async workflows.

**4. Serverless-first use case**
- Input: Webhook-handler product with spiky traffic
- Expected: Serverless (FaaS) recommended; cold-start caveat flagged; observability investment required.

**5. CQRS for read-heavy analytics**
- Input: Analytics dashboard over transactional data
- Expected: CQRS for read-model separation; event-sourcing optional; consistency trade-off (eventual reads) accepted.

### Edge cases

**6. Team wants microservices for modern-tech signal**
- Input: Team preference for microservices, no scale justification
- Expected: Monolith-first challenge; present cost + complexity of microservices without benefits; recommend modular monolith as middle ground that preserves future optionality.

**7. Inherited microservices with small team**
- Input: 5-person team inherited 20 microservices
- Expected: Recommend consolidation to modular monolith or service-based; operational mismatch flagged as risk; migration-roadmap guidance.

**8. Hybrid across subsystems**
- Input: E-commerce with catalog + checkout + fulfillment + analytics
- Expected: Modular monolith for catalog + checkout; microservice for fulfillment (high scale); event-driven integration; serverless for webhook handlers; CQRS for analytics read-model.

### Failure cases

**9. No context**
- Input: "Pick an architecture"
- Expected: Interview — "What system, what team, what scale?"

**10. Out of scope**
- Input: "Select pattern + implement it"
- Expected: "Selection only. Implementation is engineering."
