# Cloud Architecture Design — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | cloud-architecture-design |
| **Version** | 1.0.0 |
| **Purpose** | Cloud architecture design for AWS / Azure / GCP / multi-cloud applying Well-Architected framework pillars (operational excellence / security / reliability / performance / cost / sustainability). Selects compute paradigm (serverless for spiky / containers for portability / VMs for legacy / PaaS for simple apps), region + AZ strategy (multi-AZ default HA, multi-region for DR + global latency + compliance), networking topology (VPC per account, subnets public/private/data, NAT + private endpoints + VPC peering + Transit Gateway), identity (federated + OIDC for CI/CD + least privilege), storage tiering (block / object / file with lifecycle policies), managed services fit-for-purpose. Landing zone foundation: organizational structure + account-per-environment + security baselines (Config / Security Hub / Defender) + logging aggregation + network backbone + billing. Cost optimization (reserved / savings plans / CUDs / spot / right-sizing / storage tiering / auto-scaling / tagging / anomaly alerts). Mermaid cloud architecture diagram with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- Greenfield cloud architecture
- Cloud migration planning
- Multi-account / landing zone setup
- Cost optimization review
- Well-Architected review

## When not to use
- Specific service selection → `technology-evaluation-matrix` / `database-technology-selection`
- IaC planning → `iac-planning`
- DR specifics → `disaster-recovery-planning`
- Security architecture → Security-Architecture skills

## Required input
- **Cloud(s)** + **workload** + **scale** + **constraints**

## Output contract
Pillars + compute + regions + network + IAM + storage + managed services + landing zone + cost + diagram.

## Failure behavior
- No workload → interview
- Cloud-always-best bias → challenge
- Multi-cloud without justification → flag

## Examples
1. AWS-first SaaS — ECS on Fargate + RDS + S3 + CloudFront + landing zone with Control Tower.
2. GCP data platform — GKE + BigQuery + Cloud Storage + Dataflow.
3. Azure enterprise — AKS + Azure SQL + Management Groups hierarchy + Azure Policy.
4. Multi-region fintech — primary + DR regions + cross-region replication + Route 53 failover.
5. Multi-cloud avoidance argument — flag overhead; recommend primary cloud with escape hatch per critical workload.
