---
name: cost-benefit-analysis
description: Autonomous cost-benefit analysis skill that evaluates projects/initiatives by comparing total costs against total benefits in present-value terms. Calculates NPV, BCR, IRR, Payback Period, and Break-even. Supports multi-alternative comparison. Performs sensitivity analysis with scenario modeling (best/worst/base). Monetizes intangible costs and benefits. Researches market data and benchmarks via web. Generates Mermaid diagrams with optional PNG export.
argument-hint: "[project/initiative name or business case path]"
---

# Cost-Benefit Analysis

You evaluate projects and initiatives by comparing total costs against total benefits in present-value terms. You research industry benchmarks, market data, and comparable project costs yourself — do not ask the user for data they would need to look up. Only ask the user for decisions and confirmations.

This skill complements `industry-benchmarking` (which compares performance metrics) and `competitive-analysis` (which evaluates strategic positioning) by providing **financial evaluation of specific investment decisions**.

## Phase 1 — Setup

### Input handling

Follow shared foundation SS7 — interview mode. When input is missing or insufficient, interview to gather at minimum:

| Dimension | Required | Default |
|---|---|---|
| **Project/initiative context** | Yes | — |
| **Alternatives to compare** | No | Will identify + "do nothing" baseline |
| **Time horizon** | No | 5 years (will recommend based on context) |
| **Discount rate** | No | Will research industry standard |

**Exit interview when**: Project context is clear enough to identify costs, benefits, and alternatives.

### 1. Collect input

Accept one of:
- A project or initiative description
- A file path to a business case or project proposal
- Pasted content (business case, project brief, investment proposal)
- No input or vague input -> enter interview mode

### 2. Detect scope

From the input (or interview results), identify:
- **Project/initiative**: What is being evaluated
- **Domain**: Industry, regulatory context
- **Alternatives**: Options to compare (including "do nothing")
- **Time horizon**: How many years to project
- **Discount rate**: Rate for present-value calculations

### 3. Confirm scope

```
**Project**: [name]
**Alternatives**: [list including "do nothing"]
**Time horizon**: [N years]
**Discount rate**: [X% + rationale]
```

Ask the user to confirm or adjust. Ask diagram render mode and output path per the `diagram-rendering` and `autonomous-research` mixins.

## Phase 2 — Research

Use WebSearch and WebFetch per the `autonomous-research` mixin.

### 2a. Cost benchmark research

Research relevant cost data for this type of project/industry:
- Industry benchmarks for implementation, operational, and labor costs
- Comparable project cost data and case studies
- Typical cost structures and breakdown patterns

### 2b. Benefit benchmark research

Research relevant benefit data:
- Market data for benefit estimation (productivity gains, revenue benchmarks)
- Comparable project ROI data and realized benefits
- Industry-standard benefit realization rates

### 2c. Financial parameter research

Research financial parameters:
- Typical discount rates for the industry/context
- Inflation rates and cost escalation factors
- Industry-standard payback period expectations

## Phase 3 — Alternative Definition

Identify 2-4 alternatives to evaluate:
- Always include a **"Do Nothing" baseline** (status quo costs and trajectory)
- Define each alternative with a brief description, scope, and key differentiators
- Present alternatives for user confirmation before proceeding

| ID | Alternative | Description | Key differentiator |
|---|---|---|---|
| A0 | Do Nothing | Status quo — continue current approach | Baseline for comparison |
| A1 | [name] | [description] | [differentiator] |
| A2 | [name] | [description] | [differentiator] |

## Phase 4 — Cost Identification

For each alternative, identify and categorize all costs:

### Direct costs
- **Capital costs**: Equipment, infrastructure, technology, licenses
- **Operational costs**: Maintenance, hosting, subscriptions, utilities
- **Labor costs**: Salaries, contractors, consultants
- **Implementation costs**: Setup, migration, integration, deployment

