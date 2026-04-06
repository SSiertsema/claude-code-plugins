# Stakeholder Mapping — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | stakeholder-mapping |
| **Version** | 1.0.0 |
| **Purpose** | Identifies, classifies, and prioritizes stakeholders using multiple frameworks (Power/Interest Grid, Salience Model, Engagement Assessment Matrix, Onion Diagram). Researches stakeholder landscape via web tools, produces stakeholder registers with 6-dimension attribute assessment, engagement strategies with gap analysis, communication plans, and risk factors. Generates Mermaid diagrams with optional PNG export. |
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

- User needs to identify and map stakeholders for a project, initiative, or organization
- User wants power/interest grid, salience model, or engagement assessment
- User needs stakeholder register with engagement strategies
- User wants communication plan derived from stakeholder analysis
- User needs to understand stakeholder dynamics and coalition structures
- User is starting a new project and needs to know who to engage

## When not to use

- RACI matrix creation — use `raci-matrix`
- Influence network diagramming (dependency/flow analysis) — use `influence-diagramming`
- User persona creation — use `persona-management`
- Organizational chart creation — not a strategy skill
- Communication plan only (without stakeholder analysis) — out of scope
- Project management planning — use appropriate planning skills

---

## Required input

| Field | Description |
|---|---|
| **Project/initiative context** | What the project or initiative is about — sufficient to identify stakeholder categories |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Known stakeholders** | Any stakeholders already identified | None (will be researched) |
| **Organization type** | Industry, sector, company size | Inferred from context |
| **Frameworks** | Which frameworks to apply | All four |
| **Focus areas** | Governance, delivery, external relations | All covered |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/stakeholder-mapping/` |

## Input schema

```
input:
  required:
    project_context:
      type: string
      description: "Project or initiative description — what is being planned or executed"
  optional:
    known_stakeholders:
      type: list[string]
      description: "Pre-identified stakeholders"
    organization_type:
      type: string
      description: "Industry/sector context"
    frameworks:
      type: list[string]
      enum: [power_interest_grid, salience_model, engagement_assessment, onion_diagram]
      default: all
    focus_areas:
      type: list[string]
      enum: [governance, delivery, external_relations]
      default: all
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
| **What may be invented** | Stakeholder role names for generic categories, example engagement tactics, scenario descriptions for gap closure |
| **What must be grounded** | Framework definitions (Mendelow, Mitchell/Agle/Wood, PMBOK), assessment criteria, strategy classifications, industry-typical stakeholder patterns |
| **What assumptions are allowed** | Stakeholder influence levels based on typical industry patterns, likely engagement attitudes based on role, coalition dynamics based on organizational theory |
| **What must never be fabricated** | Specific people's actual attitudes, real organizational politics, engagement outcomes, stakeholder reactions |

---

## Processing rules

### Phase 1 — Setup
1. Parse input, detect project context
2. If insufficient → interview mode (§7): gather project context at minimum
3. Confirm scope with user (project, organization, frameworks, known stakeholders)
4. Ask diagram render mode (per diagram-rendering mixin)
5. Ask output path (default: `/documentation/[case]/stakeholder-mapping/`)

### Phase 2 — Research
6. WebSearch/WebFetch (per autonomous-research mixin) for industry-typical stakeholder categories
7. Research regulatory/compliance stakeholders for the domain
8. Research common stakeholder dynamics in similar projects
9. Research best practices for stakeholder engagement in this initiative type

### Phase 3 — Stakeholder Identification
10. Identify 15-30 stakeholders across categories:
    - Internal: Upward (executives, board), Sideways (dept heads, peers), Downward (teams, employees)
    - External: Primary (customers, partners, suppliers), Secondary (regulators, media, community), Tertiary (investors, analysts)
11. For each: ID, name/role, organization, category, primary/secondary, description

### Phase 4 — Attribute Assessment
12. Score each stakeholder on 6 dimensions (1-5): Power, Interest, Influence, Impact, Legitimacy, Urgency
13. Calculate composite score (average)
14. Provide evidence justification for any dimension scored 4-5

### Phase 5 — Power/Interest Grid (Mendelow)
15. Plot all stakeholders on 2×2 matrix (Power × Interest)
16. Assign quadrant: Manage Closely / Keep Satisfied / Keep Informed / Monitor
17. Define tactics per quadrant with stakeholder lists
18. Generate quadrantChart diagram

