# Market Sizing — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | market-sizing |
| **Version** | 1.0.0 |
| **Purpose** | Autonomously researches and calculates TAM/SAM/SOM market sizing for a product, company, or business idea. Uses both top-down and bottom-up approaches with mandatory triangulation, produces growth projections with CAGR, segmentation breakdowns, sensitivity analysis, and validation cross-checks. Researches market data itself via web tools. Generates 6 Mermaid diagrams with optional PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |

---

## When to use

- User wants to understand the size of a market opportunity
- User needs TAM/SAM/SOM figures for a business case, pitch deck, or investment decision
- User wants to validate whether a market is large enough to pursue
- User has a product/company and needs market sizing for strategic planning
- User needs market segmentation with sizing per segment

## When not to use

- Financial valuation or DCF analysis
- Competitive analysis without market sizing — use `competitive-analysis`
- Customer segmentation as the primary goal without sizing
- Revenue forecasting / financial modeling (market sizing informs these but does not produce them)
- Internal capacity planning without market context

---

## Required input

| Field | Description |
|---|---|
| **Subject** | A product, company, business idea, or market to size |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Geographic scope** | Region, country, or global | Global |
| **Target segments** | Specific customer segments to focus on | Researched autonomously |
| **Pricing data** | ASP, ARPU, or contract values | Researched autonomously |
| **Time horizon** | Projection period in years | 5 years |
| **Known competitors** | Named competitors for validation | Researched autonomously |
| **PNG export** | Whether to render diagrams as PNG images | No |
| **Output path** | Where to save the report | `/documentatie/business/market-sizing-[subject].md` |

## Input schema

```
input:
  required:
    subject:
      type: string | document
      description: "Product, company, business idea, or market to size"
  optional:
    geographic_scope:
      type: string
      enum: [global, regional, national, local]
      default: global
    target_segments:
      type: list[string]
      description: "Customer segments to focus on"
    pricing_data:
      type: object
      fields:
        asp: number | null
        arpu: number | null
        currency: string
    time_horizon:
      type: integer
      default: 5
      description: "Projection period in years"
    competitors:
      type: list[string]
      description: "Named competitors for validation"
    png_export:
      type: boolean
      default: false
      dependency: "@mermaid-js/mermaid-cli (mmdc)"
    output_path:
      type: string
      description: "File path for saving the report"
```

---

## Processing rules

### Phase 1 — Setup

1. Accept input (product/company name, business case path, or pasted content)
2. If insufficient, enter interview mode (§7) to gather subject and industry at minimum
3. Detect scope: subject, industry, geography, segments, pricing
4. Present scope for user confirmation
5. Ask about PNG export; check/offer mmdc installation if requested
6. Ask for output path

### Phase 2 — Research (autonomous)

Research via WebSearch and WebFetch. Do not ask the user for market data.

1. Industry revenue data (global, regional) from reports
2. Customer counts and segmentation data
3. Pricing data (ASP, ARPU) if not provided
4. Competitor revenues and market shares
5. Growth rates (historical and projected CAGR)
6. Flag data older than 18 months with `[Dated: YYYY]`

### Phase 3 — TAM Calculation

1. **Top-down**: Start from published industry figures, apply scope adjustments
2. **Bottom-up**: Multiply total potential customers by average revenue per customer
3. **Triangulate**: Compare approaches. If divergence ≤15%, average or use more defensible. If >15%, analyze causes and present both.

### Phase 4 — SAM Calculation

Apply filters to TAM: geographic, segment, channel, product-fit. Document each filter with percentage and rationale.

### Phase 5 — SOM Calculation

Calculate realistic capture based on competition, resources, and go-to-market capacity. Must be grounded — not an arbitrary percentage of SAM.

### Phase 6 — Growth Projections

Project TAM/SAM/SOM forward using CAGR. Show current, +1Y, +3Y, +5Y (or custom horizon).

### Phase 7 — Segmentation Analysis

Break down by key segments with TAM/SAM/SOM per segment.

### Phase 8 — Validation

Cross-check via: triangulation, competitor revenue sum, analogy comparison, sanity checks. Present results table.

### Phase 9 — Diagrams

Generate 6 Mermaid diagrams:
1. Concentric circles (pie) — TAM > SAM > SOM with values
2. Market sizing funnel (flowchart) — progressive filtering
3. Growth projection (xychart) — bar chart over time
4. Segmentation breakdown (pie) — per segment
5. Top-down vs bottom-up comparison (flowchart) — both paths to convergence
6. Sensitivity analysis (xychart) — key assumption impact

### Phase 10 — PNG Export (if requested)

Write `.mmd` files, render via `mmdc`, include PNG paths. Keep Mermaid code blocks for portability.

### Phase 11 — Report Assembly

Assemble complete report with all sections. Present for approval. Save only after explicit confirmation.

---

## Output contract

### Report structure

```markdown
# Market Sizing: [Subject]

**Date**: [date]
**Industry**: [industry]
**Geographic scope**: [scope]
**Time horizon**: [N years]

## Executive Summary
[3-5 sentences]

## TAM — Total Addressable Market
[Top-down calculation + Bottom-up calculation + Triangulation]
[Concentric circles diagram + Top-down vs bottom-up diagram]

## SAM — Serviceable Addressable Market
[Filters with percentages and rationale]
[Market sizing funnel diagram]

## SOM — Serviceable Obtainable Market
[Capture rate with go-to-market grounding]

## Market Segmentation
[Per-segment table + Segmentation diagram]

## Growth Projections
[Year-by-year table + Growth projection diagram]

## Sensitivity Analysis
[Key assumptions varied + Sensitivity diagram]

## Validation
[Triangulation, competitor sum, analogies, sanity checks table]

## Assumptions
[Numbered list with source, impact rating, confidence]

## Sources
[Numbered list with publication dates]

## Limitations
[Data gaps, methodology constraints]
```

