---
name: content-inventory-audit
description: Inventory and audit existing content (pages, articles, media, components) for a site or product. Produces structured inventory with metadata, quality audit (accuracy, freshness, completeness, relevance, findability), gap analysis vs user needs, and per-item recommended action (keep / update / merge / delete / migrate).
argument-hint: "[subject / site + content source or list]"
---

# Content Inventory & Audit

You inventory existing content and audit it for quality, freshness, and gaps. Output is a table + per-item recommendation a content team can act on.

## Core rules

- **Work from supplied or exported inventory**: don't fabricate URLs, authors, dates
- **Stable IDs** per content item (`C-001`, …)
- **Multi-dimensional quality**: accuracy + freshness + completeness + relevance + findability — not one "quality score"
- **Gap analysis against declared user needs or taxonomy**
- **Every item has a recommendation**: no "it's fine" without rationale
- **No fabricated content assessments**: if item cannot be evaluated (no excerpt / metadata), flag as `Cannot assess` — don't invent

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Subject** (site / product) | Yes | — |
| **Content source** (CMS export / crawl result / sitemap / manual list) | Yes | — |
| **User needs / intended topics** | No | Elicit |
| **Quality criteria weights** | No | Equal |
| **Age thresholds** | No | Fresh: ≤ 6mo, Aging: 6–18mo, Stale: > 18mo |

## Phase 1 — Setup

```
**Subject**: [name]
**Content source**: [CMS export / crawl / sitemap / supplied list]
**Item count**: [N]
**User needs / topics in scope**: [list]
**Age thresholds**: [fresh / aging / stale cutoffs]
```

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/content-inventory-audit/`).

## Phase 2 — Inventory schema

Per content item:

| Field | Description |
|---|---|
| **ID** | `C-001`, ... stable |
| **URL / path** | Where it lives |
| **Title** | Human title |
| **Type** | article / product / landing / help / legal / media / component / other |
| **Status** | published / draft / archived / private |
| **Last updated** | ISO date |
| **Author / owner** | Role or person |
| **Tags / categories** | Existing taxonomy assignments |
| **Word count** | Text length |
| **Media count** | Images / videos / embeds |
| **Internal links** | Count in + out |
| **Traffic / engagement** (if supplied) | Pageviews, time, bounce |
| **SEO signals** (if supplied) | Meta title, description, H1 present |

## Phase 3 — Quality audit

Per item, rate on 5 dimensions (1–5):

| Dimension | 1 | 3 | 5 |
|---|---|---|---|
| **Accuracy** | Factually wrong / outdated info | Partially correct | Verified accurate |
| **Freshness** | >18 months untouched | 6–18 months | <6 months |
| **Completeness** | Missing major sections / unanswered questions | Covers most | Thorough |
| **Relevance** | Off-strategy / legacy | Tangentially relevant | Core to strategy |
| **Findability** | Orphan / poorly-linked / no SEO signals | Some links / basic SEO | Well-linked + SEO optimized |

Composite = sum (max 25). But: don't reduce to single number — show per-dimension because actions differ.

Rules:
- Don't fabricate ratings — if an item lacks excerpt / metadata, mark `Cannot assess` on affected dimensions
- Freshness is objective (date-based); accuracy/completeness/relevance are judgments and need evidence

## Phase 4 — Gap analysis

Compare inventory to declared user needs / intended topics:

| Topic | Coverage | Items | Gap |
|---|---|---|---|
| [User need 1] | Yes | C-003, C-015 | — |
| [User need 2] | Partial | C-007 | Missing: practical examples |
| [User need 3] | No | — | No content at all |

Surface:
- **Uncovered needs** — content to create
- **Over-covered needs** — consolidate / merge
- **Off-need content** — content not serving any declared need; candidate for archive

## Phase 5 — Recommendations per item

Every item gets one of:

| Action | When |
|---|---|
| **Keep as-is** | High quality across dimensions |
| **Update** | Freshness or completeness weak; content still needed |
| **Merge** | Overlaps with another item (reference merge target) |
| **Rewrite** | Relevant topic, poor execution |
| **Archive** | No longer relevant; keep for history |
| **Delete** | Off-need + low quality + no historical value |
| **Migrate** | Content OK but wrong location / CMS / format |
| **Cannot assess** | Insufficient info — flag for human review |

Add effort: Small / Medium / Large.

## Phase 6 — Prioritization

Rank actions by impact × effort:

- **Quick wins**: High-traffic / user-need-critical item with small update needed
- **Strategic**: Uncovered user-needs requiring new content
- **Cleanup**: Bulk deletions / archives of off-need content
- **Parking lot**: Low-impact items to review later

## Phase 7 — Summary dashboard

| Category | Count |
|---|---|
| Total items | N |
| Fresh (< 6mo) | N |
| Aging (6–18mo) | N |
| Stale (> 18mo) | N |
| Keep | N |
| Update | N |
| Merge | N |
| Rewrite | N |
| Archive | N |
| Delete | N |
| Migrate | N |
| Cannot assess | N |

## Phase 8 — Diagrams

### 1. Freshness distribution

```mermaid
pie title Content age distribution
    "Fresh (< 6mo)" : 45
    "Aging (6-18mo)" : 30
    "Stale (> 18mo)" : 25
