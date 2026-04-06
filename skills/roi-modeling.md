# ROI Modeling — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | roi-modeling |
| **Version** | 1.0.0 |
| **Purpose** | Calculates return on investment for projects, initiatives, and investments using 6 ROI variants (basic, annualized, risk-adjusted, expected/probability-weighted, multi-period with discounting, intangibles). Includes 4 industry-specific models (IT/Technology TCO-based, Marketing ROAS/CAC/CLV, Training Phillips 5-level, Product R&D lifecycle). Performs scenario modeling (optimistic/realistic/pessimistic) with sensitivity analysis and break-even thresholds. Can import from business case or CBA output. Generates Mermaid diagrams with optional PNG export. |
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

- User needs to calculate ROI for a project, investment, or initiative
- User wants multi-scenario ROI projections (optimistic/realistic/pessimistic)
- User needs industry-specific ROI model (IT, marketing, training, product)
- User wants risk-adjusted or probability-weighted ROI
- User needs ROI comparison across multiple investment options
- User wants sensitivity analysis on ROI drivers

## When not to use

- Comprehensive cost-benefit analysis with full monetization — use `cost-benefit-analysis`
- Revenue/expense projections over time — use `financial-forecasting`
- Business case creation — use `business-case-management`
- Value proposition design — use `value-proposition-canvas`
- Problem-solution validation — use `problem-solution-fit`

---

## Required input

| Field | Description |
|---|---|
| **Investment/project context** | What is being invested in and why |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Business case/CBA output** | Existing business case or CBA report | None |
| **Investment amount** | Known or estimated investment | Will be researched |
| **Time horizon** | Analysis period in years | 3 years |
| **Industry/domain** | For industry-specific model selection | Inferred from context |
| **ROI variants** | Which calculations to include | All applicable |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/roi-modeling/` |

## Input schema

```
input:
  required:
    investment_context:
      type: string
      description: "What is being invested in and why"
  optional:
    business_case:
      type: string | file_path
      description: "Existing business case or CBA report to import from"
    investment_amount:
      type: number
      description: "Known or estimated investment amount"
    time_horizon:
      type: integer
      default: 3
      description: "Analysis period in years"
    industry:
      type: string
      description: "Industry for model selection (it, marketing, training, product)"
    variants:
      type: list[string]
      enum: [basic, annualized, risk_adjusted, expected, multi_period, intangibles]
      default: all_applicable
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
| **What may be invented** | Cost estimates based on industry benchmarks, benefit projections based on typical patterns, scenario assumptions based on industry norms |
| **What must be grounded** | ROI formulas (all 6 variants), Phillips methodology levels, TCO components, ROAS/CAC/CLV definitions, sensitivity analysis methodology |
| **What assumptions are allowed** | Cost ranges based on industry data, benefit magnitudes based on comparable investments, risk factors based on investment type |
| **What must never be fabricated** | Specific financial figures without research basis, actual company data, guaranteed returns, benchmark numbers without source |

---

## Processing rules

### Phase 1 — Setup
1. Parse input, detect investment context
2. If insufficient → interview mode (§7)
3. Check for business case/CBA input to import
4. Detect industry for model selection (IT → TCO, Marketing → ROAS/CLV, Training → Phillips, Product → lifecycle)
5. Confirm scope, variants, time horizon with user
6. Ask diagram render mode (per diagram-rendering mixin)
7. Ask output path (default: `/documentation/[case]/roi-modeling/`)

### Phase 2 — Research
8. WebSearch/WebFetch (per autonomous-research mixin) for industry ROI benchmarks
9. Research comparable investment cost data
10. Research typical benefit realization timelines
11. Research industry-specific model parameters

### Phase 3 — Investment Cost Modeling
12. Itemize: initial investment, ongoing costs, hidden costs
13. TCO calculation for technology investments
14. Exclude sunk costs explicitly
15. Assign costs to periods (Year 0 through Year N)
16. Document confidence level per estimate
17. Present for user confirmation

### Phase 4 — Benefit Modeling
18. Itemize quantifiable benefits (revenue, savings, productivity, risk reduction)
19. Identify intangible benefits (brand, satisfaction, strategic positioning)
20. Monetize intangibles with documented technique and confidence
21. Assign benefits to periods
22. Present for user confirmation

