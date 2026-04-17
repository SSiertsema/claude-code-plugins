# Master Data Management — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | master-data-management |
| **Version** | 1.0.0 |
| **Purpose** | Designs MDM — single source of truth for reusable entities (customer / product / vendor / location / employee / organization) used across ≥3 systems with duplication. Selects MDM architecture style: registry (keys + source pointers; federated queries), consolidation (read-only aggregation), coexistence (bi-directional sync), centralized transactional (MDM = authoritative). Defines matching rules (deterministic on keys like email/SSN/VAT; probabilistic fuzzy on name+address+phone with confidence threshold) with auto-merge-above-X / suggest-merge-Y-to-X / flag-below-Y thresholds. Survivorship rules per attribute (most recent / most-trustworthy-source / most-complete / steward decision). Integration patterns (hub-and-spoke / federated / stream-based CDC). Stewardship per domain with resolution SLAs + audit trail. Ops concerns: data latency / identity stability / schema evolution / GDPR right-to-delete propagation. Mermaid architecture diagram with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- Pain from customer-data duplication / inconsistency across systems
- Post-M&A data consolidation
- Compliance-driven single-record requirement
- Analytics quality driven by bad master data

## When not to use
- Operational data model → data modeling skills
- Data governance policy only → `data-governance-policy`
- Classification / dictionary → `data-dictionary-definition`

## Required input
- **Organization + master entities in scope**

## Output contract
Architecture + matching rules + survivorship + integration + stewardship + implementation plan + diagram.

## Failure behavior
- No domain owners → require
- MDM everything → flag overreach
- Custom matching → recommend existing product

## Examples
1. Customer MDM across CRM + billing + support — consolidation style; steward-approved merges; SLA.
2. Product MDM across ERP + e-commerce + partner catalogs — coexistence with SAP / Reltio.
3. Location MDM — lightweight registry style; federated queries.
4. Employee MDM across HRIS + identity + finance — centralized (HRIS as source of truth).
5. Post-M&A — phased: registry first to avoid disruption, consolidation later.
