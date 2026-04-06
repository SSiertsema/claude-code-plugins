# RACI Matrix — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | raci-matrix |
| **Version** | 1.0.0 |
| **Purpose** | Creates and validates RACI matrices (Responsibility Assignment Matrices) that assign responsibilities to tasks/deliverables across roles. Supports 6 variants (RACI, RASCI, RACI-VS, RACIO, DACI, RAPID). Validates against hard rules and 15 anti-patterns, produces workload analysis, decision clarity scoring (0-100 per task), governance health assessment (0-100 composite), and communication plan skeleton derived from C/I assignments. Can import roles from stakeholder-mapping output and tasks from WBS. Generates Mermaid diagrams with optional PNG export. |
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

- User needs to assign responsibilities for project tasks or deliverables
- User wants a RACI (or variant) matrix for governance clarity
- User needs workload analysis and accountability distribution review
- User wants anti-pattern detection for an existing responsibility matrix
- User needs to derive a communication plan skeleton from responsibility assignments
- User is starting a project and needs to clarify who does what

## When not to use

- Stakeholder identification and classification — use `stakeholder-mapping`
- Influence network analysis — use `influence-diagramming`
- Project scheduling / Gantt charts — out of scope
- User persona creation — use `persona-management`
- Organizational chart creation — not a strategy skill
- Communication plan only (without responsibility assignment) — use `stakeholder-mapping`

---

## Required input

| Field | Description |
|---|---|
| **Project/initiative context** | What the project or initiative is about — sufficient to identify roles and tasks |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Stakeholder mapping output** | Existing stakeholder register or mapping report (file path or pasted) | None (will identify roles itself) |
| **Task list / WBS** | Predefined tasks, deliverables, or decisions | None (will identify tasks) |
| **Variant** | RACI, RASCI, RACI-VS, RACIO, DACI, RAPID | RACI (will recommend if another fits better) |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/raci-matrix/` |

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
      description: "Existing stakeholder mapping report to import roles from"
    task_list:
      type: string | file_path
      description: "Existing task list or WBS to import tasks from"
    variant:
      type: string
      enum: [raci, rasci, raci_vs, racio, daci, rapid]
      default: raci
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
| **What may be invented** | Task names for common project activities, role titles for typical project structures, example responsibility patterns based on industry norms |
| **What must be grounded** | RACI definitions, variant definitions, anti-pattern rules, validation criteria, scoring formulas |
| **What assumptions are allowed** | Role authority levels based on typical organizational patterns, task granularity based on project type, governance structures based on industry norms |
| **What must never be fabricated** | Specific people's actual responsibilities, real organizational decisions, governance outcomes, validation scores without matrix data |

---

## Processing rules

### Phase 1 — Setup
1. Parse input, detect project context
2. If insufficient → interview mode (§7): gather project context at minimum
3. Check for stakeholder mapping output and/or task list
4. Recommend variant based on context (regulated → RACI-VS, support-heavy → RASCI, decision-focused → DACI/RAPID)
5. Confirm variant, scope with user
6. Ask diagram render mode (per diagram-rendering mixin)
7. Ask output path (default: `/documentation/[case]/raci-matrix/`)

### Phase 2 — Research
8. WebSearch/WebFetch (per autonomous-research mixin) for typical role structures
9. Research common task breakdowns for similar initiatives
10. Research governance best practices and RACI patterns for the domain

### Phase 3 — Role Identification (Columns)
11. If stakeholder mapping provided: import roles, map Power/Interest to likely RACI codes
12. If not: identify 5-15 roles with title, description, authority level
13. Present role list for user confirmation

### Phase 4 — Task/Deliverable Identification (Rows)
14. If WBS/task list provided: import and organize by phase
15. If not: identify 15-40 tasks/deliverables/decisions organized by phase
16. Present task list for user confirmation

### Phase 5 — RACI Assignment
17. Assign codes per task × role, enforcing hard rules:
    - Exactly 1 A per row
    - At least 1 R per row
    - One code per cell (or blank)
18. Apply soft rules: 1-2 R, max 2-3 C, separate R and A where possible

### Phase 6 — Horizontal Validation
19. Check every row: A count, R count, C count, I count
20. Flag hard rule violations as Critical, soft rule violations as Warning

### Phase 7 — Vertical Validation
21. Check every column: assignment counts, % tasks involved
22. Flag bottlenecks (A > 40%), overloads (R > 50%), consultation bottlenecks (C > 60%)

### Phase 8 — Anti-Pattern Detection
23. Scan all 15 anti-patterns
24. For each detected: describe issue, identify affected tasks/roles, suggest fix

### Phase 9 — Workload & Governance Analysis
25. Per-role assignment counts (R/A/C/I breakdown)
26. Decision clarity score per task (0-100)
27. Governance health score (0-100 composite)
28. Communication plan skeleton from C and I assignments

### Phase 10 — Diagrams
29. Generate 3 Mermaid diagrams:
    1. Workload Distribution Chart (xychart-beta) — R/A/C/I counts per role
    2. Governance Health Dashboard (xychart-beta) — clarity score by task group
    3. Responsibility Network (flowchart) — roles↔tasks with RACI labels (skip if matrix > 20×10)
30. Render per diagram-rendering mixin

### Phase 11 — Report Assembly
31. Assemble complete report with all sections
32. Present for user approval, save after confirmation

---

## Output contract

```markdown
# RACI Matrix: [Project/Initiative]

