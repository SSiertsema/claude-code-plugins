# JS Refactor Logic Plugin

Autonomously refactor JavaScript code for improved readability, maintainability, and modern best practices.

## Usage

```
/js-refactor-logic:refactor
```

Automatically detects the currently open `.js` or `.jsx` file and applies refactoring.

## What It Does

### Code Splitting
- Extracts functions > 50 lines into smaller pieces
- Reduces nesting > 3 levels with guard clauses
- Converts > 4 parameters to object pattern
- Extracts duplicate code to utilities

### Pattern Application
| Problem | Solution |
|---------|----------|
| Callback hell | Async/await |
| Deep nesting | Guard clauses |
| Long switch | Strategy/lookup |
| Magic values | Named constants |

### ES6+ Modernization
- `var` → `const`/`let`
- `.then()` → `async`/`await`
- Arrow functions where appropriate
- Destructuring and spread operators

### Error Handling
- Adds try/catch to unhandled async code
- Proper error propagation

## Example

**Before:**
```javascript
var data = null;
function processData(a, b, c, d, e) {
  if (a) {
    if (b) {
      if (c) {
        return fetch(url).then(function(res) {
          return res.json();
        }).then(function(json) {
          data = json;
        });
      }
    }
  }
}
```

**After:**
```javascript
const data = ref(null);

async function processData({ a, b, c, d, e }) {
  if (!a || !b || !c) return;

  const response = await fetch(url);
  data.value = await response.json();
}
```

## Verification

Every refactoring ends with a mandatory checklist showing what was done.
