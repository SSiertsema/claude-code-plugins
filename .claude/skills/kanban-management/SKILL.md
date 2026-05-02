---
name: kanban-management
description: Transform user stories (from user-story-generator) and user journeys (from user-journey-management) into a central kanban.md file at the project root. Analyzes dependencies and proposes a numerical priority ordering when missing. The kanban.md is the single source of truth for development status with TODO / DOING / DONE sections, manually editable by moving stories between sections. On a re-run the skill iteratively reconciles changes (new / removed / status conflicts / dependency changes) with the user. On request, renders three projections from the data via inline-presentation - progress percentage (P-7 bar), kanban board (P-8 cluster cards), and dependency flowchart (P-1 ASCII). Stops on circular dependencies and asks the user to fix the source. All stories start in TODO on first run.
argument-hint: "[story paths or dir | 'show progress' | 'show kanban' | 'show dependencies']"
---

# Kanban Management

Transform user stories + optional user journeys into a central `kanban.md` at project root, and produce on-demand inline projections of that data.

## Modes

Detect mode from the invocation argument and the presence of `./kanban.md`:

| Signal | Mode |
|---|---|
| Empty, "update", "generate", file/dir path, or no `kanban.md` yet | **Generate / Update** |
| "show progress" / "voortgang" | **Present P-7** |
| "show kanban" / "show board" | **Present P-8** |
| "show dependencies" / "afhankelijkheden" / "show flowchart" | **Present P-1** |

If ambiguous, ask one disambiguating question.

## Generate / Update mode

### Phase 1 — Setup

1. Check existence of `./kanban.md`. Yes → reconciliation flow (Phase 5). No → first-run flow.
2. Collect bron-stories: ask for paths, directory, or pasted content. Expect `user-story-generator` template structure (story ID, title, optional `Blocked by` / `Blocks`).
3. Optionally collect a user-journey reference for the scope/context section.
4. Detect output language from bron-stories — use it for all generated content.
5. Optionally collect a scope filter (epic / feature).

### Phase 2 — Validate input

Per story:
- Story ID and title are required — if missing, **stop**, report which story is incomplete.
- Note presence or absence of dependency information.

If source files are not in the expected `user-story-generator` template structure: stop, report the mismatch.

### Phase 3 — Dependency analysis

For stories with explicit `Blocked by` / `Blocks`: use them as-is.

For stories without dependency info:
1. Analyze story content (description, acceptance criteria, role, optional journey context) and propose `blocked_by` / `blocks` relations.
2. Present the proposal as a table for review.
3. For unclear pairs, ask one focused question at a time.
4. After consolidation, run cycle detection. On any cycle: **stop**, list the cycle's stories, ask the user to fix in the source.

### Phase 4 — Priority analysis

1. Topological-sort the dependency graph.
2. Within each topological layer, apply content-aware ordering (foundational/simpler/higher-leverage first, based on story content).
3. Assign unique integer ranks `1..N`.
4. Verify: every blocker has a strictly lower rank than what it blocks.
5. Present the ranked list. Iterate with the user until approved.

### Phase 5 — Reconciliation (re-run only)

Diff current `./kanban.md` ↔ source stories. Categorize:

| Category | Action |
|---|---|
| New stories in source | Propose adding (default: append to TODO) |
| Removed stories in source | Propose removal (or archive); ask user |
| Status conflicts (manual edits in kanban) | **Preserve manual status by default**; only reset on explicit user request |
| Dependency changes | Re-run analysis (Phase 3) only on affected sub-graph; propose updates |
| Priority changes implied by new/removed/dep-changes | Propose re-ranking; iterate |

Present each category. Iterate. Never silently overwrite manual edits.

### Phase 6 — Write `./kanban.md`

Format (headers in the source-stories language; the example below is English):

```markdown
# Project Kanban

<!-- Generated and maintained by kanban-management. Move story bullets between TODO / DOING / DONE to update status; re-run the skill to reconcile. -->

## Scope

[2–3 sentences derived from the journey context, or "No journey context provided"]

## Stories

### TODO

- **US-001** — User can register with email · priority: 1 · blocked_by: — · blocks: US-002, US-003
- **US-004** — User can reset password · priority: 2 · blocked_by: — · blocks: —

### DOING

- **US-002** — User can verify email · priority: 3 · blocked_by: US-001 · blocks: —

### DONE

- **US-005** — Persistent session · priority: 4 · blocked_by: — · blocks: —
```

On first run: every story under `### TODO`.

## Present mode

Read `./kanban.md`, parse: list of stories per status section with ID, title, priority, blocked_by, blocks.

Call the `inline-presentation` skill with the appropriate catalog form:

| Request | Form | Content |
|---|---|---|
| Progress | **P-7** horizontal bar | One bar: `Progress  ████████░░░░░░░░  N%` where N = `done / total × 100` (rounded to nearest integer). |
| Kanban board | **P-8** cluster cards | Three side-by-side cards: `┌─ TODO (n) ─┐` / `┌─ DOING (n) ─┐` / `┌─ DONE (n) ─┐`, each with story IDs as bullets (titles compact, truncated if needed to keep cards within ~120 chars total). |
| Dependencies | **P-1** ASCII flowchart | Boxes for stories (ID + short title), arrows for `blocked_by`. Top of chart = stories with no blockers. |

Render only. Do not modify `kanban.md` in present mode.

If `./kanban.md` is missing: respond `No ./kanban.md found. Run kanban-management first to generate.`

If a story-graph is too wide for P-1 (~10+ unblocked roots, or chart wider than 120 chars), report: `Dependency graph too wide for ASCII rendering — N roots. Showing top-K most-blocking stories instead.` and render the K stories with the most outgoing `blocks` edges.

## Preservation policy

`balanced` preservation mode.

**Must preserve exactly**:
- Story IDs (e.g., `US-001`) — verbatim from source
- Story titles — verbatim from source
- Approved dependency relations
- Manual status changes (TODO/DOING/DONE placement) across re-runs

**May change**:
- Structure: per-story files → consolidated `kanban.md` sections
- Format: template form → list-item layout

## Failure behavior

| Situation | Behavior |
|---|---|
| No stories provided | Interview for source path / files |
| Story missing ID or title | Stop; report which story; ask user to fix source |
| Source not in `user-story-generator` template structure | Stop; report mismatch |
| Circular dependency detected | Stop; list cycle's stories; ask user to fix source |
| Present mode but no `./kanban.md` | "No ./kanban.md found. Run kanban-management first to generate." |
| `./kanban.md` parse error (corrupted by manual edits) | Report parse error with line/section; ask user to fix manually |
| User asks for status states beyond TODO/DOING/DONE | Out of scope — only those three states are supported |

## Self-check

```
[ ] Every source story appears exactly once in kanban.md
[ ] No story IDs or titles altered
[ ] No circular dependencies in output graph
[ ] Priority ranks are unique integers 1..N
[ ] Every blocker has a strictly lower rank than its blocked story
[ ] On re-run: manual status edits preserved unless user requested reset
[ ] Output language matches source stories
[ ] Scope/journey section present (or explicit "No journey context provided")
[ ] On present: rendered values match kanban.md exactly — no fabrication
```

## Out of scope

- Creating new stories from journey opportunities (use `user-story-generator`)
- Editing story content — kanban.md only references; edit source files
- Sprint planning, capacity, velocity
- Statuses beyond TODO / DOING / DONE (no backlog, blocked, review)
- Multiple kanban files per project (one project = one `./kanban.md`; scope filter changes which stories appear, not the file)
