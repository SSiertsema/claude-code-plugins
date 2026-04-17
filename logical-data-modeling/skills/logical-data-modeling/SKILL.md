---
name: logical-data-modeling
description: Logical data model — technology-agnostic detail with normalized entities, attributes, data types, keys (PK/FK/natural), constraints, cardinality, referential integrity. Applies normalization 1NF-3NF. Between conceptual and physical.
argument-hint: "[conceptual model or domain + normalization target]"
---

# Logical Data Modeling

You produce a logical data model — normalized, detailed, but technology-agnostic. Between conceptual (business) and physical (DB-specific).

## Core rules

- **Normalization target**: 3NF default (most practical); 2NF acceptable for certain analytical use cases
- **Generic types**: use `string`, `integer`, `decimal(p,s)`, `boolean`, `date`, `timestamp`, `binary`, `text` — not vendor-specific
- **Keys explicit**: PK / FK / natural / surrogate
- **Constraints specified**: NOT NULL, UNIQUE, CHECK
- **Referential integrity**: CASCADE / RESTRICT / SET NULL / NO ACTION per FK

## Normalization

| Form | Rule |
|---|---|
| 1NF | Atomic values, no repeating groups |
| 2NF | 1NF + no partial dependencies on composite key |
| 3NF | 2NF + no transitive dependencies |
| BCNF | 3NF + every determinant is a candidate key (stricter) |

Default 3NF. De-normalize only in physical model per query pattern.

## Per entity

| Field | Description |
|---|---|
| **Name** | Entity name |
| **Description** | Purpose |
| **Attributes** | Table: name / type / length / nullable / default / constraint |
| **Primary key** | Natural or surrogate |
| **Alternate keys** | Other unique constraints |
| **Foreign keys** | To other entities with cascade rule |
| **Indexes hinted** (for physical) | Expected access patterns |

## Per relationship

| Field | Description |
|---|---|
| **Name** | Relationship name |
| **Type** | Identifying / non-identifying / many-to-many |
| **Cardinality** | 1:1 / 1:N / M:N with min/max |
| **FK location** | Which side holds the FK |
| **Cascade** | ON DELETE / ON UPDATE behavior |

M:N relationships resolved via junction entities in logical model.

## Diagram

Mermaid ERD with attributes + keys.

## Report

```markdown
# Logical Data Model: [Domain]

## Scope
[Conceptual reference, normalization target]

## Entities
[Per entity: attributes + keys + constraints]

## Relationships
[Typed with cardinality + FK + cascade]

## Normalization Verification
[3NF checks per entity]

## Referential Integrity Rules
[Cascade decisions per FK]

## Access Pattern Hints
[For physical-model input]

## ERD
```

## Failure behavior
- Vendor-specific types mixed in → strip to generic
- Un-normalized → apply normalization
- No conceptual reference → light conceptual first
- mmdc failure → see mixin
