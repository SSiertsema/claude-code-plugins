---
name: frontend-docs-architect
description: Research a frontend codebase end-to-end, propose an approval-gated documentation plan, then generate developer- and LLM-agent-oriented documentation in a consistent house style. Auto-detects framework, routing, state, styling, API, build/deploy, and tests. Existing docs are archived, never blindly overwritten. Nothing is written before the user approves the plan.
argument-hint: "[path to frontend root, defaults to cwd]"
---

# Frontend Docs Architect

Generate house-style frontend documentation **grounded in the actual code**. The skill investigates the solution completely and automatically, proposes a documentation plan that the user must approve, and only then writes files. Existing documentation is moved to an archive — never blindly overwritten. Output is English, written for both human developers and LLM agents.

## Metadata

| Field | Value |
|---|---|
| `name` | frontend-docs-architect |
| `primary_category` | generation |
| `secondary_category` | planning |
| `output_mode` | human_readable |
| `creativity_level` | low (structure and prose are authored freely; every fact is grounded in the code) |
| `evidence_mode` | required for all technical claims (`path:line` references); not applicable to authored prose/structure |
| `tone` | technical / neutral |
| `version` | 1.1.0 |

## When to use

- A frontend codebase must be (re)documented in a consistent house style, grounded in the real code rather than assumptions.
- The architecture and techniques are unknown or vary per project and must first be discovered before documentation can be accurate.
- Existing documentation is outdated, incomplete, or inconsistent and must be replaced while the old versions are preserved (archive).

## When not to use

- The target directory is not a recognizable frontend (no package manifest, no frontend framework). → Return `Cannot proceed`.
- The task is backend-only or library-only documentation with no frontend.
- A single quick README without research is wanted. → Use `readme-generator` instead.

## Required input

- **Frontend root path** — the directory to document. Default: current working directory. The skill locates the nearest package manifest and framework markers.

## Optional input

- **Scope** — which app/package to document when a monorepo or multiple frontends are detected.
- **Emphasis areas** — topics to expand (e.g. auth, state, API integration).
- **Naming/branding conventions** — product or house-style names to use in headings and prose.

## Input schema

```
{
  "content":     { "frontend_root": "<path>" },
  "context":     { "scope": "<app/package | null>", "emphasis": ["<area>", ...] | null,
                   "naming": "<brand/style note | null>" },
  "constraints": { "language": "English (fixed)", "audience": "developers + LLM agents (fixed)" }
}
```

## House-style baseline

The documentation house style is a **strong guideline, not a rigid template**. Anchor on these conventions; adapt the actual set of files to what the research finds (omit guides for absent techniques, add guides for present ones).

- **Single entry point** — a top-level doc index / README that links out to everything.
- **Layered, progressive disclosure** — Setup → Architecture → Development guidelines → Operations/Deployment.
- **`documentation/` tree** with, where applicable: `ARCHITECTURE.md`, `SETUP.md`, `CONTRIBUTING.md`, `DEPLOYMENT.md`, and a `development/` layer.
- **`development/` decision-tree hub** — a `README.md` that routes the reader by file type to specific guides (components, pages, stores/state, composables/hooks, services/API, styling).
- **Consistent per-guide section template** — `When to use` → `Pattern / Standard structure` → `Real Examples` (pulled from the actual codebase) → `Quick Checklist` → `Next Steps` (cross-links).
- **Cross-linking** — every guide links back to the hub and to related guides.
- **Mermaid diagrams** where the house style uses them (data flow, auth flow, component/state relationships, deployment), as in `ARCHITECTURE.md`. Use fenced ` ```mermaid ` blocks — never ASCII art.
- **Agent-readable** — explicit conventions, predictable headings, code-fenced paths/commands, no implicit knowledge.

### Documentation depth — do not over-document

Document understanding the source cannot give the reader for free. Both humans and LLM agents can read the files directly, so do not restate their mechanical contents.

- **Do not** walk through self-evident files line-by-line — a `Dockerfile`, CI YAML, `package.json`, lockfiles, `tsconfig`, lint/format configs, or `.env` examples. Reproducing what the file already plainly states adds noise, drifts out of date, and buries the signal.
- **Do** document the *why* behind them — the principles, decisions, conventions, constraints, and non-obvious wiring: why the deploy is split into these stages, why this state pattern was chosen, what a config value affects downstream, how pieces connect that the files alone don't reveal.
- Reference such files by `path` so the reader can open them; explain intent, not syntax.
- When in doubt: if removing a passage loses no understanding that isn't already obvious from opening the file, cut it.

## Mermaid diagram conventions

All diagrams use Mermaid in fenced ` ```mermaid ` blocks. No ASCII art.

