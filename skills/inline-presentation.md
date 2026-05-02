# Inline Presentation — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | inline-presentation |
| **Version** | 1.0.0 |
| **Purpose** | Detects when an assistant response contains structured or relational data and renders it inline using a fixed catalog of CLI-friendly presentation forms (markdown + ASCII/Unicode). Operates by default in every session — the assistant anticipates the right visual form so the user does not need to ask "can you make this visual?". |
| **Primary category** | `transformation` |
| **Secondary category** | `classification` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Preservation mode** | `balanced` |
| **Mixins** | none |

---

## When to use

- The assistant is about to produce a response containing one of 8 recognized data types: process/flow, relational, hierarchical, time-series/planning, comparative, key-value, numeric/proportion, set/categorical
- Detection signals are present: steps + decisions, entities + references, parent-child taxonomies, milestones with dates, multi-object same-criteria comparisons, single objects with N attributes, percentages/scores, items grouped in buckets

## When not to use

- Plain narrative answers without structured data
- Pure code review or code-only output
- Single-sentence or single-value answers
- Data types outside the 8-item catalog → fallback to plain text
- Non-CLI interfaces (out of scope, but skill does not enforce this)

---

## Preservation policy

| Aspect | Declaration |
|---|---|
| **Facts** | All facts must be preserved |
| **Meaning** | Exact meaning |
| **Structure** | Restructure allowed (text → spatial layout) |
| **Tone** | Preserve tone |
| **Terminology** | Preserve domain terms |
| **Named entities** | Must preserve exactly |
| **Formatting** | Adapt to output format (the whole point of the skill) |

**What may change**: structure, formatting, length (slight increase due to ASCII rendering).

**What may NOT change**: facts, named entities, numeric values, exact terminology, semantic meaning.

---

## Required input

