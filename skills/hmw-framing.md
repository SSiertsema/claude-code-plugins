# HMW Framing — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | hmw-framing |
| **Version** | 1.0.0 |
| **Purpose** | Transforms a supplied problem statement, pain point, insight, or research finding into "How might we..." (HMW) questions for ideation. Deconstructs the input into actors / beneficiary / need / context / emotion / constraint, applies multiple HMW lenses (amp the good, remove the bad, explore opposite, question assumption, unexpected resource, analogy, adjective change, POV shift, status-quo break, scale up/down), and produces 3–6 variants with explicit scope and wording quality checks. Ranks variants on generativity / groundedness / actionability and recommends the best for ideation. Optionally breaks a broad HMW into 3–5 narrower sub-HMWs. Produces a Mermaid flowchart of the HMW tree with optional PNG export. Acts as the bridge between research synthesis (affinity diagramming, insights) and idea generation (brainstorming). |
| **Primary category** | `transformation` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Preservation mode** | `balanced` |
| **Creativity level** | `medium` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- User has a problem, pain point, insight, or research finding and wants HMW framings for ideation
- User wants 3–6 alternative HMWs to choose where to ideate
- User wants to break down a broad HMW into narrower, actionable sub-HMWs
- Bridge between `affinity-diagramming` insights and `brainstorming` ideation
- User wants to flip a pain into an opportunity

## When not to use

- Idea generation on a finished HMW → `brainstorming` (chain HMW framing before)
- Research synthesis itself → `affinity-diagramming`
- Root-cause analysis → future root-cause-analysis skill
- Vision statement crafting → `vision-crafting`
- User story writing → `user-story-generator` (Phase 3)

---

## Required input

| Field | Description |
|---|---|
| **Problem / insight** | Problem statement, pain point, user quote, research finding, or insight reference |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Mode** | `single` / `variants` / `breakdown` | `variants` |
| **Audience ("we")** | Team, product, org, service | Inferred |
| **Context / domain** | User situation, moment, medium | Inferred |
| **Constraints** | What must remain true in any solution | None |
| **Lens preferences** | Force-include or exclude specific lenses | Auto-select 3–8 |
| **Target HMW count** | 3–8 | 5 |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/hmw-framing/` |

## Input schema

```
input:
  required:
    problem:
      type: string | document_reference
  optional:
    mode:
      type: string
      enum: [single, variants, breakdown]
      default: variants
    audience:
      type: string
    context:
      type: string
    constraints:
      type: list[string]
    lens_preferences:
      type: object
      properties:
        include: list[string]
        exclude: list[string]
    target_hmw_count:
      type: integer
      min: 3
      max: 8
      default: 5
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path:
      type: string
```

---

## Processing rules

### Phase 1 — Setup

1. Collect problem; interview mode (§7) if missing or vague
2. Detect mode, audience, context, constraints, lens preferences
3. Confirm scope
4. Ask render mode and output path

### Phase 2 — Deconstruction

Extract: actors ("we"), beneficiary, need, context, emotion, constraint. Label any assumed element `[Assumed]`. The deconstruction is the preservation anchor.

### Phase 3 — Lens selection

Select 3–8 lenses. Defaults matched to problem type:
- Pain → Remove the bad, Explore opposite
- Opportunity → Amp the good
- Stuck → Question the assumption, Break the status quo
- Stale → Analogy, Adjective change
- Scale-dependent → Scale up / scale down

Honor user include/exclude.

### Phase 4 — Variant generation

One HMW per lens. Every HMW:
- Starts with "How might we"
- Solution-neutral
- Positive framing
- Single focus
- ≤20 words
- Traceable to source deconstruction

No two variants may be rephrasings of each other — force lens-driven differentiation.

### Phase 5 — Quality check

- **Scope test**: too narrow / just right / too broad
- **Wording test**: starts with "How might we", positive, single focus, concrete, ≤20 words
- Show failures with proposed fix; do not silently repair

### Phase 6 — Ranking and recommendation

Score each variant on Generativity / Grounded / Actionability (1–5 each). Composite max 15. Recommend top variant with rationale; mention runner-up if meaningfully different.

### Phase 7 — Optional breakdown

Trigger when mode = `breakdown` or top HMW scored "too broad". Produce 3–5 sub-HMWs that nest under the parent (preserve actors and need; may narrow context or beneficiary).

### Phase 8 — Diagram

Mermaid flowchart: problem → deconstruction → lenses → HMWs → recommended (+ sub-HMWs if breakdown).

### Phase 9 — Diagram rendering

Per `diagram-rendering` mixin. File name: `hmw-tree.mmd` / `.png`.

### Phase 10 — Report assembly and approval

Full report; present for approval; save only after confirmation.

---

## Output contract

### Report structure

```markdown
# HMW Framing: [short label]

**Date**: [date]
**Mode**: [single / variants / breakdown]
**Source**: [verbatim]
**Variants produced**: [N]
**Recommended HMW**: [short form]

## Source Problem
> [verbatim]

## Deconstruction
[Table: actors, beneficiary, need, context, emotion, constraint; `[Assumed]` where applicable]

## Lenses Applied
[Table: lens + rationale per selected lens]

## HMW Variants
[Per variant: lens, HMW text, rationale, emphasis, scope verdict, wording check, fix]

## Ranking
[Scoring table across variants on generativity / grounded / actionability / composite]

## Recommended HMW
> **[final HMW text]**

[Rationale + runner-up mention]

## Breakdown
[If produced — 3–5 sub-HMWs nested under recommended]

## Diagram
[Mermaid flowchart]

## Next Step
Feed the recommended HMW into `brainstorming` for ideation.

