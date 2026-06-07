# Vue/Nuxt QA Checklist — ISO/IEC 25010:2023

This checklist operationalizes the **ISO/IEC 25010:2023 product quality model** for Vue 3 and Nuxt 3 development. It covers all **9 characteristics**, with **one checklist item per sub-characteristic (~40 items)**, each expressed as a concrete, testable front-end check.

All applicable items must be validated before generating the handoff report.

**Marking N/A:** Many sub-characteristics (especially under Compatibility, Flexibility, and Safety) do not apply to every component. Mark an item **N/A** when it is genuinely irrelevant to the task. N/A items are excluded from scoring (they do not count toward the denominator) — they never count as failures.

---

## 1. Functional Suitability (3 items)

- [ ] **Functional completeness**: Every acceptance criterion in the user story maps to at least one test (unit or E2E)
- [ ] **Functional correctness**: Unit and E2E tests assert the correct output/behavior, not just absence of errors
- [ ] **Functional appropriateness**: The component does exactly what the story requires — no scope creep, no missing capability

### Example
```typescript
// completeness: each AC has a named test
test('AC1: successful login redirects to dashboard', ...)
test('AC2: invalid password shows error', ...)
```

---

## 2. Performance Efficiency (3 items)

- [ ] **Time behaviour**: No heavy computation in render; derived values use `computed` (memoized), not method calls or inline expressions
- [ ] **Resource utilization**: Watchers, intervals, and event listeners are cleaned up in `onUnmounted` / `onScopeDispose`
- [ ] **Capacity**: Large or unbounded lists are paginated or virtualized; no rendering of thousands of nodes at once

### Examples
**Good — memoized derived state, cleaned listener:**
```typescript
const total = computed(() => items.value.reduce((s, i) => s + i.price, 0))

const stop = useEventListener(window, 'resize', onResize)
onUnmounted(stop)
```
**Bad — recomputed every render, leaked listener:**
```typescript
function getTotal() { return items.value.reduce((s, i) => s + i.price, 0) }
window.addEventListener('resize', onResize) // never removed
```

---

## 3. Compatibility (2 items)

*Mark N/A where the component has no shared/global surface.*

- [ ] **Co-existence**: Styles are `scoped` (or CSS-module/tokenized); no global selector leakage that affects sibling components
- [ ] **Interoperability**: Public contract (typed `props`/`emits`/`slots`) is explicit and stable so other components can integrate

### Example
```vue
<style scoped>
.card { padding: var(--space-4); } /* no bare `div {}` global rules */
</style>
```

---

## 4. Interaction Capability (8 items)

*Formerly "Usability". Target WCAG 2.2 AA for inclusivity items.*

- [ ] **Appropriateness recognizability**: Controls have clear labels/affordances; purpose is obvious without guessing
- [ ] **Learnability**: Patterns and naming are consistent with the rest of the app (predictable behavior)
- [ ] **Operability**: Fully keyboard-operable — focusable controls, logical tab order, Enter/Space activate
- [ ] **User error protection**: Inputs validated; destructive/irreversible actions guarded or confirmed
- [ ] **User engagement**: Loading, empty, success, and error states give the user feedback (no dead UI)
- [ ] **Inclusivity**: WCAG 2.2 AA — sufficient color contrast, ARIA roles/attributes, visible focus indicators, `prefers-reduced-motion` respected
- [ ] **User assistance**: Helper text and error messages are present and programmatically associated (`aria-describedby`)
- [ ] **Self-descriptiveness**: Semantic HTML and accessible names; the UI explains itself to assistive tech

### Examples
**Good — accessible, keyboard-operable, associated help:**
```vue
<label for="email">Email</label>
<input id="email" type="email" :aria-invalid="!!error" aria-describedby="email-err" />
<p id="email-err" v-if="error" role="alert">{{ error }}</p>
```
**Bad — div-as-button, no label, no feedback:**
```vue
<div @click="submit">Go</div> <!-- not focusable, no role, no aria -->
```

---

## 5. Reliability (4 items)

- [ ] **Faultlessness**: Edge cases and boundaries are tested (empty, null, max/min, rapid clicks)
- [ ] **Availability**: SSR/hydration-safe — no `window`/`document` access during SSR; no hydration mismatches (Nuxt)
- [ ] **Fault tolerance**: Failures are caught; `error` ref from data fetching is handled; error boundaries where appropriate
- [ ] **Recoverability**: User can recover from failure — retry action or graceful fallback UI, not a hard dead end

