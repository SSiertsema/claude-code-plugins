---
name: wireframing
description: Scaffold a runnable Vue 3 + Vite + TypeScript wireframe app using the @for-the-people-initiative/wireframe-kit design system (~112 hand-drawn Rough.js components). One file per screen, auto-discovered routes, screen-picker nav. Catalogue + conventions embedded.
argument-hint: "[product / app / screens to wireframe]"
---

# Wireframing

You scaffold a runnable Vue 3 wireframe application that renders one screen per route using the **`@for-the-people-initiative/wireframe-kit`** design system. Output is mid-fi, monochrome, hand-drawn (Rough.js) — wireframes that look like sketches so reviewers comment on structure and flow, not on colour and typography.

This skill is **scaffold + per-screen generation**, not pixel-level visual design or interactive prototyping.

## Core rules

- **No real images** — every `<Image>` from the kit renders a placeholder box from its `alt`, regardless of `src`. Do not try to use real URLs.
- **No real-looking copy** — use intent-only placeholders: `[CTA: primary action]`, `[Body: 40 words on benefits]`, `[Heading: product promise in 6 words]`. No Lorem Ipsum. No fake names / emails / prices that read as real.
- **Wireframe-kit components only** — all UI comes from the kit. Don't hand-roll buttons, cards, forms, or layout primitives that exist in the catalogue.
- **One concern per screen** — if the user lists 5 screens, generate 5 page files. Don't fold them into tabs.
- **Filename = route** — `<PascalCase>.Page.vue` in `src/pages/`. Auto-discovered by router via `import.meta.glob`. No router edit needed.
- **Boilerplate is canonical** — copy from `${CLAUDE_PLUGIN_ROOT}/skills/wireframing/assets/boilerplate/` verbatim. Do not improvise the scaffold.

## When to use

- User wants clickable, browser-renderable wireframes for stakeholder review
- Moving from concept / flow / journey output into mid-fi screen layouts
- Producing wireframes that downstream front-end engineering can read for layout intent
- Iterating layout + composition before commitment to visual design

## When not to use

- Lower-fi exploratory storyboards / concept sketches → `concept-sketching`
- Step-level user flow (no screens) → `user-flow-diagramming`
- Site hierarchy / page typing → `site-mapping`
- Component state machines → `state-transition-mapping`
- Pixel-level visual design / colour / typography decisions → Visual / UI design (Phase 4 visual stream, future)
- High-fidelity interactive prototypes → Prototyping skills (future)
- Production component code → `front-end-engineering`

## Phase 1 — Setup

Collect:

| Field | Required | Default |
|---|---|---|
| **App name** | Yes | — |
| **Screens to wireframe** (PascalCase names) | Yes | — |
| **Output directory** | No | `./wireframes/` |
| **Per-screen brief** (optional) | No | Elicit per screen |

If any required field is missing, enter Interview mode and ask only for what's missing.

If the output directory exists and is non-empty, ask before overwriting.

## Phase 2 — Scaffold the boilerplate

Copy every file from `${CLAUDE_PLUGIN_ROOT}/skills/wireframing/assets/boilerplate/` into the output directory verbatim. Use `cp -r` or equivalent.

The boilerplate gives you:

```
<output>/
├── package.json              # vue, vue-router, wireframe-kit, vite, typescript, vue-tsc
├── vite.config.ts            # @vitejs/plugin-vue, port 5173
├── tsconfig.json             # incl. paths override for kit type shims
├── tsconfig.node.json
├── index.html
├── .gitignore
├── README.md
└── src/
    ├── main.ts               # imports kit CSS, fonts, wireframe SCSS, registers WireframePlugin
    ├── env.d.ts
    ├── App.vue               # screen-picker nav + RouterView
    ├── router/index.ts       # auto-discovers src/pages/*.Page.vue via import.meta.glob
    ├── shims/                # tsconfig-paths targets for kit subpath types
    │   ├── kit-component.d.ts  # default-export DefineComponent shim for /components/*
    │   └── kit-plugin.d.ts     # type shim for /plugin
    └── pages/
        ├── Home.Page.vue     # auto-generated index of all screens
        └── Example.Page.vue  # demo using Hero + Section + Card + Form + Button + InputText
```

