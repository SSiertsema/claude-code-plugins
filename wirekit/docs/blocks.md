# Wirekit block catalog

All blocks in `/blocks/*.html`. Each is an HTML fragment — copy into your screen body, replace placeholders, adjust as needed.

## v0.1 blocks

### header-nav
- **File**: `blocks/header-nav.html`
- **Use**: site / app primary navigation at top of page
- **Region**: `HEADER`
- **Variants (paste + adjust)**:
  - Logged-in: show account + cart
  - Logged-out: show login + signup
  - Marketing site: add prominent CTA
- **Adjacent blocks**: always paired with `footer` at bottom

### hero
- **File**: `blocks/hero.html`
- **Use**: landing or marketing page top; headline + value prop + primary CTA + media
- **Region**: `HERO`
- **Variants**:
  - hero-image (media on right, default)
  - hero-text-only (no media, centered text)
  - hero-video (swap image placeholder for video placeholder)
- **Adjacent blocks**: often followed by `card-grid` (features) then `footer`

### card-grid
- **File**: `blocks/card-grid.html`
- **Use**: product listing, article index, feature grid, related content, team members
- **Region**: `CARD GRID`
- **Variants**:
  - 3-card default, auto-fit
  - 2-column: override grid-template-columns to `1fr 1fr`
  - Article cards: remove price, add date + author
- **Adjacent blocks**: below `hero` on landings; below `breadcrumbs` on category pages

### form-auth
- **File**: `blocks/form-auth.html`
- **Use**: login / signup / password reset
- **Region**: `AUTH FORM`
- **Variants**:
  - login (default: email + password)
  - signup: add name field + terms checkbox
  - password-reset: email-only
  - SSO-primary: add SSO buttons above email/password
- **Annotations**: always call out states (idle / loading / success / error) and error patterns

### empty-state
- **File**: `blocks/empty-state.html`
- **Use**: zero items in a list / no search results / first-run before any data
- **Region**: `EMPTY STATE`
- **Variants**:
  - first-run (encourage first action)
  - filtered-no-results (encourage filter reset / different query)
  - error (load failed — consider using a different error-state block in future versions)
- **Don't confuse with**: error state (use annotations to clarify which)

### footer
- **File**: `blocks/footer.html`
- **Use**: bottom of page with legal + support + company + product links
- **Region**: `FOOTER`
- **Variants**:
  - Full (4 columns, default)
  - Minimal (single row of legal links)
  - Multi-region: add language selector, social links, newsletter signup
- **Adjacent blocks**: always at the bottom, after `main`

## Combining blocks into screens

Typical compositions:

### Landing page
```
header-nav → hero → card-grid (features) → card-grid (testimonials) → hero (CTA) → footer
```

### Product detail
```
header-nav → breadcrumbs (custom region) → PRODUCT DETAIL (custom) → DESCRIPTION (custom) → card-grid (related) → footer
```

### Auth screen
```
header-nav (minimal) → form-auth → footer (minimal)
```

### Dashboard
```
header-nav (logged-in) → DASHBOARD regions (custom) → footer (minimal)
```

## Proposed blocks for v0.2

- `breadcrumbs` — trail navigation
- `pagination` — page controls for lists
- `modal` — overlay dialog
- `toast` — notification
- `navigation-drawer` — side nav for dashboards
- `article` — long-form content with meta
- `pricing-tier` — single pricing tier card
- `error-state` — full-page error (404, 500, access denied)
- `form-multi-step` — wizard / multi-step form
- `data-table` — tabular data with sort / filter slots

## Proposing a new block

Add an entry to this catalog with:
1. **File** path
2. **Use** — one sentence
3. **Region** label
4. **Variants** — paste-and-adjust directions
5. **Adjacent blocks** — typical compositions

Blocks should:
- Be atomic (one job)
- Be composable (no hardcoded width / forced position)
- Use wirekit conventions (data-region, data-placeholder, data-state)
- Include annotations where cross-discipline handoff matters
- Be genuinely reusable across ≥ 2 product categories
