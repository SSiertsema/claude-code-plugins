---
name: disaster-recovery-planning
description: Plan DR per service. RPO + RTO per criticality, strategy (backup-restore / pilot-light / warm-standby / hot-standby / multi-region active-active), backup policy, failover runbook, DR drills, compliance alignment.
argument-hint: "[services + criticality + budget + compliance]"
---

# Disaster Recovery Planning

You plan DR: what happens when the primary site / region / cloud fails.

## Core rules

- **Per-service RPO + RTO** — not one-size-fits-all
- **Drilled or it doesn't work** — untested DR is theater
- **Backups verified** — restore drills, not just backup jobs
- **Compliance-aware** — regulated industries often mandate DR testing

## RPO + RTO

| Term | Meaning |
|---|---|
| **RPO** (Recovery Point Objective) | Maximum acceptable data loss (time between last backup and failure) |
| **RTO** (Recovery Time Objective) | Maximum acceptable downtime (time from failure to restoration) |

Per service, declare both. Cost scales with tighter RPO / RTO.

## DR strategies (by cost + speed)

| Strategy | RPO | RTO | Cost | How |
|---|---|---|---|---|
| **Backup + restore** | Hours | Days | Low | Periodic backups; spin up from backup on disaster |
| **Pilot light** | Minutes–hours | Hours | Low-med | Core replicated; scale up on failover |
| **Warm standby** | Seconds–minutes | Minutes | Medium | Smaller replica running; scale up on failover |
| **Hot standby / active-passive** | Seconds | Seconds–minutes | High | Full replica running; traffic-redirect on failure |
| **Multi-region active-active** | Zero | Zero | Highest | All regions serving; failure = capacity reduction not downtime |

Pick per criticality: mission-critical → active-active or hot; internal tools → backup-restore.

## Backup policy

Per data store:
- **Frequency**: continuous / hourly / daily / weekly (aligned with RPO)
- **Retention**: hot (days) / warm (months) / cold (years)
- **Encryption**: always, with separate key
- **Location**: cross-region / cross-account / offline copies
- **Testing**: quarterly restore drills minimum
- **Immutability**: WORM / object-lock for ransomware resilience

3-2-1 rule: 3 copies, 2 media, 1 offsite.

## Failover procedure

Per service, runbook:

1. **Detection**: automated health checks + manual verification
2. **Decision**: who authorizes failover (SRE lead / oncall manager)
3. **Communication**: status page update + stakeholder notification
4. **Failover execution**: steps (DNS / routing / DB promotion / etc.)
5. **Verification**: service-health post-failover
6. **Failback procedure**: when primary returns
7. **Post-mortem**: always

Time-boxed; if RTO approaching, escalate.

## DR drills

- **Frequency**: minimum annual; quarterly ideal
- **Types**:
  - Tabletop (discuss scenario, no changes)
  - Partial (failover one service to DR)
  - Full (failover entire region)
  - Surprise (game-day, unannounced)
- **Report**: what worked, what didn't, RPO/RTO achieved vs target
- **Action items** tracked to closure

Chaos engineering (Gremlin / Chaos Monkey) for continuous resilience testing.

## Cross-region / cross-cloud concerns

- **Data residency** — some regulated data can't cross borders
- **Latency** — cross-region replication has lag; affects RPO
- **Cost** — egress fees, duplicate infra
- **Provider dependencies** — if DR region uses same cloud, regional outage may affect both

## Compliance alignment

- **Financial services**: RTS / DORA (EU) mandate DR testing cadence
- **Healthcare**: HIPAA requires contingency plan + testing
- **SOC 2**: DR + BCP part of availability criteria
- **ISO 27001 / 22301**: business continuity explicit

Document + test per regulatory requirement.

## Report

```markdown
# Disaster Recovery Plan: [Organization / System]

## Criticality Tiering
[Per service: criticality + RPO + RTO]

## DR Strategy per Tier
[Tier → strategy]

## Backup Policy
[Per data store: frequency + retention + encryption + location + testing + immutability]

## Failover Runbooks
[Per critical service: detection + decision + comms + execution + verification + failback]

## DR Drill Schedule
[Cadence + types + recent drills results]

## Cross-region Concerns
[Data residency + latency + cost]

## Compliance Alignment
[Per regulation]

## Gap Analysis
[Current state vs target]

## Roadmap
[Phased improvements]
```

## Failure behavior
- No RPO/RTO declared → require first
- No drill testing → block as "DR theater"
- Backups never tested → quarterly drill required
- mmdc failure → see mixin
