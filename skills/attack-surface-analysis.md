# Attack Surface Analysis — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | attack-surface-analysis |
| **Version** | 1.0.0 |
| **Purpose** | Inventories and analyzes a system's complete attack surface across 9 categories (network-facing, APIs, authentication, client-side, supply chain, physical, human/social, side channels, admin/debug). Per element captures exposure level, authentication requirement, authorization checks, protocol, data sensitivity reached, known CVEs in dependencies, monitoring / alerting / rate-limiting posture, and last review date. Scores risk per element (exposure × data-sensitivity × authentication-weakness). Proposes reduction strategies ranked by risk-reduction per effort: remove (best — eliminate unused endpoints / deprecated APIs / open ports), restrict (authenticate / narrow scopes), monitor (logging + alerting), harden (rate limiting / validation / encryption), patch (CVE remediation). Prioritizes across quick-wins / strategic / parking-lot. Complements `threat-modeling` (threat enumeration per element) and `security-requirements-classification` (controls per data tier). Mermaid surface diagram with PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `extraction` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- Pre-launch hardening sweep
- Audit discovery: understand what attackers can reach
- Post-incident blast-radius review
- Reducing vendor footprint / supply-chain risk

## When not to use
- Enumerate threats per element → `threat-modeling`
- Data-classification + controls → `security-requirements-classification`
- Framework mapping → `control-framework-mapping`

## Required input
- **System**
- **Inventory source** (arch doc / scan / elicitation)

## Processing
1. Setup
2. Categorize elements (9 categories)
3. Per-element data capture
4. Risk score = exposure × sensitivity × authentication-weakness
5. Reduction strategies (remove > restrict > monitor > harden > patch)
6. Prioritize by risk-per-effort
7. Diagram + report

## Output contract
Surface inventory + risk scores + ranked reductions + prioritized buckets + diagram.

## Failure behavior
- No inventory → recommend scan / interview
- Fabricated CVEs → flag
- mmdc failure → see mixin

## Examples
1. Public SaaS — 30 API endpoints, 5 unused (remove), 8 over-scoped (restrict), 6 without rate-limiting (harden).
2. Mobile app — client-side surface includes reverse-engineered binary; server-side API surface separate analysis.
3. Post-acquisition — inherited surface much larger than documented; major reduction via endpoint sunset.
4. Supply-chain focus — 200 npm dependencies; 12 with known CVEs requiring patching.
5. Admin surface sweep — discover forgotten debug endpoints + unprotected metrics.
