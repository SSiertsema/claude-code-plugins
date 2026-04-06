# Prioritization — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | prioritization |
| **Version** | 1.0.0 |
| **Purpose** | Prioritizes items (features, initiatives, backlog items, tasks) using multiple frameworks: RICE, ICE, Value vs Effort, Kano, Weighted Scoring, and Now/Next/Later. Produces priority-ranked lists, framework comparison with consensus analysis, conflict resolution for divergent rankings, and Now/Next/Later bucket assignment. Can import feature lists or backlogs. Generates Mermaid diagrams with optional PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Creativity level** | `medium` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Mixins** | `[diagram-rendering, autonomous-research]` |

---

## When to use

- Prioritizing a product feature backlog
- Ranking strategic initiatives for planning cycles
- Comparing items using multiple scoring frameworks (RICE, ICE, Kano, etc.)
- Assigning items to Now/Next/Later time horizons
- Resolving prioritization conflicts across frameworks

## When not to use

- Evaluating opportunities from a JTBD/customer-needs perspective — use `opportunity-scoring`
- Creating a theme-based roadmap from prioritized items — use `theme-roadmapping`
- Detailed cost-benefit analysis of investments — use `cost-benefit-analysis`
- ROI modeling for projects — use `roi-modeling`
- Strategic planning without items to rank — use `vision-crafting`

---

## Required input

| Field | Description |
|---|---|
| **Items to prioritize** | Feature list, backlog, initiative list, or product/project context to identify items from |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Context / domain** | Industry, market context | Inferred from items |
| **Framework(s)** | Which scoring frameworks to apply | RICE + Value vs Effort |
| **Scoring criteria and weights** | For Weighted Scoring only | Asked if Weighted Scoring selected |
| **Customer research data** | For Kano analysis | Will use proxy data with [Assumption] labels |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/prioritization/` |

## Input schema

```
input:
  required:
    items:
      type: string | file_path | list[string]
      description: "Items to prioritize — feature list, backlog, or context to identify items from"
  optional:
    context:
      type: string
      description: "Industry, market, or product context"
    frameworks:
      type: list[string]
      enum: [rice, ice, value_vs_effort, kano, weighted_scoring, now_next_later]
      default: [rice, value_vs_effort]
    criteria:
      type: list[object]
      description: "Custom criteria and weights for Weighted Scoring (must sum to 100%)"
    customer_data:
      type: string | file_path
      description: "Customer research data for Kano analysis"
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
| **What may be invented** | Item descriptions when identified from context, reach/impact estimates based on industry benchmarks, effort estimates based on comparable scope |
| **What must be grounded** | RICE formula (Reach x Impact x Confidence / Effort), ICE formula ((I+C+E)/3), Kano classification matrix, Value vs Effort quadrant definitions, scoring scales |
| **What assumptions are allowed** | Reach estimates based on domain benchmarks, impact estimates based on comparable products, Kano classifications from research proxy data (labeled [Assumption]) |
| **What must never be fabricated** | Scores without stated inputs, rankings that do not follow mathematically from scores, quadrant assignments that do not match value/effort scores, Kano classifications without the classification matrix |

---

## Processing rules

### Phase 1 — Setup
1. Parse input, detect items and context
2. If insufficient → interview mode (§7)
3. Detect item count and domain
4. Recommend framework(s) based on item count and context
5. Confirm scope, frameworks, and any custom criteria with user
6. Ask diagram render mode (per diagram-rendering mixin)
7. Ask output path (default: `/documentation/[case]/prioritization/`)

### Phase 2 — Research
8. WebSearch/WebFetch (per autonomous-research mixin) for industry context
9. Research benchmarks for similar features/initiatives
10. Research comparable prioritization patterns (what competitors shipped first)
11. Research market urgency signals (regulatory deadlines, competitive pressure)

### Phase 3 — Item Identification
12. If item list provided: import, validate, request clarification for ambiguous entries
13. If no item list: identify 10-30 items from context with ID, name, description, category
14. Present item list for user confirmation

