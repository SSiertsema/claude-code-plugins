---
name: hmw-framing
description: Transform a problem statement, pain point, insight, or research finding into "How might we..." (HMW) questions for ideation. Deconstructs the input, applies multiple HMW lenses, produces 3-6 variants with scope and wording quality checks, recommends a best variant, and optionally breaks down broad HMWs into sub-HMWs. Mermaid diagram with optional PNG export.
argument-hint: "[problem statement, pain point, or insight]"
---

# HMW Framing

You reframe a supplied problem, pain point, insight, or research finding as one or more "How might we..." questions suitable for ideation. You preserve the core problem (actors, need, context, constraint) while transforming form (statement → question) and framing (pain → opportunity).

## Core rules

- **Preserve the source** — every HMW traces back to the supplied problem; do not drift into a different problem
- **Solution-neutral** — HMWs describe the opportunity, never the solution
- **Positive framing** — "How might we make onboarding faster" ≠ "How might we avoid slow onboarding"
- **Just-right scope** — narrow enough to ideate against, broad enough for multiple solution directions
- **Distinct lenses** — every variant applies a different lens; no two variants should be rephrasings of each other
- **No fabrication** — do not invent users, data, quotes, competitor moves, or research findings not in the input

## Input handling

Follow shared foundation §7 — interview mode. Gather at minimum:

| Dimension | Required | Default |
|---|---|---|
| **Problem / insight** | Yes | — |
| **Mode** (`single` / `variants` / `breakdown`) | No | `variants` |
| **Audience (who is "we")** | No | Inferred |
| **Context / domain** | No | Inferred from problem |
| **Known constraints** | No | None |
| **Lens preferences** (include / exclude) | No | Auto-select 3–8 |
| **Target HMW count** | No | 5 |

**Exit interview when**: the problem is specific enough that actors + need + context can be extracted.

## Phase 1 — Setup

### 1. Collect input

Accept:
- A problem statement, pain point, user quote, or research finding
- A reference to an `affinity-diagramming` insight or cluster
- A business case pain point
- No / vague input → interview mode (§7)

### 2. Detect scope

- **Problem text**: verbatim capture
- **Mode**: `single` (one HMW), `variants` (3–6, default), `breakdown` (break a broad HMW into sub-HMWs)
- **Audience**: who is "we"? (team, product, org, service)
- **Context**: domain, user situation, moment
- **Constraints**: what must remain true in any solution?
- **Lens preferences**: user can force-include or exclude specific lenses

### 3. Confirm scope

Present:

```
**Source problem**: [verbatim]
**Mode**: [single / variants / breakdown]
**Audience ("we")**: [team / org / product]
**Context**: [domain + situation]
**Constraints**: [list or "none specified"]
**Lens set**: [selected or default auto]
**Target HMW count**: [N]
```

Ask for confirmation and adjustments. Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/hmw-framing/`).

## Phase 2 — Deconstruction

Extract structured elements from the source problem:

| Element | Question | Example |
|---|---|---|
| **Actors ("we")** | Who takes action? | The product team |
| **Beneficiary** | Whose life changes? | First-time freelancers |
| **Need** | What's the underlying need? | Log expenses without disrupting their work |
| **Context** | When/where does it apply? | On mobile, in the moment, often hands-full |
| **Emotion** | What does the user feel? | Frustrated, anxious about tax season |
| **Constraint** | What must remain true? | Must work offline; must not require receipts |

State any assumption explicitly with `[Assumed]`. The deconstruction is the preservation anchor — every HMW variant must still align with these elements.

## Phase 3 — Lens selection

Default lens set (select 3–8):

| Lens | What it does | When to use |
|---|---|---|
| **Amp the good** | How might we do more of what works? | Positive pattern in the data |
| **Remove the bad** | How might we eliminate the pain? | Clear pain point |
| **Explore the opposite** | What if the opposite were true? | Stuck on one direction |
| **Question the assumption** | What if X weren't necessary? | Unchallenged default |
| **Find unexpected resources** | Who/what already solves this? | Adjacent domains may hold clues |
| **Create an analogy** | What else is like this? | Need fresh perspective |
| **Go after the adjective** | Change the feeling | Experience/tone matters |
| **Identify unexpected stakeholders** | Whose view would shift this? | Multi-sided problem |
| **Break the status quo** | What if the convention flipped? | Legacy constraints dominate |
| **Change the POV** | What if we were X instead? | Fresh framing needed |
| **Scale up / scale down** | What at 10x? At 1/10? | Scale-dependent dynamics |

User can force-include or exclude lenses. Default auto-selection chooses lenses that best fit the problem type (pain → Remove the bad, Explore the opposite; opportunity → Amp the good; stuck → Question the assumption, Break the status quo; stale → Analogy, Adjective).

## Phase 4 — Variant generation

Per selected lens, produce one HMW variant:

```markdown
### Variant [N]: [Lens name]

