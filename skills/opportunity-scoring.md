# Opportunity Scoring — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | opportunity-scoring |
| **Version** | 1.0.0 |
| **Purpose** | Evaluates product opportunities using Ulwick's Opportunity Score (importance vs satisfaction from JTBD), Teresa Torres' Opportunity-Solution Tree, and multi-criteria weighted scoring. Identifies underserved customer outcomes, maps solutions to validated opportunities with assumption tests, and produces opportunity registers and priority landscapes. Can import customer research or segmentation data. Generates Mermaid diagrams with optional PNG export. |
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

- Finding underserved customer outcomes using JTBD methodology
- Evaluating product opportunities with importance vs satisfaction scoring
- Building Opportunity-Solution Trees with assumption tests
- Comparing opportunities with multi-criteria weighted scoring
- Identifying overserved outcomes where competing offers diminishing returns

## When not to use

- Operational prioritization with RICE/ICE/Kano frameworks — use `prioritization`
- Theme-based roadmap creation — use `theme-roadmapping`
- Market sizing and TAM/SAM/SOM — use `market-sizing`
- Competitive analysis and SWOT — use `competitive-analysis`
- Customer segmentation and personas — use `customer-segmentation`

---

## Required input

| Field | Description |
|---|---|
| **Product/market context** | What product or market to evaluate opportunities for |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Customer segment(s)** | Target segments to evaluate | Will identify from context |
| **Customer research data** | Surveys, interviews, reviews | Will research autonomously |
| **Existing opportunity list** | Pre-identified opportunities | Will identify outcomes in research |
| **Scoring approach** | Ulwick, OST, Multi-Criteria, or combination | Ulwick Opportunity Score |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/opportunity-scoring/` |

## Input schema

```
input:
  required:
    context:
      type: string
      description: "Product or market name and context"
  optional:
    segments:
      type: list[string]
      description: "Customer segments to evaluate"
    customer_data:
      type: string | file_path
      description: "Customer research data (surveys, interviews, reviews)"
    opportunity_list:
      type: string | file_path
      description: "Pre-identified opportunities to score"
    scoring_approach:
      type: list[string]
      enum: [ulwick, opportunity_solution_tree, multi_criteria]
      default: [ulwick, opportunity_solution_tree]
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
| **What may be invented** | Customer outcome statements based on research evidence, solution ideas for Opportunity-Solution Trees, assumption test designs |
| **What must be grounded** | Ulwick's Opportunity Score formula (Importance + max(Importance - Satisfaction, 0)), JTBD framing methodology, Opportunity-Solution Tree structure, classification thresholds (>15 extreme, 12-15 strong, 8-12 moderate, <8 low) |
| **What assumptions are allowed** | Importance scores based on frequency of mention in reviews/forums, satisfaction scores based on competitor ratings and workaround prevalence, market opportunity estimates based on available data |
| **What must never be fabricated** | Scores without evidence justification, specific customer data without research basis, guaranteed market outcomes, satisfaction data presented as survey results when inferred from proxy |

---

## Processing rules

### Phase 1 — Setup
1. Parse input, detect product/market context
2. If insufficient → interview mode (§7)
3. Check for customer research data to import
4. Detect scoring approach (Ulwick, OST, Multi-Criteria)
5. Confirm scope, segments, scoring approach with user
6. Ask diagram render mode (per diagram-rendering mixin)
7. Ask output path (default: `/documentation/[case]/opportunity-scoring/`)

### Phase 2 — Research
8. WebSearch/WebFetch (per autonomous-research mixin) for customer needs
9. Research customer forums, review sites, social media for outcomes and satisfaction signals
10. Research competitor feature coverage and ratings
11. Research market size, emerging needs, and technology shifts

### Phase 3 — Outcome/Opportunity Identification
12. If opportunity list provided: import, validate JTBD framing
13. If no list: identify 15-30 customer outcomes using JTBD framing
14. Frame as "When [situation], I want to [outcome], so I can [benefit]"
15. Group outcomes by job stage (Define, Locate, Prepare, Execute, Monitor, Modify, Conclude, Resolve)
16. Classify as Functional, Emotional, Social, or Related job
17. Present for user confirmation

### Phase 4 — Importance Scoring
18. Score each outcome on importance (1-10) based on evidence
19. Evidence: frequency of mention, severity indicators, regulatory requirements, research findings
20. Document evidence per score

