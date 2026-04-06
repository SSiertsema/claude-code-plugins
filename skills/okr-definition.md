# OKR Definition — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | okr-definition |
| **Version** | 1.0.0 |
| **Purpose** | Creates Objectives and Key Results at company, team, and individual levels. Supports cascading and alignment approaches. Scoring (0-1.0 scale), committed vs aspirational classification, CFR companion framework (Conversations, Feedback, Recognition). Validates OKRs against 20 common mistakes with quality scoring. Can import from vision-crafting output. Generates Mermaid diagrams with optional PNG export. |
| **Primary category** | `planning` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Creativity level** | `medium` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Mixins** | `[diagram-rendering, autonomous-research]` |

---

## When to use

- Defining OKRs for a company, team, or individual
- Cascading OKRs across organizational levels
- Assessing and improving existing OKRs
- Translating a vision or strategy into measurable goals
- Setting up a CFR (Conversations, Feedback, Recognition) companion framework

## When not to use

- Defining project tasks or work breakdown structures — use task-planning skills
- Creating KPIs without the OKR framework — use metrics/dashboard skills
- Strategic planning without measurable outcomes — use `vision-crafting`
- Performance reviews or individual evaluations
- Theme-based roadmapping from OKRs — use `theme-roadmapping`

---

## Required input

| Field | Description |
|---|---|
| **Organization/team/product context** | What entity the OKRs are for |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Vision/strategy document** | Path to vision-crafting output or strategy doc | Will identify strategic context itself |
| **OKR level** | Company, team, or individual | Company |
| **Cadence** | Annual or quarterly | Quarterly |
| **Existing OKRs** | Current OKRs to assess or build upon | None |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/okr-definition/` |

## Input schema

```
input:
  required:
    context:
      type: string
      description: "Organization, team, or product name and context"
  optional:
    vision_input:
      type: string | file_path
      description: "Vision-crafting output or strategy document to import from"
    okr_level:
      type: string
      enum: [company, team, individual]
      default: company
    cadence:
      type: string
      enum: [annual, quarterly]
      default: quarterly
    existing_okrs:
      type: string | file_path
      description: "Current OKRs to assess or extend"
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
| **What may be invented** | Objective themes based on industry patterns, key result metrics based on typical benchmarks, scoring thresholds based on domain norms |
| **What must be grounded** | OKR methodology (Doerr framework), scoring scale (0-1.0), committed vs aspirational definitions, CFR framework structure, quality validation criteria |
| **What assumptions are allowed** | Industry-typical objectives for similar organizations, benchmark targets based on comparable companies, cadence recommendations based on organization stage |
| **What must never be fabricated** | Specific company data without research basis, actual performance numbers, guaranteed outcomes, benchmark numbers without source |

---

## Processing rules

### Phase 1 — Setup
1. Parse input, detect organization/team/product context
2. If insufficient → interview mode (§7)
3. Check for vision/strategy input to import
4. Detect OKR level (company, team, individual)
5. Confirm scope, level, cadence with user
6. Ask diagram render mode (per diagram-rendering mixin)
7. Ask output path (default: `/documentation/[case]/okr-definition/`)

### Phase 2 — Research
8. WebSearch/WebFetch (per autonomous-research mixin) for industry OKR patterns
9. Research common objectives for similar organizations
10. Research typical key result metrics and benchmarks
11. Research scoring calibration norms and best practices

### Phase 3 — Strategic Context
12. If vision/strategy input provided: extract mission, vision, strategic priorities, values
13. If no strategic input: research organization's stated direction from public sources
14. Identify current challenges and opportunities
15. Map strategic priorities to potential objective areas
16. Present strategic context summary for user confirmation

### Phase 4 — Objective Definition
17. Define 3-5 objectives per level
18. Each objective must be qualitative, inspirational, action-oriented, time-bound
19. Classify each as committed, aspirational, or learning
20. Link each objective to a strategic priority
21. Present objectives for user confirmation

