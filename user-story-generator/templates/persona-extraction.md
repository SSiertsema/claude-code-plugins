# Persona Extraction Guide

<!--
TEMPLATE INSTRUCTIONS:
Use this guide when reading persona documents to extract relevant information
for user story generation.
-->

## Required Information

When reading a persona file, extract the following:

### Identity

| Field | Description | Example |
|-------|-------------|---------|
| **Persona ID** | Short identifier for referencing | `end-user`, `admin`, `manager` |
| **Name** | Representative name | "Sarah the Sales Manager" |
| **Role** | Their job title or function | "Sales Manager" |
| **Description** | Brief persona summary | "Mid-level manager responsible for team performance" |

### Goals & Motivations

Extract what this persona wants to achieve:

```
Goals:
- Primary: {Main objective they're trying to accomplish}
- Secondary: {Supporting objectives}

Motivations:
- {What drives them to use the system}
- {What success looks like for them}
```

### Pain Points

What frustrations or challenges do they face?

```
Pain Points:
- {Current problem they face}
- {Friction in existing workflows}
- {Unmet needs}
```

These pain points often translate directly into user story benefits ("So that...").

### Characteristics

| Characteristic | Options | Impact on Stories |
|----------------|---------|-------------------|
| **Technical Proficiency** | Non-technical / Basic / Intermediate / Advanced | Affects complexity of features and UI expectations |
| **Usage Frequency** | Daily / Weekly / Monthly / Occasional | Impacts onboarding and discoverability needs |
| **Device Preference** | Desktop / Mobile / Tablet / All | May generate device-specific stories |

### Key Tasks

What does this persona need to do in the system?

```
Tasks:
1. {Primary task} - {Frequency}
2. {Secondary task} - {Frequency}
3. {Tertiary task} - {Frequency}
```

These tasks often map directly to features and user stories.

---

## Mapping to User Stories

When generating stories, use persona information as follows:

| Persona Field | User Story Element |
|---------------|-------------------|
| Role | "As a [role]..." |
| Goals | "I want [goal]..." |
| Pain Points | "So that [pain point is resolved]..." |
| Tasks | Feature identification |
| Technical Proficiency | Acceptance criteria complexity |

### Example Mapping

**Persona:**
- Role: Sales Manager
- Goal: Track team performance
- Pain Point: Currently uses spreadsheets, error-prone
- Task: Review weekly sales reports

**User Story:**
> As a **Sales Manager**,
> I want **to view an automated weekly sales report**,
> So that **I can track team performance without manual spreadsheet work**.

---

## Missing Persona Handling

If no persona documents exist, create minimal personas from specifications:

### Step 1: Identify User Types

Look for mentions in specifications:
- "user", "end user", "customer"
- "admin", "administrator", "system admin"
- "manager", "supervisor"
- Role-specific terms from the domain

### Step 2: Create Minimal Personas

For each identified user type, create:

```
**Persona ID:** {type-slug}
**Role:** {Inferred role}
**Goals:** {Inferred from features they use}
**Technical Level:** {Assume based on role}
```

### Step 3: Confirm with User

Present inferred personas:
```
I found references to these user types in your specifications:

1. **End User** - Primary application user performing core tasks
2. **Administrator** - System configuration and user management

Should I use these personas, or would you like to define them differently?
```

---

## Common Persona Archetypes

When specifications are vague, consider these common archetypes:

| Archetype | Typical Goals | Technical Level |
|-----------|---------------|-----------------|
| **End User** | Complete tasks efficiently | Non-technical to Basic |
| **Power User** | Advanced features, shortcuts | Intermediate to Advanced |
| **Administrator** | System management, user oversight | Intermediate |
| **Guest/Anonymous** | Limited access, exploration | Non-technical |
| **API Consumer** | Programmatic access | Technical |
