# Theme Roadmapping — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | theme-roadmapping |
| **Version** | 1.0.0 |
| **Purpose** | Creates theme-based product roadmaps organizing work into strategic themes with initiatives. Supports multiple formats (Now/Next/Later, time-horizon, swimlane). Produces audience-specific views (executive, team, customer). Performs dependency analysis across themes and initiatives. Can import from OKR and vision outputs. Generates Mermaid diagrams with optional PNG export. |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Creativity level** | `medium` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Mixins** | `[diagram-rendering, autonomous-research]` |

---

## When to use

- Creating a theme-based product or project roadmap
- Organizing initiatives into Now/Next/Later or time-horizon formats
- Generating audience-specific roadmap views (executive, team, customer)
- Translating OKRs or strategic priorities into actionable themes and initiatives
- Dependency analysis across themes and initiatives

## When not to use

- Detailed sprint or iteration planning — use agile planning skills
- Task-level work breakdown structures — use task-planning skills
- OKR definition without execution planning — use `okr-definition`
- Financial budgeting or resource allocation — use budgeting skills
- Prioritization with scoring frameworks — use `prioritization`

---

## Required input

| Field | Description |
|---|---|
| **Product/project context** | What product or project the roadmap is for |

## Optional input

| Field | Description | Default |
|---|---|---|
| **OKR document** | Path to okr-definition output | Will identify strategic context itself |
| **Vision/strategy document** | Path to vision-crafting output | Will identify strategic context itself |
| **Roadmap format** | Now/Next/Later, time-horizon, or swimlane | Now/Next/Later |
| **Audience** | Primary audience for the roadmap | All three views generated |
| **Time scope** | How far the roadmap looks ahead | 12 months |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/theme-roadmapping/` |

## Input schema

```
input:
  required:
    context:
      type: string
      description: "Product or project name and context"
  optional:
    okr_input:
      type: string | file_path
      description: "OKR definition output to import"
    vision_input:
      type: string | file_path
      description: "Vision-crafting output or strategy document"
    roadmap_format:
      type: string
      enum: [now-next-later, time-horizon, swimlane]
      default: now-next-later
    audience:
      type: string
      enum: [executive, team, customer, all]
      default: all
    time_scope:
      type: string
      default: "12 months"
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
    output_path:
      type: string
```

---

## Generation policy

| Aspect | Declaration |
|---|---|
| **What may be invented** | Theme groupings based on industry patterns, initiative scoping based on typical product work, effort estimates based on comparable projects, horizon assignments based on strategic logic |
| **What must be grounded** | Now/Next/Later methodology, theme-based roadmapping principles, dependency analysis techniques, audience view conventions |
| **What assumptions are allowed** | Initiative effort sizing based on industry norms, dependency relationships based on logical sequencing, time scope distribution based on roadmapping best practices |
| **What must never be fabricated** | Specific company data without research basis, actual delivery dates or commitments, resource availability, budget numbers without source |

---

## Processing rules

### Phase 1 — Setup
1. Parse input, detect product/project context
2. If insufficient → interview mode (§7)
3. Check for OKR/vision input to import
4. Detect roadmap format preference
5. Confirm scope, format, time scope, audience with user
6. Ask diagram render mode (per diagram-rendering mixin)
7. Ask output path (default: `/documentation/[case]/theme-roadmapping/`)

### Phase 2 — Research
8. WebSearch/WebFetch (per autonomous-research mixin) for industry roadmap patterns
9. Research common themes for similar products or projects
10. Research typical initiative types and scoping
11. Research dependency management approaches and stakeholder communication patterns

### Phase 3 — Strategic Context
12. If OKR/vision input provided: extract objectives, key results, strategic priorities, success metrics
13. If no strategic input: research product/project's stated direction from public sources
14. Map objectives to potential theme areas
15. Identify initiative candidates from key results
16. Present strategic context summary for user confirmation

### Phase 4 — Theme Identification
17. Define 3-5 strategic themes
18. Each theme must be strategic, bounded, measurable, and justified
19. Classify each as Strategic, Customer, or Technical
20. Link each theme to an objective or strategic priority
21. Define success metric per theme
22. Present themes for user confirmation

### Phase 5 — Initiative Mapping
23. Define 5-15 initiatives mapped to themes
24. Each initiative must be specific, sized (S/M/L/XL), linked, and outcome-oriented
25. Describe expected outcome, effort, dependencies, OKR link per initiative
26. Present initiative table for user confirmation

### Phase 6 — Time-Horizon Assignment
27. Assign each initiative to Now (committed, high detail), Next (planned, moderate detail), or Later (exploratory, light detail)
28. For time-horizon format: map to specific periods (Q1/Q2/H1/H2/FY)
29. For swimlane format: organize by theme (rows) x time (columns)
30. Provide rationale and confidence per assignment

### Phase 7 — Audience Views
31. Generate Executive view (strategic outcomes, metrics, timeline — no implementation details)
32. Generate Team view (initiatives, effort, dependencies, sequencing — full implementation context)
33. Generate Customer view (outcomes and value — no internal details, no effort, no dependencies)

### Phase 8 — Dependency Analysis
34. Identify cross-theme and cross-initiative dependencies
35. Classify dependencies as hard (blocks) or soft (benefits from)
36. Assess risk and impact if delayed
37. Identify critical path through dependencies
38. Flag initiatives with > 2 dependencies and recommend sequencing adjustments

### Phase 9 — Diagrams
39. Generate 3 Mermaid diagrams:
    1. Theme Roadmap (gantt) — initiatives organized by theme across time
    2. Now/Next/Later Board (flowchart) — initiatives in horizon buckets with dependency arrows
    3. Dependency Map (flowchart) — cross-initiative and cross-theme dependencies with relationship types
40. Render per diagram-rendering mixin

### Phase 10 — Report Assembly
41. Assemble complete report, present for approval, save after confirmation

---

## Output contract

```markdown
# Theme Roadmap: [Product/Project Name]