### Phase 5 — Key Result Definition
22. Define 2-5 key results per objective
23. Each KR must be quantitative, measurable, time-bound, with baseline and target
24. Define 0.3/0.5/0.7/1.0 scoring thresholds for every KR
25. Present key results for user confirmation

### Phase 6 — Alignment Check
26. Validate cascade: every team OKR traces to company, every individual to team
27. Detect conflicts between objectives at the same level
28. Flag potential tensions and suggest resolution
29. Build alignment map table

### Phase 7 — Quality Validation
30. Score overall OKR quality (0-100) against 20 common mistakes
31. Check for: output-not-outcome, too many OKRs, sandbagging, no baseline, not measurable, no alignment, conflicting, binary KR, BAU, metric gaming risk, etc.
32. Calculate quality score with rating (Excellent/Good/Fair/Poor)

### Phase 8 — CFR Framework
33. For each objective, define Conversations (topic, frequency, participants, purpose)
34. Define Feedback mechanisms (trigger, direction)
35. Define Recognition triggers and types

### Phase 9 — Diagrams
36. Generate 3 Mermaid diagrams:
    1. OKR Alignment Tree (flowchart) — cascade from company to team to individual
    2. Key Results Progress Dashboard (xychart-beta) — baseline vs target per KR
    3. Quality Scorecard (xychart-beta) — quality scores by dimension
37. Render per diagram-rendering mixin

### Phase 10 — Report Assembly
38. Assemble complete report, present for approval, save after confirmation

---

## Output contract

```markdown
# OKR Definition: [Entity Name]

**Date**: [date]
**Entity**: [name]
**Level**: [company/team/individual]
**Cadence**: [annual/quarterly]
**Objectives**: [count]
**Key Results**: [count]
**Quality score**: [0-100] — [rating]

## Executive Summary
[Key findings: quality score, objective types breakdown, alignment status, top 3 recommendations]

## Strategic Context
[Mission, vision, priorities, challenges]

## OKR Table
[Objectives with their key results, baselines, targets, scoring rubrics]

## Alignment Map
[Cascade validation + alignment tree diagram]

## Quality Validation
[Mistake detection + quality scorecard diagram]

## Key Results Dashboard
[Progress dashboard diagram]

## CFR Framework
[Conversations, feedback, recognition tables]

## Recommendations
[Prioritized actions traced to specific findings]

## Sources

## Assumptions & Limitations
```

### Diagrams

| # | Diagram | Mermaid type | Content |
|---|---|---|---|
| 1 | OKR Alignment Tree | flowchart | Cascade from company to team to individual objectives |
| 2 | Key Results Progress Dashboard | xychart-beta | Baseline vs target score per KR |
| 3 | Quality Scorecard | xychart-beta | Quality scores by dimension (measurability, alignment, ambition, clarity, completeness) |

Rendering per diagram-rendering mixin.

---

## Self-check

