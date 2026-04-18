<script lang="ts">
export const meta = { title: 'Wireframe index' };
</script>

<script setup lang="ts">
import { computed } from 'vue';
import { useRouter, RouterLink } from 'vue-router';
import Section from '@for-the-people-initiative/wireframe-kit/components/Section';
import Card from '@for-the-people-initiative/wireframe-kit/components/Card';

const router = useRouter();

const screens = computed(() =>
  router
    .getRoutes()
    .filter((r) => r.meta?.screen && r.path !== '/')
    .map((r) => ({
      path: r.path,
      title: (r.meta?.title as string) ?? r.name?.toString() ?? r.path,
    }))
    .sort((a, b) => a.title.localeCompare(b.title)),
);
</script>

<template>
  <Section title="Wireframe index" subtitle="Pick a screen to review">
    <div v-if="screens.length === 0" class="wf-home__empty">
      [No screens yet — add files to <code>src/pages/&lt;Name&gt;.Page.vue</code>]
    </div>
    <div v-else class="wf-home__grid">
      <Card v-for="s in screens" :key="s.path">
        <template #content>
          <h3>{{ s.title }}</h3>
          <RouterLink :to="s.path">Open</RouterLink>
        </template>
      </Card>
    </div>
  </Section>
</template>

<style scoped>
.wf-home__grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 1rem;
}
.wf-home__empty {
  font-family: 'Caveat', cursive;
  opacity: 0.7;
  padding: 2rem;
  text-align: center;
}
</style>
