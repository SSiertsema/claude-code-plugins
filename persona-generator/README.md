# Persona Generator

Create detailed user personas through interactive dialogue for user story development.

## Overview

This plugin guides you through a structured conversation to create realistic, actionable personas. Personas help teams understand their users and write better user stories.

## Usage

```
/generate-personas
```

The command will guide you through:

1. **Discovery** - Check for existing documentation and personas
2. **Identify User Types** - Discover the different users of your system
3. **Deep Dive** - Answer questions about each persona's goals, pain points, tasks
4. **Generate** - Create detailed persona documents from a template
5. **Summary** - Review all personas and get user story mapping guidance

## Interactive Questionnaire

The agent asks targeted questions across these areas:

| Area | Questions About |
|------|-----------------|
| **Identity** | Role, department, experience level |
| **Goals** | Primary objectives, motivations, success metrics |
| **Pain Points** | Current frustrations, workarounds, impact |
| **Technical Profile** | Proficiency, devices, usage frequency |
| **Tasks** | Key activities, frequency, complexity |
| **Environment** | Tools used, stakeholders, constraints |
| **Mindset** | Representative quotes capturing their perspective |

## Output

Personas are saved to `documentation/business/personas/`:

```
documentation/business/personas/
├── sarah-sales-manager.md
├── alex-system-admin.md
└── jordan-end-user.md
```

### Persona Structure

Each persona includes:

- **Demographics** - Role, department, experience
- **Goals & Motivations** - What they want to achieve
- **Pain Points** - Current frustrations with impact ratings
- **Behaviors** - Technical proficiency, usage patterns
- **Key Tasks** - What they need to do, with frequency
- **Environment** - Tools, stakeholders, constraints
- **Quotes** - Representative mindset statements
- **Scenarios** - Success and frustration examples
- **User Story Mapping** - How to use this persona in stories

## Example Persona Output

```markdown
# Persona: Sarah the Sales Manager

**ID:** `sarah-sales-manager`

## Overview

> Mid-level sales manager responsible for a team of 8 reps, focused on hitting quarterly targets.

## Goals & Motivations

### Primary Goals
1. Track team performance against quota in real-time
2. Identify at-risk deals before they slip

### Motivations
- Save time on manual reporting (currently 4 hours/week)
- Look prepared in leadership meetings
- Help struggling reps improve faster

## Pain Points

| Pain Point | Impact | Workaround |
|------------|--------|------------|
| Manual data consolidation from multiple systems | High | Weekly spreadsheet ritual |
| No early warning for at-risk deals | High | Gut feeling, often too late |
| Can't see rep activity in real-time | Medium | Daily standups |

## User Story Mapping

- **"As a..."**: Sales Manager
- **Goals inform**: "I want to see real-time team performance..."
- **Pain Points inform**: "...so that I don't waste hours on manual reports"
```

## Using Personas for User Stories

After creating personas, use them with the user-story-generator:

```
/generate-user-stories
```

The user story generator will:
1. Read your persona files
2. Map personas to user stories
3. Use pain points to inform "So that..." benefits

## Workflow Integration

```
┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│  /generate-personas │────▶│ /generate-user-     │────▶│  Development with   │
│                     │     │    stories          │     │  vue-development    │
│  Create user        │     │                     │     │  skill              │
│  personas           │     │  Generate stories   │     │                     │
│                     │     │  from specs +       │     │  Implement with     │
│                     │     │  personas           │     │  TDD + E2E          │
└─────────────────────┘     └─────────────────────┘     └─────────────────────┘
```

## Installation

Add to your Claude Code plugins:

```bash
claude plugins add claude-code-plugins/persona-generator
```

## License

MIT
