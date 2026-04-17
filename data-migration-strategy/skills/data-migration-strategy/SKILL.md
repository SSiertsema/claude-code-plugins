---
name: data-migration-strategy
description: Plan data migration. Source + target analysis, mapping rules, strategy selection (big-bang / phased / parallel / strangler), cutover plan, rollback, validation, downtime management, CDC.
argument-hint: "[source + target + volume + downtime tolerance]"
---

# Data Migration Strategy

You plan a data migration — from legacy to new system, on-prem to cloud, between clouds, or DB technology swap.

## Core rules

- **Validate before cutover** — every record accounted for
- **Rollback plan mandatory** — before any write-to-target
- **Downtime realistic** — match user tolerance; minimize via phased / parallel approaches
- **CDC when possible** — ongoing sync during migration reduces downtime window
- **Reconciliation after cutover** — count + checksum + spot-check

## Strategies

| Strategy | How | Trade-offs |
|---|---|---|
| **Big bang** | All-at-once cutover | Simple but long downtime, high risk |
| **Phased** | By domain / tenant / geography | Partial risk at each phase; longer total |
| **Parallel run** | Both systems live; compare outputs | Safest; high cost (2× capacity) |
| **Strangler fig** | New system gradually replaces old feature-by-feature | Incremental; longest duration |
| **CDC + switchover** | Stream changes from source to target live; cutover when caught up | Near-zero-downtime; complex |

Choose based on: downtime tolerance × volume × criticality × budget.

## Phases

### 1. Source analysis
- Data volume + growth rate
- Quality (know the rot)
- Dependencies (FKs, semantic links)
- Access patterns during migration

### 2. Target design
- Schema mapping (logical + physical)
- Transformations required
- Data type conversions
- Referential integrity approach

### 3. Mapping + transformation
- Field-level mapping doc
- Transformation rules (format / cleanup / enrichment)
- Data quality fixes (or accept as-is with report)

### 4. Execution plan
- Strategy selection
- Batch size / parallelism
- Dependencies (load parents before children)
- Throttling to avoid source impact

### 5. Cutover
- Pre-cutover checklist
- Cutover window (or zero-downtime path)
- Application config switch
- Monitoring

### 6. Validation
- Row count match
- Checksum / hash match
- Business-rule spot checks
- User acceptance test on critical flows
- Reconciliation report

### 7. Rollback
- Trigger conditions
- Procedure
- Time budget (how long before decision to roll back)
- Data-capture during cutover for rollforward later

### 8. Post-migration
- Decommission old system (when?)
- Monitor target for anomalies
- Support plan for rollback period

## Common pitfalls

- **Character encoding issues** (UTF-8 vs Latin1)
- **Time zone drift** (all timestamps UTC?)
- **Null handling differences**
- **Business logic in triggers not migrated**
- **IDs change** (re-keyed) — referential integrity across systems
- **Historical data gaps** (archive / exclude / migrate)

## Report

```markdown
# Data Migration Strategy: [Source → Target]

## Source + Target Analysis
[Volume / quality / dependencies / schema]

## Mapping + Transformation
[Field-level doc + rules]

## Strategy Selection
[Big-bang / phased / parallel / strangler / CDC + rationale]

## Execution Plan
[Batching + parallelism + dependencies + throttling]

## Cutover Plan
[Window / steps / rollback trigger]

## Validation
[Count / checksum / spot checks / UAT / reconciliation]

## Rollback
[Conditions + procedure + time budget]

## Post-migration
[Decommission timeline + monitoring]

## Pitfalls Addressed
[Per common pitfall]

## Diagram
```

## Failure behavior
- No source analysis → required first
- No rollback plan → block
- Big-bang for critical system → challenge
- mmdc failure → see mixin
