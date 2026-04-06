# Influence Diagramming — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | influence-diagramming |
| **Version** | 1.0.0 |
| **Purpose** | Maps relationships, influence flows, and power dynamics between stakeholders using network analysis techniques. Builds on stakeholder mapping output (or identifies stakeholders itself). Produces influence matrices with outgoing/incoming totals, centrality analysis (degree, betweenness, closeness), network role identification (hub, gatekeeper, bridge, broker, isolate), coalition detection with stance and vulnerability analysis, influence pathway mapping with bottleneck identification, and strategic recommendations. Generates Mermaid diagrams with optional PNG export. |
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

- User needs to understand influence relationships between stakeholders
- User wants to identify key influencers, gatekeepers, and bridges in a network
- User needs coalition analysis and power dynamics mapping
- User wants influence pathways for change management or communication strategy
- User has stakeholder mapping output and wants deeper relationship analysis
- User needs to identify single points of failure in influence chains
- User is planning change management and needs to know the optimal influence chain

## When not to use

- Stakeholder identification and classification — use `stakeholder-mapping`
- RACI matrix creation — use `raci-matrix`
- User persona creation — use `persona-management`
- Organizational chart creation — not a strategy skill
- Social media network analysis — out of scope
- Communication plan only (without influence analysis) — use `stakeholder-mapping`

---

## Required input

| Field | Description |
|---|---|
| **Project/initiative context** | What the project or initiative is about — sufficient to identify stakeholders and research influence dynamics |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Stakeholder mapping output** | Existing stakeholder register or mapping report (file path or pasted) | None (will identify stakeholders itself) |
| **Known relationships** | Any known influence relationships | None |
| **Focus** | Change management, risk, communication, coalition building | All |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/influence-diagramming/` |

## Input schema

```
input:
  required:
    project_context:
      type: string
      description: "Project or initiative description"
  optional:
    stakeholder_mapping:
      type: string | file_path
      description: "Existing stakeholder mapping report to import from"
    known_relationships:
      type: list[object]
      description: "Pre-identified influence relationships"
    focus:
      type: list[string]
      enum: [change_management, risk, communication, coalition_building]
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
| **What may be invented** | Influence relationship patterns based on typical organizational dynamics, coalition compositions based on common patterns, stakeholder role names for generic categories |
| **What must be grounded** | Centrality formulas, network analysis concepts, influence type definitions, network role identification criteria |
| **What assumptions are allowed** | Influence strength estimates based on role/position, coalition formation based on shared attitudes, pathway effectiveness estimates, typical organizational dynamics |
| **What must never be fabricated** | Specific people's actual relationships, real organizational politics, influence outcomes, centrality scores without relationship data |

---

## Processing rules

### Phase 1 — Setup
1. Parse input, detect project context
2. If insufficient → interview mode (§7): gather project context at minimum
3. Check for stakeholder mapping output — if provided, will import stakeholders
4. Confirm scope with user (project, stakeholder source, focus areas)
5. Ask diagram render mode (per diagram-rendering mixin)
6. Ask output path (default: `/documentation/[case]/influence-diagramming/`)

### Phase 2 — Research
7. WebSearch/WebFetch (per autonomous-research mixin) for typical influence dynamics in this project/industry type
8. Research common power structures and organizational politics patterns
9. Research best practices for influence management in this domain
10. Research known challenges with stakeholder influence in similar contexts

### Phase 3 — Stakeholder Import or Identification
11. If stakeholder mapping provided: import stakeholders with attributes (ID, name, role, organization, category, power, interest, attitude)
12. If not provided: identify 10-20 key stakeholders with basic attributes (ID, name/role, organization, attitude)
13. Present stakeholder list for user confirmation

### Phase 4 — Influence Relationship Assessment
14. For each meaningful stakeholder pair, assess:
    - Direction: unidirectional (→) or bidirectional (↔)
    - Strength: 1-5 scale
    - Type: from 7 influence types (formal authority, resource control, information access, expertise, social capital, political leverage, referent power)
    - Nature: supportive, neutral, or adversarial
    - Basis: why this influence exists

### Phase 5 — Influence Matrix
15. Build N×N matrix (rows = influencer, columns = influenced, cells = strength)
16. Calculate row totals (outgoing), column totals (incoming)
17. Calculate influence ratios (outgoing/incoming)
18. Identify top influencers and most influenced

