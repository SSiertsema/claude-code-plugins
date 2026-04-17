# Vendor Evaluation Matrix — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | vendor-evaluation-matrix |
| **Version** | 1.0.0 |
| **Purpose** | Produces a weighted evaluation of vendors against a defined use case + constraints. Criteria base set: capability fit (20), reliability (10), security+compliance (15), TCO at forecast (15), commercial terms (10), implementation complexity (5), vendor viability (5), support+partnership (5), data residency+GDPR (5), exit strategy+lock-in (10) — weights adapted + agreed before scoring, sum to 100. Scoring 1–5 with evidence citation per score (doc link, status page, DPA excerpt); unknowns marked `[unknown]` not guessed. TCO model over 3-year horizon covering direct license, integration one-time, training, operate (monitoring/SRE/updates), change/upgrade, exit (data migration + rebuild), hidden costs (egress, premium support, seat tiers). Commercial terms checklist (pricing model, tiers, term length, auto-renewal, renewal price caps, volume discounts, trial, usage caps + overage). SLA requirements expressed as what we need (uptime with measurement exclusions, response SLA by severity, resolution, credits, notification, post-mortem SLA, data durability, backup + RPO/RTO). Data residency + compliance (region options, DPA + Schrems II SCCs for US transfers, sub-processor list + change notice, erasure mechanisms, audit rights, breach notification, PCI/HIPAA BAA availability). Vendor risk assessment beyond capability: financial health, operational (region outage history), concentration, fourth-party dependency (their AWS/GCP reliance), security maturity, regulatory, key-person. Exit strategy per vendor (data export fidelity, portability, abstraction layer, contract notice, migration time). PoC plan if decision pending. Includes disclaimer: engineering + procurement input, not legal/contractual advice. Hand-off to `build-vs-buy-analysis` for serious in-house option, `third-party-api-evaluation` for API-integration-focused variant. Mermaid weighted-radar + TCO-3y chart with PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `classification` |
| **Output mode** | `human_readable` |
| **Tone** | `professional` |
| **Audience** | `mixed` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |
| **Evidence mode** | `required` |

---

## When to use

- Vendor shortlist evaluation
- Renewal / alternatives review
- RFP evaluation phase
- Build-vs-buy evidence gathering

## When not to use

- API-integration fit only → `third-party-api-evaluation`
- Full build-vs-buy TCO → `build-vs-buy-analysis`
- RFP document creation → `rfp-rfi-creation`
- Legal / contract advice → counsel

---

## Required input

| Field | Description |
|---|---|
| **Use case + must-haves** | What vendor must do |
| **Vendor shortlist** | Candidates |
| **Volume forecast** | Scale expectations |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Constraints** | Regulatory / geography / budget / timeline | Asked |
| **Horizon** | 1 / 3 / 5 years | 3 years |
| **Stakeholders** | Owner / approver / legal / finance | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/vendor-evaluation-matrix/` |

## Input schema

```
input:
  required:
    use_case: string
    must_haves: array[string]
    vendors: array[string]
    volume_forecast: object
  optional:
    constraints: object
    horizon_years: integer
    stakeholders: array[string]
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path: string
```

---

## Processing rules

### Phase 1 — Setup
Use case, must-haves, vendors, volume, constraints, stakeholders.

### Phase 2 — Criteria + weights
Agreed before scoring.

### Phase 3 — Scoring
1–5 with evidence; `[unknown]` where missing.

### Phase 4 — TCO model
Direct + integration + operate + change + exit + hidden.

### Phase 5 — Commercial terms
Checklist.

### Phase 6 — SLA requirements
Our asks.

### Phase 7 — Data residency + compliance
DPA + sub-processors + erasure.

### Phase 8 — Vendor risk
Financial / operational / concentration / fourth-party / security / regulatory / key-person.

### Phase 9 — Exit strategy
Per vendor.

### Phase 10 — PoC plan
If decision pending.

### Phase 11 — Recommendation
Top factors + risks + negotiation priorities + exit.

### Phase 12 — Diagrams
Radar + TCO.

### Phase 13 — Diagram rendering
Per mixin.

### Phase 14 — Report assembly and approval
Approval before save. Disclaimer included.

---

## Output contract

```markdown
# Vendor Evaluation: [Use case]

**Date**: [date]
**Use case**: [...]
**Vendors**: [...]
**Recommended**: [...]

> Disclaimer: Not legal or contractual advice.

## Scope
## Criteria + Weights
## Scoring Matrix
## TCO Model
## Commercial Terms
## SLA Requirements
## Data Residency + Compliance
## Vendor Risk Assessment
## Exit Strategy
## Proof-of-Concept Plan
## Recommendation
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Weighted radar** — Mermaid `xychart-beta`
- **TCO** — Mermaid `xychart-beta`

---

## Assessment and planning policy

- Use-case-driven
- Weights agreed + sum 100
- Evidence per score
- TCO beyond list price
- SLA as requirements
- Vendor risk multi-dimensional
- Exit explicit
- Disclaimer present
- No fabricated data

---

## Self-check

```
[] Use case + must-haves
[] Weights sum 100
[] Evidence per score
[] TCO: integration / operate / exit
[] SLA requirements
[] Data residency + DPA
[] Vendor risk multi-dimensional
[] Exit per vendor
[] PoC plan if pending
[] Disclaimer
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No use case | Interview mode (§7) |
| Single-vendor "review" | Require alternatives |
| Vendor marketing | Replace with evidence or `[unknown]` |
| Missing regulatory context | Ask first |
| Legal/contract advice | Decline |
| Build-vs-buy serious | Hand off |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Every criterion weighted deliberately
- [ ] Evidence links per score
- [ ] TCO includes hidden costs
- [ ] SLA clauses quantitative
- [ ] Residency + DPA confirmed per vendor
- [ ] Risk mitigations per identified risk
- [ ] Exit migration time estimated

---

## Examples

### Normal cases

**1. Payments processor**
- Input: Stripe vs Adyen vs Mollie, EU, 500k txn/mo
- Expected: Weighted scorecard with PCI + DPA + EU residency emphasis; TCO per volume tier; negotiation priorities

**2. Customer support SaaS**
- Input: Zendesk vs Intercom vs Freshdesk
- Expected: Capability + TCO dominant; seat-based model; exit via CSV export evaluated

**3. Observability stack**
- Input: Datadog vs Grafana Cloud vs Honeycomb
- Expected: Data ingestion cost + retention tiers dominate; lock-in low if OTel used upstream

**4. Cloud provider**
- Input: AWS vs GCP vs Azure for new workload
- Expected: Concentration risk if already on one; TCO 3y; residency per region; exit via abstraction layer

**5. Renewal / re-evaluation**
- Input: Incumbent vs alternatives
- Expected: Baseline incumbent with actual usage + cost data; alternatives scored similarly

### Edge cases

**6. Build-in-house emerges**
- Expected: Include as column; flag handoff to `build-vs-buy-analysis` for full TCO

**7. Vendor in financial distress**
- Expected: Vendor-viability risk High; require contract guarantees + escrow

**8. Regulatory mismatch**
- Expected: Block vendor; flag DPO review; recommend EU-region alternative

### Failure cases

**9. No use case**
- Input: "Evaluate Stripe"
- Expected: Interview — what for, volume, geography, alternatives

**10. Legal advice request**
- Input: "Is the contract safe to sign?"
- Expected: "Engineering + procurement input only. Counsel decides."
