---
name: write-backend-documentation
description: Research a backend codebase end-to-end, propose an approval-gated documentation plan, then generate developer- and LLM-agent-oriented documentation in a consistent house style. Auto-detects language, framework, API surface, data layer, background processing, auth, config, observability, build/deploy, and tests. Existing docs are archived, never blindly overwritten. The entry point is a root-level README.md linking into a documentation/ tree. Nothing is written before the user approves the plan.
argument-hint: "[path to backend root, defaults to cwd]"
---

# Write Backend Documentation

Generate house-style backend documentation **grounded in the actual code**. The skill investigates the service completely and automatically, proposes a documentation plan that the user must approve, and only then writes files. Existing documentation is moved to an archive — never blindly overwritten. The single entry point is a **root-level `README.md`** that links into a `documentation/` tree. Output is English, written for both human developers and LLM agents.

## Metadata

| Field | Value |
|---|---|
| `name` | write-backend-documentation |
| `primary_category` | generation |
| `secondary_category` | planning |
| `output_mode` | human_readable |
| `creativity_level` | low (structure and prose are authored freely; every fact is grounded in the code) |
| `evidence_mode` | required for all technical claims (`path:line` references); not applicable to authored prose/structure |
| `tone` | technical / neutral |
| `version` | 1.0.0 |

## When to use

- A backend / service codebase must be (re)documented in a consistent house style, grounded in the real code rather than assumptions.
- The architecture and techniques are unknown or vary per project and must first be discovered before documentation can be accurate.
- Existing documentation is outdated, incomplete, or inconsistent and must be replaced while the old versions are preserved (archive).

## When not to use

- The target directory is a pure frontend (no server framework, no API surface, no data/service layer). → Use `frontend-docs-architect`.
- A single quick README without research is wanted. → Use `readme-generator` instead.
- The target is not a recognizable backend (no package/build manifest, no server framework or service entry point). → Return `Cannot proceed`.

## Required input

- **Backend root path** — the directory to document. Default: current working directory. The skill locates the nearest package/build manifest and framework markers.

## Optional input

- **Scope** — which service/package to document when a monorepo or multiple services are detected.
- **Emphasis areas** — topics to expand (e.g. auth, messaging, data model, integrations).
- **Naming/branding conventions** — product or house-style names to use in headings and prose.

## Input schema

```
{
  "content":     { "backend_root": "<path>" },
  "context":     { "scope": "<service/package | null>", "emphasis": ["<area>", ...] | null,
                   "naming": "<brand/style note | null>" },
  "constraints": { "language": "English (fixed)", "audience": "developers + LLM agents (fixed)" }
}
```

## House-style baseline

The documentation house style is a **strong guideline, not a rigid template**. Anchor on these conventions; adapt the actual set of files to what the research finds (omit guides for absent techniques, add guides for present ones).

- **Single entry point at the solution root** — a top-level **`README.md` placed in the backend root** (not inside `documentation/`) that introduces the service and links out to every file under `documentation/`. If a root `README.md` already exists, its existing project content is preserved/merged and a clearly delimited "Documentation" section with the links is added or updated; the prior version is archived first.
- **Layered, progressive disclosure** — Setup → Architecture → Development guidelines → Operations/Deployment.
- **`documentation/` tree** with, where applicable: `ARCHITECTURE.md`, `SETUP.md`, `CONTRIBUTING.md`, `DEPLOYMENT.md`, an `API.md` (API surface reference), and a `development/` layer.
- **`development/` decision-tree hub** — a `README.md` that routes the reader by file type / concern to specific guides:
  - **API layer** — routes/controllers/handlers, request/response DTOs, validation, error model.
  - **Domain / services** — business logic, use cases, application services.
  - **Data layer** — models/entities, ORM, repositories, migrations, schema.
  - **Middleware & cross-cutting** — auth/authz, rate limiting, logging, request context.
  - **Background processing** — jobs, queues, schedulers, workers, events/messaging.
  - **Integrations** — external API clients, SDKs, third-party services.
  - **Configuration** — config keys, secrets, environment variables.
  - **Observability** — logging, metrics, tracing, health/readiness checks.
