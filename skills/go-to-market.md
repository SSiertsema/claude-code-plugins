# Go-to-Market — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | go-to-market |
| **Version** | 1.0.0 |
| **Purpose** | Creates comprehensive go-to-market strategies for product launches, feature releases, market expansions, and repositioning efforts. Covers market definition (ICP/personas), positioning and messaging (3-level hierarchy), pricing and packaging (model selection, tier structure, competitor benchmarks), channel strategy (PLG/SLG/hybrid/partner/community-led), 90-day launch plan (6 phases), rollout waves with go/no-go gates, success metrics (AARRR with LTV:CAC north star), and sales enablement (battle cards, objection handling, demo scripts). Can import from competitive analysis, customer segmentation, market sizing, and vision crafting outputs. Generates Mermaid diagrams with optional PNG export. |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Creativity level** | `medium` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Mixins** | `[diagram-rendering, autonomous-research]` |

---

## When to use

- Launching a new product to market
- Releasing a major feature to existing or new customers
- Expanding into a new market or geography
- Repositioning or rebranding an existing product
- Creating a 90-day launch plan with rollout waves

## When not to use

- Competitive landscape analysis only — use `competitive-analysis`
- Market sizing and TAM/SAM/SOM only — use `market-sizing`
- Customer segmentation only — use `customer-segmentation`
- Product roadmapping — use `theme-roadmapping`
- ROI modeling for the launch investment — use `roi-modeling`

---

## Required input

| Field | Description |
|---|---|
| **Product/feature/initiative context** | What is being launched and why |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Launch type** | New product, feature launch, market expansion, repositioning | Auto-detect from context |
| **Target market/audience** | Known target segments | Will research |
| **Competitive analysis output** | Path to competitive-analysis report | Will research independently |
| **Customer segmentation output** | Path to customer-segmentation report | Will research independently |
| **Market sizing output** | Path to market-sizing report | Will research independently |
| **Vision crafting output** | Path to vision-crafting report | Will research independently |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/go-to-market/` |

## Input schema

```
input:
  required:
    context:
      type: string
      description: "Product, feature, or initiative being launched and context"
  optional:
    launch_type:
      type: string
      enum: [new_product, feature_launch, market_expansion, repositioning]
      default: auto_detect
    target_market:
      type: string
      description: "Known target market or audience"
    competitive_analysis:
      type: string | file_path
      description: "Competitive analysis report to import"
    customer_segmentation:
      type: string | file_path
      description: "Customer segmentation report to import"
    market_sizing:
      type: string | file_path
      description: "Market sizing report to import"
    vision_crafting:
      type: string | file_path
      description: "Vision crafting report to import"
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
| **What may be invented** | ICP characteristics based on domain research, messaging copy direction and examples, channel recommendations based on category norms, activation sequence steps based on product type |
| **What must be grounded** | GTM motion selection criteria (PLG/SLG by ACV range), pricing model justification, competitor pricing from research, LTV:CAC formula, AARRR metrics framework, Phillips methodology for launch phases |
| **What assumptions are allowed** | Pricing ranges based on category benchmarks, CAC estimates based on channel norms, conversion targets based on industry benchmarks (labeled as such), rollout wave durations based on typical patterns |
| **What must never be fabricated** | Specific competitor pricing without research basis, actual company data, guaranteed conversion rates, market size numbers without source, benchmark numbers presented as facts without citation |

---

## Processing rules

### Phase 1 — Setup
1. Parse input, detect product/feature context
2. If insufficient → interview mode (§7)
3. Check for import sources (competitive analysis, segmentation, market sizing, vision)
4. Detect launch type (new product, feature, market expansion, repositioning)
5. Confirm scope, launch type, import sources with user
6. Ask diagram render mode (per diagram-rendering mixin)
7. Ask output path (default: `/documentation/[case]/go-to-market/`)

### Phase 2 — Research
8. WebSearch/WebFetch (per autonomous-research mixin) for market context
9. Research market size, growth rate, maturity, buyer expectations
10. Research competitor GTM approaches (pricing, channels, positioning, recent launches)
11. Research pricing norms for the category (models, ranges, free/freemium prevalence)
12. Research channel effectiveness (typical acquisition channels, CAC benchmarks, conversion benchmarks)

