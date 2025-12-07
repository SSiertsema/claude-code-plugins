---
description: Refactor JavaScript logic - code splitting, patterns, ES6+ modernization
---

You are a JavaScript refactoring assistant. Your task is to autonomously refactor JavaScript code for improved readability, maintainability, and modern best practices.

## Step 1: Identify Target File

1. Check if a `.js` or `.jsx` file is currently open in the editor
2. If yes, use that file
3. If no file is open or user provides a path argument, use that instead
4. Validate the file is JavaScript (`.js` or `.jsx`)

## Step 2: Analyze Code

Analyze the entire file for:

### Code Splitting Issues
- Functions exceeding 50 lines
- Cyclomatic complexity > 10 (many conditionals/branches)
- Nesting depth > 3 levels
- Functions with > 4 parameters
- Duplicate code patterns (2+ occurrences)

### Anti-Patterns
- Magic numbers/strings (unnamed constants)
- Missing error handling in async code
- Callback hell / Promise chains that could use async/await
- Deep nesting instead of guard clauses
- Long switch statements without abstraction

### Modernization Opportunities
- `var` declarations (should be `const`/`let`)
- `.then()/.catch()` chains (should be async/await)
- Old-style functions where arrow functions fit better
- Missing destructuring opportunities
- Missing spread operator usage

## Step 3: Plan Refactoring

For each issue found, apply the appropriate resolution technique:

---

### Resolving High Cyclomatic Complexity (> 10)

**Technique A: Extract Conditional Logic to Lookup Object**
```javascript
// BEFORE: complexity = 12
function process(data) {
  if (data.type === 'A') { /* 20 lines */ }
  else if (data.type === 'B') { /* 20 lines */ }
  else if (data.type === 'C') { /* 20 lines */ }
}

// AFTER: complexity = 3 per function
const processors = {
  A: processTypeA,
  B: processTypeB,
  C: processTypeC
}
function process(data) {
  return processors[data.type]?.(data)
}
```

**Technique B: Strategy Pattern for Conditionals**
```javascript
// BEFORE
function calculatePrice(item) {
  if (item.type === 'book') return item.price * 0.9
  if (item.type === 'electronics') return item.price * 1.1
}

// AFTER
const pricingStrategies = {
  book: (item) => item.price * 0.9,
  electronics: (item) => item.price * 1.1
}
const calculatePrice = (item) => pricingStrategies[item.type](item)
```

**Technique C: Decompose Boolean Expressions**
```javascript
// BEFORE
if (user.age > 18 && user.hasLicense && !user.isSuspended && user.balance > 0) {}

// AFTER
const isEligibleDriver = (user) =>
  user.age > 18 && user.hasLicense && !user.isSuspended && user.balance > 0

if (isEligibleDriver(user)) {}
```

---

### Resolving Deep Nesting (> 3 levels)

**Technique A: Guard Clauses (Early Returns)**
```javascript
// BEFORE: 4 levels deep
function process(data) {
  if (data) {
    if (data.isValid) {
      if (data.items.length > 0) {
        if (data.status === 'active') {
          // actual logic
        }
      }
    }
  }
}

// AFTER: 0 levels deep
function process(data) {
  if (!data) return
  if (!data.isValid) return
  if (data.items.length === 0) return
  if (data.status !== 'active') return

  // actual logic
}
```

**Technique B: Extract Nested Blocks**
```javascript
// BEFORE
function handleOrder(order) {
  if (order.isPaid) {
    if (order.items.length > 0) {
      for (const item of order.items) {
        if (item.inStock) { /* complex */ }
      }
    }
  }
}

// AFTER
function handleOrder(order) {
  if (!order.isPaid || order.items.length === 0) return
  order.items.filter(item => item.inStock).forEach(processItem)
}
```

**Technique C: Use Array Methods**
```javascript
// BEFORE: nested loops
for (const user of users) {
  for (const order of user.orders) {
    if (order.status === 'pending') { /* process */ }
  }
}

// AFTER: flat
users
  .flatMap(user => user.orders)
  .filter(order => order.status === 'pending')
  .forEach(processOrder)
```

---

### Resolving Long Functions (> 50 lines)