**Do not modify** `main.ts`, `router/index.ts`, `App.vue`, `vite.config.ts`, `tsconfig*`, `index.html`, `shims/*`, or `Home.Page.vue`. They are scaffolding. The `shims/` directory exists because the kit's v1.0.0 `exports` field points `types` for `/components/*` and `/plugin` at the shared barrel (which has no default exports); the tsconfig `paths` redirect resolves that — remove when the kit ships per-subpath `.d.ts`.

After copying:
- **Replace `Example.Page.vue`** with the user's first real screen (keep its filename pattern).
- If the user named no screen "Home", keep the boilerplate `Home.Page.vue` as the screen index.

## Phase 3 — Per-screen generation

For each screen, produce one file at `src/pages/<PascalCaseName>.Page.vue`.

### File template

```vue
<script lang="ts">
export const meta = { title: '<Human-readable title>' };
</script>

<script setup lang="ts">
import { ref } from 'vue';
import <Component> from '@for-the-people-initiative/wireframe-kit/components/<Component>';
// ...one import per kit component used
</script>

<template>
  <!-- composition using kit components, intent-only placeholders -->
</template>

<style scoped>
/* layout-only CSS — no colour, no typography overrides */
</style>
```

### Conventions

- **Imports**: one per component, default import from `.../components/<Name>`. No barrel imports.
- **Filename → route**: `ProductDetail.Page.vue` → `/product-detail`, title "Product Detail". `Home.Page.vue` → `/`.
- **Custom title**: override via `export const meta = { title: '...' }` in the non-setup `<script>` block.
- **Reactive state**: use `ref` / `reactive` for v-model bindings on form inputs, even if the value is decorative — kit inputs require `v-model`.
- **Layout**: scoped `<style>` for grid / flex / spacing only. No colour, no font, no border styling — kit owns the aesthetic.
- **Intent placeholders** in copy (see Core rules).

### Composition heuristics

Match user intent to the kit. Example mappings:

| Screen intent | Kit composition (illustrative) |
|---|---|
| Marketing landing | `Hero` → `Section + FeatureGrid` → `Section + Testimonial`s → `CTA` → `Footer` |
| Auth (sign in / up) | `Section` containing `Form` + `FormField` + `InputText` + `PasswordInput` + `Button` |
| Product / item detail | `Section` + `Image` (placeholder) + headings + `Button` + `Tabs` (description / specs / reviews) |
| Product list | `Section` + `Toolbar` + `DataView` (or `Card` grid) + `Paginator` |
| Dashboard | `AppBar` + `Drawer` (nav) + `Stats` + `Chart` + `DataTable` |
| Empty / first-run | `Section` + a single `Card` with placeholder copy + `Button` |
| Settings | `Tabs` or `Steps` + `Form` + `FormField` + `InputSwitch` / `Select` / `Textarea` |
| Confirmation / modal | trigger `Button` + `Dialog` (or `ConfirmDialog`) |
| Pricing | `Section` + `PricingTable` |
| FAQ | `Section` + `FAQ` |

These are starting points — adjust to the brief.

### State demonstration

If the user asks to "show the loading state of X" or "show error variant", do **not** fork the page. Use the kit's prop on the same instance (e.g. `<Button is-loading>`, `<Alert severity="error">`, `<Skeleton />` placeholders). To show multiple states side-by-side, render the same component multiple times with different props inside one `<Section>`.

## Phase 4 — Component catalogue (snapshot of v1.0.0)

All components are imported individually as default imports from `@for-the-people-initiative/wireframe-kit/components/<Name>`. Props with `?` are optional. `v-model` binds to `modelValue` unless noted.

### Layout / page structure