### Phase 4 — Framework Application
15. Apply each selected framework independently:
    - RICE: Reach x Impact x Confidence / Effort per item
    - ICE: (Impact + Confidence + Ease) / 3 per item
    - Value vs Effort: score value (1-10) and effort (1-10), assign to quadrants (Quick Wins, Major Projects, Fill-ins, Time Sinks)
    - Kano: classify via functional/dysfunctional matrix (Must-be, Performance, Attractive, Indifferent, Reverse)
    - Weighted Scoring: score 1-100 per criterion, calculate weighted total
16. Show complete scoring tables per framework

### Phase 5 — Scoring & Ranking
17. Produce unified ranked list per framework applied, sorted descending by score

### Phase 6 — Now/Next/Later Assignment
18. Assign every item to Now (20-30%), Next (30-40%), or Later (30-40%)
19. Based on framework scores, urgency, dependencies, strategic alignment
20. Provide rationale per assignment

### Phase 7 — Cross-Framework Comparison
21. If multiple frameworks: compare rankings per item
22. Determine consensus (strong, moderate, weak, conflict) based on rank position across frameworks

### Phase 8 — Conflict Resolution
23. For items with weak consensus or conflict: explain why frameworks disagree
24. Recommend which ranking to trust and why

### Phase 9 — Diagrams
25. Generate 3 Mermaid diagrams:
    1. Value vs Effort Matrix (quadrantChart) — all items plotted with normalized scores
    2. Priority Ranking (xychart-beta) — top 15 items by primary framework score
    3. Now/Next/Later Board (flowchart) — all items in assigned buckets with color coding
26. Render per diagram-rendering mixin

### Phase 10 — Report Assembly
27. Assemble complete report, present for approval, save after confirmation

---

## Output contract

```markdown
# Prioritization Report: [Subject]

**Date**: [date]
**Subject**: [name]
**Items**: [count]
**Framework(s)**: [list]

## Executive Summary
[Key findings: top 3 priorities, framework consensus, Now/Next/Later distribution, top recommendations]

## Items List
[ID, name, description, category]

## Framework Scores

### [Framework Name]
[Scoring table for each applied framework]

## Ranked List
[Unified ranking]

## Value vs Effort Matrix
[Quadrant chart + quadrant assignments]

## Now/Next/Later Assignment
[Bucket table + board diagram]

## Cross-Framework Comparison
[Comparison table, if multiple frameworks]

## Conflict Analysis
[Conflict resolution, if applicable]

## Priority Ranking
[Bar chart diagram]

## Recommendations
[Prioritized actions: what to do first, what to sequence, what to defer, risks]

## Sources

## Assumptions & Limitations
```

### Diagrams

| # | Diagram | Mermaid type | Content |
|---|---|---|---|
| 1 | Value vs Effort Matrix | quadrantChart | All items plotted by value and effort with quadrant labels |
| 2 | Priority Ranking | xychart-beta | Top 15 items by primary framework score |
| 3 | Now/Next/Later Board | flowchart | All items in assigned buckets (Now=green, Next=orange, Later=gray) |

Rendering per diagram-rendering mixin.

---

## Self-check

