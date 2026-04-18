# Wireframing — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | wireframing |
| **Version** | 1.0.0 |
| **Purpose** | Scaffolds a runnable Vue 3 + Vite + TypeScript wireframe application that renders one screen per route using the `@for-the-people-initiative/wireframe-kit` design system (~112 hand-drawn Rough.js components, monochrome). Boilerplate is copied verbatim from skill assets — `package.json`, `vite.config.ts`, `tsconfig*`, `index.html`, `src/main.ts` (CSS + SCSS imports + `WireframePlugin` registration), `src/App.vue` (screen-picker nav + RouterView), `src/router/index.ts` (auto-discovers `src/pages/*.Page.vue` via `import.meta.glob`), `src/pages/Home.Page.vue` (auto-generated index of every screen). Per requested screen, generates one `<PascalCase>.Page.vue` composed of kit components only, with intent-only placeholders (no Lorem Ipsum, no real-looking fake data) and `<Image>` rendering as labelled placeholder boxes regardless of `src`. Filename = route slug = title. Embeds a snapshot of the v1.0.0 component catalogue (layout / nav / actions / form / data / feedback / marketing) and import patterns. Mid-fi by design — pixel-level visual decisions and high-fi interactivity are out of scope. |
| **Primary category** | `generation` |
| **Secondary category** | `transformation` |
| **Output mode** | `code` |
| **Tone** | `neutral` |
| **Audience** | `technical` |
| **Output format** | `vue + ts + scaffold` |
| **Creativity level** | `medium` |
| **Mixins** | `[]` |

---

## When to use

- User wants clickable, browser-renderable wireframes for stakeholder review
- Moving from concept / flow / journey output into mid-fi screen layouts
- Wireframes that downstream front-end engineering can read for layout intent
- Iterating layout + composition before commitment to visual design

## When not to use

- Lower-fi exploratory storyboards / concept sketches → `concept-sketching`
- Step-level user flow (no screens) → `user-flow-diagramming`
- Site hierarchy / page typing → `site-mapping`
- Component state machines → `state-transition-mapping`
- Pixel-level visual design / colour / typography decisions → Visual / UI design (Phase 4 visual stream, future)
- High-fidelity interactive prototypes → Prototyping skills (future)
- Production component code → `front-end-engineering`

---

## Required input

| Field | Description |
|---|---|
| **App name** | Short app / product name |
| **Screens** | List of PascalCase screen names |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Output directory** | Where to scaffold | `./wireframes/` |
| **Per-screen brief** | Intent / composition hint per screen | Elicit |
| **Overwrite** | Overwrite existing non-empty output dir | Confirm |

## Input schema

```
input:
  required:
    app_name:
      type: string
    screens:
      type: list[string]   # PascalCase
  optional:
    output_dir:
      type: string
      default: ./wireframes
    screen_briefs:
      type: map[string, string]   # screen_name -> brief
    overwrite:
      type: boolean
      default: false
```

---

## Processing rules

### Phase 1 — Setup
Collect app name, screen list, output dir. Interview if missing. Confirm overwrite if dir non-empty.

### Phase 2 — Scaffold
`cp -r ${CLAUDE_PLUGIN_ROOT}/skills/wireframing/assets/boilerplate/* <output>/`. No edits to scaffold files.

### Phase 3 — Per-screen generation
One `src/pages/<Name>.Page.vue` per screen. Filename → route slug + title. Composition uses kit components only. Intent placeholders only. v-model on form inputs. Layout-only scoped styles.

### Phase 4 — Catalogue reference
Use embedded catalogue (in SKILL.md) for component names, props, and composition heuristics. Suggest closest match if a requested component doesn't exist; compose from primitives if missing.

### Phase 5 — Verify and report
Print file tree of `src/pages/` and run instructions. Do not auto-run `npm install` or `npm run dev`.

### Phase 6 — Iteration
Add / remove / rename screens by adding / deleting / renaming `<Name>.Page.vue` files. Router auto-discovers on next reload.

---

## Output contract

```
<output>/
├── package.json                 # boilerplate (verbatim)
├── vite.config.ts               # boilerplate
├── tsconfig.json                # boilerplate
├── tsconfig.node.json           # boilerplate
├── index.html                   # boilerplate
├── .gitignore                   # boilerplate
├── README.md                    # boilerplate
└── src/
    ├── main.ts                  # boilerplate (CSS + fonts + wireframe SCSS + WireframePlugin)
    ├── env.d.ts                 # boilerplate
    ├── App.vue                  # boilerplate (screen-picker shell)
    ├── router/index.ts          # boilerplate (auto-glob)
    └── pages/
        ├── Home.Page.vue        # boilerplate index (or replaced by user's Home)
        └── <Name>.Page.vue      # one per requested screen
```