### Phase 3 — Market & Customer Definition
13. Define ICP (company characteristics, pain points, buying triggers, disqualifiers)
14. Define 2-4 buyer/user personas (role, type, goals, objections, activation trigger)
15. Map buying process stages (problem aware, solution aware, decision, purchase, onboarding)
16. Present for user confirmation

### Phase 4 — Positioning & Messaging
17. Define category claim (category, subcategory, frame)
18. Build competitive positioning table
19. Create 3-level messaging hierarchy:
    - Level 1: Core positioning statement ("For [ICP] who [pain], [product] is a [category] that [differentiator]")
    - Level 2: Value propositions with proof points (3-5 per persona)
    - Level 3: Channel-specific copy (website, email, ads, sales deck, launch)
20. Present for user confirmation

### Phase 5 — Pricing & Packaging
21. Select and justify pricing model (per user, usage-based, feature-gated, flat, hybrid)
22. Define tier structure (Free through Enterprise) with features and price ranges
23. Select entry model (free trial, freemium, reverse trial, demo/sales)
24. Benchmark competitor pricing
25. Define expansion paths (seat, tier, usage, cross-sell, add-ons)

### Phase 6 — Channel Strategy
26. Select and justify GTM motion (PLG, SLG, hybrid, partner, community-led) based on ACV
27. Rank acquisition channels by expected impact, CAC, timeline
28. Define activation sequence (signup → first value → aha moment → habit formation)

### Phase 7 — Launch Plan (90 Days)
29. Define 6-phase timeline: Pre-Launch I (Day -90 to -30), Pre-Launch II (Day -30 to -1), Launch (Day 0), Post-Launch I (Day 1-30), Post-Launch II (Day 31-60), Review (Day 61-90)
30. Define 5-10 specific tasks per phase with owner type, dependencies, done criteria

### Phase 8 — Rollout Waves
31. Define progressive release stages: Internal alpha → Private beta → Limited release → GA → Follow-up
32. Define exit criteria per wave (go/no-go gates)

### Phase 9 — Success Metrics
33. Define metrics by AARRR stage (Acquisition, Activation, Revenue, Retention)
34. Define north star metric (LTV:CAC > 3:1) with component breakdown
35. Set 30/60/90-day milestone targets

### Phase 10 — Sales Enablement
36. Create battle cards for top 2-3 competitors (overview, strengths, weaknesses, advantages, landmines, objection handling)
37. Build objection handling matrix with proof points
38. Create competitive comparison matrix
39. Outline demo script (hook, solution overview, key differentiator, social proof, CTA)

### Phase 11 — Diagrams
40. Generate 4 Mermaid diagrams:
    1. Launch Timeline (gantt) — 90-day timeline with phases and tasks
    2. Channel Strategy Matrix (quadrantChart) — channels by effort vs reach
    3. Messaging Hierarchy (mindmap) — positioning, personas, value props, channel copy
    4. Rollout Waves (flowchart) — progressive release stages with go/no-go gates
41. Render per diagram-rendering mixin

### Phase 12 — Report Assembly
42. Assemble complete report, present for approval, save after confirmation

---

## Output contract