**HMW**: How might we [question]?

**Lens rationale**: [why this lens surfaces something useful for this problem]

**What it emphasizes**: [which element of the deconstruction this variant leans on]
```

Rules:
- Every variant starts with "How might we"
- Every variant is solution-neutral
- No two variants are rephrasings of the same idea — force lens-driven differentiation
- Every variant must be traceable to the source deconstruction (no drift)

## Phase 5 — Quality check per variant

Score each variant on two tests:

### Scope test

| Verdict | Signal | Fix |
|---|---|---|
| **Too narrow** | Implies a specific solution already | Remove the solution, re-ask |
| **Just right** | Many solution directions fit | Keep |
| **Too broad** | Any answer works; no focus | Add context / constraint |

### Wording test

- [ ] Starts with "How might we"
- [ ] Positive framing (not "avoid / prevent / reduce")
- [ ] Single focus (not two questions joined)
- [ ] Concrete enough to ideate (no abstract nouns like "success", "growth" alone)
- [ ] Short (≤20 words)

If a variant fails wording checks: show the failing check, propose a wording fix, then show the fixed version. Do not silently repair — transparency matters.

## Phase 6 — Ranking and recommendation

Rank variants on suitability for ideation. Criteria:

| Criterion | 1 | 3 | 5 |
|---|---|---|---|
| **Generativity** | Narrow, few solution directions | Some directions | Wide solution space |
| **Grounded** | Drifts from source | Partially aligned | Fully anchored in deconstruction |
| **Actionability** | Unclear what to ideate against | Workable | Immediately usable by a team |

Composite max 15. Recommend the top variant with a 1–2 sentence rationale. Mention the runner-up if it opens a meaningfully different direction.

## Phase 7 — Optional breakdown

Trigger automatically if:
- Mode = `breakdown`, OR
- Recommended HMW scores "Too broad" on the scope test

Breakdown rules:
- Produce 3–5 narrower sub-HMWs
- Every sub-HMW nests under the parent (solving it contributes to solving the parent)
- Sub-HMWs can apply different lenses within the parent's scope
- Preserve the parent's deconstruction; sub-HMWs may narrow `context` or `beneficiary` but must not change `actors` or `need`

## Phase 8 — Diagram

Mermaid flowchart showing deconstruction → lenses → variants → recommended (and breakdown if produced):

```mermaid
flowchart LR
    P["Problem:<br/>[short summary]"]
    P --> D["Deconstruction<br/>[actor / need / context]"]
    D --> L1["Lens: [name]"]
    D --> L2["Lens: [name]"]
    D --> L3["Lens: [name]"]
    L1 --> V1["HMW 1<br/>[short]"]
    L2 --> V2["HMW 2<br/>[short]"]
    L3 --> V3["HMW 3<br/>[short]"]
    V1 -. "recommended" .-> R(("Next step:<br/>ideate"))
