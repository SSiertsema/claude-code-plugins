# Disaster Recovery Planning — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | disaster-recovery-planning |
| **Version** | 1.0.0 |
| **Purpose** | Plan DR per service. Declares RPO (max data loss) + RTO (max downtime) per service criticality tier. Selects DR strategy scaled by cost + speed: backup + restore (low cost, hours RTO, days recovery), pilot light (core replicated, scale up on failover), warm standby (smaller replica running, scale up), hot standby / active-passive (full replica running, traffic redirect on failure), multi-region active-active (zero-RTO, highest cost). Backup policy per data store: frequency aligned with RPO, retention tiered (hot / warm / cold), encryption with separate key, cross-region + cross-account location, quarterly restore drills minimum, immutability via WORM / object-lock for ransomware resilience (3-2-1 rule). Failover runbooks per critical service: detection → decision (authorizer) → communication → execution → verification → failback → post-mortem. DR drills (tabletop / partial / full / surprise game-day) with minimum annual cadence — chaos engineering for continuous resilience. Cross-region concerns (data residency, replication latency, egress cost, provider correlation). Compliance alignment (DORA / RTS / HIPAA contingency / SOC 2 availability / ISO 22301). Gap analysis + roadmap. |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- Greenfield DR plan
- Post-incident DR improvements
- Compliance-driven DR requirement
- Cost optimization on over-engineered DR

## When not to use
- Scalability / capacity → `scalability-modeling`
- SLO / SLI → `slo-sli-definition`
- Backup mechanics only → IaC / infra skills

## Required input
- **Services + criticality + budget + compliance**

## Output contract
Criticality tiering + DR strategy per tier + backup policy + failover runbooks + drill schedule + cross-region concerns + compliance + gap analysis + roadmap.

## Failure behavior
- No RPO/RTO → require
- No testing → block as DR theater
- Untested backups → quarterly drill required

## Examples
1. Financial services active-passive across regions with RPO 1min / RTO 5min.
2. Small SaaS — backup + restore with daily snapshots; RPO 24h / RTO 24h.
3. Healthcare — DORA-compliant DR testing quarterly + HIPAA contingency plan.
4. Post-ransomware — add immutable backups + offline copies + IRP integration.
5. Cost-driven — downgrade hot standby to warm for tier-2 services.
