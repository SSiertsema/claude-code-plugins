# Gherkin to Playwright Test File Generation

This guide shows how to generate Playwright test files from Gherkin acceptance criteria.

## Output Location

E2E test files are written to: `tests/e2e/{story-id}-{feature-slug}.spec.ts`

Examples:
- `tests/e2e/us-001-user-login.spec.ts`
- `tests/e2e/us-042-password-reset.spec.ts`
- `tests/e2e/us-103-checkout-flow.spec.ts`

---

## Quick Reference

| Gherkin Pattern | Playwright Code |
|-----------------|-----------------|
| `Given I am on "{url}"` | `await page.goto('{url}')` |
| `When I click "{text}"` | `await page.click('text={text}')` |
| `When I click the "{selector}" button` | `await page.click('{selector}')` |
| `When I fill "{field}" with "{value}"` | `await page.fill('[name="{field}"]', '{value}')` |
| `When I select "{option}" from "{field}"` | `await page.selectOption('[name="{field}"]', '{option}')` |
| `When I press "{key}"` | `await page.keyboard.press('{key}')` |
| `Then I see "{text}"` | `await expect(page.locator('text={text}')).toBeVisible()` |
| `Then I am redirected to "{url}"` | `await expect(page).toHaveURL(/{url}/)` |
| `Then the "{element}" is visible` | `await expect(page.locator('{element}')).toBeVisible()` |
| `Then the "{element}" is not visible` | `await expect(page.locator('{element}')).not.toBeVisible()` |

---

## Test File Structure

### Template

```typescript
// tests/e2e/{story-id}-{feature-slug}.spec.ts
import { test, expect } from '@playwright/test'

/**
 * {STORY_ID}: {Story Title}
 * As a {persona}, I want {goal}, so that {benefit}.
 */
test.describe('{STORY_ID}: {Story Title}', () => {

  test('{AC_ID}: {AC Title}', async ({ page }) => {
    // Given {precondition}
    // Playwright code...

    // When {action}
    // Playwright code...

    // Then {expected result}
    // Playwright code...
  })

})
```

### Complete Example

**Input: User Story**

```markdown
## US-001: User Login

> **As a** registered user,
> **I want** to login with my credentials,
> **So that** I can access my account.

### Acceptance Criteria

#### AC1: Successful login

```gherkin
Given I am on the login page
When I fill "email" with "user@example.com"
And I fill "password" with "password123"
And I click "Login"
Then I am redirected to the dashboard
And I see "Welcome back"
```

#### AC2: Invalid password

```gherkin
Given I am on the login page
When I fill "email" with "user@example.com"
And I fill "password" with "wrong"
And I click "Login"
Then I see "Invalid credentials"
```
```

**Output: Test File**

```typescript
// tests/e2e/us-001-user-login.spec.ts
import { test, expect } from '@playwright/test'

/**
 * US-001: User Login
 * As a registered user, I want to login with my credentials,
 * so that I can access my account.
 */
test.describe('US-001: User Login', () => {

  test('AC1: Successful login', async ({ page }) => {
    // Given I am on the login page
    await page.goto('/login')

    // When I fill "email" with "user@example.com"
    await page.fill('[name="email"]', 'user@example.com')

    // And I fill "password" with "password123"
    await page.fill('[name="password"]', 'password123')

    // And I click "Login"
    await page.click('button:has-text("Login")')

    // Then I am redirected to the dashboard
    await expect(page).toHaveURL(/dashboard/)

    // And I see "Welcome back"
    await expect(page.locator('text=Welcome back')).toBeVisible()
  })

  test('AC2: Invalid password', async ({ page }) => {
    // Given I am on the login page
    await page.goto('/login')

    // When I fill "email" with "user@example.com"
    await page.fill('[name="email"]', 'user@example.com')

    // And I fill "password" with "wrong"
    await page.fill('[name="password"]', 'wrong')

    // And I click "Login"
    await page.click('button:has-text("Login")')

    // Then I see "Invalid credentials"
    await expect(page.locator('text=Invalid credentials')).toBeVisible()
  })

})
```

---

## Gherkin to Playwright Mappings

### Navigation

```gherkin
Given I am on the login page
Given I am on "/dashboard"
Given I am on the home page
```

```typescript
await page.goto('/login')
await page.goto('/dashboard')
await page.goto('/')
```

### Click Actions

```gherkin
When I click "Submit"
When I click the login button
When I click on "Save Changes"
When I click the ".cancel-btn" button
```

```typescript
await page.click('text=Submit')
await page.click('button:has-text("Login")')
await page.click('text=Save Changes')
await page.click('.cancel-btn')
```

### Form Input

```gherkin
When I fill "email" with "user@example.com"
When I enter "password123" in the password field
When I type "search query" in the search box
When I clear the "username" field
```

```typescript
await page.fill('[name="email"]', 'user@example.com')
await page.fill('#password', 'password123')
await page.fill('[placeholder="Search"]', 'search query')
await page.fill('[name="username"]', '')
```

### Select/Dropdown

```gherkin
When I select "United States" from "country"
When I choose "Large" from the size dropdown
```

