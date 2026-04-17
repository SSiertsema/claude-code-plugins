# Concept Sketching — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | concept-sketching |
| **Version** | 1.0.0 |
| **Purpose** | Produces low-fidelity concept sketches for a design challenge as structured text-based equivalents: concept briefs, storyboard panels, low-fi wireflows (Mermaid flowcharts), key touchpoint specs, and design annotations. Default mode is `comparison` — generates 2–4 meaningfully different concept variants on a declared differentiation axis, with a comparison table and a recommended next step. Also supports `autonomous` (single concept) and `elaboration` (elaborate an existing concept) modes. Stays at concept level; detailed wireframing, visual design, and prototyping belong in Phase 4 skills. |
| **Primary category** | `generation` |
| **Secondary category** | — |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `high` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- User has a design / product challenge and wants multiple conceptual directions side-by-side
- User wants to move from a brainstorm idea or HMW to a tangible concept design
- User wants an existing concept elaborated with storyboard + flow + touchpoint specs
- User needs input for a designer to start detailed work from
- Upstream of detailed wireframing and prototyping (Phase 4)

## When not to use

- High-fidelity wireframes or interactive prototypes → Phase 4 `wireframing` / `prototyping` (future)
- UI component design or design system work → Phase 4 visual/UI design (future)
- User flow diagramming of an existing product → `user-flow-diagramming` (Phase 4, future)
- Broad idea generation without design focus → `brainstorming`
- Concept validation with real users → user research skills
- Technical architecture → Phase 5 skills
- Pixel-level layout, color, typography decisions

---

## Required input

| Field | Description |
|---|---|
| **Design challenge** | Brief, HMW question, problem statement, or business case reference |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Mode** | `autonomous` / `comparison` / `elaboration` | `comparison` |
| **Concept count** | Number of variants (2–4) | 3 |
| **Target audience** | Primary persona or user type | Inferred / `[Assumed]` |
| **Platform / medium** | web / mobile / service / physical / cross-platform | Ask or `[Assumed]` |
| **Constraints** | Technical, brand, accessibility, regulatory | None |
| **Existing concept** | For elaboration mode | — |
| **Storyboard length** | 3–6 panels | 4 |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/concept-sketching/` |

## Input schema

```
input:
  required:
    challenge:
      type: string | document_reference
  optional:
    mode:
      type: string
      enum: [autonomous, comparison, elaboration]
      default: comparison
    concept_count:
      type: integer
      min: 1
      max: 4
      default: 3
    audience:
      type: string
    platform:
      type: string
      enum: [web, mobile, service, physical, cross-platform]
    constraints:
      type: list[string]
    existing_concept:
      type: string | document_reference
      description: "Required if mode = elaboration"
    storyboard_length:
      type: integer
      min: 3
      max: 6
      default: 4
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

1. Collect challenge; enter interview mode (§7) if missing/vague
2. Detect mode, count, audience, platform, constraints, storyboard length
3. Confirm scope with user
4. Ask render mode (per `diagram-rendering` mixin) and output path

### Phase 2 — Concept framing

Establish the shared frame every variant must address:
- **Primary user**
- **Primary goal**
- **Primary context**
- **Success definition**

Variants differ in *how*, not *what*.

### Phase 3 — Concept generation

- **Comparison mode**: Declare a differentiation axis (e.g., guided vs self-service, AI-assisted vs manual, linear vs exploratory). Each concept occupies a distinct position on that axis.
- **Autonomous mode**: Single best concept — same content sections, no variants.
- **Elaboration mode**: Preserve the user's original concept. Flag any adjustments explicitly.

### Phase 4 — Per-concept content

Per concept, produce:
1. **Concept card**: name, elevator pitch, differentiator, target moment
2. **Storyboard** (3–6 panels): setting, user action, visual description, caption
3. **Wireflow** (Mermaid flowchart): 3–8 screens/touchpoints with labeled transitions and terminal outcome
4. **Key touchpoint specs** (3–5): purpose, primary elements (3–5 bullets), primary interaction, success state
5. **Annotations** (3–6): key design decisions with rationale, assumptions labeled `[Assumed]`

