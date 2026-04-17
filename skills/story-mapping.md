# Story Mapping — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | story-mapping |
| **Version** | 1.0.0 |
| **Purpose** | Builds a Jeff Patton-style user story map: a horizontal backbone of user activities left-to-right (narrative), vertical sub-stories / tasks below each activity ordered by priority top-to-bottom, and release slices cutting across as horizontal cuts. Produces 4–10 backbone activities (user verbs, not features), 3–7 tasks per activity, user stories under each task in "As a / I want / so I can" form, and 2–3 releases (walking skeleton = top row end-to-end, thickening releases deeper coverage). Surfaces narrative gaps (missing steps), over-detail (one column with too many tasks), orphan stories, under-prioritization, and walking-skeleton infeasibility (where top-row stories don't connect end-to-end). Optional overlays for persona variants, platform scope, risk, and dependencies. Feeds `user-story-generator` / existing backlog for detailed stories + AC, and `planning-poker-protocol` + `story-point-estimation` for sizing. Mermaid story-map flowchart + release-slicing markdown table with PNG export. |
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

- Discovery / shaping phase: translate user journey into actionable backbone + stories
- Release planning: slice product into walking skeleton + thickening releases
- Backlog alternative that preserves narrative (unlike flat list)
- Cross-team alignment on "what are we building" before sprint planning
- Upstream of detailed story writing

## When not to use

- Strategic user journey with emotions → `user-journey-management`
- UI-task-level user flow → `user-flow-diagramming`
- Individual stories / AC → `user-story-generator` / `acceptance-criteria-writing`
- Prioritization frameworks → `prioritization`
- Theme / epic roadmapping → `theme-roadmapping`

---

## Required input

| Field | Description |
|---|---|
| **Product / initiative** | Subject |
| **User** | Persona or role |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Journey source** | Existing journey / research / elicitation | Elicit |
| **Release count target** | N releases to plan | 3 |
| **Annotations scope** | Persona / platform / risk / dependencies | Optional |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/story-mapping/` |

## Input schema

```
input:
  required:
    product:
      type: string | document_reference
    user:
      type: string | object
  optional:
    journey_source: string | document_reference
    release_count:
      type: integer
      default: 3
    annotations: list[string]
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
Collect product + user + journey source + release count.

### Phase 2 — Backbone
4–10 user activities, narrative-ordered.

### Phase 3 — Tasks per activity
3–7 tasks, priority top-to-bottom.

### Phase 4 — Stories per task
User-story format.

### Phase 5 — Release slicing
Walking skeleton (R1) + thickening releases.

### Phase 6 — Gap detection
Narrative / over-detail / orphan / skeleton.

### Phase 7 — Annotations
Persona / platform / risk / dependencies.

### Phase 8 — Diagrams
Story map flowchart + release table.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Story Map: [Product / Initiative]

**Date**: [date]
**User**: [persona]
**Backbone activities**: [N]
**Total tasks**: [N]
**Total stories**: [N]
**Releases planned**: [N]

## Scope
[Product, user, journey source, release target]

## Backbone
[Narrative activity sequence]

## Tasks per Activity
[Prioritized top-to-bottom]

## Stories per Task
[Full list with priority]

## Release Slicing
### Walking Skeleton (R1)
[Minimum end-to-end]

### Release 2 / 3 ...
[Thickening]

## Gap Detection
[Findings]

## Annotations
[Overlays]

## Diagrams
[Story map + release table]

## Next Steps
[Hand off walking skeleton to backlog / user-story-generator / estimation]

## Assumptions & Limitations
[Gaps, persona assumptions]
```

### Diagrams

- **Story map** — Mermaid `flowchart` with activity subgraphs
- **Release slicing** — Markdown table

---

## Generation and planning policy

- Backbone narrative-led
- Walking skeleton end-to-end
- Release slices horizontal, not vertical
- No fabricated activities

---

## Self-check

```
[] Backbone 4–10 activities
[] Tasks 3–7 per activity, prioritized
[] Stories in user-story format
[] Walking skeleton top row end-to-end
[] Thickening releases defined
[] Gaps surfaced
[] Annotations if applicable
[] Diagram + table valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No product / user | Interview mode (§7) |
| Activities feature-like | Recast as user verbs |
| Over-detail in one column | Flag + recommend split |
| Walking skeleton breaks | Flag + revisit |
| Flat backlog request | Note value of narrative map |
| mmdc failure | See `diagram-rendering` mixin |
| Sprint-plan request | Out-of-scope |

---

## Quality checks

- [ ] Narrative backbone
- [ ] Prioritized tasks
- [ ] User-story format
- [ ] Walking skeleton
- [ ] Release slicing
- [ ] Gaps surfaced
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. E-commerce MVP**
- Input: E-commerce product for shoppers
- Expected: Backbone Discover → Choose → Decide → Buy → Receive → Use. 24 tasks; 60 stories; walking skeleton = 6 stories (one per task column); R2 adds filtering / reviews / wishlist; R3 adds recommendations / social / power-user.

**2. SaaS onboarding**
- Input: B2B SaaS onboarding flow
- Expected: Backbone Land → Signup → Configure → First task → Invite team → See results. 20 tasks; 50 stories; walking skeleton = single-user single-tenant minimum; R2 adds templates / SSO; R3 adds analytics / customization.

**3. Mobile app greenfield**
- Input: Fitness tracker app
- Expected: Backbone Install → Onboard → Log activity → Review progress → Share → Adjust plan. Platform annotations (iOS / Android differences). Walking skeleton iOS-first.

**4. Legacy migration**
- Input: Migrating from old CRM to new
- Expected: Backbone mirrors user's current workflows + new capabilities. Walking skeleton = feature parity; thickening = new capabilities. Dependency annotations on data-migration prerequisites.

**5. Platform product with multi-persona**
- Input: Product serving admin + end-user
- Expected: Two maps OR one map with persona-annotation overlays; walking skeleton for end-user first (higher volume).

### Edge cases

**6. Over-focused on one activity**
- Input: "Buy" activity has 15 tasks; others have 3
- Expected: Flag imbalance; recommend splitting Buy into two activities (e.g., "Decide" + "Purchase") OR acknowledge focus is intentional and reduce others.

**7. Walking skeleton requires too much work**
- Input: Walking skeleton stories sum to 6 months of work
- Expected: Either activities are too ambitious (shave top story per column to even-smaller) OR release target needs stretching.

**8. No clear user journey**
- Input: Product where user doesn't have obvious activity sequence (admin dashboard, for instance)
- Expected: Consider if story mapping is right tool; admin products often do better with job-based or feature-based backlogs.

### Failure cases

**9. No product / user**
- Input: "Make a story map"
- Expected: Interview — "Which product, and which user?"

**10. Out of scope**
- Input: "Story map + sprint planning for next 6 months"
- Expected: "Mapping only. Sprint planning = release + capacity → use estimates from `story-point-estimation` + velocity."
