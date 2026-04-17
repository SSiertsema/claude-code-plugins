# Wirekit conventions

Consistent attribute + class conventions across all wirekit output. The wireframing skill (and any other skill consuming wirekit) must follow these.

## Regions

Every semantic layout landmark gets a `data-region` attribute:

```html
<header data-region="HEADER" role="banner">...</header>
<main data-region="MAIN" id="main">...</main>
<aside data-region="SIDEBAR" aria-label="Related">...</aside>
<footer data-region="FOOTER" role="contentinfo">...</footer>
```

Label convention:
- UPPERCASE SHORT-WORD — e.g., `HEADER`, `HERO`, `CARD GRID`, `BUY`, `EMPTY STATE`
- Human-readable; describes the region's purpose, not its HTML element
- Max ~18 characters for clean badge rendering

### Toggle region labels

```html
<body data-regions="visible">   <!-- default: labels shown -->
<body data-regions="hidden">    <!-- labels hidden, borders remain -->
```

Use `hidden` for stakeholder walkthroughs where labels distract; `visible` for developer / design review.

## Placeholders

Two equivalent ways to mark placeholder content:

```html
<!-- As attribute (preferred for inline elements) -->
<span data-placeholder>Heading: product title</span>

<!-- As class (preferred when combined with other classes) -->
<span class="placeholder">Body: 3 paragraphs</span>
```

Both render with brackets, italic, secondary color:  `[ Heading: product title ]`

### Placeholder content convention

Describe **intent**, not filler text:
- ✅ `[Heading: product promise in 6 words]`
- ✅ `[Body: 40 words on benefits]`
- ✅ `[CTA: primary action]`
- ✅ `[List: 4 items]`
- ✅ `[Image: hero illustration]`
- ❌ Lorem Ipsum
- ❌ "John Doe", "jane@example.com" (real-looking fake data — confuses reviewers)

## Interactive states

```html
<button data-state="idle">Submit</button>
<button data-state="loading">Submit</button>     <!-- renders Submit ⌛ -->
<button data-state="success">Submit</button>      <!-- renders Submit ✓ -->
<button data-state="error">Submit</button>        <!-- renders Submit ✗ -->
<button data-state="disabled" disabled>Submit</button>
```

Supported states: `idle`, `loading`, `success`, `error`, `disabled`.

Show multiple states side-by-side in the wireframe to communicate the state model. Use annotations to describe transitions (link to `state-transition-mapping` output).

## Image / media placeholders

```html
<div class="img-placeholder" style="min-height: 200px;">
  <span>Hero illustration</span>
</div>
```

Renders a gray box with diagonal X and label. Use `style="min-height: ..."` to size.

Label describes **what the image is**, not "Image" — e.g., `Hero illustration`, `Product primary image`, `Team photo`.

## Annotations

Sticky-note style callouts for design intent, state notes, cross-discipline handoffs:

```html
<aside class="annotation">
  <strong>States:</strong> idle → loading → success / error.
  See <em>state-transition-mapping</em> for transitions.
</aside>
```

Guidelines:
- Use for cross-discipline handoff notes (link to skill outputs)
- Use for non-obvious design intent
- Don't over-annotate — if every block has 3 annotations, the wireframe becomes hard to read
- Max ~2 lines per annotation when possible

## A11y baseline

Every wirekit wireframe must include:

```html
<html lang="en" data-theme="light">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Wireframe: [screen name]</title>
</head>
<body>
  <a href="#main" class="skip-link">Skip to main content</a>
  ...
  <main id="main">...</main>
```

- `lang` on `<html>`
- `viewport` meta
- Semantic landmarks (`header`, `main`, `aside`, `footer`) with roles where useful (`role="banner"`, `role="contentinfo"`)
- `<h1>` exactly once; logical heading hierarchy
- `aria-label` on multiple same-type landmarks (e.g., two `<nav>` elements)
- Form labels always associated (`<label for="...">` or wrapping)
- Skip link to main content

## Viewport indicator

Optional dev helper showing current breakpoint:

```html
<div class="wk-viewport-indicator" aria-hidden="true"></div>
```

Renders fixed at bottom-right with text `DESKTOP` / `LAPTOP` / `TABLET` / `MOBILE` per breakpoint. Hidden on print.

Include during design, consider removing for stakeholder review if distracting.

## Custom CSS

Avoid inline `<style>` or per-screen CSS files. If a screen needs custom styling, add to `wireframe.css` as a reusable utility with `wk-` prefix.

Exception: one-off structural overrides via inline `style` attribute (e.g., `style="min-height: 200px"`) are OK on wirekit-provided containers.

## Block composition

Blocks in `/blocks/*.html` are HTML fragments. To use:
1. Copy the contents of the block file (skip the `<!-- comment -->` header)
2. Paste into your screen's body
3. Replace placeholders with your intent
4. Add / remove / adjust as needed for your screen

Blocks are starting points, not rigid templates. Adjust.

## Don'ts

- **Don't add colors** beyond the declared palette (grayscale + amber accent)
- **Don't add JavaScript** — wirekit is static; interactions are signaled via `data-state` only
- **Don't use hi-fi content** (real product names, real prices, real copy) — defeats mid-fi intent
- **Don't hide region labels permanently** — toggle per review, not per design
- **Don't over-rotate** — elements have subtle 0.25°–0.3° rotation; don't amplify
- **Don't remove `.img-placeholder` X pattern** — critical "not an image" signal
