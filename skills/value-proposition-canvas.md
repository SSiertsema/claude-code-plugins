# Value Proposition Canvas — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | value-proposition-canvas |
| **Version** | 1.0.0 |
| **Purpose** | Creates Value Proposition Canvases based on Strategyzer's framework. Builds Customer Profiles (jobs, pains, gains) and Value Maps (products/services, pain relievers, gain creators) for each customer segment. Assesses problem-solution fit with coverage scoring (0-100). Researches customer insights and competitor value propositions via web tools. Supports multiple customer segments with one canvas per segment. Generates Mermaid diagrams with optional PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Creativity level** | `medium` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Mixins** | `[diagram-rendering, autonomous-research]` |

---

## When to use

- User needs to map a product/service's value proposition against customer needs
- User wants Customer Profile analysis (jobs-to-be-done, pains, gains)
- User needs to assess problem-solution fit for one or more customer segments
- User wants to compare value propositions across segments
- User has customer segmentation or persona output and wants to build canvases from it
- User needs to identify gaps between what customers need and what the product offers

## When not to use

- Full Business Model Canvas — use `business-case-management` for Lean Canvas
- Customer segmentation itself — use `customer-segmentation`
- Persona creation — use `persona-management`
- Competitive analysis (SWOT, Porter's, TOWS) — use `competitive-analysis`
- Market sizing — use `market-sizing`
- Pricing strategy — out of scope
- Product roadmap creation — out of scope

---

## Required input

| Field | Description |
|---|---|
| **Product/service context** | What the product or service is — sufficient to research customer needs and build value maps |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Target customer segments** | Specific segments to analyze | Will be researched or inferred |
| **Industry/market** | Sector, segment | Inferred from product/service |
| **Existing customer data** | Personas, segmentation output, user research | None (will be researched) |
| **Competitor context** | Known competitors | Will be researched |
| **Geographic scope** | Region or global | Global |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/value-proposition-canvas/` |

## Input schema

```
input:
  required:
    product_service_context:
      type: string
      description: "Product or service name/description, business case document, or pasted content"
  optional:
    target_segments:
      type: list[string]
      description: "Customer segments to analyze (one canvas per segment)"
    industry_market:
      type: string
      description: "Industry/sector context"
    existing_customer_data:
      type: string
      description: "Path to persona or segmentation output, or pasted customer data"
    competitor_context:
      type: list[string]
      description: "Known competitors"
    geographic_scope:
      type: string
      default: "Global"
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
| **What may be invented** | Customer job descriptions, pain descriptions, gain descriptions based on research and typical patterns. Pain reliever and gain creator mappings. Scenario descriptions for fit improvement. |
| **What must be grounded** | VPC framework definitions (Strategyzer), fit scoring methodology, customer job type classifications, pain/gain categorizations |
| **What assumptions are allowed** | Customer needs based on industry research, competitive positioning based on public information, typical customer workflows based on domain knowledge |
| **What must never be fabricated** | Specific customer quotes, survey data, actual usage statistics, real customer feedback, specific revenue or conversion figures |

---

## Processing rules

### Phase 1 — Setup
1. Parse input, detect product/service context
2. If insufficient → interview mode (§7): gather product/service context at minimum
3. Confirm scope with user (product/service, segments, industry, competitors)
4. Ask diagram render mode (per diagram-rendering mixin)
5. Ask output path (default: `/documentation/[case]/value-proposition-canvas/`)

### Phase 2 — Research
6. WebSearch/WebFetch (per autonomous-research mixin) for customer insights, market context, competitor value propositions
7. Research jobs-to-be-done in the target market
8. Research common pain points and desired outcomes
9. Research competitor offerings and how they address customer needs

### Phase 3 — Customer Segment Selection
10. Identify target segments from: customer-segmentation output, personas, or research
11. One canvas per segment
12. Present segment list to user for confirmation before proceeding

### Phase 4 — Customer Profile
For each segment:
13. Identify 8-12 Customer Jobs across 4 types (functional, social, emotional, supporting). Prioritize top 5.
14. Identify 8-12 Pains across 3 categories (undesired outcomes, obstacles, risks). Severity ranking (extreme to moderate). Prioritize top 5.
15. Identify 8-12 Gains across 4 types (required, expected, desired, unexpected). Relevance ranking (essential to nice-to-have). Prioritize top 5.

### Phase 5 — Value Map
For each segment:
16. List Products & Services across 4 types (physical, digital, intangible, financial). Rank by importance.
17. Define Pain Relievers — how each product/service alleviates specific prioritized pains. Map 1:1 where possible.
18. Define Gain Creators — how each product/service produces specific prioritized gains. Map 1:1 where possible.

### Phase 6 — Fit Assessment
For each segment:
19. Map each pain reliever to its corresponding pain
20. Map each gain creator to its corresponding gain
21. Score coverage: % of prioritized pains addressed, % of prioritized gains addressed
22. Determine fit level: High (>70%), Medium (40-70%), Low (<40%)
23. Identify unmatched pains (gaps) and unmatched gain creators (over-delivery)
24. Calculate overall fit score (0-100): pain coverage 60%, gain coverage 40%

### Phase 7 — Competitive Comparison
25. If competitors identified: brief competitor value map comparison, differentiation opportunities, competitive gaps
26. If no competitors: skip and note in report

### Phase 8 — Diagrams
27. Generate 3 Mermaid diagrams per segment:
    1. Canvas Overview (mindmap) — Customer Profile and Value Map structure
    2. Fit Mapping (flowchart) — Pain relievers → Pains, Gain creators → Gains with fit indicators
    3. Fit Score Chart (xychart-beta) — Coverage scores across segments
28. Render per diagram-rendering mixin

### Phase 9 — Recommendations
29. Gaps to address: prioritized pains/gains with no or weak coverage
30. Over-deliveries to evaluate: gain creators addressing non-prioritized gains
31. Iteration suggestions: how to improve fit score per segment
32. Competitive moves (if applicable)
33. Every recommendation traced to a specific finding

### Phase 10 — Report Assembly
34. Assemble complete report with all sections
35. Present for user approval, save after confirmation

---

## Output contract

```markdown
# Value Proposition Canvas: [Product/Service]

**Date**: [date]
**Product/Service**: [name]
**Customer segments analyzed**: [count]
**Overall fit score**: [0-100]

## Executive Summary

## Customer Profile: [Segment Name]
### Customer Jobs
[Table: ID, Job, Type, Priority, Evidence]
### Pains
[Table: ID, Pain, Category, Severity, Evidence]
### Gains
[Table: ID, Gain, Type, Relevance, Evidence]

## Value Map: [Segment Name]
### Products & Services
[Table: ID, Product/Service, Type, Importance]
### Pain Relievers
[Table: ID, Pain Reliever, Addresses Pain, Strength]
### Gain Creators
[Table: ID, Gain Creator, Addresses Gain, Strength]

## Canvas Overview
[Mindmap diagram]

## Fit Assessment: [Segment Name]
### Pain Coverage
[Mapping table: Pain → Pain Reliever → Fit strength]
### Gain Coverage
[Mapping table: Gain → Gain Creator → Fit strength]
### Gaps (Unaddressed)
### Over-delivery
### Fit Score: [0-100]

## Fit Mapping
[Flowchart diagram]

## Segment Comparison
[Fit score chart across segments]

## Competitive Comparison (if applicable)

## Recommendations

## Sources

## Assumptions & Limitations
```

### Diagrams

| # | Diagram | Mermaid type | Content |
|---|---|---|---|
| 1 | Canvas Overview | mindmap | Customer Profile (jobs/pains/gains) and Value Map (products/pain relievers/gain creators) |
| 2 | Fit Mapping | flowchart | Pain relievers → Pains, Gain creators → Gains with fit strength indicators |
| 3 | Fit Score Chart | xychart-beta | Coverage scores across segments |

Rendering per diagram-rendering mixin.

---

## Self-check

### Must verify before output
```
[] Customer Profile complete for each segment (jobs, pains, gains with types and priorities)
[] 8-12 items identified per category, top 5 prioritized
[] Value Map complete for each segment (products, pain relievers, gain creators)
[] Pain relievers mapped to specific pains
[] Gain creators mapped to specific gains
[] Fit assessment with coverage scores for each segment
[] Gaps (unaddressed pains) and over-deliveries identified
[] Fit score calculated (0-100) with correct weighting (pain 60%, gain 40%)
[] Fit level classification matches thresholds (High >70%, Medium 40-70%, Low <40%)
[] Recommendations traced to specific gaps/findings
[] All Mermaid diagrams render valid syntax (per diagram-rendering mixin)
[] Sources listed for all major claims (per autonomous-research mixin)
[] Assumptions explicitly labeled (per autonomous-research mixin)
[] No fabricated customer quotes, survey data, or usage statistics
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No product/service context | Enter interview mode (§7) — "What product or service should I create a Value Proposition Canvas for?" |
| Context too vague | Enter interview mode (§7) — ask targeted questions to narrow scope |
| No customer data available | Use research-based inference with [Assumption] labels |
| Single segment only | Produce one canvas, note limitation in report |
| Cannot identify competitors | Skip competitive comparison, note in report |
| Insufficient research data | Produce partial output, label gaps and low-confidence findings |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| User provides conflicting scope | Present the conflict, ask user to resolve |
| Out-of-scope request | "This skill creates Value Proposition Canvases. [Request] is outside scope." |

---

## Quality checks

- [ ] Customer Profile has jobs, pains, gains for each segment with correct type classifications
- [ ] 8-12 items per category with top 5 prioritized
- [ ] Value Map has products/services, pain relievers, gain creators for each segment
- [ ] Pain relievers map to specific prioritized pains (1:1 where possible)
- [ ] Gain creators map to specific prioritized gains (1:1 where possible)
- [ ] Fit coverage percentages calculated correctly
- [ ] Fit score uses correct weighting (pain 60%, gain 40%)
- [ ] Gaps and over-deliveries explicitly listed
- [ ] Recommendations are concrete and trace to specific findings
- [ ] Multi-segment analysis produces one canvas per segment
- [ ] Competitive comparison included when competitors are identified
- [ ] All 3 diagram types render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] Sources listed for all major claims (per autonomous-research mixin)
- [ ] Assumptions explicitly labeled (per autonomous-research mixin)
- [ ] No fabricated customer quotes, survey data, or usage statistics

---

## Examples

### Normal cases

**1. SaaS project management tool**
- Input: "Create a VPC for our SaaS project management tool targeting small dev teams"
- Expected: Functional jobs (task tracking, sprint planning, collaboration), social jobs (appear organized to stakeholders), emotional jobs (reduce stress of missed deadlines). Pains around complexity, context switching, reporting overhead. Gain creators for productivity, visibility, team alignment. Fit assessment showing strong pain coverage for core workflow pains.

**2. With personas input**
- Input: "Create VPC for our CRM platform, use personas from `/documentation/acme/persona-management/`"
- Expected: Import persona insights into Customer Profile — jobs, pains, gains derived from persona characteristics. One canvas per persona-segment. Evidence column references persona data.

**3. B2B enterprise security platform**
- Input: "VPC for our cloud security platform targeting enterprise CISOs"
- Expected: High compliance needs, risk-averse buyers. Functional jobs (threat detection, compliance reporting), social (demonstrate due diligence to board), emotional (peace of mind). Pain relievers focused on risk reduction and audit readiness. High fit expected for compliance pains, potential gaps in developer experience gains.

**4. Consumer mobile fitness app**
- Input: "Value proposition canvas for a mobile fitness app targeting young professionals"
- Expected: Emotional/social jobs dominate (feel confident, share progress, belong to community). Pains around motivation, time constraints, intimidation. Gain creators for habit formation, social accountability, personalized workouts. Gains include unexpected (status/social currency).

**5. Multi-segment analysis**
- Input: "VPC for our project tool — freemium individual users vs enterprise teams"
- Expected: Two separate canvases. Freemium: functional simplicity, low switching cost pains, free-tier gain expectations. Enterprise: collaboration, security, compliance jobs, integration pains, admin control gains. Fit score chart comparing both segments. Different gaps per segment.

### Edge cases

**6. Very early-stage idea**
- Input: "I have an idea for an AI-powered recipe app but haven't built anything yet"
- Expected: Minimal product data, heavy reliance on market research. Customer Profile well-developed from research, Value Map mostly hypothetical. All value map items labeled [Assumption]. Low-confidence fit score with explicit limitations noted.

**7. Single feature, not full product**
- Input: "Create a VPC for just the automated reporting feature of our analytics platform"
- Expected: Scoped canvas for one feature. Narrower jobs (generate reports, share insights), specific pains (manual report creation, formatting, distribution). Value map limited to reporting capabilities. Note that this is a feature-level canvas, not product-level.

**8. Non-profit/public service**
- Input: "VPC for a municipal library's new digital lending service"
- Expected: Adapts framework for non-commercial value. Jobs include access to knowledge, community engagement, digital literacy. Pains around physical access barriers, limited hours, outdated catalogs. Gains around convenience, discovery, inclusivity. No pricing-related gains. Social value emphasized.

### Failure cases

**9. No context**
- Input: "Create a value proposition canvas"
- Expected: Interview mode — "What product or service should I create a Value Proposition Canvas for? A brief description of what it does and who it serves will help me get started."

**10. Out of scope**
- Input: "Create a business model canvas with revenue streams and cost structure"
- Expected: "This skill creates Value Proposition Canvases (Customer Profile + Value Map + fit assessment). Full Business Model Canvas is outside scope — use business-case-management for Lean Canvas."
