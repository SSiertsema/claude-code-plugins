# Wireframes

Vue 3 + Vite + TypeScript app rendering screens with the
[`@for-the-people-initiative/wireframe-kit`](https://www.npmjs.com/package/@for-the-people-initiative/wireframe-kit)
design system (hand-drawn Rough.js aesthetic, monochrome).

## Run

```bash
npm install
npm run dev
```

Open the printed URL. Use the screen-picker in the top bar to navigate.

## Add a screen

Drop a new file in `src/pages/` named `<PascalCaseName>.Page.vue`. The router
auto-discovers it via `import.meta.glob` — no router edit needed. The filename
becomes the title (`ProductDetail` → `Product Detail`) and the slug
(`/product-detail`). The file `Home.Page.vue` is mounted at `/`.

## Wireframing intent

- Every `<Image>` renders as a placeholder box labelled with its `alt` — never
  use real image URLs to "fill in" the design.
- Use intent-only copy: `[CTA: primary action]`, `[Body: 40 words on benefits]`,
  not Lorem Ipsum or real-looking fake data.
- One concern per screen. Show multiple states by composing components.

See the wireframing skill for component catalogue + conventions.
