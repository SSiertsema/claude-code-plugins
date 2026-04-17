# Data Flow Diagramming (Privacy) — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | data-flow-diagramming |
| **Version** | 1.0.0 |
| **Purpose** | Produces a privacy-focused data flow diagram for a system, product, or process. Inventories entities (external entities, processes, data stores, trust boundaries), classifies data categories per flow (identity, contact, account, financial, health, biometric, children's, location, device, behavioral, Art. 9 special-category), assigns GDPR legal basis (Art. 6) and Art. 9 basis where applicable, labels retention and deletion, identifies cross-border transfers with mechanism (adequacy / SCCs / BCRs / derogation), and flags high-risk conditions (international transfers to non-adequate third countries, special-category at scale, children's data, automated decisions with legal effect, large-scale profiling, systematic monitoring, innovative tech, data combining, rights-blocking processing). Produces a Mermaid DFD grouped by trust boundary, an optional cross-border transfer map, and an optional processing risk matrix. Also generates a RoPA-style register (Art. 30) and a retention/deletion check that flags orphan data. Output is structured; compliance determination requires qualified legal review. |
| **Primary category** | `extraction` |
| **Secondary category** | `classification` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Privacy-by-design early step: map what personal data flows through a system
- Pre-DPIA: structure flows and high-risk flags before a Data Protection Impact Assessment
- RoPA (Art. 30) support: feed a processing-activities register
- Third-party-processor assessment: surface which flows go through which processors and under which legal basis
- Input to `regulatory-landscape-mapping` and `control-framework-mapping`

## When not to use

- Legal advice / compliance determination → qualified legal counsel
- Full DPIA → dedicated DPIA process (this skill feeds into it)
- General system architecture → future system-decomposition skill (Phase 5)
- Threat modelling (security-first) → future threat-modeling skill (Phase 5)
- Regulatory landscape overview → `regulatory-landscape-mapping`
- Control framework mapping → `control-framework-mapping`

---

## Required input

| Field | Description |
|---|---|
| **System / product / process** | Subject to map |
| **Data subjects** | Users, employees, patients, minors, etc. |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Jurisdiction** | GDPR / UK GDPR / CCPA / LGPD / ... | GDPR (EU) |
| **Processors / sub-processors** | Known third parties | Inferred / `[Assumed]` |
| **Storage locations** | Countries, providers | Asked |
| **Retention periods** | Per data category | `[Assumed]` with rationale |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/data-flow-diagramming/` |

## Input schema

```
input:
  required:
    system:
      type: string | document_reference
    data_subjects:
      type: list[string]
  optional:
    jurisdiction:
      type: string
      default: GDPR (EU)
    processors:
      type: list[string]
    storage_locations:
      type: list[string]
    retention:
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

Collect system + subjects; interview mode (§7) if missing. Detect jurisdiction, entities, storage, retention. Confirm.

### Phase 2 — Entity inventory

External entities, processes, data stores, trust boundaries with IDs.

### Phase 3 — Data categories

Assign from controlled vocabulary. Special-category and children's data flagged.

### Phase 4 — Flow elicitation

Per flow: from → to, categories, purpose, legal basis (Art. 6), Art. 9 basis if applicable, retention, cross-border transfer mechanism, automated decision flag, third-party role, confidence.

### Phase 5 — High-risk flag analysis

Match flows against 9 high-risk conditions. DPIA likely if ≥1.

### Phase 6 — RoPA register

One row per processing activity (Art. 30 style).

### Phase 7 — Retention & deletion check

Per category: storage, retention, trigger, deletion mechanism. Orphans flagged.

### Phase 8 — Diagrams

- Primary DFD (flowchart with trust-boundary subgraphs)
- Cross-border transfer map (optional)
- Processing risk matrix (optional)

### Phase 9 — Diagram rendering

Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval

Full report with disclaimer; present for approval; save only after confirmation.

---

## Output contract

### Report structure

```markdown
# Data Flow Diagram: [System]

**Date**: [date]
**Disclaimer**: Structured mapping. Not legal advice.
**Jurisdiction**: [GDPR / ...]
**Data subjects**: [categories]

## Scope
[System, subjects, entities, jurisdictions, storage]

## Entity Inventory
[IDs]

## Data Categories in Scope
[Per category]

## Data Flow Diagram
[Primary DFD]

## Flows
[Table: from/to, categories, purpose, legal basis, retention, cross-border, ADM, third party, confidence]

## High-risk Flags
[Per flow + DPIA-required summary]

## RoPA Register
[Per processing activity]

## Retention & Deletion
[Per category; orphans flagged]

## Cross-border Transfers
[Mechanism per transfer; diagram if any]

## Recommendations
[DPIA needs, transfer-mechanism work, retention fixes, processor-contract gaps]

## Evidence & Assumptions
[`[Assumed]` items]

## Limitations
[Freshness, scope, specialist input needs]
```

