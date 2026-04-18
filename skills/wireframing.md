# Wireframing — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | wireframing |
| **Version** | 1.1.0 |
| **Purpose** | Scaffolds a runnable Vue 3 + Vite + TypeScript wireframe application that renders one screen per route using the `@for-the-people-initiative/wireframe-kit` design system (hand-drawn Rough.js components, monochrome, v1.0.1+). Boilerplate is copied verbatim from skill assets. Per requested screen, generates one `<PascalCase>.Page.vue` composed of kit components only, wrapped in the platform-appropriate device frame (`PhoneFrame` / `TabletFrame` / `DesktopFrame` / `DeviceFrame`), with plain generic placeholder copy (no Lorem Ipsum, no real-looking fake data) and `<Image>` rendering as labelled placeholder boxes. Interactive elements (CTAs, tab items, back buttons, row actions) are wired with `router.push(...)` so the output is a real click-through prototype; non-reachable entry points (e.g. onboarding) are exposed via a "Demo controls" section on Home. Filename = route slug = title. Embeds a snapshot of the v1.0.1 component catalogue (layout / nav / actions / form / data / feedback / marketing / frames) and import patterns. Mid-fi by design — pixel-level visual decisions and high-fi interactivity are out of scope. |
| **Primary category** | `generation` |
| **Secondary category** | `transformation` |
| **Output mode** | `hybrid` |
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
- Iterating layout + composition + transitions before commitment to visual design

## When not to use

- Lower-fi exploratory storyboards / concept sketches → `concept-sketching`
- Step-level user flow (no screens) → `user-flow-diagramming`
- Site hierarchy / page typing → `site-mapping`
- Component state machines → `state-transition-mapping`
- Pixel-level visual design / colour / typography decisions → Visual / UI design (future)
- High-fidelity interactive prototypes → Prototyping skills (future)
- Production component code → `front-end-engineering`

---

## Required input

| Field | Description |
|---|---|
| **App name** | Short app / product name |
| **Screens** | List of PascalCase screen names |
| **Platform target** | One of `mobile` / `tablet` / `desktop` / `responsive`. No default — always elicit. Determines which device frame wraps page content. |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Output directory** | Where to scaffold | `./wireframes/` |
| **Per-screen brief** | Intent / composition hint per screen | Elicit |
| **Flow spec** | Structured transitions (from → action → to) — YAML/JSON, or Mermaid from `user-flow-diagramming` | Elicit conversationally if absent |
| **Placeholders** | Copy style: `plain` (short generic copy) or `bracketed` (intent-labelled, e.g. `[CTA: ...]`) | `plain` |
| **Overwrite** | Overwrite existing non-empty output dir | Confirm |

## Input schema

```
input:
  required:
    app_name:
      type: string
    screens:
      type: list[string]            # PascalCase
    platform_target:
      type: enum
      values: [mobile, tablet, desktop, responsive]
  optional:
    output_dir:
      type: string
      default: ./wireframes
    screen_briefs:
      type: map[string, string]     # screen_name -> brief
    flow_spec:
      type: list[transition]        # { from: screen, action: label, to: screen }
      or: string                    # mermaid flowchart
    placeholders:
      type: enum
      values: [plain, bracketed]
      default: plain
    overwrite:
      type: boolean
      default: false
```

---

## Processing rules

### Phase 1 — Setup
Collect app name, screen list, platform target, output dir. Interview if missing. `platform_target` is always required — never assume. Confirm overwrite if dir non-empty. If `flow_spec` absent, plan to elicit transitions during Phase 3.

### Phase 2 — Scaffold
`cp -r ${CLAUDE_PLUGIN_ROOT}/skills/wireframing/assets/boilerplate/* <output>/`. No edits to scaffold files. Boilerplate `package.json` declares `@for-the-people-initiative/wireframe-kit ^1.0.1` — earlier kit versions lack the device-frame components and `--wf-surface` var and must be rejected.

### Phase 3 — Per-screen generation
One `src/pages/<Name>.Page.vue` per screen. Filename → route slug + title. Composition uses kit components only.