### Phase 6 — Salience Model (Mitchell/Agle/Wood)
19. Classify using threshold: score 4-5 = "has" attribute
20. Assign type: Definitive / Dominant / Dangerous / Dependent / Dormant / Discretionary / Demanding
21. Determine salience level and type-specific strategy
22. Generate Venn diagram (flowchart)

### Phase 7 — Engagement Assessment
23. Assess current engagement: Unaware / Resistant / Neutral / Supportive / Leading
24. Set desired engagement level
25. Identify gaps and define closure actions
26. Classify attitude: Champion / Supporter / Neutral / Critic / Opponent / Blocker
27. Generate engagement gap xychart

### Phase 8 — Communication Plan
28. For top 15 stakeholders: method, frequency, key messages, relationship owner, escalation triggers
29. Tailor messages to stakeholder interests and concerns

### Phase 9 — Stakeholder Register
30. Compile complete register with all fields from Phases 3-8

### Phase 10 — Diagrams
31. Generate Stakeholder Onion Diagram (concentric rings by proximity)
32. Render all 4 diagrams in selected mode (code blocks or PNG via mmdc)

### Phase 11 — Report Assembly
33. Assemble complete report with all sections
34. Include Risk Factors (opposition, coalition risks, dormant stakeholder triggers)
35. Include Recommendations (prioritized, traced to specific findings)
36. Present for user approval, save after confirmation

---

## Output contract

```markdown
# Stakeholder Mapping: [Project/Initiative]

**Date**: [date]
**Project**: [name]
**Stakeholders identified**: [count]
**Frameworks applied**: [list]

## Executive Summary
[Key findings: most critical stakeholders, biggest engagement gaps, primary risks]

## Stakeholder Identification
[Table: ID, Name/Role, Organization, Category, Primary/Secondary, Description]

## Attribute Assessment
[Table: stakeholder × 6 dimensions scored 1-5 + composite]
[Evidence for scores 4-5]

## Power/Interest Grid
[Quadrant diagram + summary table with stakeholder lists per quadrant + tactics]

## Salience Analysis
[Venn diagram + classification table with type and strategy per stakeholder]

## Engagement Assessment
[Engagement table: current, desired, gap, attitude, actions]
[Gap chart diagram]
[Gap closure strategies]

## Communication Plan
[Table: stakeholder, method, frequency, key messages, owner, escalation trigger]

## Stakeholder Register
[Complete register table with all fields]

## Stakeholder Onion Diagram
[Proximity diagram with stakeholders in concentric rings]

## Risk Factors
[Stakeholder-related risks: opposition, coalitions, engagement gaps, dormant triggers]

## Recommendations
[Prioritized actions, each traced to specific findings]

## Sources
[Numbered list of web sources]

## Assumptions & Limitations
[Explicit list]
```

### Diagrams

| # | Diagram | Mermaid type | Content |
|---|---|---|---|
| 1 | Power/Interest Grid | quadrantChart | All stakeholders plotted by power vs interest |
| 2 | Salience Venn Diagram | flowchart | 3-circle Venn with 7 stakeholder types + IDs |
| 3 | Stakeholder Onion Diagram | flowchart | Concentric rings with stakeholders by proximity |
| 4 | Engagement Gap Chart | xychart-beta | Current vs desired engagement (bar pairs) |

Rendering per diagram-rendering mixin.

---

## Self-check

