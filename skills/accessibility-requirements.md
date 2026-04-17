# Accessibility Requirements — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | accessibility-requirements |
| **Version** | 1.0.0 |
| **Purpose** | Defines accessibility requirements against a named conformance target (default WCAG 2.2 AA; AAA, EN 301 549, EAA, Section 508, ADA, AODA on request). Produces per-feature acceptance criteria in Given/When/Then form across keyboard, focus, screen-reader semantics, contrast, resize, target size (WCAG 2.2), reduced-motion, forms, media (captions/transcripts/AD), timing, language, and error prevention. Builds an assistive-technology support matrix per platform (NVDA/JAWS/VoiceOver/TalkBack/Switch/Voice). Combines automated (axe-core/Pa11y/Lighthouse), manual (keyboard-only, contrast, zoom 200%/400%), and AT-based testing with real AT users per release. For existing products, identifies gaps with severity (blocks/degrades/cosmetic) and remediation priority. Covers governance: accessibility statement, feedback mechanism, training, and conformance-claim process. Disclaimer required — VPAT/ACR work needs a qualified auditor. Mermaid criteria-coverage and remediation-priority diagrams with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Define accessibility requirements before build
- Upgrade existing product to a conformance target (e.g., EAA obligation)
- Input to design / dev / QA with concrete acceptance criteria
- Procurement: understand what an external product must support

## When not to use

- Conformance audit / VPAT / ACR → qualified auditor
- Security / privacy requirements → `security-requirements-classification` / `data-flow-diagramming`
- Performance requirements → `performance-budgeting`

---

## Required input

| Field | Description |
|---|---|
| **Product / feature** | Subject |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Target conformance** | WCAG level / EN 301 549 / EAA | WCAG 2.2 AA |
| **Regulatory drivers** | EAA / ADA / AODA | EAA inferred if EU |
| **Platforms** | web / iOS / Android / desktop | web |
| **Existing state** | Greenfield or remediation | Greenfield |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/accessibility-requirements/` |

## Input schema

```
input:
  required:
    product:
      type: string | document_reference
  optional:
    target_conformance:
      type: string
      enum: [WCAG-2.2-AA, WCAG-2.2-AAA, EN-301-549, EAA, Section-508, ADA, AODA]
      default: WCAG-2.2-AA
    regulatory_drivers: list[string]
    platforms: list[string]
    existing_state: string
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
Collect product + target conformance.

### Phase 2 — Conformance target
Criteria applicable; AAA extras if selected; EN 301 549 if hardware/EU public.

### Phase 3 — Per-feature acceptance criteria
Given/When/Then across criteria classes.

### Phase 4 — AT matrix
Per platform with real AT names.

### Phase 5 — Test plan
Automated + manual + AT + user testing.

### Phase 6 — Remediation (if existing)
Severity + effort + owner + sequence.

### Phase 7 — Governance
Statement + feedback + training + conformance claim.

### Phase 8 — Diagrams
Criteria coverage, optional remediation priority.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report with disclaimer; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Accessibility Requirements: [Product]

**Date**: [date]
**Disclaimer**: Structured requirements. Conformance audit (VPAT/ACR) requires qualified auditor.
**Target conformance**: [standard + level]
**Regulatory drivers**: [list]
**Platforms**: [list]

## Scope
[Product, conformance, regulatory, platforms, state]

## Conformance Target
[Criteria applicable + rationale]

## Per-feature Acceptance Criteria
[Feature → criterion → Given/When/Then]

## Assistive-technology Matrix
[Platform → AT targets]

## Test Plan
[Automated + manual + AT + user]

## Remediation
[Gaps + severity + effort + owner]

## Documentation & Governance
[Statement + feedback + training + claim process]

## Diagrams
[Coverage + remediation priority]

## Assumptions & Limitations
[`[Assumed]` AT; auditor call-out]
```

### Diagrams

- **Criteria coverage** — Mermaid `xychart-beta` (auto vs manual)
- **Remediation priority** — Mermaid `quadrantChart` (severity × effort)

---

## Generation and planning policy

- Conformance target named
- Per-feature Given/When/Then
- AT claims only where verified
- Disclaimer required
- No fabricated conformance claims

---

## Self-check

```
[] Disclaimer
[] Conformance target named
[] Regulatory drivers
[] Per-feature Given/When/Then
[] AT matrix
[] Test plan (all 4 layers)
[] Remediation if existing
[] Governance
[] Diagrams valid
[] No fabricated AT claims
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No product | Interview mode (§7) |
| Conformance unclear | Default WCAG 2.2 AA + `[Assumed]` |
| VPAT/ACR request | Decline — qualified auditor required |
| Platform missing AT | Flag gap |
| Huge gap list | Prioritize + phased remediation |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Disclaimer
- [ ] Conformance named
- [ ] Per-feature Given/When/Then
- [ ] AT matrix
- [ ] Test plan (auto + manual + AT + user)
- [ ] Remediation if existing
- [ ] Governance
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. EU consumer web product**
- Input: Consumer web product, EU market, EAA obligation
- Expected: WCAG 2.2 AA + EN 301 549; per-feature Given/When/Then; AT matrix (NVDA, JAWS, VoiceOver); accessibility statement obligation + feedback mechanism.

**2. Public-sector web**
- Input: EU public-sector site
- Expected: EN 301 549 v3.2 + Directive 2016/2102; conformance statement required; quarterly re-assessment.

**3. Mobile app**
- Input: iOS + Android consumer app
- Expected: WCAG 2.2 AA + platform-specific (iOS VoiceOver / TalkBack); target-size (WCAG 2.2); mobile gestures alternatives.

**4. Upgrade to AAA for specific content**
- Input: "Documentation section to AAA"
- Expected: AAA for that section only; contrast 7:1; sign language for video where applicable; AA elsewhere with transition plan.

**5. Existing product remediation**
- Input: Product with known a11y debt
- Expected: Gap list by severity; phased plan (blocking fixes first); training recommendation; governance added.

### Edge cases

**6. Legacy tech stack limits a11y**
- Input: Old framework with poor ARIA support
- Expected: Flag technical constraint; propose upgrade path; phased workaround with `[Assumed]` AT limitations.

**7. Data visualization**
- Input: Dashboard with charts
- Expected: Alternative text summary, keyboard access, data-table alternative, non-color-dependent patterns; flag complex a11y.

**8. Audio/video-heavy product**
- Input: Streaming / media
- Expected: Captions (open + closed), transcripts, audio description, keyboard-accessible controls; live caption quality standards.

### Failure cases

**9. No product**
- Input: "Accessibility requirements"
- Expected: Interview — "Which product, which target conformance?"

**10. Audit / VPAT**
- Input: "Produce VPAT"
- Expected: Decline — "VPAT/ACR requires a qualified auditor. This skill produces requirements and a remediation plan."
