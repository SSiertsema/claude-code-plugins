# Plugin Persistence Issue

## Problem

Plugins from this marketplace are not persisting after Claude Code restarts.

## Symptoms

1. Plugin is installed successfully
2. Claude Code indicates a restart is needed to apply changes
3. After restarting Claude Code, the plugin is no longer installed
4. The plugin must be reinstalled after every restart

## Investigation

- **Third-party plugin `repomix` (yamadashy/repomix) persists correctly** after installation and restart
- This suggests the issue is with our plugin structure, not Claude Code's plugin system itself

## Suspected Cause

The plugin structure in this repository may be missing something that third-party plugins (like repomix) have, causing Claude Code to not properly save the plugin configuration persistently.

### Areas to Investigate

1. **Plugin manifest structure** (`<plugin>/.claude-plugin/plugin.json`)
   - Are all required fields present?
   - Is the format matching what Claude Code expects?

2. **Marketplace format** (`.claude-plugin/marketplace.json`)
   - Is the source path format correct?
   - Are there missing required fields?

3. **Hooks configuration** (`<plugin>/hooks/hooks.json`)
   - Is the hooks.json structure compatible with Claude Code's expectations?
   - Are the hook event names correct?

4. **File paths**
   - Is `${CLAUDE_PLUGIN_ROOT}` being resolved correctly?
   - Are relative vs absolute paths causing issues?

## Next Steps

1. Compare our plugin structure with the working `repomix` plugin
2. Check Claude Code's plugin storage location to see what gets saved
3. Review Claude Code documentation for any plugin requirements we may have missed
4. Test with a minimal plugin to isolate the issue

## Workaround

Currently, plugins must be reinstalled after each Claude Code restart.

---

# Debug Timeline

## 2025-11-30: Comprehensive Structure Comparison

### Research Methodology
Parallel investigation using three approaches:
1. Official Claude Code plugin documentation review
2. Analysis of working `repomix` plugin structure
3. Analysis of our non-working plugin structure

---

### Finding 1: Repomix Plugin Structure (WORKING)

**Location:** `~/.claude/plugins/marketplaces/repomix/`

**Directory Structure:**
```
repomix/
├── .claude-plugin/
│   └── marketplace.json              # Root marketplace manifest
└── .claude/
    └── plugins/
        ├── repomix-mcp/
        │   ├── .claude-plugin/
        │   │   └── plugin.json
        │   └── .mcp.json
        ├── repomix-commands/
        │   ├── .claude-plugin/
        │   │   └── plugin.json
        │   └── commands/
        │       ├── pack-local.md
        │       └── pack-remote.md
        └── repomix-explorer/
            ├── .claude-plugin/
            │   └── plugin.json
            ├── agents/
            │   └── explorer.md
            └── commands/
                ├── explore-local.md
                └── explore-remote.md
```

**Repomix marketplace.json:**
```json
{
  "name": "repomix",
  "owner": {
    "name": "yamadashy"
  },
  "metadata": {
    "description": "Official Repomix plugins for Claude Code",
    "version": "1.0.2"
  },
  "plugins": [
    {
      "name": "repomix-mcp",
      "source": "./.claude/plugins/repomix-mcp",
      "category": "integration"
    },
    {
      "name": "repomix-commands",
      "source": "./.claude/plugins/repomix-commands",
      "category": "productivity"
    },
    {
      "name": "repomix-explorer",
      "source": "./.claude/plugins/repomix-explorer",
      "category": "productivity"
    }
  ]
}
```

**Repomix plugin.json example (repomix-commands):**
```json
{
  "name": "repomix-commands",
  "description": "Slash commands for quick Repomix operations...",
  "version": "1.0.2",
  "author": {
    "name": "yamadashy"
  },
  "homepage": "https://repomix.com/docs/guide/claude-code-plugins",
  "repository": "https://github.com/yamadashy/repomix",
  "keywords": ["repomix", "commands", "pack", "productivity"],
  "license": "MIT"
}
```

---

### Finding 2: Our Plugin Structure (NOT WORKING)

**Location:** `/home/sven/Projects/claude-code-plugins/`

**Directory Structure:**
```
claude-code-plugins/
├── .claude-plugin/
│   └── marketplace.json
├── agent-meeting-room/
│   ├── .claude-plugin/
│   │   └── plugin.json
│   └── hooks/
│       ├── hooks.json
│       └── *.sh
├── git-commit/
│   ├── .claude-plugin/
│   │   └── plugin.json
│   └── commands/
│       └── commit.md
└── documentation-generator/
    ├── .claude-plugin/
    │   └── plugin.json
    └── commands/
        └── generate-docs.md
```

**Our marketplace.json:**
```json
{
  "name": "claude-code-plugins",
  "owner": {
    "name": "Sven Siertsema"
  },
  "plugins": [
    {
      "name": "agent-meeting-room",
      "source": "./agent-meeting-room",
      "description": "..."
    },
    {
      "name": "git-commit",
      "source": "./git-commit",
      "description": "..."
    }
  ]
}
```

**Our plugin.json example (git-commit):**
```json
{
  "name": "git-commit",
  "version": "1.0.0",
  "description": "...",
  "author": "Sven",
  "commands": "./commands"
}
```

---

