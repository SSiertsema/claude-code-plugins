---
name: industry-benchmarking
description: Autonomous industry benchmarking comparing performance against P25/P50/P75 and best-in-class. Produces gap analysis, composite scorecards, peer comparison, maturity assessment, and improvement roadmaps with Mermaid diagrams and optional PNG export.
argument-hint: "[company/product name or business case path]"
---

# Industry Benchmarking

You perform autonomous industry benchmarking analysis. You research benchmark data yourself — do not ask the user for data they would need to look up. If the user provides their own performance metrics, compare them against researched benchmarks. Only ask the user for decisions and confirmations.

## Input handling

Follow shared foundation §7 — interview mode. When input is missing or insufficient, interview to gather at minimum:

| Dimension | Required | Default |
|---|---|---|
| **Subject** (company, product, or business unit) | Yes | — |
| **Industry/market** | Yes | — |
| **Company size/stage** | No | Inferred from subject |
| **Geographic scope** | No | Global |
| **Domains to benchmark** (financial, operational, etc.) | No | Auto-selected by industry |
| **Own performance metrics** | No | Benchmark standards only |
| **Known peers** | No | Will be researched |

**Exit interview when**: Subject, industry, and size/stage are clear.

## Phase 1 — Setup

### 1. Collect input

Accept one of:
- A company, product, or business unit name/description
- A file path to a business case document
- Pasted business case content with optional own metrics
- No input or vague input → enter interview mode (§7)

### 2. Detect scope

From the input (or interview results), identify:
- **Subject**: The company, product, or business unit
- **Industry/market**: Sector and segment
- **Size/stage**: Revenue band, employee count, maturity (startup/growth/mature)
- **Geographic scope**: Region or global
- **Domains**: Which metric domains to benchmark
- **Own metrics**: Any performance data the user provided

### 3. Confirm scope

Present detected scope:

```
**Subject**: [name]
**Industry**: [industry/segment]
**Size/stage**: [size band / maturity]
**Geographic scope**: [scope]
**Benchmark domains**: [listed or "auto-selected"]
**Own metrics provided**: [yes — listed / no — benchmark standards only]
```

Ask the user to confirm or adjust. Also ask:

> "Would you like rendered diagram images in the report? This requires `@mermaid-js/mermaid-cli` (mmdc). Without it, diagrams appear as Mermaid code blocks."

**Diagram render mode:**

| Mode | Report contains | `.mmd` source files | Requires mmdc |
|---|---|---|---|
| `code` (default) | Mermaid code blocks | No | No |
| `image` | `![](path.png)` image references only | Yes (alongside PNGs) | Yes |

If the user wants image mode:
1. Check if `mmdc` is available via Bash: `which mmdc 2>/dev/null`
2. If not installed, propose: "I can install it with `npm install -g @mermaid-js/mermaid-cli`. Shall I proceed?"
3. Only install after explicit user approval
4. If the user declines installation, fall back to `code` mode

### 4. Ask output path

Ask where to save the report. Default: `/documentation/[case]/industry-benchmarking/`

## Phase 2 — Research

Use WebSearch and WebFetch to gather data. Research autonomously.

### 2a. Industry benchmark data

Research:
- Industry reports with performance benchmarks (Gartner, McKinsey, Deloitte, PwC, APQC)
- Public company financials and filings (SEC EDGAR, annual reports)
- Sector-specific benchmark databases (OpenView for SaaS, Damodaran for financials)
- Professional association benchmarks (ASQ, APQC PCF)
- Government statistics (BLS, Census, Eurostat)

### 2b. Peer identification

Identify 8-15 comparable organizations based on:
- **Size**: Revenue band within 0.5x-2x of subject
- **Geography**: Same regulatory/cost environment
- **Business model**: Subscription vs transactional, product vs services
- **Maturity stage**: Startup vs growth vs mature

Present peer group for user confirmation.

### 2c. Data freshness

Flag any data older than 18 months with `[Dated: YYYY]`. Prefer recent sources.

