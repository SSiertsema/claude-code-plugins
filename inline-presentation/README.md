# inline-presentation

A Claude Code skill that automatically detects when a response contains structured or relational data and renders it inline using a fixed catalog of CLI-friendly presentation forms. No more "can you make this visual?" — the assistant anticipates.

## What it does

When the assistant is about to produce a response containing structured data, this skill classifies the datatype and applies the agreed presentation form from a fixed catalog of 8 forms.

| Datatype | Presentation form |
|---|---|
| Process / flow | Vertical fully-drawn ASCII flowchart |
| Relational | ER-style with boxes and lines |
| Hierarchical | Tree view (file-explorer style) |
| Time-series / planning | Gantt-style horizontal bars |
| Comparative | Side-by-side cards with pros/cons |
| Key-value | Two-column table with header separator only |
| Numeric / proportion | Horizontal bar with percentage |
| Set / categorical | Cluster cards |

## Why this skill

- The Claude Code CLI cannot render Mermaid, LaTeX, HTML, or images
- Plain prose is suboptimal for structured data — tables, diagrams, and bars communicate faster
- The catalog provides a consistent visual language across sessions

## Constraints

- **CLI-only**: output uses CommonMark + UTF-8 box-drawing characters (`┌─┐│└┘├┤┬┴┼`)
- **No Mermaid, no LaTeX, no images, no HTML**
- **No color conventions**: no diff-blocks or syntax-highlight tricks for meaning — output is purely structural
- **8-item catalog**: datatypes outside the catalog fall back to plain text

## How to activate by default

The skill becomes more reliable when referenced from a CLAUDE.md file. Add this line to your global `~/.claude/CLAUDE.md`:

```
- before producing any response that contains structured or relational data (process/flow, relational, hierarchical, time-series/planning, comparative, key-value, numeric/proportion, set/categorical), invoke the `inline-presentation` skill to render it inline using the agreed catalog form. Default to plain text only when no datatype matches.
```

Without this line the skill still works but relies entirely on description-matching, which becomes less reliable as more skills are loaded.

## Examples

### Process detection

Input intent: "When a user asks a question, the assistant first classifies the data type. If structured, it renders inline. If not, it produces plain text."

Output:

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

### Key-value detection

Input intent: "Anna de Vries is a Senior Developer in Utrecht."

Output:

```
┌──────────────┬───────────────────┐
│ Field        │ Value             │
├──────────────┼───────────────────┤
│ Name         │ Anna de Vries     │
│ Role         │ Senior Developer  │
│ Location     │ Utrecht           │
└──────────────┴───────────────────┘
```

## Customizing the catalog

Edit `skills/inline-presentation/SKILL.md`. The canonical examples in the "Catalog" section define the visual style — change them, and the assistant will follow.

## License

MIT
