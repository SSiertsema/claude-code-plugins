# JTBD Analysis — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | jtbd-analysis |
| **Version** | 1.0.0 |
| **Purpose** | Performs Jobs-to-be-Done analysis for a product, feature, market, or user segment. Produces a formal main job statement (`When [situation], I want to [motivation], so I can [outcome]`), 3–6 related jobs (prerequisite / parallel / follow-on), emotional and social jobs, 5–15 Ulwick-style desired outcome statements (`[direction] the [metric] of [object] when [context]`), forces-of-progress analysis across push / pull / anxiety / habit with strength and evidence, competitive alternatives including mandatory non-consumption option, and underserved-outcome opportunity signals via importance-satisfaction gap analysis. Supports two modes: `synthesis` (extraction from supplied research) and `autonomous` (inference from product context with labeled `[Assumed]`). Output includes job hierarchy, forces diagram, and outcome opportunity quadrant Mermaid diagrams with optional PNG export. Feeds `opportunity-scoring`, `brainstorming`, and `hmw-framing` downstream. |
| **Primary category** | `extraction` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- User wants to understand the core job their product, feature, or market addresses
- User has interview data, survey results, or observation notes to synthesize as JTBD
- User wants competitive analysis through the "what else gets hired" lens (including non-consumption)
- User needs structured input for opportunity-scoring, brainstorming, or HMW framing
- User wants to reframe a feature request as an underlying job

## When not to use

- Demographic / psychographic persona creation → `persona-management`
- Customer segmentation → `customer-segmentation`
- Says/thinks/does/feels research synthesis → `empathy-mapping`
- User story writing (Phase 3) → `user-story-generator`
- User journey mapping → `user-journey-management`
- Product vision statement → `vision-crafting`
- Quantitative survey analysis → `survey-design`

---

## Required input

| Field | Description |
|---|---|
| **Target** | Product, feature, market, or user segment to analyze |

At least one of Target or Research input must be substantive enough to proceed. Research input strongly recommended for synthesis mode.

## Optional input

| Field | Description | Default |
|---|---|---|
| **Mode** | `synthesis` (from research) or `autonomous` (from product context) | `synthesis` if research supplied, else `autonomous` |
| **Research input** | Interview transcripts, quotes, survey open-text, reviews, observation notes | — |
| **Target user segment** | Which user group to analyze | Inferred |
| **Known alternatives / competitors** | What else users hire | Researched from context |
| **Job level** | `main` / `related` / `both` | `both` |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/jtbd-analysis/` |

## Input schema

```
input:
  required:
    target:
      type: string | document_reference
      description: "Product, feature, market, or segment to analyze"
  optional:
    mode:
      type: string
      enum: [synthesis, autonomous]
      default: "synthesis if research_input supplied else autonomous"
    research_input:
      type: list[string | document_reference]
      description: "Interview transcripts, quotes, reviews, observation notes"
    target_segment:
      type: string
    known_alternatives:
      type: list[string]
    job_level:
      type: string
      enum: [main, related, both]
      default: both
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

1. Collect target; interview mode (§7) if missing or vague
2. Detect mode based on research input availability
3. Confirm scope
4. Ask render mode (per `diagram-rendering` mixin) and output path

### Phase 2 — Context analysis

Situational triggers, user state at trigger, environment, constraints.

### Phase 3 — Main job identification

Single formal statement: `When [situation], I want to [motivation], so I can [outcome]`.
- Situation: concrete moment
- Motivation: verb + functional objective, never a product feature
- Outcome: observable or measurable

### Phase 4 — Related jobs

3–6 in same format, classified prerequisite / parallel / follow-on.

### Phase 5 — Emotional and social jobs

Distinct from functional job. Each traceable to evidence or labeled `[Assumed]`.

### Phase 6 — Desired outcomes (Ulwick)

5–15 statements in `[direction] the [metric] of [object] when [context]` format. Direction from controlled set: minimize, maximize, increase speed of, decrease likelihood of.

### Phase 7 — Forces of progress

Push / pull / anxiety / habit. Per force: strength (`strong` / `moderate` / `weak`), evidence or `[Assumed]` rationale, specific items.