```

If breakdown is produced, add sub-HMWs as children of the recommended HMW.

## Phase 9 — Diagram rendering

Per the `diagram-rendering` mixin. File name: `hmw-tree.mmd` / `.png`.

## Phase 10 — Report assembly and approval

Assemble:

```markdown
# HMW Framing: [short label of problem]

**Date**: [date]
**Mode**: [single / variants / breakdown]
**Source**: [verbatim problem / insight]
**Variants produced**: [N]
**Recommended HMW**: [short form]

## Source Problem
> [verbatim]

## Deconstruction
[Table: actors, beneficiary, need, context, emotion, constraint — with `[Assumed]` where applicable]

## Lenses Applied
[Table: lens + rationale per selected lens]

## HMW Variants
[Per variant: lens, HMW text, rationale, what it emphasizes, scope verdict, wording check, fix if needed]

## Ranking
[Scoring table across variants on generativity / grounded / actionability / composite]

## Recommended HMW
> **[final HMW text]**

[1–2 sentence rationale + mention of runner-up if relevant]

## Breakdown
[If produced — 3–5 narrower sub-HMWs nested under recommended]

## Diagram
[Mermaid flowchart]

## Next Step
Feed the recommended HMW into `brainstorming` for ideation.

## Assumptions & Limitations
[Explicit list with `[Assumed]` items]
```

Present for user approval. Save only after explicit confirmation.

## Transformation + generation rules

**Transformation (primary)**:
- **Must preserve**: actors, beneficiary, underlying need, context, constraints
- **May change**: wording, framing (pain → opportunity), form (statement → question), lens-specific perspective
- **Preservation mode**: `balanced`
- **Evidence**: the deconstruction section documents what was preserved

**Generation (secondary)**:
- **May invent**: lens-specific wordings, variant phrasings, sub-HMW scopings
- **Must be grounded**: source problem anchors every variant
- **Never fabricate**: user quotes, statistics, competitor references, research findings not in the input

## Failure behavior

| Situation | Behavior |
|---|---|
| No problem provided | Interview mode (§7) |
| Input already in HMW form | Acknowledge, offer `variants` (alternatives) or `breakdown` (narrower sub-HMWs) |
| Input is a solution, not a problem | "This looks like a solution. The underlying problem appears to be [X]. Shall I reframe as [X] first?" — confirm before proceeding |
| Input is abstract ("grow the business") | Ask for narrowing; if declined, apply `[Assumed]` narrowing and label clearly |
| Input is very prescriptive ("we need a mobile app") | Extract underlying need, reframe to problem, then HMW |
| Fewer than 2 meaningful lens variations | Produce 2 variants with honest note; do not pad with rephrasings |
| All variants fail scope test | Report, invite user input to tighten/loosen constraints |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope request (e.g., "generate 30 ideas for this HMW") | "This skill produces HMW questions. Use `brainstorming` with the recommended HMW as input for ideation." |

## Self-check

```
[] Source problem preserved verbatim in report
[] Deconstruction covers actors, beneficiary, need, context, emotion, constraint
[] Assumptions labeled `[Assumed]`
[] 3–6 variants (or mode-appropriate count); each on a distinct lens
[] Every variant starts with "How might we"
[] Every variant is solution-neutral
[] Every variant positively framed (not "avoid / prevent")
[] Every variant ≤20 words
[] Scope verdict given per variant (too narrow / just right / too broad)
[] Wording check shown; failing checks include a proposed fix
[] Ranking on generativity / grounded / actionability
[] Recommended HMW clearly stated with rationale
[] Runner-up mentioned if meaningfully different
[] Breakdown produced when mode = breakdown or top HMW scored "too broad"
[] Sub-HMWs nest under parent (preserve actors and need)
[] Mermaid diagram renders valid syntax (per diagram-rendering mixin)
[] No fabricated quotes, users, stats, or competitor references
[] Next-step pointer to `brainstorming` included
[] Report follows output contract
```
