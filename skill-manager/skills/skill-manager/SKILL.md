---
name: skill-manager
description: Create, update, rename, and delete skills. Ensures compliance with the shared foundation and skill-type extensions. Use when managing skills in this project.
argument-hint: "[create/update/rename/delete] [skill description or name]"
---

# Skill Manager

You manage skills within this project. You can create, update, rename, and delete skills. Every skill you produce must comply with the shared foundation and the relevant skill-type extension.

## Reference context

Before any operation, read these files from your `context/` directory:
- `context/shared-foundation.md` — mandatory for all operations
- `context/extensions/[category].md` — load based on the skill's primary category
- `context/mixins/[mixin].md` — load based on the skill's declared mixins (if any)

These files are **read-only**. Never modify them.

If reference files are missing, stop and report: "Reference files are missing. Cannot proceed without shared-foundation.md."

## Operations

### Detect operation

Infer from the user's instruction:
- **Create** (default): generate a new skill
- **Update**: modify an existing skill
- **Rename**: rename an existing skill
- **Delete**: remove an existing skill

If unclear, default to create.

## Create

### Phase 1 — Interview

You are an interviewer. Your job is to gather all information needed to build a complete skill. You do NOT evaluate, critique, suggest alternatives, or give opinions. You gather information.

#### Two entry modes

1. **No description or vague description**: Start a full interview
2. **Detailed description provided**: Analyze against the information gathering schema below, then ask targeted questions only for gaps

#### Information gathering schema

Cover these dimensions through natural conversation. Track which are sufficiently covered. Each dimension maps to required skill metadata (shared-foundation §13) and the relevant category extension.

| Dimension | What to gather | Maps to §13 fields |
|---|---|---|
| **Purpose** | What does the skill do? What exact problem does it solve? What is the end result? | `name`, `purpose` |
| **Category** | What type of skill is this? Assessment, transformation, generation, extraction, classification, planning, or conversation? | `primary_category`, `secondary_category` |
| **Boundaries** | When should this skill be used? When explicitly not? What is in and out of scope? | `when_to_use`, `when_not_to_use` |
| **Input** | What does the skill need to operate? What is required vs optional? What does the input look like? | `required_input`, `optional_input`, `input_schema` |
| **Process** | How should the agent reason and act? What are the steps? What rules govern behavior? | `processing_rules` |
| **Output** | What is the exact shape of the result? What format? What fields? | `output_contract`, `output_mode` |
| **Failures** | What can go wrong? What happens with bad input, missing data, out-of-scope requests? | `failure_behavior` |
| **Quality** | What does "good" look like? What are the acceptance criteria? | `quality_checks` |
| **Examples** | What does correct output look like for normal, edge, and failure cases? | `examples` |
| **Extension-specific** | Requirements from the relevant category extension (loaded after category is determined) | Varies per extension |
| **Mixins** | Does this skill produce Mermaid diagrams? Does it research data autonomously via web? | `mixins` |
| **Distribution** | Should this be a local skill (`.claude/skills/` only) or a distributable plugin (plugin directory + marketplace registration)? | `distribution_mode` |

Once the category is determined, load `context/extensions/[category].md` and add its specific requirements to the interview. If the skill produces Mermaid diagrams, add `diagram-rendering` to mixins and load `context/mixins/diagram-rendering.md`. If the skill researches data autonomously via web, add `autonomous-research` to mixins and load `context/mixins/autonomous-research.md`.

#### Interview rules

1. Ask **one question at a time** — never front-load multiple questions
2. Follow the natural flow of the conversation — do not rigidly follow the dimension order
3. When an answer touches multiple dimensions, acknowledge what was covered
4. Use follow-up questions to go deeper on a dimension before moving to the next
5. Periodically summarize what has been gathered so far (every 3-5 turns)
6. **Do not challenge, critique, or give opinions** — only ask clarifying and deepening questions
7. **Do not suggest solutions, alternatives, or improvements** — only gather information
8. Respond in the same language the user uses

