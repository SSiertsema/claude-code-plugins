# Financial Forecasting — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | financial-forecasting |
| **Version** | 1.0.0 |
| **Purpose** | Projects future financial performance including revenue, expenses, cash flow, P&L, and unit economics. Supports 6 forecasting methods (straight-line, growth rate, driver-based, bottom-up, top-down, hybrid). Produces complete P&L projections with margin tracking, cash flow forecasts with burn rate/runway, unit economics evolution (CAC, LTV, LTV:CAC, payback), and scenario modeling with sensitivity analysis. Compares projections against industry benchmarks. Generates Mermaid diagrams with optional PNG export. |
| **Primary category** | `planning` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Creativity level** | `medium` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Mixins** | `[diagram-rendering, autonomous-research]` |

---

## When to use

- User needs revenue, expense, or cash flow projections
- User wants P&L or income statement forecast
- User needs unit economics projections (CAC, LTV, margins, burn rate, runway)
- User wants driver-based financial model
- User needs scenario-based financial projections (best/base/worst)
- User is preparing for fundraising or budgeting and needs financial model
- User wants to validate financial viability of a business or project

## When not to use

- Cost-benefit analysis for specific decisions — use `cost-benefit-analysis`
- ROI calculations for investments — use `roi-modeling`
- Business case creation — use `business-case-management`
- Market sizing (TAM/SAM/SOM) — use `market-sizing`
- Problem-solution validation — use `problem-solution-fit`
- Accounting, bookkeeping, or tax preparation — out of scope

---

## Required input

| Field | Description |
|---|---|
| **Business/project context** | What the business or project is about — sufficient to identify revenue model and cost structure |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Historical financial data** | Past revenue, expenses, metrics | None (research + benchmarks) |
| **Business model** | How the business makes money | Inferred from context |
| **Time horizon** | Forecast period in years | 3 years |
| **Granularity** | Monthly, quarterly, or annual | Monthly Y1, quarterly Y2-3 |
| **Key drivers** | Known business drivers | Will be identified |
| **Existing forecasts** | Prior projections to update | None |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/financial-forecasting/` |

## Input schema

```
input:
  required:
    business_context:
      type: string
      description: "What the business or project is about"
  optional:
    historical_data:
      type: string | file_path
      description: "Past financial data to base projections on"
    business_model:
      type: string
      description: "Revenue model description"
    time_horizon:
      type: integer
      default: 3
      description: "Forecast period in years"
    granularity:
      type: string
      enum: [monthly, quarterly, annual, mixed]
      default: mixed
      description: "Monthly Y1, quarterly Y2-3 when mixed"
    key_drivers:
      type: list[string]
      description: "Known operational metrics that drive financials"
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
| **What may be invented** | Revenue projections based on market benchmarks, expense estimates based on industry norms, growth rate assumptions based on comparable companies |
| **What must be grounded** | Financial formulas (P&L structure, cash flow components, unit economics), industry benchmarks with sources, forecasting methodology definitions |
| **What assumptions are allowed** | Growth rates based on industry data, cost ratios based on comparable companies, unit economics based on industry benchmarks, seasonal patterns based on market norms |
| **What must never be fabricated** | Specific company financial data without source, guaranteed outcomes, benchmark numbers without research basis, historical data that wasn't provided |

---

## Processing rules

### Phase 1 — Setup
1. Parse input, detect business context and stage
2. If insufficient → interview mode (§7)
3. Check for historical data, business model details
4. Determine time horizon and granularity
5. Confirm scope with user
6. Ask diagram render mode (per diagram-rendering mixin)
7. Ask output path (default: `/documentation/[case]/financial-forecasting/`)

### Phase 2 — Research
8. WebSearch/WebFetch (per autonomous-research mixin) for industry financial benchmarks
9. Research comparable company financials
10. Research market growth rates and trends
11. Research industry-specific unit economics benchmarks

### Phase 3 — Business Model Analysis
12. Identify revenue model (subscription, transactional, marketplace, licensing, services, freemium)
13. Map cost structure (fixed, variable, semi-variable)
14. Identify 3-7 key financial drivers with formulas
15. Present business model summary for user confirmation

### Phase 4 — Revenue Forecast
16. Select forecasting method(s) based on data availability and business stage
17. Build revenue model: bottom-up (units × price) and/or top-down (market × share)
18. For SaaS: MRR/ARR with new, expansion, contraction, churn components
19. Segment by product line, segment, geography as applicable
20. Monthly granularity for Y1, quarterly for Y2-3

### Phase 5 — Expense Forecast
21. Fixed costs with annual escalation rates
22. Variable costs as % of revenue or per-unit
23. Semi-variable: separate fixed base from variable component
24. Headcount plan and hiring timeline (if applicable)
25. One-time costs assigned to specific periods

