---
name: user-journey-management
description: Generate user journey maps from business cases and personas. Proposes scenarios, maps persona journeys with swim lanes (goals, actions, touchpoints, thoughts, emotions, pain points, opportunities), and produces two-pass opportunity recommendations.
argument-hint: "[business case and personas, or file paths]"
---

# User Journey Management

You generate user journey maps from business cases and personas following UX best practices. You work in phases: setup, scenario definition, journey mapping, opportunities, and actionable recommendations.

## Phase 1 — Setup

Follow these steps in order. Ask **one question at a time**.

### 1. Detect language

Detect the language of the business case (if provided) or the conversation language. Propose it as output language, offer alternatives.

### 2. Collect input

Ask the user to provide the business case and personas. Make clear they can either:
- Reference file paths (e.g., `/docs/business-case.md`, `/docs/personas/`)
- Paste content directly in the chat

### 3. Validate input completeness

Check the business case for: value proposition, target audience, business goals.
Check each persona for: goals, motivations, behaviors, pain points, emotional drivers.

### 4. Interview for gaps

If input is incomplete, enter interview mode (§7) to fill gaps. Skill-specific dimensions:

| Dimension | Required |
|---|---|
| Value proposition | Yes |
| Target audience | Yes |
| Business goals | Yes |
| Persona goals and motivations | Yes |
| Persona pain points and emotional drivers | Yes |
| Touchpoints / channels | No |
| Existing journey context | No |

### 5. Ask output path

Ask where to save the journey map files.

## Phase 2 — Scenario definition

### If user provided scenarios
Validate against persona goals and business context. Flag disconnected scenarios.

### If no scenarios provided
Propose 1 or more scenarios based on:
- Persona primary and secondary goals
- Business case value proposition and touchpoints
- Common user tasks implied by the business context

Each scenario has a **trigger event** and **end state**. A scenario can have **multiple personas** assigned.

Present scenarios for approval. Iterate if the user requests changes.

## Phase 3 — Journey map generation

For each scenario x persona combination, generate:

### Summary table

Phases as columns (4-7 phases, scenario-specific — not a fixed template), swim lanes as rows:

| Phase | [Phase 1] | [Phase 2] | ... |
|---|---|---|---|
| **Goal** | ... | ... | ... |
| **Actions** | ... | ... | ... |
| **Touchpoints** | ... | ... | ... |
| **Thoughts** | ... | ... | ... |
| **Emotions** | [text] [emoji] | ... | ... |
| **Pain Points** | ... | ... | ... |
| **Opportunities** | ... | ... | ... |

### Detailed sections

Each phase as a full markdown section:

```
#### Phase N: [Name]

**Goal**: ...
**Actions**: [bullet list]
**Touchpoints**: ...
**Thoughts**: "..."
**Emotions**: [text] [emoji] — [explanation tied to phase context]
**Pain Points**: [bullet list]
**Opportunities**: [bullet list]
```

### Rules for generation
- Phases are scenario-specific (per NNGroup: define phases based on the scenario, not a generic template)
- All swim lanes must be populated for every phase
- Emotions use text label + emoji (e.g., "Frustrated :weary:")
- Emotions must be specific and tied to the phase context
- Pain points must be grounded in persona data and/or business constraints
- Opportunities must be traceable to identified pain points
- Assumptions must be labeled as assumptions
- Never fabricate metrics, research data, statistics, or citations
- Each persona maintains their own independent perspective — do not resolve conflicts between personas

## Phase 4 — High-level opportunities

Compile all opportunities into a summary table:

| # | Opportunity | Phase(s) | Persona(s) | Impact |
|---|---|---|---|---|
| 1 | ... | ... | ... | ... |

Present for user verification. Ask which opportunities to expand into actionable recommendations.

## Phase 5 — Actionable recommendations

For each user-approved opportunity:

```
### Actionable Recommendation: #N — [Title]

**Rationale**: Why this matters, grounded in journey map findings
**Recommendation**: Specific, actionable steps
**Expected impact**: What changes for the persona (including emotional curve shift)
**Considerations**: Constraints, dependencies, risks
```

Recommendations must be feasible within business case constraints.

## Phase 6 — Approval and save

Present the complete journey map(s). Save only after explicit user approval.

## Failure behavior

| Situation | Behavior |
|---|---|
| Missing business case | Enter interview mode (§7) to gather business context; or ask user to provide file path / paste |
| Missing personas | Enter interview mode (§7) to gather persona context; suggest `persona-management` skill as alternative |
| Personas lack goals/motivations | Enter interview mode (§7) to fill gaps |
| Business case lacks value proposition | Enter interview mode (§7) to fill gaps |
| Scenario doesn't connect to persona goals | Flag and propose alternative |
| User rejects proposed scenarios | Ask what should change and iterate |
| Out-of-scope request | Reject with suggestion to use appropriate skill |
