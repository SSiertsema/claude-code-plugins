<script setup lang="ts">
import AppearanceToggle from './AppearanceToggle.vue'

// VitePress' client-router vangt <a>-clicks af en kan proberen intern te
// SPA-routeren — zelfs bij href="/" over de sub-site-base heen. We forceren
// full-page navigation via window.location.assign('/'), zo gaat de browser
// daadwerkelijk naar de domain-root (de hub).
function goToHub(event: Event) {
  event.preventDefault()
  event.stopPropagation()
  if (typeof window !== 'undefined') {
    window.location.assign(window.location.origin + '/')
  }
}
</script>

<template>
  <div class="main-header">
    <div class="main-header__inner">
      <a
        class="main-header__title"
        href="/"
        title="Terug naar Solution Explorer"
        @click="goToHub"
      >
        <span class="main-header__dot" aria-hidden="true">◆</span>
        <span>Solution Explorer</span>
      </a>
      <div class="main-header__actions">
        <AppearanceToggle />
      </div>
    </div>
  </div>
</template>

<style scoped>
.main-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 60;
  height: var(--vp-layout-top-height, 38px);
  background: var(--vp-c-bg-alt);
  border-bottom: 1px solid var(--vp-c-divider);
}
.main-header__inner {
  max-width: 100%;
  height: 100%;
  padding: 0 1.5rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
}
.main-header__title {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--vp-c-text-1);
  text-decoration: none;
  font-size: 0.85rem;
  font-weight: 600;
  letter-spacing: 0.02em;
  white-space: nowrap;
  cursor: pointer;
}
.main-header__title:hover {
  color: var(--vp-c-brand-1);
}
.main-header__dot {
  color: var(--vp-c-brand-1);
  font-size: 0.85rem;
  line-height: 1;
}
.main-header__actions {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
@media (max-width: 768px) {
  .main-header__inner {
    padding: 0 1rem;
  }
  .main-header__title {
    font-size: 0.8rem;
  }
}
</style>