### Phase 5 — Satisfaction Scoring
21. Score current satisfaction with existing solutions (1-10) based on evidence
22. Evidence: competitor ratings, feature-specific satisfaction, workaround prevalence, support patterns
23. Document current solution and evidence per score

### Phase 6 — Opportunity Score Calculation
24. Calculate: Opportunity Score = Importance + max(Importance - Satisfaction, 0)
25. Classify: >15 extreme, 12-15 strong, 8-12 moderate, <8 low
26. Flag overserved outcomes (Satisfaction > Importance)
27. Rank by Opportunity Score descending

### Phase 7 — Opportunity-Solution Tree
28. For top 5-10 opportunities: build Teresa Torres' Opportunity-Solution Tree
29. Generate 2-4 distinct solutions per opportunity (low-effort to ambitious)
30. Define 1-3 assumption tests per solution (cheapest experiment for riskiest assumption)
31. Label solutions requiring significant research as [Needs validation]

### Phase 8 — Multi-Criteria Scoring (if requested)
32. Propose 4-6 criteria with weights summing to 100% (default: Market size 20%, Strategic fit 25%, Feasibility 20%, Competitive advantage 20%, Revenue potential 15%)
33. Confirm criteria with user
34. Score each opportunity 1-100 per criterion
35. Calculate weighted totals

### Phase 9 — Diagrams
36. Generate 3 Mermaid diagrams:
    1. Opportunity Landscape (quadrantChart) — importance vs satisfaction, opportunity quadrant top-left
    2. Opportunity-Solution Tree (flowchart) — top 5 opportunities with solutions and tests
    3. Priority Ranking (xychart-beta) — top 15 outcomes by Opportunity Score
37. Render per diagram-rendering mixin

### Phase 10 — Report Assembly
38. Assemble complete report, present for approval, save after confirmation

---

## Output contract

```markdown
# Opportunity Scoring Report: [Product/Service]

**Date**: [date]
**Product/service**: [name]
**Market**: [target market]
**Outcomes evaluated**: [count]
**Scoring approach**: [method(s)]

## Executive Summary
[Key findings: top 3 opportunities, score distribution, overserved outcomes, key solution directions, recommendations]

## Outcomes Register
[ID, job stage, outcome statement, category]

## Importance Scores
[Scoring table with evidence]

## Satisfaction Scores
[Scoring table with evidence]

## Opportunity Scores
[Full scoring table with classifications]

## Opportunity Landscape
[Quadrant chart + interpretation]

## Top Opportunities
[Detailed analysis of top 5-10 opportunities]

## Opportunity-Solution Tree
[Tree structure + flowchart diagram]

## Multi-Criteria Analysis
[Weighted scoring table, if applied]

## Priority Ranking
[Bar chart diagram]

## Recommendations
[Which opportunities to pursue first, which solutions to test, which assumption tests to run]

## Sources

## Assumptions & Limitations
```

### Diagrams

| # | Diagram | Mermaid type | Content |
|---|---|---|---|
| 1 | Opportunity Landscape | quadrantChart | Importance vs satisfaction with opportunity quadrant (top-left) |
| 2 | Opportunity-Solution Tree | flowchart | Top 5 opportunities with solutions and assumption tests |
| 3 | Priority Ranking | xychart-beta | Top 15 outcomes by Opportunity Score |

Rendering per diagram-rendering mixin.

---

## Self-check

