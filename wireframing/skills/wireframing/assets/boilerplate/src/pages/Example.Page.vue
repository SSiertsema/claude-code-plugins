<script lang="ts">
export const meta = { title: 'Example screen' };
</script>

<script setup lang="ts">
import { ref } from 'vue';
import Section from '@for-the-people-initiative/wireframe-kit/components/Section';
import Hero from '@for-the-people-initiative/wireframe-kit/components/Hero';
import Card from '@for-the-people-initiative/wireframe-kit/components/Card';
import Button from '@for-the-people-initiative/wireframe-kit/components/Button';
import Form from '@for-the-people-initiative/wireframe-kit/components/Form';
import FormField from '@for-the-people-initiative/wireframe-kit/components/FormField';
import InputText from '@for-the-people-initiative/wireframe-kit/components/InputText';

const email = ref('');
</script>

<template>
  <Hero
    title="[Headline: product promise in 6 words]"
    subtitle="[Subhead: clarifying value prop in one sentence]"
    alignment="center"
  />

  <Section title="[Section: features]" subtitle="[Subhead: what differentiates us]">
    <div class="example-grid">
      <Card v-for="i in 3" :key="i">
        <template #content>
          <h3>[Feature {{ i }} title]</h3>
          <p>[Feature {{ i }} body — 1 sentence on benefit]</p>
        </template>
      </Card>
    </div>
  </Section>

  <Section title="[Section: sign up]">
    <Form layout="vertical">
      <FormField label="Email" required>
        <InputText v-model="email" placeholder="you@example.com" />
      </FormField>
      <Button label="[CTA: primary]" variant="primary" />
    </Form>
  </Section>
</template>

<style scoped>
.example-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 1rem;
}
</style>
