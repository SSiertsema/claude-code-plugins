# CSS Best Practices (2025+)

## Modern Layout

### CSS Grid
- Use `grid-template-areas` for named regions in page-level layouts.
- Use `auto-fill` vs `auto-fit` intentionally: `auto-fill` preserves empty tracks, `auto-fit` collapses them.
- Combine `grid-template-columns: repeat(auto-fill, minmax(min(100%, 250px), 1fr))` for intrinsic responsive grids with zero media queries.

### Subgrid
- Use `grid-template-rows: subgrid` or `grid-template-columns: subgrid` so nested content aligns to parent grid tracks.
- Combine subgrid with `gap: inherit` for consistent gutters.

### Flexbox
- Use `gap` in Flexbox instead of margin hacks.
- Use `flex-wrap: wrap` with `flex-basis` values instead of media queries for simple flowing layouts.

### Container Queries
- Use `container-type: inline-size; container-name: card;` then query with `@container card (min-inline-size: 400px)`.
- Use container query units (`cqi`, `cqb`) for container-relative sizing.
- Prefer container queries over media queries for component-level responsiveness.

---

## Custom Properties (CSS Variables)

- Use layered naming: `--color-blue-500` (primitive), `--color-primary` (semantic), `--button-bg` (component-scoped).
- Define light-theme tokens on `:root`, override in `[data-theme="dark"]` or `@media (prefers-color-scheme: dark)`.
- Use `color-mix()` with custom properties for hover/active states.
- Register custom properties with `@property` for transitions and type-checking.

---

## Modern Selectors

- `:has()` as parent selector: `.card:has(img)` targets cards containing an image.
- `:is()` to group selectors without repetition.
- `:where()` for zero-specificity resets and defaults.
- `:focus-visible` for keyboard-only focus rings.

---

## Responsive Design

- Use `clamp()` for fluid sizing: `font-size: clamp(1rem, 0.5rem + 1.5vw, 2rem)`.
- Use `dvh` (dynamic viewport height) instead of `vh` on mobile.
- Use range syntax: `@media (width >= 768px)` for readability.

---

## Performance

- Apply `contain: layout style paint` on independent components.
- Apply `content-visibility: auto` on off-screen sections with `contain-intrinsic-size`.
- Apply `will-change` only immediately before an animation; remove after.
- Use `font-display: swap` or `font-display: optional` on `@font-face`.

---

## Animation

### View Transitions API
- Use `document.startViewTransition()` with `::view-transition-old()` and `::view-transition-new()`.
- Assign `view-transition-name` to elements that should animate individually.

### Scroll-Driven Animations
- Use `animation-timeline: scroll()` to tie animation progress to scroll position.
- Use `animation-timeline: view()` for visibility-based animations.

### prefers-reduced-motion
- Default to no animation and enhance with motion.
- Wrap animations in `@media (prefers-reduced-motion: no-preference)`.

### General Animation
- Animate only composite properties (`transform`, `opacity`, `filter`) for 60fps.
- Use `transition-behavior: allow-discrete` with `@starting-style` for entry animations.

---

## Color

- Prefer `oklch()` over `hsl()` for perceptually uniform color scales.
- Use `color-mix(in oklch, ...)` for shade/tint/alpha variants.
- Use relative color syntax for programmatic color derivation.
- Use `color()` with `display-p3` for wider-gamut colors behind `@supports`.

---

## Architecture

### Cascade Layers (@layer)
- Organize: `@layer reset, base, components, utilities;`. Later layers win.
- Place third-party CSS in lowest layer. Utilities in highest.
- Keep all styles in layers for predictable behavior.

### CSS Nesting
- Use native CSS nesting. Avoid deeper than 3 levels.
- `&` required when nested selector does not start with a symbol.

### @scope
- Use `@scope (.card) to (.card__content)` for donut scoping.
- Prevents styles from leaking into deeply nested identical components.

### General Architecture
- Use logical properties (`margin-inline-start`, `padding-block`, `inline-size`).
- Adopt a single naming convention (BEM, CUBE CSS, or utility-first).

---

## Accessibility

- Use `@media (prefers-contrast: more)` for increased contrast.
- Use `@media (forced-colors: active)` for Windows High Contrast Mode with system color keywords.
- Maintain minimum 3:1 contrast ratio for focus indicators.
- Use `@media (prefers-reduced-transparency: reduce)` for opaque alternatives.
- Ensure interactive targets meet 24x24 CSS pixel minimum.
- Apply `scroll-margin-top` to anchor targets for fixed headers.

---

## Progressive Enhancement

- Use `@supports` to test for modern features.
- Provide Flexbox baseline, enhance with Grid/subgrid via `@supports`.
- Gate cutting-edge features (scroll-driven animations, anchor positioning) behind `@supports`.
- Use `min-width: 0` on Flex/Grid children to prevent text overflow.
- Use `overflow-wrap: break-word` on long-content containers.
- Set `isolation: isolate` to create local stacking contexts.
- Use `text-wrap: balance` on headings, `text-wrap: pretty` on body text.
