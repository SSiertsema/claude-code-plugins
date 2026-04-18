import { createRouter, createWebHashHistory, type RouteRecordRaw } from 'vue-router';

type PageModule = { default: unknown; meta?: Record<string, unknown> };

const pageModules = import.meta.glob<PageModule>('../pages/*.Page.vue', { eager: true });

const titleFromName = (name: string) =>
  name
    .replace(/([a-z])([A-Z])/g, '$1 $2')
    .replace(/([A-Z])([A-Z][a-z])/g, '$1 $2')
    .trim();

const slugFromName = (name: string) =>
  name
    .replace(/([a-z])([A-Z])/g, '$1-$2')
    .replace(/([A-Z])([A-Z][a-z])/g, '$1-$2')
    .toLowerCase();

const routes: RouteRecordRaw[] = Object.entries(pageModules).map(([file, mod]) => {
  const name = file.split('/').pop()!.replace(/\.Page\.vue$/, '');
  const slug = slugFromName(name);
  const meta = (mod.meta ?? {}) as Record<string, unknown>;
  return {
    path: name === 'Home' ? '/' : `/${slug}`,
    name,
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    component: mod.default as any,
    meta: { screen: true, title: meta.title ?? titleFromName(name), ...meta },
  };
});

routes.sort((a, b) =>
  a.path === '/' ? -1 : b.path === '/' ? 1 : a.path.localeCompare(b.path),
);

export default createRouter({
  history: createWebHashHistory(),
  routes,
});
