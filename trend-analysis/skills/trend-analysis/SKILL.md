---
name: trend-analysis
description: Autonomous trend analysis combining quantitative and qualitative methods. Researches trends via web, produces PESTEL scans, trend classification (megatrend/trend/fad), impact assessment, weak signals, scenario sketches, and Mermaid diagrams with optional PNG export.
argument-hint: "[product/company/industry name or business case path]"
---

# Trend Analysis

You perform autonomous trend analysis. You research trend data yourself — do not ask the user for data they would need to look up. Only ask the user for decisions and confirmations.

## Input handling

Follow shared foundation §7 — interview mode. When input is missing or insufficient, interview to gather at minimum:

| Dimension | Required | Default |
|---|---|---|
| **Subject** (product, company, industry, or market) | Yes | — |
| **Industry/market** | Yes | — |
| **Geographic scope** | No | Global |
| **Trend categories** (technology, consumer, regulatory, etc.) | No | All categories |
| **Time horizon** | No | 10 years |
| **Known trends to include** | No | Will be researched |

**Exit interview when**: Subject and industry are clear enough to research.

## Phase 1 — Setup

### 1. Collect input

Accept one of:
- A product, company, or industry name/description
- A file path to a business case document
- Pasted business case content
- No input or vague input → enter interview mode (§7)

### 2. Detect scope

From the input (or interview results), identify:
- **Subject**: The product, company, industry, or market
- **Industry/market**: Sector and segment
- **Geographic scope**: Region or global (default: global)
- **Trend categories**: Which categories to focus on (default: all)
- **Time horizon**: How far to look (default: 10 years)

### 3. Confirm scope

Present detected scope:

```
**Subject**: [name]
**Industry**: [industry/segment]
**Geographic scope**: [scope]
**Trend categories**: [listed or "all"]
**Time horizon**: [N years]
```

Ask the user to confirm or adjust.

Ask diagram render mode and output path per the `diagram-rendering` and `autonomous-research` mixins.

## Phase 2 — Research

Use WebSearch and WebFetch per the `autonomous-research` mixin.

### 2a. Macro-environmental data (PESTEL)

Research trends across all six categories:
- **Political**: Regulation changes, trade policy, political stability, government initiatives
- **Economic**: GDP growth, inflation, interest rates, employment, consumer spending
- **Social**: Demographics, lifestyle shifts, cultural changes, health/wellness trends
- **Technological**: Emerging tech, adoption rates, R&D investment, patent activity
- **Environmental**: Climate policy, sustainability mandates, resource scarcity, green tech
- **Legal**: Industry regulation, data protection, IP law, compliance requirements

### 2b. Industry-specific trends

Research:
- Technology trends within the industry
- Consumer behavior and preference shifts
- Competitive landscape changes
- Business model innovation
- Supply chain and distribution shifts

### 2c. Weak signals

Search fringe and early-stage sources:
- Startup activity (new entrants, funding rounds)
- Patent filings in adjacent domains
- Academic preprints and research papers
- Niche publications and trade journals
- Social media / community discussions

### 2d. Data freshness

Flag any data older than 18 months with `[Dated: YYYY]`. Prefer recent sources. State publication date for every source.

## Phase 3 — PESTEL Trend Matrix

Produce a structured assessment of macro trends:

| Category | Trend | Direction | Impact (1-5) | Timing | Evidence |
|---|---|---|---|---|---|
| Political | [trend] | Rising / Stable / Declining | [1-5] | [near/mid/long] | [source] |
| Economic | [trend] | ... | ... | ... | ... |
| Social | [trend] | ... | ... | ... | ... |
| Technological | [trend] | ... | ... | ... | ... |
| Environmental | [trend] | ... | ... | ... | ... |
| Legal | [trend] | ... | ... | ... | ... |

2-3 trends per category. Each must reference a specific source.

## Phase 4 — Trend Identification and Classification

Identify 8-12 key trends (combining PESTEL and industry-specific). For each trend, classify:

