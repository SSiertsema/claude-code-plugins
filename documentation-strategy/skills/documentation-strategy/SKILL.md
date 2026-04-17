---
name: documentation-strategy
description: Docs strategy — audience map, Diátaxis (tutorial / how-to / reference / explanation), IA, docs-as-code, review + maintenance with owners + staleness alerts, findability, localization + a11y, metrics.
argument-hint: "[product + audiences + current docs state]"
---

# Documentation Strategy

You design how docs serve users + teammates — not "write all the docs" but "write the right docs for named audiences + keep them alive".

## Core rules

- **Audience-first** — each doc serves a specific audience + intent
- **Diátaxis framework** — four distinct doc types (tutorials / how-to / reference / explanation); don't mix
- **Living docs over stale docs** — fewer good docs > many stale ones
- **Ownership named** — every doc has an owner + review cadence
- **Findability > volume** — docs nobody finds don't exist
- **Docs-as-code default** — versioned, reviewed, CI-tested
- **Accessibility + localization deliberate** — not afterthoughts
- **No fabricated audiences** — work from supplied context

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Product** | Yes | — |
| **Audiences** | Yes | — |
| **Current docs state** | Yes | — |
| **Pain points** (nobody finds docs / stale / wrong content for wrong audience) | No | Asked |
| **Compliance needs** | No | Asked |

## Phase 1 — Setup

```
**Product**: [name + scope]
**Audiences**: [end-users / API consumers / operators / future maintainers / newcomers / leadership / regulators]
**Current state**: [scattered wiki / README-only / excellent but aging / none]
**Pain**: [findability / staleness / wrong-type-for-audience]
**Compliance**: [SOX / SOC 2 / GDPR / sector]
**Existing tooling**: [Confluence / Notion / Docusaurus / ReadTheDocs / MkDocs / Backstage TechDocs]
```

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/documentation-strategy/`).

## Phase 2 — Audience map

For each audience, list:

| Audience | What they need | Intent | Success looks like |
|---|---|---|---|
| End-users | UI how-to, onboarding tutorials | accomplish a task | task completed |
| API consumers | reference, quickstart tutorials, SDK guides | integrate | first successful API call in < 15 min |
| Operators / SRE | runbooks, dashboards, playbooks | keep it running | incident handled |
| Future maintainers | architecture, ADRs, decision history | safely change | confident PR |
| Newcomers | onboarding guide, code tours | ramp up | first PR merged |
| Leadership | roadmap, status, metrics | make decisions | informed decision |
| Regulators / auditors | policies, evidence, DPA | compliance | audit pass |

Each audience has a doc home + entry point.

## Phase 3 — Diátaxis framework

Four distinct types — don't mix them in a single doc:

| Type | Serves | Focus | Example |
|---|---|---|---|
| **Tutorial** | learning | sequential, hand-held, concrete | "Build your first order in 15 min" |
| **How-to guide** | task completion | goal-oriented, practical | "How to refund an order" |
| **Reference** | information lookup | factual, complete, dry | API endpoint reference |
| **Explanation** | understanding | discussion of concepts + design | "Why eventual consistency" |

Signs of mixing:
- Tutorials with reference tables buried mid-step
- How-to guides that try to teach concepts
- References that go on narrative tangents
- Explanations with step-by-step instructions

Fix by splitting the doc.

## Phase 4 — Information architecture

### Navigation

- One entry point per audience
- Progressive disclosure — landing page → section → page
- Breadcrumbs always
- Search-first mindset (most users search, don't browse)
- 404s link to search + similar topics

### Findability

- Titles in user language, not internal jargon
- H1–H3 headers for structure; search engines + skimmers rely on them
- Consistent terminology (glossary)
- Cross-linking between related docs
- Tag / category taxonomy

### Versioning

- Product version aware (v1 / v2 docs)
- Deprecation markers (`@deprecated`, sunset headers in API docs)
- Archive old versions; don't delete

## Phase 5 — Living documentation + docs-as-code

- **Docs near code** — API docs generated from specs (OpenAPI); code comments for in-line reference
- **CI-tested** — links not broken, code samples still work, screenshots not stale
- **Reviewed like code** — PR process, codeowners, required reviewers
- **Versioned with product** — tag releases; doc version aligned
- **Auto-generated where valuable** — API ref, CLI ref, schema ref
- **Handwritten where irreplaceable** — explanations, tutorials, opinionated how-tos

## Phase 6 — Review + maintenance

- **Owner per doc / section** (codeowners equivalent)
- **Review cadence** (e.g., quarterly for explanations, on-change for references, annually for tutorials with usage metrics)
- **Staleness alerts** — date last reviewed + automated alerts when aged
- **Deprecation policy** — mark, announce, remove
- **Decay is normal** — audit twice yearly to prune

## Phase 7 — Contribution model

- Style guide (voice, tone, terminology, formatting)
- Plain-language principles
- Template per doc type (tutorial template, how-to template, reference template, explanation template)
- Contributor guide (how to propose a doc, review process)
- Recognition (docs contributions valued as code)

## Phase 8 — Accessibility + localization

### Accessibility

- Plain language + short sentences
- Descriptive link text (not "click here")
- Alt text on images
- Video captions + transcripts
- Semantic headings
- Color-blind-safe palette
- Keyboard-navigable reader

### Localization

- Decide what to localize (tutorials often; deep reference rarely)
- Source of truth in one language; translation pipeline
- In-product language switcher
- Locale-aware examples (dates, currency)

## Phase 9 — Metrics

- Traffic (views per doc / funnel)
- Helpfulness rating (was this useful? yes/no)
- Search logs (zero-result searches = gap)
- Staleness (% docs reviewed in last 90 days)
- Support deflection (tickets about topics docs should cover)
- Contributor counts

Dashboard per audience (owner-level).

## Phase 10 — Legal + compliance docs

Keep these separate from product docs:

- Privacy policy (GDPR-compliant)
- Terms of service
- DPA / data processing addendum
- Cookie policy
- Accessibility statement (legally required in some jurisdictions)
- Regulatory filings

Owner: Legal / DPO. Don't let product docs carry legal weight; cross-reference only.

## Phase 11 — Anti-patterns

| Anti-pattern | Fix |
|---|---|
| One giant "docs" section without audience split | Audience-first IA |
| Docs + code drift | docs-as-code with CI checks |
| "We'll write docs after launch" | Write during; treat as ship-blocker for audiences |
| Stale screenshots | Auto-generate or CI-validate |
| Markdown dumps in Confluence | Move to docs-as-code |
| No owners | Assign per section |
| Internal jargon externally | Plain language |
| Videos without captions | Caption + transcript |

## Phase 12 — Diagrams

### Diátaxis quadrants

```mermaid
quadrantChart
    title Doc type by audience intent
    x-axis "Practical <-> Theoretical"
    y-axis "Study <-> Work"
    "Tutorials": [0.25, 0.75]
    "How-to guides": [0.25, 0.25]
    "Reference": [0.75, 0.25]
    "Explanation": [0.75, 0.75]
