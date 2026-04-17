# Site Mapping — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | site-mapping |
| **Version** | 1.0.0 |
| **Purpose** | Designs a hierarchical site map for a web or app product in one of three modes: `autonomous` (propose structure from product scope), `inventory` (structure a supplied page list), `audit` (assess an existing site). Produces a page inventory with stable IDs, page type (entry / hub / detail / list / funnel / utility / legal / error), parent-child hierarchy (single root, max depth ceiling default 4), declared URL pattern per page with a consistent convention (kebab-case, plural for collections), access levels (public / authenticated / role-based), primary navigation placement (main / secondary / footer / utility / contextual / hidden), entry points, key actions, and related-page cross-links. Surfaces orphan pages, near-duplicate pages, dead ends, and depth violations explicitly. Mermaid site-map tree and optional depth-distribution diagrams with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Designing a new web / app product's page structure
- Restructuring an existing site (audit mode)
- Formalizing an inventory handed over from another tool (CMS export, Figma, spreadsheet)
- Input to navigation design, URL planning, SEO strategy, routing setup

## When not to use

- Wireframe / screen layout design → `wireframing`
- User flow diagramming → `user-flow-diagramming`
- Taxonomy of content categories → future `taxonomy-design` skill
- Navigation modeling in depth → future `navigation-modeling` skill
- Content audit → future `content-inventory-audit`

---

## Required input

| Field | Description |
|---|---|
| **Product** | Web or app product |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Mode** | `autonomous` / `inventory` / `audit` | `autonomous` |
| **Page list / source** | Existing inventory or CMS export | Elicit |
| **Depth ceiling** | Max hierarchy depth | 4 |
| **URL convention** | Casing + plural + nesting rules | kebab-case, plural for collections |
| **Access levels** | public / authenticated / roles | public + authenticated |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/site-mapping/` |

## Input schema

```
input:
  required:
    product:
      type: string | document_reference
  optional:
    mode:
      type: string
      enum: [autonomous, inventory, audit]
      default: autonomous
    page_source: list | document_reference
    depth_ceiling:
      type: integer
      default: 4
    url_convention: object
    access_levels: list[string]
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
Collect product + mode.

### Phase 2 — Page types
Apply controlled type vocabulary.

### Phase 3 — Page inventory
Stable IDs + metadata per page.

### Phase 4 — Hierarchy rules
Single root, max depth, parent required.

### Phase 5 — Orphan / redundancy / dead-end detection
Surface explicitly.

### Phase 6 — Navigation placement
Per page: nav area.

### Phase 7 — URL patterns
Consistent convention.

### Phase 8 — Diagrams
Site map tree + optional depth distribution.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Site Map: [Product]

**Date**: [date]
**Mode**: [mode]
**Depth ceiling**: [N]
**Total pages**: [N]

## Scope
[Product, mode, ceiling, URL convention, access levels]

## Page Inventory
[Full table]

## Hierarchy
[Tree diagram]

## Navigation Placement
[Matrix]

## URL Patterns
[Convention + per-page patterns]

## Orphans
[List]

## Redundancy
[Consolidation recommendations]

## Depth Violations
[Pages + path]

## Dead Ends
[Leaves with no outgoing]

## Diagrams
[Site map + optional depth]

## Assumptions & Limitations
[`[Assumed]` / elicitation gaps]
```

### Diagrams

- **Site map tree** — Mermaid `flowchart`
- **Depth distribution** — Mermaid `xychart-beta` (optional)

---

## Generation and planning policy

- Stable IDs across revisions
- Controlled type vocabulary
- Consistent URL convention
- Surface orphans / redundancy / depth
- No fabricated pages beyond `[Proposed]` labeling

---

## Self-check

```
[] Stable IDs
[] Every page typed
[] Single root, parent per page
[] Depth ≤ ceiling (violations flagged)
[] URL convention declared
[] Access levels per page
[] Nav placement per page
[] Orphans listed
[] Redundancy flagged
[] Dead ends identified
[] Diagrams valid
[] No fabricated pages (beyond `[Proposed]`)
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No product | Interview mode (§7) |
| Unclear page count | Autonomous proposal labeled `[Proposed]` |
| Depth violation | Flag + recommend redesign or note |
| Flat inventory | Propose grouping, confirm |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | "Structure only; CMS implementation is engineering." |

---

## Quality checks

- [ ] Stable IDs
- [ ] Typed pages
- [ ] Hierarchy correct
- [ ] URL convention consistent
- [ ] Access levels
- [ ] Nav placement
- [ ] Orphans / redundancy / dead ends
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. E-commerce autonomous**
- Input: DTC e-commerce product
- Expected: Home → Products hub → Category hubs → Detail; account utility; legal footer; checkout funnel; ~25 pages at depth ≤ 4.

**2. SaaS app**
- Input: B2B SaaS dashboard
- Expected: Dashboard (hub) → domain hubs (projects, settings) → detail / list pages; auth-gated; admin-role pages flagged; onboarding funnel separate.

**3. Audit of existing site**
- Input: 120-page legacy site export
- Expected: Types assigned, 12 orphans found, 5 depth-5 violations, 8 near-duplicate page pairs, consolidation roadmap.

**4. Inventory mode**
- Input: Figma site-map export (60 pages)
- Expected: Structure given list, flag type inconsistencies, recommend renames for URL consistency.

**5. Small marketing site**
- Input: 10-page marketing site
- Expected: Flat-ish hierarchy (depth 2–3), clear entry pages, footer legal group, minimal funnel.

### Edge cases

**6. Deep legacy CMS**
- Input: Existing site with depth 7+
- Expected: Flag violations, propose restructure with 3-tier model, migration-risk note.

**7. Multi-brand**
- Input: Parent company hosting multiple sub-brands
- Expected: Multi-root proposal OR single-root with brand as L1 hub; surface trade-offs (SEO, nav, separation).

**8. Micro-app within larger portal**
- Input: Small feature-set under a larger portal
- Expected: Map scope bounded; point out where parent portal structure dictates constraints; limited URL flexibility.

### Failure cases

**9. No product**
- Input: "Make a site map"
- Expected: Interview — "Which product, and what mode (autonomous / inventory / audit)?"

**10. Out of scope**
- Input: "Site map + build the CMS"
- Expected: "Structure only. CMS implementation is engineering work."
