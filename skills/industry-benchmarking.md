# Industry Benchmarking — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | industry-benchmarking |
| **Version** | 1.0.0 |
| **Purpose** | Autonomously researches and produces industry benchmarking analysis for a company, product, or business unit. Compares performance metrics against industry standards (P25/P50/P75), peers, and best-in-class performers. Identifies gaps with percentile rankings, produces composite scorecards with weighted domain scores, optional maturity assessment, and a prioritized improvement roadmap. Researches data itself via web tools. Generates 5 Mermaid diagrams with optional PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Mixins** | `[diagram-rendering, autonomous-research]` |

---

## When to use

- User wants to understand how their company/product performs relative to industry standards
- User needs benchmark data for strategic planning or board reporting
- User wants to identify performance gaps and improvement priorities
- User needs peer comparison for investor presentations or due diligence
- User wants a maturity assessment across capability dimensions

## When not to use

- Competitive analysis (strategy, positioning) — use `competitive-analysis`
- Market sizing — use `market-sizing`
- Trend analysis — use `trend-analysis`
- Customer segmentation — use `customer-segmentation`
- Internal performance dashboarding or real-time monitoring
- Financial valuation or investment analysis
- Benchmarking requiring access to proprietary internal data the skill cannot research

---

## Required input

| Field | Description |
|---|---|
| **Subject** | A company, product, or business unit to benchmark |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Industry vertical** | Specific industry or sub-sector | Inferred from subject |
| **Company size/stage** | Revenue band, employee count, maturity | Inferred from subject |
| **Geographic scope** | Region, country, or global | Global |
| **Domains to benchmark** | Financial, operational, marketing, product, HR, technology | Auto-selected by industry |
| **Own performance metrics** | User's actual performance data to compare | Benchmark standards only |
| **Known peers** | Specific companies to include in peer group | Researched autonomously |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/industry-benchmarking/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document
      description: "Company, product, or business unit to benchmark"
  optional:
    industry:
      type: string
      description: "Industry or sub-sector"
    size_stage:
      type: object
      fields:
        revenue_band: string
        employee_count: integer
        maturity: enum [startup, growth, mature]
    geographic_scope:
      type: string
      enum: [global, regional, national, local]
      default: global
    domains:
      type: list[string]
      enum_values: [financial, operational, marketing, product, hr, technology]
      default: auto_selected
    own_metrics:
      type: object
      description: "Key-value pairs of metric name to value"
    known_peers:
      type: list[string]
      description: "Companies to include in peer group"
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

1. Accept input
2. If insufficient, enter interview mode (§7) to gather subject, industry, size/stage
3. Detect scope
4. Present scope for user confirmation
5. Ask about diagram render mode (per diagram-rendering mixin)
6. Ask for output path

### Phase 2 — Research (autonomous)

Research via WebSearch and WebFetch (per autonomous-research mixin):
1. Industry benchmark data from reports, analyst firms, public filings
2. Peer group identification (8-15 peers by size, geography, model, maturity)
3. Present peer group for user confirmation
4. Flag data older than 18 months

### Phase 3 — Metric Selection

Select 8-12 key metrics across relevant domains. Domain-specific sets:
- SaaS/Tech: ARR growth, churn, CAC:LTV, payback, Rule of 40, NDR
- Financial: Margins, ROIC, revenue/employee, ratios
- Operational: Cycle time, defect rate, utilization, delivery
- Marketing: CAC, LTV, conversion, cost per lead
- Product: NPS, churn, adoption, time-to-value
- HR: Turnover, revenue/employee, cost-per-hire
- Technology: Uptime, deploy frequency, MTTR, change failure rate

### Phase 4 — Benchmark Data Collection

Gather P25/P50/P75 and best-in-class for each metric. Label data confidence.

### Phase 5 — Gap Analysis

If user provided own metrics: calculate absolute gap, relative gap, percentile ranking. Classify severity by percentile band.

### Phase 6 — Composite Scoring

Weighted score across domains, normalized 0-100. Grade: A (75-100), B (50-74), C (25-49), D (0-24).

### Phase 7 — Maturity Assessment (optional)

1-5 scale across key dimensions if relevant.

### Phase 8 — Prioritization

Impact-vs-effort matrix: Quick wins, Strategic investments, Fill ins, Deprioritize.

### Phase 9 — Action Plan

Specific targets, initiatives, timelines per priority gap.

### Phase 10 — Diagrams

Generate 5 Mermaid diagrams:
1. Performance radar (xychart) — subject vs P50 vs P75
2. Gap analysis bars (xychart) — current vs benchmark
3. Percentile ranking (xychart) — percentile per metric
4. Prioritization matrix (quadrant) — impact vs effort
5. Maturity heatmap (xychart) — levels across dimensions

### Phase 11 — Diagram Rendering

Two modes:
- **`code`** (default): Mermaid code blocks in report
- **`image`**: Render `.mmd` → `.png` via `mmdc`, embed `![](path.png)`, `.mmd` source files alongside

### Phase 12 — Report Assembly

Assemble complete report. Present for approval. Save only after explicit confirmation.

---

## Output contract

### Report structure

```markdown
# Industry Benchmarking: [Subject]

**Date**: [date]
**Industry**: [industry]
**Size/stage**: [size / maturity]
**Geographic scope**: [scope]
**Metrics benchmarked**: [count]
**Peer group**: [count] peers

## Executive Summary
[3-5 sentences]

## Peer Group
[Peer table with selection rationale]

## Benchmark Metrics
[Selection rationale + benchmark data table (P25/P50/P75/best-in-class)]

## Gap Analysis
[Gap table + performance radar + gap analysis bars + percentile ranking diagrams]

## Composite Scorecard
[Domain scores, grades, weights, overall]

## Maturity Assessment
[Maturity table + heatmap diagram]

## Prioritization
[Impact-effort table + prioritization matrix diagram]

## Improvement Roadmap
[Action plan with targets, initiatives, timelines]

## Sources
[Numbered list with publication dates]

## Assumptions & Limitations
[Explicit list]
```