**Device frame (mandatory):**
- `mobile` → wrap template in `<PhoneFrame>`
- `tablet` → wrap in `<TabletFrame>`
- `desktop` → wrap in `<DesktopFrame>`
- `responsive` → wrap in `<DeviceFrame>` and register `useDevice()` composable (localStorage-backed toggle rendered in `App.vue` shell)

All imported from `@for-the-people-initiative/wireframe-kit/components/<Name>` / `.../composables`. One frame per page; frame is the root template element.

**Click-through wiring:**
- For each interactive element (button-as-CTA, `TabMenu` / `Tabs` item, back button, `DataTable` / `DataView` row, `Card` with an action), wire a transition using `router.push('/<target-slug>')`.
- `TabMenu` items receive `command: () => router.push(...)`.
- Transitions come from `flow_spec` if provided; otherwise elicit per screen during generation ("What happens when the user taps `Continue`?").
- Decorative elements without a transition remain handler-less.

**Demo controls:**
- If `flow_spec` or the elicited transitions reveal entry points not reachable by normal click-through (first-launch onboarding, deep-link-only screens, state-gated flows), generate a "Demo controls" `Section` at the bottom of `Home.Page.vue` with labelled `Button`s that `router.push` to those entry points. Each labelled by context (e.g. `Restart onboarding`).

**Placeholder copy:**
- Default (`placeholders: plain`): short generic plain copy (`Get started`, `Stay hydrated, daily`, `Sign in to continue`). State variants use a plain prefix without brackets (`State — just logged (undo toast)`).
- Opt-in (`placeholders: bracketed`): intent-labelled bracketed copy (`[CTA: primary action]`, `[Heading: product promise in 6 words]`).
- Either mode: no Lorem Ipsum, no real-looking fake names / emails / prices / URLs.

**Styling:**
- Layout-only scoped `<style>` (grid / flex / spacing).
- No colour / typography overrides — kit owns aesthetic.
- Every `position: sticky | fixed | absolute` element has explicit `background: var(--wf-surface)` (kit v1.0.1 exposes this). Never `inherit` or `transparent` on floating elements.

**State:**
- `v-model` on form inputs with `ref` / `reactive` state, even if decorative.
- Multiple UI states via props on shared instances (`is-loading`, `severity="error"`), not duplicate pages.

### Phase 4 — Catalogue reference
Use embedded catalogue (in SKILL.md) for component names, props, composition heuristics, device frames, and the `useDevice` composable. Suggest closest match if a requested component doesn't exist; compose from primitives if missing.

### Phase 5 — Verify and report
Print file tree of `src/pages/`. Print platform target + device frame in use. Print run instructions. Do not auto-run `npm install` or `npm run dev`.

### Phase 6 — Iteration
Add / remove / rename screens by adding / deleting / renaming `<Name>.Page.vue` files. Router auto-discovers on next reload. When adding a screen that is the target of a transition from an existing screen, update the source screen's handler. When platform target changes, re-wrap every page.

---

## Output contract

```
<output>/
├── package.json                 # boilerplate; kit ^1.0.1
├── vite.config.ts               # boilerplate
├── tsconfig.json                # boilerplate
├── tsconfig.node.json           # boilerplate
├── index.html                   # boilerplate
├── .gitignore                   # boilerplate
├── README.md                    # boilerplate
└── src/
    ├── main.ts                  # boilerplate (CSS + fonts + wireframe SCSS + WireframePlugin)
    ├── env.d.ts                 # boilerplate
    ├── App.vue                  # boilerplate (screen-picker shell; device toggle when platform=responsive)
    ├── router/index.ts          # boilerplate (auto-glob)
    └── pages/
        ├── Home.Page.vue        # boilerplate index (or replaced by user's Home); hosts Demo controls when needed
        └── <Name>.Page.vue      # one per requested screen, wrapped in the selected device frame
```

Plus a chat report listing: screens generated, platform target, device frame used, transitions wired, demo-control entry points added, and run instructions.

---

## Generation and planning policy

