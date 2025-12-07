# TS Refactor Logic Plugin

Autonomously refactor TypeScript code for improved readability, maintainability, type safety, and best practices.

## Usage

```
/ts-refactor-logic:refactor
```

Automatically detects the currently open `.ts` or `.tsx` file and applies refactoring.

## What It Does

### Code Splitting
- Extracts functions > 50 lines into smaller pieces
- Reduces nesting > 3 levels with guard clauses
- Converts > 4 parameters to typed object pattern
- Extracts duplicate code to utilities

### Type Improvements
| Issue | Solution |
|-------|----------|
| `any` type | Specific type or `unknown` |
| Inline objects | Interface |
| Repeated types | Shared interface |
| String literals | Enum or union |
| Missing generics | Type parameters |

### Pattern Application
| Problem | Solution |
|---------|----------|
| Callback hell | Async/await |
| Deep nesting | Guard clauses |
| Long switch | Strategy/lookup |
| Magic values | Typed constants/enums |

### Error Handling
- Adds try/catch to unhandled async code
- Proper typed error propagation

## Example

**Before:**
```typescript
function processUser(data: any) {
  if (data) {
    if (data.status === 'active') {
      if (data.role === 'admin') {
        return fetch(url).then(res => res.json());
      }
    }
  }
}
```

**After:**
```typescript
interface UserData {
  status: UserStatus;
  role: UserRole;
}

enum UserStatus {
  Active = 'active',
  Inactive = 'inactive'
}

enum UserRole {
  Admin = 'admin',
  User = 'user'
}

async function processUser(data: UserData): Promise<ApiResponse | null> {
  if (!data) return null;
  if (data.status !== UserStatus.Active) return null;
  if (data.role !== UserRole.Admin) return null;

  const response = await fetch(url);
  return response.json();
}
```

## Verification

Every refactoring ends with a mandatory checklist showing what was done.
