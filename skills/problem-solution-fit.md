# Problem-Solution Fit — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | problem-solution-fit |
| **Version** | 1.0.0 |
| **Purpose** | Validates whether a proposed solution effectively addresses a genuine, significant problem. Uses multiple frameworks: problem significance scoring (frequency, intensity, willingness to pay), Customer Forces Canvas, Solution-Problem Mapping with coverage scoring, DVF assessment (desirability-viability-feasibility with geometric mean), Riskiest Assumption Testing with validation experiment designs, and Strategyzer Evidence Quality Ladder. Produces a composite fit scorecard (0-100) with pivot/persevere recommendations. Generates Mermaid diagrams with optional PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Creativity level** | `medium` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Mixins** | `[diagram-rendering, autonomous-research]` |

---

## When to use

- User needs to validate whether a solution addresses a real problem
- User wants structured problem-solution fit assessment with scoring
- User needs to identify and prioritize riskiest assumptions
- User wants validation experiment designs for hypotheses
- User needs DVF (desirability-viability-feasibility) assessment
- User wants evidence-based pivot/persevere recommendation
- User is pre-product and needs to validate before building

## When not to use

- Value proposition design — use `value-proposition-canvas`
- Full business case creation — use `business-case-management`
- Customer segmentation — use `customer-segmentation`
- Market sizing — use `market-sizing`
- ROI calculations — use `roi-modeling`
- Product-market fit measurement from live product data — out of scope
- Competitive analysis depth — use `competitive-analysis`

---

## Required input

| Field | Description |
|---|---|
| **Problem and solution description** | The problem being addressed and the proposed solution |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Value proposition canvas** | Existing VPC output to import | None |
| **Customer/persona data** | Target customer insights | None (will research) |
| **Existing evidence** | Customer interviews, surveys, pilot results | None |
| **Competitors/alternatives** | Known existing solutions | Will be researched |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/problem-solution-fit/` |

## Input schema

```
input:
  required:
    problem_solution:
      type: string
      description: "Problem being addressed and proposed solution"
  optional:
    vpc_output:
      type: string | file_path
      description: "Existing Value Proposition Canvas output"
    customer_data:
      type: string | file_path
      description: "Persona or customer segment data"
    evidence:
      type: string | file_path
      description: "Existing validation evidence (interviews, surveys, pilot data)"
    competitors:
      type: list[string]
      description: "Known competitor solutions"
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
| **What may be invented** | Problem descriptions based on market research, alternative characterizations based on public data, assumption categories based on typical patterns |
| **What must be grounded** | DVF framework definitions, Evidence Quality Ladder levels, fit scoring methodology, RAT scoring formula |
| **What assumptions are allowed** | Problem frequency/intensity based on market evidence, customer willingness to pay based on alternatives pricing, feasibility estimates based on technology landscape |
| **What must never be fabricated** | Customer quotes, survey results, usage statistics, evidence quality levels without actual evidence, guaranteed fit outcomes |

---

## Processing rules

### Phase 1 — Setup
1. Parse input, detect problem and solution
2. If insufficient → interview mode (§7)
3. Check for VPC/persona/evidence inputs
4. Confirm scope with user
5. Ask diagram render mode (per diagram-rendering mixin)
6. Ask output path (default: `/documentation/[case]/problem-solution-fit/`)

### Phase 2 — Research
7. WebSearch/WebFetch (per autonomous-research mixin) for market context
8. Research existing alternatives and competitor solutions
9. Research customer pain points in forums, reviews, articles
10. Research industry validation patterns and benchmarks

### Phase 3 — Problem Assessment
11. Score problem significance: Frequency (1-5), Intensity (1-5), Willingness to Pay (1-5)
12. Assess validation level: Confirmed / Observed / Hypothesis
13. Map existing alternatives with strengths/weaknesses
14. Root cause analysis using 5 Whys

### Phase 4 — Customer Forces Canvas
15. Map triggers, desired outcomes, existing alternatives, inertia factors, friction factors
16. Assess force balance: (Push + Pull) - Resistance

### Phase 5 — Solution-Problem Mapping
17. Map each solution feature to validated problems
18. Identify gaps (unaddressed problems) and over-engineering (unjustified features)
19. Calculate coverage score: % of validated problems addressed