- **AppBar** — `fixed?`, `elevated?`, `transparent?`, `color?`. Top nav bar; default slot for content.
- **Section** — `title?`, `subtitle?`, `variant?: 'default'|'muted'|'accent'|'dark'`, `padding?: 'sm'|'md'|'lg'|'xl'`, `id?`. Section wrapper; default slot.
- **Hero** — `title?`, `subtitle?`, `alignment?: 'left'|'center'|'right'`, `backgroundImage?`, `overlay?`, `fullHeight?`. Marketing hero.
- **Footer** — `columns?: FooterColumn[]`, `logo?`, `copyright?`, `socialLinks?`. Page footer.
- **CTA** — `title?`, `description?`, `variant?: 'banner'|'card'|'inline'`, `alignment?`. Call-to-action block.
- **Divider** — `layout?: 'horizontal'|'vertical'`, `type?: 'solid'|'dashed'|'dotted'`, `align?`.
- **Splitter** / **SplitterPanel** — resizable panes; `layout?`, `gutterSize?`, panel `size?` / `minSize?`.
- **ScrollPanel** — scrollable region; `style?`, `step?`.
- **ScrollTop** — scroll-to-top button; `threshold?`, `behavior?`, `target?`.
- **BlockUI** — overlay blocker; `blocked?`, `fullScreen?`, `showSpinner?`.
- **Toolbar** — flex container with start / end slots.
- **Sidebar** / **Drawer** — off-canvas panel; `visible?`, `header?`, `position?`, `size?`, `closable?`.
- **Dock** — macOS-style icon dock; `model: DockItem[]`, `position?`, `magnification?`.

### Navigation

- **Breadcrumb** — `model?: BreadcrumbItem[]`, `home?`.
- **Menu** — `model?: MenuItem[]`, `popup?`.
- **MenuBar** — horizontal menubar; `model?: MenuItem[]`.
- **MegaMenu** — `model?`, `orientation?`.
- **PanelMenu** — collapsible nested menu; `model?`, `expandedKeys?`, `multiple?`.
- **TieredMenu** — multilevel popup; `model?`, `popup?`.
- **TabMenu** — tab-style nav (no panels); `model?`, `activeIndex?`.
- **Tabs** + **TabPanel** — tab container with panels; `activeIndex?`, `header` per panel.
- **Steps** — wizard step indicator; `model?: StepItem[]`, `activeIndex?`, `isReadonly?`.
- **ContextMenu** — right-click menu; `model?`, `global?`, `popup?`.
- **CommandPalette** — `commands: CommandPaletteCommand[]`, `placeholder?`, `open?`.
- **SpeedDial** — FAB with radial actions; `model?: SpeedDialItem[]`, `direction?`, `type?`.

### Buttons / actions

- **Button** — `label?`, `icon?`, `iconPos?`, `size?: 'sm'|'md'|'lg'`, `variant?: 'primary'|'secondary'|'outlined'|'text'`, `pill?`, `is-disabled?`, `is-loading?`.
- **SplitButton** — primary action + dropdown; `label?`, `icon?`, `model?: MenuItem[]`, `severity?`, `size?`.
- **ToggleButton** — on / off button; `v-model: boolean`, `onLabel?`, `offLabel?`, `onIcon?`, `offIcon?`.

### Form fields

