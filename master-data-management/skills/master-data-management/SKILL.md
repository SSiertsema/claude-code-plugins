---
name: master-data-management
description: Design Master Data Management. Identifies master entities, chooses MDM architecture, designs matching / merging / survivorship rules, defines stewardship + governance, integrates with source systems.
argument-hint: "[org + master entities scope]"
---

# Master Data Management

You design MDM: a single source of truth for the most-critical reusable entities (customer, product, vendor, location, employee).

## Core rules

- **Master entities are reused across systems** — not per-system snapshots
- **Golden record per entity** — authoritative, reconciled from multiple sources
- **Matching + merging rules** — deterministic where possible; probabilistic where not
- **Survivorship** — which attribute from which source wins
- **Stewardship** — someone owns resolution of conflicts

## Master entity candidates

| Entity | Common masters |
|---|---|
| Customer | CRM, billing, support — consolidate |
| Product | Catalog, ERP, procurement |
| Location | Address book, ERP, field ops |
| Employee | HRIS, identity, finance |
| Vendor | Procurement, finance |
| Account / Organization | CRM hierarchy |

Not all entities need MDM — only those used across ≥3 systems with duplication / inconsistency.

## MDM architecture styles

| Style | How it works |
|---|---|
| **Registry** | MDM stores only keys + source pointers; queries federate |
| **Consolidation** | MDM aggregates data read-only from sources |
| **Coexistence** | MDM + sources read-write; bi-directional sync |
| **Centralized (transactional)** | MDM is the source of truth; other systems reference |

Registry = lightest; centralized = strongest but biggest change.

## Matching rules

Per master entity:

- **Deterministic**: exact match on key (email, SSN, VAT number)
- **Probabilistic**: fuzzy match on name + address + phone with confidence score
- **Weighted attributes**: some attributes more indicative than others

Threshold: auto-merge above X; suggest merge between Y–X; flag for steward below Y.

## Survivorship rules

When attributes conflict across sources, which wins:

- **Most recent** — timestamp-based
- **Most trustworthy source** — per attribute (billing address from billing system)
- **Most complete** — whoever has data when other is blank
- **Steward decision** — manual resolution

Document rules per attribute.

## Integration patterns

- **Hub-and-spoke**: MDM is hub; spokes are source systems
- **Federated**: no central store; virtual integration via queries
- **Stream-based**: CDC (change data capture) from sources → MDM

## Stewardship

- **Per-domain steward** — owns conflict resolution
- **SLA on resolution** — high-priority within 24h
- **Audit trail** — every merge / unmerge logged

## Ops concerns

- **Data latency** — eventual consistency trade-off
- **Identity stability** — master IDs should be stable; unmerge is painful
- **Schema evolution** — as attributes added / changed
- **Compliance** — GDPR right-to-delete propagates to masters

## Report

```markdown
# Master Data Management: [Org]

## Scope
[Master entities selected + sources]

## Architecture Style
[Registry / consolidation / coexistence / centralized + rationale]

## Matching Rules
[Per entity: deterministic + probabilistic + thresholds]

## Survivorship Rules
[Per attribute]

## Integration
[Hub-spoke / federated / stream + pattern per source]

## Stewardship
[Per-domain owner + SLA]

## Implementation Plan
[Phased + quick wins]

## Data-quality Monitoring
[SLAs post-MDM]

## Diagram
```

## Failure behavior
- No domain owners → require before implementation
- "MDM everything" overreach → flag; start with 1–2 entities
- Custom matching algorithm proposed → recommend existing MDM product (Reltio / Informatica / SAP / Profisee)
- mmdc failure → see mixin
