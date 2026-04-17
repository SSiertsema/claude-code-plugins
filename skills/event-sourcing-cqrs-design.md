# Event Sourcing + CQRS Design — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | event-sourcing-cqrs-design |
| **Version** | 1.0.0 |
| **Purpose** | Designs event sourcing (state-as-append-only-log) and/or CQRS (separate command + query models). Two independent patterns, often combined. ES fit: audit requirements / temporal queries / complex domain logic. CQRS alone fit: different read vs write models optimal. Core ES elements: events as past-tense facts (immutable, one-aggregate-per-stream, append-only), aggregates as consistency boundaries with events grouped + ordered by sequence, event store selection (EventStoreDB purpose-built / Kafka log-based / Postgres simpler / Axon Server JVM / DynamoDB cloud-native), event schema (type.v1 + aggregate ID + sequence + timestamp + data + metadata). CQRS: command side validates + produces; query side reads projections; projections consume events or change-log, rebuildable from scratch. Consistency strongly within aggregate, eventually across. Snapshotting (every N events or time-based) for rehydration speed. Versioning via versioned event types + upcasting without modifying old events. Replay for rebuilding views or temporal queries. GDPR compliance in immutable stores via crypto-erasure, redaction events, separation of PII, or retention. Mermaid command/query/event flow diagram. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- Complex domain with audit / temporal requirements
- Read-write asymmetry justifying CQRS
- After DDD strategic modeling identifies event-centric aggregates
- Regulated domain requiring complete audit trail

## When not to use
- Simple CRUD
- Small team without distributed-systems expertise
- Strong consistency across aggregates required

## Required input
- **Domain + ES scope + CQRS scope**

## Output contract
Event store + aggregates + schemas + command model + projections + consistency + snapshotting + versioning + replay + GDPR + monitoring + diagram.

## Failure behavior
- ES for CRUD → challenge
- No snapshotting → recommend
- GDPR ignored → require strategy

## Examples
1. Banking ledger — ES for immutability + audit; CQRS for reporting projections.
2. E-commerce order lifecycle — ES for order stream; projections for dashboards.
3. Collaboration tool — ES per document for undo/redo + real-time; CQRS for listings.
4. Healthcare records — ES for audit + temporal queries (what did we know on date X).
5. CQRS-only analytics — high read / write asymmetry without full ES overhead.
