# HTML Best Practices (2025+)

## Semantic HTML5+ Elements

### Document Structure
- Use `<header>`, `<main>`, `<footer>` as top-level landmarks. Every page should have exactly one `<main>`.
- Use `<nav>` for primary and secondary navigation blocks. Label multiple navs with `aria-label` to distinguish them.
- Use `<article>` for self-contained, independently distributable content (blog posts, comments, cards).
- Use `<section>` for thematic grouping of content. Each `<section>` should generally have a heading.
- Use `<aside>` for tangentially related content (sidebars, callouts, pull quotes).
- Use `<figure>` and `<figcaption>` for images, diagrams, code listings, or any content referenced from the main flow.
- Use `<address>` for contact information related to the nearest `<article>` or `<body>` ancestor.
- Use `<hgroup>` (reintroduced in the WHATWG spec) to group a heading with secondary content like subtitles or taglines.

### Text-Level Semantics
- `<strong>` for importance, `<em>` for stress emphasis, `<mark>` for highlighted/relevant text.
- `<time datetime="...">` for dates and times; machine-readable `datetime` attribute is essential.
- `<abbr title="...">` for abbreviations and acronyms.
- `<cite>` for titles of works, `<blockquote cite="...">` for extended quotations with source URL.
- `<code>`, `<kbd>`, `<samp>`, `<var>` for technical inline content.
- `<data value="...">` to associate machine-readable values with human-readable content.
- `<del>` and `<ins>` with `datetime` and `cite` attributes for document edits.
- Avoid `<div>` and `<span>` when a semantic element exists. Use them only as styling/layout hooks.

### Lists and Tables
- Use `<ol>` for ordered sequences, `<ul>` for unordered groups, `<dl>` for key-value pairs and glossaries.
- Use `<menu>` for toolbar-like groups of interactive controls.
- Tables require `<caption>`, `<thead>`, `<tbody>`, `<tfoot>`, and proper `<th scope="col|row">` attributes.
- Never use tables for layout.

---

## Accessibility (ARIA, Landmarks, Roles)

### Foundational Principles
- First rule of ARIA: do not use ARIA if a native HTML element provides the semantics you need.
- Every interactive element must be keyboard accessible. Use native `<button>`, `<a>`, `<input>` over `<div>` with `role` and `tabindex`.
- All images require `alt` text. Decorative images use `alt=""` and ideally `role="presentation"` or `aria-hidden="true"`.
- Ensure a logical heading hierarchy (`<h1>` through `<h6>`) with no skipped levels.

### Landmark Roles
- Native landmarks map automatically: `<header>` to `banner`, `<nav>` to `navigation`, `<main>` to `main`, `<footer>` to `contentinfo`, `<aside>` to `complementary`, `<form>` (with accessible name) to `form`, `<section>` (with accessible name) to `region`.
- When multiple instances of the same landmark exist, give each an `aria-label` or `aria-labelledby`.

### ARIA Patterns
- Use `aria-live="polite"` for dynamic content updates (toast notifications, status messages). Use `aria-live="assertive"` sparingly.
- Use `role="status"` for status messages and `role="alert"` for urgent notifications.
- `aria-expanded`, `aria-controls`, and `aria-haspopup` for disclosure widgets and menus.
- `aria-current="page"` for the active item in navigation.
- `aria-describedby` to associate supplementary descriptions (e.g., password requirements with an input).
- `aria-errormessage` paired with `aria-invalid="true"` for form validation errors.
- `aria-hidden="true"` to remove decorative or redundant content from the accessibility tree.

### Focus Management
- Use `tabindex="0"` to add elements to tab order, `tabindex="-1"` for programmatic focus only. Never use `tabindex` values greater than 0.
- Trap focus within modal dialogs using native `<dialog>` or the `inert` attribute on background content.
- The `inert` attribute disables all interaction and removes from accessibility tree. Apply to background content when modals are open.
- Provide visible focus indicators; never `outline: none` without an alternative.
- Use `:focus-visible` for keyboard-only focus styles.

### Skip Links and Reading Order
- Provide a "Skip to main content" link as the first focusable element.
- Ensure DOM order matches visual order. Use CSS for visual reordering only when reading order is unaffected.

---

## Performance

### Resource Hints and Prioritization
- `<link rel="preconnect" href="...">` for third-party origins you will fetch from (fonts, APIs, CDNs).
- `<link rel="dns-prefetch" href="...">` as a fallback for browsers that do not support preconnect.
- `<link rel="preload" href="..." as="font|script|style|image">` for critical resources discovered late by the browser.
- `<link rel="modulepreload" href="...">` for ES module scripts.
- `fetchpriority="high"` on the LCP image or critical above-the-fold resources.
- `<link rel="prefetch" href="...">` for resources likely needed on the next navigation.
- Speculation Rules API (`<script type="speculationrules">`) for prerendering likely next pages.

### Lazy Loading
- `loading="lazy"` on all images and iframes below the fold. Never lazy-load the LCP image.
- `decoding="async"` on images to avoid blocking the main thread during decode.