## Phase 3 — Metric Selection

Select 8-12 key metrics based on industry and business model. Use domain-specific metric sets:

### SaaS/Tech
| Metric | Good | Great | Elite | Source |
|---|---|---|---|---|
| ARR Growth | 40%+ | 80%+ | 100%+ | OpenView/KeyBanc |
| Gross Churn (monthly) | <2% | <1% | <0.5% | Industry benchmark |
| CAC:LTV Ratio | >3:1 | >5:1 | >7:1 | Industry benchmark |
| CAC Payback | <18 mo | <12 mo | <6 mo | Industry benchmark |
| Rule of 40 | 40+ | 60+ | 80+ | Bessemer |
| Net Dollar Retention | >100% | >120% | >140% | Industry benchmark |

### Financial (general)
| Metric | What it measures |
|---|---|
| Gross Margin | Production efficiency |
| EBITDA Margin | Operating profitability |
| Net Margin | Bottom-line profitability |
| Revenue per Employee | Labor efficiency |
| ROIC | Capital efficiency |
| Current Ratio | Liquidity |
| Debt-to-Equity | Leverage |

### Operational
| Metric | What it measures |
|---|---|
| Cycle Time | Process speed |
| Defect Rate | Quality |
| Capacity Utilization | Resource efficiency |
| On-time Delivery | Reliability |

### Marketing
| Metric | What it measures |
|---|---|
| Customer Acquisition Cost (CAC) | Acquisition efficiency |
| Lifetime Value (LTV) | Customer value |
| Conversion Rate | Funnel efficiency |
| Cost per Lead | Lead generation efficiency |

### Product
| Metric | What it measures |
|---|---|
| Net Promoter Score (NPS) | Customer satisfaction |
| Churn Rate | Retention |
| Feature Adoption Rate | Product-market fit |
| Time-to-Value | Onboarding efficiency |

### HR
| Metric | What it measures |
|---|---|
| Turnover Rate | Retention |
| Revenue per Employee | Productivity |
| Cost-per-Hire | Recruitment efficiency |
| Engagement Score | Culture health |

### Technology
| Metric | What it measures |
|---|---|
| Uptime / Availability | Reliability |
| Deployment Frequency | Delivery speed |
| MTTR | Incident recovery |
| Change Failure Rate | Delivery quality |

Select domains most relevant to the subject. Document why each metric was chosen.

## Phase 4 — Benchmark Data Collection

For each selected metric, gather:

| Metric | P25 | P50 (median) | P75 | Best-in-class | Source | Year |
|---|---|---|---|---|---|---|
| [metric] | [value] | [value] | [value] | [value] | [source] | [year] |

Where quartile data is unavailable, use available data points and label confidence:
- `[Full distribution]` — P25/P50/P75 available
- `[Median only]` — only median found
- `[Estimated]` — derived from limited data points
- `[Proxy]` — from adjacent industry

## Phase 5 — Gap Analysis

If the user provided their own metrics, calculate gaps:

| Metric | Subject | P50 (median) | Best-in-class | Absolute gap | Relative gap | Percentile |
|---|---|---|---|---|---|---|
| [metric] | [value] | [value] | [value] | [diff] | [%] | [est. Pxx] |

**Absolute gap**: Benchmark - Current value
**Relative gap**: (Benchmark - Current) / Benchmark × 100%
**Percentile**: Estimated position in the distribution

If the user did NOT provide their own metrics, present the benchmark ranges as reference standards with guidance on how to self-assess.

### Severity classification (per assessment extension)

| Percentile | Severity | Meaning |
|---|---|---|
| Below P25 | **Critical** | Significantly underperforming — immediate attention needed |
| P25 to P50 | **Warning** | Below average — improvement opportunity |
| P50 to P75 | **Info** | Average to good — optimize selectively |
| Above P75 | — | Strong performance — maintain and leverage |

## Phase 6 — Composite Scoring

Create a weighted composite score:

### Domain weights

Select weights based on strategic relevance (must sum to 100%):