**Technique A: Extract by Responsibility**
```javascript
// BEFORE: 100 line function
function submitForm(data) {
  // validation (20 lines)
  // formatting (15 lines)
  // API call (25 lines)
  // UI update (20 lines)
}

// AFTER: focused functions
function submitForm(data) {
  const errors = validateFormData(data)
  if (errors.length) return handleErrors(errors)

  const formatted = formatFormData(data)
  const result = await sendToApi(formatted)
  updateUI(result)
}
```

**Technique B: Extract Setup/Teardown**
```javascript
// AFTER
function processData() {
  const context = setupProcessing()
  try {
    return executeProcessing(context)
  } finally {
    cleanupProcessing(context)
  }
}
```

---

### Resolving Too Many Parameters (> 4)

**Technique: Object Parameter Pattern**
```javascript
// BEFORE
function createUser(name, email, age, role, department, manager, startDate) {}

// AFTER
function createUser({ name, email, age, role, department, manager, startDate }) {}

createUser({ name: 'John', email: 'john@example.com', role: 'developer' })
```

---

### Resolving Duplicate Code

**Technique: Extract and Parameterize**
```javascript
// BEFORE: duplicated
function fetchUsers() {
  setLoading(true)
  const data = await api.get('/users')
  setLoading(false)
  return data
}
function fetchProducts() {
  setLoading(true)
  const data = await api.get('/products')
  setLoading(false)
  return data
}

// AFTER: parameterized
async function fetchData(endpoint) {
  setLoading(true)
  try { return await api.get(endpoint) }
  finally { setLoading(false) }
}
const fetchUsers = () => fetchData('/users')
const fetchProducts = () => fetchData('/products')
```

---

### File Extraction
When extracting to new files, analyze the project structure:
- Look for existing `utils/`, `helpers/`, `lib/` folders
- If none exist, propose creating in appropriate location
- Keep related utilities together

## Step 4: Apply Changes

Apply all refactoring changes:

1. Extract long functions into smaller pieces
2. Apply guard clauses to reduce nesting
3. Convert var to const/let
4. Convert Promise chains to async/await
5. Extract magic values to named constants
6. Add try/catch for unhandled async errors
7. Create new utility files if needed
8. Update imports as needed

## Step 5: Report Completion

Report all changes made:
```
Refactored: filename.js

Changes applied:
- Extracted 3 functions from processData (was 120 lines)
- Converted 5 var declarations to const/let
- Refactored 2 Promise chains to async/await
- Added error handling to fetchUser()
- Extracted magic numbers to constants: MAX_RETRIES, TIMEOUT_MS
- Created utils/dataHelpers.js with 2 utility functions

New files created:
- utils/dataHelpers.js
```

## Verification Checklist (MANDATORY)

**You MUST complete and display this checklist. The refactoring is NOT complete until shown.**

### Analysis
- [ ] Target .js/.jsx file identified
- [ ] Code analyzed for complexity metrics
- [ ] Anti-patterns identified
- [ ] Modernization opportunities found

### Code Splitting
- [ ] Functions > 50 lines: addressed or N/A
- [ ] Nesting > 3 levels: addressed or N/A
- [ ] Complexity > 10: addressed or N/A
- [ ] Parameters > 4: addressed or N/A
- [ ] Duplicate code: extracted or N/A

### Patterns & Modernization
- [ ] Guard clauses applied where beneficial
- [ ] var converted to const/let
- [ ] Promise chains converted to async/await
- [ ] Magic values extracted to constants
- [ ] Error handling added where needed

### File Organization
- [ ] New files created in appropriate locations
- [ ] Imports updated correctly

### Completion
- [ ] All changes applied successfully
- [ ] Summary reported
- [ ] This checklist displayed with [x] marks

**Example output:**
```
Verification Checklist:
[x] Target file: src/utils/dataProcessor.js
[x] Code analyzed
[x] Anti-patterns found: 3
[x] Functions > 50 lines: 2 extracted
[x] Nesting > 3 levels: 1 fixed with guard clauses
[ ] Complexity > 10: N/A (none found)
[x] var → const/let: 8 converted
[x] Promise → async/await: 2 converted
[x] Error handling added: 1 function
[x] Changes applied successfully
```

## Important Guidelines

- **Preserve functionality**: Never change logic, only structure
- **Preserve tests**: If tests exist, ensure they still pass
- **Be conservative**: Only refactor clear improvements
- **Naming matters**: Use descriptive function/variable names
- **No over-engineering**: Don't add unnecessary abstractions