### Must verify before output
```
[] 5-30 items identified with name, description, category
[] Selected framework(s) applied with complete scoring tables
[] All scores calculated from stated inputs (no fabricated numbers)
[] Rankings follow mathematically from scores
[] Value vs Effort quadrant assignments match scores
[] Now/Next/Later assignment covers all items with rationale
[] Cross-framework comparison present (if multiple frameworks)
[] Conflict analysis present for divergent items (if applicable)
[] Recommendations traced to specific scores and findings
[] All 3 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
[] Sources listed for research claims (per autonomous-research mixin)
[] Assumptions labeled (per autonomous-research mixin)
[] Kano classifications follow the classification matrix (if Kano applied)
[] Weighted Scoring weights sum to 100% (if Weighted Scoring applied)
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No items provided or identifiable | Enter interview mode (§7) — "What items should I prioritize?" |
| Context too vague | Enter interview mode (§7) — ask targeted questions |
| Too few items (< 5) | Proceed but note limited differentiation value of framework scoring |
| All items score similarly | Flag low score differentiation, suggest adding discriminating criteria or Weighted Scoring |
| Technical debt items (no user-facing value) | Adjust frameworks: use Effort + Risk reduction instead of Reach/Impact, note adaptation |
| Kano without customer data | Use research proxy data, label all classifications as [Assumption] |
| Weighted Scoring without criteria | Propose criteria based on context, confirm with user |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| Out-of-scope request | "This skill prioritizes items using scoring frameworks. [Request] is outside scope." |

---

## Quality checks

- [ ] 5-30 items identified with name, description, and category
- [ ] Selected framework(s) applied with complete scoring tables
- [ ] All scores calculated from stated inputs — no fabricated numbers
- [ ] Rankings follow mathematically from scores — no arbitrary reordering
- [ ] Value vs Effort quadrant assignments match value/effort scores
- [ ] Now/Next/Later assignment covers all items with rationale per item
- [ ] Cross-framework comparison present when multiple frameworks applied
- [ ] Conflict analysis present for items with divergent rankings
- [ ] Kano classifications follow the classification matrix (if applied)
- [ ] Weighted Scoring weights sum to 100% (if applied)
- [ ] No fabricated scores, reach numbers, or effort estimates without basis
- [ ] All 3 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] Sources listed for research claims (per autonomous-research mixin)
- [ ] Assumptions labeled (per autonomous-research mixin)

---

## Examples

### Normal cases

**1. Feature backlog prioritization**
- Input: "Prioritize our product backlog: dark mode, API v2, mobile app, SSO integration, reporting dashboard, onboarding wizard, bulk import, webhook support, audit log, custom branding"
- Expected: 10 items identified. RICE + Value vs Effort applied. Ranked list with scores. Now/Next/Later assignment. Quick Wins and Time Sinks identified in matrix.

**2. RICE scoring for B2B SaaS**
- Input: "Use RICE to prioritize these features for our B2B SaaS: [list of 15 features]"
- Expected: RICE only. Research B2B SaaS benchmarks for reach/impact estimation. RICE table with all components shown. Ranked list sorted by RICE score.

**3. Kano analysis for e-commerce**
- Input: "Run a Kano analysis on our e-commerce checkout features: guest checkout, saved addresses, Apple Pay, order tracking, gift wrapping, carbon offset option"
- Expected: Kano classification using research proxy data (no survey). All classifications labeled [Assumption]. Priority order: Must-be > Performance > Attractive.

**4. Multi-framework comparison**
- Input: "Compare RICE, ICE, and Weighted Scoring for our platform migration tasks: [12 items]"
- Expected: All three frameworks applied independently. Cross-framework comparison with consensus analysis. Conflict resolution for divergent items.

**5. Strategic initiative ranking**
- Input: "Rank these strategic initiatives for 2025: market expansion APAC, AI feature suite, enterprise tier, partner program, sustainability reporting, developer portal"
- Expected: RICE + Weighted Scoring (strategic criteria). Research market context. Now/Next/Later with strategic rationale.

### Edge cases

**6. Very few items**
- Input: "Prioritize: login page redesign, password reset fix, 2FA"
- Expected: Proceed with 3 items. Note limited differentiation value. Simplified scoring. Ranking with caveat about small sample size.

**7. All items similar priority**
- Input: [12 compliance features all with similar regulatory deadlines and similar effort]
- Expected: Flag low differentiation. Suggest adding discriminating criteria (penalty severity, implementation dependencies). Attempt ranking but clearly state tight clustering.

**8. Technical debt prioritization**
- Input: "Prioritize our tech debt: upgrade Node 16->20, replace deprecated ORM, fix N+1 queries, add monitoring, refactor auth module, migrate to TypeScript"
- Expected: Adapt frameworks — use Risk Reduction and Effort instead of Reach/Impact. Note adaptation. Score based on technical risk, blast radius, and effort.

### Failure cases

**9. No items provided**
- Input: "Prioritize"
- Expected: Interview mode (§7) — "What items should I prioritize, and what is the product/project context?"

**10. Out of scope**
- Input: "Prioritize and then build the top 3 features"
- Expected: Prioritize items per skill scope. Refuse the build request: "This skill prioritizes items using scoring frameworks. Building features is outside scope."