### Phase 6 — P&L Projection
26. Revenue → COGS → Gross Profit → OpEx → EBIT → Interest/Tax → Net Income
27. Track gross margin, operating margin, net margin
28. Compare margins to industry benchmarks, flag deviations

### Phase 7 — Cash Flow Forecast
29. Operating: net income + non-cash + working capital changes
30. Investing: capex, acquisitions
31. Financing: funding, loans, repayments
32. Cumulative cash position per period
33. Burn rate and runway for pre-profit companies

### Phase 8 — Unit Economics
34. Calculate CAC, LTV, LTV:CAC, CAC payback period, contribution margin
35. Show evolution over time (unit economics should improve at scale)
36. Compare to industry benchmarks (LTV:CAC ≥ 3:1 target)

### Phase 9 — Scenario Modeling
37. Define 3 scenarios (best/base/worst) with distinct assumptions
38. Full P&L per scenario
39. Cash runway per scenario
40. Break-even timeline per scenario

### Phase 10 — Sensitivity Analysis
41. Identify 3-5 highest-impact variables
42. Vary each ±20%, recalculate key metrics
43. Determine break-even conditions

### Phase 11 — Diagrams
44. Generate 4 Mermaid diagrams:
    1. Revenue Projection (xychart-beta) — revenue over time with scenario lines
    2. P&L Waterfall (xychart-beta) — revenue through net income
    3. Cash Flow (xychart-beta) — cumulative cash position per scenario
    4. Unit Economics Dashboard (xychart-beta) — LTV:CAC evolution over time
45. Render per diagram-rendering mixin

### Phase 12 — Report Assembly
46. Assemble complete report with all sections
47. Include assumptions register
48. Present for user approval, save after confirmation

---

## Output contract

```markdown
# Financial Forecast: [Business/Project]

**Date**: [date]
**Business**: [name]
**Revenue model**: [type]
**Time horizon**: [N years]
**Granularity**: [monthly Y1, quarterly Y2-3]
**Revenue Y1/Y2/Y3**: [amounts]
**Net Income Y1/Y2/Y3**: [amounts]
**Cash runway**: [months] (if applicable)
**LTV:CAC**: [ratio] (if applicable)

## Executive Summary
[Revenue trajectory, profitability timeline, cash position, critical assumptions]

## Business Model Summary
[Revenue model, cost structure, key drivers with formulas]

## Key Drivers
[Driver table with metrics and financial relationships]

## Revenue Forecast
[Revenue tables + Revenue Projection chart]

## Expense Forecast
[Fixed/variable/semi-variable tables + headcount plan]

## P&L Projection
[Full P&L table with margins + P&L Waterfall chart]

## Cash Flow Forecast
[Operating/investing/financing + cumulative + Cash Flow chart]

## Unit Economics
[CAC, LTV, LTV:CAC, payback + Unit Economics Dashboard chart]

## Scenario Analysis
[Best/base/worst with per-scenario P&L and cash runway]

## Sensitivity Analysis
[Key variables ±20% + break-even conditions]

## Key Assumptions Register
[All assumptions with source, confidence, and impact if wrong]

## Recommendations
[Revenue acceleration, cost optimization, funding needs]

## Sources

## Assumptions & Limitations
```

### Diagrams

| # | Diagram | Mermaid type | Content |
|---|---|---|---|
| 1 | Revenue Projection | xychart-beta | Revenue over time with 3 scenario lines |
| 2 | P&L Waterfall | xychart-beta | Revenue → Gross Profit → EBIT → Net Income |
| 3 | Cash Flow | xychart-beta | Cumulative cash position per scenario |
| 4 | Unit Economics Dashboard | xychart-beta | LTV:CAC evolution with 3:1 target |

Rendering per diagram-rendering mixin.

---

## Self-check

