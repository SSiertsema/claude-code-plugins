# Git Commit Plugin

A Claude Code plugin that streamlines committing and pushing changes with auto-generated commit messages.

## Usage

```
/commit              # Auto mode: commit and push immediately
/commit --safe       # Safe mode: interactive approval flow
```

## Modes

### Auto Mode (default)

Commits and pushes in one step:
1. Analyzes your changes
2. Generates a commit message (conventional commits or repo style)
3. Commits and pushes
4. Reports: `✓ Committed and pushed: abc1234 feat: Add new feature`

### Safe Mode (`--safe`)

Interactive flow with approval:
1. Shows files to be committed
2. Proposes a commit message
3. Asks for your approval (or edits)
4. After commit, asks before pushing

## Configuration

Set default mode via environment variable:

```bash
export CLAUDE_COMMIT_MODE=auto   # Default behavior
export CLAUDE_COMMIT_MODE=safe   # Always use safe mode
```

## Safety Features

- Never force pushes
- Warns when pushing to main/master
- Skips secret files (.env, credentials, keys)
- Suggests `git pull --rebase` if push fails
- Never amends commits unless explicitly asked

## Commit Message Style

The plugin:
1. Matches your repository's existing commit style
2. Falls back to conventional commits (feat/fix/docs/refactor/test/chore)
3. Keeps messages concise and descriptive
4. Includes Claude Code footer

## Installation

### Via Plugin Marketplace

```bash
/plugin marketplace add <github-user>/claude-code-plugins
/plugin install git-commit
```

### Manual Installation

1. Clone or copy this plugin directory
2. Run `/plugin install <path-to-plugin>`