### Phase 5 — Basic ROI Calculation
23. Basic ROI = (Net Benefit / Cost) × 100%
24. Annualized ROI for multi-year
25. Cumulative ROI by period
26. Payback period

### Phase 6 — Advanced ROI Calculations
27. Risk-Adjusted ROI with documented risk factors
28. Expected ROI probability-weighted across scenarios
29. Multi-Period ROI (NPV-based) with justified discount rate
30. Industry-specific metrics (TCO, ROAS, CAC, CLV, Phillips levels as applicable)

### Phase 7 — Scenario Modeling
31. Define 3 scenarios (optimistic, realistic, pessimistic) with distinct assumptions
32. Calculate all ROI variants per scenario
33. Compute Expected ROI as weighted average

### Phase 8 — Sensitivity Analysis
34. Identify 3-5 key ROI drivers
35. One-way sensitivity: vary each ±20%, recalculate ROI
36. Determine break-even thresholds (ROI = 0%)

### Phase 9 — Investment Comparison
37. If multiple options: side-by-side table, rank by Expected ROI, recommend with justification

### Phase 10 — Diagrams
38. Generate 4 Mermaid diagrams:
    1. ROI Timeline (xychart-beta) — cumulative ROI % over time
    2. Cost-Benefit Breakdown (xychart-beta) — costs vs benefits by category
    3. Scenario Comparison (xychart-beta) — ROI per scenario
    4. Sensitivity Tornado (xychart-beta) — variable impact on ROI
39. Render per diagram-rendering mixin

### Phase 11 — Report Assembly
40. Assemble complete report, present for approval, save after confirmation

---

## Output contract

```markdown
# ROI Model: [Investment/Project]

**Date**: [date]
**Investment**: [name]
**Time horizon**: [N years]
**Industry model**: [model applied]
**Basic ROI**: [X%]
**Risk-Adjusted ROI**: [X%]
**Expected ROI**: [X%]
**Payback period**: [N months/years]

## Executive Summary
[Key findings: ROI across scenarios, critical drivers, recommendation]

## Methodology
[Variants used, discount rate justification, industry model rationale]

## Investment Cost Breakdown
[Cost table with totals by category]

## Benefit Analysis
[Benefit table with monetization methods and confidence]

## ROI Calculations
### Basic ROI + Annualized ROI + Cumulative by Period
### Multi-Period ROI (NPV-Based)
### Risk-Adjusted ROI
### Industry-Specific Metrics

## ROI Timeline
[Cumulative ROI chart]

## Cost-Benefit Breakdown
[Cost vs benefit chart]

## Scenario Analysis
[3 scenarios + comparison chart + Expected ROI]

## Sensitivity Analysis
[Key drivers + tornado chart + break-even thresholds]

## Investment Comparison (if applicable)
[Side-by-side + ranking]

## Recommendations
[Prioritized, traced to findings]

## Sources

## Assumptions & Limitations
```

### Diagrams

| # | Diagram | Mermaid type | Content |
|---|---|---|---|
| 1 | ROI Timeline | xychart-beta | Cumulative ROI % over time with payback point |
| 2 | Cost-Benefit Breakdown | xychart-beta | Costs vs benefits by category |
| 3 | Scenario Comparison | xychart-beta | ROI per scenario per option |
| 4 | Sensitivity Tornado | xychart-beta | Variable impact on ROI sorted by magnitude |

Rendering per diagram-rendering mixin.

---

## Self-check

