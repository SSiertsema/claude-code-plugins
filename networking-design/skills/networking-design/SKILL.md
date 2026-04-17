---
name: networking-design
description: Network design for cloud / hybrid / on-prem. VPC structure, subnet segmentation, CIDR planning, routing, peering + hub-spoke, NAT, DNS, private endpoints, load balancers, CDN, VPN + Direct Connect, service mesh.
argument-hint: "[cloud + multi-account + on-prem / multi-region]"
---

# Networking Design

You design the network: VPCs, subnets, CIDRs, routing, DNS, edge, hybrid connectivity.

## Core rules

- **CIDR plan up front** — avoid overlapping ranges (esp. for future peering / hybrid)
- **Subnet tiering** — public / private / data per AZ
- **Private by default** — resources in private subnets, egress via NAT / private endpoints
- **DNS strategy explicit** — internal + external, not ad-hoc
- **Hub-spoke for multi-VPC** — avoid full mesh
- **Zero-trust network** — don't rely on network alone; see `zero-trust-architecture`

## CIDR planning

Reserve non-overlapping ranges:
- **Corporate / on-prem**: e.g., 10.0.0.0/12 (lots of room)
- **Cloud VPC-per-env**: e.g., 10.16.0.0/16 dev, 10.32.0.0/16 staging, 10.48.0.0/16 prod
- **Within VPC**: /20 per subnet tier, subdivided per AZ /22

Leave room for:
- Multi-region expansion
- Future peerings (partners, M&A)
- VPN client pool

Don't use overlapping RFC1918 ranges if hybrid connectivity planned.

## Subnet tiers

Per VPC:

| Subnet tier | Contains | Routing |
|---|---|---|
| **Public** | Load balancers, bastion (if any), NAT gateways | Route to IGW |
| **Private (app)** | Apps / containers / VMs | Route to NAT for egress; private to VPC |
| **Data** | Databases, caches, internal services | No internet route; only from private app subnets |

Multi-AZ: 3 subnets per tier × 3 AZs = 9 subnets typical.

## Routing

- **Internet Gateway** (public only)
- **NAT Gateway** (private → internet; per-AZ for HA)
- **Transit Gateway** for cross-VPC + hybrid hub
- **VPC Peering** for simple 1:1 (bypasses TGW cost but doesn't transit)
- **Routing tables** per subnet tier

## Hub-spoke topology

For multi-VPC / multi-account:
- **Hub VPC** (shared services: DNS, monitoring, hybrid connectivity)
- **Spoke VPCs** (workload envs)
- Spokes route to hub; hub routes out (internet / on-prem)

## DNS

| Concern | Tool |
|---|---|
| External DNS (customer-facing) | Route53 / Cloud DNS / Azure DNS / CloudFlare |
| Internal DNS (service discovery) | Route53 private zones / Cloud DNS private / Consul / K8s DNS |
| Hybrid resolution | Resolver endpoints for cross-VPC + on-prem |
| Service mesh | mDNS-like via Istio / Linkerd / Consul |

Naming convention: `<service>.<env>.<region>.<company>.internal`.

## Private endpoints for managed services

Avoid public internet traffic to managed services within same cloud:
- **VPC endpoints** (AWS) / **Private Link** / **Private Service Connect**
- Access S3 / RDS / Cloud SQL / etc. over private network
- Reduces egress + improves security

## Load balancers

| Type | Layer | Use |
|---|---|---|
| **Network LB (L4)** | TCP/UDP | Lower latency, high throughput, static IP |
| **Application LB (L7)** | HTTP/HTTPS | Path-based routing, WAF, TLS termination |
| **Global LB** | DNS / Anycast | Multi-region, geo-routing |

## CDN

- Static content + dynamic content at edge
- CloudFront / Cloudflare / Fastly / Akamai
- Cache policy per content type
- Edge functions for logic at edge (Lambda@Edge, Workers, Cloudflare)

## Hybrid connectivity

| Option | Use |
|---|---|
| **Site-to-site VPN** | Quick, cheaper, lower bandwidth |
| **Direct Connect / ExpressRoute / Partner Interconnect** | High bandwidth, consistent latency, dedicated |
| **SD-WAN** | Multi-site enterprise |

## Service mesh network

For microservices:
- Sidecar-based (Istio / Linkerd)
- mTLS between services
- Traffic policies (retry / timeout / circuit-breaker)
- Observability

## Diagram

```mermaid
flowchart TB
    Internet
    subgraph VPC
        subgraph AZ1["AZ 1"]
            PUB1["Public subnet"]
            PRIV1["Private subnet"]
            DATA1["Data subnet"]
        end
        subgraph AZ2["AZ 2"]
            PUB2["Public subnet"]
            PRIV2["Private subnet"]
            DATA2["Data subnet"]
        end
    end
    Internet --> PUB1
    PUB1 --> PRIV1 --> DATA1
    PUB2 --> PRIV2 --> DATA2
```

## Report

```markdown
# Networking Design: [Scope]

## CIDR Plan
[Per env + future reservations]

## VPC Structure
[Hub-spoke / per-env / multi-region]

## Subnet Tiering
[Public / private / data per AZ]

## Routing
[IGW / NAT / TGW / peering]

## DNS Strategy
[External + internal + hybrid]

## Private Endpoints
[For managed services]

## Load Balancers + CDN
[Per external entry point]

## Hybrid Connectivity
[If on-prem]

## Service Mesh
[If microservices]

## Security Controls
[Security groups / NACLs / firewall rules]

## Diagram
```

## Failure behavior
- Overlapping CIDRs → remediate before hybrid
- No private endpoints (all via internet) → challenge
- Public-by-default resources → flag
- mmdc failure → see mixin
