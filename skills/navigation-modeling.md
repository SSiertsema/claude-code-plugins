# Navigation Modeling — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | navigation-modeling |
| **Version** | 1.0.0 |
| **Purpose** | Designs the navigation system for a site or app — how page hierarchy is exposed to users. Selects a pattern from hub-and-spoke, hierarchical (drill-down), flat, faceted (filter-based), sequential (wizard), or hybrid based on content scope and product type. Per applicable navigation area (primary / secondary / utility / contextual / footer) produces: location convention, item count range, label language (from `taxonomy-design` if supplied), cardinality rules, platform-specific adaptations. Per navigation item: stable ID, label, destination (linked to `site-mapping`), position, platform scope, visibility rules (always / authenticated / role / feature-flag), active-state trigger. State behavior complete per item type (default / hover / focus / active via `aria-current` / disabled / loading for submenus). Mobile treated as first-class with per-area desktop-vs-mobile comparison (bottom tabs vs top bar, drill-down vs sub-nav, expandable search, bottom sheets). Accessibility: landmark roles with unique aria-labels per nav, skip links, keyboard-complete with logical tab order, `aria-expanded` on dropdowns, target size ≥24×24 CSS px, contrast ≥4.5:1 text / ≥3:1 focus indicator. Wayfinding signals: breadcrumbs, active-state, H1 match, URL convention, progress indicator. Transitions + persistence rules (sticky / collapsing / session / cross-device / reduced-motion). Mermaid diagrams for nav system overview, state behavior, and mobile-vs-desktop comparison with PNG export. |
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

- Greenfield product navigation design
- Nav restructure when site has grown / content has shifted
- Mobile-first redesign of existing desktop-primary nav
- Adding new nav area (e.g., utility nav) to existing product
- Accessibility-driven nav redesign
- Pairs with `site-mapping` (hierarchy) and `taxonomy-design` (labels)

## When not to use

- Site hierarchy / page inventory → `site-mapping`
- Taxonomy of content → `taxonomy-design`
- Individual micro-interaction in nav (e.g., how a dropdown animates) → `micro-interaction-design`
- Screen-layout composition → `wireframing`
- User flow through a task → `user-flow-diagramming`

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Site / app |
| **Content scope** | Page count or `site-mapping` reference |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Platforms** | web-desktop / web-mobile / iOS / Android | web + mobile |
| **User segments** | admin / end-user / multi-role | single-segment |
| **Existing pattern** | Current navigation approach | Elicit |
| **Breakpoints** | Responsive breakpoint set | Asked |
| **Taxonomy reference** | `taxonomy-design` output for labels | None |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/navigation-modeling/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    content_scope:
      type: string | document_reference
  optional:
    platforms: list[string]
    user_segments: list[string]
    existing_pattern: string
    breakpoints: object
    taxonomy_reference: document_reference
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
Collect subject + content scope + platforms.

### Phase 2 — Pattern selection
Hub-spoke / hierarchical / flat / faceted / sequential / hybrid per content fit.

### Phase 3 — Navigation areas
Primary / secondary / utility / contextual / footer as applicable.

### Phase 4 — Per-item spec
ID / label / destination / position / visibility / active-state.

### Phase 5 — State behavior
Default / hover / focus / active / disabled / loading per item type.

### Phase 6 — Accessibility
Landmarks / skip / aria-current / keyboard / target / contrast.

### Phase 7 — Wayfinding signals
Breadcrumbs / active state / H1 / URL / progress.

### Phase 8 — Transitions + persistence
Scroll / session / cross-device / motion.

### Phase 9 — Diagrams
Nav system + state + mobile-vs-desktop.

### Phase 10 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 11 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Navigation Model: [Subject]

**Date**: [date]
**Pattern**: [chosen]
**Platforms**: [list]

## Scope
[Subject, content, platforms, segments, breakpoints]

## Pattern Selection
[Rationale]

## Navigation Areas
[Primary / Secondary / Utility / Contextual / Footer]

## Per-item Specification
[Table]

## State Behavior
[Per item type]

## Mobile Adaptation
[Desktop vs mobile per area]

## Accessibility
[Landmarks / skip / aria-current / keyboard / contrast / target]

## Wayfinding Signals
[Breadcrumbs / active / H1 / URL / progress]

## Transitions & Persistence
[Scroll / session / cross-device / motion]

## Diagrams
[System + state + mobile-vs-desktop]

## Assumptions & Limitations
[Grounding gaps]
```

### Diagrams

- **Nav system overview** — Mermaid `flowchart` with subgraphs per area
- **State behavior** — Mermaid `flowchart` or `stateDiagram-v2`
- **Mobile vs desktop** — Mermaid `flowchart` two columns

---

## Generation and planning policy

- Pattern grounded in scope
- Mobile first-class
- A11y required
- No fabricated items

---

## Self-check

```
[] Pattern with rationale
[] Areas per scope
[] Per-item complete
[] State behavior complete
[] Mobile adaptation
[] A11y full
[] Wayfinding
[] Transitions + persistence
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject / scope | Interview mode (§7) |
| No site-map | Work from described pages; flag gaps |
| Pattern mismatch | Recommend alternative |
| Mobile as afterthought | Require per-platform spec |
| A11y missing | Block |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out-of-scope |

---

## Quality checks

- [ ] Pattern fit
- [ ] All applicable areas
- [ ] Per-item spec
- [ ] State behavior
- [ ] Mobile adaptation
- [ ] A11y
- [ ] Wayfinding
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. E-commerce (faceted)**
- Input: 1500-product DTC site
- Expected: Faceted pattern for catalog, hierarchical for help, flat for marketing. Primary nav top bar with mega-menu on Products. Mobile: hamburger + search + cart persistent bottom.

**2. SaaS dashboard (hybrid)**
- Input: Multi-tenant SaaS
- Expected: Sidebar nav (primary for authenticated), top bar (utility — account, notifications, help), contextual in-page tabs. Mobile: bottom tabs for primary (3 tabs), drawer for rest.

**3. Marketing site (flat)**
- Input: 12-page marketing site
- Expected: Flat top nav (6 items), footer with legal + company + support. Mobile: hamburger, same 6 items.

**4. Documentation (hierarchical)**
- Input: Docs with ~200 pages, 3 levels deep
- Expected: Sidebar nav hierarchical, version selector top, search persistent. Mobile: search-first, drawer for tree.

**5. Multi-role app**
- Input: Admin + end-user + support-agent roles
- Expected: Per-role visibility rules; admin sees more primary items; end-user focused on 4 core; support has dedicated utility area.

### Edge cases

**6. Content volume mismatch**
- Input: 200 pages, user says "flat nav"
- Expected: Surface mismatch — flat won't fit; propose hierarchical or hybrid; explain trade-off.

**7. Mobile has different primary tasks**
- Input: Desktop = browsing-heavy, mobile = transactional
- Expected: Different primary nav per platform; rationale stated; persistent utility differs.

**8. Progressive web app with offline**
- Input: PWA with offline queue
- Expected: Offline indicator in utility; queued-action counter; graceful degradation rules in transition spec.

### Failure cases

**9. No subject / scope**
- Input: "Design nav"
- Expected: Interview — "Which subject, and content scope?"

**10. Implementation request**
- Input: "Design + code the navigation"
- Expected: "Design only; implementation is engineering."
