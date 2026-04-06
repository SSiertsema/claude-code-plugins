# Cost-Benefit Analysis — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | cost-benefit-analysis |
| **Version** | 1.0.0 |
| **Purpose** | Evaluates projects and initiatives by comparing total costs against total benefits in present-value terms. Calculates NPV, BCR, IRR, Payback Period, and Break-even for 2-4 alternatives (always including a "do nothing" baseline). Identifies and categorizes direct, indirect, and intangible costs and benefits. Monetizes intangible items using productivity-based, avoided cost, proxy metric, market-based, and expert judgment techniques with documented confidence levels. Performs sensitivity analysis (one-way, scenario, switching values) and risk assessment linked to key variables. Produces side-by-side alternative comparison with ranked recommendation. Generates Mermaid diagrams with optional PNG export. |
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

- User needs to evaluate whether a project or investment is financially worthwhile
- User wants to compare multiple alternatives (build vs buy, cloud vs on-premise, etc.)
- User needs NPV, BCR, IRR, or payback period calculations for a business case
- User wants sensitivity analysis to understand which variables drive value
- User needs to monetize intangible costs and benefits
- User wants a structured recommendation backed by financial analysis

## When not to use

- Revenue forecasting or financial projections without a decision context — use financial modeling
- Portfolio-level investment prioritization across many projects — use portfolio analysis
- Pure risk assessment without cost-benefit framing — use risk assessment
- Competitive analysis or market positioning — use `competitive-analysis`
- Industry performance benchmarking — use `industry-benchmarking`
- Organizational chart or responsibility assignment — use `raci-matrix`

---

## Required input

| Field | Description |
|---|---|
| **Project/initiative context** | What the project or initiative is about — sufficient to identify costs, benefits, and alternatives |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Alternatives** | Specific alternatives to compare | Will identify + "do nothing" baseline |
| **Time horizon** | Number of years to project | 5 years (will recommend based on context) |
| **Discount rate** | Rate for present-value calculations | Will research industry standard |
| **Business case** | Existing business case document (file path or pasted) | None |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/cost-benefit-analysis/` |

## Input schema

```
input:
  required:
    project_context:
      type: string
      description: "Project or initiative description, or path to business case"
  optional:
    alternatives:
      type: array[string]
      description: "Specific alternatives to compare (do-nothing always included)"
    time_horizon:
      type: integer
      default: 5
      description: "Number of years to project costs and benefits"
    discount_rate:
      type: number
      description: "Discount rate for PV calculations (e.g., 0.08 for 8%)"
    business_case:
      type: string | file_path
      description: "Existing business case document to extract context from"
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
| **What may be invented** | Cost estimates based on industry benchmarks, benefit projections based on typical patterns, alternative definitions based on common options for the project type |
| **What must be grounded** | NPV/BCR/IRR/payback formulas, discount rate methodology, monetization technique definitions, financial calculation methods |
| **What assumptions are allowed** | Cost ranges based on industry data, benefit magnitudes based on comparable projects, discount rates based on industry standards, adoption/utilization rates based on benchmarks |
| **What must never be fabricated** | Specific financial figures without research basis, actual company financial data, guaranteed returns, precise ROI claims without documented assumptions |

---

## Processing rules

### Phase 1 — Setup
1. Parse input, detect project context
2. If insufficient -> interview mode (SS7): gather project context at minimum
3. Identify alternatives (2-4, always including "do nothing" baseline)
4. Determine time horizon and discount rate (research if not provided)
5. Confirm scope (project, alternatives, time horizon, discount rate) with user
6. Ask diagram render mode (per diagram-rendering mixin)
7. Ask output path (default: `/documentation/[case]/cost-benefit-analysis/`)

### Phase 2 — Research
8. WebSearch/WebFetch (per autonomous-research mixin) for industry cost benchmarks
9. Research comparable project cost data and case studies
10. Research benefit estimation data (productivity gains, revenue benchmarks)
11. Research typical discount rates for the industry/context