### Finding 3: Key Differences Identified

| Aspect | Repomix (Working) | Our Plugins (Not Working) |
|--------|-------------------|---------------------------|
| **metadata in marketplace.json** | Has `metadata.description` and `metadata.version` | Missing `metadata` block |
| **category in plugin entries** | Has `"category": "productivity"` | Missing `category` field |
| **author format** | Object: `{"name": "yamadashy"}` | String: `"Sven"` |
| **Additional fields** | `homepage`, `repository`, `keywords`, `license` | Missing all of these |
| **Plugin path structure** | `./.claude/plugins/plugin-name` | `./plugin-name` |

---

### Finding 4: Official Documentation Requirements

From Claude Code docs, **required fields** are:
- `plugin.json`: Only `name` is strictly required
- `marketplace.json`: `name`, `owner.name`, and `plugins` array

**However**, the docs also state:
- Custom paths must be **relative** and **start with `./`** ✓ (we do this)
- Use `${CLAUDE_PLUGIN_ROOT}` for absolute path references ✓ (we do this)
- Commands/agents/hooks should NOT be inside `.claude-plugin/` ✓ (we follow this)

---

### Hypothesis: Likely Root Causes

#### Hypothesis A: Missing `metadata` block in marketplace.json
Repomix has:
```json
"metadata": {
  "description": "...",
  "version": "1.0.2"
}
```
We are missing this entirely.

#### Hypothesis B: Author format mismatch
Repomix uses object format:
```json
"author": { "name": "yamadashy" }
```
We use string format:
```json
"author": "Sven"
```

#### Hypothesis C: Missing `category` field in plugin entries
Repomix plugin entries have:
```json
"category": "integration"
```
Our entries lack this field.

#### Hypothesis D: Path structure difference
Repomix plugins are nested under `.claude/plugins/`:
```
source: "./.claude/plugins/repomix-mcp"
```
Our plugins are at root level:
```
source: "./agent-meeting-room"
```

---

### Recommended Tests

1. **Test A**: Add `metadata` block to our marketplace.json
2. **Test B**: Change `author` from string to object format in all plugin.json files
3. **Test C**: Add `category` field to all plugin entries in marketplace.json
4. **Test D**: Add optional fields (`homepage`, `repository`, `keywords`, `license`) to plugin.json files
5. **Test E**: Restructure plugins under `.claude/plugins/` path (matching repomix structure)

---

### JSON Validation Status

All our JSON files are syntactically valid. The issue is not malformed JSON but likely missing optional fields that Claude Code uses for persistence logic.

---

## 2025-11-30: Applied Fixes (Tests A, B, C, D)

Based on the research findings, applied the following changes to match the repomix plugin structure:

### Changes Applied

#### 1. marketplace.json - Added `metadata` block and `category` fields

**Before:**
```json
{
  "name": "claude-code-plugins",
  "owner": { "name": "Sven Siertsema" },
  "plugins": [
    { "name": "agent-meeting-room", "source": "./agent-meeting-room", "description": "..." }
  ]
}
```

**After:**
```json
{
  "name": "claude-code-plugins",
  "owner": { "name": "Sven Siertsema" },
  "metadata": {
    "description": "Collection of plugins for Claude Code",
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "agent-meeting-room",
      "source": "./agent-meeting-room",
      "description": "Tracks Claude Code sessions and agent processes in the Agent Meeting Room system",
      "category": "integration"
    },
    {
      "name": "documentation-generator",
      "source": "./documentation-generator",
      "description": "Generate comprehensive project documentation through interactive dialog with templates",
      "category": "productivity"
    },
    {
      "name": "git-commit",
      "source": "./git-commit",
      "description": "Streamlined git commit and push with auto-generated commit messages",
      "category": "productivity"
    }
  ]
}
```

#### 2. All plugin.json files - Changed `author` to object format, added metadata fields

**Before (example: git-commit):**
```json
{
  "name": "git-commit",
  "version": "1.0.0",
  "description": "...",
  "author": "Sven",
  "commands": "./commands"
}
```

**After:**
```json
{
  "name": "git-commit",
  "version": "1.0.0",
  "description": "Streamlined git commit and push with auto-generated commit messages",
  "author": {
    "name": "Sven Siertsema"
  },
  "repository": "https://github.com/SSiertsema/claude-code-plugins",
  "license": "MIT",
  "keywords": ["git", "commit", "automation", "productivity"],
  "commands": "./commands"
}
```

### Summary of All Changes

| File | Changes Applied |
|------|-----------------|
| `.claude-plugin/marketplace.json` | Added `metadata` block, added `category` to each plugin entry |
| `agent-meeting-room/.claude-plugin/plugin.json` | Changed `author` to object, added `repository`, `license`, `keywords` |
| `git-commit/.claude-plugin/plugin.json` | Changed `author` to object, added `repository`, `license`, `keywords` |
| `documentation-generator/.claude-plugin/plugin.json` | Changed `author` to object, added `repository`, `license`, `keywords` |

### Tests Not Applied

- **Test E (restructure to `.claude/plugins/` path)**: Not applied yet. The current path structure `./plugin-name` should be valid according to docs. Will only apply if the above changes don't resolve the issue.

### Next Step

Restart Claude Code and test if plugins now persist after restart.
