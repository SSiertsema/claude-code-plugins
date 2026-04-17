# Regulatory Landscape Mapping — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | regulatory-landscape-mapping |
| **Version** | 1.0.0 |
| **Purpose** | Maps the regulatory landscape for a product, service, or business across one or more jurisdictions. Produces an inventory of regulations classified by domain (privacy, security, sectoral, payments, content & platforms, AI, consumer, accessibility, employment, ESG, tax, export-control, voluntary industry standards), with per-regulation applicability assessment (Yes / Likely / Possibly / No + rationale), severity of non-compliance (critical / high / medium / low), mandatory-vs-voluntary status, in-force vs upcoming status, and evidence or `[Assumed]` labels. Surfaces overlaps (shared control requirements across regimes), conflicts (contradictory obligations with typical resolutions), and upcoming changes within a 24-month window. Scores net risk (severity × applicability × proximity), recommends prioritization, and points to `control-framework-mapping` and `data-flow-diagramming` for follow-up. Output is structured, not legal advice — a prominent disclaimer is always included. Mermaid diagrams for regulation coverage by jurisdiction, net-risk quadrant, and optional overlaps with PNG export. |
| **Primary category** | `extraction` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- A new product or market entry requires an overview of applicable regulations
- Internal stakeholders need a shared view of the compliance landscape
- Preparation for legal review: structure the landscape before meeting counsel
- Input to risk register, business case, roadmap, or funding decision

## When not to use

- Legal advice / formal compliance determination → qualified legal counsel
- Detailed control implementation → `control-framework-mapping`
- Privacy-specific data flow analysis → `data-flow-diagramming`
- Policy drafting → future policy / documentation skills
- Litigation / enforcement analysis — out of scope

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Product, service, or business to map |
| **Industry** | Sector (healthcare, fintech, SaaS, adtech, platform, public-sector, …) |
| **Jurisdictions** | Country / region list (EU, UK, US, US-CA, AU, …) |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Data sensitivity** | Personal, special category, health, financial, children's, biometric | Inferred |
| **User groups** | B2B / B2C / minors / vulnerable / employees | Inferred |
| **Scale / revenue thresholds** | Triggers like DSA VLOP, DMA gatekeeper, PCI level | Asked if relevant |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/regulatory-landscape/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    industry:
      type: string
    jurisdictions:
      type: list[string]
  optional:
    data_sensitivity:
      type: list[string]
    user_groups:
      type: list[string]
    scale:
      type: object
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

Collect subject, industry, jurisdictions; interview mode (§7) if missing. Detect data sensitivity, user groups, scale. Confirm.

### Phase 2 — Inventory

Inventory regulations by domain. Per regulation: name, jurisdiction, domain, applicability, mandatory/voluntary, severity, status, evidence.

### Phase 3 — Applicability assessment

Per relevant regulation: why it applies, 3–5 key obligations, 3–5 typical controls. Actionable, not paraphrased text.

### Phase 4 — Overlaps and conflicts

- Overlaps: shared control requirements across regimes
- Conflicts: contradictory obligations with typical resolution approach

### Phase 5 — Upcoming changes

Regulations effective within 24 months. Runway + affected parties. Freshness caveat mandatory.

### Phase 6 — Risk overview

Net risk per regulation: severity × applicability × proximity.

### Phase 7 — Roadmap recommendations

Prioritization + shared control opportunities + specialist input needs + downstream skill pointers.

### Phase 8 — Diagrams

- Regulation coverage (flowchart, jurisdictional subgraphs)
- Net risk matrix (quadrantChart)
- Overlaps (flowchart, optional)

### Phase 9 — Diagram rendering

Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval

Full report with disclaimer; present for approval; save only after confirmation.

---

## Output contract

### Report structure

```markdown
# Regulatory Landscape: [Subject]

**Date**: [date]
**Disclaimer**: Structured mapping only. Not legal advice. Verify currency with qualified legal counsel.
**Jurisdictions**: [list]
**Industry**: [sector]

## Scope
[Subject, industry, jurisdictions, data, users, scale]

## Regulation Inventory
[Full table by domain]

## Applicability Assessment
[Per relevant regulation: rationale, obligations, typical controls]

## Overlaps
[Pairs of regimes with shared controls]

## Conflicts
[Pairs with contradictions + resolution]

## Upcoming Changes
[24-month window, runway, affected parties]

## Risk Overview
[Net risk table + matrix diagram]

## Diagrams
[Coverage + net risk + optional overlaps]

## Roadmap Recommendations
[Prioritization + shared controls + specialist input + downstream skills]

## Evidence & Assumptions
[`[Assumed]` items with rationale]

## Limitations
[Freshness caveat, scope bounds, legal-review call-outs]
```

