# Threat Modeling — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | threat-modeling |
| **Version** | 1.0.0 |
| **Purpose** | Systematic threat modeling using STRIDE (default — Spoofing / Tampering / Repudiation / Information disclosure / Denial of service / Elevation of privilege) or PASTA (7-stage Process for Attack Simulation and Threat Analysis) methodology. Decomposes system into processes / data flows / data stores / external entities / trust boundaries. Per element enumerates applicable threat categories systematically. Per threat captures: ID, element, category, description, likelihood (1–5), impact (1–5), risk (L × I), attack vector, attacker-capability assumption, current controls, residual risk, recommended additional mitigations, owner. Maps threats to control types (authentication / authorization / cryptography / input validation / output encoding / logging / rate limiting / isolation / secrets management / secure development). Optional attack-tree decomposition for critical threats. Produces Mermaid trust-boundary diagram + risk heat-map quadrant with PNG export. Disclaimer: threat model informs security work but doesn't replace pentesting or formal certification. |
| **Primary category** | `assessment` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Audience** | `technical` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use
- Early-stage security design for a new system
- Pre-launch security review
- Post-incident root-cause + systemic analysis
- Regulatory or contractual threat-modeling requirement
- Pairs with `security-requirements-classification` + `control-framework-mapping`

## When not to use
- Pentesting / red team — this is analytical, not empirical
- Security-requirements classification → `security-requirements-classification`
- Audit against frameworks → `control-framework-mapping`
- Privacy-only flow mapping → `data-flow-diagramming`

## Required input
- **System** — named subject

## Optional input
- **Methodology** — STRIDE / PASTA (default STRIDE)
- **Decomposition reference** — from `system-decomposition`
- **Regulatory context**
- **Render mode + output path**

## Processing
1. Setup (system + methodology + scope + decomposition source + regulatory)
2. Decomposition (processes / flows / stores / entities / trust boundaries)
3. STRIDE enumeration (or PASTA stages)
4. Per-threat scoring + mitigations
5. Attack trees for critical threats
6. Control type mapping
7. Residual-risk accounting
8. Diagrams (trust-boundary + risk heat map)
9. Report with disclaimer

## Output contract
Threat inventory + trust-boundary diagram + risk heat map + attack trees (if critical threats) + residual risks + prioritized recommendations + disclaimer.

## Failure behavior
- No system → interview
- No decomposition → light DFD first
- Certification claim → decline
- mmdc failure → see mixin

## Examples (brief)
1. Web app STRIDE — 40 threats across elements; 5 critical require mitigation; 3 accepted with monitoring.
2. Payment system PASTA — business-risk-driven; regulatory overlay for PCI-DSS.
3. Microservice architecture — per-service threats + cross-service trust boundaries.
4. Mobile app — client-side threats + API threats + secret-storage threats.
5. IoT device — firmware + network + cloud triad.
6. Insufficient info → flag elements as `[Assumed]` and recommend information-gathering phase.
