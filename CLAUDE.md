# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Claude Code plugins marketplace repository. It contains plugins that extend Claude Code functionality via hooks.

## Structure

```
.claude-plugin/marketplace.json  # Marketplace index listing all available plugins
<plugin-name>/                   # Each plugin in its own directory
  .claude-plugin/plugin.json     # Plugin manifest
  hooks/hooks.json               # Hook registrations
  hooks/*.sh                     # Hook implementation scripts
  README.md                      # Plugin documentation
```

## Plugin Architecture

### Marketplace Format (`.claude-plugin/marketplace.json`)

```json
{
  "name": "marketplace-name",
  "owner": { "name": "Owner Name" },
  "plugins": [
    {
      "name": "plugin-name",
      "source": "./plugin-directory",
      "description": "Plugin description"
    }
  ]
}
```

### Plugin Manifest (`<plugin>/.claude-plugin/plugin.json`)

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Description",
  "author": "Author",
  "hooks": "${CLAUDE_PLUGIN_ROOT}/hooks/hooks.json"
}
```

### Hooks Configuration (`<plugin>/hooks/hooks.json`)

Register shell scripts for Claude Code lifecycle events:
- `SessionStart` / `SessionEnd` - Session lifecycle
- `UserPromptSubmit` - User sends a prompt
- `PreToolUse` / `PostToolUse` - Before/after tool execution
- `Stop` - Agent stops processing
- `SubagentStop` - Subagent (Task tool) completes
- `PreCompact` - Before context compaction
- `Notification` - User input required

Hook scripts receive JSON on stdin with event data including `session_id`, `cwd`, `transcript_path`, and event-specific fields.

### Hook Script Conventions

- Use `${CLAUDE_PLUGIN_ROOT}` for paths in hooks.json
- Scripts should `exit 0` on success
- Parse input with `jq`: `INPUT=$(cat); SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')`
- Dependencies: `curl`, `jq`, `uuidgen` (or `/proc/sys/kernel/random/uuid`)
