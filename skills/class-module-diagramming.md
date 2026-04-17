# Class + Module Diagramming — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | class-module-diagramming |
| **Version** | 1.0.0 |
| **Purpose** | Produces structural UML diagrams (class / interface / enum / package / module) using Mermaid. Enforces one-purpose-per-diagram: domain model, port/adapter layout, hierarchy, or module structure — never all at once. Elements with explicit visibility (`+` public, `-` private, `#` protected, `~` package), stereotypes for DDD context (`<<aggregate-root>>`, `<<value-object>>`, `<<entity>>`, `<<domain-service>>`, `<<repository>>`, `<<port>>`, `<<adapter>>`, `<<application>>`). Relationships correctly distinguished: inheritance (`--|>`), implementation (`..|>`), composition strong-whole-part (`*--`), aggregation weak-whole-part (`o--`), association (`--`), dependency uses-a (`..>`). Multiplicities noted where non-obvious. Package / module views use Mermaid `graph` with subgraphs (classDiagram has limited package syntax), encoding layer rules (only downward) and bounded-context rules (cross via published contract). Omit trivial members (framework bases, getters/setters, DTOs without behavior, internal helpers). Mark existing-code approximations with `[approximate]`. Optional PNG export via `diagram-rendering` mixin. |
| **Primary category** | `generation` |
| **Secondary category** | `transformation` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Domain model documentation
- Port / adapter layer diagram
- Inheritance / substitutability analysis
- Module / package-structure view
- Refactor target illustration

## When not to use

- Request / event flows → `sequence-diagramming`
- Component context → `component-design-documentation`
- BPMN / business process → `business-process-modeling`
- Entity-relationship (data schema) → `conceptual-data-modeling`

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Domain / module / component |
| **Scope** | What to include / exclude |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Purpose** | Domain / layer / module / hierarchy | Asked |
| **Audience** | Architects / devs / reviewers | Asked |
| **Source** | New / existing / refactor | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/class-diagrams/[subject]/` |

## Input schema

```
input:
  required:
    subject: string
    scope: string
  optional:
    purpose:
      type: string
      enum: [domain-model, layer, module, hierarchy]
    audience: string
    source:
      type: string
      enum: [new, existing, refactor]
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
Subject, purpose, scope, audience, source.

### Phase 2 — Element types
Class / interface / abstract / enum / annotation / package.

### Phase 3 — Members
Visibility + attributes + methods.

### Phase 4 — Relationships
Inheritance / implementation / composition / aggregation / association / dependency.

### Phase 5 — Domain model diagram
If purpose is domain.

### Phase 6 — Layer / ports-adapters diagram
If purpose is layer.

### Phase 7 — Hierarchy diagram
If purpose is hierarchy.

### Phase 8 — Package / module diagram
If purpose is module; `graph` syntax.

### Phase 9 — Show / omit guidance
Keep focused.

### Phase 10 — Consistency with code
Mark approximations.

### Phase 11 — Diagrams
Multiple small.

### Phase 12 — Diagram rendering
Per mixin.

### Phase 13 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Class + Module Diagrams: [Subject]

**Date**: [date]
**Purpose**: [...]
**Scope**: [...]

## Domain Model
## Layer / Ports-Adapters
## Module / Package Structure
## Relationships & Multiplicities
## Assumptions & Limitations
```

### Diagrams
- **Domain model / layer / hierarchy** — Mermaid `classDiagram`
- **Package / module** — Mermaid `graph TD` with subgraphs

---

## Assessment and planning policy

- One purpose per diagram
- Visibility + stereotype + multiplicity
- Relationships distinct
- Trivial members omitted
- Stale diagrams removed
- No fabricated members

---

## Self-check

```
[] One purpose per diagram
[] Visibility per member
[] Relationships distinct
[] Multiplicities where non-obvious
[] Stereotypes where helpful
[] Trivial members omitted
[] Module boundaries clear
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject / scope | Interview mode (§7) |
| Diagram doing too much | Split |
| Composition vs aggregation confused | Ask lifetime binding |
| Implementation as inheritance | Correct |
| Package as classDiagram | Switch to `graph` |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] Diagram purpose explicit
- [ ] Visibility markers correct
- [ ] Composition vs aggregation intentional
- [ ] Multiplicity noted where non-obvious
- [ ] Stereotypes used consistently
- [ ] Renders without Mermaid errors

---

## Examples

### Normal cases

**1. Orders domain model**
- Input: Aggregate + value objects + repo port
- Expected: One diagram with stereotypes, composition for Order—OrderLine, implementation for adapter

**2. Ports + adapters layer**
- Input: Clean-architecture layout
- Expected: Application vs port vs adapter; dependency arrows; trivial framework omitted

**3. Inheritance hierarchy for UI controls**
- Input: Abstract Control with Button / Input / Checkbox subclasses
- Expected: Shallow hierarchy with `--|>`; shared methods at base

**4. Module layout for monorepo**
- Input: 4 packages + dependency rules
- Expected: `graph` with subgraphs; rule comment: dependencies only downward

**5. DDD bounded contexts**
- Input: Orders + Payments + Fulfilment
- Expected: Context diagram as packages; published-language events as dashed edges

### Edge cases

**6. Large aggregate with 20+ value objects**
- Expected: Split into primary + auxiliary diagrams; keep root diagram focused

**7. Legacy code with unclear boundaries**
- Input: Tangled modules
- Expected: Mark `[approximate]`; show current + target diagrams

**8. Generics / templates**
- Input: `Repository<T>` generic
- Expected: Use `~T~` syntax; note parameterization

### Failure cases

**9. No subject**
- Input: "Draw me a class diagram"
- Expected: Interview — subject + scope + purpose

**10. Request for flow**
- Input: "Diagram the order flow"
- Expected: Redirect to `sequence-diagramming`
