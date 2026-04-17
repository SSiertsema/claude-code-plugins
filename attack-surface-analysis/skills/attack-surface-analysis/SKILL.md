---
name: attack-surface-analysis
description: Inventory and analyze the attack surface — all externally accessible interaction points. Per element: exposure, accessibility, authentication, CVEs, data sensitivity reached, monitoring. Ranked reduction recommendations.
argument-hint: "[system + inventory source]"
---

# Attack Surface Analysis

You inventory the attack surface — anywhere an attacker could interact with the system — and rank reduction opportunities by risk-per-effort.

## Core rules

- **Comprehensive**: network + API + auth + supply chain + physical + human channels
- **Per-element data**: exposure, auth req, CVE history, data reached, monitoring
- **Reduction over defense**: prefer removing an attack surface element to defending it
- **Risk per effort**: prioritize reductions by biggest risk reduction per unit work
- **No fabricated CVEs**: work from real CVE DBs or flag as unverified

## Input handling
- **System** (required)
- **Inventory source**: architecture doc / scan results / manual elicitation
- **Regulatory context**

## Phase 1 — Setup
Declare system + inventory source.

## Phase 2 — Surface categories

| Category | Elements |
|---|---|
| **Network-facing** | Public endpoints, open ports, protocols |
| **APIs** | REST / GraphQL / gRPC endpoints, methods per endpoint |
| **Authentication** | Login flows, SSO providers, password reset, API keys, OAuth scopes |
| **Client-side** | Mobile apps (reverse-engineerable), browser code, extensions |
| **Supply chain** | Third-party libraries, vendor integrations, container base images |
| **Physical** | Office access, device compromise, USB |
| **Human / social** | Support channels, phishing vectors, insider access |
| **Side channels** | Logs, error messages, timing attacks, cache metadata |
| **Admin / debug** | Admin panels, monitoring endpoints, debug flags |

## Phase 3 — Per-element data

| Field | Description |
|---|---|
| **Element** | Endpoint / interface |
| **Category** | From above |
| **Exposure** | Public / authenticated / internal |
| **Authentication** | None / basic / MFA / cert |
| **Authorization** | Role / resource checks present? |
| **Protocol** | HTTPS / HTTP / WS / gRPC |
| **Data sensitivity reached** | Public / PII / special-category |
| **Known CVEs** | From dependencies |
| **Monitoring** | Logged, alerted, rate-limited |
| **Last reviewed** | Date |

## Phase 4 — Risk scoring

Per element: exposure × data-sensitivity × authentication-weakness.

## Phase 5 — Reduction strategies

1. **Remove** — eliminate unused endpoints, deprecated APIs, unused ports
2. **Restrict** — move from public to authenticated, tighten scopes
3. **Monitor** — add logging + alerting
4. **Harden** — rate limiting, input validation, encryption
5. **Patch** — CVE remediation

## Phase 6 — Prioritization

Rank: risk-reduction ÷ effort. Top quick-wins first.

## Phase 7 — Diagram

```mermaid
flowchart TB
    subgraph Public["Public surface"]
        API["API endpoints"]
        WEB["Web app"]
    end
    subgraph Auth["Authenticated surface"]
        ADMIN["Admin API"]
    end
    subgraph Internal["Internal only"]
        METRICS["Metrics endpoint"]
    end
```

## Phase 8 — Report

```markdown
# Attack Surface Analysis: [System]

## Surface Inventory
[Per element table]

## Risk Scoring
[Sorted by risk]

## Reduction Recommendations
[Ranked by risk-per-effort]

## Quick Wins / Strategic / Parking Lot
[Prioritized buckets]
```

## Failure behavior
- No inventory → interview / scan-recommendation
- CVE claims without source → flag unverified
- mmdc failure → see `diagram-rendering` mixin
