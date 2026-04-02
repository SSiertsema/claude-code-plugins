# Acceptance Criteria Parsing Guide

This guide explains how to extract and validate Gherkin acceptance criteria from user stories.

## User Story Input Format

The skill expects user stories in this format:

```markdown
## {STORY_ID}: {Story Title}

> **As a** {persona},
> **I want** {goal},
> **So that** {benefit}.

### Acceptance Criteria

#### AC1: {Criterion Title}

```gherkin
Given {precondition}
When {action}
Then {expected result}
```

#### AC2: {Criterion Title}

```gherkin
Given {precondition}
When {action}
And {additional action}
Then {expected result}
And {additional result}
```
```

---

## Parsing Steps

### Step 1: Extract Story Metadata

From the user story header, extract:

| Field | Pattern | Example |
|-------|---------|---------|
| Story ID | `## {ID}:` | `US-001` |
| Title | `## {ID}: {Title}` | `User Login` |
| Persona | `As a {persona}` | `registered user` |
| Goal | `I want {goal}` | `to login with my credentials` |
| Benefit | `So that {benefit}` | `I can access my account` |

### Step 2: Extract Acceptance Criteria

For each `#### AC{n}:` section:

1. **ID**: Extract `AC1`, `AC2`, etc.
2. **Title**: Text after the colon
3. **Gherkin**: Content within ` ```gherkin ` block

### Step 3: Parse Gherkin Statements

Each Gherkin block contains:

| Keyword | Purpose | Example |
|---------|---------|---------|
| `Given` | Precondition/setup | `Given I am on the login page` |
| `When` | Action/trigger | `When I click "Login"` |
| `And` | Additional Given/When/Then | `And I fill "email" with "x"` |
| `Then` | Expected outcome | `Then I see "Welcome"` |

**Parse into structured format:**

```json
{
  "id": "AC1",
  "title": "Successful login",
  "steps": [
    { "keyword": "Given", "text": "I am on the login page" },
    { "keyword": "When", "text": "I fill \"email\" with \"user@example.com\"" },
    { "keyword": "And", "text": "I fill \"password\" with \"password123\"" },
    { "keyword": "And", "text": "I click \"Login\"" },
    { "keyword": "Then", "text": "I am redirected to the dashboard" },
    { "keyword": "And", "text": "I see \"Welcome back\"" }
  ]
}
```

---

## Mapping AC to Tests

### Unit Tests (Vitest)

Acceptance criteria inform what unit tests to write:

| Gherkin | Unit Test Focus |
|---------|-----------------|
| `Given form is empty` | Test initial state |
| `When I click submit` | Test emit/handler |
| `Then error is shown` | Test conditional rendering |
| `Then field is disabled` | Test computed/reactive state |

**Example mapping:**

```gherkin
Given I am on the login form
When I enter invalid email "not-an-email"
And I click "Login"
Then I see "Please enter a valid email"
```

**Unit test:**
```typescript
it('shows validation error for invalid email', async () => {
  const wrapper = mount(LoginForm)
  await wrapper.find('[name="email"]').setValue('not-an-email')
  await wrapper.find('button').trigger('click')
  expect(wrapper.text()).toContain('Please enter a valid email')
})
```

### E2E Tests (Playwright MCP)

Acceptance criteria execute directly via Playwright:

```gherkin
Given I am on the login page
When I fill "email" with "user@example.com"
And I click "Login"
Then I am redirected to the dashboard
```

**Playwright execution:**
```
1. mcp__playwright__browser_navigate → /login
2. mcp__playwright__browser_fill → email field
3. mcp__playwright__browser_click → Login button
4. mcp__playwright__browser_snapshot → verify /dashboard URL
```

---

## AC Categories

### Happy Path (Required)

Every story needs at least one happy path AC:

```gherkin
# AC1: Successful completion
Given {valid preconditions}
When {correct user action}
Then {successful outcome}
```

### Validation/Error (Recommended)

Test invalid inputs and error states:

```gherkin
# AC2: Invalid input handling
Given {preconditions}
When {invalid user action}
Then {appropriate error message}
And {user can retry}
```

### Edge Cases (As Needed)

Test boundary conditions:

```gherkin
# AC3: Empty state
Given {no data exists}
When {user views the page}
Then {empty state message shown}

