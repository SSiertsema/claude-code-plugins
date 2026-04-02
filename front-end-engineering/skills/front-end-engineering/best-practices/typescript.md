# TypeScript Best Practices (2025+)

## Modern TypeScript 5.x Features

- `satisfies` operator: validate type compliance without widening inference.
- `const` type parameters: infer literal types from arguments without `as const` at call site.
- Stage 3 decorators: prefer over legacy `experimentalDecorators`.
- `using` and `Symbol.dispose` (5.2+): deterministic resource cleanup.
- Import attributes (5.3+): `import config from "./config.json" with { type: "json" }`.
- `NoInfer<T>` (5.4+): control where generics infer from.

---

## Type-Level Programming

- Template literal types for string manipulation at type level (event names, route params).
- Mapped types with key remapping and filtering.
- Conditional types sparingly; prefer simpler alternatives when they exist.
- Limit recursive types to ~10 levels using counter patterns.

---

## Strict Configuration

- Enable `strict: true`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`.
- Enable `noFallthroughCasesInSwitch`, `noImplicitReturns`, `forceConsistentCasingInFileNames`.
- Use `isolatedModules: true` for bundler compatibility.
- Use `verbatimModuleSyntax: true` to enforce explicit `import type`.

---

## Type Narrowing and Type Guards

- Prefer built-in narrowing: `typeof`, `instanceof`, `in`, equality checks.
- Custom type guards with `is` predicates when built-in narrowing is insufficient.
- Assertion functions with `asserts` for functions that throw on invalid input.

---

## Generic Patterns

- Only constrain generics to what the function body needs.
- If a generic is used only once, you probably do not need it.
- Use `infer` in conditional types to extract inner types.

---

## Discriminated Unions

- Use a common literal property (discriminant) to distinguish union members.
- Always include exhaustiveness check with `never` in switch/if-else chains.
- Prefer discriminated unions over enums. Use string literal unions for simple enumerations.

---

## Module and Declaration Patterns

- Use `import type` consistently with `verbatimModuleSyntax`.
- Use barrel files (`index.ts`) at package boundaries only, not within packages.
- Use module augmentation for extending third-party types.

---

## Error Handling with Types

- Use typed Result pattern: `{ success: true; data: T } | { success: false; error: E }`.
- Use typed error classes with discriminants for exceptions.
- Handle `catch (err: unknown)` properly; never use `any` in catch blocks.

---

## Interface vs Type Alias

- Use `interface` for object shapes that may be extended or implemented.
- Use `type` for unions, intersections, mapped types, conditional types, tuples.
- Pick one convention for object shapes and stay consistent.

---

## Utility Types

- Core: `Partial<T>`, `Required<T>`, `Readonly<T>`, `Pick<T, K>`, `Omit<T, K>`, `Record<K, V>`, `Extract<T, U>`, `Exclude<T, U>`, `NonNullable<T>`, `ReturnType<T>`, `Parameters<T>`, `Awaited<T>`, `NoInfer<T>`.
- Compose utility types for DTOs: `Partial<Omit<User, "id" | "createdAt">>`.

---

## Performance

- Avoid deep type recursion. Prefer interfaces over intersections for object types.
- Break nested conditional types into smaller named types.
- Use project references with `composite: true` for large codebases.

---

## tsconfig Best Practices

- Frontend (Vite): `module: "ESNext"`, `moduleResolution: "Bundler"`, `noEmit: true`.
- Node.js: `module: "NodeNext"`, `moduleResolution: "NodeNext"`.
- Always enable `skipLibCheck: true` in applications.

---

## Testing with TypeScript

- Use `@ts-expect-error` and type-level assertions to test types.
- Use `satisfies` for type-safe test fixtures.
- Prefer Vitest for first-class ESM and TypeScript support.

---

## Additional Patterns

- Branded types to prevent accidental interchange of structurally compatible types.
- `as const` for immutable data with literal type inference.
- Zod/Valibot for runtime validation at system boundaries.
- Prefer `unknown` over `any`. Use `readonly` by default.
- Prefer `as const` objects over enums.
