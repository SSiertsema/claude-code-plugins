# Epic Template

<!--
TEMPLATE INSTRUCTIONS:
This template defines the structure for epic overview documents.
An epic groups related features around a common theme or goal.
-->

# Epic: {Epic Name}

**ID:** {EPIC-XX}
**Status:** Draft
**Created:** {Date}

---

## Overview

<!--
Describe the epic's purpose and scope.
What business objective does this epic serve?
-->

{High-level description of what this epic encompasses and why it exists.}

---

## Business Value

<!--
Why is this epic important?
What problem does it solve?
Who benefits from its completion?
-->

{Description of the value delivered when this epic is complete.}

---

## Scope

### In Scope

<!--
What is included in this epic?
-->

- {Functionality included}
- {User capabilities enabled}

### Out of Scope

<!--
What is explicitly NOT part of this epic?
Helps prevent scope creep.
-->

- {Related functionality that belongs elsewhere}
- {Future enhancements not included}

---

## Features

<!--
List all features that belong to this epic.
Link to feature index files.
-->

| Feature | Description | Stories |
|---------|-------------|---------|
| [{Feature Name}](../features/{feature-slug}/_index.md) | {Brief description} | {count} |

---

## Personas Involved

<!--
Which personas interact with features in this epic?
-->

| Persona | Role | Primary Features |
|---------|------|------------------|
| {Persona Name} | {Role} | {Features they primarily use} |

---

## Dependencies

### Epic Dependencies

<!--
Does this epic depend on other epics being complete?
-->

- **Depends on:** {List of prerequisite epics, or "None"}
- **Blocks:** {List of epics that depend on this one, or "None"}

### External Dependencies

<!--
Are there external factors this epic depends on?
-->

- {External systems, third-party services, or "None"}

---

## User Stories Summary

<!--
Aggregate view of all stories in this epic.
-->

**Total Stories:** {count}

| Feature | Story Count |
|---------|-------------|
| {Feature Name} | {n} |

---

## Source Specifications

<!--
Link to the source documents this epic was derived from.
-->

| Specification | Relevant Sections |
|---------------|-------------------|
| {spec-name.md} | {Section references} |
