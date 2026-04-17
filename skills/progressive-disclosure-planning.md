# Progressive Disclosure Planning — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | progressive-disclosure-planning |
| **Version** | 1.0.0 |
| **Purpose** | Plans layered information architecture for a surface: what appears in the primary layer (L1, always visible), secondary (L2, one-click / tap reveal via accordion / tab / dropdown), on-demand (L3, deeper interaction via modal / bottom sheet / page), and power-user (L4, hidden until opted-in via command palette / shortcut / preference). Classifies every content / control item into a layer with user-segment emphasis (novice / intermediate / expert), chooses reveal mechanism per hidden item (disclosure triangle / tab / tooltip / hover / bottom sheet / modal / new screen / command palette / setting / contextual action menu) with trigger + exit + focus behavior, and ensures every hidden item has a discoverability affordance. Supports implicit adaptation (usage-based), explicit mode (user-chosen), or hybrid approaches. Validates against Nielsen / Norman heuristics (recognition over recall, aesthetic minimalism, real-world match, user control, consistency). Produces Given/When/Then acceptance per segment and per layer. Mermaid layer-composition diagram and optional user-type swimlane with PNG export. |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Crowded or overwhelming surface needs layering
- New surface design: set information hierarchy up-front
- Audit: identify what should be buried deeper or surfaced sooner
- Pre-wireframe: establish hierarchy before committing to layout

## When not to use

- Screen-layout composition → `wireframing`
- Component state → `state-transition-mapping`
- Single interaction → `micro-interaction-design`
- Content voice / tone → future content style skill
- User research / segmentation itself → `customer-segmentation` / `persona-management`

---

## Required input

| Field | Description |
|---|---|
| **Surface** | Named surface / screen / feature |
| **Primary task** | Core task in one sentence |

## Optional input

| Field | Description | Default |
|---|---|---|
| **User segments** | Novice / intermediate / expert or named personas | Inferred / `[Assumed]` |
| **Platforms** | web / mobile / desktop | web |
| **Existing patterns** | Current disclosure approach | Elicit |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/progressive-disclosure-planning/` |

## Input schema

```
input:
  required:
    surface:
      type: string | document_reference
    primary_task:
      type: string
  optional:
    user_segments: list[string]
    platforms: list[string]
    existing_patterns: string
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
Collect surface + primary task.

### Phase 2 — Content inventory
All items with criticality and user.

### Phase 3 — Layer assignment
L1–L4 with rationale.

### Phase 4 — User-type differentiation
Per segment; mode choice.

### Phase 5 — Reveal mechanisms
Per item: mechanism + trigger + exit + focus.

### Phase 6 — Discoverability
Per hidden item.

### Phase 7 — Heuristics check
Nielsen / Norman.

### Phase 8 — Acceptance criteria
Given/When/Then per segment + per layer.

### Phase 9 — Diagrams
Layer composition + optional swimlane.

### Phase 10 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 11 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Progressive Disclosure Plan: [Surface]

**Date**: [date]
**Surface**: [name]
**Primary task**: [task]
**User segments**: [list]

## Scope
[Surface, primary task, segments, platforms, existing patterns]

## Content Inventory
[Item / category / criticality / user]

## Layer Assignment
[L1 / L2 / L3 / L4]

## User-type Differentiation
[Per segment + mode mechanism]

## Reveal Mechanisms
[Per item: mechanism + trigger + exit + focus]

## Discoverability
[How users find hidden content]

## Heuristics Check
[Recognition / minimalist / real-world / control / consistency]

## Acceptance Criteria
[Given/When/Then per segment + per layer]

## Diagrams
[Layer composition + optional swimlane]

## Assumptions & Limitations
[`[Assumed]` segments, platform caveats]
```

### Diagrams

- **Layer composition** — Mermaid `flowchart`
- **User-type swimlane** — Mermaid `flowchart` with subgraphs (optional)

---

## Planning and generation policy

- L1 minimal
- Hidden items discoverable
- Reveal intentional with exit
- User-type aware
- Heuristics validated
- No fabricated research

---

## Self-check

```
[] L1 minimal
[] Hidden items have discoverability
[] Reveals have trigger + exit + focus
[] Segments addressed
[] Mode mechanism chosen
[] Heuristics applied
[] Acceptance criteria per segment
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No surface | Interview mode (§7) |
| L1 overloaded | Push items to L2/L3 |
| Hidden without discoverability | Block — require affordance |
| No segment differentiation | Acceptable if single-segment, noted |
| Mode without exit | Require exit |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] L1 minimal
- [ ] Discoverability
- [ ] Reveal triggers + exits
- [ ] Segments
- [ ] Heuristics
- [ ] Acceptance criteria
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Dashboard for B2B SaaS**
- Input: Analytics dashboard
- Expected: L1 = key KPIs + primary CTA; L2 = filters + date range; L3 = export / share (modal); L4 = saved views + command palette (expert). Novice mode shows L1 + hover tips; expert mode compact L1 + keyboard shortcuts.

**2. Mobile settings**
- Input: App settings screen
- Expected: L1 = frequently-changed (notifications, account); L2 = preferences (accordion); L3 = advanced (nav to page); L4 = developer options (hidden behind 5-tap). Discoverability for hidden via search.

**3. Editor surface**
- Input: Document editor
- Expected: L1 = toolbar core actions + content canvas; L2 = formatting submenus; L3 = styles / templates (sidebar or modal); L4 = command palette + macro recording (Cmd+K).

**4. Onboarding surface**
- Input: First-run product tour
- Expected: Implicit adaptation (hide after N uses); explicit "skip tour" affordance; L1 starts with single focused action; subsequent L2 reveals as user completes.

**5. Admin vs end-user view**
- Input: Multi-role product
- Expected: Segment differentiation driven by role; admin gets L2/L3 elevated to L1; end-user limited set.

### Edge cases

**6. L1 too crowded**
- Input: L1 has 12 elements
- Expected: Push 6 to L2; justify each move; recommend split-view or tabs if still overwhelming.

**7. Power-user feature hidden too deep**
- Input: Keyboard shortcut only, no visual affordance
- Expected: Add Cmd+K palette + ? help overlay; users can find without documentation lookup.

**8. Cross-platform inconsistency**
- Input: Web has bottom-sheet on mobile, modal on desktop
- Expected: Per-platform mechanism choice; consistent trigger label; focus behavior native to each.

### Failure cases

**9. No surface**
- Input: "Plan disclosure"
- Expected: Interview — "Which surface, and what's its primary task?"

**10. Out of scope**
- Input: "Plan disclosure + design the screen"
- Expected: "Disclosure only. Screen layout in `wireframing`."