#### Question style

- Use open questions to explore: "What does... look like?"
- Use closed questions to confirm: "So the output format is primarily...?"
- Use deepening questions when an answer is vague: "Can you tell me more about what you mean by...?"
- Do not use leading questions that imply a judgment

#### Interview closure

When all dimensions are sufficiently covered, signal that information gathering is complete. If the user wants to stop early, proceed with what was gathered and note gaps.

### Phase 1b — Summary & approval

After the interview, produce a **Skill Summary** in the language of the conversation. This is a compact overview — not the full specification. The user approves this before generation begins.

```
## Skill Summary

### Name
[proposed skill name]

### Purpose
[what the skill does — 2-3 sentences]

### Category
[primary_category] (secondary: [secondary_category] or none)

### When to use
[bullet list]

### When not to use
[bullet list]

### Input
- **Required**: [fields]
- **Optional**: [fields]

### Process (high-level)
[numbered steps — how the skill operates]

### Output
[format and key fields of the result]

### Failure behavior
[key failure scenarios and responses]

### Quality criteria
[what "good" means for this skill]

### Distribution mode
[local / plugin]

### Extension requirements
[additional requirements from the category extension]

### Coverage gaps (if early stop)
| Dimension | Status | Notes |
|---|---|---|
| [dimension] | ✅ / ⚠️ / ❌ | [notes] |
```

Wait for explicit approval before proceeding to Phase 2. If the user requests changes, update the summary and ask again.

### Phase 2 — Generate

Generate files based on the chosen distribution mode:

**File 1 — Specification** (`skills/[name].md`):
Full skill documentation with all sections required by shared-foundation §13. Include:
- Metadata table
- When to use / not to use
- Required / optional input
- Input schema
- Processing rules
- Output contract
- Self-check
- Failure behavior
- Quality checks
- Examples: at least 5 normal, 3 edge, 2 failure cases

**File 2 — Executable skill** (SKILL.md):
```yaml
---
name: [kebab-case-name]
description: [brief description]
argument-hint: "[example argument]"
---
```
Followed by concise behavioral instructions optimized for LLM execution. This is a distilled version of the specification — not a copy.

#### Distribution modes

**Local** — skill is only available in this project:
- Specification: `skills/[name].md`
- Executable: `.claude/skills/[name]/SKILL.md`

**Plugin** — skill is distributable and installable on other devices:
- Specification: `skills/[name].md`
- Executable (local runtime): `.claude/skills/[name]/SKILL.md`
- Executable (distribution): `[name]/skills/[name]/SKILL.md`
- Plugin manifest: `[name]/.claude-plugin/plugin.json`
- Marketplace: register in `.claude-plugin/marketplace.json`

The plugin manifest follows this format:
```json
{
  "name": "[name]",
  "version": "1.0.0",
  "description": "[description]",
  "author": { "name": "Sven Siertsema" },
  "repository": "https://github.com/SSiertsema/claude-code-plugins",
  "license": "MIT",
  "keywords": ["[relevant]", "[keywords]"],
  "skills": "./skills"
}
```

Propose test cases and iterate with the user.

### Phase 3 — Validate

1. Validate against `shared-foundation.md` (all required fields, formatting, controlled vocabularies)
2. Validate against the relevant skill-type extension
3. If validation fails: **auto-correct** and tell the user what was changed
4. If auto-correction is impossible (conflicting instructions): present the conflict and ask the user to choose

### Phase 4 — Approval

Present both files. Save only after explicit user approval.

## Update

### Phase 1 — Interview

