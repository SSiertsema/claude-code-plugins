# Conceptual Data Modeling — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | conceptual-data-modeling |
| **Version** | 1.0.0 |
| **Purpose** | Produces high-level conceptual data model — business-level entities + relationships + rules in domain language, independent of technology and normalization. First of three modeling layers (conceptual → logical → physical). Per entity: definition, business identity (not FK), 3–5 key attributes, invariants. Per relationship: cardinality (1:1 / 1:N / M:N), role name, optionality, business rule. Often aligned with bounded contexts from `ddd-strategic-modeling`. Mermaid ERD with PNG export. |
| **Primary category** | `generation` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- Early domain design
- Post-DDD strategic modeling
- Pre-physical-DB design
- Cross-team alignment on what entities exist

## When not to use
- Physical DB schema → `physical-data-modeling`
- Data dictionary with fields → `data-dictionary-definition`
- DB tech choice → `database-technology-selection`

## Required input
- **Domain** + **key entities** (or elicit)

## Output contract
Entities + relationships + business rules + ERD.

## Failure behavior
- Technical details → strip
- No domain → interview

## Examples
1. E-commerce conceptual — Customer, Order, Product, Payment, Shipment with relationships.
2. Healthcare — Patient, Appointment, Diagnosis, Prescription with compliance-driven rules.
3. SaaS — Tenant, User, Resource, Permission reflecting bounded contexts.
4. Content platform — Author, Article, Comment, Tag with many-to-many relationships.
5. Financial ledger — Account, Transaction, Balance with immutability rules.