### Phase 3 — Alternative Definition
12. Define 2-4 alternatives including "do nothing" baseline
13. Present alternatives with descriptions and key differentiators
14. Confirm with user before proceeding

### Phase 4 — Cost Identification
15. For each alternative, identify costs in three categories:
    - Direct: capital, operational, labor, implementation
    - Indirect: overhead, opportunity cost, training, change management
    - Intangible: brand risk, morale, disruption
16. Classify each as one-time or recurring
17. Exclude sunk costs explicitly
18. Assign costs to years (Year 0 through Year N)

### Phase 5 — Benefit Identification
19. For each alternative, identify benefits:
    - Tangible: revenue increase, cost savings, productivity gains, error reduction
    - Intangible: brand value, satisfaction, retention, strategic positioning
20. Classify each as direct/indirect, short-term/long-term
21. Assign benefits to years (Year 0 through Year N)

### Phase 6 — Monetization
22. For each intangible item, apply appropriate technique:
    - Productivity-based (hours saved x labor rate)
    - Avoided cost (expense prevented)
    - Proxy metrics (satisfaction -> retention -> CLV)
    - Market-based (comparable pricing)
    - Expert judgment (with confidence range)
23. Document technique and confidence level (High/Medium/Low) per item

### Phase 7 — Financial Calculations
24. Build year-by-year cash flow table per alternative
25. Apply discounting: PV = FV / (1+r)^t
26. Calculate NPV = sum of discounted net cash flows
27. Calculate BCR = PV of benefits / PV of costs
28. Calculate IRR = discount rate where NPV = 0 (iterative)
29. Calculate Payback Period = when cumulative cash flow turns positive
30. Calculate Break-even point

### Phase 8 — Sensitivity Analysis
31. Identify 3-5 key variables with highest impact
32. One-way sensitivity: vary each +/-20% and +/-40%, recalculate NPV
33. Scenario analysis: best case, worst case, base case (define assumptions for each)
34. Switching values: at what value does NPV become negative?
35. Tornado diagram data: rank variables by NPV impact

### Phase 9 — Risk Assessment
36. Identify project-specific risks
37. Assess probability and impact
38. Link to sensitivity findings
39. Provide specific mitigation strategies

### Phase 10 — Alternative Comparison
40. Build side-by-side comparison table (all metrics per alternative)
41. Rank alternatives by NPV, BCR, risk profile
42. State recommended alternative with justification

### Phase 11 — Diagrams
43. Generate 4 Mermaid diagrams:
    1. Cumulative Cash Flow Chart (xychart-beta) — year-by-year cumulative net cash flow, one line per alternative
    2. Cost-Benefit Breakdown (xychart-beta) — cost categories vs benefit categories per alternative
    3. Tornado Diagram (xychart-beta) — NPV impact per variable, most impactful at top
    4. Scenario Comparison (xychart-beta) — NPV for best/worst/base per alternative
44. Render per diagram-rendering mixin

### Phase 12 — Report Assembly
45. Assemble complete report with all sections
46. Present for user approval, save after confirmation

---

## Output contract

