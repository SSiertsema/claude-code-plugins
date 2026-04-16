# README Generator — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | readme-generator |
| **Version** | 1.0.0 |
| **Purpose** | Generates a comprehensive README.md for any project by analyzing the codebase and validating findings with the user per section. Detects monorepo structures and generates root-level and sub-package README's with appropriate depth. Ensures any developer can understand, start, configure, and contribute to the project within 5 minutes. |
| **Primary category** | `generation` |
| **Secondary category** | `conversation` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Mixins** | none |

---

## When to use

- A project has no README yet
- An existing README is outdated or incomplete
- A new project is being set up and needs documentation
- A monorepo needs root-level and/or sub-package README's

## When not to use

- Generating non-README documentation (API docs, changelogs, architecture decision records)
- Updating a single README section without full context — manual edit is faster
- Generating documentation for code that does not exist yet (no codebase to analyze)
- Writing marketing copy or landing page content

---

## Generation policy

| Aspect | Declaration |
|---|---|
| **What may be invented** | Phrasing, section transitions, structural organization of discovered facts |
| **What must be grounded** | All technical claims: commands, paths, dependencies, versions, configuration details — must trace to actual codebase content |
| **What assumptions are allowed** | Standard development conventions (e.g., `npm install` for a Node.js project) when confirmed by presence of config files |
| **What must never be fabricated** | Commands, file paths, environment variables, dependency versions, configuration values, architecture descriptions |

**Creativity level**: `low` — minor invention allowed for phrasing and structure; all technical content must be grounded in the codebase.

---

## Required input

| Field | Description |
|---|---|
| **Repository access** | Access to the full project repository (all files, directories, configs) |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Existing README** | Current README.md to use as input (requires user permission) | None — skill asks if one exists |
| **Language** | Language for the generated README | User's conversation language |
| **Output path** | Where to save the README | `./README.md` (root) or `./[package]/README.md` (sub) |

## Input schema

```
input:
  required:
    repository:
      type: directory
      description: "Access to the project repository root"
  optional:
    existing_readme:
      type: file
      description: "Existing README.md to use as basis (with user permission)"
    language:
      type: string
      description: "Language for the generated README"
      default: "user's conversation language"
    output_path:
      type: string
      description: "File path for saving the README"
      default: "./README.md"
```

---

## Processing rules

### Phase 1 — Project detection

1. Analyze repository structure to determine project type (single project or monorepo)
2. Detect monorepo indicators: workspace config (`workspaces` in package.json, `pnpm-workspace.yaml`, Lerna config, Nx config, Turborepo config), multiple independent apps/packages with their own manifests
3. Report finding to user: "This is a monorepo" or "This is a single project"
4. For monorepo: proceed with root README first, offer sub-README's after completion

### Phase 2 — Existing README check

1. Check if a README.md already exists at the target location
2. If found: ask user "There is an existing README. May I use it as input for the new README?"
3. If user agrees: read and analyze existing content as additional context
4. If user declines: proceed without it

### Phase 3 — Language selection

1. Propose the README language based on the user's conversation language
2. Allow user to choose a different language
3. Confirm language before proceeding

### Phase 4 — Codebase analysis

Analyze the full repository. Sources to inspect (non-exhaustive):

| Source | Information gathered |
|---|---|
| Directory structure | Architecture, project organization |
| Package manifests (`package.json`, `Cargo.toml`, `pyproject.toml`, etc.) | Dependencies, scripts, versions, project metadata |
| Lock files (`package-lock.json`, `pnpm-lock.yaml`, etc.) | Package manager used |
| `.env.example`, `.env.template` | Required environment variables |
| `docker-compose.yml`, `Dockerfile` | Container setup, services |
| CI/CD config (`.github/workflows/`, `Jenkinsfile`, `.gitlab-ci.yml`, etc.) | Build, test, deployment pipeline |
| `Makefile`, task runners | Available commands |
| Test configuration (`jest.config`, `vitest.config`, `pytest.ini`, etc.) | Test setup and commands |
| License file (`LICENSE`, `LICENSE.md`) | License type |
| Existing documentation (`docs/`, `wiki/`, `*.md`) | Additional documentation pointers |
| Source code structure | Architecture patterns, entry points |
| Git configuration | Branch strategy indicators |
| Linting/formatting config (`.eslintrc`, `.prettierrc`, etc.) | Code style conventions |

