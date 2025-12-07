# User Story Generator

Generate INVEST-compliant user stories from functional specifications and personas.

## Features

- Transforms functional specifications into structured user stories
- Supports persona-driven story writing
- Generates Gherkin acceptance criteria (Given/When/Then)
- Organizes stories by Epic → Feature → Story hierarchy
- Tracks dependencies between stories
- Provides implementation order recommendations

## Usage

```
/generate-user-stories
```

The command will guide you through:

1. **Configuration** - Specify your specs folder, personas folder (optional), and output location
2. **Discovery** - Analyzes your specifications and personas
3. **Organization** - Proposes epics and features for your approval
4. **Generation** - Creates INVEST-compliant user stories with Gherkin acceptance criteria
5. **Dependencies** - Maps relationships and suggests implementation order
6. **Review** - Presents summary and quality checklist

## Input

### Functional Specifications

Place your functional specification documents in a folder (e.g., `docs/specifications/`). Supported formats:
- Markdown (`.md`)
- Text files (`.txt`)

The plugin handles various specification styles:
- Requirements lists (REQ-001, etc.)
- Feature descriptions
- Use cases
- User flows
- Narrative prose

### Personas (Optional)

Place persona documents in a separate folder (e.g., `docs/personas/`). Include:
- Role/job title
- Goals and motivations
- Pain points
- Technical proficiency
- Key tasks

If no personas are provided, the plugin will identify user types from your specifications.

## Output

Generated user stories are organized as:

```
user-stories/
├── README.md              # Overview and index
├── epics/
│   └── {epic}.md          # Epic overviews
├── features/
│   └── {feature}/
│       ├── _index.md      # Feature overview
│       └── US-001-*.md    # Individual stories
└── dependencies.md        # Dependency map
```

### User Story Format

Each story includes:
- **User Story**: "As a [persona], I want [goal], So that [benefit]"
- **Acceptance Criteria**: Gherkin scenarios (Given/When/Then)
- **Dependencies**: Hard and soft dependencies on other stories
- **INVEST Checklist**: Verification of story quality
- **Traceability**: Links back to source specifications

### Example Story

```markdown
## US-001: User Registration

> **As a** new visitor,
> **I want** to create an account with my email and password,
> **So that** I can access personalized features.

### Acceptance Criteria

#### AC1: Successful Registration
```gherkin
Given I am on the registration page
When I enter a valid email and password
And I click "Create Account"
Then my account is created
And I see a confirmation message
```

#### AC2: Duplicate Email
```gherkin
Given an account exists with "user@example.com"
When I try to register with "user@example.com"
Then I see "Email already exists" error
```
```

## Best Practices Applied

### INVEST Criteria

Every generated story is verified against:
- **I**ndependent - Can be developed in any order
- **N**egotiable - Open to discussion
- **V**aluable - Delivers user value
- **E**stimable - Effort can be estimated
- **S**mall - Fits in a sprint
- **T**estable - Has verifiable acceptance criteria

### Gherkin Acceptance Criteria

All acceptance criteria use Given/When/Then format:
- Directly translatable to automated tests
- Unambiguous success criteria
- Readable by non-technical stakeholders

### Dependency Tracking

Stories include:
- **Hard dependencies**: Must be completed first
- **Soft dependencies**: Easier if done in order
- **Implementation phases**: Suggested development sequence

## Installation

Add to your Claude Code plugins:

```bash
claude plugins add claude-code-plugins/user-story-generator
```

## License

MIT