**Date**: [date]
**Project**: [name]
**Variant**: [RACI/RASCI/RACI-VS/RACIO/DACI/RAPID]
**Tasks**: [count]
**Roles**: [count]
**Governance health score**: [0-100] — [rating]

## Executive Summary
[Key findings: governance health, critical gaps, overloaded roles, top recommendations]

## Roles Directory
[Table: Role, Description, Authority level, Source]

## RACI Matrix
[Core matrix table]

## Horizontal Validation
[Per-task: A count, R count, C count, I count, issues, severity]

## Vertical Validation
[Per-role: R/A/C/I counts, % involved, workload assessment]

## Anti-Pattern Report
[Detected patterns: pattern, severity, affected tasks/roles, fix]

## Workload Distribution
[Per-role summary + workload chart]

## Decision Clarity Analysis
[Per-task clarity score + governance health chart]

## Communication Plan Skeleton
[C/I derived: role, consulted on, informed about, suggested method]

## Responsibility Network
[Network diagram (if matrix size allows)]

## Recommendations
[Prioritized actions traced to specific findings]

## Sources
[Numbered list of web sources]

## Assumptions & Limitations
[Explicit list]
```

### Diagrams

| # | Diagram | Mermaid type | Content |
|---|---|---|---|
| 1 | Workload Distribution | xychart-beta | R/A/C/I assignment counts per role |
| 2 | Governance Health | xychart-beta | Decision clarity score by task group/phase |
| 3 | Responsibility Network | flowchart | Roles↔tasks with RACI edge labels (≤20×10 only) |

Rendering per diagram-rendering mixin.

---

## Self-check

### Must verify before output
```
[] 15-40 tasks identified and organized by phase (8+ for small scope)
[] 5-15 roles identified with descriptions and authority levels
[] Every row has exactly 1 A (hard rule — zero exceptions)
[] Every row has at least 1 R (hard rule — zero exceptions)
[] One code per cell maximum
[] All 15 anti-patterns scanned
[] Horizontal validation complete for every row
[] Vertical validation complete for every column
[] Workload distribution calculated per role
[] Decision clarity scored per task (0-100)
[] Governance health score calculated (0-100)
[] Communication plan skeleton derived from C and I
[] Recommendations traced to specific findings
[] Matrix counts are mathematically consistent
[] All Mermaid diagrams render valid syntax (per diagram-rendering mixin)
[] Sources listed for claims (per autonomous-research mixin)
[] Assumptions labeled (per autonomous-research mixin)
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No project context | Enter interview mode (§7) — "What project or initiative should I create a RACI matrix for?" |
| Context too vague | Enter interview mode (§7) — ask targeted questions |
| Too few tasks identifiable | Report limitation, produce smaller matrix (minimum 8 tasks) |
| Too few roles identifiable | Report limitation, work with available (minimum 3 roles) |
| Stakeholder mapping malformed | Ask user to verify, attempt partial import |
| Variant not applicable | Recommend appropriate variant, confirm with user |
| Hard rule violation in own output | Auto-correct before presenting; if conflict, present options |
| Existing matrix has unfixable issues | Report as Critical, present alternatives |
| Diagram rendering fails | Per diagram-rendering mixin |
| Web research insufficient | Per autonomous-research mixin |
| Out-of-scope request | "This skill creates and validates RACI matrices. [Request] is outside scope." |