**Date**: [date]
**Product/project**: [name]
**Format**: [now-next-later / time-horizon / swimlane]
**Time scope**: [duration]
**Themes**: [count]
**Initiatives**: [count]

## Executive Summary
[Key findings: theme count, initiative distribution across horizons, critical dependencies, top 3 recommendations]

## Strategic Context
[Objectives, priorities, success metrics]

## Themes
[Theme table with types, objective links, success metrics, rationale]

## Initiatives
[Initiative table with themes, outcomes, effort, dependencies, OKR links]

## Now / Next / Later Assignment
[Assignment table with rationale and confidence]

## Theme Roadmap
[Gantt diagram]

## Now/Next/Later Board
[Board diagram]

## Executive View
[Executive perspective table]

## Team View
[Team perspective table]

## Customer View
[Customer perspective table]

## Dependency Analysis
[Dependency tables + dependency map diagram]

## Recommendations
[Prioritized actions traced to specific findings]

## Sources

## Assumptions & Limitations
```

### Diagrams

| # | Diagram | Mermaid type | Content |
|---|---|---|---|
| 1 | Theme Roadmap | gantt | Initiatives organized by theme across time |
| 2 | Now/Next/Later Board | flowchart | Initiatives in horizon buckets with dependency arrows |
| 3 | Dependency Map | flowchart | Cross-initiative and cross-theme dependencies with relationship types |

Rendering per diagram-rendering mixin.

---

## Self-check

### Must verify before output
```
[] 3-5 strategic themes identified with types and success metrics
[] 5-15 initiatives mapped to themes with outcomes and effort
[] Every initiative assigned to a horizon (Now/Next/Later or time period)
[] Now items are committed and detailed, Later items are exploratory
[] Three audience views generated (executive, team, customer)
[] Customer view contains no internal details
[] Dependencies identified with types (hard/soft) and risk assessment
[] Critical path through dependencies identified
[] Recommendations traced to specific findings
[] All 3 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
[] Sources listed for claims (per autonomous-research mixin)
[] Assumptions labeled with confidence (per autonomous-research mixin)
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No context provided | Enter interview mode (§7) — "What product or project should I create a roadmap for?" |
| Context too vague | Enter interview mode (§7) — ask targeted questions about the product/project |
| OKR/vision input malformed | Ask user to verify, attempt partial import |
| Cannot identify strategic priorities | Report limitation, produce roadmap with explicit assumptions labeled |
| Single theme only | Proceed with one theme, note reduced value of theme-based approach |
| Internal platform (no external customers) | Adapt customer view to internal stakeholder view |
| Regulated industry | Add compliance/regulatory as a dedicated theme, flag mandatory initiatives |
| Too many initiatives (> 20) | Group into sub-themes or recommend phasing |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| Out-of-scope request | "This skill creates theme-based roadmaps. [Request] is outside scope." |

