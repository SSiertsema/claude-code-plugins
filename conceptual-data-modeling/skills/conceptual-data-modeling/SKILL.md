---
name: conceptual-data-modeling
description: High-level conceptual data model — business entities + relationships in domain language. No technology or normalization concerns. Precedes logical + physical models.
argument-hint: "[domain + key entities]"
---

# Conceptual Data Modeling

You produce a high-level conceptual data model — business-level entities, relationships, and key rules — in domain language. First of three modeling layers: conceptual → logical → physical.

## Core rules

- **Business language, not technical** — no columns, keys, types, indexes
- **Entities from the domain** — often aligned with bounded contexts (`ddd-strategic-modeling`)
- **Relationships cardinal** — 1:1, 1:N, M:N with meaning
- **Key business rules captured** — "customer must have verified email before order"
- **Independent of technology** — same conceptual model could run on SQL, NoSQL, graph

## Output per entity

| Field | Description |
|---|---|
| **Name** | Domain term |
| **Definition** | 1–2 sentences |
| **Identity** | What makes it unique (business-wise, not FK) |
| **Key attributes** | 3–5 most-important — no exhaustive list |
| **Business rules** | Invariants |

## Output per relationship

| Field | Description |
|---|---|
| **From → To** | Entities |
| **Cardinality** | 1:1 / 1:N / M:N |
| **Role name** | What this means ("customer places order") |
| **Optionality** | Required / optional |
| **Business rule** | Any conditions |

## Diagram

Mermaid ERD.

## Report

```markdown
# Conceptual Data Model: [Domain]

## Scope
[Domain, bounded context reference]

## Entities
[Per entity: name + definition + identity + key attributes + rules]

## Relationships
[Typed with cardinality + optionality + role]

## Business Rules
[Cross-entity invariants]

## ERD
[Mermaid]
```

## Failure behavior
- Mixed in technical details → strip to domain
- No domain context → interview
- mmdc failure → see mixin
