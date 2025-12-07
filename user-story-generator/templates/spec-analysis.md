# Specification Analysis Guide

<!--
TEMPLATE INSTRUCTIONS:
Use this guide when reading functional specification documents to extract
requirements for user story generation.
-->

## Document Structure Detection

First, identify the specification format:

| Format | Indicators | Parsing Approach |
|--------|------------|------------------|
| **Requirements List** | REQ-001, numbered items, "shall" statements | Extract each requirement as potential story |
| **Feature Descriptions** | "Feature:" headings, use cases | Group into features, decompose to stories |
| **User Flows** | Flowcharts, numbered steps, sequences | Trace paths, create story per decision point |
| **Prose/Narrative** | Paragraphs describing behavior | Extract actors, verbs, and outcomes |
| **Use Cases** | Actor, preconditions, steps, postconditions | Map directly to stories and acceptance criteria |

---

## Requirement Extraction

For each requirement found, capture:

| Field | Description | Example |
|-------|-------------|---------|
| **ID** | Requirement identifier | REQ-001, FR-12 |
| **Source** | File and section | `auth-spec.md#login` |
| **Type** | Functional / Non-functional / Constraint | Functional |
| **Description** | The requirement text | "Users shall be able to reset password" |
| **Actors** | Who performs/benefits | End User, Admin |
| **Preconditions** | What must be true before | User is registered |
| **Triggers** | What initiates the action | User clicks "Forgot Password" |
| **Outcomes** | Expected results | Password reset email sent |
| **Related** | Connected requirements | REQ-002, REQ-003 |

---

## Feature Identification

Group requirements into features by:

### Grouping Criteria

1. **Shared Actor**: Requirements for the same user type
2. **Shared Domain Object**: Requirements about the same entity (User, Order, Report)
3. **Shared Workflow**: Requirements in the same business process
4. **Explicit Grouping**: Sections/headings in the specification

### Example Grouping

```
Specification mentions:
- REQ-001: User registration
- REQ-002: Email verification
- REQ-003: Password requirements
- REQ-004: User login
- REQ-005: Password reset

Grouped into features:
├── Feature: User Registration (REQ-001, REQ-002, REQ-003)
└── Feature: Authentication (REQ-004, REQ-005)
```

---

## Requirement-to-Story Mapping

| Requirement Type | Story Mapping |
|------------------|---------------|
| **Functional** | Direct 1:1 mapping to user story |
| **Non-functional** | Becomes acceptance criteria or enabler story |
| **Constraint** | Becomes acceptance criteria |
| **Integration** | May need multiple stories (setup, use, error handling) |

---

## Decomposition Rules

### When to Split (One requirement → Multiple stories)

Split when:

1. **Multiple actors**: "Users and admins can edit profiles"
   → Story 1: User edits own profile
   → Story 2: Admin edits any profile

2. **Multiple actions**: "User can add, edit, and delete items"
   → Story 1: Add item
   → Story 2: Edit item
   → Story 3: Delete item

3. **Complex flow**: "User completes checkout"
   → Story 1: Add to cart
   → Story 2: Enter shipping info
   → Story 3: Enter payment
   → Story 4: Confirm order

4. **Optional features**: "User can optionally add notes"
   → Separate story for the optional capability

### When to Keep Together (One requirement → One story)

Keep together when:

1. **Atomic action**: Cannot be meaningfully split
2. **Single actor, single goal**: Clear focus
3. **Sprint-sized**: Can be completed in one iteration
4. **Tightly coupled**: Splitting would create incomplete functionality

---

## Extracting Acceptance Criteria

Look for these in specifications to inform Gherkin scenarios:

| Specification Content | Acceptance Criteria Type |
|-----------------------|-------------------------|
| "must", "shall", "required" | Happy path criteria |
| "valid", "invalid", "error" | Validation/error scenarios |
| "minimum", "maximum", "at least" | Boundary conditions |
| "when X then Y" | Direct Given/When/Then mapping |
| "unless", "except", "only if" | Edge case scenarios |

### Example Extraction

**Specification text:**
> "Users must enter a password of at least 8 characters containing one uppercase letter, one number, and one special character. Invalid passwords should display specific error messages."

**Extracted Acceptance Criteria:**

```gherkin
# AC1: Valid password accepted
Given I am on the registration page
When I enter a password "MyPass1!" meeting all requirements
Then the password is accepted

# AC2: Password too short
Given I am on the registration page
When I enter a password "Short1!"
Then I see "Password must be at least 8 characters"

# AC3: Missing uppercase
Given I am on the registration page
When I enter a password "mypass1!"
Then I see "Password must contain an uppercase letter"

# AC4: Missing number
Given I am on the registration page
When I enter a password "MyPasswd!"
Then I see "Password must contain a number"

# AC5: Missing special character
Given I am on the registration page
When I enter a password "MyPass12"
Then I see "Password must contain a special character"
```

---

## Ambiguity Handling

When requirements are unclear:

### Low Impact Ambiguity

Make reasonable assumptions and document:
```
**Assumption:** "Recent items" interpreted as last 30 days.
**Source:** REQ-045 does not specify time range.
```

### High Impact Ambiguity

Ask the user before proceeding:
```
REQ-045 mentions "recent items" but doesn't define the time range.
Options:
1. Last 7 days
2. Last 30 days
3. Configurable by user
Which interpretation should I use?
```

---

## Quality Indicators

### Good Requirements (easy to convert)

- Clear actor/persona
- Specific action/goal
- Measurable outcome
- Bounded scope

### Problematic Requirements (need attention)

| Issue | Example | Action |
|-------|---------|--------|
| Vague | "System shall be user-friendly" | Ask for specific criteria |
| Unbounded | "Support all file types" | Define explicit list |
| Unmeasurable | "Fast response times" | Request specific metrics |
| Compound | "User can do X, Y, and Z" | Split into separate stories |

Mark problematic requirements with "Needs Refinement" in generated stories.
