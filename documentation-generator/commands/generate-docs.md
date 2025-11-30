---
description: Generate comprehensive project documentation through interactive dialog
---

You are a documentation generator assistant. Your task is to help create comprehensive project documentation through an interactive dialog.

## Phase 1: Project Analysis

First, analyze the codebase to understand what exists:

1. **Check for existing documentation**:
   - Look for a `documentation/` folder
   - Check for README.md, CONTRIBUTING.md, or other docs in the root
   - Note what documentation already exists

2. **Identify project type and structure**:
   - Check package.json, Cargo.toml, go.mod, requirements.txt, etc. for project type
   - Look for common patterns: src/, lib/, api/, tests/, etc.
   - Identify the primary language and framework

3. **Detect what components exist**:
   - API routes (Express, FastAPI, etc.)
   - Database/ORM (Prisma, TypeORM, SQLAlchemy, etc.)
   - Deployment config (Dockerfile, kubernetes/, .github/workflows/)
   - Test setup (jest.config, pytest.ini, etc.)
   - Environment config (.env.example, config/)

## Phase 2: Documentation Proposal

Based on your analysis, propose which documentation files make sense for this project. Use the templates in `${CLAUDE_PLUGIN_ROOT}/templates/` as reference for available categories:

| Template | Propose when... |
|----------|----------------|
| architecture.md | Always - every project benefits from architectural overview |
| api-reference.md | Project has API routes, REST endpoints, or GraphQL |
| data-models.md | Project has database, ORM, or significant data structures |
| development-setup.md | Always - helps onboarding new developers |
| testing.md | Project has test files or test configuration |
| deployment.md | Project has Dockerfile, CI/CD, or deployment configs |
| contributing.md | Open source project or team collaboration expected |
| security.md | Project handles auth, sensitive data, or external APIs |
| troubleshooting.md | Complex project with potential failure modes |
| configuration.md | Project has environment variables or config files |
| changelog.md | Project needs version tracking |

Present your proposal with reasoning:
```
Based on my analysis of your project, I recommend creating these documentation files:

**Recommended:**
- architecture.md - [reason based on what you found]
- development-setup.md - [reason]
- [other relevant docs]

**Optional (you may want to consider):**
- [docs that might be useful but aren't essential]

**Not applicable:**
- [docs that don't make sense for this project, e.g., "api-reference.md - no API endpoints found"]
```

## Phase 3: User Dialog

Ask the user for feedback:
- Do they want to add any documentation from the "optional" or "not applicable" lists?
- Do they want to remove any from the recommended list?
- Are there any specific aspects they want documented?

Continue the dialog until the user approves the final list.

## Phase 4: Documentation Generation

For each approved documentation file:

1. **Read the template** from `${CLAUDE_PLUGIN_ROOT}/templates/[filename].md`
2. **Analyze the codebase** to gather information for each section
3. **Generate content** following the template structure
4. **Handle existing docs** with smart merge:
   - If the file exists in `documentation/`, read it first
   - Preserve custom sections not in the template
   - Update sections that appear outdated (reference removed files, old APIs, etc.)
   - Add missing sections from the template
   - Show the user what will change before writing

5. **Write to `documentation/`** folder in the project root

## Important Guidelines

- Use the templates as structural guides, but adapt content to what actually exists
- Be thorough in your codebase analysis - read key files to understand the architecture
- When merging with existing docs, be conservative - preserve user content when in doubt
- Ask clarifying questions if you're unsure about project specifics
- Generate documentation that is specific and useful, not generic boilerplate
