# JavaScript Best Practices (2025+)

## Modern ES2024/ES2025 Features

- `Object.groupBy()` and `Map.groupBy()` for array grouping.
- `Promise.withResolvers()` for deferred promise pattern.
- TC39 Stage 3 decorators for cross-cutting concerns.
- Set methods: `union()`, `intersection()`, `difference()`, `symmetricDifference()`, `isSubsetOf()`, `isSupersetOf()`.
- `structuredClone()` for deep copies (handles Date, RegExp, Map, Set, ArrayBuffer, Error).
- Regular expression `v` flag for set operations and improved Unicode support.

---

## Async Patterns

- Handle errors at boundaries, let them propagate through business logic.
- Use `AbortController` as the universal cancellation primitive.
- Use structured concurrency: group related async operations with linked `AbortController`.
- Choose the right combinator: `Promise.all` (all must succeed), `Promise.allSettled` (inspect individually), `Promise.any` (first success), `Promise.race` (first to settle).
- Use async generators for paginated/streaming data.

---

## Error Handling

- Create custom error classes extending `Error` with `code`, `statusCode`, and `cause`.
- Always use the `cause` option when wrapping errors. Never lose the original stack.
- Use Result pattern `{ ok: true, value }` / `{ ok: false, error }` for expected failures.
- Set up global error boundaries: `window.addEventListener("error")` and `unhandledrejection`.

---

## Module System

- Prefer named exports for tree-shaking and refactoring support.
- Use dynamic `import()` for route-based and feature-based code splitting.
- Use import maps for bare specifier resolution in browsers.
- Preload critical modules with `<link rel="modulepreload">`.

---

## Performance

- Offload CPU-intensive work to Web Workers.
- Use `requestIdleCallback` for non-critical background tasks.
- Batch DOM reads and writes to avoid layout thrashing.
- Use `WeakRef` and `FinalizationRegistry` for caches that should not prevent GC.
- Virtualize long lists with Intersection Observer for lazy rendering.

---

## Security

- Never use `eval`, `new Function(userInput)`, or string-form `setTimeout`.
- Prevent prototype pollution: use `Object.create(null)` for lookup maps, validate keys.
- Use the Sanitizer API or DOMPurify for user HTML. Use `textContent` over `innerHTML`.
- Use Trusted Types to prevent DOM XSS.

---

## Data Structures

- Use `Map` for frequent additions/deletions and non-string keys.
- Use `Set` for O(1) uniqueness checks.
- Use `structuredClone()` over `JSON.parse(JSON.stringify(...))`.

---

## Functional Patterns

- Use `Object.freeze()` for truly immutable data.
- Prefer pure functions: same input, same output, no side effects.
- Use function composition (`pipe`, `compose`) for data processing pipelines.

---

## DOM Manipulation

- Use `querySelector`/`querySelectorAll` with `closest()` for upward traversal.
- Use `replaceChildren()` for efficient clearing and re-rendering.
- Use `data-*` attributes for state, classes for styling.
- Use MutationObserver for reactive DOM watching.

---

## Event Handling

- Use event delegation to a common ancestor.
- Use `{ passive: true }` for scroll/touch events.
- Use `AbortController` for event cleanup (single abort removes all listeners).
- Use `CustomEvent` with `bubbles: true` for component communication.

---

## Fetch API and Network

- Build robust fetch wrappers with timeout, retry, and abort support.
- Use streaming responses with `ReadableStream` for large payloads.
- Implement request deduplication for concurrent identical requests.

---

## Storage APIs

- Use IndexedDB with promise wrappers for structured client storage.
- Use Cache API for offline and performance (stale-while-revalidate, network-first strategies).
- Check storage quota with `navigator.storage.estimate()`.

---

## General Conventions

- Prefer `const`, use `let` sparingly, never `var`.
- Use optional chaining (`?.`) and nullish coalescing (`??`).
- Use private class fields (`#field`).
- Use `for...of` for side-effectful iteration, array methods for transformations.
- Store and transmit dates in ISO 8601 / UTC.