- **Form** — `layout?: 'vertical'|'horizontal'`, `labelWidth?`. Emits `submit`.
- **FormField** — wraps a control; `label?`, `labelFor?`, `htmlFor?`, `required?`, `error?`, `hint?`, `disabled?`.
- **FieldSet** — grouped fields; `legend?`, `toggleable?`, `collapsed?`.
- **InputText** — `v-model`, `type?`, `placeholder?`, `name?`, `size?`, `is-disabled?`, `is-invalid?`.
- **Textarea** — `v-model`, `rows?`, `cols?`, `placeholder?`, `autoResize?`, `is-disabled?`, `is-invalid?`.
- **InputNumber** — `v-model: number|null`, `min?`, `max?`, `step?`, `showButtons?`, `locale?`, `min/maxFractionDigits?`.
- **InputMask** — `v-model`, `mask` (required), `slotChar?`, `autoClear?`, `placeholder?`.
- **InputOtp** — `v-model`, `length?`, `mask?`, `integerOnly?`, `autoFocus?`.
- **InputSwitch** / **ToggleSwitch** — `v-model: boolean`, `label?`, `name?`, `is-disabled?`.
- **Checkbox** — `v-model: boolean`, `label?`, `value?`, `indeterminate?`, `is-disabled?`, `is-invalid?`.
- **RadioButton** — `v-model`, `value` (required), `label?`, `name?`.
- **PasswordInput** — `v-model`, `showStrength?`, `showCriteria?`, `minLength?`, `confirmValue?`, `requireStrength?: 'none'|'weak'|'fair'|'strong'`.
- **Select** / **Dropdown** — `v-model`, `options?`, `optionLabel?`, `optionValue?`, `placeholder?`, `filter?` (Dropdown), `size?`.
- **MultiSelect** — `v-model: unknown[]`, `options?`, `display?: 'comma'|'chip'`, `filter?`.
- **AutoComplete** — `v-model`, `suggestions?`, `optionLabel?`, `multiple?`, `minLength?`, `delay?`, `dropdown?`, `completeOnFocus?`. Emits `complete` to refresh suggestions.
- **InputChips** — `v-model: string[]`, `separator?`, `allowDuplicate?`, `max?`.
- **InputGroup** + **InputGroupAddon** — group an input with addons (e.g. icon, prefix). `IconField` + `InputIcon` for icon-decorated inputs.
- **Slider** — `v-model: number`, `min?`, `max?`, `step?`, `is-disabled?`.
- **Knob** — circular slider; `v-model: number`, `min?`, `max?`, `step?`, `size?`, `valueTemplate?`.
- **Rating** — `v-model: number|null`, `stars?`, `readonly?`, `cancel?`.
- **ColorPicker** — stub (always emits `#000000`); `v-model`, `inline?`, `presetColors?`, `size?`.
- **Calendar** / **DatePicker** — date inputs; `v-model: Date|Date[]|null`, `placeholder?`, `format?`/`dateFormat?`, `min/maxDate?`, `selectionMode?`, `inline?`.
- **FileUpload** — `accept?`, `multiple?`, `maxFileSize?`, `maxFiles?`. Emits `select` / `remove` / `error`.
- **Editor** — rich-text-style stub; `v-model`, `placeholder?`.
- **SelectButton** — segmented choice; `v-model`, `options` (required), `multiple?`, `allowEmpty?`.
- **InPlace** — toggleable display ↔ edit; `active?`, `closable?`.
- **Terminal** — CLI stub; `prompt?`, `welcomeMessage?`. Emits `command`.

### Data display