---

## Quality checks

- [ ] 15-40 tasks organized by project phase or logical category
- [ ] 5-15 roles with descriptions and authority levels
- [ ] Every row has exactly 1 A (zero exceptions)
- [ ] Every row has at least 1 R (zero exceptions)
- [ ] Variant codes are used correctly (no mixing RACI codes with DACI codes)
- [ ] All 15 anti-patterns checked and reported
- [ ] Horizontal and vertical validation counts match the matrix
- [ ] Decision clarity scores calculated from actual matrix data
- [ ] Governance health score is composite of validation results
- [ ] Communication plan skeleton maps to actual C/I assignments
- [ ] Recommendations are concrete and traced to specific findings
- [ ] No fabricated responsibilities or governance outcomes
- [ ] All diagrams render valid Mermaid syntax (per diagram-rendering mixin)
- [ ] Sources listed for all major claims (per autonomous-research mixin)
- [ ] Assumptions explicitly labeled (per autonomous-research mixin)

---

## Examples

### Normal cases

**1. Software development project**
- Input: "Create a RACI matrix for our new mobile app development project"
- Expected: Tasks by phase (planning, design, development, testing, deployment, launch). Roles: Product Owner, Tech Lead, Dev Team, QA Lead, UX Designer, Project Manager, Stakeholders. Standard RACI variant. Governance health score with workload analysis.

**2. With stakeholder mapping input**
- Input: [stakeholder mapping report] + "Create a RACI for the same initiative"
- Expected: Imports roles from stakeholder mapping, maps Power/Interest quadrant to likely RACI assignments. Identifies tasks independently. Cross-references stakeholder attributes with responsibility assignments.

**3. Regulatory compliance project**
- Input: "We need a RACI matrix for our SOX compliance program"
- Expected: Recommends RACI-VS (adds Verifier and Signatory for audit trail). Tasks: control testing, evidence collection, remediation, reporting, external audit support. Roles: Internal Audit, Control Owners, External Auditors, Compliance Officer, CFO.

**4. Strategic decision framework**
- Input: "We need a decision rights framework for our product roadmap decisions"
- Expected: Recommends DACI or RAPID (decision-centric). Rows are decisions: feature prioritization, pricing, partnerships, go/no-go, resource allocation. Columns: CPO, Product Directors, Engineering Lead, Sales VP, Customer Success.

**5. IT service management**
- Input: "Create a RACI for our incident management process"
- Expected: RACI aligned with ITIL framework. Tasks: detection, classification, escalation, investigation, resolution, communication, post-mortem. Roles: Service Desk, L2 Support, L3 Engineering, Incident Manager, Problem Manager, Change Manager.

### Edge cases

**6. Very small project**
- Input: "RACI for a 3-person team building a landing page"
- Expected: Simplified matrix (8-12 tasks, 3 roles). Notes that some soft rules (like R≠A) may not apply at this scale. Lighter validation. Governance health score adjusted for team size context.

**7. Existing matrix for review**
- Input: "Here's our current RACI matrix [pasted]. Review it for issues."
- Expected: Imports the matrix, runs full validation (horizontal, vertical, anti-patterns). Produces report focused on findings and recommendations, not matrix creation. Governance health score based on imported data.

**8. Cross-organizational initiative**
- Input: "RACI for a joint venture between our company and a partner"
- Expected: Dual organizational structure reflected in roles (clearly labeled by organization). Extra attention to A assignments across organizational boundaries. Recommendations for governance committee structure. Notes about cross-org accountability challenges.

### Failure cases

**9. No context**
- Input: "Create a RACI"
- Expected: Interview mode (§7) — "What project or initiative should I create a RACI matrix for? Understanding the context helps me identify the right roles, tasks, and variant."

**10. Out of scope**
- Input: "Create a project schedule with Gantt chart"
- Expected: "This skill creates and validates RACI matrices for responsibility assignment. Project scheduling and Gantt charts are outside scope."