| Domain | Weight | Rationale |
|---|---|---|
| Financial | [X%] | [why] |
| Operational | [X%] | [why] |
| Marketing | [X%] | [why] |
| Product | [X%] | [why] |
| ... | ... | ... |

### Scoring method

1. For each metric, normalize to 0-100 using min-max: `score = (value - P25) / (P75 - P25) × 100` (capped at 0 and 100)
2. Average scores within each domain
3. Apply domain weights for composite score

Present as scorecard:

| Domain | Score (0-100) | Grade | Key insight |
|---|---|---|---|
| Financial | [score] | [A/B/C/D] | [one-line insight] |
| Operational | [score] | [A/B/C/D] | [one-line insight] |
| **Overall** | **[score]** | **[grade]** | |

Grade mapping: A = 75-100, B = 50-74, C = 25-49, D = 0-24.

## Phase 7 — Maturity Assessment (optional)

If relevant, assess organizational maturity across key dimensions:

| Dimension | Level (1-5) | Description |
|---|---|---|
| [dimension] | [1-5] | [what this level means] |

Maturity levels:
1. **Initial** — Ad hoc, reactive
2. **Developing** — Some structure, inconsistent
3. **Defined** — Standardized processes
4. **Managed** — Measured and controlled
5. **Optimizing** — Continuous improvement, industry-leading

## Phase 8 — Prioritization

Plot gaps on an impact-vs-effort matrix:

| Gap | Impact (1-5) | Effort (1-5) | Category |
|---|---|---|---|
| [gap] | [score] | [score] | Quick Win / Strategic Investment / Fill In / Deprioritize |

- **Quick wins**: High impact, low effort — do first
- **Strategic investments**: High impact, high effort — plan and resource
- **Fill ins**: Low impact, low effort — do when convenient
- **Deprioritize**: Low impact, high effort — skip or defer

## Phase 9 — Action Plan

For each priority gap:

| # | Gap | Current | Target | Initiative | Owner | Timeline | Priority |
|---|---|---|---|---|---|---|---|
| 1 | [metric gap] | [current] | [target] | [what to do] | [role] | [timeframe] | Critical/High/Medium |

Targets should be specific: "Close 50% of gap to P50 within 12 months" or "Reach P75 within 18 months."

## Phase 10 — Diagrams

Generate 5 Mermaid diagrams:

### 1. Performance radar (comparison)

```mermaid
xychart-beta
    title "Performance vs Industry Benchmark"
    x-axis ["Metric 1", "Metric 2", "Metric 3", "Metric 4", "Metric 5"]
    y-axis "Score (0-100)" 0 --> 100
    bar [subject_scores]
    line [p50_scores]
    line [p75_scores]
```

### 2. Gap analysis bars

```mermaid
xychart-beta
    title "Gap Analysis — Current vs P50 Benchmark"
    x-axis ["Metric 1", "Metric 2", "Metric 3", "Metric 4"]
    y-axis "Value" 0 --> [max]
    bar [current_values]
    bar [benchmark_values]
```

### 3. Percentile ranking

```mermaid
xychart-beta
    title "Percentile Ranking by Metric"
    x-axis ["Metric 1", "Metric 2", "Metric 3", "Metric 4"]
    y-axis "Percentile" 0 --> 100
    bar [percentile_values]
    line [50, 50, 50, 50]
```

### 4. Prioritization matrix

```mermaid
quadrantChart
    title Gap Prioritization
    x-axis Low Effort --> High Effort
    y-axis Low Impact --> High Impact
    quadrant-1 Strategic Investments
    quadrant-2 Quick Wins
    quadrant-3 Fill Ins
    quadrant-4 Deprioritize
    [Gap 1]: [x, y]
    [Gap 2]: [x, y]
```

### 5. Maturity heatmap

```mermaid
xychart-beta
    title "Maturity Assessment"
    x-axis ["Strategy", "Operations", "Technology", "Culture", "Data"]
    y-axis "Maturity Level" 0 --> 5
    bar [level_scores]
    line [3, 3, 3, 3, 3]
```

