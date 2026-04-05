# Customer Segmentation — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | customer-segmentation |
| **Version** | 1.0.0 |
| **Purpose** | Autonomously researches and produces customer segmentation analysis for a product, company, or market. Identifies 4-7 distinct segments using multiple dimensions (demographic, psychographic, behavioral, needs-based, value-based; firmographic for B2B), creates rich profiles, validates via MASDA criteria, sizes segments, and produces targeting/positioning recommendations with an activation roadmap. Researches data itself via web tools. Generates 5 Mermaid diagrams with optional PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |

---

## When to use

- User wants to understand their customer segments for a product or market
- User needs segmentation for marketing strategy, product development, or pricing decisions
- User has a business case and needs to identify target audiences
- User wants to evaluate which customer segments to prioritize
- User needs STP (Segmentation, Targeting, Positioning) analysis

## When not to use

- Persona creation (rich narrative personas) — use `persona-management`
- Market sizing without segmentation focus — use `market-sizing`
- Competitive analysis — use `competitive-analysis`
- Trend analysis — use `trend-analysis`
- CRM data analysis requiring access to proprietary customer databases
- Real-time customer analytics or dashboarding

---

## Required input

| Field | Description |
|---|---|
| **Subject** | A product, company, business case, or market to segment |

## Optional input

| Field | Description | Default |
|---|---|---|
| **B2B/B2C context** | Business model type | Inferred from subject |
| **Geographic scope** | Region, country, or global | Global |
| **Segmentation focus** | Specific dimensions to prioritize | Multi-dimensional |
| **Known customer data** | Any existing customer insights | None |
| **Known segments** | Existing segments to include or validate | None |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/customer-segmentation/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document
      description: "Product, company, business case, or market to segment"
  optional:
    context:
      type: string
      enum: [b2b, b2c, both]
      default: inferred
    geographic_scope:
      type: string
      enum: [global, regional, national, local]
      default: global
    segmentation_focus:
      type: list[string]
      enum_values: [demographic, geographic, psychographic, behavioral, firmographic, needs_based, value_based]
      default: multi_dimensional
    known_customer_data:
      type: string
      description: "Any existing customer insights or data"
    known_segments:
      type: list[string]
      description: "Existing segments to include or validate"
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

1. Accept input (product/company, business case path, or pasted content)
2. If insufficient, enter interview mode (§7) to gather subject, industry, B2B/B2C
3. Detect scope
4. Present scope for user confirmation
5. Ask about diagram render mode; check/offer mmdc if image mode
6. Ask for output path

### Phase 2 — Research (autonomous)

Research via WebSearch and WebFetch. Do not ask the user for customer data.

1. Market and demographic/firmographic data
2. Behavioral and needs data (purchase patterns, JTBD, pain points)
3. Competitive positioning and segment gaps
4. Value data (pricing tiers, CLV benchmarks, cost-to-serve)

### Phase 3 — Dimension Selection

Select 3-4 most relevant segmentation dimensions based on B2B/B2C context.
- B2C: demographic + psychographic + behavioral + needs-based + value-based
- B2B: firmographic + technographic + behavioral + needs-based + value-based

### Phase 4 — Segment Identification

Identify 4-7 distinct segments. Each with memorable name, estimated size, key differentiator.

### Phase 5 — Segment Profiling

Rich multi-dimensional profile per segment: demographics/firmographics, psychographics, behaviors, needs (JTBD), value profile, MASDA validation.

### Phase 6 — Segment Sizing

Estimate per segment: % of market, customer count, revenue potential, CLV tier.

### Phase 7 — Targeting Assessment

Rate each segment on attractiveness (1-5) and competitive strength (1-5). Recommend: Primary / Secondary / Monitor / Avoid.

### Phase 8 — Positioning Recommendations

Value proposition, key differentiator, and messaging theme per target segment. Select positioning map axes.

### Phase 9 — Activation Roadmap

Per target segment: marketing tactics, product adaptations, pricing model, distribution channels.

### Phase 10 — Diagrams

Generate 5 Mermaid diagrams:
1. Segmentation tree (flowchart) — market breakdown into segments
2. Segment sizing (pie) — proportional segment sizes
3. Targeting matrix (quadrant) — attractiveness vs competitive strength
4. Positioning map (quadrant) — segments on 2 differentiating axes
5. Segment comparison (xychart) — key attributes per segment

### Phase 11 — Diagram Rendering

Two modes:
- **`code`** (default): Mermaid code blocks in report, no external files
- **`image`**: Render `.mmd` → `.png` via `mmdc`, embed `![](path.png)` in report, no code blocks. `.mmd` source files stored alongside for editability

### Phase 12 — Report Assembly

Assemble complete report with all sections. Present for approval. Save only after explicit confirmation.

---

## Output contract

### Report structure

```markdown
# Customer Segmentation: [Subject]

**Date**: [date]
**Industry**: [industry]
**Context**: [B2B / B2C / Both]
**Geographic scope**: [scope]
**Segments identified**: [count]

## Executive Summary
[3-5 sentences]

## Segmentation Approach
[Dimensions selected and rationale]

## Segmentation Overview
[Segmentation tree + sizing diagrams]

## Segment Profiles
[Full profile per segment with MASDA validation]

## Segment Sizing
[Sizing table]

## Segment Comparison
[Comparison diagram]

## Targeting Assessment
[Targeting matrix diagram + scoring table + recommendations]

## Positioning
[Positioning map diagram + value proposition per segment]

## Activation Roadmap
[Per-segment marketing, product, pricing, channel plan]

## Sources
[Numbered list with publication dates]

## Assumptions & Limitations
[Explicit list]
```

