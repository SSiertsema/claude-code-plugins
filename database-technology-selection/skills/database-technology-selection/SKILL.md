---
name: database-technology-selection
description: Select DB technology for a use case. Evaluates DB classes (relational / document / wide-column / key-value / graph / time-series / search / vector / cache / analytical / ledger / newSQL) against consistency / scale / query patterns / schema flex / ops / cost / ecosystem.
argument-hint: "[use case + data shape + scale + query patterns]"
---

# Database Technology Selection

You select the right DB class + specific product for a use case. Distinct from `technology-evaluation-matrix` (generic): this is DB-specific with DB-specific criteria.

## Core rules

- **Multiple DBs is normal** — polyglot persistence for different needs
- **Start with query patterns** — reads + writes drive choice
- **Consistency model explicit** — strong / eventual / per-aggregate
- **Scale envelope realistic** — what's the actual projected load
- **Operational complexity counts** — who runs it, managed vs self-hosted

## DB class catalog

| Class | Best for | Examples |
|---|---|---|
| **Relational / RDBMS** | Transactions, joins, structured data, SQL ecosystem | Postgres, MySQL, SQL Server, Oracle |
| **Document** | Schema flexibility, nested aggregates | MongoDB, Couchbase, DynamoDB (document-mode) |
| **Wide-column** | Time-series / logs / massive-write | Cassandra, ScyllaDB, HBase, BigTable |
| **Key-value** | Simple lookups, cache, session | Redis, Memcached, DynamoDB (KV-mode), Riak |
| **Graph** | Deeply-connected data, traversal queries | Neo4j, JanusGraph, Amazon Neptune |
| **Time-series** | Metrics, IoT, monitoring | InfluxDB, TimescaleDB, Prometheus, Clickhouse |
| **Search** | Full-text, faceted search, log analysis | Elasticsearch, OpenSearch, Typesense, Meilisearch |
| **Vector** | Embeddings, similarity search, RAG | Pinecone, Weaviate, Qdrant, pgvector (Postgres ext) |
| **Cache (in-memory)** | Speed layer | Redis, Memcached |
| **Analytical / OLAP** | Reporting, aggregations over large data | Snowflake, BigQuery, Redshift, Clickhouse, DuckDB |
| **Ledger / immutable** | Audit trail, financial | QLDB, ImmuDB, blockchain |
| **NewSQL** | SQL ecosystem + horizontal scale | CockroachDB, YugabyteDB, Spanner, TiDB |

## Selection criteria (DB-specific)

| Criterion | What it captures |
|---|---|
| **Consistency model** | Strong / eventual / per-aggregate / linearizable |
| **Query patterns** | Read-heavy / write-heavy / analytical / transactional / search / graph traversal |
| **Schema flex** | Fixed / evolving / document / schemaless |
| **Scale envelope** | Current + projected data volume + QPS |
| **ACID vs BASE** | Transaction needs |
| **Latency SLO** | p99 target |
| **Ops complexity** | Self-hosted / managed service; team familiarity |
| **Cost per GB / per request** | At projected scale |
| **Ecosystem / tooling** | Drivers, migrations, backup, monitoring |
| **Backup + DR** | RPO / RTO achievable |
| **Multi-region** | If needed |

## Decision flow

1. **Query patterns → class**: what are you querying and how?
2. **Consistency → filter within class**: what consistency is acceptable?
3. **Scale → product within class**: single-node vs distributed?
4. **Ops + cost → final**: what can team run + afford?

## Polyglot persistence

Typical production uses 3–5 DBs:
- Primary OLTP (Postgres)
- Cache (Redis)
- Search (Elasticsearch)
- Analytics (Snowflake)
- Optional: time-series, graph, vector per domain need

Don't treat it as monolithic choice.

## Trade-offs per class

Per recommendation, surface:
- **Won on**: criteria that favor this class
- **Lost on**: criteria where it's weak
- **Alternatives considered**: other classes/products rejected and why
- **Reversal conditions**: triggers to revisit

## Report

```markdown
# Database Technology Selection: [Use case]

## Scope
[Use case + data shape + scale + query patterns + consistency needs]

## DB Class Decision
[Class + rationale from query patterns]

## Product Within Class
[Specific product + rationale]

## Polyglot Considerations
[Other DBs for complementary needs]

## Trade-offs
[Won on / lost on / alternatives]

## Reversal Conditions
[Triggers]

## Migration / Adoption Plan
[If replacing existing DB]
```

## Failure behavior
- Generic "pick a DB" without query patterns → interview
- "Microservices + one DB per service" pushed for small team → flag overhead
- DB chosen for cool-factor not fit → challenge
- mmdc failure → see mixin
