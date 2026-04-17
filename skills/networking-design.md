# Networking Design — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | networking-design |
| **Version** | 1.0.0 |
| **Purpose** | Network design for cloud / hybrid / on-prem. Non-overlapping CIDR plan reserving room for multi-region + peerings + VPN client pool. VPC/VNet structure with subnet tiering (public / private / data per AZ, multi-AZ). Routing (IGW for public, NAT GW for private egress per-AZ for HA, Transit Gateway for cross-VPC hub, VPC peering for 1:1). Hub-spoke topology for multi-VPC/multi-account (hub = shared services + hybrid connectivity, spokes = workloads). DNS strategy: external (Route53 / Cloud DNS / Azure DNS / CloudFlare) + internal (private zones / Consul / K8s DNS) + hybrid resolution. Private endpoints for managed services (VPC endpoints / Private Link / PSC) avoiding public internet. Load balancers (NLB L4 / ALB L7 / Global LB with geo-routing). CDN + edge functions. Hybrid connectivity (VPN / Direct Connect / ExpressRoute / Partner Interconnect / SD-WAN). Service mesh (Istio / Linkerd) with mTLS + traffic policies for microservices. Mermaid network diagram with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- Greenfield cloud network
- Multi-account / multi-region expansion
- Hybrid connectivity setup
- M&A network integration

## When not to use
- Zero-trust architecture → `zero-trust-architecture`
- Cloud architecture broader → `cloud-architecture-design`
- IaC implementation → `iac-planning`

## Required input
- **Cloud + multi-account + on-prem / multi-region context**

## Output contract
CIDR plan + VPC structure + subnet tiering + routing + DNS + private endpoints + LB + CDN + hybrid + service mesh + security + diagram.

## Failure behavior
- Overlapping CIDRs → remediate
- No private endpoints → challenge
- Public-by-default → flag

## Examples
1. AWS multi-account — hub-spoke via TGW + per-env VPC + private subnets + NAT HA.
2. Hybrid enterprise — Direct Connect + VPN backup + Route53 resolver endpoints.
3. Multi-region active-active — separate VPCs per region + cross-region peering + global LB.
4. K8s-native — service mesh with Istio + mTLS between services + Envoy as data plane.
5. CIDR remediation — re-number overlapping ranges before hybrid connectivity possible.