### Must verify before output
```
[] 15-30 outcomes identified in JTBD format with job stages
[] Importance scores grounded in evidence (no fabricated numbers)
[] Satisfaction scores grounded in evidence (no fabricated numbers)
[] Opportunity Scores calculated correctly: Importance + max(Importance - Satisfaction, 0)
[] Overserved outcomes flagged (Satisfaction > Importance)
[] Top 5-10 opportunities have Opportunity-Solution Trees
[] Each solution maps clearly to the customer outcome
[] Assumption tests target the riskiest assumption per solution
[] Multi-Criteria weights sum to 100% (if applied)
[] Recommendations traced to specific scores and findings
[] All 3 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
[] Sources listed for research claims (per autonomous-research mixin)
[] Assumptions labeled (per autonomous-research mixin)
[] JTBD framing follows "When/I want to/so I can" structure
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No product/market context | Enter interview mode (§7) — "What product or market should I evaluate opportunities for?" |
| Context too vague | Enter interview mode (§7) — ask targeted questions |
| Very early stage (no product exists) | Proceed with market research only, note higher uncertainty, label more items as [Assumption] |
| B2B with few customers | Adapt research to industry reports, analyst reviews, competitor analysis rather than consumer forums; note limited data |
| Internal tool opportunities | Adapt JTBD framing to internal users, use productivity/efficiency as outcome measures |
| No customer data and research yields little | Produce partial output, clearly label all scores as [Assumption], recommend primary research |
| Customer research provided but poorly structured | Attempt to extract outcomes, ask user to clarify ambiguous items |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| Out-of-scope request | "This skill evaluates product opportunities using scoring methods. [Request] is outside scope." |

---

## Quality checks

- [ ] 15-30 outcomes identified in JTBD format with job stages and categories
- [ ] Importance scores grounded in evidence — no fabricated numbers
- [ ] Satisfaction scores grounded in evidence — no fabricated numbers
- [ ] Opportunity Scores calculated correctly using Ulwick formula
- [ ] Overserved outcomes flagged when Satisfaction > Importance
- [ ] Top 5-10 opportunities have Opportunity-Solution Trees with 2-4 solutions each
- [ ] Each solution maps clearly to the customer outcome it addresses
- [ ] Assumption tests target the riskiest assumption per solution — not generic research
- [ ] Multi-Criteria weights sum to 100% (if applied)
- [ ] JTBD framing follows "When [situation], I want to [outcome], so I can [benefit]"
- [ ] No fabricated scores or satisfaction data presented as survey results
- [ ] All 3 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] Sources listed for research claims (per autonomous-research mixin)
- [ ] Assumptions labeled (per autonomous-research mixin)

---

## Examples

### Normal cases

**1. SaaS feature opportunities**
- Input: "Evaluate opportunities for our project management SaaS targeting mid-market teams"
- Expected: Research PM SaaS market. 15-25 customer outcomes from forums/reviews. Importance and satisfaction scored against existing tools (Asana, Monday, Jira). Opportunity Scores calculated. OST for top opportunities.

**2. With customer research input**
- Input: "Here are our customer interview transcripts: [path]. Score opportunities for our fintech app."
- Expected: Import interview data, extract outcomes from transcripts. Supplement with web research. Higher-confidence scores grounded in both interview evidence and market data.

**3. New market entry**
- Input: "We're considering entering the employee wellness market with a B2B platform. What opportunities exist?"
- Expected: Research employee wellness market extensively. Identify underserved outcomes. Evaluate against existing solutions (Headspace for Work, Virgin Pulse). Map opportunities to potential product directions.

**4. Competitive gap analysis**
- Input: "Find opportunity gaps in the e-commerce analytics space vs Shopify Analytics and Google Analytics"
- Expected: Research specific competitor capabilities. Identify outcomes where satisfaction is low despite high importance. OST focused on differentiation opportunities.

**5. Product pivot opportunities**
- Input: "Our CRM is losing to HubSpot and Salesforce. Where are the underserved opportunities we could pivot toward?"
- Expected: Research CRM market satisfaction deeply. Identify outcomes where incumbents score poorly. Focus on niches or segments where large players underserve. Pivot-oriented recommendations.

### Edge cases

**6. Very early stage**
- Input: "I have an idea for an AI-powered cooking assistant. What opportunities exist?"
- Expected: Proceed with market research only. Score against existing apps (Paprika, Mealime, ChatGPT). Higher uncertainty throughout. Most scores labeled [Assumption].

**7. B2B with few customers**
- Input: "We sell compliance software to 12 enterprise banks. Score our product opportunities."
- Expected: Adapt research to industry analyst reports, regulatory publications, enterprise software reviews. Note limited public data. Recommend supplementing with direct customer interviews.

**8. Internal tool opportunities**
- Input: "Score opportunities for improving our internal developer platform"
- Expected: Adapt JTBD to internal developer outcomes. Research developer experience patterns, platform engineering best practices, internal tool satisfaction signals.

### Failure cases

**9. No context**
- Input: "Score opportunities"
- Expected: Interview mode (§7) — "What product or market should I evaluate opportunities for?"

**10. Out of scope**
- Input: "Score these opportunities and then build the winning solution"
- Expected: Score opportunities per skill scope. Refuse the build request: "This skill evaluates product opportunities using scoring methods. Building solutions is outside scope."
