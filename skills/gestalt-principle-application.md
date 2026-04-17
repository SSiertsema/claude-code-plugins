# Gestalt Principle Application — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | gestalt-principle-application |
| **Version** | 1.0.0 |
| **Purpose** | Applies the eight Gestalt principles (proximity, similarity, closure, continuity, common fate, figure-ground, common region, connectedness) as a structured design / audit checklist against a supplied layout or component description. Two modes: `design` (recommend how to apply principles while designing) and `audit` (evaluate an existing design). Per principle produces verdict (applied-well / at-risk / violation / insufficient-detail), evidence from the description, user-perception impact, concrete recommendation (not vague), and priority. For each recommendation, describes current state → proposed change → expected perception change in relative terms. Surfaces principle conflicts (e.g., proximity vs common region competing for grouping) with chosen trade-off. Cross-checks findings under high-contrast, zoom 200%/400%, reduced-motion, color-blind simulation, and screen-reader access. Integrates with Nielsen / Norman heuristics where complementary. Works from text descriptions only — no image analysis. Mermaid verdict distribution and optional priority matrix with PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Design review through a Gestalt lens
- Pre-wireframe or wireframe audit for perceptual grouping issues
- Fixing "looks busy / confusing" feedback with specific principle-grounded actions
- Education + applied review as a team practice

## When not to use

- Full screen layout composition → `wireframing`
- Accessibility conformance audit → `accessibility-requirements`
- Broader UX heuristic review → future `heuristic-evaluation`
- Visual / typography / color system → future Visual/UI design skills
- Image-based analysis (screenshots) — not supported

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Layout / component name |
| **Description** | Text description or structured element list |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Mode** | `design` / `audit` | Inferred |
| **Principles in scope** | Subset of 8 | All 8 |
| **Platform** | web / mobile / desktop | web |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/gestalt-principle-application/` |

## Input schema

```
input:
  required:
    subject:
      type: string
    description:
      type: string | document_reference
  optional:
    mode:
      type: string
      enum: [design, audit]
    principles_in_scope: list[string]
    platform:
      type: string
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
Collect subject + description + mode.

### Phase 2 — Checklist
All 8 principles (or scoped subset).

### Phase 3 — Per-principle analysis
Verdict + evidence + impact + recommendation + priority.

### Phase 4 — Before / after
Per recommendation.

### Phase 5 — Conflict resolution
Principle conflicts + trade-offs.

### Phase 6 — A11y cross-check
High-contrast, zoom, motion, color-blind, SR.

### Phase 7 — Heuristics integration
Nielsen / Norman complementary findings.

### Phase 8 — Diagrams
Verdict distribution + optional priority matrix.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Gestalt Principle Application: [Subject]

**Date**: [date]
**Subject**: [name]
**Mode**: [design / audit]
**Principles in scope**: [list]

## Scope
[Subject, mode, description source, principles]

## Per-principle Analysis
[Principle / verdict / evidence / impact / recommendation / priority]

## Before / After
[Per recommendation]

## Principle Conflicts
[Where principles clash + resolution]

## Accessibility Cross-check
[High-contrast / zoom / motion / color-blind / SR]

## Heuristics Integration
[Complementary findings]

## Diagrams
[Verdict distribution + optional priority matrix]

## Assumptions & Limitations
[Description gaps, `Insufficient-detail`]
```

### Diagrams

- **Verdict distribution** — Mermaid `pie`
- **Priority matrix** — Mermaid `quadrantChart` (optional)

---

## Assessment and generation policy

- Every principle explicitly evaluated
- Honest severity
- Concrete recommendations (relative terms when no pixel data)
- Insufficient-detail acceptable
- Conflicts surfaced
- No fabricated verdicts

---

## Self-check

```
[] All 8 principles evaluated (or in-scope subset)
[] Verdict per principle
[] Evidence per verdict
[] Recommendation for at-risk / violation
[] Before/after
[] Conflicts surfaced
[] A11y cross-check
[] Heuristics integration
[] Diagrams valid
[] No fabricated verdicts
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No description | Interview mode (§7) |
| Insufficient detail | Per-principle `Insufficient-detail` + what's needed |
| Image input requested | Decline — text-only skill |
| All applied-well | Honest praise with specifics |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope (build the design) | "Principles applied; implementation is design / engineering." |

---

## Quality checks

- [ ] All principles evaluated
- [ ] Honest verdicts
- [ ] Concrete recommendations
- [ ] Before/after described
- [ ] Conflicts resolved
- [ ] A11y cross-checked
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Pricing page audit**
- Input: "Three-column pricing cards, all same color, same CTA style; separated by thin vertical lines"
- Expected: Similarity = at-risk (all look identical, hard to differentiate "recommended" plan); Common region = applied-well (vertical lines create bounded regions); Recommendation: highlight recommended plan with background tint + badge + larger CTA to break similarity intentionally.

**2. Form design**
- Input: "Address form: street, city, postal code, country fields in a single column, 16px gap between all"
- Expected: Proximity = at-risk (same spacing doesn't group logically); Continuity = applied-well (single column aligns well); Recommendation: group (street+house) tight, (city+postal+country) tight, larger gap between groups.

**3. Dashboard**
- Input: "KPI cards on top, chart below, table below that, all with same card background"
- Expected: Common region = applied-well; Similarity = at-risk (different types of content feel homogenized); Recommendation: differentiate with subtle elevation or heading weight.

**4. Carousel**
- Input: "Image carousel with dots below, 6 dots for 6 slides"
- Expected: Continuity = applied-well (dots on line); Common fate = consider for transitions between slides; Recommendation (if new design): use sync'd animations between content and active dot.

**5. Grouped icons**
- Input: "Toolbar with 12 icons, all evenly spaced"
- Expected: Proximity = violation (no grouping for cognitively related actions); Recommendation: group related icons (editing / view / share) with small dividers or wider gaps.

### Edge cases

**6. Insufficient detail**
- Input: "The screen shows a form"
- Expected: All principles `Insufficient-detail`; list what's needed (field order, spacing, color, labels, CTA position, grouping intent).

**7. Minimalist design**
- Input: "White background, one button, one line of text"
- Expected: Figure-ground = applied-well; most others N/A due to minimal elements; honest short report.

**8. Mobile vs desktop**
- Input: "Same pricing card layout across mobile and desktop"
- Expected: Note that proximity / common region may fail on mobile due to tighter space; recommend responsive adjustments.

### Failure cases

**9. No description**
- Input: "Check Gestalt"
- Expected: Interview — "Describe the layout or component."

**10. Image input**
- Input: "Here's a screenshot"
- Expected: Decline — "Text descriptions only. Describe the layout or elements."
