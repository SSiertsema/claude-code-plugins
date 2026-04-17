# Brainstorming — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | brainstorming |
| **Version** | 1.0.0 |
| **Purpose** | Runs a structured brainstorming / brainwriting session for a given challenge. Applies classic brainstorming rules, 6-3-5 brainwriting, reverse brainstorming, SCAMPER, round-robin, nominal group technique (NGT), silent brainstorming, crazy 8s, and HMW framing. Operates in three modes: `autonomous` (generates ideas), `facilitation` (prompts the user round-by-round), or `documentation` (structures a user-supplied idea list). Produces a deduplicated idea log, affinity clusters, multi-criteria evaluation, top-N recommendations, and 2 Mermaid diagrams with optional PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `high` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- User has a challenge / problem / HMW question and wants a diverse set of ideas
- User wants to apply structured brainstorming / brainwriting techniques
- User wants to document a live session and have it structured and evaluated
- User wants ideas clustered and evaluated against explicit criteria
- User is at the Phase 2 Exploration & Validation stage of a discipline-skills workflow

## When not to use

- Gericht mind mapping around a single topic → `mind-mapping` (future)
- Affinity diagramming of existing research data (not idea generation) → `affinity-diagramming` (future)
- Visual concept sketching of a solution → `concept-sketching` (future)
- Isolated HMW reframing without ideation → `hmw-framing` (future)
- Detailed concept development, feasibility analysis, or PoC — later skills in the phase
- Validation of ideas with real users — user-research skills

---

## Required input

| Field | Description |
|---|---|
| **Challenge** | Problem statement, HMW question, or business case reference to ideate against |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Mode** | `autonomous` / `facilitation` / `documentation` | `autonomous` |
| **Techniques** | Subset of supported techniques to apply | Auto-selected (2–4) |
| **Target idea count** | How many ideas to produce | 30–50 |
| **Evaluation criteria** | Criteria for scoring ideas (1–5 each) | `feasibility`, `impact`, `novelty`, `effort` |
| **Existing ideas** | Prior ideas to build on or structure | None |
| **Participants** | For documentation mode | Anonymous |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/brainstorming/` |

## Input schema

```
input:
  required:
    challenge:
      type: string | document_reference
      description: "Problem, HMW question, or business case to ideate against"
  optional:
    mode:
      type: string
      enum: [autonomous, facilitation, documentation]
      default: autonomous
    techniques:
      type: list[string]
      enum_values: [classic, brainwriting-6-3-5, reverse, scamper, round-robin, ngt, silent, crazy-8s, hmw]
      default: auto_selected
    target_idea_count:
      type: integer
      default: 40
      min: 20
    evaluation_criteria:
      type: list[string]
      default: [feasibility, impact, novelty, effort]
    existing_ideas:
      type: list[string]
      description: "Prior ideas to include"
    participants:
      type: list[string]
      description: "For documentation mode — attribution if relevant"
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path:
      type: string
      description: "File path for saving the report"