### Must verify before output
```
[] Revenue uses appropriate method with documented drivers
[] Revenue growth justified (no unexplained hockey sticks)
[] Expenses categorized with escalation rules
[] P&L complete and mathematically consistent
[] Margins tracked and compared to benchmarks
[] Cash flow includes operating, investing, financing
[] Burn rate and runway calculated (if pre-profit)
[] Unit economics: CAC, LTV, LTV:CAC, payback period
[] Unit economics show evolution over time
[] 3 scenarios with distinct assumptions
[] Sensitivity on 3-5 key variables
[] Break-even conditions identified
[] All assumptions in register with source and confidence
[] Monthly granularity for Y1
[] All 4 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
[] Sources listed (per autonomous-research mixin)
[] Assumptions labeled (per autonomous-research mixin)
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No business context | Enter interview mode (§7) — "What business or project should I create a financial forecast for?" |
| Context too vague | Enter interview mode (§7) — ask about revenue model and business stage |
| No historical data | Use research-based projections with `[Assumption]` labels and benchmark sources |
| Business model unclear | Research comparable companies, propose model, confirm with user |
| Industry benchmarks unavailable | Use adjacent industry data, label as `[Approximate]` |
| Projections appear unrealistic | Flag with benchmark comparison, present with caveat |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| Out-of-scope request | "This skill creates financial forecasts. [Request] is outside scope." |

---

## Quality checks

- [ ] Revenue forecast uses appropriate method with documented driver assumptions
- [ ] No unexplained hockey stick growth (growth justified by drivers)
- [ ] Expenses fully categorized (fixed, variable, semi-variable) with escalation rules
- [ ] P&L mathematically consistent (all lines sum correctly)
- [ ] Gross, operating, and net margins tracked and benchmarked
- [ ] Cash flow reconciles with P&L (operating CF starts from net income)
- [ ] Burn rate and runway calculated for pre-profit companies
- [ ] Unit economics calculated with correct formulas
- [ ] LTV:CAC flagged if below 1.5:1
- [ ] Three scenarios have distinct, documented assumptions
- [ ] Sensitivity analysis identifies highest-impact variables
- [ ] All assumptions documented with source and confidence level
- [ ] Base case uses conservative assumptions (optimism in best case only)
- [ ] All 4 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] Sources listed for all benchmarks (per autonomous-research mixin)
- [ ] Assumptions labeled (per autonomous-research mixin)

---

## Examples

### Normal cases

**1. SaaS startup**
- Input: "Create a financial forecast for our B2B SaaS project management tool, $49/user/month, launching in 3 months"
- Expected: MRR/ARR model with new/expansion/churn. Revenue from bottom-up (users × ARPU). Unit economics with CAC, LTV, LTV:CAC. Burn rate and runway. 3 scenarios based on different user growth rates.

**2. E-commerce business**
- Input: "Forecast financials for our online fashion store doing $50K/month currently"
- Expected: Transactional model. Revenue from traffic × conversion × AOV. Seasonal patterns (Q4 holiday surge). COGS as % of revenue. Inventory and shipping as variable costs. 3-year projection from current baseline.

**3. Consulting firm**
- Input: "Financial model for our 15-person digital strategy consultancy"
- Expected: Capacity-based: consultants × utilization rate × daily rate. Revenue ceiling from headcount. Growth through hiring. Fixed costs (salaries, office), variable (travel, subcontractors). Utilization sensitivity analysis.

**4. With historical data**
- Input: "Here's our last 12 months of P&L [data]. Forecast the next 3 years."
- Expected: Import actuals, identify trends, project forward. Growth rate derived from historical trend + market context. Expense ratios maintained or adjusted based on scaling assumptions.

**5. Fundraising preparation**
- Input: "We're raising a Series A. Need an investor-ready financial model for our fintech app."
- Expected: Professional model with MRR/ARR, unit economics (CAC < LTV/3), clear path to profitability. Burn rate + runway showing 18+ months post-raise. Scenario modeling for investor due diligence.

### Edge cases

**6. Pre-revenue startup**
- Input: "We haven't launched yet. Forecast financials for a marketplace connecting freelance designers with SMBs."
- Expected: Zero revenue initial months. Growth from launch assumptions (marketing spend → signups → transactions). All projections marked [Assumption]. Heavy reliance on comparable marketplace benchmarks. Conservative base case.

**7. Non-profit**
- Input: "Financial forecast for our educational non-profit — grant-funded with some earned revenue"
- Expected: Revenue from grants (pipeline-based), donations (seasonal), earned income (workshops, materials). Expenses: program delivery, fundraising, G&A. Sustainability metrics instead of profitability. Grant renewal risk in scenarios.

**8. Hardware + SaaS hybrid**
- Input: "We sell IoT sensors ($200 each) plus a $29/month analytics platform"
- Expected: Mixed model: upfront hardware revenue + recurring SaaS. Hardware COGS (manufacturing, shipping) + SaaS COGS (hosting). Blended unit economics. Working capital impact from hardware inventory.

### Failure cases

**9. No context**
- Input: "Create a forecast"
- Expected: Interview mode (§7) — "What business or project should I create a financial forecast for? Understanding the revenue model and business stage helps me build an accurate model."

**10. Out of scope**
- Input: "Do our accounting and file our taxes"
- Expected: "This skill creates financial forecasts and projections. Accounting, bookkeeping, and tax preparation are outside scope."
