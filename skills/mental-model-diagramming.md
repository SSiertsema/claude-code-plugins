# Mental Model Diagramming — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | mental-model-diagramming |
| **Version** | 1.0.0 |
| **Purpose** | Produces an Indi Young-style mental model diagram for a problem domain. Captures *what users think, do, and feel* in the domain-wide space (not one persona's moment, not a journey, not a job statement). Extracts verb-led user-language behaviors from research input, clusters into 4–10 vertical "towers" = task spaces, populates per-tower rows for Thinking / Doing / Feeling / Guiding Principles. Optionally aligns existing / proposed / competitor features beneath the towers they support. Surfaces opportunity gaps (towers with no feature support) and misalignments (features not under any tower). Produces summary synthesis of dominant towers, surprising towers, prioritized opportunities, and evidence strength per tower. Two modes: `synthesis` (from research — default when research supplied) and `autonomous` (inference with labeled `[Assumed]`). Mermaid mental-model overview and opportunity heat-map diagrams with PNG export. |
| **Primary category** | `extraction` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Before product / feature strategy: understand the domain user-space
- Post-research synthesis: organize interview insights domain-wide
- Portfolio-level gap analysis: where does the product fit the user mental space, where not
- Pairs with `jtbd-analysis` (formal job statement) and `empathy-mapping` (persona-moment) — mental model is the stable backdrop

## When not to use

- One-persona, one-moment emotional map → `empathy-mapping`
- Formal job statement + desired outcomes → `jtbd-analysis`
- Sequential journey through touchpoints → `user-journey-management`
- Ideation → `brainstorming`
- Clustering of existing items → `affinity-diagramming`

---

## Required input

| Field | Description |
|---|---|
| **Domain** | Problem space — verb-led framing |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Research input** | Interviews / quotes / observations | Required for synthesis mode |
| **Mode** | synthesis / autonomous | synthesis if research supplied, else autonomous |
| **Features for alignment** | Current / proposed / competitor features | None |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/mental-model-diagramming/` |

## Input schema

```
input:
  required:
    domain:
      type: string | document_reference
  optional:
    research_input: list[string | document_reference]
    mode:
      type: string
      enum: [synthesis, autonomous]
      default: "synthesis if research_input supplied else autonomous"
    features:
      type: object
      properties:
        existing: list[string]
        proposed: list[string]
        competitor: list[string]
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
Collect domain + mode + research.

### Phase 2 — Root-level synthesis
Extract verb-led user-language behaviors.

### Phase 3 — Tower grouping
4–10 task-space towers.

### Phase 4 — Row content per tower
Think / do / feel / guiding principles.

### Phase 5 — Feature alignment (if features supplied)
Existing / proposed / competitor aligned under towers.

### Phase 6 — Opportunity & misalignment analysis
Towers without features, features without towers.

### Phase 7 — Summary synthesis
Dominant / surprising / prioritized gaps / evidence strength.

### Phase 8 — Diagrams
Mental model + opportunity heatmap.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Mental Model: [Domain]

**Date**: [date]
**Domain**: [space]
**Mode**: [synthesis / autonomous]
**Towers**: [N]

## Scope
[Domain, mode, research, feature alignment]

## Domain Framing
[1 paragraph]

## Towers
[Per tower: name + think / do / feel / principles + sources]

## Feature Alignment (if applicable)
[Existing / proposed / competitor]

## Opportunities
[Towers without features + candidate responses]

## Misalignments
[Features without towers + rationale]

## Summary Synthesis
[Dominant / surprising / opportunities / evidence strength]

## Diagrams
[Mental model + opportunity heatmap]

## Evidence Index
[Row → source or `[Assumed]`]

## Assumptions & Limitations
[Research gaps]
```

### Diagrams

- **Mental model overview** — Mermaid `flowchart` with subgraphs per tower
- **Opportunity heatmap** — Mermaid `quadrantChart`

---

## Extraction and generation policy

- Evidence or `[Assumed]`
- User language preserved
- No fabricated quotes
- Towers verb-led
- Feature-tower mapping explicit
- Opportunities evidence-grounded

---

## Self-check

```
[] Domain stated
[] 4–10 towers
[] Verb-led user-language rows
[] Evidence or `[Assumed]`
[] Think / do / feel categories
[] Feature alignment if in scope
[] Opportunities named with evidence
[] Misalignments named
[] Summary synthesis
[] Evidence index
[] Diagrams valid
[] No fabricated quotes
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No domain | Interview mode (§7) |
| Synthesis without research | Offer autonomous with `[Assumed]`, low confidence |
| Multi-domain research | Split into separate mental models |
| Features without research | Alignment speculative; flag |
| <4 or >10 towers | Flag with re-cluster recommendation |
| mmdc failure | See `diagram-rendering` mixin |
| Feature-design request | Out-of-scope |

---

## Quality checks

- [ ] Tower count fit (4–10)
- [ ] Verb-led user-language
- [ ] Evidence or `[Assumed]`
- [ ] Think/do/feel complete
- [ ] Feature alignment
- [ ] Opportunities + misalignments
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Food / cooking domain**
- Input: Domain = "Deciding what to cook for dinner", 12 interview transcripts
- Expected: 6 towers (consider what I have, think about preferences, plan ahead, avoid repetition, manage dietary constraints, save leftovers); features aligned below show strong support for "consider what I have" (via inventory app) but nothing for "save leftovers" → opportunity.

**2. Personal finance**
- Input: Domain = "Managing personal finances", 8 interviews + journals
- Expected: 7 towers around tracking, budgeting, saving, investing, coping-with-stress, planning-future, managing-debt. Features for tracking/budgeting strong; coping-with-stress entirely unserved → emotional opportunity.

**3. Vacation planning**
- Input: Domain = "Planning a vacation", quotes from 10 users
- Expected: Towers around deciding-destination, coordinating-people, booking-logistics, managing-budget, packing-preparation, anticipating-enjoyment. Surprising tower: "anticipating enjoyment" (pre-vacation mental rehearsal — emotional benefit often under-served).

**4. Onboarding a new product**
- Input: Domain = "Getting started with [product class]"
- Expected: Towers around understand-what-this-is, assess-fit, commit-to-trying, achieve-first-value, invite-others, make-habit. Map onboarding features to each; gaps reveal content / experience investment needs.

**5. Autonomous mode (no research)**
- Input: Domain only, no research
- Expected: Heavy `[Assumed]` labels; towers derived from domain knowledge; confidence low; strong recommendation to validate with 5+ interviews before acting.

### Edge cases

**6. Domain too broad**
- Input: Domain = "Being healthy"
- Expected: Recommend narrowing (diet / exercise / mental / sleep / prevention); flag that a single mental model for such a broad domain is too coarse.

**7. Research reveals sub-domains**
- Input: Research covers "deciding what to cook" but also "grocery shopping" and "meal prep"
- Expected: Propose 3 mental models; ask which to produce now.

**8. Features don't map anywhere**
- Input: Product has features not matching any tower
- Expected: Misalignment list; per feature, probe: wrong / right-but-uncommunicated / wrong-domain. Recommend deprecation or research to add missing tower.

### Failure cases

**9. No domain**
- Input: "Make a mental model"
- Expected: Interview — "Which domain?"

**10. Feature-design request**
- Input: "Mental model + design features for the gaps"
- Expected: "Mental model only. Feature design is downstream — see `brainstorming` / `hmw-framing` / `concept-sketching`."
