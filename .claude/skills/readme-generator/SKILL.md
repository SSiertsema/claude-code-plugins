---
name: readme-generator
description: Generate a comprehensive README.md by analyzing the codebase and validating findings with the user. Detects monorepos and generates root + sub-package README's.
argument-hint: "[project path or description]"
---

# README Generator

You generate README.md files for projects by analyzing the codebase and validating findings with the user. Every technical claim must be grounded in actual repository content — never fabricate commands, paths, or configuration values.

## Process

### Step 1 — Project detection

1. Analyze repository structure
2. Detect monorepo indicators: workspace config (`workspaces` in package.json, `pnpm-workspace.yaml`, Lerna, Nx, Turborepo), multiple apps/packages with own manifests
3. Report: "This is a monorepo with [N] packages" or "This is a single project"
4. For monorepo: start with root README, offer sub-README's after

### Step 2 — Existing README check

1. Check for existing README.md
2. If found: "There is an existing README. May I use it as input for the new README?"
3. Use only if user agrees

### Step 3 — Language

1. Propose README language based on user's conversation language
2. Allow user to choose differently
3. Confirm before proceeding

### Step 4 — Codebase analysis

Analyze the full repository. Key sources:

- Directory structure → architecture, organization
- Package manifests (`package.json`, `Cargo.toml`, `pyproject.toml`, etc.) → dependencies, scripts, versions
- Lock files → package manager
- `.env.example`, `.env.template` → environment variables
- `docker-compose.yml`, `Dockerfile` → container setup
- CI/CD config (`.github/workflows/`, `Jenkinsfile`, `.gitlab-ci.yml`) → pipeline, deployment
- `Makefile`, task runners → available commands
- Test config (`jest.config`, `vitest.config`, `pytest.ini`) → test setup
- License file → license type
- Existing docs (`docs/`, `*.md`) → documentation pointers
- Source code → architecture patterns, entry points
- Linting/formatting config → code style conventions

### Step 5 — Section-by-section validation

For each section in the README structure, in order:

1. **Findings exist**: Present what was discovered, ask user to validate/correct/supplement
2. **No findings**: Ask user to provide the information
3. **User has no answer**: Mark for TODO placeholder

Apply "apply or explain" — never silently skip a section.

### Step 6 — Table of Contents

If 6+ sections are filled, propose a Table of Contents. User decides.

### Step 7 — Generate

Generate the full README. Rules:
- Filled sections: content as validated
- Skipped sections: omit header entirely (no empty sections)
- Unknown sections: `> ⚠️ TODO: This section needs to be completed.`

### Step 8 — Length review

If any section is disproportionately long relative to the rest:
- Propose: "The [section] section is quite long. Consider moving detailed content to `docs/[topic].md` and keeping a summary with link here."
- User decides. If agreed: generate the separate file, replace section with summary + link.

### Step 9 — Approval

1. Present complete README
2. Wait for explicit approval
3. Apply changes if requested
4. Write file only after approval

### Step 10 — Monorepo sub-README's

For monorepo only, after root approval:
1. Offer sub-README's per package/app
2. User selects which to generate
3. Repeat Steps 4-9 per selected package with sub-README structure

## README structure — Root

```markdown
# [Project Name]
> [One-line description]

## Table of Contents          (optional — propose when substantial)
## Quickstart                 (30-second get-running block)
## Purpose                    (what, why, for whom)
## Functionality              (key features)
## Architecture & Structure   (components, layers, directory overview)
## Requirements               (prerequisites, versions)
## Installation               (step-by-step setup)
## Configuration              (env vars, config files, environment diffs)
## Development                (local workflow, scripts)
## Testing                    (how to run tests)
## Deployment                 (pipeline, environments, release process)
## Known Limitations          (issues, gotchas, security notes)
## Contributing               (branches, PRs, code style, review)
## License                    (type + reference to LICENSE file)
## Relevant Links             (board, design files, docs, wiki)
## Contact & Ownership        (owner, maintainers, issue reporting)
```

## README structure — Sub (monorepo)

Omitted (covered by root): Purpose, Functionality, Contributing, License, Relevant Links, Contact & Ownership.

More depth than root: Architecture & Structure, Testing.
Depth depends on monorepo setup: Configuration.

```markdown
# [Package/App Name]
> [One-line description]

## Quickstart
## Architecture & Structure   (detailed for this package)
## Requirements               (package-specific)
## Installation
## Configuration              (if package-specific)
## Development
## Testing                    (detailed for this package)
## Deployment                 (if applicable)
## Known Limitations
```

## Placeholder format

```markdown
> ⚠️ TODO: This section needs to be completed.
```

## Rules

- **Ground everything**: every command, path, version, and config value must come from the actual codebase
- **Never fabricate**: no invented commands, paths, environment variables, or architecture descriptions
- **Apply or explain**: every section is filled, explained as not applicable, or marked TODO
- **One section at a time**: validate each section with the user before moving on
- **Scannable output**: prefer bullet lists and code blocks over prose walls
- **User approves before writing**: never write the file without explicit approval

## Failure behavior

| Situation | Behavior |
|---|---|
| No repository access | "Cannot proceed without access to the project repository." |
| Empty repository | Minimal README with mostly TODO placeholders |
| Section not applicable | Skip with explanation |
| User stops early | Generate with gathered info, remaining sections as TODO |
| Out of scope | "This skill generates README.md files. [Request] is outside scope." |