### Diagrams

- **Regulation coverage** — Mermaid `flowchart` with jurisdictional subgraphs
- **Net risk matrix** — Mermaid `quadrantChart`
- **Overlaps** — Mermaid `flowchart` (optional)

---

## Evidence and assessment policy

**Extraction (primary)**:
- Every entry has applicability rationale
- Evidence preserved where supplied; otherwise `[Assumed]` with rationale
- No fabricated laws, dates, fines, or case citations

**Assessment (secondary)** — severity, applicability, net risk:
- Scores justified against supplied context
- Deterministic
- No invented figures

---

## Self-check

```
[] Disclaimer present and prominent
[] Scope stated
[] Inventory covers applicable domains
[] Every entry has applicability rationale
[] Severity, status, mandatory/voluntary labeled
[] Evidence or `[Assumed]` labels present
[] Overlaps identified
[] Conflicts identified with resolution
[] Upcoming changes flagged
[] Net risk scored and diagrammed
[] Roadmap recommendations prioritized
[] Freshness caveat included
[] All diagrams valid
[] No fabricated laws or case citations
[] Pointer to control-framework-mapping and data-flow-diagramming
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject / industry / jurisdiction | Interview mode (§7) |
| Industry too broad | Ask to narrow |
| Jurisdiction unlisted in standard set | Map clearly-applicable regimes; flag local-counsel recommendation |
| User asks "which law do I break" | Decline — not legal advice |
| User asks for specific fines or case law | Do not fabricate; state currency requires current research |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] Disclaimer
- [ ] Scope complete
- [ ] Inventory across domains
- [ ] Severity / status labels
- [ ] Evidence or `[Assumed]`
- [ ] Overlaps & conflicts
- [ ] Upcoming changes
- [ ] Net risk scoring
- [ ] Freshness caveat
- [ ] Diagrams valid
- [ ] No fabricated content

---

## Examples

### Normal cases

**1. EU SaaS with PII**
- Input: B2B SaaS, EU, handles personal data of end-users of customer orgs
- Expected: GDPR + e-Privacy + NIS2 (if covered) + EAA (accessibility) + DSA (if qualifies) + ISO 27001 (voluntary) + SOC 2 (voluntary). Applicability analysis, severity, upcoming EU AI Act if AI used.

**2. US-EU healthcare**
- Input: Telehealth platform, US + EU, health data of patients
- Expected: HIPAA (US) + GDPR + EU Health Data Space (upcoming) + MDR (if classified as device). Conflicts flagged: CLOUD Act vs GDPR transfers.

**3. Fintech EU**
- Input: Payments platform, EU-wide, consumer + merchant facing
- Expected: PSD2/PSD3 + EMD2 + MiCA (if crypto) + PCI-DSS + GDPR + DORA (upcoming). PCI-DSS + ISO 27001 + GDPR security overlap consolidated.

**4. Multi-jurisdiction content platform**
- Input: User-generated content platform, US + EU + UK, minors as users
- Expected: DSA + Online Safety Act + KOSA (US, evolving) + COPPA (US) + GDPR-K. Very high severity on minors; upcoming OSA codes flagged.

**5. Small e-commerce, single jurisdiction**
- Input: NL e-commerce selling own products, no PII beyond order data
- Expected: GDPR + consumer rights (EU CRD) + distance-selling rules + VAT e-invoicing rules + WEEE/PPWR for packaging (if product in scope). Minimal overlap; roadmap simple.

### Edge cases

**6. Emerging jurisdiction**
- Input: African country with evolving data protection
- Expected: Map what is clearly applicable, flag "local-counsel required for current status" explicitly, reference continental standards (e.g., AU Convention on Cyber Security) if relevant.

**7. AI-heavy product**
- Input: Product with AI/ML features, EU + US
- Expected: EU AI Act (tiered by risk classification) + NY AEDT + US state AI laws + sectoral overlays. Applicability depends on use-case; require clarification on "high-risk" vs "limited-risk" classification.

**8. Uncertain industry classification**
- Input: Product that could be classified as medical device or not
- Expected: Flag the classification question; map under two scenarios (MDR in / MDR out) with different severity.

### Failure cases

**9. No jurisdiction**
- Input: "Map regulations for our product"
- Expected: Interview — "Which jurisdictions are you mapping? (e.g., EU, US, UK)"

**10. Legal-advice request**
- Input: "Am I in compliance with GDPR?"
- Expected: Decline — "This skill produces a structured landscape mapping, not a compliance determination. I can map GDPR obligations and typical controls; determining compliance requires qualified legal counsel with access to your specific processing activities, contracts, and measures."
