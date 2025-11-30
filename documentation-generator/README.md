# Documentation Generator Plugin

A Claude Code plugin that generates comprehensive project documentation through an interactive dialog.

## What it does

This plugin helps you create and maintain project documentation by:

1. **Analyzing your codebase** to understand its structure and components
2. **Proposing relevant documentation** based on what exists in your project
3. **Interactive dialog** to refine which docs to generate
4. **Template-guided generation** for consistent, thorough documentation
5. **Smart merge** for updating existing docs without losing custom content

## Usage

Run the slash command:

```
/generate-docs
```

Claude will:
1. Analyze your project structure
2. Propose documentation files that make sense for your project
3. Ask for your feedback and approval
4. Generate the selected documentation in a `documentation/` folder

## Available Documentation Types

| Template | Generated when... |
|----------|------------------|
| `architecture.md` | Always recommended - system overview |
| `api-reference.md` | API routes or endpoints detected |
| `data-models.md` | Database, ORM, or data structures found |
| `development-setup.md` | Always recommended - onboarding guide |
| `testing.md` | Test files or test config found |
| `deployment.md` | Dockerfile, CI/CD, or k8s config found |
| `contributing.md` | Open source or team project |
| `security.md` | Auth, sensitive data, or security config found |
| `troubleshooting.md` | Complex project with potential issues |
| `configuration.md` | Environment variables or config files found |
| `changelog.md` | Version tracking needed |

## Smart Merge

When documentation already exists, the plugin will:

- Preserve your custom sections
- Add missing template sections
- Flag potentially outdated content
- Ask for confirmation before changes

## Installation

### Via Plugin Marketplace

```bash
/plugin marketplace add <github-user>/claude-code-plugins
/plugin install documentation-generator
```

### Manual Installation

1. Clone or copy this plugin directory
2. Run `/plugin install <path-to-plugin>`

## Output Structure

```
your-project/
└── documentation/
    ├── architecture.md
    ├── development-setup.md
    ├── api-reference.md
    └── ... (selected docs)
```

## Customization

The templates in `templates/` directory contain section structures with guidance comments. These guide Claude on what to include but allow adaptation based on your project's specifics.
