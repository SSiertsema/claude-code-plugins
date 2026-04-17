# Example Mapping — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | example-mapping |
| **Version** | 1.0.0 |
| **Purpose** | Runs a Matt Wynne example-mapping session to refine a user story before development. 25–30 minute time-boxed workshop with four card types: yellow (single user story), blue (rules / abstract acceptance criteria), green (concrete examples illustrating rules — with specific data), red (questions / unknowns — recorded, not debated in-session). Produces structured card output with rules + attached examples + open questions, explicit ready-or-not verdict with rationale (READY / MARGINAL / NOT READY), post-session action items for red cards (who answers, by when), and draft acceptance criteria extractable from blues + greens that feed directly into `acceptance-criteria-writing` for Gherkin formalization. Two modes: `facilitation` (session guide for live workshop) and `documentation` (structure completed session's cards retrospectively). Verdict criteria: READY = ≤1 red + every blue has ≥2 greens + yellow specific; MARGINAL = 2–3 reds closeable within 1 day; NOT READY = >3 reds OR blue without green OR yellow vague. Mermaid card layout + distribution pie with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `extraction` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Pre-development story refinement — catching ambiguity before coding
- Three Amigos (product + dev + QA) collaborative session
- Backlog refinement to detect stories not ready for sprint
- Discovery follow-up after user research / story mapping
- Pairs with `acceptance-criteria-writing` (turns draft AC into formal Gherkin) and `story-splitting` (if session reveals story too big)

## When not to use

- Writing the user story itself → `user-story-generator`
- Full Gherkin acceptance criteria → `acceptance-criteria-writing`
- Splitting oversized stories → `story-splitting`
- Sprint planning / estimation → `planning-poker-protocol` + `story-point-estimation`
- Strategic user research synthesis → `affinity-diagramming` / `mental-model-diagramming`

---

## Required input

| Field | Description |
|---|---|
| **Story to refine** | User story (yellow card content) |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Mode** | facilitation / documentation | facilitation |
| **Participants** | Roles + count | Asked (ideal: PO + dev + QA + design) |
| **Time budget** | Session duration | 30 min |
| **Domain context** | For plausible examples | Elicit |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/example-mapping/` |

## Input schema

```
input:
  required:
    story:
      type: string
  optional:
    mode:
      type: string
      enum: [facilitation, documentation]
      default: facilitation
    participants: object
    time_budget_minutes:
      type: integer
      default: 30
    domain_context: string
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
Collect story + mode + participants.

### Phase 2 — Four card types
Yellow / Blue / Green / Red conventions.

### Phase 3 — Session protocol
Setup → story read → rule-brainstorm → example-brainstorm → question handling → verdict.

### Phase 4 — Card layout
Yellow top, blues below, greens under blues, reds aside.

### Phase 5 — Verdict
READY / MARGINAL / NOT READY with rationale.

### Phase 6 — Output artifacts
Card list + verdict + post-session actions + draft AC.

### Phase 7 — Facilitation mode
Session guide + artifacts.

### Phase 8 — Documentation mode
Retrospectively structure completed session.

### Phase 9 — Diagrams
Card layout + distribution.

### Phase 10 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 11 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Example Mapping: [Story]

**Date**: [date]
**Mode**: [facilitation / documentation]
**Story**: [yellow]
**Participants**: [roles + count]
**Duration**: [minutes]
**Verdict**: [READY / MARGINAL / NOT READY]

## Scope
[Story, mode, participants, time]

## Cards
### Yellow (Story)
[Content]

### Blue (Rules)
[List]

### Green (Examples)
[Grouped under rules]

### Red (Questions)
[List with context]

## Ready-or-not Verdict
[Verdict + rationale]

## Post-session Actions
[Per red: who / when / expected outcome]

## Draft Acceptance Criteria
[Blues + greens structured for Gherkin conversion]

## Diagrams
[Card layout + distribution]

## Facilitator Guide (facilitation mode)
[Protocol + timer + artifacts]

## Assumptions & Limitations
[Attendance gaps, caveats]
```

### Diagrams

- **Card layout** — Mermaid `flowchart` (yellow → blues → greens)
- **Card distribution** — Mermaid `pie`

---

## Generation and extraction policy

- Four card types only
- Examples attached to rules
- Questions recorded, not debated
- Verdict explicit
- Time-boxed
- No fabricated examples

---

## Self-check

```
[] Yellow specific
[] Blues present
[] Every blue has ≥1 green
[] Reds recorded separately
[] Verdict with rationale
[] Post-session actions
[] Draft AC extractable
[] ≤30 min
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No story | Interview mode (§7) |
| Vague yellow | Refine first |
| Abstract-only (no greens) | Flag weak rules |
| >5 reds | NOT READY; clarify |
| >30 min | Likely too-big story; recommend split |
| Wrong participant mix | Flag |
| mmdc failure | See `diagram-rendering` mixin |
| Code-writing request | Out-of-scope |

---

## Quality checks

- [ ] All four card types
- [ ] Examples under rules
- [ ] Reds isolated
- [ ] Verdict clear
- [ ] Actions per red
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Discount code story**
- Input: "As a customer I want to use a discount code so I can save"
- Expected: 4 blues (validity rules, expiry, stackability, subtotal applicability), 8 greens (specific scenarios), 2 reds (stacking with loyalty, cart-reload timing). Verdict MARGINAL: reds answerable within day. Draft AC ready for Gherkin.

**2. Age-restricted purchase**
- Input: "As a retailer I want to prevent underage purchases of restricted items"
- Expected: Blues cover age check, item classification, parental consent options. Greens include 17-year-old attempts, 18-on-day-of-order edge, ID-verification flow. Reds: "what's legal age by jurisdiction", "ID-upload vs attestation".

**3. Documentation mode for completed session**
- Input: Team held informal session, raw card photos
- Expected: Structure into 4-card-type report, assign reads per red to owners, produce draft AC. Flag if raw session had debated reds (against protocol) in retrospect.

**4. Refinement before sprint**
- Input: 3 stories on upcoming sprint candidates, each gets a session
- Expected: 3 reports, verdicts help prioritize what's sprint-ready vs needs more discovery.

**5. Ready verdict with clean card layout**
- Input: Well-refined story
- Expected: READY verdict, 3 blues with 2–3 greens each, 0 reds, draft AC feeds straight to `acceptance-criteria-writing`.

### Edge cases

**6. Yellow card is actually epic**
- Input: "As a user I want a great shopping experience"
- Expected: Refuse to proceed; recommend splitting into user-goal-level stories first.

**7. All rules, no examples surface**
- Input: Team articulates rules but can't produce concrete scenarios
- Expected: Flag — either rules are vague / fake OR team lacks domain knowledge. Recommend bringing SME or user research.

**8. Reds cluster in one area**
- Input: 6 reds all about permissions model
- Expected: Flag — permissions model is missing foundation; recommend separate discovery before refining this story further.

### Failure cases

**9. No story**
- Input: "Do example mapping"
- Expected: Interview — "Which story do you want to refine?"

**10. Out of scope**
- Input: "Example mapping + write all the code"
- Expected: "Example mapping refines stories. Coding is engineering work; AC feeds `acceptance-criteria-writing` first."