- **May be invented**: layout composition, placeholder copy within declared style, decorative state demonstrations, transitions implied by conversational briefs
- **Must be grounded**: screen list, transitions in `flow_spec`, platform target (all from user input)
- **Assumptions allowed**: closest-match kit component if requested name does not exist (flag it); default route slug = kebab-case(filename)
- **Never fabricated**: real image URLs, real-looking names / emails / prices, kit components that do not exist in v1.0.1, transitions not implied by input or brief
- Boilerplate copied verbatim — never re-derived
- Kit components only; no hand-rolled UI primitives that exist in the catalogue
- No colour / typography overrides
- Multiple states via props on shared instances, not duplicate pages
- `npm install` / `npm run dev` not auto-run

---

## Self-check

```
[] Boilerplate copied verbatim
[] package.json declares kit ^1.0.1
[] platform_target collected; correct device frame wraps every page (PhoneFrame/TabletFrame/DesktopFrame/DeviceFrame)
[] For platform_target=responsive: useDevice registered and toggle rendered in App.vue
[] One <PascalCase>.Page.vue per screen
[] Each page imports kit components individually from .../components/<Name>
[] No real image URLs
[] No Lorem Ipsum / real-looking fake data
[] Placeholder style matches `placeholders` option (plain default; no brackets unless opted in)
[] Interactive elements wired with router.push per flow_spec or elicited transitions
[] Demo controls on Home for non-reachable entry points
[] Layout-only scoped <style>
[] Floating elements (position sticky/fixed/absolute) have explicit background: var(--wf-surface)
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
| `platform_target` missing | Interview — always ask, no silent default |
| `platform_target` invalid value | Reject; list the four allowed values |
| Output dir non-empty | Confirm overwrite |
| `flow_spec` references unknown screen | Reject the spec; ask user to correct or add the screen |
| `flow_spec` absent | Elicit transitions conversationally per screen during generation |
| Real images requested | Refuse; explain `Image` is a placeholder; intent goes in `alt` |
| Lorem / fake-real data requested | Substitute with plain copy (or bracketed if opted in); explain |
| Colour / typography decisions requested | Defer to Visual / UI design |
| Production code requested | Defer to `front-end-engineering` |
| High-fi / pixel-perfect requested | Defer to prototyping skills |
| Component not in catalogue | Suggest closest match; compose from primitives if missing |
| Kit version resolves < 1.0.1 | Refuse; explain that device frames and `--wf-surface` require v1.0.1+ |
| `npm install` fails | Check Node ≥ 18 + npm registry; do not "work around" by editing boilerplate |

---

## Quality checks

- [ ] Scaffold matches boilerplate
- [ ] Kit version pinned `^1.0.1`
- [ ] Platform target explicit; every page wrapped in the matching frame
- [ ] Routes auto-discoverable
- [ ] Screen filenames PascalCase + `.Page.vue`
- [ ] Imports per-component, default exports
- [ ] Placeholder style consistent with `placeholders` option
- [ ] Every interactive element either has a handler (wired via flow or elicited) or is explicitly decorative
- [ ] No colour / typography in scoped styles
- [ ] Floating elements use `background: var(--wf-surface)`
- [ ] Run instructions communicated

---

## Examples

### Normal cases

**1. Marketing landing for a SaaS product (desktop, plain copy)**
- Input: `app = "Acme"`, `screens = ["Home", "Pricing", "Signup", "Features"]`, `platform_target = desktop`
- Expected: scaffold + 4 page files, each wrapped in `<DesktopFrame>`. `Home.Page.vue` uses `Hero` + `Section` + `FeatureGrid` + `Testimonial` + `CTA` + `Footer`; hero CTA `Button` `@click="router.push('/signup')"`. `Pricing.Page.vue` uses `Section` + `PricingTable`; per-plan `Button` → `/signup`. `Signup.Page.vue` uses `Section` + `Form` + `FormField` + `InputText` + `PasswordInput` + `Button` (submit → `/`). `Features.Page.vue` uses `Section` + `FeatureGrid`. Copy is short and generic: `Get started`, `Stay productive at scale`, etc.

**2. Dashboard MVP (desktop, flow-specced)**
- Input: `screens = ["Dashboard", "Customers", "CustomerDetail", "Settings"]`, `platform_target = desktop`, `flow_spec = [{from: Customers, action: "row click", to: CustomerDetail}, {from: CustomerDetail, action: "back", to: Customers}]`
- Expected: `AppBar` + `Drawer` shell repeated inside `<DesktopFrame>`. `Dashboard` uses `Stats` + `Chart` + `DataTable`; `Customers` uses `Toolbar` + `DataView` + `Paginator` with row action `router.push('/customer-detail')`; `CustomerDetail` uses `Tabs`, back button `router.push('/customers')`; `Settings` uses `Tabs` or `Steps` + `Form`.

**3. Auth flow (mobile, plain copy)**
- Input: `screens = ["SignIn", "SignUp", "ResetPassword"]`, `platform_target = mobile`
- Expected: each wrapped in `<PhoneFrame>`, 3 short pages, each `Section` + `Form` + inputs + `Button`. SignIn has link → `/sign-up` and → `/reset-password`. Show `Alert` (error severity) and `Button` `is-loading` state demonstration via props on the same instance.

**4. E-commerce product catalogue (responsive)**
- Input: `screens = ["Catalog", "ProductDetail", "Cart", "Checkout", "OrderConfirmation"]`, `platform_target = responsive`
- Expected: every page wrapped in `<DeviceFrame>`. `App.vue` shows the kit's device-toggle in the shell (driven by `useDevice`), defaulting to the last device in `localStorage`. Row action on `Catalog` → `/product-detail`; `Add to cart` `Button` → `/cart`; `Proceed to checkout` → `/checkout`; `Place order` → `/order-confirmation`. `Checkout` uses `Steps` + `Form`.

**5. Daily water tracker (mobile, onboarding + tab-based, elicited transitions)**
- Input: `app = "Hydra"`, `screens = ["Home", "Onboarding", "Log", "History", "Settings"]`, `platform_target = mobile`, no `flow_spec`
- Expected: every page in `<PhoneFrame>`. Skill elicits transitions per screen. `Home.Page.vue` contains a primary tracker view plus a "Demo controls" `Section` with `Restart onboarding` → `/onboarding`. `Onboarding.Page.vue` uses `Steps` with `Continue` → next step, final step → `/`. Bottom tab bar (`TabMenu`) on `Home` / `Log` / `History` / `Settings` with `command: () => router.push('/<slug>')` per item. Sticky tab bar has `background: var(--wf-surface)`.

### Edge cases

**6. Single screen (tablet)**
- Input: `screens = ["Landing"]`, `platform_target = tablet`
- Expected: scaffold + replace `Example.Page.vue` with `Landing.Page.vue` wrapped in `<TabletFrame>`. `Home.Page.vue` (boilerplate index) remains at `/` listing the single screen; no Demo controls section (nothing unreachable).

**7. Many screens (≥ 10, mobile)**
- Input: 12 screens, `platform_target = mobile`
- Expected: 12 page files, each in `<PhoneFrame>`. Screen-picker dropdown lists all. No pagination on dropdown.

**8. Iteration — add one screen with a new transition**
- Input: existing scaffold (mobile); add screen `Notifications` with transition `Home → bell icon → Notifications`
- Expected: one new file `Notifications.Page.vue` in `<PhoneFrame>`; update bell icon handler in `Home.Page.vue` to `router.push('/notifications')`. No other edits.

### Failure cases

**9. No screens + no platform target**
- Input: "wireframe my app"
- Expected: Interview — ask app name, screen list, platform target, output dir.

**10. Real image requested**
- Input: "use https://example.com/hero.jpg in the hero"
- Expected: Refuse politely. Use `<Image alt="Hero illustration" src="placeholder" />`.

**11. Colour decision requested**
- Input: "make the CTA button blue"
- Expected: Defer to Visual / UI design. Wireframe-kit is monochrome.

**12. Kit version < 1.0.1 pinned**
- Input: user requests `@for-the-people-initiative/wireframe-kit@1.0.0`
- Expected: Refuse; explain device frames (`PhoneFrame` / `TabletFrame` / `DesktopFrame` / `DeviceFrame`) and `--wf-surface` var require v1.0.1+.