- **API surface reference** — an `API.md` mapping each endpoint (`method path` → handler → auth requirement → request/response DTO), grounded in the code. For event-driven services, document the message/topic surface equivalently.
- **Consistent per-guide section template** — `When to use` → `Pattern / Standard structure` → `Real Examples` (pulled from the actual codebase) → `Quick Checklist` → `Next Steps` (cross-links).
- **Cross-linking** — every guide links back to the hub and to related guides; the root `README.md` links to the top-level docs.
- **Mermaid diagrams** where the house style uses them (request lifecycle, auth flow, data model, module/dependency relationships, deployment). Use fenced ` ```mermaid ` blocks — never ASCII art.
- **Agent-readable** — explicit conventions, predictable headings, code-fenced paths/commands, no implicit knowledge.

### Documentation depth — do not over-document

Document understanding the source cannot give the reader for free. Both humans and LLM agents can read the files directly, so do not restate their mechanical contents.

- **Do not** walk through self-evident files line-by-line — a `Dockerfile`, CI YAML, `package.json` / `pom.xml` / `go.mod` / `requirements.txt`, lockfiles, `tsconfig`, lint/format configs, or `.env` examples. Reproducing what the file already plainly states adds noise, drifts out of date, and buries the signal.
- **Do** document the *why* behind them — the principles, decisions, conventions, constraints, and non-obvious wiring: why the deploy is split into these stages, why this persistence pattern was chosen, what a config value affects downstream, how a request flows through middleware to a handler to the data layer that the files alone don't reveal.
- Reference such files by `path` so the reader can open them; explain intent, not syntax.
- When in doubt: if removing a passage loses no understanding that isn't already obvious from opening the file, cut it.

## Mermaid diagram conventions

All diagrams use Mermaid in fenced ` ```mermaid ` blocks. No ASCII art.

| Concept | Mermaid diagram |
|---|---|
| Request lifecycle, data flow, build/deploy pipeline | `flowchart` (`flowchart LR` / `TD`) |
| Auth flow, API/RPC call sequences, message handling over time | `sequenceDiagram` |
| Module / service / layer relationships and dependencies | `flowchart` or `classDiagram` |
| Async/job/session state machines (queued → running → done/failed) | `stateDiagram-v2` |
| Data model / entity relationships (tables, documents, aggregates) | `erDiagram` |

- Keep diagrams **grounded**: nodes and edges must reflect real modules, routes, handlers, entities, queues, or services found in the code — never invented. Label nodes with real names; the surrounding prose cites `path:line`.
- Prefer several small, focused diagrams over one sprawling one.
- Diagram structure/layout may be authored freely (per the grounding policy); the entities and relationships shown must be real.

## Processing rules

Execute in order. Steps 1–4 are research and planning; **no file is created, moved, or modified before step 5**, which requires explicit user approval.

1. **Determine scope.** Locate the backend root and package/build manifest. Detect monorepo / multiple services. If more than one service is found, ask which to document (or offer a per-service plan). If no backend is recognizable, stop with `Cannot proceed`.

2. **Research the solution — fully and automatically. Leave nothing out.** Detect and record, with `path:line` evidence:
   - Language + runtime version and framework + version (Express/Koa/Fastify/NestJS, Django/Flask/FastAPI, Spring/Spring Boot, ASP.NET, Rails, Laravel/Symfony, Gin/Echo/Fiber, Actix/Axum, etc.).
   - Build tooling, task runner, and package manager; scripts and entry point.
   - **API surface** — routing approach and the route map (method, path, handler, auth, request/response DTO); or the message/topic surface for event-driven services.
   - **Domain / service layer** — business logic organization, use cases, application/service objects.
   - **Data layer** — models/entities, ORM/ODM/query builder, repositories, migrations, schema, database(s).
   - **Middleware & cross-cutting** — authentication/authorization, validation, rate limiting, logging, error handling, request context.
   - **Background processing** — jobs, queues, schedulers, workers, event/message brokers, pub/sub.
   - **Integrations** — external API clients, SDKs, third-party services.
   - **Configuration** — config keys, environment variables, secrets management.
   - **Observability** — logging, metrics, tracing, health/readiness/liveness endpoints.
   - Build/deploy and runtime (Docker, orchestration, process manager, CI config).
   - Testing (unit, integration, contract, e2e) and tooling (lint, format, hooks).
   - Existing documentation: inventory every doc file (including any root `README.md`), note coverage and staleness.

3. **Map findings to the baseline.** Decide which house-style files apply. Add guides for techniques present (e.g. a `messaging/` guide when a broker is used); omit guides for techniques absent. Note every adaptation and its reason. Decide what **not** to document — self-evident files (Dockerfile, CI config, manifests, configs) are referenced and explained by intent, not reproduced (see Documentation depth).

