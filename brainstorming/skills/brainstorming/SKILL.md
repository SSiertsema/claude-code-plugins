---
name: brainstorming
description: Brainstorming and brainwriting skill applying classic rules, 6-3-5, reverse brainstorming, SCAMPER, round-robin, nominal group technique, silent brainstorming, crazy 8s, and HMW framing. Generates, facilitates, or documents idea sessions with affinity clustering, multi-criteria evaluation, and Mermaid diagrams with optional PNG export.
argument-hint: "[challenge or problem statement]"
---

# Brainstorming

You run a structured brainstorming / brainwriting session. You can operate in three modes: `autonomous` (you generate ideas), `facilitation` (you prompt the user round-by-round), or `documentation` (the user supplies raw ideas and you structure them). You produce a large, diverse idea set, cluster ideas by affinity, evaluate against criteria, and recommend top-N ideas.

## Core rules (defer-judgement ideation)

During idea generation:
- **Quantity over quality** — aim for 30–50 ideas before any filtering
- **Defer judgement** — do not evaluate, critique, or prioritize during generation
- **Build on ideas** — combine and extend prior ideas openly
- **Encourage wild ideas** — extreme, silly, or implausible ideas are welcome at generation time
- **Stay on challenge** — every idea must address the stated challenge

Evaluation only happens in Phase 7, never during Phase 4.

## Input handling

Follow shared foundation §7 — interview mode. When input is missing or insufficient, interview to gather at minimum:

| Dimension | Required | Default |
|---|---|---|
| **Challenge / problem statement** | Yes | — |
| **Mode** (autonomous / facilitation / documentation) | No | `autonomous` |
| **Technique(s)** | No | Auto-selected based on challenge |
| **Target idea count** | No | 30–50 |
| **Evaluation criteria** | No | feasibility, impact, novelty, effort |
| **Existing ideas to build on** | No | None |
| **Participants** (documentation mode only) | No | Anonymous |

**Exit interview when**: challenge is clear.

## Phase 1 — Setup

### 1. Collect input

Accept:
- A challenge, problem statement, or "how might we" question
- A file path to a business case or brief
- No / vague input → enter interview mode (§7)

### 2. Detect scope

From input or interview:
- **Challenge**: the problem to ideate against (reframe into HMW if not already)
- **Mode**: autonomous / facilitation / documentation
- **Technique set**: auto-select 2–4 techniques, or honor user selection
- **Target count**: default 30–50
- **Evaluation criteria**: default `feasibility`, `impact`, `novelty`, `effort`

### 3. Confirm scope

Present:

```
**Challenge**: [HMW / problem statement]
**Mode**: [autonomous / facilitation / documentation]
**Techniques**: [list with reason per technique]
**Target count**: [N]
**Evaluation criteria**: [list]
```

Ask for confirmation or adjustments.

Ask diagram render mode per the `diagram-rendering` mixin and the output path (default: `/documentation/[case]/brainstorming/`).

## Phase 2 — Technique selection

Pick 2–4 complementary techniques. Diversity beats depth — combining techniques raises idea variance.

| Technique | When to use | What it produces |
|---|---|---|
| **Classic brainstorming** | Warm-up, broad exploration | Fast divergent idea stream |
| **6-3-5 brainwriting** | Group settings, quieter participants | 108 ideas in 30 min (6 × 3 × 5 rounds); documentation/facilitation mode |
| **Reverse brainstorming** | Stuck on the positive framing | "How to cause the problem?" → invert |
| **SCAMPER** | Existing product/service to improve | Substitute, Combine, Adapt, Modify, Put to other use, Eliminate, Reverse |
| **Round-robin** | Equal participation needed | Sequential contributions, no jumping in |
| **Nominal group technique (NGT)** | Silent + structured voting | Silent generation → round-robin sharing → ranked votes |
| **Silent brainstorming** | Dominant voices risk | Individual written idea generation, shared after |
| **Crazy 8s** | Visual/UX concepts, time pressure | 8 ideas in 8 minutes, one per sheet |
| **How Might We (HMW)** | Framing before ideation | Converts problem into opportunity question |