```

---

## Processing rules

### Phase 1 — Setup

1. Collect challenge; enter interview mode (§7) if missing or vague
2. Detect mode, techniques, target count, evaluation criteria
3. Confirm scope with the user
4. Ask render mode (per `diagram-rendering` mixin) and output path

### Phase 2 — Technique selection

Pick 2–4 complementary techniques. Combining techniques raises idea variance more than depth in a single technique.

Default mixes:
- Business/strategy: HMW + SCAMPER + Reverse + Classic
- Product/UX: HMW + Crazy 8s + SCAMPER
- Process/ops: Reverse + SCAMPER + 6-3-5
- Research/discovery: Classic + Silent + NGT

### Phase 3 — HMW framing

If the challenge is not in HMW form, reframe. Rules:
- Starts with "How might we..."
- Neither prescriptive (too narrow) nor unfocused (too broad)
- Positive framing

### Phase 4 — Generation / capture

Apply defer-judgement rules: quantity over quality, build on ideas, no evaluation yet, stay on challenge.

- **Autonomous**: model generates ideas per technique, labeled in batches
- **Facilitation**: model runs the session, collects user ideas per round, does not invent
- **Documentation**: user supplies ideas, model normalizes only

Idea ID convention: `[technique-code]-[sequence]` (e.g., `SC-03`, `C8-05`, `HMW-01`).

### Phase 5 — Deduplication and normalization

- Merge near-duplicates (list originals)
- Split compound ideas
- Rewrite unclear ideas to ≤15 words
- Never delete — mark as `merged` or `split`

### Phase 6 — Affinity clustering

Group ideas into 3–7 named clusters. Each cluster has: name, 1-sentence rationale, member idea IDs. No "Miscellaneous".

### Phase 7 — Evaluation

Score every idea on each criterion (1–5). Compute composite (max 20). Anchor scales:
- Feasibility: 1 = blocked / 3 = possible / 5 = readily buildable
- Impact: 1 = negligible / 3 = moderate / 5 = game-changing
- Novelty: 1 = done-to-death / 3 = fresh / 5 = new in domain
- Effort (inverse): 1 = months / 3 = weeks / 5 = days

### Phase 8 — Prioritization

- Top-N (default 10) by composite
- Highlight quick wins (feasibility ≥4 AND impact ≥4)
- Keep 2–3 wildcards (high novelty, lower composite)

### Phase 9 — Diagrams

Generate 2 Mermaid diagrams:
1. **Affinity cluster tree** (flowchart) — challenge → clusters → top ideas per cluster
2. **Evaluation quadrant** (quadrantChart) — feasibility (x) vs impact (y)

### Phase 10 — Diagram rendering

Per `diagram-rendering` mixin. File names:
- `affinity-clusters.mmd` / `.png`
- `idea-evaluation-quadrant.mmd` / `.png`

### Phase 11 — Report assembly and approval

Assemble full report. Present for user approval. Save only after explicit confirmation.

---

## Output contract

### Report structure

```markdown
# Brainstorming Session: [Challenge]

**Date**: [date]
**Mode**: [autonomous / facilitation / documentation]
**HMW framing**: [reframed question]
**Techniques applied**: [list]
**Total ideas generated**: [N]
**Ideas after dedup**: [N]
**Clusters identified**: [N]

## Executive Summary
[3-4 sentences]

## Challenge & Framing
[Original + HMW reframe]

## Techniques Used
[Per technique: name, rationale, ideas produced]

## Affinity Clusters
[Cluster diagram + per-cluster detail]

## Idea Log
[Full table: ID, idea, technique, cluster, feasibility, impact, novelty, effort, composite]

## Evaluation
[Evaluation quadrant diagram]

## Top 10 Recommended Ideas
[Per idea: ID, idea, cluster, scores, rationale]

## Quick Wins
[Ideas with feasibility ≥4 AND impact ≥4]

## Wildcards
[High-novelty, lower-composite ideas]

## Assumptions & Limitations
[Explicit list]
```

### Diagrams (2)

1. **Affinity cluster tree** — Mermaid flowchart, challenge → clusters → top ideas per cluster
2. **Evaluation quadrant** — Mermaid quadrantChart, feasibility vs impact

In `code` mode: Mermaid code blocks. In `image` mode: PNG via `mmdc` per `diagram-rendering` mixin.

---

## Generation policy

| Aspect | Declaration |
|---|---|
| **What may be invented** | Ideas, cluster names, cluster rationales, illustrative examples |
| **What must be grounded** | The challenge, user-supplied evaluation criteria, user-supplied existing ideas |
| **What assumptions are allowed** | Domain/industry assumptions — must be labeled `[Assumed]` |
| **What must never be fabricated** | Market statistics, citations, quotes, "real" customer voices, competitor names presented as sources |

---

## Self-check

```
[] Challenge clearly stated and reframed as HMW if applicable
[] At least 2 techniques applied
[] At least 20 ideas (target 30–50)
[] Every idea has a unique ID traceable to its technique
[] 3–7 affinity clusters, no "Miscellaneous"
[] Every idea assigned to exactly one cluster
[] Every idea scored on all criteria (1–5)
[] Composite scores computed
[] Top-N list with rationale
[] Quick wins and wildcards highlighted
[] Both Mermaid diagrams render valid syntax (per diagram-rendering mixin)
[] Illustrative content labeled as such
[] No fabricated statistics, quotes, or sources
[] Assumptions labeled `[Assumed]`
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No challenge provided | Enter interview mode (§7) — ask what to ideate against |
| Challenge too vague | Interview — audience, goal, constraint |
| Challenge is a solution in disguise | Reframe as HMW, confirm |
| Too few ideas produced | Apply an additional technique before moving on |
| Cannot cluster naturally | Produce 2 broad clusters with honest explanation |
| User declines HMW reframe | Use original framing |
| mmdc rendering fails | See `diagram-rendering` mixin |
| Out-of-scope request | "This skill generates and structures ideas. [Request] is outside scope." |

