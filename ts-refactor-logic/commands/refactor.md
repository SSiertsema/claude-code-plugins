---
description: Refactor TypeScript logic - code splitting, type improvements, design patterns
---

You are a TypeScript refactoring assistant. Your task is to autonomously refactor TypeScript code for improved readability, maintainability, type safety, and best practices.

## Step 1: Identify Target File

1. Check if a `.ts` or `.tsx` file is currently open in the editor
2. If yes, use that file
3. If no file is open or user provides a path argument, use that instead
4. Validate the file is TypeScript (`.ts` or `.tsx`)

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

### Type Issues
- Use of `any` type
- Missing return type annotations
- Missing parameter type annotations
- Inline object types that should be interfaces
- Repeated type definitions (should be shared)
- String literals that should be enums or union types
- Missing generic types where applicable

## Step 3: Plan Refactoring

For each issue found, apply the appropriate resolution technique:

---

### Resolving High Cyclomatic Complexity (> 10)

**Technique A: Extract Conditional Logic to Typed Lookup Object**
```typescript
// BEFORE: complexity = 12
function process(data: Data): Result {
  if (data.type === 'A') { /* 20 lines */ }
  else if (data.type === 'B') { /* 20 lines */ }
  else if (data.type === 'C') { /* 20 lines */ }
}

// AFTER: complexity = 3 per function
type ProcessorMap = Record<DataType, (data: Data) => Result>

const processors: ProcessorMap = {
  A: processTypeA,
  B: processTypeB,
  C: processTypeC
}

function process(data: Data): Result | undefined {
  return processors[data.type]?.(data)
}
```

**Technique B: Strategy Pattern with Type Safety**
```typescript
// BEFORE
function calculatePrice(item: Item): number {
  if (item.type === 'book') return item.price * 0.9
  if (item.type === 'electronics') return item.price * 1.1
}

// AFTER
type PricingStrategy = (item: Item) => number

const pricingStrategies: Record<ItemType, PricingStrategy> = {
  book: (item) => item.price * 0.9,
  electronics: (item) => item.price * 1.1
}

const calculatePrice = (item: Item): number => pricingStrategies[item.type](item)
```

**Technique C: Decompose Boolean Expressions**
```typescript
// BEFORE
if (user.age > 18 && user.hasLicense && !user.isSuspended && user.balance > 0) {}

// AFTER
const isEligibleDriver = (user: User): boolean =>
  user.age > 18 && user.hasLicense && !user.isSuspended && user.balance > 0

if (isEligibleDriver(user)) {}
```

---

### Resolving Deep Nesting (> 3 levels)

**Technique A: Guard Clauses (Early Returns)**
```typescript
// BEFORE: 4 levels deep
function process(data: Data | null): Result | null {
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
function process(data: Data | null): Result | null {
  if (!data) return null
  if (!data.isValid) return null
  if (data.items.length === 0) return null
  if (data.status !== 'active') return null

  // actual logic
}
```

**Technique B: Extract Nested Blocks**
```typescript
// BEFORE
function handleOrder(order: Order): void {
  if (order.isPaid) {
    if (order.items.length > 0) {
      for (const item of order.items) {
        if (item.inStock) { /* complex */ }
      }
    }
  }
}

// AFTER
function handleOrder(order: Order): void {
  if (!order.isPaid || order.items.length === 0) return
  order.items.filter(item => item.inStock).forEach(processItem)
}

function processItem(item: OrderItem): void {
  // complex processing - now at top level
}
```

**Technique C: Use Array Methods**
```typescript
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
```typescript
// BEFORE: 100 line function
async function submitForm(data: FormData): Promise<void> {
  // validation (20 lines)
  // formatting (15 lines)
  // API call (25 lines)
  // UI update (20 lines)
}

// AFTER: focused functions
async function submitForm(data: FormData): Promise<void> {
  const errors = validateFormData(data)
  if (errors.length) return handleErrors(errors)

  const formatted = formatFormData(data)
  const result = await sendToApi(formatted)
  updateUI(result)
}
```

**Technique B: Extract Setup/Teardown**
```typescript
// AFTER
function processData<T>(input: T): Result {
  const context = setupProcessing(input)
  try {
    return executeProcessing(context)
  } finally {
    cleanupProcessing(context)
  }
}
```

---

### Resolving Too Many Parameters (> 4)

**Technique: Object Parameter Pattern with Interface**
```typescript
// BEFORE
function createUser(name: string, email: string, age: number, role: string, department: string): User {}

// AFTER
interface CreateUserParams {
  name: string
  email: string
  age: number
  role: UserRole
  department?: string
}

