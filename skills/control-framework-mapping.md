# Control Framework Mapping — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | control-framework-mapping |
| **Version** | 1.0.0 |
| **Purpose** | Maps existing or planned controls for a scope against one or more control frameworks (ISO 27001 Annex A, SOC 2 TSC, NIST CSF, NIST 800-53, CIS v8, PCI-DSS v4, HIPAA Security Rule, NIS2, ISO 27701, ISO 42001). Produces a framework clause inventory, a control inventory with owner / type / maturity (1–5) / evidence source type, a mapping matrix (control × framework), coverage counts and gaps per framework, a gap analysis with recommended controls and effort, maturity scoring per domain, and cross-framework consolidation that surfaces high-leverage controls (satisfying ≥5 cells across frameworks). Mermaid diagrams for coverage heatmap, cross-framework leverage, and optional maturity chart with PNG export. Output is structured mapping; certification requires a qualified auditor. |
| **Primary category** | `extraction` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Preparing for ISO 27001 / SOC 2 / NIST / PCI / HIPAA certification or attestation
- Consolidating controls across multiple frameworks to avoid duplicate work
- Running a gap analysis against a target framework before deeper compliance work
- Scoring maturity to set a baseline and a roadmap
- Feeding a GRC tool or audit preparation with structured content

## When not to use

- Certified audit / attestation opinion → qualified auditor
- Regulatory landscape overview → `regulatory-landscape-mapping`
- Privacy flow mapping → `data-flow-diagramming`
- Security architecture / threat modelling → future Phase 5 skills
- Policy drafting → future documentation skills

---

## Required input

| Field | Description |
|---|---|
| **Scope** | Organization, system, or service to map |
| **Target frameworks** | ≥1 from the supported set |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Current controls** | Inventory or references | Elicit top controls via interview |
| **Evidence sources** | Policy / config / log / ticket / attestation / audit | `[Assumed]` unless supplied |
| **Maturity model** | 1–5 scale | 1–5 |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/control-framework-mapping/` |

## Input schema

```
input:
  required:
    scope:
      type: string | document_reference
    target_frameworks:
      type: list[string]
      enum_values: [ISO-27001, SOC-2, NIST-CSF, NIST-800-53, CIS-v8, PCI-DSS-v4, HIPAA-Security-Rule, NIS2, ISO-27701, ISO-42001]
  optional:
    current_controls:
      type: list[object]
      properties:
        id: string
        name: string
        description: string
        owner: string
        type: string
        maturity: integer
        evidence_source_type: string
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

Collect scope + target frameworks; interview mode (§7) if missing. Detect current controls, evidence sources, maturity model.

### Phase 2 — Framework clause inventory

Per framework: list in-scope clauses with real IDs. No paraphrase of regulatory text.

### Phase 3 — Control inventory

Per control: ID, name, description, owner, type (Preventive / Detective / Corrective / Directive / Compensating), maturity 1–5, evidence source type.

### Phase 4 — Mapping

Matrix control × framework with `(partial)` and `(compensating)` flags where applicable. No invented framework IDs.

### Phase 5 — Coverage

Per framework: covered / partial / not covered counts with lists.

### Phase 6 — Gap analysis

Per gap: clauses affected, why it matters, recommended control, effort estimate. Prioritized by cross-framework impact.

### Phase 7 — Maturity scoring

Per domain or per control: score 1–5 with justification.

### Phase 8 — Cross-framework consolidation

Flag controls serving ≥5 framework cells. Centralized evidence opportunities.

### Phase 9 — Recommendations

Quick wins, evidence consolidation, tooling, 3–6 month roadmap.

### Phase 10 — Diagrams

Coverage heatmap, cross-framework leverage flowchart, optional maturity chart.

### Phase 11 — Diagram rendering

Per `diagram-rendering` mixin.

### Phase 12 — Report assembly and approval

Full report with disclaimer; present for approval; save only after confirmation.

---

## Output contract

### Report structure

```markdown
# Control Framework Mapping: [Scope]

**Date**: [date]
**Disclaimer**: Structured mapping. Not a certified audit.
**Target frameworks**: [list]

## Scope
[Boundary, frameworks, maturity model]

## Framework Clause Inventory
[Per framework]

## Control Inventory
[Per control: ID, name, description, owner, type, maturity, evidence source type]

## Mapping Matrix
[Control × framework]

## Coverage
[Per framework: counts + gap lists]

## Gap Analysis
[Per gap: clauses, impact, recommended control, effort]

## Maturity Scoring
[Per domain: score + justification]

## Cross-framework Consolidation
[High-leverage controls + diagram]

## Recommendations
[Quick wins, evidence consolidation, tooling, roadmap]

## Evidence & Assumptions
[`[Assumed]` items]

## Limitations
[Framework-version caveats, specialist-input needs]
```

