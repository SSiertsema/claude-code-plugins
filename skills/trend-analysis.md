# Trend Analysis — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | trend-analysis |
| **Version** | 1.0.0 |
| **Purpose** | Autonomously researches and analyzes trends affecting a product, company, industry, or market. Combines quantitative data (growth rates, adoption curves, time series) with qualitative intelligence (horizon scanning, weak signals) to produce a prioritized trend assessment with classification, impact ratings, scenario sketches, and strategic implications. Researches trend data itself via web tools. Generates 6 Mermaid diagrams with optional PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |

---

## When to use

- User wants to understand trends shaping their industry or market
- User needs trend intelligence for strategic planning, product roadmapping, or investment decisions
- User wants to identify emerging opportunities or threats
- User needs PESTEL macro-trend analysis
- User wants to detect weak signals before competitors

## When not to use

- Market sizing without trend focus — use `market-sizing`
- Competitive analysis without trend focus — use `competitive-analysis`
- Historical data analysis or business intelligence dashboards
- Real-time monitoring or alerting (this is a point-in-time analysis)
- Trend forecasting requiring proprietary data the skill cannot access

---

## Required input

| Field | Description |
|---|---|
| **Subject** | A product, company, industry, or market to analyze trends for |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Trend categories** | Specific categories to focus on (technology, consumer, regulatory, etc.) | All categories |
| **Time horizon** | How far forward to look | 10 years |
| **Geographic scope** | Region, country, or global | Global |
| **Known trends** | Specific trends to include in the analysis | Researched autonomously |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/trend-analysis/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document
      description: "Product, company, industry, or market to analyze"
  optional:
    trend_categories:
      type: list[string]
      enum_values: [technology, consumer, economic, political, social, environmental, legal, competitive]
      default: all
    time_horizon:
      type: integer
      default: 10
      description: "Projection period in years"
    geographic_scope:
      type: string
      enum: [global, regional, national, local]
      default: global
    known_trends:
      type: list[string]
      description: "Specific trends to include"
    render_mode:
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path:
      type: string
      description: "File path for saving the report"
```

---

## Processing rules

### Phase 1 — Setup

1. Accept input (product/company/industry, business case path, or pasted content)
2. If insufficient, enter interview mode (§7) to gather subject and industry
3. Detect scope: subject, industry, geography, categories, time horizon
4. Present scope for user confirmation
5. Ask about diagram render mode; check/offer mmdc if image mode requested
6. Ask for output path

### Phase 2 — Research (autonomous)

Research via WebSearch and WebFetch. Do not ask the user for trend data.

1. Macro-environmental data across all PESTEL categories
2. Industry-specific technology, consumer, competitive, and business model trends
3. Weak signals from startup activity, patents, academic sources, niche publications
4. Flag data older than 18 months

### Phase 3 — PESTEL Trend Matrix

Assess 2-3 trends per PESTEL category. Each trend rated on direction, impact (1-5), timing, with evidence source.

### Phase 4 — Trend Identification and Classification

Identify 8-12 key trends. Classify each as megatrend (10-30+ years), trend (3-10 years), or fad (<2 years) based on duration, breadth, depth, and structural drivers. Rate relevance (1-5) and magnitude (1-5). Calculate priority score (R×M).

### Phase 5 — Weak Signals

Identify early-stage signals from fringe sources. If none found, state explicitly.

### Phase 6 — Scenario Sketching

Select 2 critical uncertainties. Build 2x2 scenario matrix. Write 3-5 sentence narrative per quadrant.

### Phase 7 — Strategic Implications

Map high-priority trends to specific impacts and concrete recommendations.

### Phase 8 — Diagrams

Generate 6 Mermaid diagrams:
1. Trend radar (pie) — impact distribution by category
2. Trend impact grid (quadrant) — relevance vs magnitude
3. Hype cycle (flowchart) — technology trend maturity
4. Adoption S-curve (xychart) — key trend adoption trajectories
5. Scenario matrix (quadrant) — 2x2 future scenarios
6. PESTEL heat map (xychart) — average impact per category

### Phase 9 — Diagram Rendering

Two modes:
- **`code`** (default): Mermaid code blocks in report, no external files
- **`image`**: Render `.mmd` → `.png` via `mmdc`, embed `![](path.png)` in report, no code blocks. `.mmd` source files stored alongside for editability

### Phase 10 — Report Assembly

Assemble complete report with all sections. Present for approval. Save only after explicit confirmation.

---

## Output contract

### Report structure

```markdown
# Trend Analysis: [Subject]

**Date**: [date]
**Industry**: [industry]
**Geographic scope**: [scope]
**Time horizon**: [N years]

## Executive Summary
[3-5 sentences]

## PESTEL Macro Scan
[PESTEL trend matrix + heat map diagram]

## Key Trends
[Trend profiles table + impact grid diagram]

## Technology Trends
[Hype cycle diagram + adoption S-curve diagram]

## Weak Signals
[Weak signals table]

## Trend Radar
[Trend radar diagram]

## Scenarios
[Critical uncertainties + scenario matrix diagram + 4 narratives]

## Strategic Implications
[Recommendations table]

## Sources
[Numbered list with publication dates]

