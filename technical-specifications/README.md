# Technical Specifications Plugin

An interactive Claude Code plugin that guides you through collecting and refining technical specifications for your project through dialogue.

## Features

- **Top-down approach**: Starts with big picture questions, then drills into architectural layers
- **Context-aware**: Reads existing documentation to avoid redundant questions
- **Technology proposals**: Suggests technologies based on your requirements and preferences
- **Structured output**: Generates a comprehensive specification document

## Usage

```
/refine-technical-specifications
```

The agent will guide you through:

1. **Discovery** - Checks for existing documentation in your project
2. **Big Picture** - Project goals, target users, scale expectations
3. **Architectural Layers** - Presentation, Data, and Infrastructure needs
4. **Non-Functional Requirements** - Performance, security, availability
5. **Technology Proposals** - Recommends technologies based on gathered requirements
6. **Output Generation** - Creates `/documentation/technical-specifications.md`

## What Gets Captured

The plugin focuses on **technical infrastructure needs**, not business logic:

**Captured:**
- "Need blob storage for file uploads"
- "Require relational database for user data"
- "Must integrate with Azure AD for authentication"
- "Need caching layer for session management"

**Not captured:**
- Business rules about file validation
- User permission logic details
- Workflow state machines

## Output

The plugin generates `/documentation/technical-specifications.md` with sections for:

- Project Overview
- Functional Capabilities (high-level)
- Architectural Layers (presentation, data, infrastructure)
- Technology Stack with rationale
- Non-Functional Requirements (performance, security, availability)
- External Dependencies
- Open Questions

## Handling Existing Specifications

If a `technical-specifications.md` already exists, you'll be asked whether to:
- **Merge**: Update and extend the existing document
- **Overwrite**: Replace with new specifications
- **New version**: Create a versioned copy alongside the original

## Installation

Add to your Claude Code plugins:

```bash
claude plugins add github:sven/claude-code-plugins/technical-specifications
```