### Phase 6 — DVF Assessment
20. Score Desirability (0-100): problem significance, customer pull, emotional resonance, early adopters, competitive gap
21. Score Viability (0-100): revenue potential, cost structure, scalability, business model, moat
22. Score Feasibility (0-100): technical complexity, resources, dependencies, time to market, risk
23. Calculate DVF score: geometric mean of all three
24. Identify weakest lens

### Phase 7 — Riskiest Assumption Testing
25. List all assumptions with category (value, audience, problem, motivation, execution, competition)
26. Score: Impact (1-5) × Lack of Confidence (1-5) = Risk Score
27. Rank by risk score
28. Design validation experiments for top 5 with success criteria, fail conditions, evidence quality target

### Phase 8 — Evidence Assessment
29. If evidence provided: score per Strategyzer Evidence Quality Ladder (1-6)
30. Calculate per-assumption evidence level
31. Calculate overall evidence strength (0-100)

### Phase 9 — Fit Scorecard
32. Calculate composite PSF score: Problem significance (30%) + Coverage (25%) + DVF (20%) + Evidence (15%) + Differentiation (10%)
33. Assign rating: Strong (≥75) / Moderate (50-74) / Weak (25-49) / Not achieved (<25)
34. Determine pivot/persevere recommendation: Scale / Persevere / Pivot / Kill

### Phase 10 — Diagrams
35. Generate 4 Mermaid diagrams:
    1. Problem-Solution Map (flowchart) — problems↔features with gaps and over-engineering
    2. DVF Venn Diagram (flowchart) — three lenses with scores
    3. Assumption Priority Matrix (quadrantChart) — impact vs confidence
    4. Fit Scorecard Chart (xychart-beta) — 5 scoring dimensions
36. Render per diagram-rendering mixin

### Phase 11 — Report Assembly
37. Assemble complete report, present for approval, save after confirmation

---

## Output contract

```markdown
# Problem-Solution Fit: [Solution Name]

**Date**: [date]
**Problem**: [brief]
**Solution**: [brief]
**Target customer**: [segment]
**PSF Score**: [0-100] — [Strong/Moderate/Weak/Not achieved]
**Recommendation**: [Scale/Persevere/Pivot/Kill]

## Executive Summary
## Problem Assessment
### Problem Significance + Root Cause + Existing Alternatives
## Customer Forces Canvas
## Solution-Problem Mapping + diagram
### Coverage + Gaps + Over-engineering
## DVF Assessment + diagram
## Riskiest Assumptions + diagram
### Assumption Register + Top 5 Validation Experiments
## Evidence Assessment (if provided)
## Fit Scorecard + diagram
## Pivot/Persevere Recommendation
## Recommendations
## Sources
## Assumptions & Limitations
```

### Diagrams

| # | Diagram | Mermaid type | Content |
|---|---|---|---|
| 1 | Problem-Solution Map | flowchart | Problems↔features with gaps/over-engineering |
| 2 | DVF Venn Diagram | flowchart | Three lenses with scores and key factors |
| 3 | Assumption Priority Matrix | quadrantChart | Impact vs confidence with assumptions plotted |
| 4 | Fit Scorecard Chart | xychart-beta | 5 scoring dimensions |

Rendering per diagram-rendering mixin.

---

## Self-check