| Field | Description |
|---|---|
| **Planned response content** | The structured data the assistant is about to render (implicit — operates on the assistant's own planned response) |

## Optional input

| Field | Description | Default |
|---|---|---|
| **User override** | User explicitly requests a different presentation form ("show as table" / "as flowchart") | None — auto-detect |

## Input schema

```
input:
  required:
    planned_response_content:
      type: string
      description: "The structured/relational data the assistant intends to convey"
  optional:
    user_override:
      type: string
      description: "Explicit user request for a specific presentation form"
      default: null
```

---

## Processing rules

### Phase 1 — Detect

Inspect the planned response for structured-data signals using the heuristics:

| Signal | Likely datatype |
|---|---|
| Steps, decisions, "if X then Y", branching logic | Process / flow |
| Entities with cross-references, foreign keys, "X has N Y's" | Relational |
| Categories with sub-categories, parent-child, taxonomies | Hierarchical |
| Milestones, sprints, phases with start/end dates | Time-series / planning |
| Multiple objects compared on the same criteria/attributes | Comparative |
| One object with N attributes (config, profile, status) | Key-value |
| Percentages, progress, scores, ratios | Numeric / proportion |
| Items grouped into buckets without parent-child hierarchy | Set / categorical |

If no signal matches confidently → skip the skill, produce plain text.

### Phase 2 — Classify

Pick the dominant datatype. If multiple datatypes mix (e.g., a comparative table that also has hierarchical sub-items):
- Choose the dominant one
- Or split: render each section in its own appropriate form

### Phase 3 — Render

Apply the catalog form for the detected datatype (see Output contract below).

### Phase 4 — Validate preservation

Before emitting, verify:
- All facts from the planned response appear in the rendered form
- Named entities are spelled exactly as intended
- Numeric values match the source
- No fabricated data was added

If any check fails → adjust or fallback to plain text.

### Rules

- **No color conventions**: do not use diff-blocks, syntax-highlight tricks, or other coloring patterns to encode meaning. Output is purely structural.
- **No Mermaid, LaTeX, HTML, or images**: these do not render in the Claude Code CLI.
- **Conservative detection**: when in doubt, default to plain text.
- **User override wins**: if the user explicitly asks for a different form, follow the user.
- **Use UTF-8 box-drawing characters** (`┌─┐│└┘├┤┬┴┼`) consistently within a single rendering.

---

## Output contract

The presentation catalog. Each datatype maps to exactly one canonical form.

### P-1: Process / flow → vertical fully-drawn ASCII flowchart

Boxes connected by `│` and `▼`, branching with labeled arrows (Yes/No), spatial generosity over compactness.

```
                    ┌──────────────────────┐
                    │ User asks question   │
                    └──────────┬───────────┘
                               │
                               ▼
                  ┌────────────────────────┐
                  │ Does response contain  │
                  │ structured data?       │
                  └──┬──────────────────┬──┘
                 No  │                  │  Yes
                     ▼                  ▼
            ┌──────────────┐   ┌────────────────┐
            │ Plain text   │   │ Which datatype?│
            └──────────────┘   └────────────────┘
```

### P-2: Relational → ER-style with boxes and lines

Entity boxes with attributes, lines between entities, cardinality indicated with `1`, `N`, `◄──`, `──►`.

```
       ┌─────────────┐               ┌─────────────┐
       │   CUSTOMER  │               │   ORDER     │
       ├─────────────┤      1     N  ├─────────────┤
       │ id          │◄──────────────┤ customer_id │
       │ name        │               │ id          │
       │ email       │               │ date        │
       └─────────────┘               └─────────────┘
```

### P-3: Hierarchical → tree view (file-explorer style)

`├──`, `└──`, `│` characters with consistent indentation per level.

```
Products/
├── Electronics/
│   ├── Phones/
│   └── Computers/
├── Clothing/
│   └── Men
└── Books/
```

### P-4: Time-series / planning → Gantt-style horizontal bars

Items as rows, `████` for filled periods, `░░░░` for empty, column headers for time units.

```
                     Wk1   Wk2   Wk3   Wk4   Wk5
Research            ████████░░░░░░░░░░░░░░░░░░░░░
Design              ░░░░░░░░████████████░░░░░░░░░
Build               ░░░░░░░░░░░░░░░░████████████░
```

### P-5: Comparative → side-by-side cards with pros/cons

Each object as `┌─ Name ─┐` card placed side-by-side. Inside each card: a "Pros" section and a "Cons" section, **without** a separator line between them.

```
┌─ PostgreSQL ─────────────┐  ┌─ MySQL ──────────────────┐
│                          │  │                          │
│  Pros                    │  │  Pros                    │
│  + Strong JSON support   │  │  + Wide community        │
│  + Strict schema         │  │  + Mature tooling        │
│                          │  │                          │
│  Cons                    │  │  Cons                    │
│  - Vertical scaling      │  │  - Limited JSON          │
│  - Steep learning curve  │  │  - Vertical scaling      │
└──────────────────────────┘  └──────────────────────────┘
```

### P-6: Key-value → two-column table, header separator only

Outer border + a single header separator line. **No** horizontal lines between data rows.

```
┌──────────────┬───────────────────┐
│ Field        │ Value             │
├──────────────┼───────────────────┤
│ Name         │ Anna de Vries     │
│ Role         │ Senior Developer  │
│ Location     │ Utrecht           │
│ Status       │ Active            │
└──────────────┴───────────────────┘
```

### P-7: Numeric / proportion → horizontal bar with percentage

Label + `████░░░░` fill + percentage or value at the end.

```
Sprint progress     ████████████████░░░░░░░░  64%
CPU usage           ███████████████████████░  92%
Disk space free     ██████░░░░░░░░░░░░░░░░░░  25%
```

### P-8: Set / categorical → cluster cards

Each group as a `┌─ Name (n) ─┐` card with items as bullets inside. Cards placed side-by-side.

```
┌─ Backend (3) ─────────┐  ┌─ Frontend (3) ────────┐
│                       │  │                       │
│  • api-server         │  │  • web-app            │
│  • auth-service       │  │  • mobile-app         │
│  • data-pipeline      │  │  • admin-portal       │
│                       │  │                       │
└───────────────────────┘  └───────────────────────┘
```

---

## Self-check

```
□ Was a structured-data signal detected before applying the skill?
□ Was the correct catalog form (P-1 to P-8) applied for the detected datatype?
□ Are all facts from the planned response preserved in the rendered output?
□ Are named entities and numeric values intact?
□ Was no color convention introduced (no diff-blocks, no syntax-highlight tricks)?
□ Was no Mermaid, LaTeX, HTML, or image syntax used?
□ Is the output rendered in monospace and within reasonable line width (~120 chars)?
□ If detection was uncertain, did the skill fallback to plain text?
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No structured-data signal detected | Skip the skill, produce plain text |
| Multiple competing signals (e.g., comparative + hierarchical) | Choose the dominant one; if equal, split into sections per form |
| Datatype outside the 8-item catalog | Fallback to plain text — do not invent a new form |
| User override conflicts with auto-detection | User wins — apply the requested form |
| Rendering would exceed reasonable line width (>120 chars) | Use a more compact variant (e.g., tabular form for proportions instead of bar) or fallback to plain text |
| Required information is missing or fabricated | Do not render — produce plain text and request clarification |

---

## Quality checks

- **Anticipation**: in a session of normal length, the user should not need to ask "can you make this visual?" for any of the 8 datatypes.
- **Catalog fidelity**: the rendered form for each datatype matches the canonical example exactly in structural style.
- **Preservation**: facts, named entities, and numeric values match the planned response content.
- **No fabrication**: no data is added that was not in the planned response.
- **Conservative detection**: when in doubt, the skill defaults to plain text rather than over-applying.
- **CLI compatibility**: output renders correctly in monospace; no Mermaid, LaTeX, HTML, or images used.

---

## Examples

### Normal cases

#### Example 1 — Process / flow detected

**Planned response** (before skill): "When a user asks a question, the assistant first checks if the response contains structured data. If yes, it classifies the datatype. If no, it produces plain text."

**Output (after skill, P-1 form)**:

```
                    ┌──────────────────────┐
                    │ User asks question   │
                    └──────────┬───────────┘
                               │
                               ▼
                  ┌────────────────────────┐
                  │ Does response contain  │
                  │ structured data?       │
                  └──┬──────────────────┬──┘
                 No  │                  │  Yes
                     ▼                  ▼
            ┌──────────────┐   ┌────────────────┐
            │ Plain text   │   │ Classify type  │
            └──────────────┘   └────────────────┘
```

#### Example 2 — Relational detected

**Planned response**: "A customer can have many orders. Each order belongs to one customer and contains one or more order lines. Each order line refers to a product."

**Output (P-2 form)**:

```
       ┌─────────────┐               ┌─────────────┐
       │   CUSTOMER  │               │   ORDER     │
       ├─────────────┤      1     N  ├─────────────┤
       │ id          │◄──────────────┤ customer_id │
       │ name        │               │ id          │
       └─────────────┘               └──────┬──────┘
                                            │ 1
                                            │
                                            │ N
                                     ┌──────┴──────┐
                                     │ ORDER_LINE  │
                                     ├─────────────┤
                                     │ id          │
                                     │ product_id  │
                                     └─────────────┘
```

#### Example 3 — Key-value detected

**Planned response**: "Anna de Vries is a Senior Developer in Utrecht, on the Platform team, currently active."

**Output (P-6 form)**:

```
┌──────────────┬───────────────────┐
│ Field        │ Value             │
├──────────────┼───────────────────┤
│ Name         │ Anna de Vries     │
│ Role         │ Senior Developer  │
│ Location     │ Utrecht           │
│ Team         │ Platform          │
│ Status       │ Active            │
└──────────────┴───────────────────┘
```

#### Example 4 — Numeric / proportion detected

**Planned response**: "Sprint progress is 64%, CPU usage is at 92%, and disk space is 25% free."

**Output (P-7 form)**:

```
Sprint progress     ████████████████░░░░░░░░  64%
CPU usage           ███████████████████████░  92%
Disk space free     ██████░░░░░░░░░░░░░░░░░░  25%
```

#### Example 5 — Set / categorical detected

**Planned response**: "Backend services include api-server, auth-service, and data-pipeline. Frontend includes web-app, mobile-app, and admin-portal."

**Output (P-8 form)**:

```
┌─ Backend (3) ─────────┐  ┌─ Frontend (3) ────────┐
│                       │  │                       │
│  • api-server         │  │  • web-app            │
│  • auth-service       │  │  • mobile-app         │
│  • data-pipeline      │  │  • admin-portal       │
│                       │  │                       │
└───────────────────────┘  └───────────────────────┘
```

### Edge cases

#### Example 6 — Mixed datatypes (comparative + hierarchical)

**Planned response**: Comparing two architecture options, where each option also has a sub-component breakdown.

**Behavior**: choose dominant form (comparative → P-5), and within each card render the sub-components as nested bullets rather than introducing a separate tree view.

#### Example 7 — Very short structured data (3 key-value pairs)

**Planned response**: "Status: active, Owner: Anna, Priority: high"

**Behavior**: still apply P-6 (key-value table). Conservative detection does not mean "skip if small" — it means "skip if unclear".

#### Example 8 — Borderline case: a single percentage

**Planned response**: "The build succeeded with 87% test coverage."

**Behavior**: skip the skill — a single value embedded in a sentence does not warrant a bar chart. P-7 applies when there are multiple proportions to compare.

### Failure cases

#### Example 9 — Datatype outside catalog (geospatial data)

**Planned response**: "The three offices are located in Amsterdam, Utrecht, and Rotterdam, with the Amsterdam office being the largest."

**Behavior**: fallback to plain text. No catalog form fits geospatial data; the skill does not invent a new form.

#### Example 10 — Fabrication risk

**Planned response**: "Several services are operational." (no specific data)

**Behavior**: do not render any visual form. There is no concrete data to preserve. Produce plain text.

---

## Activation mechanism

This skill is intended to operate by default across all Claude Code sessions. Activation:

1. Skill file at `.claude/skills/inline-presentation/SKILL.md`
2. A reference line is added to global `~/.claude/CLAUDE.md` so the LLM keeps the skill top-of-mind across all sessions
3. The skill is selected via description-matching when the assistant detects structured data in a planned response

---

## Test cases

### Normal cases (must produce expected catalog form)

1. Process description with steps and decisions → P-1 flowchart
2. Entity description with relationships and cardinality → P-2 ER diagram
3. Hierarchical taxonomy (categories with sub-categories) → P-3 tree view
4. Project planning with phases over weeks → P-4 Gantt
5. Comparison of 2+ tools/options on same criteria → P-5 side-by-side cards
6. Single object with multiple attributes → P-6 key-value table
7. Multiple percentages or proportions → P-7 horizontal bars
8. Items grouped into buckets without hierarchy → P-8 cluster cards

### Edge cases

1. Mixed datatypes in one response → choose dominant or split
2. Very small dataset (2-3 items) → still apply if detection is clear
3. Very wide content that exceeds reasonable line width → use compact variant or fallback

### Failure cases

1. Datatype outside catalog (e.g., geospatial, audio, video) → plain text fallback
2. No concrete data to preserve → no rendering, plain text

---

## What this skill does NOT do

- No color conventions (no diff-blocks, no syntax-highlight tricks for visual meaning)
- No Mermaid, LaTeX, images, or interactive elements
- No presentation forms beyond the 8-item catalog — fallback to plain text
- No on-the-fly per-user customization — preferences are fixed (modify by editing the skill)
- No enforcement on non-CLI interfaces (out of scope)