Default technique mix:
- Business/strategy challenges: HMW + SCAMPER + Reverse + Classic
- Product/UX challenges: HMW + Crazy 8s + SCAMPER
- Process/ops challenges: Reverse + SCAMPER + 6-3-5
- Research/discovery challenges: Classic + Silent + NGT

## Phase 3 — HMW framing

If the challenge is not already in HMW form, reframe:

- "Our churn is too high" → "How might we make staying with us the easier choice?"
- "We need a new revenue stream" → "How might we capture value from our underused assets?"

Rules:
- Neither too narrow (prescribes solution) nor too broad (no focus)
- Starts with "How might we..."
- Positive framing (not "how do we avoid X")

Present the reframe to the user if you generated it.

## Phase 4 — Idea generation / capture

### Autonomous mode

Apply each selected technique in sequence. Generate ideas under the defer-judgement rules above.

Per technique, produce a labeled batch:

```
### Technique: SCAMPER
- [S1] Substitute: ...
- [S2] Substitute: ...
- [C1] Combine: ...
...
```

Target: reach the target idea count (default 30–50) across all techniques combined.

### Facilitation mode

Run one technique at a time with the user:

1. Announce the technique and rules
2. Run a timed / structured round (e.g., "Generate 8 ideas in 8 minutes for Crazy 8s")
3. Collect the user's ideas
4. Move to next technique

Do not generate ideas yourself in facilitation mode — you are the facilitator.

### Documentation mode

Accept the user's raw idea list. Normalize:
- Deduplicate near-identical ideas (merge with "merged from: [originals]")
- Clarify vague ideas with short rewrites (retain original in `note`)
- Assign IDs
- Do not invent new ideas

### Idea ID convention

`[technique-code]-[sequence]` — e.g., `SC-03` for SCAMPER #3, `C8-05` for Crazy 8s #5, `HMW-01` for classic HMW ideas.

## Phase 5 — Deduplication and normalization

- Merge near-duplicates (list originals)
- Split compound ideas that combine two distinct directions
- Rewrite unclear ideas into a single short sentence (≤15 words)
- Never delete — mark as `merged` or `split`

## Phase 6 — Affinity clustering

Group ideas into 3–7 clusters by theme.

Per cluster:
- **Name**: short, memorable (e.g., "Frictionless onboarding", "Community-led growth")
- **Rationale**: 1 sentence — what these ideas have in common
- **Member IDs**: list of idea IDs

Rules:
- No "Miscellaneous" or "Other" cluster — every idea fits somewhere
- 3–7 clusters — fewer is too coarse, more is over-fragmented
- If you find >7 natural clusters, merge the smallest

## Phase 7 — Evaluation

Score every idea on each criterion (1–5 scale):

| Criterion | 1 | 3 | 5 |
|---|---|---|---|
| **Feasibility** | Blocked by hard constraint | Possible with effort | Readily buildable |
| **Impact** | Negligible | Moderate | Game-changing |
| **Novelty** | Done-to-death | Fresh in some contexts | New in the domain |
| **Effort (inverse)** | Months/multi-team | Weeks/small team | Days/single owner |

Allow the user to override criteria in Phase 1. Use 1–5 scales consistently.

Compute `composite = feasibility + impact + novelty + effort_inverse`. Max 20.

## Phase 8 — Prioritization

### Top-N selection

Default N = 10. Select top ideas by composite score. Break ties by impact.

### High-impact / high-feasibility quadrant

Also highlight ideas where both `feasibility ≥ 4` AND `impact ≥ 4` — these are "do next" candidates regardless of composite.

### Wildcards

Keep 2–3 ideas with low composite but high novelty as "wildcards" — label separately.

## Phase 9 — Diagrams

Generate 2 Mermaid diagrams.

### 1. Affinity cluster tree

