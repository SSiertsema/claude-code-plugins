# Kanban Management — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | kanban-management |
| **Version** | 1.0.0 |
| **Purpose** | Transforms user stories (from `user-story-generator`) and optional user journeys (from `user-journey-management`) into a central `./kanban.md` file at the project root. The `kanban.md` is the single source of truth for development status with three sections — `TODO` / `DOING` / `DONE` — and stores per-story dependency relations and a numerical priority rank. The skill performs an LLM-based analysis step that proposes dependencies (when the source stories miss them) and a topologically-consistent priority order, both reviewed and iteratively approved by the user. On a re-run, the skill diffs the existing `kanban.md` against the source and reconciles new / removed / status-conflict / dependency-change cases interactively, never silently overwriting manual status edits. On request, three projections are rendered inline by the `inline-presentation` skill: progress percentage (P-7 horizontal bar), kanban board (P-8 cluster cards `TODO/DOING/DONE`), and dependency flowchart (P-1 ASCII boxes with arrows). |
| **Primary category** | `transformation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Preservation mode** | `balanced` |
| **Mixins** | `[]` (uses `inline-presentation` as a peer skill, not a mixin) |

---

## When to use

- A set of `user-story-generator`-style user stories must be brought into a working kanban format
- Central development status must be tracked in one canonical file
- Dependency relations and priority order must be inferred when missing from sources
- An existing `kanban.md` must be reconciled after source-stories changed
- Visual projections (progress %, kanban board, dependency graph) of the kanban data are needed inline

## When not to use

- No user stories exist yet — first run `user-story-generator`
- Stories are managed in another tracking system (Jira, Linear, GitHub Projects)
- A pure planning instrument without stories is needed
- Status states beyond `TODO`/`DOING`/`DONE` are required (no backlog, blocked, review)
- Multiple kanban files per project — only one `./kanban.md` per project

---

## Required input

| Field | Description |
|---|---|
| **Source stories** | Path, directory, or pasted content of stories in the `user-story-generator` template (each with story ID, title, optional `Blocked by` / `Blocks`) |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Journey reference** | Path or pasted user-journey output from `user-journey-management` for the scope/context section | None |
| **Scope filter** | Epic or feature name to filter which stories appear | All stories |
| **Mode** | `generate` / `update` / `show progress` / `show kanban` / `show dependencies` | Auto-detect from argument and `kanban.md` presence |

## Input schema

```
input:
  required:
    source_stories:
      type: string | path | directory | content
      template_structure: user-story-generator
  optional:
    journey_reference: string | path | content
    scope_filter: string
    mode: enum [generate, update, show_progress, show_kanban, show_dependencies]
```

---

## Processing rules

### Phase 1 — Setup
Detect existence of `./kanban.md`. Collect source stories, optional journey, optional scope. Detect output language from source.

### Phase 2 — Validate
Check each story for ID + title. Stop on incomplete story. Stop on template mismatch.

### Phase 3 — Dependency analysis
Use explicit dependencies when present. Otherwise propose `blocked_by` / `blocks` from content (description, AC, journey context). Present proposal table. Interview unclear cases one at a time. Cycle detection — stop and report on any cycle.

### Phase 4 — Priority analysis
Topological sort + content-aware ordering within layers. Assign unique integer ranks 1..N. Verify blocker-before-blocked invariant. Iterate with user.

### Phase 5 — Reconciliation (re-run only)
Diff against existing `kanban.md`. Categorize: new / removed / status-conflict / dependency-change. Iterate per category. Preserve manual status edits unless user explicitly resets.

### Phase 6 — Write
Write `./kanban.md` in source-stories language. First-run: all stories under `### TODO`. Headers translated to source language. Include scope/journey section.

### Phase 7 — Present (on request)
Read and parse `kanban.md`. Call `inline-presentation` with P-7 (progress %), P-8 (cluster cards), or P-1 (ASCII flowchart) per request signal. Render only — no file mutation.

---

## Output contract

### `./kanban.md` data file

```markdown
# Project Kanban

<!-- Generated and maintained by kanban-management. -->

## Scope
[Journey context summary, or "No journey context provided"]

## Stories

### TODO
- **US-001** — [Title] · priority: 1 · blocked_by: — · blocks: US-002

### DOING
- **US-002** — [Title] · priority: 3 · blocked_by: US-001 · blocks: —

### DONE
- **US-005** — [Title] · priority: 4 · blocked_by: — · blocks: —
```

### On-demand presentations

- **P-7 progress bar** — single horizontal bar with `done/total` percentage
- **P-8 cluster cards** — three side-by-side cards `TODO (n)` / `DOING (n)` / `DONE (n)` with story IDs as bullets
- **P-1 ASCII flowchart** — boxes for stories, arrows for `blocked_by`, top-down

---

## Preservation policy

