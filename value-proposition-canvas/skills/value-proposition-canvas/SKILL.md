---
name: value-proposition-canvas
description: Autonomous Value Proposition Canvas using Strategyzer's framework. Creates Customer Profiles (jobs, pains, gains) and Value Maps (products/services, pain relievers, gain creators). Assesses problem-solution fit with scoring. Supports multiple customer segments (one canvas per segment). Researches customer insights via web. Generates Mermaid diagrams with optional PNG export.
argument-hint: "[product/service name or business case path]"
---

# Value Proposition Canvas

You create autonomous Value Proposition Canvases based on Strategyzer's framework. You research customer insights and market context yourself — do not ask the user for data they would need to look up. Only ask the user for decisions and confirmations.

## Phase 1 — Setup

### Input handling

Follow shared foundation §7 — interview mode. When input is missing or insufficient, interview to gather at minimum:

| Dimension | Required | Default |
|---|---|---|
| **Product/service** (name, description, or business case) | Yes | — |
| **Target customer segments** | No | Will be researched or inferred |
| **Industry/market** | No | Inferred from product/service |
| **Existing customer data** (personas, segmentation output) | No | Will be researched |
| **Competitor context** | No | Will be researched |
| **Geographic scope** | No | Global |

**Exit interview when**: Product/service is clear enough to research customer context. Do not over-interview — the skill researches data itself.

### 1. Collect input

Accept one of:
- A product or service name/description
- A file path to a business case document
- Pasted business case content
- Output from `customer-segmentation` or `persona-management`
- No input or vague input → enter interview mode

### 2. Detect scope

From the input (or interview results), identify:
- **Product/Service**: What is being offered
- **Industry/market**: Sector and market segment
- **Target segments**: Customer segments to analyze (one canvas per segment)
- **Geographic scope**: Region or global (default: global)
- **Competitor context**: Known competitors (if any)

### 3. Confirm scope

Present detected scope to the user for confirmation:

```
**Product/Service**: [name]
**Industry**: [industry/segment]
**Target segments**: [listed or "will be researched"]
**Geographic scope**: [scope]
**Competitors**: [listed or "will be researched"]
```

Ask the user to confirm or adjust.

Ask diagram render mode and output path per the `diagram-rendering` and `autonomous-research` mixins.

## Phase 2 — Research

Use WebSearch and WebFetch per the `autonomous-research` mixin.

Research:
- Customer insights: jobs-to-be-done, pain points, desired outcomes in the target market
- Market context: industry dynamics, customer expectations, unmet needs
- Competitor value propositions: how competitors address similar customer segments
- Domain-specific knowledge: typical customer workflows, decision criteria, buying behavior

## Phase 3 — Customer Segment Selection

Identify target segments using one of:
- Output from `customer-segmentation` skill (if provided)
- Personas from `persona-management` (if provided)
- Research-based inference from Phase 2

One canvas will be produced per segment. For multi-segment analysis, confirm segment list with user before proceeding.

Present:
```
**Segments to analyze**:
1. [Segment name] — [brief description]
2. [Segment name] — [brief description]
...
```

Ask user to confirm, add, or remove segments.

## Phase 4 — Customer Profile

For each segment, build the Customer Profile side of the canvas.

### Customer Jobs

Identify 8-12 customer jobs across four types:
- **Functional**: Tasks customers are trying to perform or complete
- **Social**: How customers want to be perceived by others
- **Emotional**: Feelings customers seek or want to avoid
- **Supporting**: Roles customers play in related contexts (buying, co-creating, transferring)

Prioritize the top 5 by importance to the customer.

| ID | Job | Type | Priority | Evidence |
|---|---|---|---|---|
| J1 | [description] | Functional / Social / Emotional / Supporting | 1-5 | [source or assumption label] |

### Pains

Identify 8-12 pains across three categories:
- **Undesired outcomes**: Functional, social, emotional problems
- **Obstacles**: Things preventing job completion
- **Risks**: Potential negative consequences

Rank by severity: Extreme / High / Moderate.

| ID | Pain | Category | Severity | Evidence |
|---|---|---|---|---|
| P1 | [description] | Undesired outcome / Obstacle / Risk | Extreme / High / Moderate | [source or assumption label] |

Prioritize the top 5 by severity.

### Gains

Identify 8-12 gains across four types:
- **Required**: Minimum expectations without which the solution fails
- **Expected**: Gains customers assume they will get
- **Desired**: Gains customers would love but do not expect
- **Unexpected**: Gains beyond customer imagination

Rank by relevance: Essential / Important / Nice-to-have.

| ID | Gain | Type | Relevance | Evidence |
|---|---|---|---|---|
| G1 | [description] | Required / Expected / Desired / Unexpected | Essential / Important / Nice-to-have | [source or assumption label] |

Prioritize the top 5 by relevance.

## Phase 5 — Value Map

For each segment, build the Value Map side of the canvas.

### Products & Services

List the products and services offered, classified by type:
- **Physical**: Tangible goods
- **Digital**: Software, apps, platforms
- **Intangible**: Services, consulting, support
- **Financial**: Financial products, insurance, financing

Rank by importance to the value proposition.

| ID | Product/Service | Type | Importance |
|---|---|---|---|
| PS1 | [description] | Physical / Digital / Intangible / Financial | High / Medium / Low |

### Pain Relievers

Describe how each product/service alleviates specific prioritized pains. Map 1:1 where possible.

| ID | Pain Reliever | Addresses Pain | Strength |
|---|---|---|---|
| PR1 | [description] | P[n] | Strong / Moderate / Weak |

### Gain Creators

Describe how each product/service produces specific prioritized gains. Map 1:1 where possible.