- **DataTable** — `value?`, `columns?: DataTableColumn[]`, `striped?`, `hoverable?`, `paginator?`, `rows?`, `sortField?`.
- **Column** / **ColumnGroup** / **Row** — DataTable composition primitives.
- **DataView** — `value?`, `layout?: 'list'|'grid'`, `gridColumns?`, `paginator?`, `showLayoutSwitcher?`.
- **TreeTable** — hierarchical table; `nodes?`, `columns?: TreeTableColumn[]`, `expandedKeys?`, `selectionMode?`.
- **Tree** — `nodes?`, `expandedKeys?`, `selectionMode?`, `filter?`.
- **TreeSelect** — tree picker input; `v-model`, `options?: TreeNode[]`, `selectionMode?`, `filter?`.
- **OrganizationChart** — org chart; `value?`, `selectionMode?`, `expandedKeys?`, `collapsible?`.
- **OrderList** — reorderable list; `v-model: any[]`, `header?`, `multiple?`.
- **PickList** — dual-list transfer; `source?`, `target?`, `sourceHeader?`, `targetHeader?`.
- **ListBox** — `v-model`, `options?`, `multiple?`, `filter?`.
- **Paginator** — standalone pagination; `totalRecords` (required), `rows?`, `first?`, `rowsPerPageOptions?`.
- **VirtualScroller** — virtualized list; `items?`, `itemSize?`, `scrollHeight?`, `loading?`.
- **Carousel** — `items?`, `numVisible?`, `numScroll?`, `circular?`, `autoplay?`, `showNavigators?`, `showIndicators?`, `orientation?`.
- **Galleria** — image gallery (placeholders); `items?`, `activeIndex?`, `fullscreen?`, `showThumbnails?`, `enableZoom?`.
- **Lightbox** — `images?`, `visible?`, `activeIndex?`, `showThumbnails?`, `zoom?`.
- **Image** — placeholder box from `alt`; `src` (required, ignored), `alt?`, `width?`, `height?`, `preview?`.
- **ImageCompare** — slider compare; `initialPosition?`.
- **Avatar** — `label?`, `icon?`, `image?` (placeholder), `size?: 'small'|'medium'|'large'|'xlarge'`, `shape?: 'square'|'circle'`.
- **Badge** — `value?`, `size?`, `severity?: 'primary'|'success'|'warning'|'danger'|'info'`.
- **Chip** — `label?`, `icon?`, `image?` (placeholder), `removable?`.
- **Tag** — `value?`, `color?: 'brand'|'accent'|'neutral'|'success'|'warning'|'danger'|'info'`, `icon?`, `rounded?`.
- **Skeleton** — loading placeholder; `shape?`, `width?`, `height?`, `borderRadius?`, `animation?`.
- **Card** — `variant?: 'default'|'highlighted'`. Slots: `header`, `title`, `subtitle`, `content`, `footer`.
- **Panel** — `header?`, `toggleable?`, `collapsed?`.
- **Accordion** + AccordionTab — `activeIndex?`, `multiple?`; tab `header?`, `isDisabled?`.
- **Timeline** — `value: TimelineEvent[]`, `align?`, `layout?`.
- **Stats** — `stats?: StatItem[]`, `columns?: 2|3|4`.
- **MeterGroup** — stacked progress bars; `values: MeterGroupValue[]`, `max?`, `orientation?`.
- **ProgressBar** — `value?`, `showValue?`, `mode?: 'determinate'|'indeterminate'`.
- **ProgressSpinner** — `strokeWidth?`, `fill?`, `animationDuration?`.
- **Chart** — sketchy SVG stub (axes + bars/line/pie); `type?`, `data?`, `options?`, `title?`, `isLoading?`.
- **LiveTile** — Windows-style flipping tile; `href?`, `title?`, `icon?`, `badge?`, `badgeClass?`, `loading?`, `faceCount?`, `hideBranding?`.
- **LogoCloud** — `logos?: LogoItem[]` (placeholders), `title?`, `grayscale?`, `columns?`.

### Feedback / overlays

- **Alert** — `severity?: 'success'|'info'|'warn'|'error'`, `title?`, `closable?`, `icon?`.
- **InlineMessage** — inline alert; `severity?`, `icon?`.
- **Message** — toast-like inline; `severity?`, `closable?`, `icon?`, `life?`.
- **Toast** — global toast service; `position?: 'top-left'|...|'center'`, `group?`, `showIcon?`, `showProgress?`.
- **Dialog** — modal; `visible?`, `header?`, `closable?`, `modal?`, `draggable?`, `dismissableMask?`, `size?: 'sm'|'md'|'lg'|'xl'`.
- **ConfirmDialog** — `visible?`, `header?`, `message?`, `icon?`, `acceptLabel?`, `rejectLabel?`.
- **ConfirmPopup** — anchored confirm; `target?`, `message?`, `position?`.
- **OverlayPanel** / **PopOver** — `visible?`, `dismissable?`, `position?` (PopOver), `trigger?` (PopOver).
- **Tooltip** — `content` (required), `position?`, `showDelay?`, `hideDelay?`.

