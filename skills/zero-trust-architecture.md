# Zero Trust Architecture — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | zero-trust-architecture |
| **Version** | 1.0.0 |
| **Purpose** | Designs zero-trust architecture per NIST SP 800-207 / BeyondCorp principles. Core principle: never-trust-always-verify — every request authenticated + authorized + encrypted regardless of network location. Components: Policy Engine (decides), Policy Administrator (configures), Policy Enforcement Point at every boundary (enforces), Subject + Device (attested), Resource (target), Data Sources (CDM / threat-intel / SIEM / ID systems). Design dimensions: identity-centric (strong authN / workload identity via SPIFFE), device-centric (enrollment / health attestation / compliance posture), context-aware (geo / time / behavior / resource sensitivity), micro-segmentation (workload-level zones + east-west mTLS + no internal implicit trust), continuous verification (short-lived tokens + session reassessment on signal change + step-up auth). Migration roadmap from perimeter model (inventory → identity maturity → device management → workload identity → east-west authN → micro-seg → policy engine → sunset implicit trust). Patterns: ZTNA (replaces VPN), SASE (ZT + network), service mesh, BeyondCorp remote access. Mermaid control/data-plane diagram with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- Post-remote-work zero-trust transition
- Migrating away from VPN-as-trust-proxy
- Cloud-native / service mesh adoption
- Compliance-driven need (NIST, FedRAMP)

## When not to use
- Identity design alone → `authentication-strategy-design`
- Encryption design → `encryption-strategy`
- Network infrastructure → `networking-design` (Phase 5 Infra)

## Required input
- **Org** + **existing network model**

## Processing
1. Principles + maturity assessment
2. Components (PE / PA / PEP / data sources)
3. Identity + device + context design
4. Micro-segmentation plan
5. Continuous verification
6. Migration roadmap
7. Quick wins first

## Output contract
Principles + components + 4 design dimensions + micro-seg plan + migration roadmap + quick wins + diagram.

## Failure behavior
- No IdP centralization → prerequisite
- VPN called ZT → correct
- Big-bang migration → recommend phased
- mmdc failure → see mixin

## Examples
1. Large enterprise — 5-phase migration; quick wins: MFA + EDR; 24-month roadmap.
2. Cloud-native startup — service mesh with mTLS + SPIFFE from start; easier greenfield.
3. Regulated org — BeyondCorp-style remote access replacing legacy VPN; compliance-driven.
4. SaaS product — workload identity for services + ZTNA for customer access.
5. Hybrid — phased with identity first, then east-west, then sunset-VPN last.
