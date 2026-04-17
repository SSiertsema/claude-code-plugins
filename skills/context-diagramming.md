# Context Diagramming — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | context-diagramming |
| **Version** | 1.0.0 |
| **Purpose** | Produces a system context diagram — the highest-level view of a system, showing the system as a single opaque box surrounded by external entities (persons / user groups / software systems / organizations) with labeled data and interaction flows. Defines in-scope and out-of-scope explicitly. Supports three styles: `C4` (C4 model Level 1 system context — default), `classic` (traditional textbook context diagram), and `DFD-Level-0` (data flow diagram level 0, emphasizing data movement). Per external entity: name, type, role, description (C4), technology (C4), classification rationale. Per flow: from-to direction, purpose, type (interaction / data / notification / control / payment / ...), optional protocol / channel / frequency / data, direction (in / out / both). Surfaces constraints driving the boundary (regulatory, organizational, technical, business). Resists decomposing into internals — those belong in future C4 Level 2 / 3 skills. Mermaid flowchart diagrams with optional PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `extraction` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Early architecture design: establish system boundary before internals
- Scope clarification for stakeholders / procurement / partners
- Pre-development alignment on what's part of "our system" vs external
- Handoff to architecture team (feeds C4 Level 2 container diagram next)
- Regulatory / compliance discussions — scope of audit, PII flows

## When not to use

- System internals / component decomposition → future C4 modeling skills (Phase 5)
- Privacy-focused data flow mapping → `data-flow-diagramming`
- UI-level task flow → `user-flow-diagramming`
- Business process → `business-process-modeling`
- Integration architecture (detailed protocols) → future integration design skill (Phase 5)

---

## Required input

| Field | Description |
|---|---|
| **System name** | Named system |
| **System purpose** | One sentence |
| **External entities** | ≥2, or elicit |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Known flows** | From prior docs | Elicit |
| **Style** | C4 / classic / DFD-Level-0 | C4 |
| **Constraints** | Regulatory / org / technical / business | Surface during setup |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/context-diagramming/` |

## Input schema

```
input:
  required:
    system_name:
      type: string
    system_purpose:
      type: string
  optional:
    external_entities: list[object]
    flows: list[object]
    style:
      type: string
      enum: [C4, classic, DFD-Level-0]
      default: C4
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
Collect system + purpose + style.

### Phase 2 — Entity classification
Type + role + (C4) description + technology.

### Phase 3 — Flow specification
Direction + purpose + type + protocol + data.

### Phase 4 — Scope statement
In-scope capabilities + out-of-scope entities with reasons.

### Phase 5 — Constraints & assumptions
Regulatory / org / technical / business drivers.

### Phase 6 — Style conventions
C4 vs classic vs DFD.

### Phase 7 — Diagram
Mermaid flowchart per style.

### Phase 8 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 9 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Context Diagram: [System]

**Date**: [date]
**System**: [name]
**Purpose**: [sentence]
**Style**: [style]

## Scope
[System, purpose, style]

## External Entities
[Table: name, type, role, description, technology]

## Flows
[Table: from → to, purpose, type, protocol, frequency, data, direction]

## Scope Statement
### In scope
[Capabilities within system box]

### Out of scope
[External entities + reason]

## Constraints & Assumptions
[Regulatory / org / technical / business]

## Diagram
[Mermaid flowchart]

## Assumptions & Limitations
[`[Assumed]` items, gaps]
```

### Diagrams

- **Context diagram** — Mermaid `flowchart` with central system + surrounding entities

---

## Generation and extraction policy

- One system per diagram
- Every entity typed
- Every flow has purpose
- In/out of scope explicit
- No internal details
- No fabricated entities

---

## Self-check

```
[] Single system under focus
[] One-sentence purpose
[] Style declared
[] ≥2 entities typed
[] Per-flow: direction + purpose + type
[] In/out of scope explicit
[] Constraints surfaced
[] No internal details
[] Diagram valid
[] No fabricated entities
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No system | Interview mode (§7) |
| <2 external entities | Ask |
| Internal component as "external" | Reclassify |
| Many similar flows | Consolidate |
| Scope ambiguity | Force explicit placement |
| mmdc failure | See `diagram-rendering` mixin |
| Decomposition request | Out-of-scope |

---

## Quality checks

- [ ] Single system
- [ ] Per-entity type + role
- [ ] Per-flow purpose + direction
- [ ] In/out scope
- [ ] Constraints
- [ ] Diagram valid

---

## Examples

### Normal cases

**1. E-commerce platform**
- Input: DTC e-commerce system
- Expected: External entities — customers (person), admin (person), payment gateway (system), email service (system), analytics (system), warehouse system (external). Flows labeled per purpose. In scope: storefront + order management; out: payment processing (PCI scope externalized), email delivery.

**2. B2B SaaS (C4 style)**
- Input: Multi-tenant SaaS
- Expected: Customers (various sub-roles), admin, SSO provider, billing system, analytics, CRM. C4 annotations per entity (description + technology). Scope clarifies multi-tenant boundary.

**3. Internal tool**
- Input: Internal HR system
- Expected: Employees (users), HR admin (admin), payroll system (external), identity provider (SSO), email service. Clear internal-to-org vs external-to-system distinction.

**4. Integration-heavy system**
- Input: System with 6 external integrations
- Expected: Each integration shown with protocol + direction + purpose; scope note: integrations are external systems, not owned.

**5. Regulated system**
- Input: Healthcare platform
- Expected: Patients + clinicians + health records exchange + payment processor + regulator (as organization). Constraints: HIPAA BAAs with processors, data residency. In/out of scope strictly.

### Edge cases

**6. Internal microservice within a larger architecture**
- Input: Single microservice; many consumers are other internal services
- Expected: Ask whether scope = one service (showing other services as external) OR wider product (different diagram). Context diagrams still work at any system-boundary level.

**7. Very narrow system**
- Input: A simple CLI tool
- Expected: Single user + optionally filesystem + optionally remote API; very few entities; honest output.

**8. System with user roles as separate entities**
- Input: Product with 5 distinct user roles
- Expected: Consolidate into user groups if interactions are similar; show separately if interactions differ significantly.

### Failure cases

**9. No system**
- Input: "Make a context diagram"
- Expected: Interview — "Which system, and what's its one-sentence purpose?"

**10. Out of scope**
- Input: "Context diagram + decompose into components"
- Expected: "Context diagram is Level 1. Decomposition is future C4 Level 2 / 3 skill. I can produce the context; container / component comes next."