### Diagrams (5 total)

1. **Segmentation tree** — Mermaid flowchart showing market breakdown
2. **Segment sizing** — Mermaid pie chart with proportional sizes
3. **Targeting matrix** — Mermaid quadrant chart (attractiveness vs strength)
4. **Positioning map** — Mermaid quadrant chart on 2 differentiating axes
5. **Segment comparison** — Mermaid xychart comparing attributes across segments

In `code` mode: diagrams appear as Mermaid code blocks. In `image` mode: diagrams rendered to PNG via `mmdc`, embedded as `![](path.png)`, with `.mmd` source files alongside.

---

## Self-check

```
[] 4-7 segments identified (not too few, not over-segmented)
[] Multiple dimensions combined (at least 3, not demographics alone)
[] Every segment has a memorable, descriptive name
[] Every segment profiled across all dimensions
[] Every segment validated against MASDA (all 5 criteria)
[] Segments sized with customer count and revenue potential
[] Targeting assessment with scores and recommendations
[] Positioning recommendations with value proposition per segment
[] Activation roadmap connects to marketing, product, pricing, channels
[] All 5 Mermaid diagrams included and render valid syntax
[] Every data point sourced with publication date
[] Assumptions explicitly labeled
[] No fabricated customer data or statistics
[] Report follows the output contract structure
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject provided | Enter interview mode (§7) — ask what product/market to segment |
| Subject too vague | Enter interview mode (§7) — ask targeted questions |
| Cannot determine B2B/B2C | Ask the user directly |
| Cannot find sufficient market data | Produce partial output, label gaps and confidence as low |
| Data older than 18 months | Flag with `[Dated: YYYY]`, proceed with caveat |
| Too few differentiating factors | Produce fewer segments (minimum 3) with explanation |
| Segment fails MASDA validation | Report failure, explain which criteria failed, propose adjustment |
| mmdc not installed and user declines | Fall back to `code` mode |
| mmdc rendering fails | Report error, fall back to `code` mode |
| Out-of-scope request | "This skill performs customer segmentation. [Request] is outside scope." |

---

## Quality checks

- [ ] 4-7 segments (not too few, not over-segmented)
- [ ] Multiple dimensions combined (at least 3, never demographics alone)
- [ ] Every segment has a memorable, descriptive name
- [ ] Segments profiled across demographics, psychographics, behaviors, needs, and value
- [ ] MASDA validation for every segment (all 5 criteria assessed)
- [ ] Segments sized with estimated numbers and revenue potential
- [ ] Targeting scores (attractiveness + competitive strength) with evidence
- [ ] Positioning axes justified from the analysis
- [ ] Activation roadmap actionable per segment
- [ ] All data sourced with publication dates
- [ ] No fabricated data
- [ ] All 5 diagrams render valid Mermaid syntax

---

## Examples

### Normal cases

**1. B2C product**
- Input: "Segment the market for a premium meal kit delivery service in the US"
- Expected: 5-6 segments combining demographic (income, household), psychographic (health-conscious, convenience-seeking), behavioral (cooking frequency), needs (time-saving, healthy eating). Segments like "Health-Focused Professionals", "Busy Parents", "Culinary Explorers".

**2. B2B SaaS**
- Input: "Customer segmentation for our project management SaaS tool"
- Expected: Firmographic (company size, industry), behavioral (team size, usage intensity), needs-based (collaboration, reporting, compliance). Segments like "Scaling Startups", "Enterprise PMOs", "Agency Teams".

**3. Business case input**
- Input: Business case file for a fintech lending platform
- Expected: Segments by borrower type, creditworthiness, loan purpose, digital comfort. B2C or B2B depending on the platform. MASDA validated, sized by addressable borrower pool.

**4. With known segments**
- Input: "We currently target SMBs and enterprise. Validate and refine our segmentation for our cybersecurity product."
- Expected: Validates existing segments against MASDA, proposes refinement (e.g., split SMB into "security-aware SMBs" vs "compliance-driven SMBs"), identifies potential new segments.

**5. Geographic-specific**
- Input: "Segment the Dutch e-bike market for consumers"
- Expected: Netherlands-specific demographics and cycling culture, segments by commuter type, recreation use, age, urban/rural. Psychographic: sustainability values, health motivation.

### Edge cases

**6. Both B2B and B2C**
- Input: "Segment the market for our payment processing platform (we serve both merchants and consumers)"
- Expected: Two parallel segmentation tracks — B2B (merchant segments by size, industry, volume) and B2C (consumer segments by spending pattern, digital adoption). Clearly separated with cross-references.

**7. Very new market**
- Input: "Segment potential customers for personal AI assistants"
- Expected: Limited behavioral data. Heavier reliance on psychographic and needs-based dimensions. Analogy to smartphone/smart speaker adoption. Many segments labeled with `[Estimated]`.

**8. Single dominant segment**
- Input: "Segment the market for industrial-grade 3D printers"
- Expected: Fewer segments (3-4) given niche market. Honest about limited differentiation. May combine firmographic (aerospace, automotive, medical) with needs-based (prototyping vs production).

### Failure cases

**9. No subject**
- Input: "Do a customer segmentation"
- Expected: Enters interview mode (§7) — "What product, company, or market would you like to segment?"

**10. Out of scope**
- Input: "Analyze our CRM database to find segments"
- Expected: "This skill performs market-based customer segmentation using publicly available data. Analysis of proprietary CRM data is outside scope."