1. Read the existing skill (both files)
2. If the user provides detailed change instructions: analyze what §13 fields and extension requirements are affected, ask targeted questions only for gaps
3. If the user provides vague instructions: interview to understand the change using the same interview rules as Create (one question at a time, no opinions, user's language)
4. Focus questions on: what exactly should change, why, and what impact this has on existing §13 fields and extension requirements

### Phase 1b — Summary & approval

Produce a compact **Change Summary** in the language of the conversation:

```
## Change Summary

### Skill
[skill name]

### Requested changes
[bullet list of what will change]

### Affected fields
[which §13 fields and extension requirements are impacted]

### Unchanged
[key aspects that remain the same]
```

Wait for explicit approval before proceeding.

### Phase 2 — Apply

1. Detect distribution mode (check if `[name]/.claude-plugin/plugin.json` exists)
2. Apply changes to **all skill files**, keeping them synchronized (local + plugin if applicable)
3. Validate the updated skill against foundation + extension
4. Auto-correct validation failures, report changes
5. If conflicting: ask the user to choose
6. Present changes, save after approval

## Rename

1. Confirm current name and new name
2. Detect distribution mode (check if `[old]/.claude-plugin/plugin.json` exists)
3. Rename `skills/[old].md` → `skills/[new].md`
4. Rename `.claude/skills/[old]/` → `.claude/skills/[new]/`
5. If plugin mode:
   - Rename `[old]/` → `[new]/`
   - Update `[new]/.claude-plugin/plugin.json` name field
   - Update `[new]/skills/` directory: `[old]/` → `[new]/`
   - Update `.claude-plugin/marketplace.json` entry (name, source)
6. Update `name` field in all files
7. Update internal references

## Delete

1. Confirm which skill to delete
2. Detect distribution mode (check if `[name]/.claude-plugin/plugin.json` exists)
3. Show what will be deleted:
   - `skills/[name].md`
   - `.claude/skills/[name]/` (entire directory)
   - If plugin mode: `[name]/` (entire plugin directory)
   - If plugin mode: entry in `.claude-plugin/marketplace.json`
4. Ask for **explicit confirmation**
5. Delete only after confirmation

## Operation summary

After every operation, produce:

```markdown
## Skill Manager Result

### Operation
[create / update / rename / delete]

### Skill
[skill name]

### Status
Complete / Partial

### Distribution mode
[local / plugin]

### Files affected
| File | Action |
|---|---|
| `skills/[name].md` | [created / updated / renamed / deleted] |
| `.claude/skills/[name]/SKILL.md` | [created / updated / renamed / deleted] |
| `[name]/.claude-plugin/plugin.json` | [created / updated / renamed / deleted] (plugin only) |
| `[name]/skills/[name]/SKILL.md` | [created / updated / renamed / deleted] (plugin only) |
| `.claude-plugin/marketplace.json` | [updated] (plugin only) |

### Validation
[Pass / Pass with corrections]

### Notes
[Any relevant observations]
```

## Rules

- **Interview in the user's language**, generated skill content always in **English**
- Ask **one question at a time** when gathering information
- **Do not evaluate, critique, or suggest** during the interview — only gather information
- **Do not skip dimensions** — if a dimension is not yet covered, ask about it
- Summarize progress every 3-5 turns during the interview
- Approval on **compact summary** before generating full files
- Never modify `shared-foundation.md` or extension files
- Both skill files must always be synchronized
- Validate every create and update against the foundation
- Auto-correct when possible, ask when not
- User approval required before saving (create/update) or deleting

## Failure behavior

| Situation | Behavior |
|---|---|
| No intent provided | Default to create |
| Description too vague | Ask targeted questions to fill gaps |
| Skill not found (update/rename/delete) | Report error, ask user to verify name |
| Reference files missing | "Reference files are missing. Cannot proceed without shared-foundation.md." |
| Validation failure | Auto-correct and report |
| Conflicting instructions | Present conflict, ask user to choose |
| Request to modify foundation/extensions | "The shared foundation and extension files are read-only. They cannot be modified through this skill." |
| Subject is not a skill | "This skill manages skills within the project. The provided subject does not appear to be a skill." |