### Must verify before output
```
[] 3-5 objectives defined per level
[] 2-5 key results per objective with baselines and targets
[] Every objective classified (committed/aspirational/learning)
[] Every KR has 0.3/0.5/0.7/1.0 scoring thresholds
[] Alignment validated — no orphan OKRs
[] No conflicting OKRs at the same level
[] All 20 OKR mistakes checked
[] Quality score calculated (0-100)
[] CFR framework defined for each objective
[] Recommendations traced to specific findings
[] All 3 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
[] Sources listed for claims (per autonomous-research mixin)
[] Assumptions labeled with confidence (per autonomous-research mixin)
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No context provided | Enter interview mode (§7) — "What entity should I define OKRs for?" |
| Context too vague | Enter interview mode (§7) — ask targeted questions about the organization/team |
| Vision input malformed | Ask user to verify, attempt partial import |
| Cannot identify strategic priorities | Report limitation, produce OKRs with explicit assumptions labeled |
| Existing OKRs provided for assessment | Assess against the 20 mistakes, provide improvement recommendations |
| Single person / solo founder | Adapt to individual OKRs, skip cascade validation |
| Non-profit / mission-driven | Adapt objectives to impact metrics, not revenue |
| Cross-functional initiative | Create shared OKRs with clear ownership per KR |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| Out-of-scope request | "This skill defines and validates OKRs. [Request] is outside scope." |

---

## Quality checks

- [ ] 3-5 objectives defined per level with classification
- [ ] 2-5 key results per objective with baselines, targets, and scoring rubrics
- [ ] Every objective classified as committed, aspirational, or learning
- [ ] Every KR has 0.3/0.5/0.7/1.0 scoring thresholds defined
- [ ] Alignment validated — no orphan OKRs at any level
- [ ] No conflicting OKRs at the same level
- [ ] All 20 common OKR mistakes checked and scored
- [ ] Quality score calculated (0-100) with rating
- [ ] CFR framework defined for each objective
- [ ] Objectives are qualitative, inspirational, and action-oriented — never a metric
- [ ] Key results are quantitative, measurable, with baseline and target — never vague
- [ ] No fabricated company data or benchmark numbers
- [ ] All 3 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] Sources listed for benchmarks and claims (per autonomous-research mixin)
- [ ] Assumptions labeled with confidence (per autonomous-research mixin)

---

## Examples

### Normal cases

**1. SaaS company quarterly OKRs**
- Input: "Define Q2 OKRs for CloudMetrics, a B2B SaaS analytics platform with 500 customers"
- Expected: Company-level quarterly OKRs with 3-5 objectives covering growth, product, and customer success. Key results with SaaS-specific metrics (MRR, churn, NPS). Committed and aspirational mix. Quality score 75+.

**2. With vision-crafting input**
- Input: "/documentation/cloudmetrics/vision-crafting/vision-report.md"
- Expected: OKRs directly linked to the vision's strategic priorities. Alignment map shows clear trace from each objective to a strategic priority. No orphan objectives.

**3. Engineering team OKRs**
- Input: "Define OKRs for the Platform Engineering team at CloudMetrics. Company OKR: Achieve 99.95% uptime."
- Expected: Team-level OKRs cascading from the company objective. KRs on reliability, incident response, infrastructure metrics. Alignment map traces each team OKR to the company OKR.

**4. Startup annual OKRs**
- Input: "Annual OKRs for FreshBite, a pre-Series A food delivery startup in Amsterdam, 3 months post-launch"
- Expected: Company-level annual OKRs focused on product-market fit, growth, and fundraising. Heavy on aspirational objectives. Baselines near zero for many KRs.

**5. Assess existing OKRs**
- Input: Pasted set of current OKRs for review
- Expected: Assessment against 20 mistakes. Quality score with breakdown. Specific improvement recommendations per objective and KR. No new OKRs generated unless requested.

### Edge cases

**6. Solo founder**
- Input: "OKRs for me, solo founder of a side project"
- Expected: Individual-level OKRs only. Skip cascade validation. Adapt CFR to self-accountability mechanisms. Fewer objectives (2-3).

**7. Non-profit**
- Input: "Quarterly OKRs for WaterFirst, a clean water NGO operating in East Africa"
- Expected: Objectives focused on impact (lives affected, wells built) rather than revenue. KRs include donor and operational metrics alongside impact metrics.

**8. Cross-functional initiative**
- Input: "OKRs for a GDPR compliance initiative spanning Legal, Engineering, and Product teams"
- Expected: Shared objectives with KRs assigned to specific teams. Alignment shows how each team contributes. Potential conflicts between speed and compliance flagged.

### Failure cases

**9. No context**
- Input: "Define OKRs"
- Expected: Interview mode (§7) — "What entity should I define OKRs for?" Do not generate OKRs without context.

**10. Out of scope**
- Input: "Create a project plan with timelines and resource allocation"
- Expected: "This skill defines and validates OKRs. Project planning with timelines and resource allocation is outside scope. Consider using a project planning skill."