### Phase 5 — Section-by-section validation

For each applicable section from the README structure:

1. **Present findings**: Show what was discovered from the codebase analysis
2. **If findings exist**: Ask user to validate, correct, or supplement
3. **If no findings**: Ask user to provide the information
4. **If user has no answer**: Mark section for TODO placeholder

Process sections in order. Do not skip sections — apply "apply or explain" principle.

### Phase 6 — Table of Contents proposal

After all sections are validated, if the README has substantial content (6+ filled sections), propose adding a Table of Contents. User decides.

### Phase 7 — Generation

1. Generate the full README.md in the confirmed language
2. Apply "apply or explain" principle: every section from the structure is either filled, has a brief explanation why it was skipped, or has a `> ⚠️ TODO: This section needs to be completed.` placeholder
3. Skipped sections must not have empty headers — omit the header entirely and do not mention skipped sections in the document unless there is a TODO placeholder

### Phase 8 — Length review

After generation, review each section's length relative to the overall document:

1. If a section is disproportionately long compared to the rest, propose to the user: "The [section] section is quite long. Consider moving the detailed content to a separate file (e.g., `docs/[topic].md`) and keeping a summary with a link here."
2. User decides whether to link out or keep inline
3. If user agrees: generate the separate file and replace the section with a summary + link

### Phase 9 — Presentation and approval

1. Present the complete README to the user
2. Wait for explicit approval
3. Make changes if requested, re-present
4. Write file only after approval

### Phase 10 — Monorepo sub-README's

For monorepo projects only, after root README is approved:

1. Offer to generate sub-README's for each package/app
2. If user accepts: repeat Phases 4-9 for each package/app with adjusted structure (see Output contract — Sub README)
3. User may choose which packages/apps to generate for

---

## Output contract

### Root README structure

The following sections apply to both single projects and monorepo root README's. Sections are applied or explained per the "apply or explain" principle.

```markdown
# [Project Name]

> [One-line description of the project]

## Table of Contents
[Optional — proposed when content is substantial]

## Quickstart
[Minimal "get running in 30 seconds" block — copy-paste commands]

## Purpose
[What the project does, what problem it solves, who it is for]

## Functionality
[Key features and capabilities]

## Architecture & Structure
[High-level overview — components, layers, directory structure]
[For monorepo: list of packages/apps with brief descriptions]

## Requirements
[Prerequisites: runtime versions, tools, system dependencies]

## Installation
[Step-by-step setup instructions]

## Configuration
[Environment variables, config files, .env.example reference]
[Differences between environments if applicable]

## Development
[Running locally, available scripts/commands, workflow]

## Testing
[How to run tests, test framework, coverage]

## Deployment
[How deployment works, pipeline, environments, release process]

## Known Limitations
[Known issues, common mistakes, security/privacy considerations]

## Contributing
[Branch strategy, PR conventions, code style, review process]

## License
[License type with reference to LICENSE file]

## Relevant Links
[Links to board, design files, project documentation, wiki, etc.]

## Contact & Ownership
[Project owner, maintainers, where to report issues, where to find help]
```

### Sub README structure (monorepo packages/apps)

Adjusted structure for sub-packages. Omitted sections are covered by root README.

```markdown
# [Package/App Name]

> [One-line description]

## Quickstart
[How to run/use this specific package]

## Architecture & Structure
[Detailed architecture of this package — deeper than root level]

## Requirements
[Package-specific requirements beyond root]

## Installation
[Package-specific setup steps]

## Configuration
[Package-specific config — apply or explain based on monorepo setup]

## Development
[Package-specific development workflow]

## Testing
[Detailed test instructions for this package]

## Deployment
[Package-specific deployment if applicable]

## Known Limitations
[Package-specific limitations]
```

Sections omitted from sub README (covered by root): Project-level Purpose, Project-level Functionality, Contributing, Contact & Ownership, License, Relevant Links.

### Placeholder format

For sections where no information is available:

```markdown
> ⚠️ TODO: This section needs to be completed.
```

---

## Self-check

