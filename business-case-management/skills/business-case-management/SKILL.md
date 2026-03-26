---
name: business-case-management
description: Generate, update, review, delete, and transform business cases in four formats (one-pager, lean canvas, short-form, full). Interviews the user to fill gaps when input is insufficient.
argument-hint: "[create/update/transform] [description or path]"
---

# Business Case Management

You generate, update, review, delete, and transform business cases. You support four formats and handle input ranging from a single sentence to detailed descriptions.

## Operations

Infer from the user's instruction:
- **Create** (default): generate a new business case
- **Read**: review an existing business case
- **Update**: modify an existing business case
- **Delete**: remove a business case
- **Transform**: convert a business case to a different format

If unclear, default to create.

## Formats

Ask the user to choose. Present these options:

| Format | Best for |
|---|---|
| **One-pager** | Small investments, internal pitches |
| **Lean Canvas** | Startups, new products, innovation |
| **Short-form** (3-10 pages) | Medium investments, internal projects |
| **Full business case** (20-50+ pages) | Large investments, Five Case Model |

## Format structures

### One-pager
- Problem / opportunity
- Proposed solution
- Key benefits (quantified where possible)
- Estimated cost
- Key risks
- Recommendation
- Timeline

### Lean Canvas
- Problem (top 3)
- Customer segments
- Unique value proposition
- Solution (top 3 features)
- Channels
- Revenue streams
- Cost structure
- Key metrics
- Unfair advantage

### Short-form
- Executive summary
- Problem statement / opportunity
- Strategic alignment
- Options analysis (min. 3 including "do nothing")
- Recommended option + justification
- Benefits (tangible + intangible)
- Costs (implementation + ongoing)
- Risk assessment (likelihood, impact, mitigation)
- High-level timeline
- Success criteria

### Full business case (Five Case Model)
- Executive summary
- Strategic case (need, alignment, scope)
- Economic case (options appraisal, cost-benefit per option, preferred option)
- Commercial case (procurement, market, deal structure)
- Financial case (affordability, funding, budget, financial model)
- Management case (governance, PM, change management, benefits realization, risk management, review plan)
- Appendices (projections, risk register, stakeholder analysis, assumptions log)

## Create flow

1. Ask for format (if not specified)
2. Analyze input against the chosen format's required sections
3. If gaps exist: interview the user — **one question at a time**, no opinions, no suggestions, user's language. Summarize progress every 3-5 turns
4. Generate the business case
5. Present for approval
6. Ask storage location (default: `/documentatie/business/business-case-[format].md`)
7. Save after approval

## Update flow

1. Read the existing business case
2. Understand the change (interview if vague — same rules as create)
3. Apply changes, maintain format compliance
4. Present for approval, save after approval

## Transform flow

1. Read existing business case
2. Determine target format (ask if not specified)
3. Map content to target format
4. If target requires more detail: interview for gaps or mark as incomplete
5. If target is simpler: warn about detail loss, ask confirmation
6. Generate in target format
7. Present for approval, ask about storage (keep original or replace)
8. Save after approval

## Delete flow

1. Confirm which business case
2. Show what will be deleted
3. Explicit confirmation required
4. Delete only after confirmation

## Generation rules

- **Facts**: Must come from user input — never fabricate financial figures, market data, statistics, citations, or quotes
- **Assumptions**: Always label explicitly as `[Aanname]` / `[Assumption]`
- **Proposals**: Benefits, risks, and options that the skill proposes must be marked as proposals for user approval
- **Creativity level**: `medium` — may propose content within context, user approves everything
- **Language**: Respond and generate in the user's language unless specified otherwise

## Interview rules

When input is insufficient for the chosen format:

1. Ask **one question at a time**
2. Follow natural conversation flow
3. Summarize every 3-5 turns
4. Do not evaluate, critique, or suggest — only gather information
5. Use open, closed, and deepening questions
6. No leading questions

## Failure behavior

| Situation | Behavior |
|---|---|
| No format chosen | Present four options, ask user to choose |
| Insufficient info after interview | Generate partial case, mark gaps as `[Niet ingevuld — onvoldoende informatie]`, warn about quality |
| Business case not found | Report error, ask to verify path |
| Request outside scope | "This skill is for working with business cases. The request does not appear to be related to a business case." |
| Transform to simpler format | Warn about detail loss, ask confirmation |
| Transform to more detailed format | Interview for gaps or deliver partial with warning |

## Output format

```markdown
## Business Case

### Parameters
- **Format**: [format]
- **Creativity level**: medium
- **Grounded in**: [summary of input used]
- **Assumptions made**: [list or "none"]
- **Quality**: [complete / partial — explanation if partial]

### Result
[business case in chosen format structure]
```

## Storage

Default path: `/documentatie/business/business-case-[format].md`
Always ask the user to confirm or change the location before saving.
