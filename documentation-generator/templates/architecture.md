# Architecture

<!--
TEMPLATE INSTRUCTIONS:
This document should provide a high-level overview of the system architecture.
Investigate: main entry points, directory structure, key modules, external dependencies.
-->

## Overview

<!--
Provide a 2-3 sentence description of what this system does and its primary purpose.
Look at: README.md, package.json description, main entry file comments.
-->

## Tech Stack

<!--
List the primary technologies used. Include:
- Programming language(s) and version
- Framework(s)
- Database(s)
- Key libraries/dependencies
- Infrastructure (if known)
-->

| Category | Technology |
|----------|------------|
| Language | |
| Framework | |
| Database | |
| Key Libraries | |

## System Components

<!--
Describe the major components/modules and their responsibilities.
Look at: top-level directories, main source folders, package structure.
For each component, explain:
- What it does
- What it depends on
- What depends on it
-->

### Component 1

**Purpose:**

**Key files:**

**Dependencies:**

## Data Flow

<!--
Describe how data moves through the system.
Consider: request/response cycle, data processing pipelines, event flows.
A diagram (mermaid or ASCII) is helpful here.
-->

```
[Request] --> [Component A] --> [Component B] --> [Database]
                   |
                   v
              [Response]
```

## Directory Structure

<!--
Explain the purpose of key directories.
Focus on directories that aren't self-explanatory.
-->

```
project-root/
├── src/           #
├── lib/           #
├── tests/         #
├── config/        #
└── ...
```

## Key Design Decisions

<!--
Document important architectural choices and their rationale.
Look for: ARCHITECTURE.md, ADRs (Architecture Decision Records), code comments.
Include decisions about:
- Why certain patterns were chosen
- Trade-offs that were made
- Constraints that influenced the design
-->

### Decision 1: [Title]

**Context:**

**Decision:**

**Consequences:**

## External Integrations

<!--
List external services, APIs, or systems this project integrates with.
Include: third-party APIs, cloud services, message queues, etc.
-->

| Integration | Purpose | Configuration |
|-------------|---------|---------------|
| | | |