### Phase 8 — Competitive alternatives

Direct, indirect, and mandatory non-consumption option. Per alternative: category, why hired, strengths, gaps.

### Phase 9 — Underserved outcomes

Score each outcome on importance + current satisfaction; identify high-importance / low-satisfaction as opportunity signals.

### Phase 10 — Recommendations

Where to feed next (opportunity-scoring, brainstorming, hmw-framing) and what research gaps remain.

### Phase 11 — Diagrams

1. Job hierarchy (flowchart)
2. Forces of progress (flowchart)
3. Outcome opportunity quadrant (quadrantChart)

### Phase 12 — Diagram rendering

Per `diagram-rendering` mixin. File names:
- `job-hierarchy.mmd` / `.png`
- `forces-of-progress.mmd` / `.png`
- `outcome-opportunity-quadrant.mmd` / `.png`

### Phase 13 — Report assembly and approval

Full report; present for approval; save only after confirmation.

---

## Output contract

### Report structure

```markdown
# JTBD Analysis: [Target]

**Date**: [date]
**Mode**: [synthesis / autonomous]
**Target segment**: [segment]
**Research input**: [N items from K sources, or "none"]

## Context & Triggers
[Situational triggers, user state, environment, constraints]

## Main Job
> **When** [situation], **I want to** [motivation], **so I can** [outcome].

## Related Jobs
[Job hierarchy diagram + table: prerequisite / parallel / follow-on]

## Emotional & Social Jobs
[Emotional + social jobs lists]

## Desired Outcomes (Ulwick)
[Table: outcome, importance, satisfaction, opportunity signal]

## Forces of Progress
[Forces diagram + per-force detail]

## Competitive Alternatives
[Table: alternative, category, why hired, strengths, gaps]

## Underserved Outcomes
[Outcome opportunity quadrant + ranked list]

## Recommendations
[Next steps with pointers to downstream skills]

## Evidence Index
[Table: claim → source reference / `[Assumed]` with rationale and confidence]

## Assumptions & Limitations
[Explicit list]
```

### Diagrams

- **Job hierarchy** — Mermaid `flowchart`
- **Forces of progress** — Mermaid `flowchart`
- **Outcome opportunity quadrant** — Mermaid `quadrantChart`

In `code` mode: Mermaid code blocks. In `image` mode: PNG via `mmdc` per `diagram-rendering` mixin.

---

## Evidence and assessment policy

**Extraction (primary)**:
- Every job element traces to research input or `[Assumed]` with rationale + confidence
- Source references preserved in evidence index
- Confidence labels: `high` / `medium` / `low`

**Assessment (secondary)** — for forces, outcome importance/satisfaction, opportunity signals:
- Strength / severity justified by evidence or `[Assumed]`
- No score inflation
- Deterministic — same input produces same analysis

---

## Self-check