### Diagrams (6 total)

1. **Concentric circles** — Mermaid pie chart showing TAM/SAM/SOM proportions
2. **Market sizing funnel** — Mermaid flowchart showing filtering from TAM to SOM
3. **Growth projection** — Mermaid xychart with TAM/SAM/SOM over time
4. **Segmentation breakdown** — Mermaid pie chart per segment
5. **Top-down vs bottom-up** — Mermaid flowchart showing both calculation paths
6. **Sensitivity analysis** — Mermaid xychart showing assumption impact

All diagrams output as Mermaid code blocks. Optionally rendered to PNG.

---

## Self-check

```
[] Both top-down AND bottom-up TAM calculations present with formulas
[] Divergence between approaches calculated and addressed
[] SAM filters documented with percentages and rationale
[] SOM grounded in go-to-market capacity (not arbitrary %)
[] Growth projections include CAGR source
[] Segmentation breakdown included (not just aggregate)
[] All 6 Mermaid diagrams included and render valid syntax
[] Every data point sourced with publication date
[] Assumptions explicitly labeled with impact rating
[] Data freshness: all data from last 18-24 months or flagged
[] Validation section includes at least 3 cross-checks
[] No fabricated statistics or market data
[] Report follows the output contract structure
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject provided | Enter interview mode (§7) — ask what product/market to size |
| Subject too vague | Enter interview mode (§7) — ask targeted questions to narrow scope |
| Cannot find sufficient market data | Produce partial output, clearly label gaps and confidence as low |
| Data older than 18 months | Flag with `[Dated: YYYY]`, proceed with caveat |
| Top-down and bottom-up diverge >15% | Flag divergence, analyze causes, present both with explanation |
| No pricing data found | Use analogies or comparable products, label as `[Estimated]` |
| Market too new for reliable data | Use proxy indicators and analog markets, label methodology |
| mmdc not installed and user declines | Proceed with Mermaid code blocks only |
| mmdc rendering fails | Report error, keep Mermaid code blocks |
| Out-of-scope request | "This skill performs market sizing (TAM/SAM/SOM). [Request] is outside scope." |

---

## Quality checks

- [ ] Both top-down AND bottom-up calculations present (never just one)
- [ ] Divergence between approaches explicitly calculated
- [ ] Every SAM filter has a documented percentage and rationale
- [ ] SOM tied to go-to-market capacity, not an arbitrary % of SAM
- [ ] Growth projections use sourced CAGR
- [ ] Market segmented (not just aggregate figures)
- [ ] All data from last 18-24 months or explicitly flagged as dated
- [ ] Assumptions listed with impact rating (High/Medium/Low)
- [ ] Validation uses at least 3 independent cross-checks
- [ ] All 6 diagrams render valid Mermaid syntax
- [ ] No fabricated market data, statistics, or financial figures
- [ ] Report internally consistent (SAM < TAM, SOM < SAM)

---

## Examples

### Normal cases

**1. Product name input**
- Input: "Size the market for plant-based meat alternatives in Europe"
- Expected: Identifies food industry / plant-based protein segment, European geography. Full TAM/SAM/SOM with both approaches, segmentation by country and product type.

**2. Business case document input**
- Input: Business case file for a B2B SaaS tool
- Expected: Extracts product type, target customer, pricing from document. Full analysis with software industry data.

**3. Startup idea with no existing data**
- Input: "Size the market for AI-powered pet health monitoring wearables"
- Expected: Uses proxy markets (pet wearables, pet health tech, human health wearables). Labels methodology as analogy-based. Full analysis with appropriate caveats.

**4. With pricing data provided**
- Input: "Size the market for our CRM tool, $49/month per seat, targeting SMBs in North America"
- Expected: Uses provided pricing ($588/year) for bottom-up. Researches CRM market for top-down. North American SMB scope for SAM.

**5. Geographic-specific analysis**
- Input: "TAM/SAM/SOM for electric vehicle charging stations in the Netherlands"
- Expected: Dutch-specific data, segmentation by charger type (fast/slow, public/private), growth tied to EV adoption rates.

### Edge cases

**6. Very niche market**
- Input: "Size the market for underwater drone inspection of offshore wind turbines"
- Expected: Limited direct data. Uses proxy markets (offshore inspection, industrial drones, offshore wind maintenance). Labels data confidence as low where applicable.

**7. Two-sided market**
- Input: "Size the market for our food delivery platform"
- Expected: Addresses both sides (restaurants and consumers). Clarifies which side drives revenue. May present TAM for both perspectives.

**8. Market with no clear industry reports**
- Input: "Size the market for AI-generated corporate training content"
- Expected: Combines adjacent markets (corporate training market + AI content generation penetration). Uses bottom-up as primary, top-down from adjacent categories. Heavy use of `[Estimated]` labels.

### Failure cases

**9. No subject**
- Input: "Do a market sizing"
- Expected: Enters interview mode (§7) — "What product, company, or market would you like to size?"

**10. Out of scope**
- Input: "What's the DCF valuation of this company?"
- Expected: "This skill performs market sizing (TAM/SAM/SOM). Financial valuation is outside scope."