### Must verify before output
```
[] 15-30 stakeholders identified across internal/external (8-12 for small scope)
[] All stakeholders assessed on 6 dimensions (1-5 scale)
[] High-scoring dimensions (4-5) have evidence justification
[] Power/Interest grid with all 4 quadrants populated
[] Salience model classification for each stakeholder
[] Engagement assessment with current vs desired for each
[] Gap closure actions for every stakeholder with a gap
[] Communication plan for top 15 stakeholders
[] Complete stakeholder register with all fields populated
[] Risk factors identified and traced to specific stakeholders
[] Recommendations traced to specific findings
[] All 4 Mermaid diagrams render valid syntax (per diagram-rendering mixin)
[] Sources listed for all major claims (per autonomous-research mixin)
[] Assumptions explicitly labeled (per autonomous-research mixin)
[] No fabricated attitudes, politics, or outcomes
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No project context | Enter interview mode (§7) — "What project or initiative should I map stakeholders for?" |
| Context too vague | Enter interview mode (§7) — ask targeted questions |
| Too few stakeholders identifiable | Report limitation, work with available (minimum 8), note gaps |
| Framework not applicable | Skip framework, explain why |
| Cannot research industry context | Produce output based on generic patterns, label confidence as low |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| User provides conflicting scope | Present conflict, ask user to resolve |
| Out-of-scope request | "This skill maps and analyzes stakeholders. [Request] is outside scope." |

---

## Quality checks

- [ ] 15-30 stakeholders identified across internal and external categories
- [ ] Every stakeholder scored on all 6 dimensions with 1-5 scale
- [ ] Composite scores calculated correctly
- [ ] Power/Interest grid has stakeholders in all 4 quadrants
- [ ] Salience classification matches attribute thresholds (4+ = has attribute)
- [ ] Engagement gap identified for every stakeholder where current ≠ desired
- [ ] Communication plan specifies method, frequency, and key messages
- [ ] Stakeholder register contains all fields from all phases
- [ ] Risk factors reference specific stakeholders and scenarios
- [ ] Recommendations are concrete and traced to findings
- [ ] No fabricated stakeholder attitudes or organizational politics
- [ ] All 4 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] Sources listed for all major claims (per autonomous-research mixin)
- [ ] Assumptions explicitly labeled (per autonomous-research mixin)

---

## Examples

### Normal cases

**1. Software platform launch**
- Input: "Map stakeholders for our new B2B SaaS platform launch"
- Expected: Internal (product, engineering, sales, marketing, C-suite, customer success), External (target customers, existing users, technology partners, competitors, regulators, industry analysts, media). Power/Interest grid with sales leadership and C-suite in Manage Closely, engineering teams in Keep Informed. Communication plan with weekly steering committee and monthly customer advisory board.

**2. Organizational restructuring**
- Input: "We're restructuring our engineering department from functional to cross-functional teams"
- Expected: Heavy internal focus (engineering managers, team leads, HR, C-suite, affected engineers, union/works council if applicable). Engagement assessment showing likely resistance from functional managers losing direct reports. Risk factors around coalition formation among affected managers.

**3. Regulatory compliance initiative**
- Input: "Map stakeholders for GDPR compliance project across our European operations"
- Expected: DPO as definitive stakeholder (all 3 salience attributes), regulators (high power, low interest → keep satisfied), data subjects (legitimacy + urgency → dependent), legal team, IT security, third-party data processors. Heavy emphasis on legitimacy dimension.

**4. Product pivot**
- Input: "We're pivoting our consumer app from social media to productivity focus"
- Expected: Current users (high interest, mixed attitudes — some resistant), investors (high power, high urgency), existing content creators (dependent stakeholders needing advocacy), competitors in new space. Engagement gap analysis showing need to move current users from Resistant to Neutral/Supportive.

**5. Merger/acquisition integration**
- Input: "Map stakeholders for post-merger integration of two mid-size tech companies"
- Expected: Both leadership teams, boards, employees from both companies (different engagement levels), customers of both, regulators (antitrust), investors, key suppliers, media. Heavy engagement gap analysis for acquired company employees. Onion diagram showing dual core teams merging.

### Edge cases

**6. Very small project**
- Input: "Map stakeholders for adding a dark mode feature to our app"
- Expected: Acknowledges smaller scope, identifies 8-12 stakeholders (not 15-30), simplified analysis with note that reduced scope is appropriate. Lighter communication plan. Some frameworks may be simplified.

**7. Non-profit/public sector**
- Input: "Map stakeholders for a municipal parks renovation project"
- Expected: Adapts to public sector — elected officials, citizens/taxpayers, community groups, environmental agencies, contractors, media, neighboring businesses. Higher weight on legitimacy dimension. Engagement assessment considers democratic accountability.

**8. Startup with minimal structure**
- Input: "We're a 5-person startup launching our MVP"
- Expected: Acknowledges lean context, focuses on external stakeholders (early adopters, investors/angels, advisors, potential partners, accelerator), minimal internal mapping (all 5 people are core). Simplified register. Notes that stakeholder landscape will change rapidly with growth.

### Failure cases

**9. No context**
- Input: "Map stakeholders"
- Expected: Interview mode (§7) — "What project or initiative should I map stakeholders for? What decisions will the mapping inform?"

**10. Out of scope**
- Input: "Create an organizational chart for our company"
- Expected: "This skill maps and analyzes stakeholders for projects and initiatives. Organizational charting is outside scope. Consider using a diagramming tool for org charts."