### Marketing / landing primitives

- **FeatureGrid** — `columns?: 2|3|4`, `features?: FeatureItem[]`, `variant?: 'card'|'minimal'|'icon-top'`.
- **PricingTable** — `plans?: PricingCardProps[]`, `columns?: 2|3|4`.
- **Testimonial** — `quote` (required), `author` (required), `role?`, `company?`, `avatar?` (placeholder), `rating?`, `variant?`.
- **FAQ** — `items?: FAQItem[]`, `variant?: 'default'|'separated'|'bordered'`.

### Utility

- **WireframeFilter** — global SVG filter for the rough aesthetic. Mounted automatically when imported on a page; you typically don't need to render it directly.

### Composables

- **useFieldValidation** — from `@for-the-people-initiative/wireframe-kit/composables`. Field-level validation helper.

### Types / shared interfaces

`Size = 'sm'|'md'|'lg'`, `Severity = 'success'|'info'|'warn'|'error'`, `Position = 'top'|'bottom'|'left'|'right'`, `Orientation = 'horizontal'|'vertical'`. `MenuItem` shape: `{ key?, label?, icon?, url?, target?, command?, items?, disabled?, separator?, active?, badge?, description? }`. `TreeNode` shape: `{ key?, label?, children? }`.

## Phase 5 — Verify and report

After scaffolding + per-screen generation:

1. Print the file tree of `<output>/src/pages/`.
2. Print the run instructions:

   ```bash
   cd <output>
   npm install
   npm run dev
   ```

3. Tell the user the dev server runs on `http://localhost:5173/` and the screen-picker in the top bar lists every page.
4. Remind: open in a browser, click through the screens, take screenshots if needed for the review.
5. **Do not run `npm install` or `npm run dev` automatically** — let the user opt in. (Per CLAUDE.md: when you do start a server, remember to close it.)

## Phase 6 — Iteration

When the user asks to add a screen: produce one new file at `src/pages/<Name>.Page.vue`. The router picks it up on the next dev-server reload — no other edit needed.

When the user asks to remove a screen: delete the file.

When the user asks to rename: rename the file (filename = route + title).

When the user asks to change `Home`: edit `Home.Page.vue`. The boilerplate version is just an index — replacing it with a real home screen is fine.

## Failure behavior

| Situation | Behavior |
|---|---|
| No screens listed | Interview mode — ask which screens, app name, output dir |
| Output dir non-empty | Confirm overwrite before copying boilerplate |
| User asks for real images | Refuse politely — explain Image renders as placeholder regardless; intent goes in `alt` |
| User asks for Lorem Ipsum or fake real-looking data | Substitute intent placeholders, explain why |
| User asks for colour / typography choices | Defer to Visual / UI design — the kit is monochrome by design |
| User asks for production-ready components | Defer to `front-end-engineering` — wireframe-kit is for sketches only |
| User asks for high-fidelity / pixel-perfect | Defer to prototyping skills — this is mid-fi only |
| Component user wants doesn't exist in catalogue | Suggest the closest match; if truly missing, compose from primitives (`Section` + `Card` + …) |
| `npm install` fails | Check Node version (need ≥ 18), check network for npm registry; do not edit the boilerplate to "work around" |

## Self-check

```
[] Boilerplate copied verbatim (no edits to main.ts / App.vue / router / configs)
[] One <PascalCase>.Page.vue per screen in src/pages/
[] Each page imports its kit components individually from .../components/<Name>
[] No real image URLs anywhere
[] No Lorem Ipsum / no real-looking fake names / emails / prices
[] Layout-only scoped <style> (no colour / typography overrides)
[] Form inputs have v-model bindings (even if decorative)
[] Multiple states demonstrated via props on shared instances, not duplicate pages
[] Run instructions printed; npm install / npm run dev not executed unprompted
[] Screen-picker nav lists every page
```