```typescript
await page.selectOption('[name="country"]', 'United States')
await page.selectOption('#size', 'Large')
```

### Keyboard Actions

```gherkin
When I press Enter
When I press Tab
When I press Escape
```

```typescript
await page.keyboard.press('Enter')
await page.keyboard.press('Tab')
await page.keyboard.press('Escape')
```

### Checkbox/Radio

```gherkin
When I check "remember me"
When I uncheck "subscribe to newsletter"
When I select the "express" shipping option
```

```typescript
await page.check('[name="remember"]')
await page.uncheck('[name="subscribe"]')
await page.check('input[value="express"]')
```

### Text Assertions

```gherkin
Then I see "Welcome back"
Then I see the message "Login successful"
Then the error "Invalid password" is displayed
```

```typescript
await expect(page.locator('text=Welcome back')).toBeVisible()
await expect(page.locator('text=Login successful')).toBeVisible()
await expect(page.locator('text=Invalid password')).toBeVisible()
```

### URL Assertions

```gherkin
Then I am redirected to the dashboard
Then I am redirected to "/profile"
Then I remain on the login page
```

```typescript
await expect(page).toHaveURL(/dashboard/)
await expect(page).toHaveURL('/profile')
await expect(page).toHaveURL(/login/)
```

### Element State Assertions

```gherkin
Then the submit button is disabled
Then the loading spinner is visible
Then the error message is not visible
Then the "email" field is empty
```

```typescript
await expect(page.locator('button[type="submit"]')).toBeDisabled()
await expect(page.locator('.loading-spinner')).toBeVisible()
await expect(page.locator('.error-message')).not.toBeVisible()
await expect(page.locator('[name="email"]')).toHaveValue('')
```

### Form Value Assertions

```gherkin
Then the email field contains "user@example.com"
Then the checkbox is checked
Then the dropdown shows "Option A"
```

```typescript
await expect(page.locator('[name="email"]')).toHaveValue('user@example.com')
await expect(page.locator('[name="remember"]')).toBeChecked()
await expect(page.locator('select')).toHaveValue('Option A')
```

### Count Assertions

```gherkin
Then I see 3 items in the list
Then there are no error messages
Then I see at least 1 result
```

```typescript
await expect(page.locator('.list-item')).toHaveCount(3)
await expect(page.locator('.error')).toHaveCount(0)
expect(await page.locator('.result').count()).toBeGreaterThanOrEqual(1)
```

---

## Element Selectors

Use these selector strategies in order of preference:

### 1. Test IDs (Preferred)

```vue
<button data-testid="submit-login">Login</button>
```
```typescript
await page.click('[data-testid="submit-login"]')
```

### 2. Role + Text

```vue
<button>Submit</button>
```
```typescript
await page.click('button:has-text("Submit")')
```

### 3. Name Attribute

```vue
<input name="email" />
```
```typescript
await page.fill('[name="email"]', 'value')
```

### 4. Placeholder

```vue
<input placeholder="Enter email" />
```
```typescript
await page.fill('[placeholder="Enter email"]', 'value')
```

### 5. ID

```vue
<input id="email" />
```
```typescript
await page.fill('#email', 'value')
```

### 6. Text Content

```vue
<a>Click here</a>
```
```typescript
await page.click('text=Click here')
```

---

## Waiting Patterns

### Implicit Waits

Playwright auto-waits for elements. These are usually sufficient:

```typescript
await page.click('button')  // Waits for button to be clickable
await expect(page.locator('text=Success')).toBeVisible()  // Waits up to timeout
```

### Explicit Waits

For specific scenarios:

```typescript
// Wait for navigation
await page.waitForURL(/dashboard/)

// Wait for element
await page.waitForSelector('.modal')

// Wait for network idle
await page.waitForLoadState('networkidle')

// Wait for specific response
await page.waitForResponse(response => response.url().includes('/api/login'))
```

---

## Running Tests

### Commands

```bash
# Run specific test file
npx playwright test tests/e2e/us-001-user-login.spec.ts

# Run all E2E tests
npx playwright test tests/e2e/

# Run with headed browser (visible)
npx playwright test tests/e2e/us-001-user-login.spec.ts --headed

# Run with UI mode for debugging
npx playwright test tests/e2e/us-001-user-login.spec.ts --ui

# Run specific test by name
npx playwright test -g "AC1: Successful login"
```

### Expected Output

```
Running 2 tests using 1 worker

  ✓ US-001: User Login › AC1: Successful login (2.1s)
  ✓ US-001: User Login › AC2: Invalid password (1.8s)

  2 passed (4.2s)
```

---

## Tips for Reliable Tests

1. **Keep Gherkin as comments**: Preserve the original Gherkin in comments for traceability
2. **Use data-testid**: Add `data-testid` attributes to components for stable selectors
3. **One AC = One test**: Each acceptance criterion becomes exactly one test
4. **Preserve assertion order**: Match Then assertions to Gherkin Then statements in order
5. **Handle async operations**: Use Playwright's built-in waiting or explicit waits for async UI
6. **Avoid hardcoded waits**: Never use `page.waitForTimeout()` - use proper assertions instead
