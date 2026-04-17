---
name: physical-data-modeling
description: Physical data model — vendor-specific schema with platform types, indexes, partitioning, sharding, de-normalization driven by query patterns, DDL. Platform-specific.
argument-hint: "[logical model + target platform + query patterns]"
---

# Physical Data Modeling

You produce a vendor-specific physical schema: platform types, indexes, partitioning, sharding, de-normalization decisions, and DDL.

## Core rules

- **Platform declared** (Postgres / MySQL / MongoDB / DynamoDB / Cassandra / BigQuery / Snowflake)
- **Query patterns drive indexes + de-normalization** — not theoretical optimization
- **De-normalization justified** — every departure from 3NF has a reason (read pattern / scale / latency)
- **Cost-awareness** — indexes cost writes; partitions cost complexity
- **Migration safety** — schema changes reversible or carefully planned

## Platform-specific considerations

### Postgres
- Rich types (JSONB, arrays, ranges, custom)
- GIN/GiST indexes for JSONB/full-text
- Table partitioning (range / list / hash)
- Vacuum/autovacuum considerations

### MySQL
- InnoDB defaults
- Limited JSON support (use sparingly)
- Partitioning coarse-grained

### MongoDB
- Document design: embed vs reference per access pattern
- Single-table denormalization typical
- Indexes on query paths
- Sharding key critical (cannot change)

### DynamoDB
- Single-table design typical
- Partition key + sort key drive everything
- GSI / LSI for alternate access patterns
- Query-first modeling

### Cassandra
- Query-first
- Partition + clustering keys
- Materialized views / secondary indexes limited

### BigQuery / Snowflake (analytical)
- Columnar
- Partition by date
- Clustering on common filter keys
- Minimal indexes (vs OLTP)

## Index strategy

Per table:
- **Primary key** — implicit clustered index
- **Unique indexes** — for uniqueness + fast lookup
- **Non-unique secondary indexes** — per access pattern
- **Composite indexes** — ordering matters; leftmost-prefix rule
- **Covering indexes** — include columns to avoid table lookups
- **Partial / filtered indexes** — when only subset of rows queried
- **GIN / GiST / Hash** — for JSONB / full-text / equality-only

Rule of thumb: index only for measured query patterns; too many = write-amplification.

## Partitioning

Triggered by table size > threshold (typically 100M+ rows) or regulatory separation:
- **Range** — time-series (created_at)
- **List** — per-region, per-tenant
- **Hash** — when data distribution uneven

Trade-offs:
- Partition pruning speeds queries
- Cross-partition queries slower
- Management overhead (new partitions, retention)

## Sharding

For horizontal scale beyond single-node:
- **Shard key choice** (irreversible in some DBs)
- **Consistent hashing** or range
- **Cross-shard queries** (slow — avoid in hot path)
- **Rebalancing** strategy

## De-normalization

Per de-normalization decision:
- **What** was de-normalized
- **Why** (query pattern, latency SLO, scale)
- **Maintenance cost** (update consistency, migration)
- **Alternative considered**

## Constraint enforcement

| Constraint | DB-level | App-level | Notes |
|---|---|---|---|
| NOT NULL | ✅ | — | Always DB-level |
| UNIQUE | ✅ | — | Always DB-level |
| CHECK | ✅ | ✅ | DB for guarantee; app for UX |
| FK | ✅ / ⚠️ | ✅ | Some DBs (Mongo, DynamoDB) — app-level only |
| Business rules | — | ✅ | App-level (with trigger rarely) |

## DDL output

Emit vendor-specific DDL:

```sql
-- Postgres example
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
  status VARCHAR(32) NOT NULL CHECK (status IN ('pending','paid','shipped','delivered','refunded')),
  total_cents BIGINT NOT NULL CHECK (total_cents >= 0),
  metadata JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
) PARTITION BY RANGE (created_at);

CREATE INDEX idx_orders_customer ON orders (customer_id);
CREATE INDEX idx_orders_status ON orders (status) WHERE status IN ('pending','paid');
CREATE INDEX idx_orders_metadata ON orders USING GIN (metadata);
```

## Report

```markdown
# Physical Data Model: [Domain / Platform]

## Platform + Rationale
[Why this DB for this use case]

## Logical-to-Physical Mapping
[Per logical entity → physical representation]

## Indexes
[Per index: columns / type / use case / cost-benefit]

## Partitioning / Sharding
[Strategy + key choice]

## De-normalization Decisions
[Per decision: what / why / cost]

## Constraints
[Enforcement location per constraint]

## DDL
[SQL / NoSQL schema definitions]

## Migration Plan
[Deployment approach, reversibility]
```

## Failure behavior
- Platform not declared → require
- Query patterns unknown → predict typical; flag as `[Assumed]`
- Over-indexed → recommend cleanup
- Sharding key questionable → flag irreversibility risk