| Classification | Duration | Breadth | Depth | Drivers |
|---|---|---|---|---|
| **Megatrend** | 10-30+ years | Cross-industry, global | Changes underlying structures | Demographic, technological, environmental |
| **Trend** | 3-10 years | Industry or sector-wide | Changes behavior/practices | Market forces, regulation, innovation |
| **Fad** | <2 years | Narrow, often consumer | Surface-level preference | Novelty, viral adoption, media hype |

### Trend profiles table

| # | Trend | Classification | Description | Key drivers | Evidence | Timing | Relevance (1-5) | Magnitude (1-5) | Priority score | Strategic implication |
|---|---|---|---|---|---|---|---|---|---|---|
| T-1 | [name] | Megatrend/Trend/Fad | [2-3 sentences] | [structural drivers] | [sources] | [near/mid/long] | [1-5] | [1-5] | [R×M] | [specific impact on subject] |

**Priority score** = Relevance × Magnitude (max 25). Use this to rank trends.

## Phase 5 — Weak Signals

| # | Signal | Source | Category | Potential impact | Confidence | What to watch |
|---|---|---|---|---|---|---|
| WS-1 | [description] | [source + date] | [tech/social/etc.] | [if this develops...] | High/Medium/Low | [leading indicator] |

If no weak signals found, state: "No weak signals detected in the sources surveyed." Do not fabricate.

## Phase 6 — Scenario Sketching

### 1. Identify critical uncertainties

From the trend analysis, select the 2 most impactful uncertainties — trends whose direction is genuinely uncertain and would materially change the landscape.

### 2. Build 2x2 scenario matrix

Use the two uncertainties as axes. Name each quadrant with a descriptive label (not "optimistic/pessimistic").

### 3. Scenario narratives

For each of the 4 quadrants, write a 3-5 sentence narrative:
- What this future looks like
- Which trends dominate
- What it means for the subject
- Key strategic implications

### Scenario matrix diagram

```mermaid
quadrantChart
    title Scenario Matrix — [Subject]
    x-axis [Uncertainty 1 Low] --> [Uncertainty 1 High]
    y-axis [Uncertainty 2 Low] --> [Uncertainty 2 High]
    quadrant-1 [Scenario Name]
    quadrant-2 [Scenario Name]
    quadrant-3 [Scenario Name]
    quadrant-4 [Scenario Name]
```

## Phase 7 — Strategic Implications

Map each high-priority trend to specific strategic recommendations:

| # | Trend | Impact on subject | Recommended action | Priority | Timeframe |
|---|---|---|---|---|---|
| 1 | [trend] | [specific impact] | [concrete action] | Critical/High/Medium/Low | Short/Medium/Long |

Every recommendation must trace back to a specific trend finding. No generic advice.

## Phase 8 — Diagrams

Generate 6 Mermaid diagrams:

### 1. Trend radar

Approximate a radar using a pie chart segmented by category, with the title indicating time horizon context:

```mermaid
pie title Trend Radar — [Subject] (Impact Distribution)
    "Technology" : [impact_sum]
    "Economic" : [impact_sum]
    "Social" : [impact_sum]
    "Political" : [impact_sum]
    "Environmental" : [impact_sum]
    "Legal" : [impact_sum]
```

### 2. Trend impact grid

```mermaid
quadrantChart
    title Trend Impact Assessment
    x-axis Low Relevance --> High Relevance
    y-axis Low Magnitude --> High Magnitude
    quadrant-1 Monitor
    quadrant-2 Act Now
    quadrant-3 Deprioritize
    quadrant-4 Prepare
    [Trend 1]: [x, y]
    [Trend 2]: [x, y]
```

### 3. Hype cycle

Approximate a Gartner-style hype cycle using a flowchart:

```mermaid
flowchart LR
    IT["Innovation\nTrigger"]
    PE["Peak of Inflated\nExpectations"]
    TD["Trough of\nDisillusionment"]
    SE["Slope of\nEnlightenment"]
    PP["Plateau of\nProductivity"]

    IT --> PE --> TD --> SE --> PP

    T1["[Trend]"] -.-> IT
    T2["[Trend]"] -.-> PE
    T3["[Trend]"] -.-> SE
```

