# User Story Template

<!--
TEMPLATE INSTRUCTIONS:
This template defines the structure for individual user stories.
Fill in all sections based on specification analysis.
-->

## {STORY_ID}: {Story Title}

**Epic:** [{Epic Name}](../epics/{epic-slug}.md)
**Feature:** [{Feature Name}](./_index.md)
**Source:** {path/to/source/specification.md}

---

### User Story

> **As a** {persona/role},
> **I want** {goal/action},
> **So that** {benefit/value}.

---

### Description

<!--
Provide additional context about this story.
Include relevant background from the functional specification.
Keep it concise but informative.
-->

{Expanded description providing context beyond the one-liner.}

---

### Acceptance Criteria

<!--
Write in Gherkin (Given/When/Then) format.
Include happy path, edge cases, and error scenarios.
Each criterion should be independently testable.
-->

#### AC1: {Criterion Title - Happy Path}

```gherkin
Given {precondition}
When {action}
Then {expected result}
```

#### AC2: {Criterion Title - Edge Case}

```gherkin
Given {precondition}
When {action}
Then {expected result}
And {additional outcome}
```

#### AC3: {Criterion Title - Error Scenario}

```gherkin
Given {precondition}
When {invalid action or error condition}
Then {error handling behavior}
```

<!--
Add more acceptance criteria as needed.
Each story typically has 3-6 acceptance criteria covering:
- Main success flow (happy path)
- Boundary conditions (edge cases)
- Error handling (what happens when things fail)
- Validation rules (input constraints)
-->

---

### Dependencies

<!--
List stories that must be completed before this one.
-->

| Story ID | Title | Type | Reason |
|----------|-------|------|--------|
| {US-XXX} | {Story Title} | Hard | {Why this must be completed first} |
| {US-YYY} | {Story Title} | Soft | {Why this makes implementation easier} |

**Blocked by:** {Comma-separated list of blocking story IDs, or "None"}
**Blocks:** {Comma-separated list of stories this blocks, or "None"}

---

### INVEST Checklist

<!--
Verification that the story meets INVEST criteria.
-->

| Criterion | Status | Notes |
|-----------|--------|-------|
| **I**ndependent | Yes/No | {Can be developed without other stories in progress} |
| **N**egotiable | Yes/No | {Leaves room for implementation discussion} |
| **V**aluable | Yes/No | {Delivers clear value to the user} |
| **E**stimable | Yes/No | {Team can reasonably estimate effort} |
| **S**mall | Yes/No | {Fits within a single sprint} |
| **T**estable | Yes/No | {Acceptance criteria are verifiable} |

---

### Traceability

**Requirement IDs:** {REQ-001, REQ-002, ...}
**Specification Section:** {Section reference in source document}
