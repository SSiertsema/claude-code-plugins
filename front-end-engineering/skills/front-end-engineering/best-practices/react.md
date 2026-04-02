# React Best Practices (2025+)

## React 19 Features

### Actions and Forms
- Use Actions as the primary pattern for mutations and form submissions.
- `useActionState` returns `[state, formAction, isPending]` for form state tied to an action.
- `useFormStatus` reads pending status (must be called from a child component inside the form).
- Wrap non-form mutations in `useTransition` for `isPending` without blocking UI.

### useOptimistic
- Show optimistic values while async actions are in flight. Automatically reverts on completion/error.
- Keep the update function pure.

### use() Hook
- `use(promise)` reads promises with Suspense. Promise must be created outside the component.
- `use(Context)` replaces `useContext`. Can be called conditionally.

---

## Server Components (RSC)

- Default to Server Components. Only add `"use client"` for interactivity.
- Push `"use client"` boundaries as deep into the tree as possible.
- Server Components can `async/await` directly. Fetch data at the component level.
- Pass Server Components as children to Client Components to keep server-rendered content out of client bundle.
- Use `server-only` package to guard against accidental client imports.
- Props from Server to Client must be serializable.

---

## Server Actions

- Mark with `"use server"`. Validate all inputs — they are public HTTP endpoints.
- Return structured results, not thrown errors.
- Use `revalidatePath`/`revalidateTag` after mutations.
- Support progressive enhancement: forms work without JavaScript.

---

## Component Composition

- Compound components with context for related UI sharing implicit state.
- Render props for headless components delegating rendering.
- Prefer composition and custom hooks over HOCs.

---

## State Management

- `useState` for simple local state. `useReducer` for complex transitions.
- Context for low-frequency, broadly-shared state (theme, locale, auth). Split by domain.
- `useSyncExternalStore` for external stores. Always provide `getServerSnapshot`.
- TanStack Query or SWR for server state. Do not replicate server data in client stores.

---

## Performance

### React Compiler
- Automatically memoizes components and hooks. Manual `useMemo`/`useCallback`/`React.memo` largely unnecessary when enabled.
- Write idiomatic React; let the compiler optimize.

### Transitions
- Wrap non-urgent updates in `startTransition` (navigation, filtering, tab switches).

### Suspense
- Nest boundaries for staged loading. Use `React.lazy` for code-splitting.

### General
- Avoid creating new objects/arrays in render. Colocate state.
- Virtualize long lists with `@tanstack/react-virtual`.
- Profile before optimizing.

---

## Hooks

- Custom hooks: single responsibility, `use` prefix, clearly typed returns.
- Each `useEffect` has one responsibility. Return cleanup functions.
- Avoid `useEffect` for: transforming data (compute during render), handling events, resetting state (use `key`).
- `useEffectEvent` (React 19) for reading latest values without adding to dependencies.

### Refs in React 19
- Refs as regular props on function components (no `forwardRef` needed).
- Ref callbacks support cleanup functions.

---

## Error Boundaries

- Wrap key UI sections. Use `react-error-boundary` for hook-friendly API.
- Combine with Suspense: `<ErrorBoundary><Suspense>...</Suspense></ErrorBoundary>`.
- Log errors to monitoring services.

---

## Accessibility

- Manage focus on route changes, modal opens/closes.
- Use semantic HTML first, ARIA as supplement.
- `useId()` for unique IDs in reusable components.
- `aria-live="polite"` for dynamic content announcements.

---

## Testing

- React Testing Library: test behavior, query by role/label/text.
- `userEvent` over `fireEvent` for realistic interactions.
- Mock network with MSW, not by mocking fetch.
- Test custom hooks with `renderHook`.
- Colocate tests with components.

---

## File Structure (Feature-Based)

```
src/
  features/
    auth/
      components/, hooks/, actions/, types.ts, index.ts
    dashboard/
  components/
    ui/         # Shared primitives
    layout/     # Layout components
  hooks/        # Shared hooks
  lib/          # Utilities, API clients
  types/        # Shared types
```

---

## Styling

- Tailwind CSS: most popular, zero runtime, use `twMerge` for conditional classes.
- CSS Modules: zero-runtime, works with Server Components.
- Avoid runtime CSS-in-JS in Server Components.

---

## Form Handling

- Native forms with `action` prop + `useActionState` (React 19 preferred).
- React Hook Form with Zod for complex client-heavy forms.
- Validate on server as source of truth. Client validation is UX enhancement.

---

## Data Fetching

- Server Components: `await` directly, parallel with `Promise.all`.
- Client: TanStack Query or SWR. Suspense-compatible.
- Avoid fetch waterfalls. Preload on hover/viewport intersection.
- Nest Suspense boundaries for streaming.

---

## Metadata (React 19)

- `<title>`, `<meta>`, `<link>` inside components are hoisted to `<head>` automatically.
- `preinit`, `preload`, `prefetchDNS`, `preconnect` from `react-dom`.

---

## Anti-Patterns to Avoid

- Do not use `useEffect` for derived state.
- Do not copy props into state.
- Do not create promises inside render for `use()`.
- Do not suppress exhaustive-deps lint rule.
- Do not use `index` as `key` for dynamic lists.
- Do not fetch data in `useEffect` when Suspense-compatible solution exists.