```markdown
# Cost-Benefit Analysis: [Project/Initiative]

**Date**: [date]
**Project**: [name]
**Alternatives evaluated**: [count]
**Time horizon**: [N years]
**Discount rate**: [X%]
**Recommended alternative**: [name] (NPV: [value])

## Executive Summary
[Key findings, recommended alternative, critical assumptions, primary risks]

## Methodology
[Discount rate justification, time horizon rationale, monetization approach]

## Alternatives
[Description of each alternative including "do nothing"]

## Cost Analysis
### [Alternative Name]
[Table: ID, Cost item, Category, Type, Year 0-N values, PV, Confidence]
[Subtotals by category, grand total]

## Benefit Analysis
### [Alternative Name]
[Table: ID, Benefit item, Category, Type, Year 0-N values, PV, Confidence, Monetization method]
[Subtotals by category, grand total]

## Financial Summary
### Year-by-Year Cash Flow
[Table per alternative: Year, Costs, Benefits, Net, Discount factor, PV, Cumulative]

### Key Metrics
| Metric | Alternative 1 | Alternative 2 | ... |
|---|---|---|---|
| NPV | | | |
| BCR | | | |
| IRR | | | |
| Payback Period | | | |
| Break-even | | | |

## Cumulative Cash Flow Chart
[Diagram 1]

## Cost-Benefit Breakdown
[Diagram 2]

## Sensitivity Analysis
### Key Variables
[Table: variable, base value, -40%, -20%, +20%, +40%, NPV impact]
### Tornado Diagram
[Diagram 3]
### Switching Values
[Table: variable, switching value, meaning]
### Scenarios
[Table: scenario, assumptions, NPV, BCR, payback]
### Scenario Comparison
[Diagram 4]

## Risk Assessment
[Table: risk, probability, impact, related variable, mitigation]

## Alternative Comparison & Recommendation
[Side-by-side table, ranking, recommended alternative with justification]

## Sources
[Numbered list of web sources — per autonomous-research mixin]

## Assumptions & Limitations
[Explicit list — per autonomous-research mixin]
```

### Diagrams

| # | Diagram | Mermaid type | Content |
|---|---|---|---|
| 1 | Cumulative Cash Flow | xychart-beta | Year-by-year cumulative net cash flow per alternative |
| 2 | Cost-Benefit Breakdown | xychart-beta | Cost categories vs benefit categories per alternative |
| 3 | Tornado Diagram | xychart-beta | NPV impact per variable, ranked by magnitude |
| 4 | Scenario Comparison | xychart-beta | NPV for best/worst/base per alternative |

Rendering per diagram-rendering mixin.

---

## Self-check