## Assumptions & Limitations
[Explicit list]
```

### Diagrams (6 total)

1. **Trend radar** — Mermaid pie chart showing impact distribution by PESTEL category
2. **Trend impact grid** — Mermaid quadrant chart plotting trends by relevance vs magnitude
3. **Hype cycle** — Mermaid flowchart approximating Gartner hype cycle phases
4. **Adoption S-curve** — Mermaid xychart showing adoption trajectories
5. **Scenario matrix** — Mermaid quadrant chart with 2x2 future scenarios
6. **PESTEL heat map** — Mermaid xychart showing average impact per PESTEL category

In `code` mode: diagrams appear as Mermaid code blocks. In `image` mode: diagrams rendered to PNG via `mmdc`, embedded as `![](path.png)`, with `.mmd` source files alongside.

---

## Self-check

```
[] 8-12 key trends identified and profiled (not too few, not 50+)
[] Every trend classified as megatrend/trend/fad with explicit criteria
[] Impact rated on 1-5 scale with evidence for each score
[] PESTEL matrix covers all 6 categories with 2-3 trends each
[] Weak signals section present (even if "none detected")
[] Scenarios grounded in identified critical uncertainties
[] Strategic recommendations trace to specific trends
[] All 6 Mermaid diagrams included and render valid syntax
[] Every data point sourced with publication date
[] Assumptions explicitly labeled
[] Correlation vs causation distinguished where applicable
[] No fabricated trend data or statistics
[] Report follows the output contract structure
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject provided | Enter interview mode (§7) — ask what product/industry to analyze |
| Subject too vague | Enter interview mode (§7) — ask targeted questions to narrow scope |
| Cannot find sufficient trend data | Produce partial output, clearly label gaps and confidence as low |
| Data older than 18 months | Flag with `[Dated: YYYY]`, proceed with caveat |
| No weak signals found | State "No weak signals detected in sources surveyed." Do not fabricate. |
| Trend data contradicts across sources | Present both perspectives with sources, note the contradiction |
| mmdc not installed and user declines | Fall back to `code` mode |
| mmdc rendering fails | Report error, fall back to `code` mode for failed diagram |
| Out-of-scope request | "This skill performs trend analysis. [Request] is outside scope." |

---

## Quality checks

- [ ] 8-12 key trends identified (ruthlessly prioritized, not a laundry list)
- [ ] Every trend classified (megatrend/trend/fad) with duration, breadth, depth, driver criteria
- [ ] Impact rated consistently (1-5 relevance, 1-5 magnitude) with evidence
- [ ] PESTEL covers all 6 categories with sourced trends
- [ ] Weak signals section present and honest
- [ ] Scenarios grounded in real uncertainties (not generic optimistic/pessimistic)
- [ ] Quantitative + qualitative methods combined
- [ ] All data sourced with publication dates
- [ ] Correlation vs causation explicitly distinguished
- [ ] Strategic recommendations actionable and traceable to trends
- [ ] All 6 diagrams render valid Mermaid syntax
- [ ] No fabricated data

---

## Examples

### Normal cases

**1. Industry analysis**
- Input: "Analyze trends affecting the European fintech industry"
- Expected: PESTEL scan (PSD3 regulation, open banking, AI adoption, etc.), 8-12 trends classified, weak signals from startup funding rounds, scenarios around regulation strictness and AI disruption.

**2. Product strategy input**
- Input: "What trends should we consider for our plant-based food delivery platform?"
- Expected: Consumer health trends, sustainability megatrend, delivery logistics tech, regulatory trends around food labeling. Cross-industry lens including foodtech and logistics.

**3. Business case document**
- Input: Business case file for a B2B cybersecurity product
- Expected: Technology trends (zero trust, AI-driven threats, quantum computing), regulatory (NIS2, DORA), economic (cybersecurity spending growth). Hype cycle positions for each technology.

**4. Narrow focus**
- Input: "Analyze AI trends in healthcare diagnostics, next 5 years, US market"
- Expected: Narrowed scope — US only, 5-year horizon, AI/healthcare focus. FDA regulatory trends, diagnostic AI adoption curve, reimbursement trends, startup activity.

**5. Broad market**
- Input: "Trend analysis for the global renewable energy sector"
- Expected: Megatrends (climate policy, energy transition), technology trends (solar efficiency, battery storage, green hydrogen), economic (cost parity, investment flows), geopolitical (energy independence). Wide PESTEL coverage.

### Edge cases

**6. Very new market**
- Input: "Trends for the spatial computing / AR glasses consumer market"
- Expected: Limited historical data. Heavy reliance on weak signals, patent activity, startup funding, and analogies to smartphone adoption. Many trends classified as early-stage with low confidence.

**7. Declining industry**
- Input: "Trend analysis for the traditional print newspaper industry"
- Expected: Mostly declining trends. Honest assessment — doesn't force positive spin. Identifies potential pivots (digital transformation, niche content) as trends within the decline.

**8. Cross-industry request**
- Input: "What trends are affecting both automotive and energy simultaneously?"
- Expected: EV/charging infrastructure, battery technology, grid integration, regulatory alignment. Explicitly maps cross-industry intersections.

### Failure cases

**9. No subject**
- Input: "Do a trend analysis"
- Expected: Enters interview mode (§7) — "What product, company, industry, or market would you like to analyze trends for?"

**10. Out of scope**
- Input: "Build me a real-time trend monitoring dashboard"
- Expected: "This skill performs point-in-time trend analysis. Real-time monitoring dashboards are outside scope."