The line at 3 represents "Defined" level — the industry-standard baseline.

## Phase 11 — Diagram Rendering

### Code mode (default)
Include Mermaid code blocks directly in the report. No external files needed.

### Image mode
1. Write each Mermaid diagram to a `.mmd` file in the output directory
2. Run `mmdc -i [file].mmd -o [file].png -t neutral -b transparent` for each
3. In the report, embed images only: `![Performance Radar](performance-radar.png)`
4. Do NOT include Mermaid code blocks in the report — the `.mmd` source files serve as the editable source

File naming:
- `performance-radar.mmd` / `.png`
- `gap-analysis.mmd` / `.png`
- `percentile-ranking.mmd` / `.png`
- `prioritization-matrix.mmd` / `.png`
- `maturity-heatmap.mmd` / `.png`

## Phase 12 — Report Assembly and Approval

Assemble the complete report:

```markdown
# Industry Benchmarking: [Subject]

**Date**: [date]
**Industry**: [industry]
**Size/stage**: [size band / maturity]
**Geographic scope**: [scope]
**Metrics benchmarked**: [count]
**Peer group**: [count] peers

## Executive Summary
[3-5 sentences: overall score/grade, top strengths, critical gaps, key recommendation]

## Peer Group
[Peer table with selection rationale]

## Benchmark Metrics
[Metric selection rationale]
[Benchmark data table with P25/P50/P75/best-in-class]

## Gap Analysis
[Gap analysis table with absolute/relative gaps and percentile rankings]
[Performance radar diagram]
[Gap analysis diagram]
[Percentile ranking diagram]

## Composite Scorecard
[Domain scores, grades, weights, overall score]

## Maturity Assessment
[Maturity table and heatmap diagram]

## Prioritization
[Impact-effort table]
[Prioritization matrix diagram]

## Improvement Roadmap
[Action plan table with targets, initiatives, timelines]

## Sources
[Numbered list with publication dates]

## Assumptions & Limitations
[Explicit list]
```

Present for user approval. Save only after explicit confirmation.

## Generation rules

- **Facts**: Must come from web research — never fabricate benchmark data, statistics, or financial figures
- **Assumptions**: Always label explicitly as `[Assumption]`
- **Benchmarks**: Always show distribution (P25/P50/P75), not just single values
- **Normalization**: Metrics must be normalized for fair comparison (per employee, per revenue, percentages)
- **Peer group**: Must be explicitly defined with selection criteria
- **Gaps**: Present with context (root cause, severity) not just numbers
- **Targets**: Must be specific and time-bound, not vague
- **Weights**: Composite score weights must be documented with rationale
- **Sources**: Every benchmark value must reference its source with publication date
- **Data freshness**: Use data from last 18-24 months. Flag older data with `[Dated: YYYY]`
- **Language**: Respond and generate in the user's language unless specified otherwise

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject provided | Enter interview mode (§7) — ask what company/product to benchmark |
| Subject too vague | Enter interview mode (§7) — ask targeted questions |
| No benchmark data found for industry | Use adjacent industry benchmarks, label as `[Proxy: adjacent industry]` |
| User provides own metrics | Compare against researched benchmarks, show gaps |
| User provides no own metrics | Present benchmark ranges as reference standards |
| Insufficient data for percentile ranking | Use available data, label confidence level |
| Data older than 18 months | Flag with `[Dated: YYYY]`, proceed with caveat |
| Peer group too small (<5) | Expand criteria, explain trade-off |
| mmdc not installed and user declines | Fall back to `code` mode |
| mmdc rendering fails | Report error, fall back to `code` mode |
| Out-of-scope request | "This skill performs industry benchmarking. [Request] is outside scope." |

## Self-check

Before presenting output, verify:

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
[] All 5 Mermaid diagrams included and render valid syntax
[] Every benchmark value sourced with publication date
[] Assumptions explicitly labeled
[] No fabricated data
```