### Must verify before output
```
[] All costs categorized (direct/indirect/intangible, one-time/recurring)
[] All benefits categorized (tangible/intangible, direct/indirect)
[] Sunk costs excluded
[] Intangible items monetized with documented technique and confidence
[] Year-by-year cash flow table complete
[] NPV, BCR, IRR, Payback Period calculated
[] Discount rate justified
[] Sensitivity analysis on 3-5 key variables
[] Three scenarios defined (best/worst/base)
[] Risks identified with mitigations
[] Alternatives compared side-by-side
[] Clear recommendation with justification
[] All 4 Mermaid diagrams render valid syntax (per diagram-rendering mixin)
[] Sources listed (per autonomous-research mixin)
[] Assumptions labeled with confidence levels (per autonomous-research mixin)
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No project context | Enter interview mode (SS7) — "What project or initiative should I evaluate?" |
| Context too vague | Enter interview mode (SS7) — ask targeted questions |
| Cannot estimate key costs | Report gap, use ranges with low confidence |
| Discount rate unknown | Research industry standard, propose with justification |
| Single alternative only | Compare against "do nothing" baseline |
| Financial data unavailable | Use research-based estimates with [Assumption] labels and confidence levels |
| Intangible items unquantifiable | Use expert judgment with Low confidence and explicit range |
| IRR has no solution | Report "No IRR — cash flows do not cross zero" |
| Payback exceeds horizon | Report "Does not pay back within [N] years" |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| Out-of-scope request | "This skill performs cost-benefit analysis. [Request] is outside scope." |

---

## Quality checks

- [ ] All costs identified and categorized (direct/indirect/intangible, one-time/recurring)
- [ ] All benefits identified and categorized (tangible/intangible, direct/indirect, short-term/long-term)
- [ ] Sunk costs explicitly excluded
- [ ] Every intangible item monetized with documented technique and confidence level
- [ ] Year-by-year cash flow table complete for each alternative
- [ ] NPV, BCR, IRR, Payback Period, Break-even calculated correctly
- [ ] Discount rate researched and justified
- [ ] Sensitivity analysis covers 3-5 key variables with one-way and scenario analysis
- [ ] Switching values identified for key variables
- [ ] Risks identified with probability, impact, and mitigation
- [ ] All alternatives compared side-by-side with consistent metrics
- [ ] Recommendation is clear, justified, and robust across scenarios
- [ ] Financial calculations are mathematically correct and internally consistent
- [ ] No fabricated financial figures presented as fact
- [ ] All diagrams render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] Sources listed for all major claims (per autonomous-research mixin)
- [ ] Assumptions explicitly labeled with confidence levels (per autonomous-research mixin)

---

## Examples

### Normal cases

**1. Cloud migration**
- Input: "Evaluate migrating our on-premise infrastructure to the cloud"
- Expected: Compare on-premise (do nothing), full cloud migration, and hybrid approach over 5 years. Costs: migration, training, operational (cloud vs on-prem). Benefits: scalability, reduced maintenance, faster deployment. Sensitivity on cloud pricing, utilization rate, migration complexity.

**2. New product development**
- Input: "Should we invest in developing a new SaaS product for the HR market?"
- Expected: Compare do nothing, build in-house, and acquire existing product. Costs: R&D, marketing, operations. Benefits: projected revenue, market share. Sensitivity on adoption rate, pricing, development timeline. Higher uncertainty, wider confidence ranges.

**3. Process automation**
- Input: "Evaluate automating our invoice processing workflow"
- Expected: Compare manual (do nothing) vs automated. Costs: implementation, licenses, training. Benefits: productivity gains (hours saved x labor rate), error reduction (avoided cost), faster cycle time. Clear payback period calculation. Sensitivity on volume growth and labor cost.

**4. Office relocation**
- Input: "Compare 3 potential office locations for our 200-person team"
- Expected: Compare current location (do nothing) vs 3 alternatives. Costs: lease, renovation, moving, commute impact. Benefits: talent access, brand, productivity. Significant intangible monetization. Sensitivity on lease terms and growth rate.

**5. Software buy vs build**
- Input: "Should we build a custom CRM or buy Salesforce?"
- Expected: Compare do nothing (spreadsheets), build custom, buy Salesforce, buy HubSpot. Costs: development/licenses, integration, ongoing maintenance. Benefits: productivity, data quality, customer insights. Sensitivity on customization needs and user adoption.

### Edge cases

**6. Very small investment**
- Input: "Should we buy a $5,000 project management tool?"
- Expected: Simplified CBA — shorter horizon (2-3 years), fewer alternatives (buy vs free tier vs do nothing). Proportionate analysis depth. Note that formal CBA may be disproportionate for the investment size.

**7. Long-horizon infrastructure**
- Input: "Evaluate a 20-year data center investment"
- Expected: Extended time horizon, higher discount rate sensitivity, terminal value considerations. Note increasing uncertainty in later years. Multiple discount rate scenarios. Infrastructure-specific cost categories (power, cooling, refresh cycles).

**8. Non-profit/social impact**
- Input: "Evaluate a community health program for our foundation"
- Expected: Intangible benefits dominate (health outcomes, quality-adjusted life years, community well-being). Use willingness-to-pay and social return on investment (SROI) methods. Lower confidence overall. Acknowledge that standard CBA may undervalue social benefits.

### Failure cases

**9. No context**
- Input: "Do a cost-benefit analysis"
- Expected: Interview mode — "What project or initiative should I evaluate? Understanding the context helps me identify the right alternatives, costs, and benefits to analyze."

**10. Out of scope**
- Input: "Forecast our Q3 revenue"
- Expected: "This skill performs cost-benefit analysis comparing alternatives for a specific investment decision. Revenue forecasting is outside scope — consider financial-forecasting or consult your finance team."