```
[] Main job follows formal structure
[] Situation is a concrete moment
[] Motivation is functional, not a product feature
[] Outcome is observable or measurable
[] 3–6 related jobs (prerequisite / parallel / follow-on)
[] Emotional + social jobs distinct and evidenced
[] 5–15 Ulwick outcome statements (direction + metric + object + context)
[] All 4 forces analyzed with strength + evidence
[] ≥1 direct, ≥1 indirect, ≥1 non-consumption alternative
[] Underserved outcomes ranked with importance-satisfaction rationale
[] All Mermaid diagrams render valid syntax
[] Evidence index traceable to source IDs or `[Assumed]`
[] Confidence calibrated
[] No fabricated quotes, research, or competitor facts
[] Recommendations point to concrete next skills
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No target provided | Interview mode (§7) |
| Target is a feature (not a context of use) | Reframe to underlying job, confirm |
| Synthesis mode but no research supplied | Request research, or offer to switch to autonomous with `[Assumed]` labels |
| Research shows multiple competing jobs | Identify conflation, propose separate JTBD analyses |
| Main job cannot be formulated in one statement | Produce 2 candidate statements with rationale, ask user |
| Force missing in evidence | Mark `[Assumed]` with rationale; do not fabricate |
| Fewer than 5 outcomes derivable | Produce fewer with note, flag as low-confidence |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope request | "This skill produces JTBD analysis. For ideation against underserved outcomes, see `brainstorming` / `hmw-framing`." |

---

## Quality checks

- [ ] Formal job statement structure
- [ ] Situation-anchored (concrete moment)
- [ ] Functional (not solution-oriented)
- [ ] 3–6 related jobs
- [ ] Emotional + social jobs distinct
- [ ] Ulwick outcomes in canonical format
- [ ] All 4 forces with evidence
- [ ] Mandatory non-consumption alternative present
- [ ] Importance × satisfaction scored for each outcome
- [ ] Diagrams valid
- [ ] Evidence index complete
- [ ] Confidence labeled on inferred elements
- [ ] No fabricated research

---

## Examples

### Normal cases

**1. SaaS product, synthesis mode**
- Input: "Our project management tool" + 12 interview quotes + 6 reviews
- Expected: Main job like "When I'm starting a new cross-functional initiative, I want to align the team on what we're doing and track progress, so I can deliver on time without constant status meetings." Related jobs: define scope (prerequisite), coordinate handoffs (parallel), retrospect (follow-on). Emotional: feel in control; social: be seen as a reliable lead. 10 Ulwick outcomes. Forces strong PUSH (meeting overload) + strong PULL (visibility) + moderate ANXIETY (tool adoption cost) + strong HABIT (existing tools). Alternatives: Jira (direct), Trello (direct), Slack + spreadsheet (indirect), "manual check-ins" (non-consumption). Underserved: "Minimize time spent producing status updates when stakeholders ask for progress" = high importance, low satisfaction → high opportunity.

**2. Consumer app, autonomous mode**
- Input: "A meditation app for beginners" (no research)
- Expected: Autonomous inference with many `[Assumed]` labels. Main job: "When I feel overwhelmed by stress at the end of a workday, I want to calm my mind quickly, so I can sleep well and feel ready for tomorrow." All elements flagged with confidence. Recommendations include "Validate with ≥10 user interviews before committing to positioning."

**3. Feature within a product**
- Input: "Slack's Canvas feature" + 5 reviews + 2 blog posts
- Expected: Main job "When my team discusses an important decision in threads, I want to capture the outcome in one place, so I can reference it without scrolling through history." Competitive alternatives: Notion docs, Google Docs, message pinning (direct in Slack), screenshots in another doc (non-consumption).

**4. B2B market**
- Input: "The market for AP automation for mid-market finance teams"
- Expected: Main job centered on month-end close, related jobs prerequisite (invoice intake), parallel (approval routing), follow-on (audit trail). Non-consumption = Excel + email.

**5. Underserved outcomes triggering opportunity**
- Input: Research shows users rate "Reduce time to onboard a new vendor" high importance but low satisfaction across 5 interviews
- Expected: Outcome scored high/low → opportunity signal high. Recommendation: "Feed into opportunity-scoring, consider this the primary target outcome for the next ideation cycle."

### Edge cases

**6. Multiple jobs conflated**
- Input: Research mentions both "speed of search" and "depth of results" heavily
- Expected: Report conflation; propose two JTBD analyses: one for "quick answer" job, one for "deep research" job. User chooses which to proceed with (or both in separate reports).

**7. Research with only quotes (no context)**
- Input: 20 raw quotes without interviewer notes
- Expected: Lower confidence on context/situational triggers. Main job inferred from quote themes; triggers marked `[Assumed]` with rationale from most-mentioned contexts.

**8. Target has no clear non-consumption**
- Input: "Air traffic control software"
- Expected: Non-consumption still required — "status quo legacy system" / "manual coordination" counts. Explicitly label and explain.

### Failure cases

**9. No target, no research**
- Input: "Do a JTBD"
- Expected: Interview mode — "What product, market, or segment do you want to analyze?"

**10. Out of scope**
- Input: "Do a JTBD and then build the feature"
- Expected: "This skill produces JTBD analysis only. For ideation, see `brainstorming`. For prioritizing outcomes, see `opportunity-scoring`. I can complete the JTBD portion and recommend which outcomes to feed into those skills."
