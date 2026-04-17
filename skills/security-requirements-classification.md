# Security Requirements Classification — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | security-requirements-classification |
| **Version** | 1.0.0 |
| **Purpose** | Classifies data and functional assets by sensitivity and derives security requirements accordingly. Produces per-asset classification tier (public / internal / confidential / restricted / special-category) with rationale, owner, and regulatory drivers; CIA triad impact score (1–5 per dimension) per asset; a per-tier required-control matrix across authentication, authorization, encryption (rest + transit), audit logging, retention, access review, data masking / tokenization, and monitoring; functional security requirements per operation (authn strength, authz model, rate limiting, input validation, output encoding, idempotency, anti-automation, secrets handling) each with test-how and failure-mode; 3–5 abuse cases per subject with actor / goal / entry point / expected control; and framework mapping per requirement to real control IDs (ISO 27001 / SOC 2 / NIST / CIS / PCI-DSS / HIPAA) feeding `control-framework-mapping`. Explicit compliance drivers per regulatory regime. Disclaimer required — requirements only, not an audit or pentest. Mermaid diagrams for classification × control intensity and optional abuse-case tree with PNG export. |
| **Primary category** | `extraction` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Early in design: produce security requirements before build starts
- Regulated product: map data sensitivity to required controls with rationale
- Pre-procurement: understand which controls are required for a third-party service
- Input to `data-flow-diagramming` (for privacy-sensitive flows) and `control-framework-mapping` (for full control design)

## When not to use

- Security audit / pentest → dedicated audit skills
- Threat modeling → future `stride-threat-modeling` skill
- Privacy flow mapping → `data-flow-diagramming`
- Control-framework mapping itself → `control-framework-mapping`

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Product / feature / service |
| **Data assets** | ≥3 distinct data assets |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Functional assets** | Operations (signup, pay, export, admin) | Elicit |
| **User groups** | Internal / external / admin | Asked |
| **Regulatory regime** | GDPR / HIPAA / PCI / NIS2 / ... | Inferred `[Assumed]` |
| **Org classification conventions** | Custom tier names | Default 5-tier |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/security-requirements/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    data_assets:
      type: list[object]
      min: 3
  optional:
    functional_assets: list[object]
    user_groups: list[string]
    regulatory_regime: list[string]
    classification_tiers: list[string]
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
Collect subject + data assets; interview mode (§7) if missing.

### Phase 2 — Data classification
Tiers + rationale + owner + regulatory drivers.

### Phase 3 — CIA impact
Per asset: C / I / A 1–5 with rationale.

### Phase 4 — Controls per tier
Matrix across authn, authz, encryption, logging, retention, access review, masking, monitoring.

### Phase 5 — Functional requirements
Per operation: requirement + test-how + failure-mode.

### Phase 6 — Abuse cases
3–5 cases with actor / goal / entry / control.

### Phase 7 — Framework mapping
Real control IDs per requirement.

### Phase 8 — Compliance drivers
Per regime: forced requirements.

### Phase 9 — Diagrams
Classification × control intensity, optional abuse-case tree.

### Phase 10 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 11 — Report assembly and approval
Full report with disclaimer; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Security Requirements: [Subject]

**Date**: [date]
**Disclaimer**: Structured requirements. Not a security audit or pentest.

## Scope
[Subject, data assets, functional assets, users, regulatory]

## Data Classification
[Per asset: tier + rationale + owner + regulatory drivers]

## CIA Impact
[C / I / A scores per asset]

## Required Controls per Tier
[Tier × control-area matrix]

## Functional Security Requirements
[Per operation with test-how + failure-mode]

## Abuse Cases
[3–5 cases]

## Framework Mapping
[Per requirement: control IDs]

## Compliance Drivers
[Per regime]

## Diagrams
[Classification × controls + optional abuse-case tree]

## Assumptions & Limitations
[`[Assumed]` regulatory scope; audit call-out]
```

### Diagrams

- **Classification × controls** — Mermaid `quadrantChart`
- **Abuse-case tree** — Mermaid `flowchart` (optional)

---

## Extraction and assessment policy

- Classification traceable
- Controls justified by tier
- Framework IDs real, not invented
- Abuse cases realistic

---

## Self-check

```
[] Disclaimer
[] Assets classified with rationale
[] CIA scored
[] Control matrix per tier
[] Functional requirements with test-how + failure-mode
[] ≥3 abuse cases
[] Real framework control IDs
[] Regulatory drivers surfaced
[] Diagrams valid
[] No fabricated IDs
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject | Interview mode (§7) |
| <3 data assets | Elicit or reject |
| "Are we secure?" request | Decline — requirements only, not audit |
| Unknown regulatory regime | Default reasonable + `[Assumed]` |
| mmdc failure | See `diagram-rendering` mixin |
| Pentest request | Out of scope; pointer to security-audit skill |

---

## Quality checks

- [ ] Disclaimer
- [ ] Tier-based classification
- [ ] CIA per asset
- [ ] Control matrix
- [ ] Functional with test + failure mode
- [ ] Abuse cases realistic
- [ ] Framework IDs real
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. E-commerce product**
- Input: DTC e-commerce with PII + payment card
- Expected: Payment data = Restricted (PCI + tokenization required); PII = Confidential (GDPR); order history = Internal. Abuse cases: card stuffing, account takeover, order-data scraping.

**2. Healthcare platform**
- Input: Telehealth with PHI
- Expected: PHI = Special-category (HIPAA + GDPR Art. 9); BAAs required for processors; audit logs tamper-resistant; 7-year retention per record type.

**3. SaaS admin console**
- Input: Internal admin for B2B SaaS with customer data
- Expected: Admin operations require MFA + just-in-time authz; actions logged with justification; access review monthly.

**4. Public-facing marketing**
- Input: Marketing site, lead form
- Expected: Leads = Confidential (GDPR contact data); minimal controls; consent + retention policy; CAPTCHA on form.

**5. Financial platform**
- Input: Payments + PII + transaction history
- Expected: Payment data = Restricted (PCI); transaction history = Confidential; strong authn + authz; fraud detection as requirement.

### Edge cases

**6. Mixed-sensitivity single asset**
- Input: "User profile" contains public-ish name + sensitive health preference
- Expected: Split the asset into two sub-assets with different tiers; avoid tier-washing.

**7. No regulatory regime declared**
- Input: Greenfield product, unsure of jurisdiction
- Expected: Propose GDPR-equivalent baseline (`[Assumed]` conservative); flag regulatory determination as prerequisite.

**8. Children's data**
- Input: Product intended for users under 16
- Expected: Children's data = Special-category; GDPR-K + COPPA (if US); parental consent; processing-minimization; no profiling / advertising.

### Failure cases

**9. No subject or data assets**
- Input: "Give me security requirements"
- Expected: Interview — "Which subject, and what are the key data assets?"

**10. Audit request**
- Input: "Audit our security"
- Expected: Decline — "This skill produces requirements. For an audit, use a security-audit skill or qualified auditor."