| Concept | Mermaid diagram |
|---|---|
| Data flow, request/response, build/deploy pipeline | `flowchart` (`flowchart LR` / `TD`) |
| Auth flow, API call sequences, runtime interactions over time | `sequenceDiagram` |
| Component / store / module relationships and dependencies | `flowchart` or `classDiagram` |
| State machines (e.g. auth/session, async UI states) | `stateDiagram-v2` |
| Data model / entity relationships | `erDiagram` |

- Keep diagrams **grounded**: nodes and edges must reflect real modules, routes, stores, or services found in the code — never invented. Label nodes with real names; the surrounding prose cites `path:line`.
- Prefer several small, focused diagrams over one sprawling one.
- Diagram structure/layout may be authored freely (per the grounding policy); the entities and relationships shown must be real.

## Processing rules

Execute in order. Steps 1–4 are research and planning; **no file is created, moved, or modified before step 5**, which requires explicit user approval.

1. **Determine scope.** Locate the frontend root and package manifest. Detect monorepo / multiple frontends. If more than one app is found, ask which to document (or offer a per-app plan). If no frontend is recognizable, stop with `Cannot proceed`.

2. **Research the solution — fully and automatically. Leave nothing out.** Detect and record, with `path:line` evidence:
   - Framework + version (Vue/Nuxt, React/Next, Angular, Svelte/SvelteKit, Solid, etc.) and language (TS/JS).
   - Build tooling and bundler (Vite, webpack, Nuxt, Next, etc.), scripts, and package manager.
   - Routing approach (file-based, config-based, router library) and route map.
   - State management (Pinia, Vuex, Redux, Zustand, Context, Composition stores, signals).
   - Component and folder organization; component categories/patterns in use.
   - Styling approach (SCSS, CSS Modules, Tailwind, CSS-in-JS, BEM, design system).
   - API/data integration (SDK/client, generated clients, fetch wrappers, services layer).
   - Build/deploy and runtime (Docker, PM2, CI config, environment variables).
   - Testing (unit, component, e2e) and tooling (lint, format, hooks).
   - Existing documentation: inventory every doc file, note coverage and staleness.

3. **Map findings to the baseline.** Decide which house-style files apply. Add guides for techniques present (e.g. a `hooks/` guide for React); omit guides for techniques absent. Note every adaptation and its reason. Decide what **not** to document — self-evident files (Dockerfile, CI config, `package.json`, configs) are referenced and explained by intent, not reproduced (see Documentation depth).

4. **Propose the plan and STOP for approval.** Output a plan containing:
   - **Detected stack summary** (table, with evidence).
   - **Proposed documentation structure** (file tree under `documentation/`).
   - **Per-file actions** — `create` / `update`, with a one-line purpose each.
   - **Archive plan** — which existing docs move to `documentation/archive/` (preserve relative structure).
   - **Open questions / assumptions** and **risks**.
   - **Success criteria.**
   Wait for explicit approval. On change requests, revise and re-present. Write nothing yet.

