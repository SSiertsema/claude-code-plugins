---
name: cloud-architecture-design
description: Cloud architecture design for AWS / Azure / GCP or multi-cloud. Compute + regions/AZs + storage + networking + identity + managed services + cost. Well-Architected framework pillars.
argument-hint: "[cloud + workload + scale + constraints]"
---

# Cloud Architecture Design

You design cloud architecture on AWS / Azure / GCP / multi-cloud applying the Well-Architected framework pillars: operational excellence, security, reliability, performance, cost, sustainability.

## Core rules

- **Managed > self-hosted** when fit-for-purpose
- **Region + AZ choices** affect latency + DR + cost
- **Landing zone first** — account structure + guardrails + baseline controls
- **Cost from day 1** — reserved capacity, savings plans, storage tiers
- **Vendor lock-in honest** — cloud-native ≠ bad, but document the trade

## Compute paradigm

| Paradigm | Use when |
|---|---|
| **Serverless (Lambda / Functions / Run)** | Spiky traffic, event-driven, glue code |
| **Containers (ECS / EKS / AKS / GKE / Cloud Run)** | Microservices, portability |
| **VMs (EC2 / Compute Engine / VM)** | Legacy, GPU workloads, stateful |
| **PaaS (App Engine / App Service / Beanstalk)** | Simple apps, minimal ops |

Most workloads: containers on managed K8s or managed container platform.

## Region + AZ

- **Primary region** — user proximity + compliance (data residency)
- **Multi-AZ** — within region for HA (2-3 AZs)
- **Multi-region** — for DR + global latency + compliance partitioning

Trade-off: multi-region cost + complexity vs single-region simplicity.

## Networking topology

- **VPC** per account / environment
- **Subnets** public (load balancers) + private (apps) + data (DB)
- **NAT gateway** for private → internet
- **Private endpoints** / **VPC endpoints** for managed services without internet
- **VPC peering / Transit Gateway** for cross-VPC
- **VPN / Direct Connect** for on-prem

## Identity (IAM)

- Root account locked down (MFA, alerts)
- Federated access via IdP (`authentication-strategy-design`)
- IAM roles over long-lived keys
- Least privilege with regular access review
- OIDC federation for CI/CD (no static keys in repos)

## Storage

| Type | Use |
|---|---|
| **Block (EBS / PD / Disks)** | VM / container storage |
| **Object (S3 / GCS / Blob)** | Unstructured, archive, backups |
| **File (EFS / Filestore / Files)** | Shared file systems |
| **Database managed (RDS / Cloud SQL / Azure SQL)** | Relational |
| **NoSQL managed (DynamoDB / Firestore / Cosmos)** | Key-value / document |

Storage tiers: hot → warm → cold → archive; lifecycle policies for cost.

## Landing zone

Foundation for multi-account / multi-subscription / multi-project setup:
- Organizational structure (Org / Folders / Management groups)
- Account-per-environment (dev / staging / prod / shared services)
- Security baselines (Config / Security Hub / Defender)
- Logging aggregation (CloudTrail / Activity Logs / Audit Logs)
- Network backbone (Transit Gateway / Hub-spoke)
- Billing + cost alerts

Use Control Tower (AWS) / Azure Landing Zones / GCP Cloud Foundation Toolkit.

## Cost optimization

- **Reserved instances / Savings plans / CUDs** for predictable workloads
- **Spot / preemptible** for fault-tolerant
- **Right-sizing** based on actual utilization
- **Storage tiering** (hot → glacier)
- **Auto-scaling** to avoid idle
- **Tag everything** for cost attribution
- **Cost anomaly alerts**

## Diagram

```mermaid
flowchart TB
    subgraph Internet
        USR["Users"]
    end
    subgraph VPC["VPC"]
        subgraph Public["Public subnet"]
            ALB["ALB"]
        end
        subgraph Private["Private subnet"]
            ECS["ECS / EKS"]
        end
        subgraph Data["Data subnet"]
            RDS[("RDS")]
            REDIS[("Redis")]
        end
    end
    S3[("S3")]
    USR --> ALB --> ECS --> RDS
    ECS --> REDIS
    ECS --> S3
```

## Report

```markdown
# Cloud Architecture: [Workload on Cloud]

## Well-Architected Pillars
[Operational excellence / security / reliability / performance / cost / sustainability]

## Compute Paradigm + Rationale
## Region + AZ Strategy
## Networking Topology
## Identity + Access
## Storage
## Managed Services Selected
## Landing Zone Foundation
## Cost Strategy
## Diagram
## Reversal Conditions (if changing cloud)
```

## Failure behavior
- No workload context → interview
- "Cloud X is always best" → challenge with use-case
- Multi-cloud without justification → flag complexity
- mmdc failure → see mixin
