# DDD Strategic Modeling — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | ddd-strategic-modeling |
| **Version** | 1.0.0 |
| **Purpose** | Applies Domain-Driven Design strategic patterns (Eric Evans) to model a business domain. Distinct from tactical DDD (aggregates / entities / value objects — implementation-level). Identifies subdomains with investment classification (core = differentiation, supporting = necessary-but-not-differentiating, generic = off-the-shelf candidate), bounded contexts (linguistic boundaries within which a single model applies), ubiquitous language per context (glossary with ≥10 terms; cross-context term-meaning differences called out explicitly), and typed context-map relationships using Evans' 9 patterns: shared kernel / customer-supplier / conformist / anti-corruption layer / open host service / published language / separate ways / big ball of mud / partnership. Recommends investment strategy per subdomain (build in-house for core, simple for supporting, buy / adopt for generic). Runs Conway's-Law alignment check comparing bounded contexts to team boundaries; flags misalignments (shared ownership / split teams / orphan contexts). Mermaid context map + subdomain-investment quadrant with PNG export. Feeds `system-decomposition` (often 1 container per bounded context), `architecture-pattern-selection`, `adr-writing`, `build-vs-buy-analysis` per subdomain. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Establishing architecture foundation for a complex domain
- Before microservices decomposition — identify proper service boundaries
- Aligning team structure to architectural boundaries (Conway's Law)
- Input to investment-allocation decisions (where to build deeply vs buy)
- Surfacing integration patterns between internal systems / external vendors

## When not to use

- Tactical DDD (aggregates / entities / value objects / domain events) → future tactical-DDD skill
- UI / UX modeling → Phase 4 skills
- Technology selection → `technology-evaluation-matrix`
- Pattern choice → `architecture-pattern-selection`
- Very simple domains (1–2 bounded contexts) — DDD overhead > benefit

---

## Required input

| Field | Description |
|---|---|
| **Domain / business scope** | Subject |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Scope** | Entire product or subset | Entire |
| **Existing teams** | For Conway-alignment | Elicit |
| **External systems** | For ACL planning | Elicit |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/ddd-strategic-modeling/` |

## Input schema

```
input:
  required:
    domain:
      type: string | document_reference
  optional:
    scope: string
    existing_teams: list[object]
    external_systems: list[string]
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
Collect domain + scope + teams + external systems.

### Phase 2 — Subdomain identification
Core / supporting / generic with rationale.

### Phase 3 — Bounded contexts
Per context: name + linked subdomains + responsibilities + owner + size.

### Phase 4 — Ubiquitous language
Glossary per context + cross-context differences.

### Phase 5 — Context-mapping relationships
9 patterns catalog; per relationship typed.

### Phase 6 — Core investment strategy
Build / buy per subdomain.

### Phase 7 — Conway's Law alignment
Context-to-team check.

### Phase 8 — Diagrams
Context map + subdomain-investment quadrant.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# DDD Strategic Model: [Domain]

**Date**: [date]
**Domain**: [scope]
**Subdomains**: [N]
**Bounded contexts**: [N]

## Scope
[Domain, modeling scope, teams, external systems]

## Subdomains
[Per subdomain: name + type + responsibilities + rationale]

## Bounded Contexts
[Per context: name + linked subdomains + responsibilities + owner + size]

## Ubiquitous Language
[Per-context glossary + cross-context term differences]

## Context Map
[Relationships typed with Evans' patterns + rationale + data format]

## Core Investment Strategy
[Per subdomain: build / buy / simplify + team allocation]

## Conway's Law Alignment
[Context-to-team check + adjustments]

## Diagrams
[Context map + subdomain investment]

## Assumptions & Limitations
[Domain assumptions, team-evolution caveats]
```

### Diagrams

- **Context map** — Mermaid `flowchart` with subdomain subgraphs + typed relationships
- **Subdomain investment** — Mermaid `quadrantChart`

---

## Generation and planning policy

- Subdomain classification justified
- Glossary per context required
- Relationships typed with standard patterns
- Conway-alignment checked
- Investment strategy tied to core/supporting/generic
- No fabricated domains

---

## Self-check

```
[] Subdomains typed + rationale
[] Contexts with owner + size
[] Glossary ≥10 terms per context
[] Cross-context term differences
[] Relationships typed
[] Investment strategy
[] Conway alignment
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No domain | Interview mode (§7) |
| >3 "core" subdomains | Challenge |
| Missing glossary | Require ≥10 terms/context |
| Shared-kernel overuse | Surface coordination cost |
| Team-context mismatch | Recommend realignment |
| mmdc failure | See `diagram-rendering` mixin |
| Tactical-DDD request | Out-of-scope |

---

## Quality checks

- [ ] Subdomains classified
- [ ] Contexts with ownership
- [ ] Per-context glossary
- [ ] Relationship patterns typed
- [ ] Investment strategy
- [ ] Conway check

---

## Examples

### Normal cases

**1. E-commerce platform**
- Input: DTC e-commerce
- Expected: 6 subdomains — Pricing (core), Recommendations (core), Catalog (supporting), Checkout (supporting), Fulfillment (supporting), Auth (generic). 6 bounded contexts. Relationships: Catalog → Pricing via Published language; Fulfillment uses ACL for shipping-partner integration.

**2. SaaS productivity tool**
- Input: B2B project-management SaaS
- Expected: Core = Planning + Collaboration; Supporting = User-management + Integrations + Notifications; Generic = Auth + Payments. Context-map shows Integrations with ACL per external system.

**3. Fintech payments platform**
- Input: Payments API
- Expected: Core = Transaction-processing + Risk-scoring; Supporting = KYC + Customer-data + Reporting; Generic = Auth + Email. Strong Conway alignment with dedicated teams per context; compliance-driven boundary integrity.

**4. Healthcare platform**
- Input: Telehealth
- Expected: Core = Clinical-workflows (differentiation); Supporting = Scheduling + Billing; Generic = Email + Auth. Regulated constraints drive context integrity (no PHI leakage across contexts without ACL).

**5. Legacy modernization**
- Input: Large legacy monolith with unclear boundaries
- Expected: Existing system = Big-Ball-of-Mud; target contexts identified; migration strategy: wrap BBM with ACL; extract core subdomains first.

### Edge cases

**6. Over-labeled "core" subdomains**
- Input: User says 8 subdomains are all core
- Expected: Challenge; 8 core = no differentiation focus; force-rank and accept max 3 as core; remaining are supporting.

**7. Team boundaries misaligned**
- Input: 12 contexts but only 3 teams
- Expected: Flag over-context-fragmentation OR under-staffing; recommend consolidating or restructuring teams; Conway warning.

**8. External system tight coupling**
- Input: Existing conformist relationship with unstable vendor API
- Expected: Recommend anti-corruption layer introduction; estimate cost vs long-term benefit; phased migration.

### Failure cases

**9. No domain**
- Input: "Do DDD modeling"
- Expected: Interview — "Which business domain?"

**10. Out of scope**
- Input: "DDD + design aggregates"
- Expected: "Strategic only. Tactical DDD (aggregates / entities / value objects) is a separate skill."