---

## Quality checks

- [ ] 3-5 strategic themes identified with types and success metrics
- [ ] 5-15 initiatives mapped to themes with outcomes and effort estimates
- [ ] Every initiative assigned to a horizon with rationale
- [ ] Now items are committed and detailed, Later items are exploratory
- [ ] Three audience views generated (executive, team, customer)
- [ ] Customer view contains no internal details (effort, dependencies, technical scope)
- [ ] Themes are strategic, bounded, and measurable — never catch-all
- [ ] Initiatives describe outcomes, not just features
- [ ] Dependencies identified with type (hard/soft) and risk assessment
- [ ] Critical path through dependencies identified
- [ ] No fabricated delivery dates or resource availability
- [ ] All 3 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] Sources listed for claims (per autonomous-research mixin)
- [ ] Assumptions labeled with confidence (per autonomous-research mixin)

---

## Examples

### Normal cases

**1. SaaS product roadmap**
- Input: "Create a roadmap for CloudMetrics, a B2B SaaS analytics platform with 500 enterprise customers"
- Expected: 3-5 themes (e.g., Enterprise readiness, Data platform, Self-service analytics). 8-12 initiatives across Now/Next/Later. Three audience views. Dependencies between platform and feature themes.

**2. With OKR input**
- Input: "/documentation/cloudmetrics/okr-definition/okr-report.md"
- Expected: Themes mapped directly to OKR objectives. Initiatives traced to specific key results. Alignment visible in theme table. Executive view references OKR targets.

**3. Platform roadmap (multi-product)**
- Input: "Roadmap for our internal developer platform serving 5 product teams. Products: Payments, Identity, Messaging, Analytics, Compliance."
- Expected: Themes spanning platform capabilities (API gateway, observability, developer experience). Swimlane format showing per-product and shared-platform initiatives. Dependencies between platform and product teams flagged.

**4. Startup MVP roadmap**
- Input: "Roadmap for FreshBite, pre-launch food delivery app, 2 developers, targeting Amsterdam"
- Expected: Lean roadmap with 2-3 themes (Core delivery flow, Market entry, Foundation). Heavy on Now (MVP features), light on Later. Small initiative count (5-8). Dependencies focused on launch-blocking items.

**5. Annual planning**
- Input: "Annual roadmap for 2025, CloudMetrics. Company priorities: expand to APAC, launch AI features, reduce churn below 5%."
- Expected: Time-horizon format (Q1/Q2/H2). Themes aligned to the three priorities. Initiatives distributed across quarters with increasing uncertainty. Executive view shows quarterly milestones.

### Edge cases

**6. Single theme only**
- Input: "Roadmap for our accessibility compliance initiative"
- Expected: Single theme roadmap. Note reduced value of theme-based approach. Organize by initiative priority within the theme. Still produce three audience views.

**7. Internal platform**
- Input: "Roadmap for our CI/CD platform, internal engineering tool"
- Expected: Adapt customer view to internal stakeholder view (engineering teams as customers). Themes focused on developer experience, reliability, adoption. No external-facing language.

**8. Regulated industry (compliance themes)**
- Input: "Roadmap for MedTrack, a medical device tracking SaaS. FDA 21 CFR Part 11 compliance required."
- Expected: Dedicated compliance/regulatory theme. Mandatory initiatives flagged as non-negotiable Now items. Dependencies between compliance and feature themes explicit. Customer view omits compliance internals.

### Failure cases

**9. No context**
- Input: "Create a roadmap"
- Expected: Interview mode (§7) — "What product or project should I create a roadmap for?" Do not generate a roadmap without context.

**10. Out of scope**
- Input: "Create a Gantt chart with task assignments and resource allocation per person"
- Expected: "This skill creates theme-based roadmaps with strategic themes and initiatives. Detailed task assignment and resource allocation per person is outside scope. Consider using a project planning or resource management skill."
