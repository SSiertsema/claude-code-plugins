<script setup lang="ts">
import { computed } from 'vue';
import { useRoute, useRouter, RouterView } from 'vue-router';

const route = useRoute();
const router = useRouter();

const screens = computed(() =>
  router
    .getRoutes()
    .filter((r) => r.meta?.screen)
    .map((r) => ({
      path: r.path,
      title: (r.meta?.title as string) ?? r.name?.toString() ?? r.path,
    }))
    .sort((a, b) => (a.path === '/' ? -1 : b.path === '/' ? 1 : a.path.localeCompare(b.path))),
);

const onScreenChange = (event: Event) => {
  const target = event.target as HTMLSelectElement;
  router.push(target.value);
};
</script>

<template>
  <div class="wf-shell">
    <header class="wf-shell__bar">
      <strong class="wf-shell__brand">Wireframes</strong>
      <select
        class="wf-shell__picker"
        :value="route.path"
        aria-label="Pick a screen"
        @change="onScreenChange"
      >
        <option v-for="s in screens" :key="s.path" :value="s.path">{{ s.title }}</option>
      </select>
    </header>
    <main class="wf-shell__main">
      <RouterView />
    </main>
  </div>
</template>

<style>
.wf-shell {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
.wf-shell__bar {
  display: flex;
  gap: 1rem;
  align-items: center;
  padding: 0.5rem 1rem;
  border-bottom: 1px dashed currentColor;
  font-family: 'Caveat', cursive;
}
.wf-shell__brand {
  font-family: 'Permanent Marker', cursive;
  font-size: 1.25rem;
}
.wf-shell__picker {
  font-family: 'Caveat', cursive;
  font-size: 1rem;
  padding: 0.25rem 0.5rem;
}
.wf-shell__main {
  flex: 1;
  padding: 1rem;
}
</style>
