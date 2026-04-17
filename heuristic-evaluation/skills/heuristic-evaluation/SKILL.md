---
name: heuristic-evaluation
description: Evaluate a UI against Nielsen's 10 usability heuristics (or alternate heuristic sets). Per finding: location, heuristic violated, Nielsen severity (0-4), evidence, impact, and concrete recommendation. Supports single-evaluator autonomous mode and multi-evaluator aggregation.
argument-hint: "[UI description / wireframe / product surface to evaluate]"
---

# Heuristic Evaluation

You evaluate a UI against a declared heuristic set (Nielsen's 10 by default). Produce findings with severity, evidence, impact, and concrete recommendations. Works from text descriptions, wireframes, screenshots described in text, or structured UI specs. Does not analyze images directly.

## Core rules

- **Declared heuristic set**: which heuristics are applied; user may swap for context-specific sets
- **Every finding cites location**: screen / element / region — not "somewhere on the page"
- **Nielsen severity scale**: 0–4 (cosmetic → catastrophic) — apply strictly, don't inflate
- **Evidence-based**: finding must point to what triggered it in the description
- **Concrete recommendation**: not "improve usability" but "add inline error message on field X with text pattern Y"
- **No fabricated issues**: if description insufficient, say `Insufficient-detail` — do not invent
- **No blame language**: "the design violates X" not "the designer missed X"

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Subject** (UI / wireframe / product surface) | Yes | — |
| **Description / spec** | Yes (or image described in text) | — |
| **Heuristic set** | No | Nielsen's 10 |
| **Mode** | No | `single-evaluator` |
| **Context** (user segment, platform) | No | Elicit |

## Phase 1 — Setup

```
**Subject**: [name]
**Description source**: [text / wireframe / structured spec / aggregated evaluator outputs]
**Heuristic set**: [Nielsen 10 / Norman / Shneiderman / mobile / accessibility / custom]
**Mode**: [single-evaluator / multi-evaluator-aggregation]
**Context**: [user segment + platform + task scope]
```

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/heuristic-evaluation/`).

## Phase 2 — Heuristic set selection

### Nielsen's 10 (default)

| # | Heuristic | Rule |
|---|---|---|
| H1 | Visibility of system status | System always informs users about what is going on, through appropriate feedback within reasonable time |
| H2 | Match between system and real world | Speak the users' language; follow real-world conventions, information in natural / logical order |
| H3 | User control and freedom | Support undo / redo; clearly-marked emergency exits to leave unwanted states |
| H4 | Consistency and standards | Same words, situations, actions mean the same thing; follow platform conventions |
| H5 | Error prevention | Better than good error messages; design prevents problems from occurring |
| H6 | Recognition rather than recall | Minimize memory load; objects, actions, options should be visible |
| H7 | Flexibility and efficiency of use | Accelerators (shortcuts, macros) for expert users; allow users to tailor frequent actions |
| H8 | Aesthetic and minimalist design | Dialogues should not contain information which is irrelevant or rarely needed |
| H9 | Help users recognize, diagnose, and recover from errors | Error messages in plain language; indicate problem; suggest solution |
| H10 | Help and documentation | Help and documentation should be easy to search; task-oriented; list concrete steps |

### Alternate sets

- **Norman's (7 stages of action)**: visibility, mapping, feedback, affordances, constraints, consistency, forgiveness
- **Shneiderman's 8 golden rules**: strive for consistency, enable frequent users to use shortcuts, offer informative feedback, design dialog to yield closure, offer simple error handling, permit easy reversal of actions, support internal locus of control, reduce short-term memory load
- **Mobile heuristics** (extend Nielsen): thumb-reachability, gesture discoverability, interruption tolerance, offline grace
- **Accessibility heuristics** (WCAG-derived): perceivable, operable, understandable, robust — cross-check with `accessibility-requirements`
- **Conversational UI heuristics**: clarity of agent capability, error recovery in dialog, context retention, handoff to human

User may select / combine / extend.

## Phase 3 — Per-heuristic review

For each heuristic in selected set, evaluate the UI. For each violation found:

| Field | Description |
|---|---|
| **Finding ID** | `F-01`, `F-02`, ... |
| **Heuristic violated** | e.g., H2 |
| **Location** | Screen / region / element — specific |
| **Observation** | What in the description triggers the finding |
| **Severity** | Nielsen 0–4 |
| **Impact** | What user experience problem results |
| **Evidence** | Quote or reference to specific description point |
| **Recommendation** | Concrete action |
| **Effort** | Small / Medium / Large |

If no issue for a heuristic: note "No issue found — [brief rationale]." Don't invent issues.

## Phase 4 — Nielsen severity scale

| Rating | Label | Definition |
|---|---|---|
| 0 | Not a problem | Intent clearly not violated |
| 1 | Cosmetic | Need not be fixed unless extra time available |
| 2 | Minor | Fixing should be given low priority |
| 3 | Major | Important to fix; should be given high priority |
| 4 | Catastrophic | Imperative to fix before release |

Rules:
- Don't inflate — 4 is reserved for blocking / safety / compliance-critical issues
- Don't deflate — if it blocks a primary task, it's ≥3
- Same input = same rating (determinism)

## Phase 5 — Multi-evaluator aggregation (optional)

If mode = `multi-evaluator-aggregation`, user supplies findings from multiple evaluators (typical 3–5). Aggregate:

1. **Deduplicate** findings that describe the same issue
2. **Reconcile severity** via mode: median / max / consensus
3. **Coverage score**: % of heuristics where ≥ 2 evaluators found same issue
4. **Confidence**: findings confirmed by multiple evaluators have higher confidence
5. **Unique findings**: findings from only 1 evaluator — kept separately, marked `unique to [evaluator ID]`

Benefits of multi-evaluator: single evaluator typically finds 30–50% of issues; 5 evaluators find ~75% (Nielsen's rule of thumb).

## Phase 6 — Prioritization

Rank findings for action. Sort by:
1. Severity (descending)
2. Effort (ascending — quick wins first within same severity)
3. Heuristic importance (weighted if user specifies)

Produce:
- **Top 10 findings** to address first
- **Quick wins**: severity ≥ 3 AND effort = small
- **Strategic**: severity = 4 AND effort = large
- **Parking lot**: severity ≤ 1

## Phase 7 — Summary view

Heuristic coverage:

| Heuristic | # findings | Worst severity |
|---|---|---|
| H1 | 3 | 3 |
| H2 | 0 | — |
| ... | ... | ... |

Flag: heuristics with 0 findings may be (a) well-satisfied OR (b) not enough evidence in description to evaluate. Note which.

## Phase 8 — Diagrams

### 1. Severity distribution

```mermaid
pie title Findings by severity
    "Catastrophic (4)" : 2
    "Major (3)" : 7
    "Minor (2)" : 10
    "Cosmetic (1)" : 4
    "Not a problem (0)" : 1
```

### 2. Findings per heuristic

```mermaid
xychart-beta
    title "Findings by heuristic"
    x-axis ["H1", "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9", "H10"]
    y-axis "Count" 0 --> 10
    bar [3, 1, 2, 5, 4, 2, 1, 3, 3, 0]
```

### 3. Impact vs effort (priority matrix)

```mermaid
quadrantChart
    title Findings — Severity vs Effort
    x-axis Low Effort --> High Effort
    y-axis Low Severity --> High Severity
    quadrant-1 "Quick wins"
    quadrant-2 "Strategic"
    quadrant-3 "Parking lot"
    quadrant-4 "Invest"
    F-01: [0.2, 0.8]
    F-02: [0.3, 0.6]
```

## Phase 9 — Diagram rendering

Per `diagram-rendering` mixin. File names:
- `severity-distribution.mmd` / `.png`
- `findings-by-heuristic.mmd` / `.png`
- `priority-matrix.mmd` / `.png`

## Phase 10 — Report assembly and approval

```markdown
# Heuristic Evaluation: [Subject]

**Date**: [date]
**Heuristic set**: [Nielsen 10 / ...]
**Mode**: [single-evaluator / multi-evaluator-aggregation]
**Context**: [user segment + platform + task]
**Evaluators**: [count if multi]

## Scope
[Subject, description source, heuristic set, mode, context]

## Heuristic Set
[Table of heuristics applied]

## Findings
[Full table per finding: ID, heuristic, location, observation, severity, impact, evidence, recommendation, effort]

## Summary by Heuristic
[Coverage matrix]

## Severity Distribution
[Diagram + counts]

## Prioritization
[Top 10 + Quick wins + Strategic + Parking lot]

## Multi-evaluator Aggregation (if applicable)
[Deduplication + reconciliation + confidence per finding]

## Diagrams
[Severity distribution + findings-by-heuristic + priority matrix]

## Limitations
[Description gaps, `Insufficient-detail` items, single-evaluator blindspots]
```

Present for user approval. Save only after confirmation.

## Assessment + extraction rules

- Per-heuristic verdict: violated / no-issue / insufficient-detail
- Severity from controlled scale, not invented
- Every finding cites location + evidence
- Recommendations concrete and actionable
- Deterministic

## Failure behavior

| Situation | Behavior |
|---|---|
| No description | Interview mode (§7) |
| Description too sparse | Per heuristic: `Insufficient-detail` + what's needed |
| Image input requested | Decline — text description only |
| User wants heuristic set not covered | Accept custom set via user-supplied rules |
| Multi-evaluator with conflicting severities | Surface conflict, use declared reconciliation mode |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope (e.g., "fix the issues") | "Evaluation only; fixing is implementation." |

## Self-check

```
[] Heuristic set declared
[] Every heuristic addressed (violation / no-issue / insufficient-detail)
[] Every finding has ID, location, severity, evidence, recommendation, effort
[] Severity from Nielsen 0–4 scale, not inflated
[] Recommendations concrete
[] Summary by heuristic with coverage matrix
[] Prioritization (top 10 + quick wins + strategic + parking lot)
[] Multi-evaluator reconciliation if applicable
[] Diagrams valid
[] No fabricated findings
[] Report follows output contract
```
