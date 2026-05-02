# kanban-management

A Claude Code skill that transforms `user-story-generator` user stories and optional `user-journey-management` journeys into a central `./kanban.md` at the project root, and renders on-demand visual projections of that data via the `inline-presentation` skill.

## What it does

- Consumes existing user stories (with optional dependency info) and an optional user journey
- Performs an LLM-based analysis step that proposes `blocked_by` / `blocks` relations when source stories miss them
- Topologically ranks stories with unique integer priorities, then iterates with the user
- Writes one canonical `./kanban.md` with `TODO` / `DOING` / `DONE` sections, manually editable
- Reconciles re-runs interactively — never silently overwrites manual status edits
- On request, renders three projections inline: progress %, kanban board, dependency flowchart

## Output format

```markdown
# Project Kanban

## Scope
[Journey context, or "No journey context provided"]

## Stories

### TODO
- **US-001** — Title · priority: 1 · blocked_by: — · blocks: US-002

### DOING
- **US-002** — Title · priority: 3 · blocked_by: US-001 · blocks: —

### DONE
- **US-005** — Title · priority: 4 · blocked_by: — · blocks: —
```

The user manually moves bullet points between sections to update status. Re-running the skill reconciles source changes with manual edits.

## On-demand presentations

| Request | Form |
|---|---|
| `show progress` | P-7 horizontal bar (`Progress  ████████░░░░  N%`) |
| `show kanban` | P-8 three side-by-side cluster cards (TODO / DOING / DONE) |
| `show dependencies` | P-1 ASCII flowchart (boxes + arrows) |

All three rendered via the [`inline-presentation`](../inline-presentation) skill.

## Why this skill

- One canonical file replaces ad-hoc tracking spread across story files
- Manual editing is the primary update path — re-runs only add structure
- Dependency analysis surfaces hidden coupling without requiring explicit pre-work
- Three projections give different insight angles from the same data file

## Constraints

- **Three statuses only**: `TODO`, `DOING`, `DONE` — no backlog / blocked / review
- **One kanban per project**: `./kanban.md` at project root; scope filter narrows which stories appear, not the file
- **Source-stories language**: output follows the language of source stories
- **Stops on cycles**: circular dependencies are not auto-broken; user fixes in source
- **No story creation**: this skill never creates new stories — use `user-story-generator`
- **No story editing**: titles and AC stay in the source files; kanban.md only references

## Related skills

- [`user-story-generator`](../user-story-generator) — produces source stories
- [`user-journey-management`](../user-journey-management) — produces journey context
- [`inline-presentation`](../inline-presentation) — renders the three projections

## License

MIT