# AC4: Maximum limit
Given {data at max capacity}
When {user tries to add more}
Then {limit message shown}
```

### Accessibility (Recommended)

Test keyboard and screen reader support:

```gherkin
# AC5: Keyboard navigation
Given I am on the form
When I press Tab
Then focus moves to next field
And focus indicator is visible
```

---

## Validation Checklist

Before executing E2E tests, verify:

- [ ] All `Given` steps have corresponding setup
- [ ] All `When` steps map to Playwright actions
- [ ] All `Then` steps have measurable assertions
- [ ] Happy path AC exists
- [ ] Error scenarios covered
- [ ] Test data is available (users, etc.)

---

## Complete Example

### Input: User Story

```markdown
## US-042: Password Reset

> **As a** registered user,
> **I want** to reset my forgotten password,
> **So that** I can regain access to my account.

### Acceptance Criteria

#### AC1: Request password reset

```gherkin
Given I am on the login page
When I click "Forgot password?"
Then I see the password reset form
And I see an email input field
```

#### AC2: Submit reset request

```gherkin
Given I am on the password reset form
When I fill "email" with "user@example.com"
And I click "Send reset link"
Then I see "Check your email for reset instructions"
```

#### AC3: Invalid email

```gherkin
Given I am on the password reset form
When I fill "email" with "not-registered@example.com"
And I click "Send reset link"
Then I see "No account found with this email"
```
```

### Parsed Structure

```json
{
  "story": {
    "id": "US-042",
    "title": "Password Reset",
    "persona": "registered user",
    "goal": "to reset my forgotten password",
    "benefit": "I can regain access to my account"
  },
  "acceptance_criteria": [
    {
      "id": "AC1",
      "title": "Request password reset",
      "type": "happy_path",
      "steps": [
        { "keyword": "Given", "text": "I am on the login page" },
        { "keyword": "When", "text": "I click \"Forgot password?\"" },
        { "keyword": "Then", "text": "I see the password reset form" },
        { "keyword": "And", "text": "I see an email input field" }
      ]
    },
    {
      "id": "AC2",
      "title": "Submit reset request",
      "type": "happy_path",
      "steps": [
        { "keyword": "Given", "text": "I am on the password reset form" },
        { "keyword": "When", "text": "I fill \"email\" with \"user@example.com\"" },
        { "keyword": "And", "text": "I click \"Send reset link\"" },
        { "keyword": "Then", "text": "I see \"Check your email for reset instructions\"" }
      ]
    },
    {
      "id": "AC3",
      "title": "Invalid email",
      "type": "error",
      "steps": [
        { "keyword": "Given", "text": "I am on the password reset form" },
        { "keyword": "When", "text": "I fill \"email\" with \"not-registered@example.com\"" },
        { "keyword": "And", "text": "I click \"Send reset link\"" },
        { "keyword": "Then", "text": "I see \"No account found with this email\"" }
      ]
    }
  ]
}
```

### E2E Execution Plan

```
AC1: Request password reset
  1. Navigate to /login
  2. Click "Forgot password?" link
  3. Snapshot: verify reset form visible
  4. Snapshot: verify email input exists
  Result: PASS/FAIL

AC2: Submit reset request
  1. Navigate to /forgot-password (or continue from AC1)
  2. Fill email with "user@example.com"
  3. Click "Send reset link"
  4. Snapshot: verify success message
  Result: PASS/FAIL

AC3: Invalid email
  1. Navigate to /forgot-password
  2. Fill email with "not-registered@example.com"
  3. Click "Send reset link"
  4. Snapshot: verify error message
  Result: PASS/FAIL

Overall: 3/3 PASS → E2E Validation PASS
```
