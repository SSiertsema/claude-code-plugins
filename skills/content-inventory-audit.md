# Content Inventory & Audit — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | content-inventory-audit |
| **Version** | 1.0.0 |
| **Purpose** | Inventories and audits existing content for a site or product. Per content item: stable ID, URL, title, type (article / product / landing / help / legal / media / component), status (published / draft / archived / private), last-updated date, author, tags, word count, media count, internal-link counts, optional traffic / engagement / SEO signals if supplied. Rates every item on 5 quality dimensions (accuracy, freshness, completeness, relevance, findability) with 1–5 anchored scales — marks `Cannot assess` when metadata insufficient rather than fabricating ratings. Performs gap analysis against declared user needs / intended topics (uncovered / over-covered / off-need). Assigns a per-item recommended action (keep / update / merge / rewrite / archive / delete / migrate / cannot-assess) with effort estimate (small / medium / large). Prioritizes across quick-wins / strategic / cleanup / parking-lot buckets. Summary dashboard counts by freshness and action. Mermaid freshness distribution, quality-vs-freshness quadrant, and action distribution diagrams with PNG export. Markdown + CSV export. |
| **Primary category** | `extraction` |
| **Secondary category** | `assessment` |
| **Output mode** | `hybrid` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- CMS migration or content-consolidation project
- Content-strategy reset (align inventory to user needs)
- Pre-IA-restructure audit (pairs with `site-mapping` + `taxonomy-design`)
- Freshness sweep / editorial review
- Compliance / legal content audit (retire outdated policies, etc.)

## When not to use

- Content creation / copywriting → content strategy skills (future)
- Site hierarchy → `site-mapping`
- Taxonomy design → `taxonomy-design`
- SEO audit → dedicated SEO skills
- Traffic / analytics analysis → analytics skills

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Site / product |
| **Content source** | CMS export, crawl result, sitemap, manual list |

## Optional input

| Field | Description | Default |
|---|---|---|
| **User needs / topics** | Declared strategic topics | Elicit |
| **Age thresholds** | Fresh / aging / stale cutoffs | 6mo / 18mo |
| **Criteria weights** | Per dimension weights | Equal |
| **Traffic data** | Per-item metrics | None |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/content-inventory-audit/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    content_source:
      type: string | document_reference | list[object]
  optional:
    user_needs: list[string]
    age_thresholds: object
    criteria_weights: object
    traffic_data: object
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path:
      type: string
```

---

## Processing rules

### Phase 1 — Setup
Collect subject + source.

### Phase 2 — Inventory schema
Per item: full metadata table.

### Phase 3 — Quality audit
5 dimensions × 1-5 scale or `Cannot assess`.

### Phase 4 — Gap analysis
User needs vs coverage; uncovered / over-covered / off-need.

### Phase 5 — Recommendation
Keep / update / merge / rewrite / archive / delete / migrate / cannot-assess + effort.

### Phase 6 — Prioritization
Quick wins / strategic / cleanup / parking.

### Phase 7 — Summary dashboard
Counts by freshness + action.

### Phase 8 — Diagrams
Freshness, quality × freshness, action distribution.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Content Inventory & Audit: [Subject]

**Date**: [date]
**Content source**: [source]
**Item count**: [N]

## Scope
[Subject, source, topics, thresholds]

## Inventory
[Full table]

## Quality Audit
[5 dimensions per item]

## Gap Analysis
[Topic coverage + uncovered / over-covered / off-need]

## Recommendations
[Action + effort per item]

## Prioritization
[4 buckets]

## Summary Dashboard
[Counts by freshness + action]

## Diagrams
[Freshness + quality × freshness + action]

## Assumptions & Limitations
[`Cannot assess` items, metadata gaps]
```

### Diagrams

- **Freshness distribution** — Mermaid `pie`
- **Quality vs freshness** — Mermaid `quadrantChart`
- **Action distribution** — Mermaid `pie`

---

## Extraction + assessment policy

- Per-item metadata preserved
- Quality ratings grounded or `Cannot assess`
- No fabricated author / date / traffic
- Every item has recommendation
- Deterministic

---

## Self-check

```
[] Stable IDs
[] Per-item metadata
[] 5 dimensions rated or Cannot assess
[] Gap analysis
[] Recommendation + effort per item
[] 4-bucket prioritization
[] Summary dashboard
[] Diagrams valid
[] No fabricated assessments
[] CSV export
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No source | Interview mode (§7) |
| Insufficient metadata | `Cannot assess` per item |
| >500 items | Offer sampling / category rollup |
| No declared user needs | Infer topics + flag low confidence |
| Rewrite request | Out-of-scope; audit only |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Metadata per item
- [ ] 5 dimensions
- [ ] Cannot-assess labeled honestly
- [ ] Gap analysis
- [ ] Actions + effort
- [ ] Prioritization
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Help center audit**
- Input: CMS export of 280 help articles
- Expected: 140 keep, 80 update (freshness), 25 merge (duplicates), 15 delete (legacy products), 20 `Cannot assess`. Gap: no content for new feature X. Quick wins: 20 articles needing minor refresh.

**2. Marketing site audit**
- Input: Sitemap + CMS pages (45 items)
- Expected: 20 keep, 10 update, 5 rewrite, 3 archive, 7 merge. Gap: no case studies for target verticals. Recommendation: commission 4 case studies.

**3. Legal content**
- Input: Privacy / terms / cookie / accessibility / compliance pages
- Expected: Strong freshness bias (legal must be current); 2 stale items flagged as critical. Cannot-assess on internal-only docs.

**4. E-commerce product catalog**
- Input: 2000 product pages
- Expected: Offer sampling (cluster by category); audit top 10% by traffic first; recommend taxonomy review (link to `taxonomy-design`).

**5. Content migration**
- Input: Old CMS → new CMS migration, 500 pages
- Expected: Migrate 300, leave-behind 100 (archive), consolidate 60 → 20, rewrite 20; CSV export for content-engineering team.

### Edge cases

**6. Partial metadata**
- Input: URLs + titles only, no dates / authors
- Expected: Freshness `Cannot assess`; accuracy / completeness `Cannot assess` without excerpts; recommend richer export.

**7. Content without clear owner**
- Input: Items with no author / owner
- Expected: Flag ownership gap; recommend assigning before audit actions; ownership as precondition for update.

**8. Topics overlap multiple items heavily**
- Input: 10 items all on same topic
- Expected: Merge recommendations clustering; single canonical + redirects from others.

### Failure cases

**9. No source**
- Input: "Audit our content"
- Expected: Interview — "What's the source? CMS export? Sitemap? Manual list?"

**10. Rewrite request**
- Input: "Audit + rewrite everything below a score of 3"
- Expected: "Audit only. Rewriting is content work outside scope."
