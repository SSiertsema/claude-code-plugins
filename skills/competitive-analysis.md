# Competitive Analysis — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | competitive-analysis |
| **Version** | 1.0.0 |
| **Purpose** | Autonomously researches and evaluates a company, product, or business case's competitive landscape using Porter's Five Forces and SWOT analysis. Produces rated assessments, TOWS strategy matrix, competitor comparisons, and a prioritized strategic action plan. Researches data itself via web tools — does not require user to provide industry knowledge. Generates five Mermaid diagrams with optional PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |

---

## When to use

- User wants to understand their competitive landscape
- User needs to evaluate market entry or positioning strategy
- User has a business case/product and wants competitive intelligence
- User wants SWOT or Porter's Five Forces analysis for a specific company or product
- User needs strategic recommendations based on competitive dynamics

## When not to use

- Internal-only organizational assessment (no competitive dimension)
- Financial valuation or investment analysis
- Operational process improvement without competitive context
- User already has a completed competitive analysis and wants a different type of analysis
- User needs customer research or persona development — use `persona-management`

---

## Required input

| Field | Description |
|---|---|
| **Subject** | A company name, product description, or business case document to analyze |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Competitors** | Specific competitors to include | Researched autonomously (3-5) |
| **Industry/market** | Industry or market segment to focus on | Inferred from subject |
| **Geographic scope** | Region or global | Global |
| **Analysis depth** | Quick scan, standard, or deep dive | Standard |
| **PNG export** | Whether to render diagrams as PNG images | No (Mermaid code blocks only) |
| **Output path** | Where to save the report | `/documentatie/business/competitive-analysis-[subject].md` |

## Input schema

```
input:
  required:
    subject:
      type: string | document
      description: "Company name, product description, or business case file path/content"
  optional:
    competitors:
      type: list[string]
      description: "Named competitors to include in analysis"
    industry:
      type: string
      description: "Industry or market segment"
    geographic_scope:
      type: string
      enum: [global, regional, national, local]
      default: global
    analysis_depth:
      type: string
      enum: [quick_scan, standard, deep_dive]
      default: standard
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

Two entry modes:
1. **Sufficient input**: Analyze input, detect scope, proceed to confirmation
2. **No input or sparse input**: Enter interview mode — gather minimum required information through one-question-at-a-time dialogue

Interview dimensions: subject (required), industry/market (required), geographic scope, competitors, analysis depth, strategic context, focus areas. Exit interview when subject and industry are clear — do not over-interview.

Then:
1. Detect subject, industry, geographic scope, and any named competitors
2. Present detected scope for user confirmation
3. Ask if PNG export is desired; if yes, check/offer to install `mmdc`
4. Ask for output path

### Phase 2 — Research (autonomous)

Research via WebSearch and WebFetch. Do not ask the user for industry data.

1. **PESTEL scan**: Political, Economic, Social, Technological, Environmental, Legal factors
2. **Competitor identification**: If not provided, research and identify 3-5 key competitors. Present for user confirmation.
3. **Industry data**: Entry barriers, supplier/buyer dynamics, substitutes, competitive intensity

### Phase 3 — Porter's Five Forces

1. Assess each force: Threat of new entrants, Supplier power, Buyer power, Threat of substitutes, Competitive rivalry
2. Rate each on scale: `++` (very favorable) to `--` (very unfavorable)
3. Minimum 2 evidence points per force with sources
4. Generate Mermaid flowchart diagram
5. Conclude with industry attractiveness rating

### Phase 4 — SWOT Analysis

1. Build SWOT for subject (3-5 items per quadrant, fact-based, sourced)
2. Build SWOT for each competitor (same standards)
3. Generate Mermaid quadrant chart for subject
4. Produce side-by-side comparison table

### Phase 5 — TOWS Strategy Matrix

1. Cross-reference subject's SWOT: SO, WO, ST, WT strategies (2-3 per quadrant)
2. Strategies must be concrete and actionable
3. Generate Mermaid quadrant chart

### Phase 6 — Competitive Positioning Map

1. Select two most strategically relevant dimensions from analysis
2. Plot subject and competitors on Mermaid quadrant chart
3. Explain dimension choice and positioning implications

### Phase 7 — Industry Attractiveness Visualization

1. Generate radar/pie chart of five forces intensity
2. Fall back to pie chart if radar not supported in environment

### Phase 8 — Strategic Action Plan

1. Synthesize findings into prioritized action table
2. Every action traces to a specific finding (TOWS quadrant, force, SWOT item)
3. Include priority, timeframe, and expected impact

### Phase 9 — PNG Export (if requested)

1. Write `.mmd` files, render via `mmdc`, include PNG paths in report
2. Keep Mermaid code blocks for portability

### Phase 10 — Report Assembly

1. Assemble complete report with all sections
2. Present for user approval
3. Save only after explicit confirmation

---

## Output contract

### Report structure

```markdown
# Competitive Analysis: [Subject]

**Date**: [date]
**Industry**: [industry]
**Geographic scope**: [scope]
**Competitors analyzed**: [list]

## Executive Summary
[3-5 sentences]

## PESTEL Context
[summary table: 6 categories with key factors]