### Phase 6 — Network Analysis
19. Calculate centrality metrics: degree, betweenness, closeness (normalized 0-1)
20. Identify network roles using centrality thresholds:
    - Hub (degree > 0.6), Gatekeeper (betweenness > 0.4), Bridge (connects disconnected groups)
    - Broker (high betweenness + multi-coalition), Isolate (degree < 0.1), Connector (high closeness)

### Phase 7 — Coalition Detection
21. Identify clusters: 3+ stakeholders with strong mutual influence (≥3) and shared attitudes
22. Profile each coalition: members, stance, combined influence, internal density, leader, swing members, vulnerabilities
23. Map cross-coalition dynamics: relationships, bridges, risks

### Phase 8 — Influence Pathway Analysis
24. Map critical pathways: decision→implementation, sponsor→resistant groups, information propagation
25. Identify bottlenecks: stakeholders where paths are weakest
26. Identify single points of failure: stakeholders whose removal disconnects the network
27. Map alternative routes for risk mitigation

### Phase 9 — Strategic Recommendations
28. Key influencer strategy, gatekeeper management, coalition strategy, bridge activation, isolate engagement, risk mitigation
29. Every recommendation traced to specific network findings
30. Prioritize as Critical / High / Medium / Low

### Phase 10 — Diagrams
31. Generate 4 Mermaid diagrams:
    1. Influence Network (flowchart) — nodes with attitude colors, edges with strength styling, coalition subgraphs
    2. Influence Matrix Heat Map (flowchart or markdown table with indicators)
    3. Centrality Comparison Chart (xychart-beta) — degree/betweenness/closeness for top 10
    4. Coalition Map (flowchart) — coalition subgraphs with stance, bridges, swing members
32. Render in selected mode (code blocks or PNG via mmdc)

### Phase 11 — Report Assembly
33. Assemble complete report with all sections
34. Present for user approval, save after confirmation

---

## Output contract

```markdown
# Influence Diagramming: [Project/Initiative]

**Date**: [date]
**Project**: [name]
**Stakeholders analyzed**: [count]
**Relationships mapped**: [count]
**Coalitions identified**: [count]

## Executive Summary
[Key findings: most influential stakeholders, critical gatekeepers, coalition dynamics, primary risks, top recommendations]

## Stakeholder Overview
[Table: ID, Name/Role, Organization, Attitude]

## Influence Relationships
[Table: From, To, Direction, Strength, Type, Nature, Basis]

## Influence Network Diagram
[Network graph with attitude-colored nodes, strength-styled edges, coalition subgraphs]

## Influence Matrix
[N×N matrix with row/column totals + heat map]

## Centrality Analysis
[Table: stakeholder, degree, betweenness, closeness, role, significance]
[Centrality comparison chart]

## Coalition Analysis
[Per-coalition profile: members, stance, strength, leader, vulnerabilities]
[Cross-coalition dynamics table]
[Coalition map diagram]

## Influence Pathways
[Critical paths table with routes, strengths, bottlenecks]
[Single points of failure with mitigation]

## Strategic Recommendations
[Table: category, recommendation, finding reference, priority, stakeholders]

## Sources
[Numbered list of web sources]

## Assumptions & Limitations
[Explicit list]
```

### Diagrams

| # | Diagram | Mermaid type | Content |
|---|---|---|---|
| 1 | Influence Network | flowchart | Nodes (attitude-colored) + edges (strength-styled) + coalition subgraphs |
| 2 | Influence Matrix Heat Map | flowchart / markdown | N×N matrix with strength indicators |
| 3 | Centrality Comparison Chart | xychart-beta | Degree/betweenness/closeness for top 10 stakeholders |
| 4 | Coalition Map | flowchart | Coalition subgraphs with stance, bridges, swing members |

Rendering per diagram-rendering mixin.

---

## Self-check

