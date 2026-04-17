# RFI / RFP / RFQ Creation — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | rfp-rfi-creation |
| **Version** | 1.0.0 |
| **Purpose** | Produces a solicitation document (RFI / RFP / RFQ). Instrument selection by intent: RFI to discover vendors + capabilities (2-week response), RFP for solution + pricing proposals (4–8 weeks), RFQ for commodity pricing against a defined spec (1–2 weeks). Standard sections with numbered requirement IDs: (1) cover + introduction, (2) business context + drivers + constraints, (3) scope, (4) functional (must / should / nice) + non-functional (performance, availability, security, a11y, interoperability, data residency) requirements, (5) commercial asks (pricing model, term, tiers, overage, implementation fees, discounts, payment terms), (6) security + compliance (SOC 2 II / ISO 27001 / PCI / HIPAA BAA / DPA + SCCs + sub-processors / incident response / vulnerability disclosure / insurance), (7) SLA asks (uptime + measurement exclusions, response/resolution SLAs by severity, credits, post-mortem SLA, planned maintenance), (8) implementation + transition (onboarding, migration, training, hypercare, exit migration-out), (9) vendor information (financials, references, sub-processors, ops centers), (10) response format + disclosed scoring rubric with weights + minimum thresholds, (11) submission process (format, deadline with timezone, NDA, Q&A process, late submissions, notification timeline), (12) draft terms + conditions flagged "legal review required" (IP, confidentiality, indemnity, termination, audit, force majeure, governing law), (13) appendices. Fair Q&A process (single channel + consolidated publication to all bidders). Realistic 8–12 week RFP timeline. Vendor-diversity + accessibility considerations. Includes disclaimer: engineering + procurement input, not legal advice. Produces draft solicitation + separate internal process memo (evaluation committee + scoring runbook + risk of issuance). Mermaid process-flow + timeline with PNG export. Hand-off to `vendor-evaluation-matrix` for evaluation + `build-vs-buy-analysis` where in-house viable. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `professional` |
| **Audience** | `mixed` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Vendor discovery (RFI)
- Competitive proposal request (RFP)
- Commodity quote (RFQ)
- Re-procurement at contract renewal

## When not to use

- Vendor scoring (evaluation) → `vendor-evaluation-matrix`
- API integration assessment → `third-party-api-evaluation`
- Build-vs-buy → `build-vs-buy-analysis`
- Contract drafting → counsel

---

## Required input

| Field | Description |
|---|---|
| **Intent** | RFI / RFP / RFQ |
| **Use case + must-haves** | What vendor must do |
| **Market** | Shortlist or open |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Budget range** | Disclosed or hidden | Asked |
| **Regulatory** | GDPR / HIPAA / PCI | Asked |
| **Procurement owner** | Person / team | Asked |
| **Target award date** | When | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/rfp-rfi-creation/` |

## Input schema

```
input:
  required:
    intent:
      type: string
      enum: [rfi, rfp, rfq]
    use_case: string
    must_haves: array[string]
    market: string
  optional:
    budget_range: string
    regulatory: array[string]
    procurement_owner: string
    target_award_date: string
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
Intent, use case, market, budget, regulatory, owner, target date, stakeholders.

### Phase 2 — Instrument selection
RFI vs RFP vs RFQ.

### Phase 3 — Common sections
Produce full document structure.

### Phase 4 — Timeline
Realistic, not compressed.

### Phase 5 — Scoring method
Internal runbook.

### Phase 6 — Q&A process
Fair + consolidated.

### Phase 7 — Fairness + diversity
Accessible + inviting smaller vendors.

### Phase 8 — Confidentiality + IP
NDA + proposal handling.

### Phase 9 — Exit criteria
When not to issue.

### Phase 10 — Diagrams
Process flow + timeline.

### Phase 11 — Diagram rendering
Per mixin.

### Phase 12 — Report assembly and approval
Draft + internal memo. Approval before save. Disclaimer present.

---

## Output contract

**Primary:** the solicitation document.

```markdown
# [RFI/RFP/RFQ]: [Subject]

**Issuing org / Date / Deadline / Contact**

## 1. Introduction
## 2. Business Context
## 3. Scope
## 4. Requirements (F-001...)
## 5. Commercial Asks
## 6. Security + Compliance Asks
## 7. SLA Asks
## 8. Implementation + Transition
## 9. Vendor Information
## 10. Response Format + Scoring
## 11. Submission Process
## 12. Terms + Conditions (draft — legal review required)
## 13. Appendices

## Timeline
```

**Secondary:** internal process memo (committee / runbook / Q&A handling / issuance risk / legal checklist).

### Diagrams
- **Process flow** — Mermaid `flowchart TD`
- **Timeline** — Mermaid `timeline`

---

## Assessment and planning policy

- Right instrument
- What-not-how requirements
- Comparable responses
- Disclosed scoring
- Fair Q&A
- Realistic timeline
- Legal flag on T&Cs
- Disclaimer present
- No fabricated policy

---

## Self-check

```
[] Instrument matches intent
[] Business context clear
[] Functional + NFR with IDs
[] Commercial + security + SLA asks
[] Response template
[] Scoring rubric disclosed
[] Q&A process fair
[] Realistic timeline
[] T&C flagged for legal
[] Appendices as needed
[] Disclaimer present
[] Draft + internal memo delivered
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No use case | Interview mode (§7) |
| "Just write the RFP" without reqs | Require functional + NFR |
| Single-vendor RFP | Challenge |
| Compressed timeline | Push back |
| Contract drafting | Decline |
| Vendor scoring | Redirect to `vendor-evaluation-matrix` |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Requirements uniquely IDed
- [ ] Scoring rubric published with weights
- [ ] Response format specified (page limits / template)
- [ ] Q&A uniform-info process clear
- [ ] T&C section marked for legal
- [ ] Accessibility of document verified (not image-only)

---

## Examples

### Normal cases

**1. RFI for CRM market**
- Input: Early stage, need landscape view
- Expected: RFI with business context + open-ended capability questions + vendor profile request; 2-week response

**2. RFP for payments gateway**
- Input: Must-haves defined, need competing proposals
- Expected: Full RFP; functional + NFR + security + SLA detail; 6-week response; scoring rubric

**3. RFQ for cloud compute capacity**
- Input: Defined spec, commodity
- Expected: RFQ against spec; short response; price-first scoring

**4. Regulated healthcare procurement**
- Input: HIPAA + BAA requirement
- Expected: Extensive security + compliance section; BAA flag; legal review priority

**5. Re-procurement at renewal**
- Input: Incumbent + alternatives
- Expected: RFP with transition-out asks; market check; fair treatment of incumbent

### Edge cases

**6. Small-vendor inclusion goal**
- Expected: Page limits modest; submission formats accessible; response template simple

**7. Confidential / restricted market**
- Expected: NDA before full context; redacted version for discovery

**8. Budget disclosure decision**
- Expected: Disclose range if org norm; else explain value-best approach

### Failure cases

**9. Shortlist of one**
- Input: "Write RFP to Stripe"
- Expected: Challenge — sole-source rationale or broaden shortlist

**10. Contract drafting**
- Input: "Write the vendor contract"
- Expected: "Counsel scope; this skill produces solicitations."
