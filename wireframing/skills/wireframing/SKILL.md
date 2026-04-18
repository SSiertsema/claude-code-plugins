---
name: wireframing
description: Scaffold a runnable Vue 3 + Vite + TypeScript wireframe app using the @for-the-people-initiative/wireframe-kit design system (hand-drawn Rough.js components, v1.0.1+). One file per screen, auto-discovered routes, screen-picker nav, per-platform device frame wrapping, click-through wiring via router.push. Catalogue + conventions embedded.
argument-hint: "[product / app / screens to wireframe]"
---

# Wireframing

You scaffold a runnable Vue 3 wireframe application that renders one screen per route using the **`@for-the-people-initiative/wireframe-kit`** design system (v1.0.1+). Output is mid-fi, monochrome, hand-drawn (Rough.js) — wireframes that look like sketches so reviewers comment on structure, flow, and transitions, not on colour and typography.

This skill is **scaffold + per-screen generation + click-through wiring**, not pixel-level visual design or interactive prototyping.

## Core rules

- **Device frame around every page** — every page wraps its content in `<PhoneFrame>`, `<TabletFrame>`, `<DesktopFrame>`, or `<DeviceFrame>` depending on `platform_target`. The frame is the root element of `<template>`.
- **Click-through by default** — every interactive element (CTA, tab, back button, row action, list action) is wired with `router.push(...)`. The set of transitions comes from a `flow_spec` input, or is elicited conversationally per screen.
- **No real images** — every `<Image>` from the kit renders a placeholder box from its `alt`, regardless of `src`. Do not try to use real URLs.
- **No real-looking copy** — use plain short generic copy by default (`Get started`, `Stay hydrated, daily`, `Sign in to continue`). No Lorem Ipsum. No fake names / emails / prices that read as real. State variants use a plain prefix without brackets (`State — just logged (undo toast)`). Only use bracketed intent copy (`[CTA: ...]`) when the user explicitly sets `placeholders: bracketed`.
- **Wireframe-kit components only** — all UI comes from the kit. Don't hand-roll buttons, cards, forms, or layout primitives that exist in the catalogue.
- **Floating elements have a solid background** — every `position: sticky | fixed | absolute` element has `background: var(--wf-surface)` explicitly. Never `inherit` or `transparent`.
- **One concern per screen** — if the user lists 5 screens, generate 5 page files. Don't fold them into tabs.
- **Filename = route** — `<PascalCase>.Page.vue` in `src/pages/`. Auto-discovered by router via `import.meta.glob`. No router edit needed.
- **Boilerplate is canonical** — copy from `${CLAUDE_PLUGIN_ROOT}/skills/wireframing/assets/boilerplate/` verbatim. Do not improvise the scaffold.
- **Kit `^1.0.1`** — earlier versions lack device frames and `--wf-surface`. Reject if pinned lower.

## When to use

- Clickable, browser-renderable wireframes for stakeholder review
- Moving from concept / flow / journey output into mid-fi screen layouts
- Wireframes that downstream front-end engineering can read for layout intent + transitions
- Iterating layout + composition + flow before commitment to visual design

## When not to use

- Lower-fi exploratory storyboards / concept sketches → `concept-sketching`
- Step-level user flow (no screens) → `user-flow-diagramming`
- Site hierarchy / page typing → `site-mapping`
- Component state machines → `state-transition-mapping`
- Pixel-level visual design / colour / typography decisions → Visual / UI design (future)
- High-fidelity interactive prototypes → Prototyping skills (future)
- Production component code → `front-end-engineering`

## Phase 1 — Setup

Collect:

| Field | Required | Default |
|---|---|---|
| **App name** | Yes | — |
| **Screens to wireframe** (PascalCase names) | Yes | — |
| **Platform target** (`mobile` / `tablet` / `desktop` / `responsive`) | Yes | — (no default — always ask) |
| **Output directory** | No | `./wireframes/` |
| **Per-screen brief** | No | Elicit per screen |
| **Flow spec** (transitions: from → action → to; YAML/JSON or Mermaid) | No | Elicit conversationally if absent |
| **Placeholders** (`plain` / `bracketed`) | No | `plain` |

If any required field is missing, enter Interview mode and ask only for what's missing. **Never silently default `platform_target`** — the device frame depends on it.

If the output directory exists and is non-empty, ask before overwriting.

## Phase 2 — Scaffold the boilerplate