5. **Execute (only after approval).**
   - Move existing documentation into `documentation/archive/` (preserve relative paths). Never delete or overwrite originals.
   - Generate the approved docs under `documentation/` in the frontend root. Ground every technical claim in the code with `path:line` references. Pull **real examples from the actual codebase** — never invent components, paths, APIs, or commands.
   - Follow the per-guide section template, add checklists, cross-links, and an entry-point index.
   - Include Mermaid diagrams (fenced ` ```mermaid ` blocks) where the house style does — data flow, auth flow, component/state relationships, deployment. No ASCII art.
   - Apply the Documentation depth rule: explain the *why* and non-obvious wiring; do not reproduce self-evident files (Dockerfile, CI config, `package.json`, configs) — reference them by `path` instead.

6. **Self-check and report.** Run the self-check, then output the result report (files created / updated / archived, adaptations, gaps).

## Grounding policy

| Aspect | Rule |
|---|---|
| **May be invented** | Document structure, section prose, explanatory wording, checklists, cross-links, Mermaid diagram layout. |
| **Diagram entities** | Mermaid nodes/edges must reflect real code (modules, routes, stores, services); layout is free, the entities shown are not. |
| **Must be grounded** | Every technical claim — stack, versions, paths, file names, APIs, commands, examples — must come from the code, cited `path:line`. |
| **Assumptions allowed** | Only where evidence is absent; must be labeled `[Assumption]` with the gap and impact stated. |
| **Never fabricate** | No invented components, file paths, endpoints, config keys, commands, version numbers, or example code presented as real. |

## Output contract

**During planning (step 4):**

```markdown
## Documentation Plan

### Detected stack
| Aspect | Finding | Evidence |
|---|---|---|
| Framework | ... | path:line |
...

### Proposed structure
documentation/
  README.md
  ARCHITECTURE.md
  ...

### Per-file actions
| File | Action | Purpose |
|---|---|---|
| documentation/ARCHITECTURE.md | create | ... |
...

### Archive plan
| Existing doc | Moves to |
|---|---|
| README.md (docs section) | documentation/archive/... |

### Assumptions & risks
- ...

### Success criteria
- [ ] ...
```

**After execution (step 6):**

```markdown
## Documentation Result

### Status
Complete / Partial

### Files
| File | Action |
|---|---|
| documentation/ARCHITECTURE.md | created |
| documentation/archive/old-README-docs.md | archived |
...

### House-style adaptations
- [guide added/omitted] — [reason]

### Grounding
- Technical claims cited to code: yes/partial
- Assumptions made: [list or none]

### Gaps
- [aspect not present / not documentable] — [why]
```

## Self-check

```
□ Did research cover every aspect (framework, build, routing, state, components, styling, API, build/deploy, tests, existing docs)?
□ Is every technical claim grounded in code with path:line references?
□ Are no components, paths, APIs, commands, or examples fabricated?
□ Were existing docs archived (not overwritten/deleted)?
□ Was the plan explicitly approved before any write/move?
□ Does the structure follow the house-style baseline, with adaptations stated and justified?
□ Does each guide follow the section template + checklist + cross-links?
□ Are diagrams Mermaid (fenced blocks, no ASCII art), with nodes/edges grounded in real code?
□ Is over-documentation avoided — no self-evident files (Dockerfile, CI, configs) reproduced line-by-line; the *why* documented instead?
□ Is there a single entry-point index linking the set?
□ Is output English and readable by both developers and LLM agents?
```

## Failure behavior

| Situation | Behavior |
|---|---|
| No recognizable frontend at target | `Cannot proceed` — reason: no framework/manifest; action: provide a frontend root. |
| Multiple frontends/apps detected | Ask which to document, or offer a per-app plan. |
| Empty/unreadable source | Enter interview mode to gather the minimum (root path, framework). |
| Plan not approved | Write and move nothing; revise on request. |
| Aspect undetectable | Document it as `[Assumption]` or mark `not present`; never guess silently. |
| Request to skip approval | Refuse — the approval gate is a fixed processing rule. |
| Request to overwrite existing docs in place | Refuse — existing docs are archived; explain why. |

## Quality checks

- **Completeness** — every detected aspect is documented, or explicitly marked not present.
- **Signal over noise** — no over-documentation; self-evident files (Dockerfile, CI, configs) are referenced and explained by intent, not reproduced; the *why* is captured.
- **Correctness** — claims trace to real code; no fabricated APIs, paths, or examples; Mermaid diagram entities are real.
- **House-style consistency** — section template, checklists, real examples, navigable via entry point + cross-links.
- **Safety** — nothing overwritten without archiving; nothing written before approval.
- **Agent-readability** — explicit conventions, predictable headings, fenced paths/commands.

## Examples

### Normal cases

1. **Nuxt 3 + Pinia + SCSS/BEM app.** Research detects Nuxt file-based routing, Pinia composition stores, a generated API SDK, Docker+PM2 deploy. Plan proposes full `documentation/` tree with a `development/` hub and guides for components, pages, stores, composables, services, BEM. Approved → docs generated with real store/component examples cited to `store/*.ts` and `components/*.vue`; old `README` docs archived.
2. **React + Vite + Zustand + Tailwind app.** Baseline adapted: `hooks/` guide replaces `composables/`, `stores/ZUSTAND.md` replaces Pinia guide, `styling/TAILWIND.md` replaces BEM. Plan approved → generated accordingly.
3. **Angular standalone-components app.** Detects Angular Router config, services with DI, RxJS. Plan proposes `services/`, `routing/`, `state/` guides; component guide reflects standalone components. Generated with `path:line`-cited examples.
4. **SvelteKit app with existing partial docs.** Research finds an outdated `docs/` folder. Plan archives it to `documentation/archive/` and regenerates `ARCHITECTURE.md`, `SETUP.md`, route/load guides. Approved → executed.
5. **Vue 3 SPA without backend integration.** API/services guide omitted (no client detected); plan states the omission and reason. Components/state/styling guides generated.

### Edge cases

1. **Monorepo with three frontends.** Skill lists the apps and asks which to document; user picks one; plan scoped to that package only, with archive paths inside that package's `documentation/`.
2. **Mixed/unclear stack (legacy jQuery + a Vue island).** Research reports both; plan documents the dominant Vue solution and notes the legacy area as `[Assumption]`/partial with reduced specificity.
3. **No existing docs at all.** Archive plan is empty (stated explicitly); only `create` actions in the per-file table.

### Failure cases

1. **Pointed at a Node backend service.** No frontend framework detected → `Cannot proceed`: reason (no frontend framework/manifest), action (provide a frontend root).
2. **User says "skip the plan, just write the docs."** Skill refuses to bypass the approval gate, presents the plan, and waits — the gate is a fixed rule.
```

Operating rules: interview the user in their language only when input is missing; always write the generated documentation in English. Never write or move a file before the plan is approved. Ground every technical claim in real code.
