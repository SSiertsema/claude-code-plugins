# Angular Best Practices (2025+)

## Standalone Components

- Every component, directive, and pipe should be `standalone: true` (default since Angular 17).
- Import dependencies directly in the component's `imports` array.
- Use `bootstrapApplication()` with `provideRouter()`, `provideHttpClient()`, etc.
- Use `importProvidersFrom()` only as bridge for third-party NgModule-based libraries.

---

## Signal-Based Reactivity

- `signal(value)` for writable reactive state.
- `computed(() => expr)` for derived state. Pure, no side effects.
- `effect(() => { ... })` sparingly, only for external system synchronization.
- `linkedSignal(() => source)` for resettable local state derived from a parent signal (Angular 19+).
- `resource({ request, loader })` for declarative async data fetching tied to signals.
- Use `update()` for immutable transitions. Use `untracked()` to read without creating dependency.
- Provide custom `equal` function for object signals to avoid unnecessary re-renders.

---

## Control Flow Syntax

- `@if` / `@else if` / `@else` replaces `*ngIf`.
- `@for (item of items(); track item.id)` replaces `*ngFor`. `track` is mandatory.
- `@empty` for empty collection fallbacks.
- `@switch` / `@case` / `@default` replaces `*ngSwitch`.
- `@defer` for lazy-loading template sections with triggers: `on viewport`, `on interaction`, `on idle`, `on timer(5s)`, `when condition()`.

---

## Component Patterns

- Signal inputs: `input.required<T>()` and `input(defaultValue)` over `@Input()`.
- Signal outputs: `output<T>()` over `@Output() EventEmitter`.
- Model signals: `model<T>()` for two-way binding with banana-in-a-box `[()]`.
- View queries as signals: `viewChild.required()`, `viewChildren()`, `contentChild()`.

---

## Dependency Injection

- Always use `inject()` over constructor injection.
- `providedIn: 'root'` with `factory` for tree-shakable tokens.
- Component-level `providers` for subtree-scoped instances.
- `runInInjectionContext()` for calling `inject()` outside constructors.

---

## Routing

- Lazy-load every route with `loadComponent`.
- Group feature routes in `*.routes.ts` loaded via `loadChildren`.
- Functional guards (`CanActivateFn`, `CanMatchFn`) and resolvers (`ResolveFn<T>`).
- `withComponentInputBinding()` to bind route data to signal inputs.

---

## State Management

- Signals + services sufficient for most apps.
- Expose read-only signals via `.asReadonly()`.
- NgRx Signal Store for complex state: `signalStore()` with `withState`, `withComputed`, `withMethods`.
- Use `patchState()` for partial immutable updates.

---

## Performance

- Every component should use `OnPush` change detection.
- Stable unique identifier for `track` in `@for`.
- `@defer` aggressively for heavy below-fold components.
- `provideClientHydration(withEventReplay())` for SSR.
- `NgOptimizedImage` (`ngSrc`) with `priority` on LCP images only.
- Experimental zoneless change detection: `provideExperimentalZonelessChangeDetection()`.

---

## Testing

- Import standalone components in `imports`, not `declarations`.
- `fixture.componentRef.setInput()` for signal inputs.
- Component harnesses (CDK) over direct DOM queries.
- `provideHttpClientTesting()` for HTTP tests.

---

## RxJS vs Signals

### Prefer Signals For
- Synchronous local component state, UI state, simple derived values.

### Prefer RxJS For
- HTTP requests, WebSocket streams, complex async coordination (debounce, retry, switchMap).

### Interop
- `toSignal(obs$)` with `initialValue`. `toObservable(signal)` for feeding into RxJS pipelines.

---

## Forms

- `fb.nonNullable.group()` for fully typed reactive forms.
- `getRawValue()` for typed form values.
- Custom validators and async validators as pure functions.

---

## HTTP

- Functional interceptors (`HttpInterceptorFn`) registered via `withInterceptors([])`.
- Always type responses: `http.get<Product[]>(...)`.
- Use `HttpContext` for per-request metadata.

---

## Accessibility

- CDK A11y: `cdkTrapFocus`, `LiveAnnouncer`, `FocusMonitor`.
- Semantic HTML first, ARIA attributes second.
- Angular Material components implement WAI-ARIA patterns.

---

## File Structure

```
src/app/
  core/         # Singleton services, interceptors, guards
  shared/       # Reusable components, directives, pipes
  features/     # Feature areas (lazy-loaded)
    products/
      products.routes.ts
      product-list/
      services/
      models/
  layout/       # Shell components (header, footer, sidebar)
```

- Group by feature domain, not by technical type.
- Co-locate tests with code (`*.spec.ts` next to `*.ts`).
- One component/service per file. Route definitions in `*.routes.ts`.
