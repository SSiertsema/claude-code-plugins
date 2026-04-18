import { createApp } from 'vue';
import { WireframePlugin } from '@for-the-people-initiative/wireframe-kit/plugin';

import '@for-the-people-initiative/wireframe-kit/css';
import '@for-the-people-initiative/wireframe-kit/scss/fonts';
import '@for-the-people-initiative/wireframe-kit/scss/wireframe';

import App from './App.vue';
import router from './router';

createApp(App).use(WireframePlugin).use(router).mount('#app');