```

### Doc lifecycle

```mermaid
stateDiagram-v2
    [*] --> Draft
    Draft --> Review
    Review --> Published
    Published --> Updated
    Updated --> Published
    Published --> Deprecated: aging / superseded
    Deprecated --> Archived
    Archived --> [*]
```

## Phase 13 — Diagram rendering

Per `diagram-rendering` mixin.

## Phase 14 — Report assembly and approval

```markdown
# Documentation Strategy: [Product]

**Date**: [date]
**Product**: [...]
**Version**: v1.0

## Scope
## Audience Map
## Diátaxis Framework Adoption
## Information Architecture
## Living Documentation + Docs-as-Code
## Review + Maintenance
## Contribution Model
## Accessibility + Localization
## Metrics
## Legal + Compliance Docs
## Anti-Patterns to Avoid
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

Present for user approval. Save only after confirmation.

## Assessment + planning rules

- Audience-first
- Diátaxis distinct types
- Ownership + cadence
- Living docs over volume
- Findability > quantity
- Accessibility + localization deliberate
- Metrics track real impact
- No fabricated audiences

## Failure behavior

| Situation | Behavior |
|---|---|
| No audiences | Interview mode (§7) |
| "Write all the docs" | Challenge; narrow to audiences |
| Mixing Diátaxis types | Propose split |
| No owners | Assign |
| Tooling question | Hand off to `documentation-tooling-selection` |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation (writing the docs themselves) | Out of scope — strategy only |

## Self-check

```
[] Audience map with needs + success
[] Diátaxis types identified per doc
[] IA + navigation clear
[] Ownership + review cadence per doc / section
[] Living-docs approach specified
[] Contribution model
[] Accessibility + localization addressed
[] Metrics defined
[] Legal / compliance docs separated
[] Anti-patterns
[] Diagrams valid
[] No fabricated audiences
[] Report follows output contract
```