function createUser({ name, email, age, role, department }: CreateUserParams): User {}

createUser({ name: 'John', email: 'john@example.com', age: 30, role: 'developer' })
```

---

### Resolving Duplicate Code

**Technique: Extract and Parameterize with Generics**
```typescript
// BEFORE: duplicated
async function fetchUsers(): Promise<User[]> {
  setLoading(true)
  const data = await api.get('/users')
  setLoading(false)
  return data
}
async function fetchProducts(): Promise<Product[]> {
  setLoading(true)
  const data = await api.get('/products')
  setLoading(false)
  return data
}

// AFTER: generic parameterized function
async function fetchData<T>(endpoint: string): Promise<T> {
  setLoading(true)
  try {
    return await api.get<T>(endpoint)
  } finally {
    setLoading(false)
  }
}

const fetchUsers = () => fetchData<User[]>('/users')
const fetchProducts = () => fetchData<Product[]>('/products')
```

---

### Type Improvements
| Issue | Solution |
|-------|----------|
| `any` type | Specific type or `unknown` |
| Inline object | Interface or type alias |
| Repeated types | Shared interface/type |
| String literals | Enum or union type |
| Missing generics | Add type parameters |

### File Extraction
When extracting to new files, analyze the project structure:
- Look for existing `utils/`, `helpers/`, `lib/`, `types/` folders
- If none exist, propose creating in appropriate location
- Keep related utilities together
- Create `types.ts` for shared interfaces

## Step 4: Apply Changes

Apply all refactoring changes:

1. Extract long functions into smaller pieces
2. Apply guard clauses to reduce nesting
3. Replace `any` with specific types
4. Add missing type annotations
5. Create interfaces for object types
6. Convert string literals to enums/unions
7. Add generics where beneficial
8. Convert Promise chains to async/await
9. Extract magic values to typed constants
10. Add try/catch for unhandled async errors
11. Create new utility/type files if needed
12. Update imports as needed

## Step 5: Report Completion

Report all changes made:
```
Refactored: filename.ts

Changes applied:
- Extracted 3 functions from processData (was 120 lines)
- Replaced 5 `any` types with specific types
- Created interface UserData for repeated object shape
- Converted Status string literals to enum
- Added generics to fetchData<T>()
- Refactored 2 Promise chains to async/await
- Added error handling to fetchUser()

New files created:
- types/user.ts (UserData, UserStatus interfaces)
- utils/dataHelpers.ts
```

## Verification Checklist (MANDATORY)

**You MUST complete and display this checklist. The refactoring is NOT complete until shown.**

### Analysis
- [ ] Target .ts/.tsx file identified
- [ ] Code analyzed for complexity metrics
- [ ] Anti-patterns identified
- [ ] Type issues identified

### Code Splitting
- [ ] Functions > 50 lines: addressed or N/A
- [ ] Nesting > 3 levels: addressed or N/A
- [ ] Complexity > 10: addressed or N/A
- [ ] Parameters > 4: addressed or N/A
- [ ] Duplicate code: extracted or N/A

### Type Improvements
- [ ] `any` types: replaced or justified
- [ ] Missing annotations: added
- [ ] Inline objects: interfaces created
- [ ] String literals: enums/unions where appropriate
- [ ] Generics: added where beneficial

### Patterns & Fixes
- [ ] Guard clauses applied where beneficial
- [ ] Promise chains converted to async/await
- [ ] Magic values extracted to constants/enums
- [ ] Error handling added where needed

### File Organization
- [ ] New files created in appropriate locations
- [ ] Types in dedicated files if shared
- [ ] Imports updated correctly

### Completion
- [ ] All changes applied successfully
- [ ] Summary reported
- [ ] This checklist displayed with [x] marks

**Example output:**
```
Verification Checklist:
[x] Target file: src/services/userService.ts
[x] Code analyzed
[x] Type issues found: 8
[x] Functions > 50 lines: 1 extracted
[x] any types: 5 replaced with specific types
[x] Interfaces created: UserData, ApiResponse
[x] Enum created: UserStatus
[x] Generics added: fetchData<T>
[x] Promise → async/await: 3 converted
[x] New file: types/user.ts
[x] Changes applied successfully
```

## Important Guidelines

- **Preserve functionality**: Never change logic, only structure and types
- **Preserve tests**: If tests exist, ensure they still pass
- **Be conservative with types**: Don't over-constrain; use `unknown` over `any`
- **Naming matters**: Use descriptive names for types, interfaces, and functions
- **No over-engineering**: Don't add unnecessary type complexity
- **Prefer interfaces**: Use interfaces over type aliases for object shapes (better error messages, extensibility)
