# Vision Crafting — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | vision-crafting |
| **Version** | 1.0.0 |
| **Purpose** | Crafts product and company vision statements using 4 frameworks (Golden Circle, Moore's Positioning Template, Amazon Working Backwards PR/FAQ, Pichler's Product Vision Board). Produces vision statements at 3 levels (company → product → feature) in 3 formats (one-liner ≤15 words, elevator pitch, extended paragraph). Includes 8-criterion quality scoring rubric (0-40), anti-vision positioning, and vision hierarchy alignment. Researches market context via web. Generates Mermaid diagrams with optional PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Creativity level** | `medium` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Mixins** | `[diagram-rendering, autonomous-research]` |

---

## When to use

- User needs a product or company vision statement
- User wants to apply a specific framework (Golden Circle, Moore's, Working Backwards, Vision Board)
- User needs vision alignment across company → product → feature levels
- User wants quality assessment of an existing vision statement
- User needs positioning statement or elevator pitch

## When not to use

- OKR definition — use `okr-definition`
- Roadmap creation — use `theme-roadmapping`
- Go-to-market strategy — use `go-to-market`
- Business case creation — use `business-case-management`
- Full competitive analysis — use `competitive-analysis`
- Value proposition design — use `value-proposition-canvas`

---

## Required input

| Field | Description |
|---|---|
| **Product/company context** | What the product or company does |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Competitive analysis** | Existing competitive analysis output | None (will research) |
| **Customer segmentation** | Target customer data | None (will research) |
| **Framework preference** | Which framework(s) to use | All applicable |
| **Vision level** | Company / product / feature | Product |
| **Existing vision** | Current vision to assess/improve | None (create new) |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/vision-crafting/` |

## Input schema

```
input:
  required:
    context:
      type: string
      description: "Product or company description"
  optional:
    competitive_analysis:
      type: string | file_path
    customer_segmentation:
      type: string | file_path
    frameworks:
      type: list[string]
      enum: [golden_circle, moores, working_backwards, vision_board]
      default: all_applicable
    level:
      type: string
      enum: [company, product, feature]
      default: product
    existing_vision:
      type: string
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
| **What may be invented** | Vision statements, positioning language, elevator pitches, press release narrative, anti-vision statements |
| **What must be grounded** | Framework definitions and structures, market context from research, competitor positioning from research |
| **What assumptions are allowed** | Customer needs based on market research, competitive positioning based on available data, market trends |
| **What must never be fabricated** | Customer quotes (in press release: clearly labeled as illustrative), competitor financial data, market statistics without source |

---

## Processing rules

### Phase 1 — Setup
1. Parse input, detect product/company context
2. If insufficient → interview mode (§7)
3. Check for competitive analysis / segmentation imports
4. Detect vision level (company/product/feature)
5. Confirm frameworks, scope with user
6. Ask diagram render mode (per diagram-rendering mixin)
7. Ask output path

### Phase 2 — Research
8. WebSearch/WebFetch (per autonomous-research mixin) for market context
9. Research competitive positioning and competitor visions
10. Research customer needs and pain points
11. Research industry vision patterns

### Phase 3 — Context Gathering
12. Compile: target audience, core need, market position, differentiators, business goals
13. Present context summary for user confirmation

### Phase 4 — Framework Application
14. Apply Golden Circle: Why, How, What (if selected)
15. Apply Moore's: fill all 6 template slots (if selected)
16. Apply Working Backwards: press release + internal/external FAQ (if selected)
17. Apply Vision Board: populate all 5 sections (if selected)

### Phase 5 — Vision Statement Drafting
18. Synthesize into one-liner (≤15 words), elevator pitch (30s), extended vision (1 paragraph)

### Phase 6 — Quality Scoring
19. Score on 8 criteria (1-5 each): clarity, conciseness, aspiration, inspiration, customer-centricity, uniqueness, actionability, credibility
20. Calculate total (max 40), assign rating

### Phase 7 — Vision Hierarchy
21. If multi-level: align company → product → feature, check for contradictions

### Phase 8 — Anti-Vision
22. Define what the product is NOT (sharpens positioning)

### Phase 9 — Diagrams
23. Generate 3 Mermaid diagrams: hierarchy, Golden Circle, quality scorecard
24. Render per diagram-rendering mixin

### Phase 10 — Report Assembly
25. Assemble complete report, present for approval

---

## Output contract

```markdown
# Vision Crafting: [Product/Company]

**Date**: [date]
**Level**: [company/product/feature]
**Frameworks applied**: [list]
**Quality score**: [X/40] — [rating]

## Executive Summary
## Market Context
## Golden Circle (if applied)
## Moore's Positioning Statement (if applied)
## Working Backwards Press Release (if applied)
## Product Vision Board (if applied)
## Vision Statements
### One-liner
### Elevator Pitch
### Extended Vision
## Anti-Vision
## Quality Assessment + diagram
## Vision Hierarchy + diagram (if multi-level)
## Recommendations
## Sources
## Assumptions & Limitations
```

### Diagrams

| # | Diagram | Mermaid type | Content |
|---|---|---|---|
| 1 | Vision Hierarchy | flowchart | Company → product → feature alignment tree |
| 2 | Golden Circle | flowchart | Why → How → What with content |
| 3 | Quality Scorecard | xychart-beta | 8 criteria scores |

Rendering per diagram-rendering mixin.

---

## Self-check

```
[] At least one framework fully applied
[] One-liner ≤ 15 words, aspirational, memorable
[] Elevator pitch covers problem-solution-differentiator
[] Extended vision 4-6 sentences, comprehensive
[] Quality scored on all 8 criteria honestly
[] Anti-vision defined
[] Customer-centric (not just company-focused)
[] Framework templates fully populated (all slots filled)
[] Vision hierarchy aligned (if multi-level)
[] No copied competitor visions
[] All 3 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
[] Sources listed (per autonomous-research mixin)
[] Assumptions labeled (per autonomous-research mixin)
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No context | Enter interview mode (§7) |
| Too vague | Enter interview mode (§7) |
| Existing vision assessment only | Skip generation, focus on scoring + recommendations |
| No competitive data | Research competitors, note as `[Researched]` |
| Framework not applicable | Skip with explanation |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| Out-of-scope request | "This skill crafts vision statements. [Request] is outside scope." |

---

## Quality checks

- [ ] At least one framework fully applied with all sections/slots complete
- [ ] One-liner is ≤ 15 words, aspirational, and memorable
- [ ] Elevator pitch answers: what, who, why, differentiator
- [ ] Quality scoring is honest (not inflated)
- [ ] Anti-vision sharpens positioning (not just negation)
- [ ] Vision is customer-centric
- [ ] Moore's template has specific, non-generic content in all 6 slots
- [ ] Working Backwards PR has all 8 sections + 10 FAQ items
- [ ] Vision Board has all 5 sections populated
- [ ] No fabricated market data or competitor quotes
- [ ] All 3 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] Sources listed (per autonomous-research mixin)

---

## Examples

### Normal cases

**1. SaaS product vision**
- Input: "Craft a vision for our team collaboration platform targeting remote-first companies"
- Expected: All 4 frameworks applied. One-liner focusing on remote team empowerment. Moore's positioning against Slack/Teams. Working Backwards PR for product launch. Vision Board with target group (remote teams), needs (async communication, context retention).

**2. With competitive analysis input**
- Input: [competitive analysis report] + "Create a vision statement"
- Expected: Imports competitive positioning, differentiators. Focuses on white space identified in analysis. Moore's template leverages competitor comparison directly.

**3. Company-level vision for startup**
- Input: "Company vision for a fintech startup making investing accessible to Gen Z"
- Expected: Company-level vision (timeless, aspirational). Golden Circle emphasizing financial empowerment (Why). Anti-vision: "We are NOT a trading platform for day traders."

**4. Assess existing vision**
- Input: "Assess our current vision: 'We make the world's best software'"
- Expected: Quality scoring (likely low on specificity, customer-centricity, uniqueness). Detailed per-criterion feedback. Improvement recommendations. Proposed alternative visions.

**5. Multi-level hierarchy**
- Input: "Create aligned visions for our company, our analytics product, and our new AI insights feature"
- Expected: Three vision statements at different levels. Alignment check showing how each level serves the one above. Hierarchy diagram.

### Edge cases

**6. Very early idea**
- Input: "I have an idea for a sustainable fashion marketplace but haven't defined much yet"
- Expected: Interview mode to gather more context. Research-heavy. Lower confidence labels. Vision Board most useful for structuring thinking. One-liner marked as draft.

**7. Non-profit/mission-driven**
- Input: "Vision for an education non-profit bringing coding to underserved communities"
- Expected: Golden Circle strongest fit (purpose-driven). Working Backwards PR adapted for social impact. Quality scoring weights inspiration and aspiration higher. Anti-vision distinguishes from corporate coding bootcamps.

**8. Internal tool**
- Input: "Vision for our internal developer portal"
- Expected: Adapted for internal audience. Moore's positioning against current tools/processes. "Customer" = internal developers. Anti-vision distinguishes from documentation wiki.

### Failure cases

**9. No context**
- Input: "Create a vision"
- Expected: Interview mode (§7) — "What product or company should I craft a vision for?"

**10. Out of scope**
- Input: "Define OKRs for our product"
- Expected: "This skill crafts vision statements. OKR definition is outside scope — use `okr-definition`."