### Must verify before output
```
[] Investment costs fully itemized (initial + ongoing + hidden)
[] Benefits itemized with monetization technique and confidence
[] Sunk costs explicitly excluded
[] Basic ROI calculated correctly
[] Annualized ROI for multi-year investments
[] Cumulative ROI shows payback point
[] Risk-adjusted ROI with documented risk factors
[] Expected ROI probability-weighted across 3 scenarios
[] Multi-period ROI with justified discount rate
[] 3 scenarios with distinct documented assumptions
[] Sensitivity on 3-5 key drivers
[] Break-even thresholds identified
[] Payback period calculated
[] Industry-specific metrics where applicable
[] All 4 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
[] Sources listed (per autonomous-research mixin)
[] Assumptions labeled with confidence (per autonomous-research mixin)
[] All calculations mathematically consistent
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No investment context | Enter interview mode (§7) — "What investment or project should I model ROI for?" |
| Context too vague | Enter interview mode (§7) — ask targeted questions |
| Cannot estimate costs | Report gap, use ranges with low confidence |
| Investment amount unknown | Research comparables, propose range |
| Single scenario only | Produce all three with noted assumptions |
| Industry model not applicable | Use general ROI model, note limitation |
| CBA/business case malformed | Ask user to verify, attempt partial import |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| Out-of-scope request | "This skill models ROI for investments. [Request] is outside scope." |

---

## Quality checks

- [ ] Investment costs fully itemized with categories and timing
- [ ] Benefits monetized with documented technique and confidence level
- [ ] Sunk costs explicitly excluded
- [ ] All applicable ROI variants calculated with correct formulas
- [ ] Annualized ROI used for multi-year comparisons
- [ ] Discount rate justified for multi-period calculations
- [ ] Three scenarios with distinct, documented assumptions
- [ ] Expected ROI calculated as probability-weighted average
- [ ] Sensitivity analysis on 3-5 highest-impact variables
- [ ] Break-even thresholds calculated for key variables
- [ ] Industry-specific metrics applied where appropriate
- [ ] Payback period identified
- [ ] No fabricated financial figures or benchmarks
- [ ] All 4 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] Sources listed for benchmarks and claims (per autonomous-research mixin)
- [ ] Assumptions labeled with confidence (per autonomous-research mixin)

---

## Examples

### Normal cases

**1. Cloud migration**
- Input: "Model ROI for migrating our on-premise infrastructure to AWS"
- Expected: IT/Technology TCO-based model. Costs: migration, retraining, cloud services. Benefits: infrastructure savings, scalability, reduced maintenance. TCO comparison current vs cloud. 3-year horizon with payback in Year 2.

**2. Marketing campaign**
- Input: "Calculate ROI for our Q4 digital marketing campaign with $200K budget"
- Expected: Marketing model with ROAS, CAC, CLV calculations. LTV:CAC ratio benchmarked against 3:1. Campaign-level ROI by channel if data available.

**3. Employee training program**
- Input: "Model ROI for our leadership development program for 50 managers"
- Expected: Phillips 5-level methodology. Level 1-4 assessment plus Level 5 ROI calculation. Intangible benefits (retention, engagement) reported separately.

**4. New product development**
- Input: "ROI for investing $500K in developing a new SaaS feature"
- Expected: Product lifecycle ROI. R&D costs, projected revenue from feature adoption, time to revenue breakeven. Multi-period ROI with discounting.

**5. With CBA input**
- Input: [CBA report path] + "Now model the ROI specifically"
- Expected: Imports costs/benefits from CBA, focuses on ROI variant calculations, scenarios, sensitivity analysis. No re-research of costs/benefits.

### Edge cases

**6. Very small investment**
- Input: "ROI for buying a $5K project management tool for our 10-person team"
- Expected: Simplified model, shorter horizon (1 year), basic ROI + payback period. Notes that full scenario modeling may be overkill.

**7. Non-profit social ROI**
- Input: "Model ROI for our community literacy program"
- Expected: Social ROI approach. Heavy intangible benefits (literacy rates, employment outcomes). Dual reporting: quantified ROI + intangible assessment. Monetization via avoided cost and proxy metrics.

**8. Multi-option comparison**
- Input: "Compare ROI for 4 different CRM platforms"
- Expected: Side-by-side ROI comparison with TCO-based costs. Ranking by Expected ROI and payback period. Recommendation with justification.

### Failure cases

**9. No context**
- Input: "Model ROI"
- Expected: Interview mode (§7) — "What investment or project should I model ROI for?"

**10. Out of scope**
- Input: "Forecast our revenue for next year"
- Expected: "This skill models ROI for investments and projects. Revenue forecasting is outside scope — use `financial-forecasting`."