### Diagrams

- **Coverage heatmap** — Mermaid `xychart-beta`
- **Cross-framework leverage** — Mermaid `flowchart`
- **Maturity chart** — Mermaid `xychart-beta` (optional)

---

## Extraction and assessment policy

**Extraction (primary)**:
- Framework IDs must be real
- Controls mapped with confidence labels
- Evidence source types only (never fabricated evidence)

**Assessment (secondary)**:
- Gaps named honestly
- Maturity justified
- Deterministic

---

## Self-check

```
[] Disclaimer present
[] Scope + frameworks stated
[] Clause inventory uses real IDs
[] Control inventory complete
[] Mapping matrix with partial/compensating flags
[] Coverage counts per framework
[] Gap analysis with clauses + recommended control + effort
[] Maturity scored with justification
[] High-leverage (≥5 cells) controls flagged
[] Recommendations include quick wins + roadmap
[] All diagrams valid
[] No fabricated framework IDs or evidence
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No scope / framework | Interview mode (§7) |
| Framework not in known set | Flag; proceed with caveat |
| No current controls | Produce recommended starter set + baseline mapping |
| Certification opinion requested | Decline — not an audit |
| Evidence content requested | Mark evidence type only |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] Disclaimer
- [ ] Real framework IDs
- [ ] Control inventory complete
- [ ] Mapping with flags
- [ ] Coverage and gaps per framework
- [ ] Gap analysis with recommendations
- [ ] Maturity scoring
- [ ] High-leverage controls flagged
- [ ] Diagrams valid
- [ ] No fabricated content

---

## Examples

### Normal cases

**1. SaaS targeting SOC 2 + ISO 27001**
- Input: B2B SaaS scope, SOC 2 Type II + ISO 27001
- Expected: ~30 ISO clauses + ~33 SOC 2 criteria inventoried, 20 controls mapped, 8 gaps (e.g., formal risk register, vendor management program, IR tabletop), cross-framework leverage on access / logging / encryption.

**2. Fintech adding PCI-DSS**
- Input: Existing ISO 27001-certified fintech adding PCI-DSS v4
- Expected: 60%+ PCI coverage via existing ISO controls; gaps around PCI-specific (SAQ scope, cardholder data environment segmentation, quarterly ASV scans); recommendations lean on existing ISO evidence.

**3. Healthcare + HIPAA + SOC 2**
- Input: Telehealth provider, HIPAA Security Rule + SOC 2 HIPAA-aware
- Expected: HIPAA admin/physical/technical safeguards mapped, SOC 2 CC-series mapped, overlap on access/audit/encryption, gaps on BAAs with sub-processors.

**4. NIST CSF baseline for public-sector**
- Input: Public-sector org, NIST CSF as baseline
- Expected: 5-function inventory (Identify / Protect / Detect / Respond / Recover), controls mapped, domain-level maturity (e.g., Detect = 2, Respond = 3), roadmap to bring Detect to 3.

**5. NIS2 applicability**
- Input: EU energy-sector entity, NIS2
- Expected: Map to NIS2 cybersecurity risk-management measures (Art. 21), governance + incident-reporting obligations flagged, cross-framework leverage with ISO 27001 extensive.

### Edge cases

**6. Multi-framework with conflicting maturity**
- Input: Org has ISO 27001 at maturity 4 but CIS at 2 (because CIS covers endpoints which aren't well-managed)
- Expected: Maturity varies per domain, not a single org-level number; report per domain; roadmap prioritizes endpoint hardening.

**7. Starter set request**
- Input: No existing controls, targeting SOC 2
- Expected: Produce recommended starter set of ~25 controls covering SOC 2 CC1–CC9 + relevant TSC categories, labeled `[Recommended]`, mapped to future SOC 2 criteria, effort estimated.

**8. Framework version mismatch**
- Input: PCI-DSS v3.2.1 history and moving to v4
- Expected: Flag version transition; map to v4 requirements; highlight new controls (e.g., customized approach, MFA extensions).

### Failure cases

**9. No scope or framework**
- Input: "Map some controls"
- Expected: Interview — "Which scope and which frameworks should I map?"

**10. Certification opinion**
- Input: "Am I SOC 2 compliant?"
- Expected: Decline — "This skill produces a structured mapping. SOC 2 attestation requires an independent auditor. I can map your controls to the TSC, identify gaps, and produce a readiness view — that feeds an auditor engagement."
