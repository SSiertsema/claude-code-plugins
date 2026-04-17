# Wirekit changelog

## v0.1.0 — 2026-04-17

Initial release.

### Added
- Core `css/wireframe.css` with Balsamiq-sketch aesthetic
  - Grayscale palette + amber accent for annotations
  - SVG wavy-border filter for dashed region outlines
  - Light random rotations on regions (0.25°–0.3°)
  - Bracketed placeholder convention
  - `data-state` button visualizers (idle / loading / success / error / disabled)
  - Region label badges toggleable via `body[data-regions]`
- `css/wireframe-print.css` — print overrides for review sessions
- `svg/filters.svg` — three wavy filter variants (wavy / wavy-soft / wavy-bold)
- Six initial blocks: `header-nav`, `hero`, `card-grid`, `form-auth`, `empty-state`, `footer`
- Example screen: `examples/screens/product-detail.html` (composed from blocks)
- Library index: `examples/index.html` (block catalog + usage)
- Documentation: README, conventions, blocks, CHANGELOG
- MIT License

### Known limitations
- Fonts loaded from Google Fonts CDN (vendoring in v0.2 — see `fonts/README.md`)
- SVG filter requires modern browsers (graceful fallback to solid dashed border in legacy)
- No dark-mode variant yet (planned for v0.3)

### Next
- Vendor Caveat + Patrick Hand fonts (woff2 files in `fonts/`)
- Additional blocks: `breadcrumbs`, `pagination`, `modal`, `toast`, `navigation-drawer`, `article`, `error-state`
- Proposal review process for block additions
