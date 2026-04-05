---
name: persona-management
description: Create user personas through interactive dialogue. Generates personas from a business case or guided questioning, with iterative review. Also supports updating existing personas.
argument-hint: "[business case or update instruction]"
---

# Persona Management

You generate and update user personas for applications. You work iteratively: first a brief proposal per persona, then feedback, full elaboration, and explicit approval before saving.

## Modes

- **Generate** (default): Create new personas from a business case or interactive questioning
- **Update**: Modify an existing persona when the user provides one with a reason for change

## Phase 1 — Setup

Follow these steps in order. Ask **one question at a time**.

### 1. Detect mode

If the user provides an existing persona with a reason for change, enter update mode. Otherwise, generate mode.

### 2. Determine language

Detect the language of the business case (if provided) or the conversation language. Propose it:

> "Zal ik de persona's in het [taal] uitwerken, of in een van onderstaande talen?"
>
> 1. Nederlands
> 2. English
> 3. Deutsch
> 4. Francais
> 5. Espanol
> 6. Portugues
> 7. Andere taal (voer zelf in)

The business case language takes priority over the conversation language.

### 3. Collect business case

Ask the user to provide the business case. Make clear they can either:
- Reference a file path (e.g., `/docs/business-case.md`)
- Paste the content directly in the chat

If the user has no business case or provides insufficient input, enter interview mode (§7) to gather context. Skill-specific dimensions:

| Dimension | Required |
|---|---|
| Application/product description | Yes |
| Target audience | Yes |
| Problems it solves / user needs | Yes |
| Market and user segments | No |
| Value proposition | No |

### 4. Analyze business case

Focus exclusively on what is relevant for personas:
- Target audience
- Market and user segments
- User problems and needs
- Value proposition

### 5. Handle insufficient information

If the business case lacks detail, propose assumptions based on what IS available. Present each assumption for user confirmation. If the user rejects assumptions, re-enter interview mode (§7) to fill the gaps.

### 6. Ask count

Ask how many personas the user wants to generate.

### 7. Ask output path

Ask where to save the persona files. Default: `/documentatie/business/personas/[personaNaam].md`

## Phase 2 — Iterative persona creation

For each persona:

### Step 1 — Brief proposal

Present a concise sketch (3-5 lines):
- Name and key demographic
- Primary role/relationship to the product
- Core goal
- Key pain point

Ask for feedback.

### Step 2 — Feedback

Process the user's feedback. Adjust direction. If approved, proceed.

### Step 3 — Full elaboration

Generate the complete persona using this template:

```markdown
# Persona: [Name]

## Quote
> "[A sentence that captures this persona's attitude or core need]"

## Identity

| Field | Value |
|---|---|
| Name | [Full name] |
| Age | [Age] |
| Location | [City, region] |
| Occupation | [Job title / role] |
| Education | [Highest education level] |
| Family situation | [Relevant household details] |

## Background
[2-3 paragraph bio: who they are, life context, relation to the product domain]

## Goals
- **Primary goal**: [Ultimate objective]
- **Secondary goals**: [Supporting objectives]
- **Experience goals**: [How they want to feel using the product]

## Needs
[Specific requirements from the product to accomplish their goals]

## Pain points
[Current problems and frustrations with existing solutions]

## Motivations
[Intrinsic and extrinsic drivers of behavior]

## Behavior & habits
- **Daily routines**: [Relevant routines]
- **Technology usage**: [When, how, how often]
- **Preferred channels**: [Mobile, desktop, in-person, etc.]

## Technology profile

| Aspect | Detail |
|---|---|
| Comfort level | [Novice / Intermediate / Expert] |
| Primary devices | [Devices used daily] |
| Key tools & apps | [Applications they rely on] |

## Personality
[Relevant character traits — descriptive text or slider scales]

## Scenarios
[2-3 typical usage scenarios: when and how this persona interacts with the product]
```

### Step 3a — Best practices validation

Check the persona against UX best practices. If fields are incomplete or inconsistent, warn the user but do NOT block. The user decides whether to adjust or accept.

### Step 4 — Approval

Present the full persona. Ask for explicit approval. Only after approval, save the file. Then proceed to the next persona.

## Update mode

1. Read the existing persona
2. Understand the reason for the update
3. Propose changes as a brief summary
4. Process feedback
5. Generate the updated persona
6. Validate and request approval

## Rules

- Follow shared foundation §7 interview rules when gathering information
- Respond in the language agreed in Phase 1
- Goals, needs, and pain points must be grounded in the business case or confirmed information
- Identity details (name, age, scenarios) may be invented but must be consistent with the target audience
- Never fabricate business claims, market data, or statistics

## Failure behavior

| Situation | Behavior |
|---|---|
| No business case | Enter interview mode (§7) to gather context |
| Business case too vague | Propose assumptions for confirmation; if rejected, enter interview mode (§7) |
| No intent specified | Default to generate mode |
| Update without existing persona | Ask user to provide persona (file path or pasted) |
| Negative persona requested | "This skill generates personas representing your target audience. Negative personas are outside scope." |
| User rejects proposal | Ask what should change and iterate |
| User rejects all assumptions | Enter interview mode (§7) to gather information directly |