Copy every file from `${CLAUDE_PLUGIN_ROOT}/skills/wireframing/assets/boilerplate/` into the output directory verbatim. Use `cp -r` or equivalent.

The boilerplate's `package.json` declares `@for-the-people-initiative/wireframe-kit: ^1.0.1`. Do not downgrade — the device frames (`PhoneFrame`, `TabletFrame`, `DesktopFrame`, `DeviceFrame`), the `useDevice` composable, and the `--wf-surface` CSS var all require v1.0.1+.

The boilerplate gives you:

```
<output>/
├── package.json              # vue, vue-router, wireframe-kit ^1.0.1, vite, typescript, vue-tsc
├── vite.config.ts            # @vitejs/plugin-vue, port 5173
├── tsconfig.json             # incl. paths override for kit type shims
├── tsconfig.node.json
├── index.html
├── .gitignore
├── README.md
└── src/
    ├── main.ts               # imports kit CSS, fonts, wireframe SCSS, registers WireframePlugin
    ├── env.d.ts
    ├── App.vue               # screen-picker nav + RouterView; device-toggle slot when platform=responsive
    ├── router/index.ts       # auto-discovers src/pages/*.Page.vue via import.meta.glob
    ├── shims/                # tsconfig-paths targets for kit subpath types
    └── pages/
        ├── Home.Page.vue     # auto-generated index of all screens; also hosts Demo controls
        └── Example.Page.vue  # demo using Hero + Section + Card + Form + Button + InputText
```

**Do not modify** `main.ts`, `router/index.ts`, `App.vue`, `vite.config.ts`, `tsconfig*`, `index.html`, `shims/*`. They are scaffolding.

After copying:
- **Replace `Example.Page.vue`** with the user's first real screen (keep its filename pattern).
- If the user named no screen "Home", keep the boilerplate `Home.Page.vue` as the screen index (and extend it with Demo controls if needed — see Phase 3).

## Phase 3 — Per-screen generation

For each screen, produce one file at `src/pages/<PascalCaseName>.Page.vue`.

### File template (mobile example)

```vue
<script lang="ts">
export const meta = { title: 'Human-readable title' };
</script>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import PhoneFrame from '@for-the-people-initiative/wireframe-kit/components/PhoneFrame';
import Button from '@for-the-people-initiative/wireframe-kit/components/Button';
// ...one import per kit component used

const router = useRouter();
</script>

<template>
  <PhoneFrame>
    <!-- composition using kit components, plain placeholder copy -->
    <Button label="Get started" @click="router.push('/next-screen')" />
  </PhoneFrame>
</template>

<style scoped>
/* layout-only CSS — no colour, no typography overrides */
</style>
```

### Device frame per platform

| `platform_target` | Frame | Extra |
|---|---|---|
| `mobile` | `<PhoneFrame>` | — |
| `tablet` | `<TabletFrame>` | — |
| `desktop` | `<DesktopFrame>` | — |
| `responsive` | `<DeviceFrame>` | Import + register `useDevice()` from `@for-the-people-initiative/wireframe-kit/composables` in `App.vue`; the kit renders a device-toggle in the app shell that drives `<DeviceFrame>` and persists choice to `localStorage` |

All frames are imported as default exports from `@for-the-people-initiative/wireframe-kit/components/<Name>`. The frame is the **root element** of `<template>` — page content nests inside.

### Click-through wiring

Every CTA, tab item, back button, row action, or list item action gets a handler that calls `router.push('/<target-slug>')`. Patterns:

- **Button / CTA**: `<Button label="Continue" @click="router.push('/next')" />`
- **TabMenu / Tabs (MenuItem style)**: per item, `command: () => router.push('/<slug>')`:
  ```ts
  const tabs = [
    { label: 'Home', icon: 'home', command: () => router.push('/') },
    { label: 'Log', icon: 'plus', command: () => router.push('/log') },
  ];
  ```
