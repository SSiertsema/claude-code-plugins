# Wirekit

**v0.1.0** — Balsamiq-sketch wireframe design system.

A reusable HTML + CSS + block library for producing mid-fi wireframes with an unmistakable "this is a draft" aesthetic. No JavaScript. No build tools. Browser-renderable. MIT licensed.

## Why

Classless CSS frameworks (Pico, Water, Simple) render semantic HTML as a **clean document** — the opposite intent of wireframes. Stakeholders see "clean" and give feedback on colour + typography instead of structure + content.

Wirekit renders HTML as an **obvious sketch**: hand-drawn fonts, dashed wavy borders, bracketed placeholders, region labels. Reviewers focus on what matters — flow, hierarchy, gaps — because there's nothing polished to distract them.

## Preview

Open `examples/index.html` in a browser. Navigate to `examples/screens/product-detail.html` for a composed screen example.

## Using wirekit in your wireframes

1. Create your wireframe HTML file
2. Link wirekit CSS (relative path to the library):

   ```html
   <link rel="stylesheet" href="../wirekit/css/wireframe.css">
   <link rel="stylesheet" href="../wirekit/css/wireframe-print.css" media="print">
   ```

3. Use the minimal template below
4. Copy blocks from `blocks/*.html` into your page
5. Replace `[bracketed placeholders]` with your intent

### Minimal template

```html
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Wireframe: [screen name]</title>
  <link rel="stylesheet" href="../wirekit/css/wireframe.css">
  <link rel="stylesheet" href="../wirekit/css/wireframe-print.css" media="print">
</head>
<body data-regions="visible">
  <a href="#main" class="skip-link">Skip to main content</a>

  <!-- paste header-nav block here -->

  <main id="main">
    <!-- your regions + content -->
  </main>

  <!-- paste footer block here -->

  <div class="wk-viewport-indicator" aria-hidden="true"></div>
</body>
</html>
```

## Directory structure

```
wirekit/
  .claude-plugin/
    plugin.json          — marketplace metadata
  css/
    wireframe.css        — core styling
    wireframe-print.css  — optional print overrides
  svg/
    filters.svg          — wavy border SVG filter (referenced by CSS)
  fonts/
    README.md            — vendoring plan (v0.1 uses Google Fonts CDN)
  blocks/
    header-nav.html
    hero.html
    card-grid.html
    form-auth.html
    empty-state.html
    footer.html
  examples/
    index.html           — block catalog + usage guide (open this first)
    screens/
      product-detail.html
  docs/
    README.md            — this file
    conventions.md       — data-region / data-state / placeholder patterns
    blocks.md            — block catalog with use-when guidance
    CHANGELOG.md
  LICENSE                — MIT
```

## Conventions (short version)

| Thing | How |
|---|---|
| Region wrapping | `<element data-region="LABEL">...</element>` — wavy dashed border + label badge |
| Toggle region labels | `<body data-regions="visible">` or `"hidden"` |
| Placeholder text | `<span data-placeholder>Intent</span>` or `<span class="placeholder">Intent</span>` |
| Interactive state | `<button data-state="idle|loading|success|error|disabled">` |
| Image placeholder | `<div class="img-placeholder"><span>Purpose</span></div>` |
| Annotation | `<aside class="annotation">...</aside>` |
| Skip link | `<a href="#main" class="skip-link">Skip to main</a>` |

Full conventions: see `conventions.md`.

## Block catalog

Current blocks (v0.1):
- `header-nav` — site / app primary navigation
- `hero` — landing hero with headline + CTA + media
- `card-grid` — product / article / feature grid
- `form-auth` — sign-in / sign-up form
- `empty-state` — zero-items state with illustration + action
- `footer` — legal / support / company links

Full details + use-when: see `blocks.md`.

## Fonts

v0.1 uses Google Fonts CDN for **Caveat** (primary) + **Patrick Hand** (secondary). Both are OFL-licensed, free to vendor. v1.0 target: vendored woff2 in `fonts/` directory.

See `fonts/README.md` for vendoring plan.

## Browser support

- Chrome, Firefox, Safari, Edge (modern)
- SVG `feTurbulence` filter requires WebKit 540+ / Gecko 3.5+ / Chromium all versions — effectively universal on modern browsers
- IE / pre-Chromium Edge: not supported (wavy borders fall back to solid dashed)

## Print

Include `wireframe-print.css` with `media="print"`. Prints with clean dashed borders (no SVG filter), region labels visible, viewport indicator + annotations hidden by default. Toggle annotations on via `<body data-print-annotations="show">`.

## Versioning

Semver. Breaking changes bump major. Block additions are minor. Bug fixes patch.

## Roadmap

- v0.2: vendor fonts + add blocks (modal, toast, navigation drawer, breadcrumbs, pagination)
- v0.3: dark-mode variant (optional stylesheet)
- v1.0: stable block catalog + published to CDN

## License

MIT — free to use, modify, redistribute. Vendored fonts (Caveat, Patrick Hand) under SIL OFL — retain their respective licenses when vendored.