```mermaid
flowchart TD
    CH["[Challenge / HMW]"]
    CH --> C1["Cluster 1: [name]\n[N ideas]"]
    CH --> C2["Cluster 2: [name]\n[N ideas]"]
    C1 --> I1["[Top idea 1]"]
    C1 --> I2["[Top idea 2]"]
    C2 --> I3["[Top idea 3]"]
```

Show top 2–3 ideas per cluster only (not every idea).

### 2. Evaluation quadrant (Feasibility vs Impact)

```mermaid
quadrantChart
    title Idea Evaluation — [Challenge]
    x-axis Low Feasibility --> High Feasibility
    y-axis Low Impact --> High Impact
    quadrant-1 Quick Wins
    quadrant-2 Do Next
    quadrant-3 Deprioritize
    quadrant-4 Big Bets
    [Idea ID]: [x, y]
```

Plot all ideas (or top 20 if more).

## Phase 10 — Diagram rendering

Render per the `diagram-rendering` mixin.

File naming:
- `affinity-clusters.mmd` / `.png`
- `idea-evaluation-quadrant.mmd` / `.png`

## Phase 11 — Report assembly and approval

Assemble:

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
[3-4 sentences: total ideas, cluster themes, top recommendations]

## Challenge & Framing
[Original challenge + HMW reframe with rationale]

## Techniques Used
[Per technique: name, why selected, ideas produced]

## Affinity Clusters
[Cluster diagram]
[Per cluster: name, rationale, idea count, member IDs]

## Idea Log
[Full table: ID, idea, technique, cluster, feasibility, impact, novelty, effort, composite]

## Evaluation
[Evaluation quadrant diagram]

## Top 10 Recommended Ideas
[Per idea: ID, idea, cluster, scores, why it scores well]

## Quick Wins (High feasibility + High impact)
[Subset]

## Wildcards (High novelty, lower composite)
[Subset]

## Assumptions & Limitations
- Ideas are illustrative starting points, not validated solutions
- Scores reflect reasoned estimation, not measured data
- [any domain assumptions labeled with `[Assumed]`]
```

Present for approval. Save only after explicit confirmation.

## Generation rules (per generation extension)

- **May invent**: ideas, cluster names, cluster rationale, illustrative scenarios
- **Must be grounded in user input**: challenge statement, evaluation criteria, existing ideas supplied
- **Assumptions allowed**: domain/industry assumptions — always label with `[Assumed]`
- **Never fabricate**: market statistics, citations, quotes, "real" customer voices, competitor names as sources
- **Creativity level**: `high`

## Failure behavior

| Situation | Behavior |
|---|---|
| No challenge provided | Enter interview mode (§7) — ask what to ideate against |
| Challenge too vague | Interview — ask for audience, goal, constraint |
| Challenge is a solution in disguise | Reframe as HMW, confirm with user |
| Too few ideas produced | Apply an additional technique before moving on |
| Cannot cluster ideas naturally | Report honestly, produce 2 broad clusters with explanation |
| User declines HMW reframe | Use original framing |
| mmdc failures | See `diagram-rendering` mixin |
| Out-of-scope request (e.g., "validate this idea with users") | "This skill generates and structures ideas. Validation with users is outside scope — see future `user-research` skills." |

## Self-check

```
[] Challenge clearly stated (and reframed as HMW if applicable)
[] At least 2 techniques applied
[] At least 20 ideas generated (target 30–50)
[] Every idea has a unique ID traceable to its technique
[] 3–7 affinity clusters, no "Miscellaneous"
[] Every idea assigned to exactly one cluster
[] Every idea scored on all criteria (1–5)
[] Composite scores computed
[] Top-N list with rationale
[] Quick wins and wildcards highlighted
[] Both Mermaid diagrams render valid syntax
[] Illustrative content labeled as such
[] No fabricated market statistics, quotes, or sources
[] Assumptions labeled `[Assumed]`
[] Report follows output contract
```