- **Back button**: `router.push('/<previous>')` (explicit target — don't rely on `router.back()` since the demo may be entered via screen-picker).
- **DataTable / DataView row action**: `@row-click="(row) => router.push('/<detail-slug>')"` or per-row `<Button>` inside a column template.
- **Card with an action**: attach `@click` on the card or on a child `Button`.

**Sources of transitions:**
1. If `flow_spec` is provided (YAML/JSON `{from, action, to}` list, or a Mermaid flowchart), parse it and use it as the authoritative map. Reject the spec if it references unknown screens.
2. If not provided, **elicit transitions per screen during generation**: ask "When the user taps `Continue` on Onboarding step 2, where does it go?" for each interactive element that has no obvious target.

Decorative elements without a target stay handler-less — don't invent transitions.

### Demo controls on Home

If any screen or state is not reachable by normal click-through (first-launch onboarding, deep-link-only routes, post-auth flows), generate a "Demo controls" `Section` at the bottom of `Home.Page.vue`:

```vue
<Section title="Demo controls" variant="muted">
  <Button label="Restart onboarding" @click="router.push('/onboarding')" />
  <Button label="Open payment success state" @click="router.push('/payment-success')" />
</Section>
```

Label each button by context so reviewers understand why it's there.

### Placeholder copy

- Default (`placeholders: plain`): short generic copy. `Get started`. `Stay hydrated, daily`. `Sign in to continue`. `No results yet`. Button labels are concrete verbs. Headings are 3–6 words. Body copy is 1–3 short sentences.
- State variants use a plain prefix, no brackets: `State — just logged (undo toast)`, `State — error (network offline)`.
- Opt-in (`placeholders: bracketed`): `[CTA: primary action]`, `[Heading: product promise in 6 words]`, `[Body: 2–3 sentences on benefits]`.
- Either mode: **no Lorem Ipsum**, **no real-looking fake data** (no realistic names / emails / prices / URLs / phone numbers).

### Layout + styling

- Scoped `<style>` for grid / flex / spacing only. No colour, no font, no border styling — kit owns the aesthetic.
- **Floating elements**: every `position: sticky | fixed | absolute` selector gets `background: var(--wf-surface)` explicitly. This applies to sticky tab bars, FABs, persistent toasts/snackbars, sticky headers. Never `inherit` or `transparent`.

### State demonstration

Use the kit's props on the **same** instance (e.g. `<Button is-loading>`, `<Alert severity="error">`, `<Skeleton />` placeholders). To show multiple states side-by-side, render the same component multiple times with different props inside one `<Section>` — don't fork the page.

### Composition heuristics

Match user intent to the kit. Example mappings:

| Screen intent | Kit composition (illustrative) |
|---|---|
| Marketing landing | `Hero` → `Section + FeatureGrid` → `Section + Testimonial`s → `CTA` → `Footer` |
| Auth (sign in / up) | `Section` containing `Form` + `FormField` + `InputText` + `PasswordInput` + `Button` |
| Product / item detail | `Section` + `Image` (placeholder) + headings + `Button` + `Tabs` |
| Product list | `Section` + `Toolbar` + `DataView` (or `Card` grid) + `Paginator` |
| Dashboard | `AppBar` + `Drawer` (nav) + `Stats` + `Chart` + `DataTable` |
| Bottom-tab app | `<PhoneFrame>` + page content + sticky `TabMenu` at bottom |
| Empty / first-run | `Section` + a single `Card` + `Button` |
| Settings | `Tabs` or `Steps` + `Form` + `FormField` + `InputSwitch` / `Select` / `Textarea` |
| Confirmation / modal | trigger `Button` + `Dialog` (or `ConfirmDialog`) |
| Pricing | `Section` + `PricingTable` |
| FAQ | `Section` + `FAQ` |
| Onboarding | `<PhoneFrame>` + `Steps` + per-step `Button` wired forward |

These are starting points — adjust to the brief.

## Phase 4 — Component catalogue (snapshot of v1.0.1)

All components are imported individually as default imports from `@for-the-people-initiative/wireframe-kit/components/<Name>`. Props with `?` are optional. `v-model` binds to `modelValue` unless noted.

### Device frames (v1.0.1)

- **PhoneFrame** — phone device frame; default slot for page content.
- **TabletFrame** — tablet device frame; default slot.
- **DesktopFrame** — desktop / browser-window device frame; default slot.
- **DeviceFrame** — polymorphic wrapper that picks its inner frame from `useDevice()`; use when `platform_target = responsive`. Default slot.
- **Composable** `useDevice` — from `@for-the-people-initiative/wireframe-kit/composables`. Returns reactive `device` + setter, persists to localStorage. Drives `<DeviceFrame>` and renders a toggle in the app shell automatically when imported.

### Layout / page structure

- **AppBar** — `fixed?`, `elevated?`, `transparent?`, `color?`. Top nav bar; default slot.
- **Section** — `title?`, `subtitle?`, `variant?: 'default'|'muted'|'accent'|'dark'`, `padding?: 'sm'|'md'|'lg'|'xl'`, `id?`.
- **Hero** — `title?`, `subtitle?`, `alignment?`, `backgroundImage?`, `overlay?`, `fullHeight?`.
- **Footer** — `columns?: FooterColumn[]`, `logo?`, `copyright?`, `socialLinks?`.
- **CTA** — `title?`, `description?`, `variant?: 'banner'|'card'|'inline'`, `alignment?`.
- **Divider** — `layout?`, `type?`, `align?`.
- **Splitter** / **SplitterPanel** — resizable panes.
- **ScrollPanel** — scrollable region.
- **ScrollTop** — scroll-to-top button.
- **BlockUI** — overlay blocker.
- **Toolbar** — flex container with start / end slots.
- **Sidebar** / **Drawer** — off-canvas panel.
- **Dock** — macOS-style icon dock.

### Navigation

- **Breadcrumb**, **Menu**, **MenuBar**, **MegaMenu**, **PanelMenu**, **TieredMenu**.
- **TabMenu** — tab-style nav (no panels); `model?`, `activeIndex?`. **Wire per item:** `command: () => router.push('/<slug>')`.
- **Tabs** + **TabPanel** — tab container with panels; `activeIndex?`, per-panel `header`.
- **Steps** — wizard step indicator; `model?`, `activeIndex?`, `isReadonly?`. Per step can expose a button forward.
- **ContextMenu**, **CommandPalette**, **SpeedDial**.

### Buttons / actions

- **Button** — `label?`, `icon?`, `iconPos?`, `size?`, `variant?`, `pill?`, `is-disabled?`, `is-loading?`. **Wire CTAs:** `@click="router.push('/<slug>')"`.
- **SplitButton** — primary + dropdown; `model?: MenuItem[]` with per-item `command`.
- **ToggleButton** — `v-model: boolean`.

### Form fields

- **Form**, **FormField**, **FieldSet**.
- **InputText**, **Textarea**, **InputNumber**, **InputMask**, **InputOtp**.
- **InputSwitch** / **ToggleSwitch**, **Checkbox**, **RadioButton**, **PasswordInput**.
- **Select** / **Dropdown**, **MultiSelect**, **AutoComplete**, **InputChips**.
- **InputGroup** + **InputGroupAddon**, **IconField** + **InputIcon**.
- **Slider**, **Knob**, **Rating**, **ColorPicker** (stub).
- **Calendar** / **DatePicker**, **FileUpload**, **Editor**, **SelectButton**, **InPlace**, **Terminal**.

### Data display

- **DataTable** — `value?`, `columns?`, row-click handler wired with `router.push`.
- **Column** / **ColumnGroup** / **Row**.
- **DataView**, **TreeTable**, **Tree**, **TreeSelect**.
- **OrganizationChart**, **OrderList**, **PickList**, **ListBox**, **Paginator**, **VirtualScroller**.
- **Carousel**, **Galleria**, **Lightbox**.
- **Image** — placeholder box from `alt`; `src` ignored.
- **ImageCompare**, **Avatar**, **Badge**, **Chip**, **Tag**, **Skeleton**.
- **Card** — `variant?`. Slots: `header`, `title`, `subtitle`, `content`, `footer`. Wire `@click` for row-style cards.
- **Panel**, **Accordion** + **AccordionTab**.
- **Timeline**, **Stats**, **MeterGroup**, **ProgressBar**, **ProgressSpinner**, **Chart**.
- **LiveTile**, **LogoCloud**.

### Feedback / overlays

- **Alert** — `severity?`, `title?`, `closable?`.
- **InlineMessage**, **Message**, **Toast**.
- **Dialog**, **ConfirmDialog**, **ConfirmPopup**.
- **OverlayPanel** / **PopOver**, **Tooltip**.

### Marketing / landing primitives

- **FeatureGrid**, **PricingTable**, **Testimonial**, **FAQ**.

### Utility

- **WireframeFilter** — global SVG filter; mounted automatically.

### CSS vars (v1.0.1)

- `--wf-surface` — paper/screen background of the active device frame. **Always use** for floating-element backgrounds (`background: var(--wf-surface)`), never literals.

### Types / shared interfaces

`Size = 'sm'|'md'|'lg'`, `Severity = 'success'|'info'|'warn'|'error'`, `Position = 'top'|'bottom'|'left'|'right'`, `Orientation = 'horizontal'|'vertical'`. `MenuItem`: `{ key?, label?, icon?, url?, target?, command?, items?, disabled?, separator?, active?, badge?, description? }`. `TreeNode`: `{ key?, label?, children? }`.

## Phase 5 — Verify and report

After scaffolding + per-screen generation:

1. Print the file tree of `<output>/src/pages/`.
2. Print the chosen **platform target** and which frame component was used.
3. Print the **transitions** wired (one line per `from → action → to`).
4. Print any **Demo controls** added to `Home`.
5. Print the run instructions:

   ```bash
   cd <output>
   npm install
   npm run dev
   ```

6. Tell the user the dev server runs on `http://localhost:5173/`, the screen-picker in the top bar lists every page (fallback navigation), and the click-through is primary.
7. **Do not run `npm install` or `npm run dev` automatically** — let the user opt in. (Per CLAUDE.md: when you do start a server, remember to close it.)

## Phase 6 — Iteration

- **Add a screen**: produce one new file at `src/pages/<Name>.Page.vue`, wrapped in the current platform's frame. Router picks it up on reload. If the new screen is the target of a transition from an existing screen, wire that source's handler.
- **Remove a screen**: delete the file. Remove handlers that pointed at it (they'd 404).
- **Rename a screen**: rename the file (filename = route + title). Update handlers that pointed at the old slug.
- **Change `Home`**: edit `Home.Page.vue`. Preserve the Demo controls section if entry points remain unreachable.
- **Change platform target**: re-wrap every page in the new frame. For `responsive`, ensure `useDevice` is registered in `App.vue`.

## Failure behavior

| Situation | Behavior |
|---|---|
| No screens listed | Interview mode |
| `platform_target` missing | Interview — always ask, never default silently |
| `platform_target` invalid | Reject; list `mobile / tablet / desktop / responsive` |
| Output dir non-empty | Confirm overwrite before copying boilerplate |
| `flow_spec` references an unknown screen | Reject the spec; ask user to correct or add the screen |
| `flow_spec` absent | Elicit transitions conversationally per screen during generation |
| User asks for real images | Refuse politely — `<Image>` renders as placeholder regardless; intent goes in `alt` |
| User asks for Lorem Ipsum / fake real-looking data | Substitute plain copy (or bracketed if opted in); explain |
| User asks for colour / typography choices | Defer to Visual / UI design — kit is monochrome by design |
| User asks for production-ready components | Defer to `front-end-engineering` |
| User asks for high-fidelity / pixel-perfect | Defer to prototyping skills |
| Component not in catalogue | Suggest the closest match; compose from primitives if missing |
| Kit pinned below v1.0.1 | Refuse; device frames + `--wf-surface` require v1.0.1+ |
| `npm install` fails | Check Node (≥ 18), check network for npm registry; do not edit the boilerplate to "work around" |

## Self-check

```
[] Boilerplate copied verbatim (no edits to main.ts / App.vue / router / configs)
[] package.json declares @for-the-people-initiative/wireframe-kit ^1.0.1
[] platform_target collected explicitly; every page wrapped in matching frame (PhoneFrame/TabletFrame/DesktopFrame/DeviceFrame)
[] For platform_target=responsive: useDevice imported and registered in App.vue
[] One <PascalCase>.Page.vue per screen in src/pages/
[] Each page imports its kit components individually from .../components/<Name>
[] No real image URLs anywhere
[] No Lorem Ipsum / no real-looking fake names / emails / prices
[] Placeholder style matches `placeholders` option (plain default; bracketed only if opted in)
[] Every interactive element (button / tab / back / row) wired with router.push per flow_spec or elicited transitions
[] Demo controls Section on Home for any entry point not reachable via normal click-through
[] Layout-only scoped <style> (no colour / typography overrides)
[] Every position: sticky|fixed|absolute element has background: var(--wf-surface)
[] Form inputs have v-model bindings (even if decorative)
[] Multiple states demonstrated via props on shared instances, not duplicate pages
[] Run instructions printed; npm install / npm run dev not executed unprompted
[] Screen-picker nav lists every page (fallback); click-through is primary
```
