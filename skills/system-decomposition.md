# System Decomposition — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | system-decomposition |
| **Version** | 1.0.0 |
| **Purpose** | Decomposes a system from its context (C4 Level 1 — see `context-diagramming`) into containers (Level 2 — separately deployable units) and optionally components (Level 3 — internal structure of one container at a time). Works at Simon Brown's C4 L2 + L3. Per container captures: ID, name, type (web app / mobile / desktop / API-service / worker / database / message broker / external dependency / CLI / extension), technology stack, purpose, 3–6 responsibilities, APIs exposed + consumed, owned data stores, deployment target, scaling approach (cross-ref `scalability-modeling`), tenant model, ownership team. Per container relationship: protocol (HTTPS / gRPC / WebSocket / event bus / file / JDBC), purpose, synchronicity, failure mode, rate characteristics. At L3, per component: type (controller / service / repository / adapter / factory / policy), responsibilities, intra-container dependencies, external dependencies, applied pattern. Cross-references quality attributes per container to `scalability-modeling`, `slo-sli-definition`, `performance-budgeting`, `security-requirements-classification`, `data-dictionary-definition`. Avoids code-level detail (L4 out of scope). Mermaid L2 container diagram + L3 component diagrams (one per targeted container) with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `extraction` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Architecture design after context + scope established (post `context-diagramming`)
- Pre-implementation handoff to engineering teams
- Onboarding new engineers with clear container + component map
- System refactor planning — current vs target decomposition
- Audit of deployment complexity (container count, dependencies, external SaaS)

## When not to use

- System boundary / external entities (L1) → `context-diagramming`
- Code-level class / function design (L4) → class diagrams in `class-module-diagramming` (future Phase 5 skill)
- Data flows specifically for privacy → `data-flow-diagramming`
- State machines → `state-machine-diagramming` / `state-transition-mapping`
- Sequence diagrams for interactions → future `sequence-diagramming` (Phase 5)

---

## Required input

| Field | Description |
|---|---|
| **System** | Named system |
| **Target level** | L2 / L3 / L2+L3 |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Context reference** | `context-diagramming` output | None |
| **Known containers / components** | If existing | Elicit |
| **L3 scope container** | Required if L3 targeted | — |
| **Technology choices** | Pre-decided stack | Elicit |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/system-decomposition/` |

## Input schema

```
input:
  required:
    system:
      type: string | document_reference
    target_level:
      type: string
      enum: [L2, L3, L2+L3]
  optional:
    context_reference: document_reference
    known_containers: list[object]
    l3_scope_container: string
    technology_choices: object
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
Collect system + level + context reference.

### Phase 2 — L2 containers
Full per-container spec.

### Phase 3 — Container relationships
Protocol + purpose + synchronicity + failure mode + rate.

### Phase 4 — L3 components (if targeted)
Per target container: component types + responsibilities.

### Phase 5 — L3 component relationships
Dependency direction; flag cycles.

### Phase 6 — Quality attributes
Cross-references to other Phase 3 / 5 skills.

### Phase 7 — Diagrams
L2 container + L3 component per target.

### Phase 8 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 9 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# System Decomposition: [System]

**Date**: [date]
**Level**: [L2 / L3 / L2+L3]

## Scope
[System, level, context reference, platforms]

## Containers (L2)
[Full table]

## Container Relationships
[Table]

## Components (L3 per in-scope container)
[Component tables + relationships]

## Quality Attributes per Container
[Cross-references]

## Diagrams
[L2 + L3]

## Assumptions & Limitations
[Gaps, tech assumptions]
```

### Diagrams

- **L2 container diagram** — Mermaid `flowchart` with system subgraph + external entities outside
- **L3 component diagram per container** — Mermaid `flowchart` with container subgraph

---

## Generation and extraction policy

- Technology explicit at container level
- Every relationship has protocol + purpose
- No L4 code-level details
- L3 scoped to one container
- No fabricated containers

---

## Self-check

```
[] Level declared
[] Per-container complete (technology, purpose, APIs, data, deployment, scaling, ownership)
[] Relationships typed (protocol + purpose + sync + failure + rate)
[] L3 per-container scoped
[] Quality attributes cross-referenced
[] No code-level content
[] Diagrams valid
[] No fabricated containers
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No system | Interview mode (§7) |
| L3 without container scope | Ask which container |
| >15 containers | Group or show in-scope only |
| Container/component mixed | Re-layer |
| Code-level request | Out-of-scope (L4) |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out-of-scope |

---

## Quality checks

- [ ] Containers with technology + purpose + responsibilities
- [ ] Typed relationships
- [ ] L3 scoped per container
- [ ] Quality attributes
- [ ] No L4 details
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. SaaS product L2**
- Input: Multi-tenant SaaS, L2
- Expected: Web app (React/TS) + API (Go) + worker (Python/Celery) + Postgres + Redis + Elasticsearch + external Auth0 + external Stripe. Relationships with protocols labeled. Deployment in Kubernetes cluster.

**2. Mobile app L2**
- Input: iOS + Android product
- Expected: iOS container (Swift) + Android container (Kotlin) + shared API (Node/TS) + Firebase external + Postgres backend.

**3. L3 for API container**
- Input: "Decompose API container at L3"
- Expected: Controllers + services + repositories + event publisher + Stripe adapter + auth middleware. Dependency direction inward. No cycles.

**4. Data pipeline**
- Input: ETL data pipeline
- Expected: Ingestion worker + transformation worker + data warehouse + orchestrator (Airflow) + quality-check service. Relationships emphasize async event flows.

**5. Migration target**
- Input: Decompose target state for monolith → microservices migration
- Expected: Target containers listed + current-state reference; migration-risk notes per container; flag shared-database coupling.

### Edge cases

**6. Monolith**
- Input: Single-container monolith
- Expected: L2 shows one app-container + DB + external services; L3 inside the monolith becomes important — many components; modular structure.

**7. Very distributed**
- Input: 40 microservices
- Expected: Suggest grouping by bounded context (ref `ddd-strategic-modeling`) before decomposing; show logical groups in L2 rather than 40 individual containers.

**8. Hybrid cloud + on-prem**
- Input: Some containers cloud, some on-prem
- Expected: Deployment field per container declares location; cross-location relationships flagged (network / latency / security implications).

### Failure cases

**9. No system**
- Input: "Decompose our system"
- Expected: Interview — "Which system, and L2 / L3 / both?"

**10. Code-level request**
- Input: "Decompose system + show class diagrams"
- Expected: "L2/L3 only. Class-level diagrams are L4 — separate skill (`class-module-diagramming`)."