| Aspect | Policy |
|---|---|
| **Facts (story IDs, titles)** | Must preserve exactly — verbatim from source |
| **Dependencies (once approved)** | Must preserve exactly |
| **Manual status changes** | Must preserve across re-runs unless user explicitly resets |
| **Structure** | Restructure allowed — per-story files → consolidated kanban |
| **Format** | Adapt to kanban list-item layout |
| **Language** | Follow source-stories language |

---

## Self-check

```
[ ] Every source story appears exactly once in kanban.md
[ ] No story IDs or titles altered
[ ] No circular dependencies in output graph
[ ] Priority ranks are unique integers 1..N
[ ] Every blocker has lower rank than its blocked story
[ ] On re-run: manual status edits preserved unless user requested reset
[ ] Output language matches source stories
[ ] Scope/journey section present (or explicit "No journey context provided")
[ ] On present: rendered values match kanban.md exactly — no fabrication
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No source stories provided | Interview mode (§7) — ask for path / files |
| Story missing ID or title | Stop, report which story, ask user to fix source |
| Source not in `user-story-generator` template structure | Stop, report mismatch |
| Circular dependency detected | Stop, list involved stories, ask user to fix in source |
| Present mode but no `./kanban.md` | "No `./kanban.md` found. Run kanban-management first to generate." |
| `./kanban.md` parse error (corrupted manual edits) | Report parse error with line/section, ask user to fix manually |
| Status state requested beyond TODO/DOING/DONE | Out of scope — only those three states are supported |
| Dependency graph too wide for P-1 ASCII | Render top-K most-blocking stories with explanatory note |

---

## Quality checks

- [ ] All source stories present in output
- [ ] Story IDs and titles unchanged
- [ ] Acyclic dependency graph
- [ ] Unique 1..N priority ranks, blocker-before-blocked
- [ ] Manual status preserved on re-run
- [ ] Output language matches source
- [ ] Inline presentations exactly reflect kanban data

---

## Examples

### Normal cases

**1. First-run with explicit dependencies**
- Input: 8 stories in `docs/stories/`, all with `Blocked by` / `Blocks` filled in. No journey.
- Expected: kanban.md created with 8 stories under `### TODO`, ranks 1..8 from topological sort + content order, scope section: "No journey context provided".

**2. First-run, missing dependencies**
- Input: 12 stories, half without dependency info. Journey provided.
- Expected: Skill proposes dependencies via content analysis, presents table, iterates with user, detects no cycles, ranks 1..12, writes kanban.md with scope section derived from journey.

**3. Re-run after source update — new stories added**
- Input: existing kanban.md with 10 stories, source now has 13.
- Expected: Skill detects 3 new stories, proposes adding to TODO, asks for re-ranking approval, preserves status of original 10.

**4. Re-run with manual status changes**
- Input: existing kanban.md where user moved 3 stories to DOING, 1 to DONE. Source unchanged.
- Expected: No source diff. All manual status changes preserved. Skill reports "no source changes detected — kanban.md unchanged".

**5. Present-mode: progress**
- Input: `show progress` with kanban.md showing 4/12 done.
- Expected: P-7 bar `Progress  ████████░░░░░░░░░░░░░░░░  33%`.

**6. Present-mode: kanban board**
- Input: `show kanban` with 5 TODO, 2 DOING, 3 DONE.
- Expected: P-8 three cluster cards side-by-side with story IDs and short titles.

**7. Present-mode: dependencies**
- Input: `show dependencies` with 6 stories and a small dep-graph.
- Expected: P-1 ASCII flowchart showing boxes connected by arrows representing `blocked_by` relations.

### Edge cases

**8. Dutch source stories**
- Input: stories written in Dutch with `Geblokkeerd door` / `Blokkeert` field labels.
- Expected: Detection of Dutch as output language; kanban.md sections in Dutch (`### OPENSTAAND`, `### BEZIG`, `### KLAAR` or natural translation), preserve story IDs/titles verbatim.

**9. Single isolated story**
- Input: 1 story, no dependencies, no journey.
- Expected: kanban.md with 1 story in TODO, priority 1, scope "No journey context provided", no dependency analysis needed.

**10. Re-run with removed story**
- Input: kanban.md has US-007 (DOING), source no longer contains US-007.
- Expected: Skill flags removal, asks user: "US-007 is no longer in source. Remove from kanban (lose its DOING status), or keep as orphan?"

### Failure cases

**11. Circular dependency**
- Input: US-A `Blocked by` US-B; US-B `Blocked by` US-A.
- Expected: Stop. "Circular dependency detected: US-A ↔ US-B. Please resolve in source stories."

**12. No stories provided**
- Input: invocation with no argument, no `kanban.md` exists.
- Expected: Interview — "Where are your user stories? Provide a path, directory, or paste content."