### Phase 5 — Optional sequence diagram

For multi-actor concepts (services, multi-user products), add a Mermaid `sequenceDiagram`.

### Phase 6 — Comparison table

Comparison mode only. Dimensions: differentiator, audience fit, build complexity, key risk, novelty, best for.

### Phase 7 — Next-step recommendation

One paragraph: which concept to prototype first, referencing audience fit, differentiator, complexity, biggest assumption to validate.

### Phase 8 — Diagrams rendering

Per `diagram-rendering` mixin. File names:
- `concept-[n]-wireflow.mmd` / `.png`
- `concept-[n]-sequence.mmd` / `.png` (only if produced)

### Phase 9 — Report assembly and approval

Full report; present for approval; save only after confirmation.

---

## Output contract

### Report structure

```markdown
# Concept Sketches: [Challenge]

**Date**: [date]
**Mode**: [autonomous / comparison / elaboration]
**Concept count**: [N]
**Audience**: [persona / user type]
**Platform**: [platform]
**Differentiation axis** (comparison mode): [axis]

## Challenge & Framing
[HMW + primary user, goal, context, success]

## Shared Frame
[Common user, goal, context across concepts]

## Concept 1: [Name]
[Card + storyboard table + wireflow diagram + touchpoint specs + annotations]

## Concept 2: [Name]
[...]

## Concept 3: [Name]
[...]

## Comparison
[Comparison table across consistent dimensions]

## Recommended Next Step
[One paragraph with rationale + biggest assumption to validate]

## Assumptions & Limitations
[Explicit list; `[Assumed]` items; note scope boundaries]
```

### Diagrams

- **Wireflow per concept** — Mermaid `flowchart` with 3–8 screens/touchpoints, labeled transitions, terminal outcome
- **Sequence diagram** (optional, multi-actor only) — Mermaid `sequenceDiagram`

In `code` mode: Mermaid code blocks. In `image` mode: PNG via `mmdc` per `diagram-rendering` mixin.

---

## Generation policy

| Aspect | Declaration |
|---|---|
| **What may be invented** | Concept names, elevator pitches, storyboard scenarios, wireflow screens, element lists, interaction patterns, design rationale, touchpoint specs |
| **What must be grounded** | Design challenge, audience (if supplied), platform, constraints, existing concept (elaboration mode) |
| **What assumptions are allowed** | Persona details, platform defaults, user context — label `[Assumed]` |
| **What must never be fabricated** | User quotes as real, competitor features as reference, statistics, citations, specific brand/product claims |

---

## Self-check

