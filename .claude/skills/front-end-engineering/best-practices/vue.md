# Vue 3 Best Practices (2025+)

## Composition API

- Always use `<script setup>` as default.
- Extract reusable stateful logic into composables prefixed with `use`.
- Composables: accept `MaybeRefOrGetter` parameters, return plain objects of refs, clean up with `onScopeDispose`.

---

## Reactivity

- Use `ref` as default for all reactive state.
- Reserve `reactive` for closely related local state that will never be reassigned.
- `computed` for derived values. Keep getters free of side effects.
- `watchEffect` for auto-tracked dependencies. `watch` for explicit sources with old/new values.
- `shallowRef` for large objects replaced wholesale.
- `toRefs`/`toRef` when destructuring reactive objects.

---

## Component Design

- Type-based props with `defineProps<T>()` and `withDefaults`.
- Typed emits with `defineEmits<T>()`.
- `defineModel` (Vue 3.4+) for `v-model` bindings.
- `defineSlots` for typed scoped slots.
- `defineExpose` sparingly for template ref APIs.
- Typed injection keys with `InjectionKey<T>` for provide/inject.

---

## State Management (Pinia)

- Setup stores (function syntax) as default.
- One store per domain concept. Keep stores thin.
- `storeToRefs` for destructuring state/getters. Actions destructure directly.
- `shallowRef` in stores for large non-deeply-reactive data.

---

## Performance

- `v-once` for content that never changes.
- `v-memo` inside `v-for` loops for expensive rows.
- `defineAsyncComponent` for heavy components.
- `<Suspense>` for async components (stable in Vue 3.5+).
- `shallowRef` for large data. Virtualize long lists.
- Avoid inline object/array literals in templates (break prop change detection).
- `markRaw` for non-reactive third-party instances.

---

## TypeScript Integration

- Generic components (Vue 3.3+) with `generic="T extends ..."`.
- Typed template refs: `ref<HTMLInputElement | null>(null)`.
- Enable `strict: true` in tsconfig.
- Discriminated unions for async state machines.

---

## Routing (Vue Router 4)

- Functional guards over global `beforeEach` for feature-specific logic.
- Lazy-load all route components.
- Watch route params explicitly for data fetching.
- `onBeforeRouteLeave` for unsaved changes guards.

---

## Testing

- Vitest + `@vue/test-utils`. Test behavior, not implementation.
- `data-testid` for selectors. Mock APIs at network layer (MSW).
- Test composables with `withSetup` or minimal component context.
- `createTestingPinia` for store tests.

---

## Accessibility

- Programmatic focus management after routes, modals, dynamic content.
- Bind ARIA attributes dynamically with `v-bind`.
- Semantic HTML first, ARIA roles second.
- `aria-live="polite"` for dynamic status messages.

---

## File Structure

```
src/
  components/
    ui/           # Generic reusable (Button, Modal)
    [feature]/    # Feature-specific
  composables/    # Shared composables
  layouts/        # Layout components
  pages/          # Route-level components
  stores/         # Pinia stores
  services/       # API clients
  types/          # Shared types
  utils/          # Pure utility functions
```

---

## Styling

- `<style scoped>` as default. `:deep()` for child component targeting.
- CSS Modules for script-referenced class names.
- `v-bind()` in CSS for reactive values.
- CSS custom properties for theming.

---

## Form Handling

- `defineModel` for two-way binding. Named models for multiple bindings.
- Custom `v-model` modifiers (Vue 3.4+).
- VeeValidate with Zod schemas for validation.
- `aria-describedby` linking error messages to inputs.

---

## Error Handling

- `onErrorCaptured` in parent components. Return `false` to stop propagation.
- `app.config.errorHandler` as last-resort catch-all.
- ErrorBoundary component using `onErrorCaptured` with fallback/retry slots.
- Async composables: always populate an `error` ref.

---

## SSR Considerations

- Guard browser APIs (`window`, `document`) with `onMounted` or `import.meta.env.SSR`.
- `useId()` (Vue 3.5+) for stable server-client IDs.
- Keep global side effects out of `setup()`.
- Avoid stateful singletons at module scope in SSR.