Plot each technology trend at its estimated phase.

### 4. Adoption S-curve

```mermaid
xychart-beta
    title "Trend Adoption Trajectories"
    x-axis ["Early", "Growing", "Mainstream", "Mature", "Declining"]
    y-axis "Adoption %" 0 --> 100
    line [5, 25, 65, 90, 85]
    line [2, 10, 35, 60, 70]
```

Plot 2-3 key trends showing their adoption stage.

### 5. Scenario matrix

(See Phase 6 above — the quadrant chart)

### 6. PESTEL heat map

```mermaid
xychart-beta
    title "PESTEL Trend Impact"
    x-axis ["Political", "Economic", "Social", "Technological", "Environmental", "Legal"]
    y-axis "Average Impact (1-5)" 0 --> 5
    bar [p_avg, e_avg, s_avg, t_avg, env_avg, l_avg]
```

## Phase 9 — Diagram Rendering

Render diagrams per the `diagram-rendering` mixin.

File naming:
- `trend-radar.mmd` / `.png`
- `trend-impact-grid.mmd` / `.png`
- `hype-cycle.mmd` / `.png`
- `adoption-s-curve.mmd` / `.png`
- `scenario-matrix.mmd` / `.png`
- `pestel-heat-map.mmd` / `.png`

## Phase 10 — Report Assembly and Approval

Assemble the complete report:

```markdown
# Trend Analysis: [Subject]

**Date**: [date]
**Industry**: [industry]
**Geographic scope**: [scope]
**Time horizon**: [N years]

## Executive Summary
[3-5 sentences: top trends, key uncertainties, most critical implication, confidence level]

## PESTEL Macro Scan
[PESTEL trend matrix table]
[PESTEL heat map diagram]

## Key Trends
[Trend profiles table — 8-12 trends with full classification and impact scoring]
[Trend impact grid diagram]

## Technology Trends
[Hype cycle diagram]
[Adoption S-curve diagram]

## Weak Signals
[Weak signals table]

## Trend Radar
[Trend radar diagram]

## Scenarios
[Critical uncertainties identified]
[Scenario matrix diagram]
[4 scenario narratives]

## Strategic Implications
[Recommendations table — actions tied to trends]

## Sources
[Numbered list of all web sources with publication dates]

## Assumptions & Limitations
[Explicit list of assumptions, data gaps, methodology constraints]
```

Present for user approval. Save only after explicit confirmation.

## Generation rules

Per the `autonomous-research` mixin, plus:
- **Classifications**: Every trend must be classified with explicit criteria (duration, breadth, depth, drivers)
- **Ratings**: Impact scores must be justified with evidence — never rate without supporting data
- **Weak signals**: Report honestly — if none found, say so. Do not fabricate early indicators.
- **Scenarios**: Must be grounded in identified uncertainties — not generic futures
- **Prioritization**: 8-12 key trends maximum. Ruthlessly prioritize — a 50-trend list is useless.
- **Causation**: Distinguish correlation from causation explicitly when trends co-occur
- **Language**: Respond and generate in the user's language unless specified otherwise

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject provided | Enter interview mode (§7) — ask what product/industry to analyze |
| Subject too vague | Enter interview mode (§7) — ask targeted questions to narrow scope |
| Cannot find sufficient trend data | Produce partial output, clearly label gaps and confidence as low |
| Data older than 18 months | Flag with `[Dated: YYYY]`, proceed with caveat |
| No weak signals found | State "No weak signals detected in sources surveyed." Do not fabricate. |
| Trend data contradicts across sources | Present both perspectives with sources, note the contradiction |
| mmdc / web search failures | See `diagram-rendering` and `autonomous-research` mixins |
| Out-of-scope request | "This skill performs trend analysis. [Request] is outside scope." |

## Self-check

Before presenting output, verify:

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
```
