# Next.js Best Practices (2025+)

## App Router Patterns

- Use App Router (`app/`) exclusively. Pages Router is legacy.
- Special files: `page.tsx`, `layout.tsx`, `loading.tsx`, `error.tsx`, `not-found.tsx`, `template.tsx`, `route.ts`.
- Root layout is required, must render `<html>` and `<body>`.
- Layouts persist across navigations. Do not pass data between parent layout and children.
- Route groups `(name)` for organization without affecting URL path.

---

## Server Components vs Client Components

- Default to Server Components. Add `"use client"` only for interactivity.
- Push `"use client"` boundary as deep as possible.
- Server Components access databases, secrets directly with zero client JS.
- Pass Server Components as children to Client Components (composition pattern).
- Use `server-only` and `client-only` packages for import guards.

---

## Server Actions

- Mark with `"use server"`. They are public HTTP endpoints — validate all inputs.
- Use `revalidatePath`/`revalidateTag` after mutations.
- Return structured results. Use `redirect()` for post-mutation navigation.
- Support progressive enhancement: forms work without JavaScript.

---

## Data Fetching

- Fetch directly in Server Components with `async/await`.
- Next.js 15: `fetch` not cached by default. Opt in with `cache: "force-cache"` or `next: { revalidate: N }`.
- React/Next.js deduplicate identical `fetch` calls. Use `React.cache()` for ORM/DB calls.
- `generateStaticParams` for static generation of dynamic routes.
- `Promise.all` for parallel independent fetches.

---

## Rendering Strategies

- Static (SSG): default for routes with no dynamic data.
- Dynamic (SSR): triggered by `cookies()`, `headers()`, `searchParams`, uncached `fetch`.
- ISR: `revalidate` on fetch or segment level. On-demand via `revalidatePath`/`revalidateTag`.
- Streaming: default with App Router. Use `<Suspense>` for granular streaming.
- PPR (experimental): static shell served from CDN, dynamic parts stream within Suspense.

---

## Middleware

- `middleware.ts` at project root. Runs on Edge Runtime.
- Use for auth checks, redirects, rewrites, headers.
- Always define `matcher` to limit execution. Keep lightweight.

---

## Route Handlers

- `route.ts` in `app/` directory. Export HTTP method functions.
- Prefer Server Actions over Route Handlers for UI-triggered mutations.
- Validate request bodies with Zod.

---

## Metadata API

- Static `metadata` export or `generateMetadata` function.
- Child metadata merges with and overrides parent.
- `metadataBase` in root layout for relative URLs.
- `opengraph-image.tsx` for dynamic OG image generation.
- `robots.ts`, `sitemap.ts`, `manifest.ts` file conventions.

---

## Image and Font Optimization

- `next/image` with `alt`, `sizes`, `priority` (LCP only), `placeholder="blur"`.
- `remotePatterns` in config for external domains.
- `next/font` for self-hosted fonts with zero layout shift.
- Use `variable` option for CSS custom property integration.

---

## Performance

- Parallel routes (`@slot`) for independent loading panels.
- Intercepting routes for modals with direct URL fallback.
- `<Link>` auto-prefetches visible routes. `prefetch={false}` for rare links.
- `next/dynamic` for heavy non-immediate components.
- `@next/bundle-analyzer` for bundle analysis.

---

## Caching (Next.js 15)

- Fetch, Route Handlers, and Router Cache no longer cache by default.
- Opt in explicitly: `cache: "force-cache"`, `next: { revalidate: N }`, `next: { tags: [...] }`.
- Time-based revalidation or on-demand via `revalidatePath`/`revalidateTag`.

---

## Authentication

- Middleware for fast route protection. Not sufficient as sole security boundary.
- Verify sessions in Server Components, Server Actions, Route Handlers.
- HTTP-only, Secure, SameSite cookies for sessions.
- Use `cookies()` from `next/headers` for session reads.

---

## Testing

- Vitest/Jest + React Testing Library for component tests.
- Mock `next/navigation` in component tests.
- Playwright for E2E with `webServer` config.
- Test Server Actions as async functions with mocked dependencies.

---

## File Structure

```
app/
  (auth)/        # Route group for auth pages
  (app)/         # Route group for authenticated app
  api/           # Route handlers
  layout.tsx
  not-found.tsx
components/
  ui/            # Generic reusable UI
  forms/
lib/             # Utilities, DB clients, auth helpers
actions/         # Server Actions
types/
middleware.ts
```

---

## Error Handling

- `error.tsx` creates error boundaries. Must be Client Component.
- `global-error.tsx` for root-level errors (must include own `<html>`/`<body>`).
- `notFound()` triggers `not-found.tsx`.
- Use `error.digest` for server-side log correlation.

---

## Internationalization

- Middleware-based locale detection and redirect.
- `[locale]` dynamic segment as route root.
- Load translations server-side in Server Components.
- Set `lang` on `<html>`. Provide `hreflang` metadata.
- `generateStaticParams` for all locales at build time.