### Must verify before output
```
[] Problem significance scored (frequency, intensity, WTP)
[] Validation level assessed
[] Root cause analysis completed (5 Whys)
[] Existing alternatives mapped
[] Customer forces canvas complete
[] Solution-problem mapping with coverage score
[] Gaps and over-engineering identified
[] DVF scored (0-100 per lens) with geometric mean
[] Weakest DVF lens identified
[] Assumptions listed, categorized, risk-scored
[] Top 5 have validation experiments with success/fail criteria
[] Evidence scored if provided
[] Fit scorecard calculated (0-100 weighted composite)
[] PSF rating assigned
[] Pivot/persevere recommendation justified
[] All 4 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
[] Sources listed (per autonomous-research mixin)
[] Assumptions labeled (per autonomous-research mixin)
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No problem/solution described | Enter interview mode (§7) — "What problem are you trying to solve, and what solution are you proposing?" |
| Context too vague | Enter interview mode (§7) — ask targeted questions |
| No customer data available | Use research-based inference with `[Assumption]` labels |
| VPC input malformed | Ask user to verify, attempt partial import |
| Problem appears trivial | Report finding with evidence, assess anyway, note in recommendations |
| Solution is very early stage | Adjust expectations, focus on assumption testing over evidence assessment |
| Cannot find market evidence | Note gap, produce with lower confidence, recommend primary research |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| Out-of-scope request | "This skill assesses problem-solution fit. [Request] is outside scope." |

---

## Quality checks

- [ ] Problem significance scored on all 3 dimensions with evidence
- [ ] Root cause analysis reaches genuine root (not surface symptom)
- [ ] Existing alternatives include workarounds (strong validation signal)
- [ ] Customer forces canvas has all 5 forces with specific findings
- [ ] Coverage score calculated from actual mapping data
- [ ] DVF uses geometric mean (not arithmetic — all three must be strong)
- [ ] Weakest DVF lens identified with specific improvement actions
- [ ] Assumptions risk-scored with correct formula (Impact × Lack of Confidence)
- [ ] Validation experiments have specific, measurable success criteria
- [ ] Evidence scoring matches Strategyzer ladder definitions
- [ ] Fit scorecard weights sum to 100%
- [ ] Pivot/persevere recommendation references specific scorecard dimensions
- [ ] No fabricated evidence, quotes, or usage statistics
- [ ] All 4 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] Sources listed (per autonomous-research mixin)
- [ ] Assumptions labeled (per autonomous-research mixin)

---

## Examples

### Normal cases

**1. SaaS productivity tool**
- Input: "We're building a unified workspace to solve context switching between 10+ tools"
- Expected: Problem significance high (daily frequency, high intensity). Existing alternatives: Notion, Slack, project tools. Coverage mapping shows core features aligned but gaps in integration. DVF: desirability strong, viability moderate (crowded market), feasibility strong. Top assumption: "users will consolidate tools" — test via landing page.

**2. With VPC input**
- Input: [VPC report path] + "Assess the problem-solution fit"
- Expected: Imports customer profile (jobs, pains, gains) and value map. Focuses on fit assessment, DVF, and assumption testing. References VPC data as evidence source.

**3. Healthcare medication adherence app**
- Input: "App to remind patients to take medication and track adherence"
- Expected: Problem well-documented (50% non-adherence rate). Strong desirability. Feasibility concerns: HIPAA compliance, integration with pharmacy systems. DVF score pulled down by feasibility. Top assumptions around regulatory path.

**4. B2B API platform**
- Input: "API integration platform for connecting legacy ERP systems with modern SaaS"
- Expected: Technical feasibility strong (team has expertise). Desirability uncertain — need to validate if IT teams prefer platform vs custom integration. Assumption testing focused on willingness to pay and adoption friction.

**5. Two-sided marketplace**
- Input: "Marketplace connecting freelance data scientists with SMBs needing analytics"
- Expected: Dual problem validation (supply: freelancers need clients; demand: SMBs need affordable analytics). Chicken-and-egg assumption is highest risk. Experiments designed for both sides independently.

### Edge cases

**6. Very early idea**
- Input: "I have an idea for something that helps people manage their energy levels throughout the day"
- Expected: Minimal evidence, problem vaguely defined. Focus on problem validation and assumption identification. Most items at "Hypothesis" level. Recommend problem interviews before solution design. Lower PSF score with "Persevere" recommendation to gather evidence.

**7. Solution exists, problem unclear**
- Input: "We built a Chrome extension that highlights text in different colors. What problem does it solve?"
- Expected: Reverse analysis — identify potential problems (reading comprehension, research organization, collaborative annotation). Assess which problem has strongest significance. Flag the solution-first approach as a risk.

**8. Non-profit/social venture**
- Input: "Free literacy tutoring platform for underserved communities"
- Expected: Adapt DVF for non-commercial: viability measured by sustainability (grants, donations, volunteer supply) not profit. Desirability likely high. Feasibility depends on volunteer recruitment and retention.

### Failure cases

**9. No context**
- Input: "Assess fit"
- Expected: Interview mode (§7) — "What problem are you trying to solve, and what solution are you proposing?"

**10. Out of scope**
- Input: "Measure our product-market fit from our usage analytics"
- Expected: "This skill assesses problem-solution fit on paper (pre-product validation). Product-market fit measurement from live product data is outside scope."