### Diagrams (5 total)

1. **Performance radar** — Mermaid xychart: subject vs P50 vs P75
2. **Gap analysis** — Mermaid xychart: current vs benchmark per metric
3. **Percentile ranking** — Mermaid xychart: percentile position per metric
4. **Prioritization matrix** — Mermaid quadrant: impact vs effort
5. **Maturity heatmap** — Mermaid xychart: maturity level across dimensions

Rendering per diagram-rendering mixin.

---

## Self-check

```
[] 8-12 metrics selected and justified
[] Benchmark data shows P25/P50/P75 distribution (not just averages)
[] Peer group defined with 8-15 peers and selection rationale
[] Metrics normalized for fair comparison
[] Gap analysis includes absolute gap, relative gap, and percentile ranking
[] Composite score shows weights, methodology, and domain breakdown
[] Severity classification applied (Critical/Warning/Info per percentile band)
[] Every gap has root-cause context and actionable recommendation
[] Action plan has specific, time-bound targets
[] All 5 Mermaid diagrams included and render valid syntax (per diagram-rendering mixin)
[] Every benchmark value sourced with publication date
[] Assumptions explicitly labeled
[] No fabricated data
[] Report follows the output contract structure
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject provided | Enter interview mode (§7) |
| Subject too vague | Enter interview mode (§7) |
| No benchmark data found for industry | Use adjacent industry, label as `[Proxy]` |
| User provides own metrics | Compare against researched benchmarks |
| User provides no own metrics | Present benchmark ranges as reference standards |
| Insufficient data for percentile ranking | Use available data, label confidence |
| Data older than 18 months | Flag with `[Dated: YYYY]` |
| Peer group too small (<5) | Expand criteria, explain trade-off |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| Out-of-scope request | "This skill performs industry benchmarking. [Request] is outside scope." |

---

## Quality checks

- [ ] 8-12 metrics (not too few, not 50 unprioritized KPIs)
- [ ] P25/P50/P75 distribution shown (not just averages)
- [ ] Peer group explicitly defined with selection rationale (8-15 peers)
- [ ] Metrics normalized for fair comparison
- [ ] Every gap has root-cause context and actionable recommendation
- [ ] Composite score shows weights, methodology, domain breakdown
- [ ] Severity mapped: Critical (<P25), Warning (P25-P50), Info (P50-P75)
- [ ] Action plan targets are specific and time-bound
- [ ] Data from last 18-24 months or flagged
- [ ] All data sourced with publication dates
- [ ] All 5 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] All data sourced with publication dates (per autonomous-research mixin)
- [ ] Assumptions explicitly labeled (per autonomous-research mixin)
- [ ] No fabricated data

---

## Examples

### Normal cases

**1. SaaS company benchmarking**
- Input: "Benchmark our B2B SaaS company ($5M ARR, 50 employees) against industry standards"
- Expected: SaaS-specific metrics (ARR growth, churn, CAC:LTV, Rule of 40, NDR). Peer group of similar-stage SaaS companies. Gap analysis with severity. Composite scorecard.

**2. Manufacturing company with own metrics**
- Input: "Our defect rate is 2.3%, cycle time 4.2 days, capacity utilization 72%. How do we compare in automotive manufacturing?"
- Expected: Compares provided metrics against automotive P25/P50/P75. Shows percentile position. Identifies gaps and quick wins.

**3. Fintech startup**
- Input: "Benchmark a Series B fintech company in European digital payments"
- Expected: Financial + product + technology metrics. Peer group of European fintechs. Growth-stage benchmarks (not mature company standards).

**4. E-commerce business**
- Input: "Industry benchmarking for a DTC e-commerce brand doing $20M revenue"
- Expected: Marketing-heavy metrics (CAC, LTV, conversion, AOV), operational (fulfillment time, return rate), financial (gross margin, contribution margin). E-commerce specific benchmarks.

**5. Enterprise software**
- Input: Business case file for an enterprise CRM platform
- Expected: Extracts company profile from document. SaaS + enterprise metrics. Maturity assessment included given enterprise context.

### Edge cases

**6. Very niche industry**
- Input: "Benchmark our space debris removal startup"
- Expected: Limited direct benchmarks. Uses proxy industries (aerospace, deeptech, space-adjacent). Labels all benchmarks as `[Proxy]`. Focuses on financial and operational metrics that apply cross-industry.

**7. No own metrics provided**
- Input: "What are the benchmark standards for a mid-market HR tech company?"
- Expected: Presents benchmark ranges (P25/P50/P75) as reference standards. No gap analysis (no subject data). Includes scorecard template the user can self-assess against.

**8. Cross-industry comparison**
- Input: "Compare our logistics company's tech maturity against best-in-class tech companies"
- Expected: Maturity assessment focused on technology dimension. Uses tech company benchmarks for tech metrics, logistics benchmarks for operational. Clearly labels the cross-industry comparison.

### Failure cases

**9. No subject**
- Input: "Do a benchmarking analysis"
- Expected: Enters interview mode (§7) — "What company, product, or business unit would you like to benchmark?"

**10. Out of scope**
- Input: "Monitor our KPIs in real-time and alert when we drop below benchmarks"
- Expected: "This skill performs point-in-time industry benchmarking. Real-time monitoring and alerting is outside scope."
