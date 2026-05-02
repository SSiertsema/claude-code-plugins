---
name: inline-presentation
description: Apply this skill before producing responses that contain structured or relational data. Detects the datatype (process, relational, hierarchical, time-series, comparative, key-value, numeric/proportion, or set/categorical) and renders it inline using a fixed catalog of CLI-friendly forms (ASCII flowcharts, tree views, ER-style diagrams, Gantt bars, side-by-side cards, two-column tables, horizontal bars, cluster cards) instead of plain prose. Operates by default — the assistant anticipates the right visual form so the user does not have to ask "can you make this visual?".
argument-hint: "[optional: explicit form override, e.g. 'as flowchart']"
---

# Inline Presentation

You apply this skill **before producing any response that contains structured or relational data**. Your goal: detect the datatype, classify it into one of 8 categories, and render it using the agreed catalog form. The user should never need to ask "can you make this visual?".

## When to apply

Apply when the planned response contains one of these structured-data signals:

| Signal | Datatype |
|---|---|
| Steps, decisions, "if X then Y", branching logic | Process / flow → P-1 |
| Entities with cross-references, foreign keys, "X has N Y's" | Relational → P-2 |
| Categories with sub-categories, parent-child, taxonomies | Hierarchical → P-3 |
| Milestones, sprints, phases with start/end dates | Time-series / planning → P-4 |
| Multiple objects compared on the same criteria | Comparative → P-5 |
| One object with N attributes (config, profile, status) | Key-value → P-6 |
| Multiple percentages, scores, ratios | Numeric / proportion → P-7 |
| Items grouped into buckets without hierarchy | Set / categorical → P-8 |

## When NOT to apply

- Plain narrative responses without structured data
- Pure code review or code-only output
- Single-sentence or single-value answers
- Datatypes outside the 8-item catalog → fallback to plain text
- A single value embedded in a sentence (e.g., "the test coverage is 87%") → not enough to warrant a bar

When in doubt, default to plain text. Conservative detection beats over-application.

## Process

1. **Inspect** the planned response for structured-data signals
2. **Classify** into one of P-1 to P-8 (or skip if no clear match)
3. **Render** using the canonical form below
4. **Verify** facts, named entities, and numeric values are preserved
5. **Emit** — do not include explanatory preamble like "here is the data as a tree"

## Catalog (canonical forms)

### P-1: Process / flow → vertical fully-drawn ASCII flowchart

Boxes connected by `│` and `▼`. Branching with labeled arrows (Yes/No). Spatial generosity over compactness.

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

### P-2: Relational → ER-style with boxes and lines

Entity boxes with attributes. Lines between entities. Cardinality with `1`, `N`, `◄──`, `──►`.

```
       ┌─────────────┐               ┌─────────────┐
       │   CUSTOMER  │               │   ORDER     │
       ├─────────────┤      1     N  ├─────────────┤
       │ id          │◄──────────────┤ customer_id │
       │ name        │               │ id          │
       │ email       │               │ date        │
       └─────────────┘               └─────────────┘
```

### P-3: Hierarchical → tree view

`├──`, `└──`, `│` characters. Consistent indentation per level.

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

Items as rows. `████` for filled, `░░░░` for empty. Column headers for time units.

```
                     Wk1   Wk2   Wk3   Wk4   Wk5
Research            ████████░░░░░░░░░░░░░░░░░░░░░
Design              ░░░░░░░░████████████░░░░░░░░░
Build               ░░░░░░░░░░░░░░░░████████████░
```

### P-5: Comparative → side-by-side cards with pros/cons

Each object as `┌─ Name ─┐` card placed side-by-side. Inside each: a "Pros" section and a "Cons" section, **without** a separator line between them.

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

Each group as `┌─ Name (n) ─┐` card with items as bullets inside. Cards placed side-by-side.

```
┌─ Backend (3) ─────────┐  ┌─ Frontend (3) ────────┐
│                       │  │                       │
│  • api-server         │  │  • web-app            │
│  • auth-service       │  │  • mobile-app         │
│  • data-pipeline      │  │  • admin-portal       │
│                       │  │                       │
└───────────────────────┘  └───────────────────────┘
```

## Hard rules

- **No color conventions**. Do not use `diff` blocks, syntax-highlight tricks, or `+`/`-`/`!` prefixes to encode meaning. Output is purely structural.
- **No Mermaid, LaTeX, HTML, or images**. They do not render in the Claude Code CLI.
- **No fabrication**. Only render data that exists in the planned response. Preserve facts, named entities, and numeric values exactly.
- **No invented forms**. If the datatype does not match P-1 to P-8, fallback to plain text.
- **User override wins**. If the user explicitly requests a different form, follow the user.
- **Use UTF-8 box-drawing characters** (`┌─┐│└┘├┤┬┴┼`) consistently within a single rendering.
- **Stay within ~120 characters wide**. If a form would exceed that, use a more compact variant (e.g., tabular for proportions) or fallback to plain text.

## Mixed datatypes

If a response contains multiple datatypes:
- Pick the dominant form, OR
- Split the response into sections and render each section with its own appropriate form

Do not invent hybrid forms.

## Self-check before emitting

- [ ] Was a structured-data signal detected?
- [ ] Was the correct catalog form (P-1 to P-8) applied?
- [ ] Are all facts, named entities, and numeric values preserved?
- [ ] No color conventions, no Mermaid, no LaTeX, no HTML, no images?
- [ ] Output stays within ~120 characters wide?
- [ ] If detection was uncertain → did the skill fallback to plain text?