## Porter's Five Forces
[Mermaid diagram + assessment table + attractiveness conclusion]

## Industry Attractiveness
[Mermaid radar/pie + narrative]

## SWOT Analysis — [Subject]
[Mermaid quadrant chart + SWOT table]

## Competitor SWOT Comparison
[per-competitor tables + side-by-side comparison]

## Competitive Positioning
[Mermaid quadrant chart + dimension rationale]

## TOWS Strategy Matrix
[Mermaid quadrant chart + strategy table with SO/WO/ST/WT]

## Strategic Action Plan
[priority actions table with source traceability]

## Sources
[numbered list of all web sources]

## Assumptions & Limitations
[explicit list]
```

### Diagrams (5 total)

1. **Porter's Five Forces** — Mermaid flowchart with force ratings
2. **SWOT matrix** — Mermaid quadrant chart with items plotted by importance
3. **TOWS strategy matrix** — Mermaid quadrant chart with strategies plotted
4. **Competitive positioning map** — Mermaid quadrant chart with 2-axis plot
5. **Industry attractiveness** — Mermaid pie chart with force intensity scores

All diagrams output as Mermaid code blocks. Optionally rendered to PNG if user requests and `mmdc` is available.

---

## Self-check

```
[] Every Porter's force has a rating with at least 2 evidence points
[] Every SWOT item is specific, fact-based, and sourced
[] SWOT quadrants have 3-5 items each
[] TOWS strategies are concrete and actionable (not generic)
[] All five Mermaid diagrams are included
[] Strategic actions trace back to specific findings
[] Sources are listed for all major claims
[] Assumptions are explicitly labeled
[] No fabricated data presented as fact
[] Competitor SWOTs use the same evidence standard as subject
[] Report follows the output contract structure
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject provided | Enter interview mode — ask what company, product, or market to analyze |
| Subject too vague (e.g., "tech") | Enter interview mode — ask targeted questions to narrow scope |
| Cannot find sufficient data via web | Produce partial output, clearly label gaps and low-confidence findings |
| Competitor data unavailable | Note the gap, proceed with available competitors, label as `[Limited data]` |
| Industry not identifiable | Enter interview mode — ask about the industry/market |
| mmdc not installed and user declines | Proceed with Mermaid code blocks only |
| mmdc rendering fails | Report error, keep Mermaid code blocks |
| Web search returns no results | State the gap, label confidence as low |
| User provides conflicting scope | Present conflict, ask user to resolve |
| Out-of-scope request | "This skill performs competitive analysis. [Request] is outside scope." |

---

## Quality checks

- [ ] Porter's forces rated with clear evidence (not assumptions)
- [ ] SWOT items are specific ("42% EU market share" not "strong position")
- [ ] TOWS strategies are actionable ("Partner with X to enter Y" not "explore partnerships")
- [ ] Competitive positioning dimensions are justified from the analysis
- [ ] Action plan items are traceable to specific findings
- [ ] All web-sourced claims reference their source
- [ ] Assumptions explicitly labeled as `[Assumption]`
- [ ] No fabricated statistics, market data, or financial figures
- [ ] Report is internally consistent (SWOT items flow into TOWS strategies flow into actions)
- [ ] Diagrams render valid Mermaid syntax

---

## Examples

### Normal cases

**1. Company name input**
- Input: "Analyze Spotify's competitive position in music streaming"
- Expected: Identifies Apple Music, Amazon Music, YouTube Music, Tidal as competitors. Full analysis with all sections and diagrams.

**2. Business case document input**
- Input: Business case file for a new SaaS product
- Expected: Identifies industry from business case, researches competitors, produces full analysis.

**3. With named competitors**
- Input: "Analyze Tesla vs BYD, Rivian, and traditional automakers in the EV market"
- Expected: Uses provided competitors, may add 1-2 more from research. Full analysis.

**4. Specific geographic scope**
- Input: "Competitive analysis for Jumbo supermarkets in the Netherlands"
- Expected: Scopes to Dutch market. Identifies Albert Heijn, Lidl, Aldi, Plus as competitors.

**5. Quick scan depth**
- Input: "Quick competitive scan for Notion in productivity tools"
- Expected: Abbreviated analysis — fewer evidence points, shorter narratives, but all sections and diagrams present.

### Edge cases

**6. Very niche market**
- Input: "Analyze competitive landscape for industrial drone inspection services in Scandinavia"
- Expected: Limited web data available. Labels gaps, produces partial analysis with `[Limited data]` markers.

**7. Startup with no public data**
- Input: "Analyze our startup [description] against established players"
- Expected: Builds subject SWOT from description (labeled as `[Based on provided description]`). Competitor SWOTs from web research.

**8. Multiple industries**
- Input: "Analyze Amazon" (spans e-commerce, cloud, streaming, etc.)
- Expected: Asks user to narrow scope to a specific business unit or segment.

### Failure cases

**9. No subject**
- Input: "Do a competitive analysis"
- Expected: "Provide a company name, product description, or business case to analyze."

**10. Out of scope**
- Input: "What's the NPV of investing in this company?"
- Expected: "This skill performs competitive analysis (SWOT, Porter's Five Forces, strategic positioning). Financial valuation is outside scope."