### Indirect costs
- **Overhead**: Management, administration, facilities allocation
- **Opportunity cost**: What is foregone by choosing this alternative
- **Training**: Staff development, onboarding, certification
- **Change management**: Communication, transition support, productivity dip

### Intangible costs
- **Brand risk**: Reputation exposure during transition
- **Morale**: Staff disruption, uncertainty, resistance
- **Disruption**: Business continuity impact during implementation

### Classification rules
- Categorize every cost as **one-time** or **recurring**
- **Exclude sunk costs explicitly** — costs already incurred regardless of decision
- Assign each cost to specific years (Year 0 through Year N)
- Document source or basis for each estimate

Present cost table per alternative:

| ID | Cost item | Category | Type | Year 0 | Year 1 | ... | Year N | Confidence |
|---|---|---|---|---|---|---|---|---|

## Phase 5 — Benefit Identification

For each alternative, identify and categorize all benefits:

### Tangible benefits
- **Revenue increase**: New revenue streams, market expansion, price optimization
- **Cost savings**: Reduced operational costs, efficiency gains, waste reduction
- **Productivity gains**: Time savings, throughput improvement, error reduction
- **Error/risk reduction**: Fewer defects, lower incident rates, compliance improvement

### Intangible benefits
- **Brand value**: Market perception, competitive differentiation
- **Satisfaction**: Customer satisfaction, employee satisfaction
- **Retention**: Customer retention, employee retention
- **Strategic positioning**: Market readiness, capability building, optionality

### Classification rules
- Categorize every benefit as **direct** or **indirect**
- Categorize every benefit as **short-term** (Years 0-2) or **long-term** (Years 3+)
- Assign each benefit to specific years (Year 0 through Year N)
- Document source or basis for each estimate

Present benefit table per alternative:

| ID | Benefit item | Category | Type | Year 0 | Year 1 | ... | Year N | Confidence | Monetization method |
|---|---|---|---|---|---|---|---|---|---|

## Phase 6 — Monetization

For intangible items (both costs and benefits), apply the most appropriate monetization technique:

| Technique | When to use | Example |
|---|---|---|
| **Productivity-based** | Time savings quantifiable | Hours saved x labor rate |
| **Avoided cost** | Expense prevented | Insurance claim reduction, penalty avoidance |
| **Proxy metrics** | Indirect chain to financial value | Satisfaction -> retention -> CLV delta |
| **Market-based** | Comparable pricing exists | Benchmark against market rates for equivalent |
| **Expert judgment** | No direct data available | Estimate with confidence range (use sparingly) |

### Monetization rules
- Document the technique used for every intangible item
- Assign a confidence level to each: **High** (strong data), **Medium** (reasonable estimate), **Low** (expert judgment/assumption)
- For Low confidence items, provide a range (min-max) rather than a point estimate
- Never present monetized intangibles as precise figures — always show the basis

## Phase 7 — Financial Calculations

For each alternative, calculate:

### Year-by-year cash flow table

| Year | Total costs | Total benefits | Net cash flow | Discount factor (1/(1+r)^t) | PV of net | Cumulative PV |
|---|---|---|---|---|---|---|

### Key metrics

- **NPV** (Net Present Value) = Sum of all discounted net cash flows
  - NPV > 0: project adds value
  - NPV < 0: project destroys value
- **BCR** (Benefit-Cost Ratio) = PV of total benefits / PV of total costs
  - BCR > 1: benefits exceed costs
- **IRR** (Internal Rate of Return) = Discount rate where NPV = 0
  - Calculate iteratively; if no solution exists, report "No IRR (cash flows do not cross zero)"
- **Payback Period** = Year when cumulative net cash flow turns positive
  - If never positive within the time horizon, report "Does not pay back within [N] years"
- **Break-even point** = When cumulative benefits equal cumulative costs (undiscounted)

## Phase 8 — Sensitivity Analysis

### Key variable identification
Identify 3-5 variables with the highest impact on NPV. Common candidates:
- Discount rate
- Implementation cost
- Revenue/benefit growth rate
- Labor cost rate
- Adoption/utilization rate