Plus a chat report listing screens generated + run instructions.

---

## Generation and planning policy

- Boilerplate copied verbatim — never re-derived
- Kit components only; no hand-rolled UI primitives that exist in the catalogue
- No real images (kit `<Image>` renders placeholder regardless of `src`)
- No real-looking copy or fake data (use `[Intent: ...]` placeholders)
- No colour / typography overrides — the kit owns the aesthetic
- Multiple states via props on shared instances, not duplicate pages
- `npm install` / `npm run dev` not auto-run

---

## Self-check

```
[] Boilerplate copied verbatim
[] One <PascalCase>.Page.vue per screen
[] Each page imports kit components individually from .../components/<Name>
[] No real image URLs
[] No Lorem Ipsum / real-looking fake data
[] Layout-only scoped <style>
[] Form inputs have v-model
[] Multiple states via props on shared instances
[] Run instructions printed; servers not auto-started
[] Screen-picker nav lists every page
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No screens listed | Interview mode |
| Output dir non-empty | Confirm overwrite |
| Real images requested | Refuse; explain `Image` is a placeholder; intent goes in `alt` |
| Lorem / fake-real data requested | Substitute intent placeholders; explain |
| Colour / typography decisions requested | Defer to Visual / UI design |
| Production code requested | Defer to `front-end-engineering` |
| High-fi / pixel-perfect requested | Defer to prototyping skills |
| Component not in catalogue | Suggest closest match; compose from primitives if missing |
| `npm install` fails | Check Node ≥ 18 + npm registry; do not "work around" by editing boilerplate |

---

## Quality checks

- [ ] Scaffold matches boilerplate
- [ ] Routes auto-discoverable
- [ ] Screen filenames PascalCase + `.Page.vue`
- [ ] Imports per-component, default exports
- [ ] Intent placeholders only
- [ ] No colour / typography in scoped styles
- [ ] Run instructions communicated

---

## Examples

### Normal cases

**1. Marketing landing for a SaaS product**
- Input: app = "Acme", screens = `["Home", "Pricing", "Signup", "Features"]`
- Expected: scaffold + 4 page files. `Home.Page.vue` uses `Hero` + `Section` + `FeatureGrid` + `Testimonial` + `CTA` + `Footer`. `Pricing.Page.vue` uses `Section` + `PricingTable`. `Signup.Page.vue` uses `Section` + `Form` + `FormField` + `InputText` + `PasswordInput` + `Button`. `Features.Page.vue` uses `Section` + `FeatureGrid`.

**2. Dashboard MVP**
- Input: screens = `["Dashboard", "Customers", "CustomerDetail", "Settings"]`
- Expected: `AppBar` + `Drawer` shell pattern repeated; `Dashboard` uses `Stats` + `Chart` + `DataTable`; `Customers` uses `Toolbar` + `DataView` + `Paginator`; `CustomerDetail` uses `Tabs` (overview / activity / billing); `Settings` uses `Tabs` or `Steps` + `Form`.

**3. Auth flow**
- Input: screens = `["SignIn", "SignUp", "ResetPassword"]`
- Expected: 3 short pages, each `Section` + `Form` + appropriate inputs + `Button`. Show `Alert` (error severity) and `Button` `is-loading` for state demonstration.

**4. E-commerce product catalogue**
- Input: screens = `["Catalog", "ProductDetail", "Cart", "Checkout", "OrderConfirmation"]`
- Expected: `Catalog` uses `DataView` (grid layout) + `Paginator` + filter `Toolbar`; `ProductDetail` uses `Image` + headings + `Tabs`; `Cart` uses `DataTable`; `Checkout` uses `Steps` + `Form`; `OrderConfirmation` uses `Section` + `Card`.

### Edge cases

**5. Single screen**
- Input: screens = `["Landing"]`
- Expected: scaffold + replace `Example.Page.vue` with `Landing.Page.vue`. `Home.Page.vue` (boilerplate index) still mounts at `/` listing the single screen.

**6. Many screens (≥ 10)**
- Input: 12 screens
- Expected: 12 page files generated. Screen-picker dropdown lists all. No pagination on the dropdown.

**7. Iteration — add one screen**
- Input: existing scaffold; add screen `"Notifications"`
- Expected: one new file `Notifications.Page.vue`. Router picks up on next reload. No other edits.

### Failure cases

**8. No screens**
- Input: "wireframe my app"
- Expected: Interview — ask app name, screen list, output dir.

**9. Real image requested**
- Input: "use https://example.com/hero.jpg in the hero"
- Expected: Refuse politely. Use `<Image alt="[Hero illustration]" src="placeholder" />`.

**10. Colour decision requested**
- Input: "make the CTA button blue"
- Expected: Defer to Visual / UI design. Wireframe-kit is monochrome.
