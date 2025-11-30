# Testing

<!--
TEMPLATE INSTRUCTIONS:
Document the testing strategy, how to run tests, and how to write new tests.
Investigate: test directories, test config files (jest.config, pytest.ini), CI workflows.
-->

## Testing Strategy

<!--
Overview of testing philosophy and coverage goals.
-->

### Test Types

| Type | Purpose | Location |
|------|---------|----------|
| Unit | Test individual functions/components | `tests/unit/` |
| Integration | Test component interactions | `tests/integration/` |
| E2E | Test full user flows | `tests/e2e/` |

### Coverage Goals

- Unit test coverage: X%
- Critical paths must have integration tests
-

## Running Tests

### All Tests

```bash
npm test
```

### Specific Test Types

```bash
# Unit tests
npm run test:unit

# Integration tests
npm run test:integration

# E2E tests
npm run test:e2e
```

### Single Test File

```bash
npm test -- path/to/test.spec.ts
```

### Watch Mode

```bash
npm run test:watch
```

### Coverage Report

```bash
npm run test:coverage
```

## Writing Tests

### Test File Location

<!--
Explain where test files should be placed.
-->

- Unit tests: alongside source files as `*.test.ts` or in `__tests__/`
- Integration tests: `tests/integration/`
- E2E tests: `tests/e2e/`

### Test Structure

<!--
Show the standard test file structure.
-->

```typescript
import { describe, it, expect, beforeEach } from 'vitest';

describe('ComponentName', () => {
  beforeEach(() => {
    // Setup
  });

  describe('methodName', () => {
    it('should do something when condition', () => {
      // Arrange

      // Act

      // Assert
      expect(result).toBe(expected);
    });
  });
});
```

### Naming Conventions

- Test files: `*.test.ts` or `*.spec.ts`
- Test descriptions: `should [expected behavior] when [condition]`

## Test Utilities

### Mocking

<!--
Explain how to mock dependencies.
-->

```typescript
// Example mock pattern
```

### Fixtures / Factories

<!--
Explain test data setup patterns.
-->

```typescript
// Example fixture/factory pattern
```

### Test Database

<!--
If tests require a database, explain setup.
-->

## Continuous Integration

<!--
How tests run in CI.
-->

Tests run automatically on:
- Pull request creation
- Push to main branch

See `.github/workflows/` for CI configuration.

## Debugging Tests

### Running in Debug Mode

```bash
# Debug command
```

### VS Code Debugging

Add to `.vscode/launch.json`:

```json
{
  "type": "node",
  "request": "launch",
  "name": "Debug Tests",
  "program": "${workspaceFolder}/node_modules/.bin/vitest",
  "args": ["--run", "${relativeFile}"]
}
```

## Common Testing Patterns

<!--
Document project-specific testing patterns.
-->

### Testing Async Code

```typescript
it('should handle async operations', async () => {
  const result = await asyncFunction();
  expect(result).toBeDefined();
});
```

### Testing Error Cases

```typescript
it('should throw error when invalid input', () => {
  expect(() => functionThatThrows()).toThrow('Expected error');
});
```