### Examples
**Good — handled error with recovery:**
```typescript
const { data, error, refresh } = await useFetch('/api/users')
```
```vue
<button v-if="error" @click="refresh()">Retry</button>
```
**Bad — unguarded SSR access:**
```typescript
const width = window.innerWidth // crashes during SSR
```

---

## 6. Security (6 items)

- [ ] **Confidentiality**: No secrets/tokens hard-coded or exposed client-side; no sensitive data in console logs
- [ ] **Integrity**: No unsanitized `v-html` or other XSS sinks; user content escaped by default
- [ ] **Non-repudiation**: State-changing actions are recorded/auditable where the story requires it *(N/A for pure display components)*
- [ ] **Accountability**: User actions are attributable where the story requires it *(N/A for pure display components)*
- [ ] **Authenticity**: Protected routes/pages enforce auth via middleware/guards before rendering sensitive data
- [ ] **Resistance** *(new in 2023)*: Input hardened against malformed/malicious data; component degrades safely under abuse (e.g., respects server rate-limit responses)

### Examples
**Good — escaped output, guarded route:**
```vue
<p>{{ userComment }}</p> <!-- escaped by default, no v-html -->
```
```typescript
// middleware/auth.ts
export default defineNuxtRouteMiddleware(() => {
  if (!useAuth().isLoggedIn.value) return navigateTo('/login')
})
```
**Bad — XSS sink:**
```vue
<div v-html="userComment" /> <!-- unsanitized user input -->
```

---

## 7. Maintainability (5 items)

- [ ] **Modularity**: Single responsibility — the component does one thing well
- [ ] **Reusability**: Shared/reusable logic extracted into typed `use*.ts` composables returning reactive refs
- [ ] **Analysability**: Readable and fully typed — no `any`, interfaces for data shapes, explicit return types
- [ ] **Modifiability**: No prop mutation (emit instead); clear one-way data flow
- [ ] **Testability**: Tests were written before the implementation (TDD), and the design is test-friendly

### Examples
**Good — composable + no prop mutation:**
```typescript
const emit = defineEmits<{ update: [value: string] }>()
function onInput(v: string) { emit('update', v) } // never mutate props
```
**Bad — untyped, mutated prop:**
```typescript
const props = defineProps(['value'])
props.value = 'x' // mutating a prop
```

---

## 8. Flexibility (4 items)

*Formerly "Portability". Mark N/A where not relevant to the task.*

- [ ] **Adaptability**: Responsive across breakpoints; spacing/colors use design tokens, not hard-coded values
- [ ] **Scalability** *(new in 2023)*: Stateless/composable-driven design that scales to more data/instances without rework
- [ ] **Installability**: Uses standard project dependencies; no hidden environment coupling that blocks install/run
- [ ] **Replaceability**: Typed public contract lets the component be swapped without breaking callers

### Example
```vue
<style scoped>
.grid { gap: var(--space-4); grid-template-columns: repeat(auto-fill, minmax(12rem, 1fr)); }
</style>
```

---

## 9. Safety (5 items)

*New top-level characteristic in 2023. Mark N/A for components with no risky or irreversible operations.*

- [ ] **Operational constraint**: Destructive actions (delete, overwrite, pay) require confirmation or are constrained
- [ ] **Risk identification**: Risky states are detectable and surfaced (e.g., "unsaved changes", "about to delete N items")
- [ ] **Fail safe**: On failure the component returns to a safe default state rather than a corrupt/ambiguous one
- [ ] **Hazard warning**: User is warned before an irreversible or high-impact action proceeds
- [ ] **Safe integration**: Data crossing the boundary (API responses, route params, props from untrusted callers) is validated before use

### Example
```vue
<button @click="confirmDelete">Delete account</button>
```
```typescript
function confirmDelete() {
  if (!window.confirm('This permanently deletes your account. Continue?')) return
  deleteAccount()
}
```

---

## Scoring

Each sub-characteristic is one item. Score per characteristic and overall.

```
score = (items_passed / total_applicable_items) × 10
```

- **N/A items are excluded** from `total_applicable_items` (they are not failures).
- Report a per-characteristic breakdown (passed / total / issues) plus the overall score.

**Thresholds:**

| Score | Status | Meaning |
|-------|--------|---------|
| 9–10 | PASS | Excellent quality, ready for E2E |
| 7–8 | ACCEPTABLE | Good quality, minor issues noted |
| 0–6 | NEEDS_WORK | Must fix issues before handoff |

**Total applicable items (max):** 40 sub-characteristics across 9 characteristics — fewer after N/A exclusions for the specific task.