```
[] Shared frame (user, goal, context, success) stated
[] Comparison mode: 2–4 concepts on a declared differentiation axis
[] Autonomous mode: 1 concept with same content depth
[] Elaboration mode: original concept preserved, adjustments flagged
[] Every concept has elevator pitch in 1 sentence
[] Every storyboard has 3–6 panels with narrative arc
[] Every wireflow has 3–8 screens/touchpoints + labeled transitions + terminal outcome
[] Every concept has 3–5 key touchpoint specs (purpose, elements, interaction, success)
[] Every concept has 3–6 annotations with rationale
[] Sequence diagrams only for multi-actor concepts
[] Comparison table uses consistent dimensions
[] Next-step recommendation identifies biggest assumption
[] All Mermaid diagrams render valid syntax
[] No fabricated user quotes, competitor features, statistics, or citations
[] Assumptions labeled `[Assumed]`
[] Visual descriptions describe layout regions + key elements, not pixel specs
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No challenge provided | Interview mode (§7) |
| Challenge too abstract or purely technical | Reframe as user-facing challenge, confirm |
| Platform unclear | Ask; if declined, assume and label `[Assumed]` |
| Cannot find meaningful differentiation | 2 concepts with honest note, or single concept in autonomous mode |
| Elaboration mode, original concept unclear | Interview to clarify before elaborating |
| Mermaid render failure | See `diagram-rendering` mixin |
| Out-of-scope (pixel-level, component library, detailed wireframes) | "This skill produces low-fi concept sketches. Detailed wireframing and visual design belong in Phase 4 skills." |

---

## Quality checks

- [ ] Shared frame stated
- [ ] 2–4 distinct concepts (or 1 in autonomous mode)
- [ ] Differentiation axis declared in comparison mode
- [ ] Storyboards have narrative arc (trigger → attempt → resolution → outcome)
- [ ] Wireflows include terminal outcome nodes
- [ ] Touchpoint specs complete (purpose + elements + interaction + success)
- [ ] Annotations include design rationale
- [ ] Comparison table consistent across dimensions
- [ ] Next-step recommendation with rationale
- [ ] All diagrams render valid Mermaid
- [ ] No fabricated quotes, features, stats, or citations
- [ ] Assumptions labeled
- [ ] No pixel-level or visual-design content
- [ ] Output saved to agreed path only after approval

---

## Examples

### Normal cases

**1. Comparison mode, mobile app**
- Input: "How might we help freelancers log expenses on the go?"
- Expected: 3 concepts on axis "friction vs accuracy" — (1) "One-tap photo capture" (low friction, manual categorization), (2) "AI receipt scanner" (low friction, auto-category), (3) "Voice-note logger" (very low friction, async review). Each with 4-panel storyboard, wireflow with 4–5 screens, 3–5 touchpoint specs, annotations. Comparison table, recommended next step with biggest assumption ("users trust AI categorization without review").

**2. Comparison mode, service design**
- Input: "Improve the onboarding experience for new employees at a mid-size company"
- Expected: 3 concepts on axis "self-directed vs guided" — each with multi-actor sequence diagram (new hire, buddy, HR, manager), storyboards covering day 1 / week 1 / month 1, touchpoints (welcome email, kit, portal, buddy session).

**3. Autonomous mode, web app**
- Input: "Design a concept for a team retrospective tool for remote teams"
- Expected: 1 concept, full depth — card, 4-panel storyboard (from meeting trigger to action items), wireflow with 5 screens, 4 touchpoint specs, 5 annotations, assumptions labeled.

**4. Elaboration mode**
- Input: User provides rough concept: "A community-led learning platform where peers teach peers in short live sessions" + elaboration = yes
- Expected: Preserves the peer-teaching core, adds 4-panel storyboard (learner discovers session → books → attends → rates), wireflow, touchpoints (discovery, booking, live room, feedback), annotations including `[Assumed]` session length.

**5. Cross-platform challenge**
- Input: "Concept for a habit-tracking product that works on mobile, desktop, and smartwatch"
- Expected: 3 concepts — (1) "Mobile-first with glance widgets", (2) "Watch-first quick logging", (3) "Desktop planning + mobile execution". Each wireflow shows touchpoints per device.

### Edge cases

**6. Very abstract challenge**
- Input: "Reimagine work"
- Expected: Reframe step — model proposes narrowing (e.g., "Reimagine how teams plan quarterly work"), confirms, proceeds. Flags `[Assumed]` narrowing.

**7. Purely technical challenge**
- Input: "Design a concept for our new caching layer API"
- Expected: Reframe as developer-facing challenge (DX); audience becomes "API consumers". Concepts compare on API-shape axis (REST vs GraphQL-style, auto-invalidation vs manual). Touchpoints become endpoints/docs/SDK methods rather than screens.

**8. Single-axis deadlock**
- Input: Brief where concepts end up nearly identical on every axis
- Expected: Produces 2 concepts (not 3), notes the natural convergence explicitly in Comparison and Assumptions. Recommends single prototype path with variants for specific details.

### Failure cases

**9. No challenge**
- Input: "Sketch some concepts"
- Expected: Interview mode — "What is the design challenge or brief you want concepts for?"

**10. Out of scope**
- Input: "Produce pixel-perfect Figma-ready wireframes with final copy for all screens"
- Expected: "This skill produces low-fi concept sketches (storyboards, wireflows, touchpoint specs). Pixel-perfect wireframes with final copy belong in Phase 4 wireframing / visual-design skills. I can proceed with concept-level sketches."