| ID | Gain Creator | Addresses Gain | Strength |
|---|---|---|---|
| GC1 | [description] | G[n] | Strong / Moderate / Weak |

## Phase 6 — Fit Assessment

For each segment, assess problem-solution fit.

### Pain Coverage
Map each pain reliever to its corresponding pain:

| Pain | Pain Reliever | Fit Strength |
|---|---|---|
| P[n]: [description] | PR[n]: [description] | Strong / Moderate / Weak / Unaddressed |

### Gain Coverage
Map each gain creator to its corresponding gain:

| Gain | Gain Creator | Fit Strength |
|---|---|---|
| G[n]: [description] | GC[n]: [description] | Strong / Moderate / Weak / Unaddressed |

### Scoring

- **Pain coverage**: % of prioritized pains addressed (at least Weak strength)
- **Gain coverage**: % of prioritized gains addressed (at least Weak strength)
- **Fit level**: High (>70% coverage), Medium (40-70%), Low (<40%)
- **Gaps**: Unmatched pains (no pain reliever)
- **Over-delivery**: Gain creators that address non-prioritized or unexpected gains
- **Overall fit score**: 0-100, weighted: pain coverage 60%, gain coverage 40%

## Phase 7 — Competitive Comparison

If competitors were identified in Phase 2:
- Brief competitor value map comparison (how competitors address the same customer jobs/pains/gains)
- Differentiation opportunities (where the subject's value proposition is unique or stronger)
- Competitive gaps (where competitors outperform)

If no competitors identified, skip this phase and note it.

## Phase 8 — Diagrams

Generate 3 Mermaid diagrams per segment:

### 1. Canvas Overview (mindmap)

```mermaid
mindmap
  root((Value Proposition Canvas\n[Segment]))
    Customer Profile
      Jobs
        J1: [job]
        J2: [job]
        ...
      Pains
        P1: [pain]
        P2: [pain]
        ...
      Gains
        G1: [gain]
        G2: [gain]
        ...
    Value Map
      Products & Services
        PS1: [product]
        PS2: [product]
        ...
      Pain Relievers
        PR1: [reliever]
        PR2: [reliever]
        ...
      Gain Creators
        GC1: [creator]
        GC2: [creator]
        ...
```

### 2. Fit Mapping (flowchart)

```mermaid
flowchart LR
    subgraph Pain_Relievers
        PR1["PR1: ..."]
        PR2["PR2: ..."]
    end
    subgraph Pains
        P1["P1: ..."]
        P2["P2: ..."]
    end
    subgraph Gain_Creators
        GC1["GC1: ..."]
        GC2["GC2: ..."]
    end
    subgraph Gains
        G1["G1: ..."]
        G2["G2: ..."]
    end
    PR1 -->|Strong| P1
    PR2 -->|Moderate| P2
    GC1 -->|Strong| G1
    GC2 -->|Weak| G2
```

Use link labels to indicate fit strength. Use dashed links for Weak, normal for Moderate, thick for Strong.

### 3. Fit Score Chart (xychart-beta)

```mermaid
xychart-beta
    title "Fit Score by Segment"
    x-axis ["Segment 1", "Segment 2", ...]
    y-axis "Fit Score (0-100)" 0 --> 100
    bar [score1, score2, ...]
```

Render all diagrams per the `diagram-rendering` mixin.

File naming:
- `canvas-overview-[segment].mmd` / `.png`
- `fit-mapping-[segment].mmd` / `.png`
- `fit-score-chart.mmd` / `.png`

## Phase 9 — Recommendations

Prioritized actions based on findings:
- **Gaps to address**: Prioritized pains/gains with no or weak coverage
- **Over-deliveries to evaluate**: Gain creators addressing non-prioritized gains — consider whether to keep, reduce, or reposition
- **Iteration suggestions**: How to improve fit score per segment
- **Competitive moves**: Actions based on competitive comparison (if applicable)

Every recommendation must trace back to a specific finding from the analysis.

## Phase 10 — Report Assembly and Approval

Assemble the complete report. Present for user approval. Save only after explicit confirmation.

## Generation rules

Per the `autonomous-research` mixin, plus:
- **Customer jobs**: Describe in the customer's language, not the provider's
- **Specificity**: "Save 3 hours/week on report generation" not "improve efficiency"
- **Language**: Respond and generate in the user's language unless specified otherwise

## Failure behavior

| Situation | Behavior |
|---|---|
| No product/service context | Enter interview mode — ask what product or service to analyze |
| Context too vague | Enter interview mode — ask targeted questions to narrow scope |
| No customer data available | Use research-based inference with [Assumption] labels |
| Single segment only | Produce one canvas, note limitation in report |
| Cannot identify competitors | Skip competitive comparison, note in report |
| Insufficient research data | Produce partial output, label gaps and low-confidence findings |
| mmdc / web search failures | Per `diagram-rendering` and `autonomous-research` mixins |
| User provides conflicting scope | Present the conflict, ask user to resolve |
| Out-of-scope request | "This skill creates Value Proposition Canvases. [Request] is outside scope." |

## Self-check

Before presenting output, verify:

```
[] Customer Profile complete for each segment (jobs, pains, gains with types and priorities)
[] Value Map complete for each segment (products, pain relievers, gain creators)
[] Fit assessment with coverage scores for each segment
[] Gaps and over-deliveries identified
[] Fit score calculated (0-100)
[] Recommendations traced to specific gaps/findings
[] All Mermaid diagrams render valid syntax (per diagram-rendering mixin)
[] Sources listed (per autonomous-research mixin)
[] Assumptions labeled (per autonomous-research mixin)
```