### Must verify before output
```
[] 10-20 stakeholders with influence relationships mapped (6+ for small scope)
[] Relationships assessed with direction, strength, type, nature, basis
[] Influence matrix complete with row/column totals
[] Top influencers and most influenced identified
[] Centrality metrics calculated for all stakeholders
[] Network roles assigned based on centrality thresholds
[] Coalitions detected with stance, strength, leader, vulnerabilities
[] Cross-coalition dynamics mapped
[] Influence pathways with bottlenecks and single points of failure
[] Strategic recommendations cover all 6 categories
[] Every recommendation traces to specific network finding
[] All 4 Mermaid diagrams render valid syntax (per diagram-rendering mixin)
[] Sources listed for major claims (per autonomous-research mixin)
[] Assumptions explicitly labeled (per autonomous-research mixin)
[] No fabricated relationships, politics, or centrality scores
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No project context | Enter interview mode (§7) — "What project or initiative should I analyze influence relationships for?" |
| Context too vague | Enter interview mode (§7) — ask targeted questions |
| Too few stakeholders (< 6) | Report limitation, produce simplified output without full network metrics |
| Stakeholder mapping output malformed | Ask user to verify, attempt partial import |
| No meaningful relationships identifiable | Report limitation, use role-based inference with `[Assumption]` labels |
| Network too sparse for centrality | Calculate available metrics, note limitations |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| Out-of-scope request | "This skill analyzes influence relationships between stakeholders. [Request] is outside scope." |

---

## Quality checks

- [ ] 10-20 stakeholders with meaningful influence relationships mapped
- [ ] Every relationship has direction, strength (1-5), type, nature, and basis
- [ ] Influence matrix is mathematically correct (row/column totals)
- [ ] Centrality metrics are calculated from actual relationship data (not invented)
- [ ] Network roles match centrality threshold criteria
- [ ] Coalitions have 3+ members with shared attitudes and strong mutual influence
- [ ] Coalition vulnerabilities and swing members identified
- [ ] Influence pathways trace complete routes from source to target
- [ ] Bottlenecks and single points of failure identified with mitigation
- [ ] Every recommendation references specific network analysis finding
- [ ] No fabricated relationships, politics, attitudes, or centrality scores
- [ ] All 4 diagrams render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] Sources listed for major claims (per autonomous-research mixin)
- [ ] Assumptions explicitly labeled (per autonomous-research mixin)

---

## Examples

### Normal cases

**1. Digital transformation program**
- Input: "Map influence relationships for our company-wide digital transformation" + stakeholder mapping report
- Expected: IT leadership as hubs, middle management as gatekeepers, department heads forming coalitions (some supportive, some resistant). Influence pathways showing CTO→IT Directors→Team Leads chain. Bottleneck at resistant operations director. Coalition map showing tech-forward vs traditional operations split.

**2. Product launch with cross-functional teams**
- Input: "Analyze influence dynamics for our new product launch across engineering, marketing, and sales"
- Expected: Product manager as broker between engineering and marketing coalitions. Sales VP as gatekeeper for customer feedback. Bridge roles between departments identified. Influence matrix showing marketing→sales as strongest flow.

**3. Regulatory change implementation**
- Input: "Map influence flows for implementing new data privacy regulations"
- Expected: Legal/compliance as formal authority hub, DPO as gatekeeper, IT security with expertise influence. External regulator with formal authority but low daily involvement. Coalition of affected business units. Pathway analysis showing regulator→legal→DPO→business units chain.

**4. Merger integration**
- Input: "Analyze influence dynamics during post-merger integration"
- Expected: Dual power structures (acquiring vs acquired leadership). Bridge roles critical for integration. Coalition detection showing company-of-origin clustering. Recommendations for cross-company bridge activation. Single points of failure at integration leads.

**5. Agile transformation**
- Input: "Map who influences whom in our shift from waterfall to agile"
- Expected: Agile coaches as brokers, resistant senior PMs as potential blockers with high betweenness, enthusiastic developers forming supportive coalition. Scrum masters as bridges between management and teams. Pathway from leadership through coaches to teams with PM bottleneck.

### Edge cases

**6. Very small team**
- Input: "Map influence in our 6-person startup"
- Expected: Simplified analysis with 6 stakeholders, all-to-all relationships feasible, likely flat structure with founder as hub. Notes that formal network analysis metrics are less meaningful at this scale. No coalition detection (too few for meaningful clusters).

**7. With stakeholder mapping input**
- Input: [stakeholder mapping report path] + "Now map the influence relationships"
- Expected: Imports all stakeholders and attributes from the mapping, skips identification. Focuses on relationship assessment and network analysis. References stakeholder mapping Power/Interest quadrants in analysis. Acknowledges imported data provenance.

**8. External-heavy network**
- Input: "Map influence relationships for our government lobbying effort"
- Expected: Heavy external focus — politicians, regulators, industry associations, media, lobbyists. Formal authority vs informal influence contrast. Coalition dynamics between industry allies and opposition groups. Pathway analysis showing indirect influence routes through media and associations.

### Failure cases

**9. No context**
- Input: "Map influence"
- Expected: Interview mode (§7) — "What project or initiative should I analyze influence relationships for? Understanding the context helps identify relevant stakeholders and their dynamics."

**10. Out of scope**
- Input: "Create a RACI matrix for our project"
- Expected: "This skill analyzes influence relationships between stakeholders. RACI matrix creation is outside scope — use `raci-matrix`."
