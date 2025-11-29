# Agent Meeting Room Plugin

A Claude Code plugin that tracks sessions and agent processes in the Agent Meeting Room system.

## What it does

This plugin automatically tracks:

- **Sessions** - When Claude Code starts and ends
- **Processes** - Each user prompt creates a trackable process
- **Subagents** - Task tool invocations are tracked as child processes
- **Status changes** - Completion, interruption, and waiting-for-input states

All data is sent to the Agent Meeting Room backend at `agent-meeting-room.up.railway.app`.

## Requirements

- `curl` - For HTTP requests
- `jq` - For JSON parsing
- `uuidgen` or `/proc/sys/kernel/random/uuid` - For generating process IDs

## Installation

### Via Plugin Marketplace

```bash
# Add the marketplace
/plugin marketplace add <github-user>/claude-code-plugins

# Install the plugin
/plugin install agent-meeting-room
```

### Manual Installation

1. Clone or copy this plugin directory
2. Run `/plugin install <path-to-plugin>`

## Hooks

This plugin registers the following hooks:

| Hook | Purpose |
|------|---------|
| `SessionStart` | Creates a session in the meeting room |
| `SessionEnd` | Marks session as ended |
| `UserPromptSubmit` | Creates a new process or resumes waiting process |
| `PreToolUse` | Tracks Task tool invocations for subagent linking |
| `PostToolUse` | Detects user interruptions |
| `Stop` | Marks process as completed/interrupted/waiting |
| `SubagentStop` | Links completed subagents to parent processes |
| `PreCompact` | (Reserved for future use) |
| `Notification` | Notifies when user input is required |

## Environment Variables

| Variable | Description |
|----------|-------------|
| `CLAUDE_HOOK_PROJECT_NAME` | Override the project name (defaults to CWD basename) |

## Temporary Files

The hooks use `/tmp/` for state management:

- `/tmp/claude-hooks.log` - Main log file
- `/tmp/claude-hook-debug.log` - Debug logging
- `/tmp/claude-current-process/` - Current process ID tracking
- `/tmp/claude-agent-sessions/` - Task metadata mapping
- `/tmp/claude-interrupted/` - Interrupt flags
- `/tmp/claude-tool-executed/` - Tool execution tracking