### Diagrams

- **Primary DFD** — Mermaid `flowchart` with trust-boundary subgraphs and high-risk highlighting
- **Cross-border transfers** — Mermaid `flowchart` (optional)
- **Processing risk matrix** — Mermaid `quadrantChart` (optional)

---

## Extraction and classification policy

**Extraction (primary)**:
- Every entity and flow traceable or `[Assumed]`
- Source references preserved
- Confidence on inferred flows

**Classification (secondary)**:
- Data categories from controlled vocabulary
- Legal basis from Art. 6 controlled values
- Special-category basis from Art. 9 controlled values (required where applicable)

---

## Self-check

```
[] Disclaimer present
[] Scope stated
[] Entities inventoried with IDs
[] Every flow has categories, purpose, legal basis
[] Special-category flows have Art. 9 basis
[] Cross-border transfers have mechanism
[] High-risk flags applied
[] DPIA-required summary present
[] RoPA register built
[] Retention + deletion per category; orphans flagged
[] Evidence or `[Assumed]` labels present
[] All diagrams valid
[] Primary DFD groups by trust boundary
[] No fabricated regulations or mechanisms
[] Recommendations name DPIA + gap-closures
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No system | Interview mode (§7) |
| No data subjects | Ask; propose common categories |
| Architecture unknown | High-level DFD with `[Assumed]` entities; recommend review |
| Purpose unclear | Flag as "undetermined purpose"; no legal basis can be assigned |
| Special-category data without Art. 9 basis | Flag explicitly; do not infer a basis |
| Cross-border transfer without mechanism | Flag as non-compliant-pending-mechanism |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] Disclaimer
- [ ] Entities with IDs
- [ ] Categories per flow
- [ ] Legal basis per flow
- [ ] Art. 9 basis where applicable
- [ ] Cross-border mechanism
- [ ] High-risk flags
- [ ] RoPA register
- [ ] Retention + deletion
- [ ] Orphan flags
- [ ] Diagrams valid
- [ ] No fabricated content

---

## Examples

### Normal cases

**1. SaaS with EU users + US analytics**
- Input: B2B SaaS, EU data subjects, uses Segment + Mixpanel
- Expected: DFD with EU and US trust boundaries, flows to Segment flagged as Art. 28 processor + SCC + DPF, analytics flows classified as behavioral + device, DPIA likely if large-scale profiling present.

**2. Healthcare app**
- Input: Telehealth product, EU patients, stores health records
- Expected: Special-category (Art. 9) data flagged on every medical-data flow, Art. 9 basis options listed (explicit consent vs Art. 9(2)(h) healthcare), DPIA required, retention by record type (typically ≥7 years per member-state rules — flagged for local counsel).

**3. E-commerce with PCI scope**
- Input: DTC e-commerce, EU + US customers, uses Stripe
- Expected: Payment card flows routed via Stripe (Art. 28 processor), PCI scope minimized by tokenization, cross-border to US under SCC + DPF, retention of order data per consumer law.

**4. Employee HR system**
- Input: HRIS with employee data including performance reviews
- Expected: Data subjects = employees, Art. 6(1)(b) contract + Art. 6(1)(c) legal obligation (payroll/tax), Art. 88 GDPR + member-state employment law for performance data, retention tied to employment-law durations.

**5. Children's product**
- Input: Ed-tech for ages 10–14, EU + US
- Expected: Children's data flag on every flow, GDPR-K consent (parental) + COPPA in US, strict retention, profiling/advertising flows either removed or flagged as unlawful under COPPA/DSA.

### Edge cases

**6. Pseudonymized data**
- Input: Analytics events use hashed user ID
- Expected: Flag as personal data (pseudonymization is not anonymization under GDPR); legal basis and retention still required.

**7. Processor chain 3+ deep**
- Input: Main processor → sub-processor → sub-sub-processor in different jurisdictions
- Expected: Chain mapped explicitly; transfer mechanism per hop; Art. 28 flow-through terms required; cross-border matrix highlights multi-hop complexity.

**8. Rights-blocking processing**
- Input: Processing prevents users from opting out
- Expected: Flag as high-risk; DPIA required; recommend rights-preserving alternatives.

### Failure cases

**9. No system**
- Input: "Make a data flow diagram"
- Expected: Interview — "Which system, product, or process would you like to map?"

**10. Out of scope**
- Input: "Map the flows and tell me if we're GDPR compliant"
- Expected: "This skill maps flows with structured labels. Compliance determination requires qualified legal review. I can produce the mapping and flag DPIA needs — the compliance call is yours with counsel."
