# Documentation Strategy — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | documentation-strategy |
| **Version** | 1.0.0 |
| **Purpose** | Designs a documentation strategy audience-first (end-users / API consumers / operators / future maintainers / newcomers / leadership / regulators) with distinct needs + intent + success criteria. Adopts Diátaxis framework (four distinct doc types, not mixed: tutorials for learning, how-to guides for task completion, reference for lookup, explanation for understanding) and flags mixing symptoms. Defines information architecture (one entry per audience, progressive disclosure, breadcrumbs, search-first mindset, 404s linking search, user-language titles, consistent glossary, cross-linking, tag taxonomy, version-aware navigation with deprecation markers). Living documentation + docs-as-code (docs near code, API ref from OpenAPI, CI-tested links + code samples + screenshots, PR-reviewed with codeowners, auto-generated where valuable, handwritten where irreplaceable). Review + maintenance (owner per doc, review cadence — quarterly explanations / on-change reference / annual tutorials-with-usage-metrics, staleness alerts on last-reviewed date, deprecation policy, twice-yearly audit to prune). Contribution model (style guide, plain-language principles, template per doc type, contributor guide, recognition). Accessibility + localization (plain language, descriptive links, alt text, video captions + transcripts, semantic headings, color-blind-safe, keyboard-navigable; localization scope decision — tutorials often vs reference rarely, translation pipeline, locale-aware examples). Metrics (traffic, helpfulness, zero-result searches as gap indicators, staleness %, support-deflection, contributor counts). Legal + compliance docs kept separate (privacy / ToS / DPA / cookie / a11y statement / regulatory filings — Legal/DPO owned; product docs cross-reference only). Anti-patterns flagged (giant-docs no audience split, docs+code drift, write-after-launch, stale screenshots, Markdown-dumps-in-Confluence, no owners, internal jargon external, uncaptioned videos). Mermaid Diátaxis quadrants + doc lifecycle with PNG export. Hand-off to `documentation-tooling-selection` for tool choice. |
| **Primary category** | `planning` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `professional` |
| **Audience** | `mixed` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- New product docs strategy
- Existing docs becoming unmaintainable
- Audience confusion (wrong doc for audience)
- Docs-as-code adoption
- Compliance uplift

## When not to use

- Tooling selection → `documentation-tooling-selection`
- Writing the docs themselves → out of scope
- README generation for a specific repo → `readme-generator` plugin

---

## Required input

| Field | Description |
|---|---|
| **Product** | Identifier |
| **Audiences** | Target groups |
| **Current docs state** | None / scattered / excellent-but-aging |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Pain points** | Findability / staleness / wrong-type | Asked |
| **Compliance** | SOC 2 / GDPR | Asked |
| **Existing tooling** | Confluence / Notion / Docusaurus | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/documentation-strategy/` |

## Input schema

```
input:
  required:
    product: string
    audiences: array[string]
    current_state: string
  optional:
    pain_points: array[string]
    compliance: array[string]
    existing_tooling: array[string]
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
Product, audiences, current state, pain, compliance, tooling.

### Phase 2 — Audience map
Needs / intent / success per audience.

### Phase 3 — Diátaxis
Four distinct types.

### Phase 4 — IA
Navigation + findability + versioning.

### Phase 5 — Docs-as-code
CI-tested + reviewed + versioned.

### Phase 6 — Review + maintenance
Owners + cadence + alerts.

### Phase 7 — Contribution model
Style + templates + recognition.

### Phase 8 — Accessibility + localization
Inclusive by default.

### Phase 9 — Metrics
Traffic / helpfulness / zero-results / staleness / deflection.

### Phase 10 — Legal + compliance
Separate from product; Legal/DPO owned.

### Phase 11 — Anti-patterns
Catalog + fixes.

### Phase 12 — Diagrams
Diátaxis quadrants + lifecycle.

### Phase 13 — Diagram rendering
Per mixin.

### Phase 14 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Documentation Strategy: [Product]

**Date**: [date]
**Product**: [...]
**Version**: v1.0

## Scope
## Audience Map
## Diátaxis Framework Adoption
## Information Architecture
## Living Documentation + Docs-as-Code
## Review + Maintenance
## Contribution Model
## Accessibility + Localization
## Metrics
## Legal + Compliance Docs
## Anti-Patterns to Avoid
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Diátaxis quadrants** — Mermaid `quadrantChart`
- **Doc lifecycle** — Mermaid `stateDiagram-v2`

---

## Assessment and planning policy

- Audience-first
- Diátaxis distinct
- Ownership + cadence
- Living docs
- Findability > volume
- Accessibility + localization
- Metrics track impact
- No fabricated audiences

---

## Self-check

```
[] Audience map
[] Diátaxis types
[] IA + navigation
[] Ownership + cadence
[] Living-docs approach
[] Contribution model
[] Accessibility + localization
[] Metrics
[] Legal / compliance separated
[] Anti-patterns
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No audiences | Interview mode (§7) |
| "Write all docs" | Narrow to audiences |
| Diátaxis mixing | Propose split |
| No owners | Assign |
| Tooling question | Hand off |
| mmdc failure | See `diagram-rendering` mixin |
| Write the docs | Out of scope |

---

## Quality checks

- [ ] Each audience has entry point
- [ ] Each doc mapped to one Diátaxis type
- [ ] Owner + review cadence per section
- [ ] CI checks on links + samples
- [ ] A11y + localization addressed
- [ ] Metrics support ownership accountability

---

## Examples

### Normal cases

**1. New SaaS doc site**
- Expected: Audience-mapped + Diátaxis-structured Docusaurus site; API ref auto-generated; tutorials first for activation

**2. Enterprise product**
- Expected: Operator runbooks + admin guides + API ref + regulatory docs separated; owners per section

**3. Open-source library**
- Expected: Tutorial + how-to + reference + explanation; contributor guide; translation pipeline

**4. Internal platform**
- Expected: Backstage TechDocs; audience = internal engineers; SLO dashboards + runbooks prominent

**5. Docs refresh for aging content**
- Expected: Audit; deprecate / archive; owners reassigned; staleness alerts enabled

### Edge cases

**6. Compliance-heavy product**
- Expected: Legal docs strictly separated; audit trail on changes

**7. Multi-product portfolio**
- Expected: Per-product doc spaces + shared platform/common reference; cross-linking policy

**8. Localization decision**
- Input: Global product
- Expected: Localize tutorials + marketing; leave deep reference in English; locale-aware examples

### Failure cases

**9. No audiences specified**
- Input: "Docs strategy"
- Expected: Interview — audiences + current state + pain

**10. Writing request**
- Input: "Write our docs"
- Expected: "Strategy only; writing is out of scope."
