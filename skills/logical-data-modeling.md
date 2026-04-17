# Logical Data Modeling — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | logical-data-modeling |
| **Version** | 1.0.0 |
| **Purpose** | Produces logical data model — detailed but technology-agnostic. Between conceptual (business) and physical (vendor-specific). Applies normalization (3NF default; BCNF stricter; 2NF acceptable for analytical). Per entity: attributes with generic types (string / integer / decimal / boolean / date / timestamp / binary / text), nullable, default, constraints (NOT NULL / UNIQUE / CHECK); primary key (natural or surrogate); alternate keys; foreign keys with cascade behavior (CASCADE / RESTRICT / SET NULL / NO ACTION); index hints for physical modeling. Per relationship: type (identifying / non-identifying / M:N), cardinality with min/max, FK location, cascade decisions. M:N relationships resolved via junction entities. Mermaid ERD with attributes + keys. |
| **Primary category** | `generation` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- After conceptual model, before physical
- Standardized detail for multi-DB portability
- Handoff to DB engineer for vendor-specific design

## When not to use
- Business-level only → `conceptual-data-modeling`
- Vendor-specific schema → `physical-data-modeling`
- Field catalog across systems → `data-dictionary-definition`

## Required input
- **Domain** or **conceptual model reference**

## Output contract
Normalized entities + typed attributes + keys + constraints + relationships + cascade + ERD.

## Failure behavior
- Vendor types → strip to generic
- Un-normalized → apply
- No conceptual → light conceptual first

## Examples
1. E-commerce 3NF — Customer, Order, OrderLine, Product, Inventory, Payment.
2. Audit-heavy — every entity has created_at/updated_at/deleted_at/version with constraints.
3. Multi-tenant — tenant_id on every FK with enforced referential integrity.
4. M:N resolved — User × Role via UserRole junction table.
5. Versioned records — historical tables with effective_from/effective_to.
