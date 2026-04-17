# Data Migration Strategy — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | data-migration-strategy |
| **Version** | 1.0.0 |
| **Purpose** | Plans data migration (legacy→new / on-prem→cloud / cloud→cloud / DB swap). Selects from 5 strategies: big-bang (simple, long downtime), phased (per domain/tenant/geo, partial risk), parallel-run (both systems live with comparison, highest safety + 2× cost), strangler-fig (gradual feature-by-feature replacement), CDC + switchover (stream changes live; cutover when caught up; near-zero downtime; complex). Covers 8 phases: source analysis (volume / quality / dependencies), target design (schema mapping), mapping + transformation (field-level + rules), execution plan (batching / parallelism / throttling / dependency order), cutover (window + steps + rollback trigger), validation (count + checksum + spot checks + UAT + reconciliation), rollback (conditions + procedure + time budget), post-migration (decommission + monitoring). Common pitfalls catalog (encoding / time zone / null handling / missing triggers / ID re-keying / historical data). Mermaid timeline + dataflow diagrams with PNG export. |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- Legacy modernization
- Cloud / vendor migration
- DB technology change (Postgres → Cassandra, etc.)
- M&A data consolidation

## When not to use
- Schema design → modeling skills
- DB choice → `database-technology-selection`
- MDM → `master-data-management`

## Required input
- **Source + target + volume + downtime tolerance**

## Output contract
Source/target analysis + mapping + strategy + execution + cutover + validation + rollback + post-migration + diagram.

## Failure behavior
- No source analysis → require first
- No rollback plan → block
- Big-bang for critical → challenge

## Examples
1. Monolith → microservices — strangler fig with feature-by-feature extraction.
2. On-prem Oracle → cloud Postgres — CDC + parallel run + scheduled cutover.
3. Small internal tool — big-bang acceptable (low user impact).
4. E-commerce over weekend — phased by region (US then EU then APAC).
5. Regulated data — extra reconciliation + audit trail + rollback preservation.