## Assumptions & Limitations
[Explicit list]
```

### Diagrams

- **HMW tree** — Mermaid `flowchart`: problem → deconstruction → lenses → HMWs → recommended, plus sub-HMWs if breakdown

In `code` mode: Mermaid code block. In `image` mode: PNG via `mmdc` per `diagram-rendering` mixin.

---

## Transformation + generation policy

**Transformation (primary)**:

| Aspect | Declaration |
|---|---|
| **What must be preserved** | Actors, beneficiary, underlying need, context, constraints |
| **What may change** | Wording, framing (pain → opportunity), form (statement → question), lens-specific perspective |
| **Preservation mode** | `balanced` |
| **Evidence of preservation** | Deconstruction section documents what was preserved |

**Generation (secondary)**:

| Aspect | Declaration |
|---|---|
| **What may be invented** | Lens-specific wordings, variant phrasings, sub-HMW scopings |
| **What must be grounded** | Source problem anchors every variant |
| **Assumptions allowed** | Audience / context / constraint inferences — labeled `[Assumed]` |
| **Never fabricate** | User quotes as real, statistics, competitor references, research findings not in input |

---

## Self-check

```
[] Source problem preserved verbatim
[] Deconstruction covers all six elements
[] Assumptions labeled `[Assumed]`
[] 3–6 variants on distinct lenses (or mode-appropriate count)
[] Every variant starts with "How might we"
[] Every variant solution-neutral
[] Every variant positively framed
[] Every variant ≤20 words
[] Scope verdict given per variant
[] Wording check shown with fix when failing
[] Ranking on generativity / grounded / actionability
[] Recommended HMW with rationale
[] Runner-up mentioned if meaningfully different
[] Breakdown produced when triggered (mode or "too broad")
[] Sub-HMWs nest under parent (preserve actors and need)
[] Mermaid diagram renders valid syntax
[] No fabricated quotes, users, stats, or competitor references
[] Next-step pointer to `brainstorming`
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No problem provided | Interview mode (§7) |
| Input already in HMW form | Acknowledge; offer `variants` (alternatives) or `breakdown` (narrower sub-HMWs) |
| Input is a solution, not a problem | Identify underlying problem, confirm reframe, then proceed |
| Input abstract ("grow the business") | Ask for narrowing; if declined, apply `[Assumed]` narrowing |
| Input prescriptive ("we need a mobile app") | Extract underlying need, reframe to problem, then HMW |
| Fewer than 2 meaningful lens variations | 2 variants with honest note; do not pad |
| All variants fail scope test | Report, invite user input to tighten/loosen constraints |
| mmdc render failure | See `diagram-rendering` mixin |
| Out-of-scope request | "This skill produces HMW questions. Use `brainstorming` with the recommended HMW as input for ideation." |

---

## Quality checks

- [ ] Source preserved verbatim
- [ ] Full deconstruction with assumption labels
- [ ] Distinct lenses per variant
- [ ] Every variant passes wording test (or fix shown)
- [ ] Scope verdict per variant
- [ ] Ranking across all variants on consistent criteria
- [ ] Recommendation with rationale
- [ ] Breakdown produced when triggered
- [ ] Mermaid diagram valid
- [ ] No fabricated content
- [ ] Output saved to agreed path only after approval

---

## Examples

### Normal cases

**1. Pain point from user research**
- Input: "Users abandon signup because they don't understand why we need their phone number"
- Expected: Deconstruction (actors=product team, beneficiary=new users, need=complete signup with confidence, context=early signup flow, emotion=suspicious/hesitant, constraint=phone verification required by compliance). Lenses: Remove the bad, Question the assumption, Change the POV, Amp the good. 4 variants including "How might we make the value of phone verification obvious at the moment we ask?" Recommended with rationale.

**2. Insight from affinity diagram**
- Input: "Users rely on trial colleagues to explain the product rather than the product itself"
- Expected: Variants covering Amp the good (formalize peer learning), Remove the bad (make the product self-explanatory), Unexpected resource (leverage the peer behavior), Analogy (community-led platforms). Recommended: "How might we turn peer explanation into a built-in part of the product experience?"

**3. Broad mode = breakdown**
- Input: "How might we improve our customer experience?" + mode = breakdown
- Expected: Acknowledge HMW is broad. Produce 4 sub-HMWs across journey stages: signup, first use, ongoing use, support. Preserve actors/need; narrow context.

**4. Prescriptive input**
- Input: "We need to build a recommendation engine"
- Expected: Identify underlying problem: "Users struggle to find relevant content on their own." Reframe. Generate HMW variants around discovery, personalization, community curation, editorial.

**5. With lens exclude**
- Input: Pain point + exclude = ["Analogy", "Status-quo break"]
- Expected: Lens set drawn from remaining; variants still distinct; excluded lenses not used.

### Edge cases

**6. Input is already HMW**
- Input: "How might we make onboarding faster for new users?"
- Expected: Acknowledge. Offer `variants` (alternatives on different lenses) or `breakdown` (split onboarding into distinct sub-HMWs). Proceed with user's choice.

**7. Very abstract input**
- Input: "Win the market"
- Expected: Interview for narrowing (which market? which user? what does "win" mean?). If user declines, apply `[Assumed]` narrowing and proceed with caveat.

**8. Single mode for direct ideation**
- Input: "Tax filing is a moment of anxiety for freelancers" + mode = single
- Expected: One best HMW only, no variant exploration, still with deconstruction and wording check.

### Failure cases

**9. No problem provided**
- Input: "Frame an HMW"
- Expected: Interview mode — "What problem, pain point, or insight would you like to frame as an HMW?"

**10. Out of scope**
- Input: "Generate 30 ideas for this HMW"
- Expected: "This skill produces HMW questions. For ideation against an HMW, see `brainstorming`. I can hand this HMW to that skill as input."
