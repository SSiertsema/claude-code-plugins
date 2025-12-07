# Code Quality Checklist

**Code is considered high quality when it meets these criteria:**

---

## 1. Readability
- [ ] **Self-documenting**: Code explains itself through naming
- [ ] **Consistent style**: Follows project conventions
- [ ] **Logical flow**: Reads top-to-bottom like a story
- [ ] **Meaningful names**: Variables, functions describe intent (not implementation)
- [ ] **No abbreviations**: `getUserData()` not `getUsrDt()`

## 2. Structure
- [ ] **Single Responsibility**: Each function does ONE thing
- [ ] **Small functions**: ≤ 50 lines (ideally ≤ 20)
- [ ] **Shallow nesting**: ≤ 3 levels of indentation
- [ ] **Low complexity**: Cyclomatic complexity ≤ 10
- [ ] **Few parameters**: ≤ 4 parameters per function
- [ ] **DRY**: No duplicate code (2+ occurrences extracted)

## 3. Naming Conventions
- [ ] **Functions**: Verb prefix (`fetchUser`, `handleClick`, `validateForm`)
- [ ] **Booleans**: `is/has/can/should` prefix (`isLoading`, `hasError`)
- [ ] **Constants**: `UPPER_SNAKE_CASE` (`MAX_RETRIES`, `API_URL`)
- [ ] **Variables**: Descriptive camelCase (`userData`, `selectedItems`)
- [ ] **No magic values**: All literals have named constants

## 4. Error Handling
- [ ] **Async has try/catch**: All async operations handle errors
- [ ] **Errors are meaningful**: Clear error messages
- [ ] **Graceful degradation**: Failures don't crash the app
- [ ] **No silent failures**: Errors are logged or reported

## 5. Maintainability
- [ ] **Easy to modify**: Changes are localized
- [ ] **Easy to extend**: New features don't require rewrites
- [ ] **Easy to test**: Functions are pure where possible
- [ ] **No tight coupling**: Components are independent
- [ ] **Clear dependencies**: Imports at top, explicit

## 6. Performance Awareness
- [ ] **No premature optimization**: But obvious issues fixed
- [ ] **Efficient loops**: No unnecessary iterations
- [ ] **Memory conscious**: No leaks, cleanup on unmount
- [ ] **Async where appropriate**: Non-blocking operations

## 7. Modern Patterns
- [ ] **ES6+ syntax**: `const`/`let`, arrow functions, destructuring
- [ ] **Async/await**: Not callback hell or `.then()` chains
- [ ] **Guard clauses**: Early returns instead of deep nesting
- [ ] **Composition**: Small functions composed together

## 8. Type Safety (TypeScript)
- [ ] **No `any`**: Specific types or `unknown`
- [ ] **Return types**: Explicit on functions
- [ ] **Interfaces**: For object shapes
- [ ] **Generics**: Where reusability benefits

## 9. Vue-Specific Quality
- [ ] **Composables**: Reusable logic extracted
- [ ] **No prop mutation**: Uses emit pattern
- [ ] **Computed for derived state**: Not methods
- [ ] **Lifecycle cleanup**: `onUnmounted` for listeners
- [ ] **Reactive refs returned**: From composables

---

## Quality Thresholds

| Metric | Good | Acceptable | Needs Work |
|--------|------|------------|------------|
| Function length | ≤ 20 lines | ≤ 50 lines | > 50 lines |
| Nesting depth | ≤ 2 levels | ≤ 3 levels | > 3 levels |
| Cyclomatic complexity | ≤ 5 | ≤ 10 | > 10 |
| Parameters | ≤ 3 | ≤ 4 | > 4 |
| File length | ≤ 200 lines | ≤ 400 lines | > 400 lines |

---

## Scoring

| Score | Status |
|-------|--------|
| 9-10 | ✅ PASS |
| 7-8 | ⚠️ ACCEPTABLE |
| 0-6 | ❌ NEEDS WORK |

**Formula**: Score = (checks passed / total applicable checks) × 10
