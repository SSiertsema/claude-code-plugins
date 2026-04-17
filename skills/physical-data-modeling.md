# Physical Data Modeling — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | physical-data-modeling |
| **Version** | 1.0.0 |
| **Purpose** | Produces vendor-specific physical schema from logical model + query patterns. Platform-specific for Postgres (JSONB / arrays / GIN / range partitioning), MySQL (InnoDB / limited JSON / coarse partitioning), MongoDB (embed vs reference / single-table / critical sharding key), DynamoDB (single-table / PK+SK / GSI/LSI / query-first), Cassandra (query-first / partition + clustering), BigQuery / Snowflake (columnar / date partitioning / clustering). Covers index strategy (PK / unique / secondary / composite with leftmost-prefix / covering / partial / GIN/GiST/hash), partitioning (range / list / hash with trade-offs), sharding (key choice + irreversibility risk + rebalancing), de-normalization decisions (justified per query pattern + maintenance cost), constraint enforcement (DB-level vs app-level), and emits actual DDL. Query patterns drive decisions — not theoretical optimization. |
| **Primary category** | `generation` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- After logical model, for vendor-specific implementation
- DB migration planning
- Performance-driven schema redesign
- New feature requiring schema change

## When not to use
- Conceptual / logical → earlier skills
- DB vendor choice → `database-technology-selection`
- Data dictionary → `data-dictionary-definition`
- Migration execution → `data-migration-strategy`

## Required input
- **Logical model or domain**
- **Target platform**
- **Query patterns**

## Output contract
Platform + logical-to-physical mapping + indexes + partitioning + sharding + de-normalization + constraints + DDL + migration plan.

## Failure behavior
- No platform → require
- No query patterns → predict + `[Assumed]`
- Over-indexed → recommend cleanup

## Examples
1. Postgres OLTP — tables with JSONB metadata, partitioned by created_at, GIN indexes.
2. DynamoDB single-table — PK+SK design per access pattern.
3. MongoDB document — embed for read-heavy, reference for write-heavy sub-documents.
4. Cassandra time-series — partition by user_id, cluster by timestamp.
5. BigQuery analytics — partition by date, cluster on common filters.
