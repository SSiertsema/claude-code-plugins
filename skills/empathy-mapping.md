# Empathy Mapping — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | empathy-mapping |
| **Version** | 1.0.0 |
| **Purpose** | Produces an empathy map for a single persona or user segment across 6 quadrants (Think & Feel / See / Hear / Say & Do / Pains / Gains — Dave Gray updated) or classic 4-quadrant (Says / Thinks / Does / Feels). Supports two modes: `synthesis` (extraction from supplied research — interviews, quotes, observations, reviews) and `autonomous` (inference from persona description with labeled assumptions and confidence). Surfaces tensions (contradictions between quadrants), evidence gaps, 3–5 synthesized insights, and top pain/gain highlights. Every item traces to source ID or `[Assumed]` rationale. Produces a Mermaid empathy map diagram (persona center + quadrant branches) with optional tensions diagram and PNG export. Feeds downstream skills: `jtbd-analysis`, `hmw-framing`, `user-journey-management`. |
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

- User wants a shared team understanding of a persona or segment's inner and outer world
- User has qualitative research (interviews, observations, reviews) and wants synthesis
- User has a persona and wants to pressure-test assumptions about their experience
- Team kickoff for a design or product initiative — align on "who are we building for"
- Upstream of `jtbd-analysis`, `hmw-framing`, and journey mapping

## When not to use

- Persona creation itself → `persona-management`
- Demographic/firmographic segmentation → `customer-segmentation`
- Jobs-to-be-Done analysis → `jtbd-analysis`
- User journey mapping → `user-journey-management`
- User story writing → `user-story-generator`
- Quantitative user research → `survey-design`
- Multi-persona comparison — run separate maps

---

## Required input

| Field | Description |
|---|---|
| **Persona / segment** | Name, description, or document reference of the single user type to map |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Schema** | `6-quadrant` (Dave Gray) or `4-quadrant` (XPLANE) | `6-quadrant` |
| **Mode** | `synthesis` / `autonomous` | `synthesis` if research supplied, else `autonomous` |
| **Research input** | Interviews, quotes, observations, reviews | — |
| **Context / goal** | Situation or goal the map addresses | Inferred |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/empathy-mapping/` |

## Input schema

```
input:
  required:
    persona:
      type: string | document_reference
  optional:
    schema:
      type: string
      enum: [6-quadrant, 4-quadrant]
      default: 6-quadrant
    mode:
      type: string
      enum: [synthesis, autonomous]
      default: "synthesis if research_input supplied else autonomous"
    research_input:
      type: list[string | document_reference]
    context_goal:
      type: string
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

1. Collect persona; interview mode (§7) if missing or vague
2. Detect schema, mode, research input, context
3. Confirm scope
4. Ask render mode and output path

### Phase 2 — Persona anchoring

Brief anchor (who, goal, context). Use supplied persona if available; label inferences `[Assumed]`.

### Phase 3 — Quadrant population

**6-quadrant (default)**:
- Think & Feel (≥4 items, inferred)
- See (≥3, observable)
- Hear (≥3, observable)
- Say & Do (≥4, observable; direct quotes preserved)
- Pains (≥3, inferred)
- Gains (≥3, inferred)

**4-quadrant**: Says / Thinks / Does / Feels (≥4 each).

Per item: statement ≤20 words + source reference or `[Assumed]` + confidence (inferred items).

### Phase 4 — Tensions and gaps

Identify contradictions between quadrants (do not silently reconcile). Flag sparse quadrants as evidence gaps.

### Phase 5 — Key insights

3–5 insights synthesizing across quadrants. Each: statement, ≥2 quadrants + source IDs, type (`pattern` / `tension` / `gap` / `opportunity`), confidence.

### Phase 6 — Pain & Gain highlights

Top 3–5 pains + top 3–5 gains with severity/value and source.

### Phase 7 — Recommendations

Point to downstream skills (`jtbd-analysis`, `hmw-framing`, `user-journey-management`) and name validation gaps.

### Phase 8 — Diagrams

1. **Empathy map** — Mermaid flowchart (persona center → quadrant branches, top 3 items per quadrant)
2. **Tensions diagram** — Mermaid flowchart (only if tensions exist)

### Phase 9 — Diagram rendering

Per `diagram-rendering` mixin. File names:
- `empathy-map.mmd` / `.png`
- `empathy-tensions.mmd` / `.png` (if tensions)

### Phase 10 — Report assembly and approval

Full report; present for approval; save only after confirmation.

---

## Output contract

### Report structure

```markdown
# Empathy Map: [Persona / Segment]

**Date**: [date]
**Schema**: [6-quadrant / 4-quadrant]
**Mode**: [synthesis / autonomous]
**Research input**: [N items from K sources, or "none"]
**Context / goal**: [situation]

## Persona Anchor
[Name, role, goal, context]

## Empathy Map
[Primary diagram]

## Quadrants
[Per quadrant: items with evidence / `[Assumed]` + confidence]

## Tensions & Gaps
[Tensions diagram if any + list + evidence gaps]

## Key Insights
[3–5 with evidence, type, confidence]

## Pain & Gain Highlights
[Top 3–5 each]

## Recommendations
[Next steps + downstream skill pointers]

## Evidence Index
[Source ID or `[Assumed]` rationale per claim]

## Assumptions & Limitations
[Explicit list]
```

