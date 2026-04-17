# Documentation Tooling Selection — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | documentation-tooling-selection |
| **Version** | 1.0.0 |
| **Purpose** | Selects documentation tooling to realize the adopted strategy. Categories: static site generators for docs-as-code (Docusaurus / MkDocs Material / Astro Starlight / Nextra / VitePress / Hugo / Jekyll / Sphinx); developer portals (Backstage TechDocs / Port / Cortex / OpsLevel); wikis + KBs (Confluence / Notion / Outline / GitBook); API reference tools (Redoc / Scalar / Stoplight / Swagger UI / Postman Docs / Mintlify / ReadMe); learning platforms (Docebo / TalentLMS / Moodle or lightweight Docusaurus tutorial section). Evaluation criteria (weights agreed + sum 100): docs-as-code fit (15), versioning (10), search (10), localization (5), authoring UX (10), publishing pipeline (10), theming + extensibility (10), plugin ecosystem (5), performance + scale (5), cost — license + ops (10), lock-in + exit (10). 1–5 scoring with evidence; vendor claims marked `[unverified]`. Per-audience recommendation (external users → Docusaurus/Astro + Redoc; API consumers → Docusaurus + Redoc/Scalar; internal devs → Backstage TechDocs; operators → runbook repo; business → Confluence/Notion). Hybrid stacks acceptable when content-type authority stays clear. Publishing pipeline specification (Git-sourced or DB-sourced, CI build + preview on PR, link + code-sample CI checks, auto-deploy, versioned releases, CDN). Integration baseline (SSO, search via Algolia DocSearch/Typesense/Meilisearch, analytics respecting GDPR, feedback widget, translation pipeline Crowdin/Lokalise, issue-tracker links, OpenAPI/proto auto-gen, Mermaid/PlantUML diagrams). Lock-in + exit analysis (Markdown portable, verify full export, migration-cost estimate, Git-based content = easy swap). Mermaid tool-fit radar + content-authority-per-audience with PNG export. Hand-off to `documentation-strategy` for strategy, general migration planning for cut-over. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |
| **Evidence mode** | `required` |

---

## When to use

- After `documentation-strategy` completion
- Replacing or consolidating existing tooling
- New product doc-site build

## When not to use

- Strategy itself → `documentation-strategy`
- Writing docs → out of scope
- Full migration planning → dedicated migration skill

---

## Required input

| Field | Description |
|---|---|
| **Strategy reference** | Output of `documentation-strategy` or equivalent |
| **Content types** | Docs site / API ref / wiki / dev portal / LMS |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Existing stack** | Tools in use | Asked |
| **Hosting** | SaaS / on-prem / cloud self-host | Asked |
| **Compliance** | Residency / auth / audit | Asked |
| **Budget** | License + ops | Asked |
| **Scale** | # docs / authors / traffic | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/documentation-tooling-selection/` |

## Input schema

```
input:
  required:
    strategy_reference: string
    content_types: array[string]
  optional:
    existing_stack: array[string]
    hosting: string
    compliance: array[string]
    budget: string
    scale: object
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
Strategy, content types, stack, hosting, compliance, budget, scale.

### Phase 2 — Tool categories
Static generators / dev portals / wikis / API ref / LMS.

### Phase 3 — Evaluation criteria
Weights sum 100.

### Phase 4 — Per-audience recommendation
Default fits + hybrid.

### Phase 5 — Publishing pipeline
CI + preview + deploy + CDN.

### Phase 6 — Integrations
SSO + search + analytics + feedback + translation + tracker + API autogen + diagram.

### Phase 7 — Lock-in + exit
Formats + export + migration cost.

### Phase 8 — Recommendation
Primary per audience + trade-offs + exit plan.

### Phase 9 — Diagrams
Tool fit + authority map.

### Phase 10 — Diagram rendering
Per mixin.

### Phase 11 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Documentation Tooling Selection: [Product]

**Date**: [date]
**Strategy reference**: [...]
**Recommended primary**: [...]

## Scope
## Tool Categories Considered
## Evaluation Criteria + Weights
## Scoring Matrix
## Per-Audience Recommendation
## Publishing Pipeline
## Integrations
## Lock-in + Exit
## Recommendation
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Tool fit heatmap** — Mermaid `xychart-beta`
- **Authority per audience** — Mermaid `graph LR`

---

## Assessment and planning policy

- Strategy-driven
- Weights agreed
- Evidence per score
- Lock-in + exit analyzed
- Hybrid clear authorities
- No fabricated features

---

## Self-check

```
[] Strategy cited
[] Categories mapped
[] Weights 100
[] Evidence per score
[] Publishing pipeline
[] Integrations listed
[] Lock-in analyzed
[] Hybrid authorities clear
[] Recommendation + trade-offs
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No strategy | Hand off to `documentation-strategy` |
| Single-tool demand without fit | Challenge |
| Vendor marketing | Mark `[unverified]` |
| Migration request | Hand off |
| mmdc failure | See `diagram-rendering` mixin |
| Authoring request | Out of scope |

---

## Quality checks

- [ ] Tool category fits content types
- [ ] Scores sourced from evidence
- [ ] Hybrid authorities clear
- [ ] CI + preview + deploy concrete
- [ ] Integrations span SSO + search + analytics
- [ ] Exit cost estimated

---

## Examples

### Normal cases

**1. External SaaS docs + API ref**
- Expected: Docusaurus + Redoc; Algolia DocSearch; versioning; i18n; Git-sourced

**2. Internal platform docs**
- Expected: Backstage TechDocs; Markdown per repo; catalog-aware; SSO

**3. Enterprise with Confluence**
- Expected: Keep Confluence for business; add Docusaurus for developer-facing; cross-link boundaries

**4. API-first product**
- Expected: Stoplight or Scalar for API + examples + SDK docs; separate tutorial Docusaurus

**5. Legacy refresh**
- Expected: Migrate from older tool; scorecard + exit cost + phased migration

### Edge cases

**6. Compliance-heavy on-prem**
- Expected: MkDocs Material self-hosted + SSO + audit log; avoid SaaS where data residency requires

**7. Multi-product portfolio**
- Expected: Per-product Docusaurus with shared theme + root landing; consistent IA

**8. Non-technical authors**
- Expected: Notion / Confluence for those authors; Markdown docs-as-code for engineering content

### Failure cases

**9. No strategy**
- Input: "Pick a tool"
- Expected: Hand off to `documentation-strategy` first

**10. Migration execution**
- Input: "Migrate our Confluence to Docusaurus"
- Expected: Selection only; migration execution out of scope