```

### 2. Quality vs freshness

```mermaid
quadrantChart
    title Content audit — Quality vs Freshness
    x-axis Low Freshness --> High Freshness
    y-axis Low Quality --> High Quality
    quadrant-1 Update (content good, outdated)
    quadrant-2 Keep as-is
    quadrant-3 Delete / archive
    quadrant-4 Rewrite (fresh but poor)
    [Topic cluster A]: [0.3, 0.8]
    [Topic cluster B]: [0.9, 0.4]
```

### 3. Action distribution

```mermaid
pie title Recommended actions
    "Keep" : 40
    "Update" : 25
    "Merge" : 10
    "Rewrite" : 5
    "Archive" : 10
    "Delete" : 8
    "Cannot assess" : 2
```

## Phase 9 — Diagram rendering

Per `diagram-rendering` mixin. File names:
- `freshness-distribution.mmd` / `.png`
- `quality-vs-freshness.mmd` / `.png`
- `action-distribution.mmd` / `.png`

## Phase 10 — Report assembly and approval

```markdown
# Content Inventory & Audit: [Subject]

**Date**: [date]
**Content source**: [source]
**Item count**: [N]
**Age thresholds**: [fresh / aging / stale]

## Scope
[Subject, source, topics, thresholds, criteria weights]

## Inventory
[Full table per item]

## Quality Audit
[Per item: 5 dimensions + composite + notes]

## Gap Analysis
[Topic coverage + uncovered / over-covered / off-need]

## Recommendations per Item
[Action + effort]

## Prioritization
[Quick wins / Strategic / Cleanup / Parking lot]

## Summary Dashboard
[Counts by freshness + action]

## Diagrams
[Freshness + quality × freshness + action distribution]

## Assumptions & Limitations
[`Cannot assess` items, missing metadata, data gaps]
```

Present for user approval. Save only after confirmation. Markdown + CSV export.

## Extraction + assessment rules

- Per-item metadata preserved from source
- Quality ratings grounded or `Cannot assess`
- No fabricated author / date / traffic
- Every item has recommended action with rationale
- Deterministic on same input

## Failure behavior

| Situation | Behavior |
|---|---|
| No source | Interview mode (§7) |
| Insufficient metadata | Flag per-item `Cannot assess`; recommend richer export |
| User asks to "rewrite now" | "Inventory / audit only; rewriting is content work." |
| Very large inventory (>500 items) | Offer sampling OR category rollup + detail-by-exception |
| No declared user needs | Proceed with topic-extraction inference; flag low-confidence |
| mmdc failure | See `diagram-rendering` mixin |

## Self-check

```
[] Stable IDs
[] Per-item metadata captured
[] 5 quality dimensions rated or `Cannot assess`
[] Gap analysis covers declared user needs
[] Every item has recommendation + effort
[] Prioritization with 4 buckets
[] Summary dashboard by freshness + action
[] Diagrams valid
[] No fabricated content assessments
[] Markdown + CSV export
[] Report follows output contract
```
