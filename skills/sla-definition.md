# SLA Definition — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | sla-definition |
| **Version** | 1.0.0 |
| **Purpose** | Defines a customer-facing Service Level Agreement with contractual commitments and remedies: per-tier availability targets with measurement window and method, optional performance commitments (latency / throughput / error rate), support response times by severity (S1–S4), remedy schedule (service credits, caps, claim procedure), explicit exclusions (scheduled maintenance, force majeure, customer-caused, beta features, third-party outages) with definitions and proof burden, measurement methodology per metric (data source, formula, retention, customer access), and reporting cadence. Always shows internal SLO as tighter than SLA with explicit buffer. Disclaimer required — structured content requires legal review before contractual use. Mermaid downtime-ladder and credit-schedule diagrams with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `formal` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Defining a customer-facing SLA for a SaaS / managed service contract
- Setting commercial commitments before sales / procurement cycles
- Aligning SLA with internal SLO before launch
- Reviewing or renegotiating an existing SLA

## When not to use

- Internal reliability targets (no contract) → `slo-sli-definition`
- Performance budgets (engineering-facing) → `performance-budgeting`
- Scalability modeling → `scalability-modeling`

---

## Required input

| Field | Description |
|---|---|
| **Service** | Named service with scope |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Customer tiers** | Free / Standard / Premium / Enterprise | Single tier |
| **Availability target** | 99.9% / 99.95% / 99.99% | Asked |
| **Internal SLO** | Must be ≥ SLA | Derived |
| **Regions / endpoints** | Which are covered | All |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/sla-definition/` |

## Input schema

```
input:
  required:
    service:
      type: string | document_reference
  optional:
    tiers: list[string]
    availability_targets: object
    internal_slo: object
    regions: list[string]
    endpoints: list[string]
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path:
      type: string
```

---

## Processing rules

### Phase 1 — Setup
Collect service + tiers + availability targets.

### Phase 2 — SLA components
Availability, performance (optional), support response, remedy schedule.

### Phase 3 — Exclusions
Scheduled maintenance, force majeure, customer-caused, beta, third-party.

### Phase 4 — Measurement methodology
Source, formula, retention, customer access.

### Phase 5 — Reporting & review
Cadence + amendment process.

### Phase 6 — SLA vs SLO
Internal SLO tighter; buffer explicit.

### Phase 7 — Diagrams
Downtime ladder + credit schedule.

### Phase 8 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 9 — Report assembly and approval
Full report with disclaimer; present for approval; save only after confirmation.

---

## Output contract

```markdown
# SLA Definition: [Service]

**Date**: [date]
**Disclaimer**: Structured SLA content. Requires legal review before contractual use.

## Scope
[Service, tiers, regions, endpoints]

## Availability Commitment
[Per tier]

## Performance Commitment
[Optional]

## Support Response Times
[Severity table]

## Remedy Schedule
[Credits + claim + caps]

## Exclusions
[With definitions and burden of proof]

## Measurement Methodology
[Per metric]

## Reporting & Review
[Cadence + amendment]

## SLA vs Internal SLO
[Comparison with buffer]

## Diagrams
[Downtime ladder + credit schedule]

## Assumptions & Limitations
[`[Assumed]` items; legal review]
```

### Diagrams

- **Downtime ladder** — Mermaid `xychart-beta`
- **Credit schedule** — Mermaid `xychart-beta`

---

## Generation and planning policy

- Disclaimer required
- SLO tighter than SLA
- Exclusions explicit
- No fabricated industry benchmarks

---

## Self-check

```
[] Disclaimer
[] Per-tier availability with window and method
[] Support response by severity
[] Remedy with claim procedure
[] Exclusions defined
[] Measurement methodology
[] Reporting cadence
[] SLO tighter than SLA
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No service | Interview mode (§7) |
| Target > capability | Flag; recommend looser target or investment |
| No internal SLO | Block — SLO must be tighter than SLA |
| Exclusions missing | Require |
| mmdc failure | See `diagram-rendering` mixin |
| Legal-drafting request | Out-of-scope; legal counsel drafts contract |

---

## Quality checks

- [ ] Disclaimer
- [ ] Availability with method
- [ ] Support tiers
- [ ] Remedies with claim
- [ ] Exclusions
- [ ] Measurement
- [ ] SLO tighter than SLA
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. B2B SaaS Enterprise tier**
- Input: Enterprise analytics SaaS, 99.95% availability
- Expected: Monthly measurement window, successful-request ratio, S1 response 15 min, credits 10/25/50%, exclusions standard, internal SLO 99.97%.

**2. API service with performance commitment**
- Input: Payment API
- Expected: Availability 99.95% + p95 latency ≤ 500ms, endpoint-specific exclusions, monthly report via status page + API.

**3. Multi-tier SaaS**
- Input: Free / Pro / Enterprise
- Expected: Free = no SLA (best effort), Pro = 99.9%, Enterprise = 99.95%; different response times per tier.

**4. Regulated service**
- Input: Healthcare data platform
- Expected: Standard SLA plus regulatory-notification commitments (breach notification, data residency), legal-review emphasized.

**5. Renegotiation**
- Input: Existing 99.9% SLA, customer asking for 99.99%
- Expected: Gap analysis (3 orders of magnitude reduction in downtime requires infra investment), cost implication, proposed phased target.

### Edge cases

**6. No historical availability data**
- Input: New service, no production history
- Expected: Propose conservative target (99.5% or 99.9%) with "reviewed after 6 months" clause; flag confidence low.

**7. Shared dependency limits SLA**
- Input: Service depends on external API with 99.9% SLA
- Expected: Cannot exceed 99.9% composite without redundancy; document dependency; propose matching target or redundancy investment.

**8. 24/7 support commitment**
- Input: "We need 24/7 S1 response"
- Expected: Staffing implication; recommend on-call rotation; cost impact on pricing.

### Failure cases

**9. No service**
- Input: "Define an SLA"
- Expected: Interview — "Which service, and which customer tier(s)?"

**10. Out of scope (legal)**
- Input: "Write the SLA contract"
- Expected: "Structured content only. Legal counsel drafts contractual language."