```markdown
# Go-to-Market Strategy: [Product/Feature]

**Date**: [date]
**Product/Feature**: [name]
**Launch type**: [New product / Feature launch / Market expansion / Repositioning]
**GTM motion**: [PLG / SLG / Hybrid / Partner / Community-Led]
**Target LTV:CAC**: [ratio]

## Executive Summary
[Key findings: market opportunity, positioning, recommended motion, launch timeline, top 3 risks]

## Market Definition
### Ideal Customer Profile
[ICP table]

### Buyer & User Personas
[Persona tables]

### Buying Process
[Buying journey map]

## Positioning & Messaging
### Core Positioning
[Positioning statement]

### Competitive Positioning
[Comparison table]

### Messaging Hierarchy
[Value propositions per persona]

### Messaging Hierarchy Diagram
[Mindmap diagram]

## Pricing & Packaging
### Pricing Model
[Pricing basis and justification]

### Tier Structure
[Tier table]

### Competitor Pricing Benchmark
[Benchmark table]

### Expansion Paths
[Expansion paths]

## Channel Strategy
### GTM Motion
[Motion selection and justification]

### Acquisition Channels
[Channel ranking]

### Activation Sequence
[Activation steps]

### Channel Strategy Matrix
[Quadrant chart]

## Launch Timeline
[Gantt chart]

### Phase Details
[Per-phase task breakdown]

## Rollout Waves
[Rollout waves flowchart]

### Wave Details
[Wave table with exit criteria]

## Success Metrics
### KPIs by Stage
[Metrics table]

### North Star: LTV:CAC
[Breakdown]

### 30/60/90-Day Targets
[Milestone table]

## Sales Enablement
### Battle Cards
[Per-competitor battle cards]

### Objection Handling
[Objection matrix]

### Competitive Comparison
[Comparison matrix]

### Demo Script Outline
[Demo outline]

## Recommendations
[Prioritized actions traced to findings, risks, and opportunities]

## Sources

## Assumptions & Limitations
```

### Diagrams

| # | Diagram | Mermaid type | Content |
|---|---|---|---|
| 1 | Launch Timeline | gantt | 90-day timeline with 6 phases and key tasks |
| 2 | Channel Strategy Matrix | quadrantChart | Channels plotted by effort vs reach |
| 3 | Messaging Hierarchy | mindmap | Positioning, personas, value props, channel copy |
| 4 | Rollout Waves | flowchart | Progressive release stages with go/no-go gates |

Rendering per diagram-rendering mixin.

---

## Self-check