4. **Propose the plan and STOP for approval.** Output a plan containing:
   - **Detected stack summary** (table, with evidence).
   - **Proposed documentation structure** — the root `README.md` plus the file tree under `documentation/`.
   - **Per-file actions** — `create` / `update`, with a one-line purpose each. Make explicit that the **root `README.md` is the entry point** and how an existing root README will be merged vs. archived.
   - **Archive plan** — which existing docs (including any prior root `README.md`) move to `documentation/archive/` (preserve relative structure).
   - **Open questions / assumptions** and **risks**.
   - **Success criteria.**
   Wait for explicit approval. On change requests, revise and re-present. Write nothing yet.

5. **Execute (only after approval).**
   - Move existing documentation into `documentation/archive/` (preserve relative paths). Never delete or overwrite originals. If a root `README.md` exists, archive a copy first, then preserve its real project content and add/refresh a clearly delimited "Documentation" section linking into `documentation/`.
   - Write the **root `README.md`** as the single entry point: a short service overview plus a linked index of every generated file under `documentation/`.
   - Generate the approved docs under `documentation/` in the backend root. Ground every technical claim in the code with `path:line` references. Pull **real examples from the actual codebase** — never invent routes, handlers, entities, paths, APIs, or commands.
   - Follow the per-guide section template, add checklists, cross-links, and ensure the `development/` hub routes by concern.
   - Include Mermaid diagrams (fenced ` ```mermaid ` blocks) where the house style does — request lifecycle, auth flow, data model (`erDiagram`), module/dependency relationships, deployment. No ASCII art.
   - Apply the Documentation depth rule: explain the *why* and non-obvious wiring; do not reproduce self-evident files (Dockerfile, CI config, manifests, configs) — reference them by `path` instead.

6. **Self-check and report.** Run the self-check, then output the result report (files created / updated / archived, adaptations, gaps).

## Grounding policy

| Aspect | Rule |
|---|---|
| **May be invented** | Document structure, section prose, explanatory wording, checklists, cross-links, Mermaid diagram layout. |
| **Diagram entities** | Mermaid nodes/edges must reflect real code (modules, routes, handlers, entities, queues, services); layout is free, the entities shown are not. |
| **Must be grounded** | Every technical claim — stack, versions, routes, paths, handlers, DTOs, entities, config keys, commands, examples — must come from the code, cited `path:line`. |
| **Assumptions allowed** | Only where evidence is absent; must be labeled `[Assumption]` with the gap and impact stated. |
| **Never fabricate** | No invented routes, endpoints, entities, file paths, config keys, commands, version numbers, or example code presented as real. |

## Output contract

**During planning (step 4):**

```markdown
## Documentation Plan

### Detected stack
| Aspect | Finding | Evidence |
|---|---|---|
| Language/Framework | ... | path:line |
...

### Proposed structure
README.md                      (root — entry point, links into documentation/)
documentation/
  ARCHITECTURE.md
  SETUP.md
  API.md
  ...

### Per-file actions
| File | Action | Purpose |
|---|---|---|
| README.md (root) | create/update | Entry point; service overview + links to documentation/ |
| documentation/ARCHITECTURE.md | create | ... |
...

### Archive plan
| Existing doc | Moves to |
|---|---|
| README.md (prior) | documentation/archive/... |

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
| README.md (root) | created/updated |
| documentation/ARCHITECTURE.md | created |
| documentation/archive/old-README.md | archived |
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
□ Did research cover every aspect (language/framework, build, API surface, domain/services, data layer, middleware/auth, background processing, integrations, config, observability, build/deploy, tests, existing docs)?
□ Is the root README.md the single entry point and does it link to every documentation/ file?
□ Is every technical claim grounded in code with path:line references?
□ Are no routes, handlers, entities, paths, APIs, commands, or examples fabricated?
□ Were existing docs (including any prior root README.md) archived (not overwritten/deleted), and was real project content in the root README preserved?
□ Was the plan explicitly approved before any write/move?
□ Does the structure follow the house-style baseline, with adaptations stated and justified?
□ Does each guide follow the section template + checklist + cross-links, and does the development/ hub route by concern?
□ Are diagrams Mermaid (fenced blocks, no ASCII art), with nodes/edges grounded in real code?
□ Is over-documentation avoided — no self-evident files (Dockerfile, CI, manifests, configs) reproduced line-by-line; the *why* documented instead?
□ Is output English and readable by both developers and LLM agents?
```

## Failure behavior

| Situation | Behavior |
|---|---|
| No recognizable backend at target | `Cannot proceed` — reason: no server framework/manifest; action: provide a backend root. |
| Multiple services/apps detected | Ask which to document, or offer a per-service plan. |
| Empty/unreadable source | Enter interview mode to gather the minimum (root path, framework). |
| Plan not approved | Write and move nothing; revise on request. |
| Aspect undetectable | Document it as `[Assumption]` or mark `not present`; never guess silently. |
| Request to skip approval | Refuse — the approval gate is a fixed processing rule. |
| Request to overwrite existing docs in place | Refuse — existing docs are archived; explain why. |
| Existing root README.md with real content | Archive a copy, preserve project content, add/refresh only the "Documentation" links section — never discard it. |

## Quality checks

- **Completeness** — every detected aspect is documented, or explicitly marked not present.
- **Entry point** — a root-level `README.md` exists and links to every file under `documentation/`.
- **Signal over noise** — no over-documentation; self-evident files (Dockerfile, CI, manifests, configs) are referenced and explained by intent, not reproduced; the *why* is captured.
- **Correctness** — claims trace to real code; no fabricated routes, handlers, entities, paths, or examples; Mermaid diagram entities are real.
- **House-style consistency** — section template, checklists, real examples, navigable via root entry point + cross-links.
- **Safety** — nothing overwritten without archiving; existing root README content preserved; nothing written before approval.
- **Agent-readability** — explicit conventions, predictable headings, fenced paths/commands.

## Examples

### Normal cases

1. **NestJS + TypeORM + PostgreSQL + BullMQ service.** Research detects Nest module/controller routing, TypeORM entities + migrations, a Bull queue with workers, JWT auth guards, Docker deploy. Plan proposes a root `README.md` entry point plus a full `documentation/` tree with `API.md`, a `development/` hub, and guides for controllers/DTOs, services, data/migrations, auth middleware, and jobs/queues. Approved → docs generated with real entity/handler examples cited to `src/**/*.ts`; old `README` archived, its project intro preserved.
2. **Django + DRF + Celery app.** Baseline adapted: `API.md` built from DRF viewsets/serializers, a `data/` guide from models + migrations, a `messaging/` guide for Celery tasks/broker. Root `README.md` links them. Plan approved → generated accordingly.
3. **Spring Boot + JPA + Kafka service.** Detects `@RestController` route map, JPA entities, Kafka listeners/producers. Plan proposes `API.md`, `data/` (JPA + Flyway), `messaging/` (Kafka), `config/` (application.yml intent). Generated with `path:line`-cited examples and an `erDiagram`.
4. **Go (Gin) + sqlc service with existing partial docs.** Research finds an outdated `docs/` folder and a thin root `README`. Plan archives both to `documentation/archive/`, preserves the README intro, regenerates `ARCHITECTURE.md`, `API.md`, `SETUP.md`, data/migration guide. Approved → executed.
5. **FastAPI service without background processing.** Jobs/messaging guide omitted (no broker/worker detected); plan states the omission and reason. API, data, config, observability guides generated; root `README.md` links the set.

### Edge cases

1. **Monorepo with three services.** Skill lists the services and asks which to document; user picks one; plan scoped to that package only, with the root `README.md` and `documentation/` placed inside that service's directory.
2. **Mixed/unclear stack (legacy PHP scripts + a Laravel module).** Research reports both; plan documents the dominant Laravel service and notes the legacy area as `[Assumption]`/partial with reduced specificity.
3. **No existing docs and no root README at all.** Archive plan is empty (stated explicitly); per-file table shows `create` for the root `README.md` and all `documentation/` files.

### Failure cases

1. **Pointed at a static frontend SPA.** No server framework/API surface detected → `Cannot proceed`: reason (no backend framework/manifest), action (provide a backend root, or use `frontend-docs-architect`).
2. **User says "skip the plan, just write the docs."** Skill refuses to bypass the approval gate, presents the plan, and waits — the gate is a fixed rule.

Operating rules: interview the user in their language only when input is missing; always write the generated documentation in English. The root `README.md` is the single entry point and must link into `documentation/`. Never write or move a file before the plan is approved. Ground every technical claim in real code.