### Diagrams

- **Empathy map** — Mermaid `flowchart` with persona center + quadrant branches
- **Tensions** — Mermaid `flowchart` (optional)

In `code` mode: Mermaid code blocks. In `image` mode: PNG via `mmdc` per `diagram-rendering` mixin.

---

## Evidence and generation policy

**Extraction (primary)**:
- Evidence mode: `required`
- Every quadrant item traces to source or `[Assumed]`
- Source IDs in evidence index
- Confidence labels on inferred items

**Generation (secondary)** — autonomous mode only:
- May infer Think/Feel/Pains/Gains from persona description
- Must label all inferences `[Assumed]` with rationale
- Never fabricate quotes or observations

---

## Self-check

```
[] Single persona / segment (not mixed)
[] Schema declared
[] Persona anchor present
[] Minimum item counts per quadrant met
[] Every item traceable or `[Assumed]`
[] Confidence labeled on inferred items
[] Direct quotes verbatim in Say & Do / Says
[] Tensions surfaced (not reconciled)
[] Evidence gaps flagged
[] 3–5 key insights with evidence from ≥2 quadrants
[] Top pains and gains highlighted
[] Recommendations with downstream skill pointers
[] All diagrams render valid Mermaid
[] Evidence index complete
[] No fabricated quotes or observations
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No persona | Interview mode (§7) |
| Persona too vague | Interview — role, goal, context |
| Synthesis mode without research | Request research, or switch to autonomous with `[Assumed]` labels |
| Research covers multiple personas | Propose separate maps per persona |
| Quadrant sparse (<3 items) | Flag as evidence gap; do not pad |
| Tensions suggest conflated personas | Recommend splitting the map |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | "This skill produces an empathy map. For ideation or JTBD analysis, see `brainstorming`, `hmw-framing`, or `jtbd-analysis`." |

---

## Quality checks

- [ ] Single persona
- [ ] Schema declared and followed
- [ ] Every quadrant meets minimum items
- [ ] Evidence or `[Assumed]` on every item
- [ ] Confidence labels on inferred items
- [ ] Direct quotes preserved verbatim
- [ ] Tensions and gaps called out
- [ ] Insights synthesize, not restate
- [ ] Pain & Gain highlights present
- [ ] Diagrams valid Mermaid
- [ ] Evidence index traceable
- [ ] No fabricated content

---

## Examples

### Normal cases

**1. B2B product, synthesis mode, 6-quadrant**
- Input: Persona "Enterprise Procurement Manager" + 8 interview quotes + 3 vendor reviews
- Expected: 6 quadrants populated from quotes (Say & Do has 3 verbatim), inferred Think/Feel with confidence, 2 tensions (says she wants standardization but does exceptions for preferred vendors), 4 insights including 1 tension and 1 opportunity, pains highlighted with severity.

**2. Consumer app, autonomous mode, 6-quadrant**
- Input: Persona "First-time home buyer, mid-20s, tech-comfortable" — no research
- Expected: All items inferred with `[Assumed]` labels and rationale, confidence mostly medium/low, Recommendations section explicitly calls for 5+ user interviews before committing to designs.

**3. Classic 4-quadrant**
- Input: Persona "Warehouse floor lead" + 5 shift observation notes + 4 interview quotes
- Expected: Says / Thinks / Does / Feels, all populated with evidence, 1 tension (says safety is priority, does skip PPE under time pressure), 3 insights.

**4. Research covers one persona across multiple contexts**
- Input: 12 quotes about a persona in both "working from home" and "working at client site" contexts
- Expected: Ask if user wants one combined map or two context-specific maps. Proceed with user's choice. If combined, flag context-dependent tensions.

**5. Pre-work for JTBD analysis**
- Input: Persona "SMB owner evaluating accounting software" + 6 interviews
- Expected: Empathy map surfaces pains ("Hates surprise fees") and gains ("Wants to feel like a real business owner"). Recommendations explicitly chain: "These pains/gains feed into `jtbd-analysis` as candidate desired outcomes."

### Edge cases

**6. Sparse research in some quadrants**
- Input: Research mostly covers Say & Do; Think & Feel has little direct evidence
- Expected: Populate Say & Do from evidence; inferred Think & Feel labeled `[Assumed]` with low confidence; evidence gap flagged explicitly.

**7. Research reveals tensions**
- Input: Persona says "I value quality over price" but research shows consistent budget-driven choices
- Expected: Surface the tension as a Key Insight, label type `tension`, recommend deeper exploration rather than reconciliation.

**8. Persona without clear goal**
- Input: Persona description is demographic-only (age, role, location)
- Expected: Ask for a goal/context in setup; if declined, apply `[Assumed]` goal and flag confidence of entire map as low.

### Failure cases

**9. No persona**
- Input: "Make an empathy map"
- Expected: Interview mode — "Which persona or user segment would you like to map?"

**10. Out of scope**
- Input: "Map this persona and then design 3 features for them"
- Expected: "This skill produces an empathy map. For ideation based on the pains and gains, use `brainstorming` or `hmw-framing`. I can complete the empathy map and hand the pains/gains to those skills."
