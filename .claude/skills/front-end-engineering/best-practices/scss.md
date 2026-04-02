# SCSS Best Practices (2025+)

## Module System: @use and @forward

- `@import` is deprecated as of Dart Sass 2.0. Use `@use` and `@forward` exclusively.
- `@use` loads a stylesheet under a namespace: `@use 'colors'` exposes `colors.$primary`.
- Use `as *` sparingly and only for foundational utility modules.
- Configure module variables at load time with `with()`.
- `@forward` re-exports members. Use `show`/`hide` to control the public API surface.
- Add prefixes to avoid naming collisions: `@forward 'spacing' as spacing-*;`.
- Private members are prefixed with `_` or `-`.

---

## Variable Management and Design Tokens

- Use Sass variables for build-time constants: breakpoints, z-index scales, internal calculations.
- Use CSS custom properties for runtime flexibility: colors, spacing, theming.
- Bridge the two: define tokens as Sass variables, emit as custom properties.
- Use Sass maps for token groups to enable iteration and validation.

---

## Mixin Patterns

- Use mixins for repetitive declaration blocks that vary by parameter.
- Use mixins for media query abstractions with consistent breakpoint APIs.
- Provide sensible defaults for parameters.
- Use keyword arguments for mixins with more than two parameters.
- Keep mixins focused on one responsibility.
- Prefer `@content` blocks over deeply parameterized mixins.

---

## Function Best Practices

- Functions are for computations that return a value. Never emit CSS directly.
- Use built-in modules (`sass:math`, `sass:color`, `sass:list`, `sass:map`, `sass:string`, `sass:meta`).
- Replace deprecated globals: `lighten()` becomes `color.scale($c, $lightness: 10%)`.
- Use `@error` and `@warn` for validation and developer feedback.

---

## Nesting Rules

- Maximum depth: 3 levels. More is a code smell.
- Use `&` for BEM suffixes, pseudo-classes, and pseudo-elements.
- Nest for logical grouping, not to mirror DOM structure.
- Place media queries inside selectors using mixins for co-location.

---

## Architecture Patterns

### 7-1 Pattern (adapted for module system)
- `abstracts/` (variables, functions, mixins), `base/`, `components/`, `layout/`, `pages/`, `themes/`, `vendors/`.
- Each directory has `_index.scss` with `@forward` aggregation.

### ITCSS
- Settings > Tools > Generic > Elements > Objects > Components > Utilities.
- Ascending specificity order.

### Component-Scoped
- Co-locate styles with components. Share tokens via global `abstracts`.
- Prefer CSS Modules or framework-native scoping over manual BEM when available.

---

## Integration with CSS Custom Properties

- Use Sass `@each` loops to generate families of custom properties from maps.
- Use `#{$sass-var}` interpolation when assigning to custom properties.
- For component variants, define custom properties at root and override in modifiers.

---

## Performance

- Prefer mixins over `@extend` in component architectures.
- Audit generated CSS periodically for bloat and unused rules.
- Target maximum 3 compound selectors in any rule.
- Dart Sass is the only supported implementation. Node Sass and LibSass are deprecated.

---

## Naming Conventions

- Blocks: lowercase, hyphen-separated. Elements: double underscore. Modifiers: double hyphen.
- Sass variables: `$kebab-case`. Mixins/functions: `kebab-case`.
- Custom properties: `--namespace-property` pattern.
- Design tokens: consistent tier system with semantic aliases.

---

## When to Use SCSS vs Plain CSS

### Use Plain CSS When
- No design token system or small number of tokens.
- Utility-first framework (Tailwind, UnoCSS).
- Zero build step is valued.
- Modern CSS features cover your needs (nesting, `@layer`, `@container`, `color-mix()`).

### Use SCSS When
- Complex build-time logic: loops, conditional output, math.
- Large design token system with maps and validation.
- Need compile-time error checking (`@error`, `@warn`).
- Programmatic CSS generation.

### Recommended: Hybrid Approach
- Sass as thin orchestration layer for tokens and repetitive generation.
- Everything else in plain CSS or near-plain SCSS.
