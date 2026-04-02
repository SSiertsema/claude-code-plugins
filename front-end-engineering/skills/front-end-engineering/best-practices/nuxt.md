# Nuxt 3 Best Practices (2025+)

## Rendering Modes

- SSR is default (`ssr: true`). Only disable for purely client-side apps.
- `npx nuxi generate` for SSG. Use `crawlLinks: true` for dynamic route discovery.
- ISR via `routeRules: { '/blog/**': { isr: 3600 } }`.
- SWR via `routeRules: { '/api/products': { swr: 600 } }`.
- Hybrid rendering: mix strategies per route in `routeRules`.
- Use `prerender: true` for static pages, `ssr: false` for client-only sections.

---

## Auto-Imports

- All composables from `composables/` auto-imported by filename.
- All components from `components/` auto-registered (subdirectory names become prefixes).
- `utils/` auto-imported for pure helper functions.
- Never manually import from `vue` or `nuxt/app` — they are auto-imported.
- Run `npx nuxi prepare` to regenerate types.

---

## Data Fetching

### useFetch
- Primary composable. Always `await` at top level of `<script setup>`.
- Use `key` option for unique cache keys. Use `watch` for reactive refetching.
- Use `lazy: true` for non-critical data. Use `pick`/`transform` to reduce payload.

### useAsyncData
- For custom functions. Always provide a unique string key.

### $fetch
- For fire-and-forget: event handlers, form submissions.
- Never use directly in `<script setup>` for SSR data (causes double-fetching).

### Caching
- `getCachedData` option for client-side caching.
- `defineCachedEventHandler` for server-side caching.
- `routeRules` with `swr`/`isr` for server cache.

---

## Server Routes and API

- `server/api/` with method suffixes: `.get.ts`, `.post.ts`, `.put.ts`, `.delete.ts`.
- `server/routes/` for non-API endpoints.
- Validate with Zod via `readValidatedBody`.
- `server/middleware/` for auth, logging, CORS.
- `server/utils/` auto-imported within server context.
- `defineCachedEventHandler` for expensive queries.

---

## State Management

### useState
- SSR-safe reactive state with unique string key.
- Replaces `ref` for cross-component shared state in SSR.

### Pinia
- Setup stores (Composition API syntax).
- Add `stores/` to `imports.dirs`.
- Use `clearNuxtState(key)` for logout flows.

---

## SEO

- `useSeoMeta` for typed SEO meta tags (preferred over `useHead` for SEO).
- `definePageMeta` for static page configuration (layout, middleware).
- Always set `ogTitle`, `ogDescription`, `ogImage`, `ogUrl`, `twitterCard`.
- JSON-LD via `useHead` script tags or `nuxt-schema-org` module.
- `@nuxtjs/sitemap` and `nuxt-robots` modules.

---

## Performance

- `pick`/`transform` on `useFetch`/`useAsyncData` to minimize SSR payload.
- Component islands (`.server.vue`) for zero-JS server-only components.
- `Lazy` prefix for deferred component loading.
- `<NuxtImg>`/`<NuxtPicture>` from `@nuxt/image` for image optimization.
- `npx nuxi analyze` for bundle analysis.

---

## Middleware

- Named: `middleware/auth.ts` applied via `definePageMeta({ middleware: 'auth' })`.
- Global: `.global.ts` suffix runs on every route change.
- `navigateTo()` for redirects, `abortNavigation()` to cancel.
- Server middleware (`server/middleware/`) for HTTP-level concerns.

---

## Plugins and Modules

- `plugins/` auto-registered. Use `.server.ts`/`.client.ts` suffixes for context.
- `defineNuxtPlugin` with `provide` for global helpers.
- Essential modules: `@nuxt/image`, `@nuxt/fonts`, `@nuxt/eslint`, `@pinia/nuxt`.

---

## TypeScript

- First-class support. Use `.ts` everywhere.
- `npx nuxi typecheck` in CI. `typescript.strict: true` in config.
- Augment Nuxt types via `types/nuxt.d.ts`.

---

## Error Handling

- `<NuxtErrorBoundary>` for component-level error catching.
- `createError({ statusCode, message })` in server routes.
- `error.vue` in project root as global error page.
- Always handle `error` from `useFetch`/`useAsyncData`.

---

## Testing

- `@nuxt/test-utils` with Vitest. `mountSuspended` for components.
- `mockNuxtImport` for auto-imported composables.
- `registerEndpoint` for mocking server API routes.
- Playwright for E2E with `@nuxt/test-utils/e2e`.

---

## Deployment

- Nitro presets: `node-server`, `vercel`, `netlify`, `cloudflare-pages`, etc.
- `runtimeConfig` for environment variables. Never put secrets in `public`.
- Multi-stage Docker builds from `.output/`.

---

## File Structure

```
├── components/     # Auto-imported Vue components
├── composables/    # Auto-imported composables
├── layouts/        # Layout components
├── middleware/      # Route middleware
├── pages/          # File-based routing
├── plugins/        # Auto-registered plugins
├── public/         # Static files
├── server/
│   ├── api/        # API routes
│   ├── middleware/  # Server middleware
│   ├── plugins/    # Nitro plugins
│   └── utils/      # Auto-imported server utils
├── stores/         # Pinia stores
├── types/          # Shared types
├── utils/          # Auto-imported utilities
├── app.vue         # Root component
├── error.vue       # Global error page
└── nuxt.config.ts
```

---

## Layers and Extends

- Extend from local directory, npm package, or git repository.
- Layers share components, composables, pages, server routes.
- Use for shared UI, base apps, themes, multi-tenant apps.
- Consuming app's files take priority over layer files.