---

## Quality checks

- [ ] At least 2 techniques applied
- [ ] ≥20 ideas produced (target 30–50)
- [ ] All ideas have unique IDs traceable to technique
- [ ] 3–7 affinity clusters, each with name and rationale
- [ ] Every idea belongs to exactly one cluster
- [ ] Every idea evaluated on all criteria (1–5)
- [ ] Composite score computed per idea
- [ ] Top-N recommendation list with rationale
- [ ] Quick wins and wildcards flagged separately
- [ ] Both diagrams render valid Mermaid
- [ ] No fabricated market data, quotes, or citations
- [ ] Assumptions labeled `[Assumed]`

---

## Examples

### Normal cases

**1. Business challenge, autonomous**
- Input: "How do we reduce churn for our mid-tier SaaS plan?"
- Expected: HMW reframe, 4 techniques (HMW + SCAMPER + Reverse + Classic), ~40 ideas, 5 clusters (e.g., "Proactive success", "Value reinforcement", "Exit friction", "Community lock-in", "Pricing optionality"), evaluation quadrant, top-10 list, 2 quick wins, 2 wildcards.

**2. Product/UX challenge, autonomous**
- Input: "Design a better first-run experience for our mobile expense app"
- Expected: HMW + Crazy 8s + SCAMPER, ~35 ideas including sketch-style concepts, 4 clusters (e.g., "Zero-config onboarding", "Guided discovery", "Instant value", "Social proof"), top-10, quick wins highlighted.

**3. Documentation mode**
- Input: User pastes 28 raw ideas from a Miro board for "Improve warehouse picking efficiency"
- Expected: Dedup (→ 23 after merges), 4 clusters (e.g., "Route optimization", "Picker UX", "Batching strategies", "Exception handling"), scoring, top-10, quick wins.

**4. Facilitation mode**
- Input: "Run a Crazy 8s session with me for our landing-page hero"
- Expected: Model announces Crazy 8s rules, times 8-minute rounds, collects 8 ideas from user, then structures and clusters.

**5. With existing ideas**
- Input: "We already have these 5 ideas — generate 30 more and evaluate all 35: [list]" for reducing support ticket volume
- Expected: Existing ideas assigned IDs `EX-01..05`, 30 more generated, all 35 clustered and scored together.

### Edge cases

**6. Very narrow challenge**
- Input: "Come up with names for our internal slack bot"
- Expected: Classic + SCAMPER only, ~25 ideas (name space is bounded), 3 clusters (e.g., "Action words", "Mascots", "Acronyms"), no HMW reframe needed (naming isn't a problem statement).

**7. Extremely broad challenge**
- Input: "How do we grow the company?"
- Expected: Model asks in scope confirmation whether to narrow (by product, market, channel, function). Proceeds with explicit [Assumed] narrowing + note that output is illustrative directions, not concrete initiatives.

**8. Existing ideas conflict with challenge**
- Input: Challenge = "Reduce onboarding friction"; existing ideas include 4 marketing campaigns
- Expected: Flag mismatch, include marketing ideas in cluster "Adjacent — marketing acquisition" with note that they don't directly address the stated challenge. Suggest either reframing the challenge or moving those ideas out of scope.

### Failure cases

**9. No challenge**
- Input: "Do a brainstorm"
- Expected: Interview mode — "What is the challenge or problem you want to ideate against?"

**10. Out of scope**
- Input: "Brainstorm and then validate these ideas with real users"
- Expected: "This skill generates and structures ideas. Validation with real users is outside scope — see future `user-research` skills. I can proceed with the brainstorming portion."