### Script Loading
- Default to `<script type="module">` which is deferred by default.
- Use `defer` for classic scripts that depend on DOM. Use `async` for independent scripts.
- Inline critical JavaScript; defer everything else.

### Critical Rendering Path
- Inline critical CSS in `<style>` within `<head>` for above-the-fold content.
- Minimize DOM size; aim for under 1500 nodes where possible.

---

## SEO

### Essential Meta Tags
- Unique, descriptive `<title>` (50-60 characters).
- `<meta name="description">` (120-160 characters).
- `<link rel="canonical">` on every page.
- `<meta name="viewport" content="width=device-width, initial-scale=1">`.

### Open Graph and Twitter Cards
- Set `og:title`, `og:description`, `og:image`, `og:url`, `og:type` for social sharing.
- Set `twitter:card`, `twitter:title`, `twitter:description`, `twitter:image`.

### Structured Data (JSON-LD)
- Use `<script type="application/ld+json">` for Schema.org structured data.
- Implement relevant types: `WebSite`, `Organization`, `BreadcrumbList`, `Article`, `Product`, `FAQPage`.
- Validate with Google's Rich Results Test.

### Link Relations
- `<link rel="alternate" hreflang="xx">` for multilingual sites.
- Semantic HTML headings (single `<h1>` per page, logical hierarchy).

---

## Security

### Content Security Policy
- Deliver CSP via HTTP headers or `<meta http-equiv="Content-Security-Policy">`.
- Avoid `unsafe-inline` and `unsafe-eval`. Use nonces or hashes.

### Iframe Security
- Always include `sandbox` attribute on `<iframe>`.
- Use `allow` attribute for Permissions Policy.

### Link Security
- External links with `target="_blank"` include `rel="noopener"`.
- Use `rel="nofollow"` for user-generated content links.
- Use Subresource Integrity (`integrity` attribute) for CDN resources.

### Form Security
- Always use `method="POST"` for state-changing forms.
- Include CSRF tokens as hidden inputs.

---

## Modern HTML Features

### Dialog Element
- Use `<dialog>` for modals. Call `.showModal()` for modal behavior with built-in focus trapping and Escape key handling.
- Style the backdrop with `::backdrop` pseudo-element.

### Details and Summary
- `<details>` and `<summary>` for native disclosure widgets.
- The `name` attribute creates exclusive accordion groups.

### Popover API
- Use the `popover` attribute for tooltips, dropdown menus, and non-modal overlays.
- `popover="auto"` for light-dismiss behavior, `popover="manual"` for explicit control.
- Trigger with `popovertarget="id"` on a button.

### Search Element
- `<search>` wraps search-related UI, providing native `search` landmark semantics.

### Other Notable Features
- `enterkeyhint` attribute for mobile keyboard action label.
- `inputmode` attribute for virtual keyboard optimization.
- `contenteditable="plaintext-only"` to restrict rich-text paste behavior.

---

## Form Best Practices

### Structure and Labels
- Every input must have a visible `<label>` with matching `for`/`id` attributes.
- Group related inputs with `<fieldset>` and `<legend>`.

### Input Types
- Use the most specific type: `email`, `url`, `tel`, `number`, `date`, `datetime-local`, `search`.

### Validation
- Use native validation: `required`, `pattern`, `min`, `max`, `minlength`, `maxlength`.
- Use `:user-valid` and `:user-invalid` pseudo-classes (activate only after user interaction).

### Autocomplete
- Always set `autocomplete` for fields that accept personal data.
- Use `autocomplete="new-password"` to trigger password generators.

---

## Image and Media Best Practices

### Responsive Images
- Use `srcset` with width descriptors and `sizes` attribute.
- Use `<picture>` for art direction and format switching (AVIF > WebP > JPEG).

### Image Performance
- Always include explicit `width` and `height` attributes to prevent layout shift.
- Use `fetchpriority="high"` on the LCP image.
- Prefer SVG for icons, logos, and simple illustrations.

### Video
- Always provide `<track>` for captions/subtitles.
- Use `preload="metadata"` to save bandwidth.
- Include `poster` for a meaningful preview frame.

---

## HTML Document Structure

### Head Element Ordering
1. `<meta charset>` (must be within first 1024 bytes)
2. `<meta name="viewport">`
3. `<title>`
4. Preconnect hints
5. Critical CSS (inlined `<style>`)
6. Synchronous stylesheets
7. Preload directives
8. Async/deferred scripts
9. Favicons, meta descriptions, Open Graph, JSON-LD

### Language and Direction
- Always set `lang` on `<html>` using BCP 47 language tags.
- Set `dir="ltr"` or `dir="rtl"` on `<html>`.
- Use `<bdi>` for bidirectional isolation of user-generated text.

### Favicons
- Minimum set: `.ico` (32x32), SVG icon, Apple Touch Icon (180x180), web manifest.

### Theme and PWA
- `<meta name="theme-color">` with media queries for light/dark.
- `<meta name="color-scheme" content="light dark">` for browser-level dark mode.