### Must verify before output
```
[] ICP defined with company characteristics, pain points, buying triggers, disqualifiers
[] 2-4 buyer/user personas with goals, objections, activation triggers
[] Buying process mapped across stages
[] Core positioning statement follows template format
[] Messaging hierarchy has 3 levels: positioning, value props with proof points, channel copy
[] One message set per persona
[] Pricing model selected and justified against category norms
[] Tier structure defined (free through enterprise)
[] Competitor pricing benchmarked with actual research data
[] GTM motion selected and justified by ACV range
[] Acquisition channels ranked by expected impact
[] Activation sequence defined with success metrics
[] 90-day launch plan has 6 phases with specific tasks
[] Rollout waves defined with exit criteria per wave
[] Success metrics cover acquisition, activation, revenue, retention
[] LTV:CAC north star defined with component breakdown
[] 30/60/90-day milestone targets set
[] Battle cards for top 2-3 competitors
[] Objection handling matrix with proof points
[] All 4 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
[] Sources listed for all claims (per autonomous-research mixin)
[] Assumptions labeled (per autonomous-research mixin)
[] Recommendations traced to specific findings
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No product/feature context | Enter interview mode (§7) — "What product or feature do you need a go-to-market strategy for?" |
| Context too vague | Enter interview mode (§7) — ask targeted questions about product, market, audience |
| No competitive data available | Label as [Assumption], note limitation, produce strategy with caveats |
| Pricing data unavailable | Research adjacent categories, label extrapolations as [Assumption] |
| Launch type unclear | Present options with rationale, ask user to select |
| Import file malformed | Ask user to verify, attempt partial import |
| Market too niche for benchmarks | State limitation, use closest available benchmarks, label confidence as low |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| Out-of-scope request | "This skill creates go-to-market strategies. [Request] is outside scope." |

---

## Quality checks

- [ ] ICP defined with company characteristics, pain points, buying triggers, disqualifiers
- [ ] 2-4 buyer/user personas with goals, objections, and activation triggers
- [ ] Buying process mapped across all stages
- [ ] Core positioning statement follows "For [ICP] who [pain], [product] is a [category] that [differentiator]"
- [ ] Messaging hierarchy has 3 levels with persona-specific value propositions
- [ ] Pricing model selected and justified against category norms
- [ ] Tier structure defined from free through enterprise
- [ ] Competitor pricing benchmarked with research data — no invented prices
- [ ] GTM motion selected and justified by ACV range
- [ ] Acquisition channels ranked by expected impact with CAC estimates
- [ ] 90-day launch plan has 6 phases with specific tasks and dependencies
- [ ] Rollout waves defined with explicit go/no-go exit criteria per wave
- [ ] Success metrics cover AARRR stages with targets
- [ ] LTV:CAC north star defined with component breakdown
- [ ] Battle cards for top 2-3 competitors with objection handling
- [ ] No fabricated competitor pricing, conversion rates, or market numbers
- [ ] All 4 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] Sources listed for all claims (per autonomous-research mixin)
- [ ] Assumptions labeled (per autonomous-research mixin)

---

## Examples

### Normal cases

**1. SaaS product launch (PLG)**
- Input: "We're launching a project management tool for remote teams. Freemium model, targeting startups and SMBs."
- Expected: New product launch detected. Research PM tool market (Asana, Monday, Linear). ICP: remote-first startups 10-200 employees. PLG motion with freemium entry, per-seat pricing with 3 tiers. Channels heavy on content/SEO and community. 90-day plan with Product Hunt launch milestone.

**2. Enterprise feature launch (SLG)**
- Input: "We're adding AI-powered compliance monitoring to our existing GRC platform. Enterprise customers, $50K+ ACV."
- Expected: Feature launch detected. Research GRC market and AI compliance trends. SLG motion with demo-first approach. Add-on pricing or tier upgrade path. Focus on existing customer base, analyst relations, industry events.

**3. Market expansion (new geography)**
- Input: "We're expanding our HR tech platform from US to EMEA, starting with UK and Germany."
- Expected: Market expansion detected. Research EMEA HR tech landscape, local competitors, regulatory requirements (GDPR, labor laws). Localized ICPs. Local pricing norms. Region-specific channels. 90-day plan phased UK-first, Germany second.

**4. With competitive analysis input**
- Input: "Create a GTM strategy for our API security platform. Here's our competitive analysis: [path]"
- Expected: Import competitive analysis. Skip redundant competitor research. Use SWOT and competitive positioning from import. Research pricing and channels independently. Build on existing differentiation.

**5. Repositioning/rebrand**
- Input: "We need to reposition our data analytics tool from a BI reporting tool to an AI-powered insights platform."
- Expected: Repositioning detected. Research BI-to-AI market shift. Map existing vs desired positioning. Messaging migration path. Existing customer communication plan. Phased rollout to avoid confusion.

### Edge cases

**6. Bootstrap startup (no budget)**
- Input: "We're launching a developer tool with zero marketing budget. Just me and my co-founder."
- Expected: Zero-cost GTM: founder-led content, community engagement, open-source consideration, Product Hunt, Hacker News, Reddit. PLG with generous free tier. No paid channels. Metrics focused on organic growth.

**7. Open-source project**
- Input: "We're launching an open-source database migration tool and want to build a commercial offering around it."
- Expected: Dual-track GTM: open-source community growth + commercial conversion. Research open-source GTM playbooks. Community metrics alongside commercial metrics. Pricing around managed service, enterprise features, or support tiers.

**8. Internal tool rollout**
- Input: "We need a rollout plan for our new internal employee portal across 5,000 employees."
- Expected: Adapt GTM for internal launch. ICP becomes departments. Channels become internal comms. Rollout waves by department/geography. Metrics: adoption rate, ticket deflection, satisfaction. Sales enablement becomes change management.

### Failure cases

**9. No context**
- Input: "GTM strategy"
- Expected: Interview mode (§7) — "What product, feature, or initiative do you need a go-to-market strategy for?"

**10. Out of scope**
- Input: "Write the actual ad copy and landing page for our product launch"
- Expected: "This skill creates go-to-market strategies including messaging frameworks and channel-specific copy direction. Writing production-ready ad copy and landing pages is outside scope. The messaging hierarchy can serve as a brief for copywriting."
