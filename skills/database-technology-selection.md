# Database Technology Selection — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | database-technology-selection |
| **Version** | 1.0.0 |
| **Purpose** | Select DB technology for a given use case. Distinct from `technology-evaluation-matrix` (generic weighted scoring): uses DB-specific criteria (consistency model / query patterns / schema flex / scale envelope / ACID-vs-BASE / latency SLO / ops complexity / cost / ecosystem / backup+DR / multi-region). Evaluates across 12 DB classes: relational (Postgres / MySQL / Oracle), document (MongoDB / Couchbase), wide-column (Cassandra / Scylla), key-value (Redis / DynamoDB KV), graph (Neo4j / Neptune), time-series (InfluxDB / Timescale / Clickhouse), search (Elasticsearch / Meilisearch / Typesense), vector (Pinecone / Weaviate / Qdrant / pgvector), cache (Redis / Memcached), analytical (Snowflake / BigQuery / Redshift / DuckDB), ledger (QLDB / ImmuDB), NewSQL (CockroachDB / YugabyteDB / Spanner). Decision flow: query patterns → class; consistency → filter within class; scale → product within class; ops + cost → final. Embraces polyglot persistence (3–5 DBs typical in production). Per recommendation surfaces won-on / lost-on / alternatives-rejected / reversal conditions. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- New service data-layer choice
- Considering adding a DB for complementary use case (cache / search / analytics)
- Replacing existing DB due to fit gap
- Architecture reviewing per subdomain data needs

## When not to use
- Schema design → `logical-data-modeling` / `physical-data-modeling`
- Generic tech eval → `technology-evaluation-matrix`
- Migration execution → `data-migration-strategy`

## Required input
- **Use case** + **query patterns** (critical)

## Processing
1. Query patterns → DB class
2. Consistency requirements → within-class filter
3. Scale envelope → product within class
4. Ops + cost → final
5. Polyglot considerations
6. Trade-offs + reversal conditions

## Output contract
Class + product + rationale + polyglot notes + trade-offs + reversal + migration plan.

## Failure behavior
- No query patterns → interview
- Fashion-driven choice → challenge
- Over-DB-for-small-team → flag

## Examples
1. B2B SaaS — Postgres primary + Redis cache + Elasticsearch search + Snowflake analytics.
2. IoT telemetry — Timescale or Clickhouse for time-series + aggregates.
3. Social-graph product — Neo4j for traversal + Postgres for user accounts.
4. RAG AI app — pgvector (in Postgres) or Qdrant for embeddings + Postgres primary.
5. Finance ledger — QLDB or append-only Postgres with audit + backup to analytical DB.