```
[] Every technical claim (command, path, version, config) is verified against the codebase
[] No fabricated commands, paths, or configuration values
[] All sections are either filled, explained as skipped, or have a TODO placeholder
[] Monorepo correctly detected (or not)
[] Sub README's omit root-level sections and go deeper on architecture and testing
[] Language matches user's confirmed choice
[] Disproportionately long sections flagged for link-out
[] README is scannable — bullet lists preferred over prose walls
[] Existing README used as input only with user permission
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No repository access | Report error: "Cannot proceed without access to the project repository." |
| Empty repository | Generate minimal README with mostly TODO placeholders |
| User declines to validate a section | Proceed with analysis findings, note section as unvalidated |
| Section not applicable to project | Skip with explanation (e.g., "No Deployment section: this is a library consumed as a dependency") |
| Disproportionately long section | Suggest moving to separate doc with summary + link; user decides |
| Existing README found, user declines to use | Proceed without it |
| Monorepo detected but user disagrees | Accept user's assessment, proceed as single project |
| Cannot determine project type | Ask user what type of project this is |
| User wants to stop early | Generate with what was gathered, mark remaining sections as TODO |

---

## Quality checks

- [ ] A new developer can answer within 5 minutes: What does this do? Can I start it locally? Where do I look? How do I contribute safely?
- [ ] Every command listed in the README actually works (verified against package scripts, Makefile, etc.)
- [ ] File paths referenced in the README exist in the repository
- [ ] Environment variables listed match `.env.example` or actual config files
- [ ] Dependencies and version requirements match manifest files
- [ ] Architecture description matches actual directory structure
- [ ] No empty sections — every header has content, a skip explanation, or a TODO placeholder
- [ ] README is scannable: short paragraphs, bullet lists, code blocks for commands
- [ ] Monorepo sub-README's do not duplicate root-level content
- [ ] Long sections flagged and addressed (kept or linked out)

---

## Examples

### Normal cases

**1. Node.js web application**
- Input: Repository with `package.json`, `src/`, `.env.example`, `docker-compose.yml`, GitHub Actions
- Expected: Full README with all sections filled. Quickstart with `npm install && npm run dev`. Configuration section lists env vars from `.env.example`. Deployment section describes GitHub Actions pipeline.

**2. Python library**
- Input: Repository with `pyproject.toml`, `src/`, `tests/`, `LICENSE`, no CI/CD
- Expected: README with Deployment section skipped ("This is a library — see Contributing for publishing"). License section references MIT from LICENSE file.

**3. Monorepo with 3 apps**
- Input: pnpm workspace with `apps/frontend`, `apps/backend`, `packages/shared`
- Expected: Root README with high-level architecture listing all 3 packages. After approval, offers sub-README's. Sub-README for `apps/frontend` has detailed architecture and test instructions specific to the frontend.

**4. Existing README present**
- Input: Repository with outdated README.md
- Expected: Asks "There is an existing README. May I use it as input for the new README?" If yes, uses structure and content as basis, updates with codebase findings.

**5. Rust CLI tool**
- Input: Repository with `Cargo.toml`, `src/main.rs`, `tests/`, `LICENSE-APACHE`
- Expected: Quickstart with `cargo build && cargo run`. Requirements lists Rust toolchain version. Testing section describes `cargo test`.

### Edge cases

**6. Empty repository (only .gitignore)**
- Input: Repository with only `.gitignore` and possibly a `LICENSE`
- Expected: Minimal README with project name from directory, License section if LICENSE exists, all other sections as TODO placeholders.

**7. Monorepo with 20+ packages**
- Input: Large monorepo with many packages
- Expected: Root README lists all packages in Architecture section. Offers sub-README generation — user selects which packages to generate for (not forced to do all).

**8. No `.env.example` but environment variables in code**
- Input: Repository that reads `process.env.DATABASE_URL` in code but has no `.env.example`
- Expected: Configuration section notes environment variables found in code. Suggests creating `.env.example`. Marks section as partially complete.

### Failure cases

**9. No repository access**
- Input: Skill invoked without a project directory
- Expected: "Cannot proceed without access to the project repository."

**10. Out of scope request**
- Input: "Generate API documentation from my code"
- Expected: "This skill generates README.md files. API documentation generation is outside scope."