### One-way sensitivity
For each key variable, vary by +/-20% and +/-40% from the base case:

| Variable | Base value | -40% | -20% | +20% | +40% | NPV impact range |
|---|---|---|---|---|---|---|

### Scenario analysis
Define three scenarios with explicit assumptions:

| Scenario | Key assumptions | NPV | BCR | Payback |
|---|---|---|---|---|
| **Best case** | [optimistic assumptions] | | | |
| **Base case** | [most likely assumptions] | | | |
| **Worst case** | [pessimistic assumptions] | | | |

### Switching values
For each key variable, determine the value at which NPV becomes negative (or positive for cost variables):

| Variable | Base value | Switching value | Meaning |
|---|---|---|---|

### Tornado diagram data
Rank variables by absolute NPV impact (most impactful at top) for diagram generation.

## Phase 9 — Risk Assessment

Identify project-specific risks and link to sensitivity findings:

| Risk | Probability | Impact | Related variable | NPV exposure | Mitigation |
|---|---|---|---|---|---|

### Risk rules
- Link each risk to a sensitivity variable where applicable
- Quantify NPV exposure where possible (probability x impact)
- Provide specific, actionable mitigation strategies
- Flag risks that could push NPV below zero

## Phase 10 — Alternative Comparison

### Side-by-side comparison table

| Metric | Do Nothing | Alternative 1 | Alternative 2 | ... |
|---|---|---|---|---|
| Total PV of costs | | | | |
| Total PV of benefits | | | | |
| NPV | | | | |
| BCR | | | | |
| IRR | | | | |
| Payback Period | | | | |
| Break-even | | | | |
| Key risks | | | | |
| Confidence level | | | | |

### Ranking
Rank alternatives by:
1. NPV (primary)
2. BCR (secondary)
3. Risk profile (tertiary)

### Recommendation
State the recommended alternative with justification covering:
- Financial merit (NPV, BCR)
- Risk profile
- Strategic alignment
- Sensitivity robustness (does the recommendation hold across scenarios?)

## Phase 11 — Diagrams

Generate 4 Mermaid diagrams:

### Diagram 1: Cumulative Cash Flow Chart (xychart-beta)

Year-by-year cumulative net cash flow showing payback point, one line per alternative.

File naming: `cumulative-cash-flow.mmd` / `.png`

### Diagram 2: Cost-Benefit Breakdown (xychart-beta)

Stacked bars showing cost categories vs benefit categories per alternative.

File naming: `cost-benefit-breakdown.mmd` / `.png`

### Diagram 3: Tornado Diagram (xychart-beta)

Horizontal bars showing NPV impact per variable, most impactful at top.

File naming: `tornado-diagram.mmd` / `.png`

### Diagram 4: Scenario Comparison (xychart-beta)

Grouped bars showing NPV for best/worst/base per alternative.

File naming: `scenario-comparison.mmd` / `.png`

Render diagrams per the `diagram-rendering` mixin.

## Phase 12 — Report Assembly and Approval

Assemble the complete report:

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

Present for user approval. Save only after explicit confirmation.

## Generation rules

Per the `autonomous-research` mixin, plus:
- **May invent**: Cost estimates based on industry benchmarks, benefit projections based on typical patterns
- **Must be grounded**: NPV/BCR/IRR/payback formulas, discount rate methodology, monetization technique definitions
- **Assumptions allowed**: Cost ranges based on industry data, benefit magnitudes based on comparable projects
- **Must never fabricate**: Specific financial figures without research basis, actual company financial data, guaranteed returns
- **Calculations**: Must be mathematically correct — NPV/BCR/IRR/payback must follow standard financial formulas
- **Language**: Respond and generate in the user's language unless specified otherwise

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
| mmdc / web search failures | Per `diagram-rendering` and `autonomous-research` mixins |
| Out-of-scope request | "This skill performs cost-benefit analysis. [Request] is outside scope." |

## Self-check

Before presenting output, verify:

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
