# Taxonomy Design — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | taxonomy-design |
| **Version** | 1.0.0 |
| **Purpose** | Designs a taxonomy — controlled vocabulary with defined terms, typed relationships, and usage rules — for content or data classification. Supports four structure types selected per domain fit: hierarchical (single-tree parent-child), flat (small vocab, no hierarchy), faceted (orthogonal dimensions with declared cardinality), polyhierarchical (multiple parents per term where legitimately cross-disciplinary). Per term produces stable ID, preferred label, scope note (what it covers), scope exclusion (what it does NOT cover), broader / narrower / related terms (BT / NT / RT), synonyms as "use-for" (UF) pointing to preferred term, usage rules (where applied, cardinality per content item), examples, status, and version-added. Governance required: owner, change process, deprecation policy, review cadence, semver versioning, consumer notification. Usability validation: findability, coverage (cross-check with content-inventory-audit), balance, depth ≤5, breadth ≤15 children per parent. Mermaid hierarchy tree, facet diagram, and optional term-usage heatmap with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Greenfield content platform or product catalog needing classification
- Tag cleanup (free tags → controlled vocabulary)
- Pre-CMS migration taxonomy redesign
- Faceted search / filter design
- Content model for new editorial system
- Data dictionary preparation (pairs with future data-dictionary-definition)

## When not to use

- Content inventory / audit → `content-inventory-audit`
- Site hierarchy (page structure) → `site-mapping`
- Navigation design → `navigation-modeling`
- Mental model mapping (user-world taxonomy) → `mental-model-diagramming`
- Full ontology with reasoning (OWL, RDF) → semantic-web skills (future)
- Database schema → data modeling skills (Phase 5)

---

## Required input

| Field | Description |
|---|---|
| **Domain** | Content or data scope to classify |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Structure type** | hierarchical / flat / faceted / polyhierarchical | Determined by fit |
| **Existing vocabulary** | Current terms or tags | Elicit |
| **User research** | Card-sort / interviews / search logs | `[Assumed]` if absent |
| **Use cases** | navigation / search / filter / tagging / data | All |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/taxonomy-design/` |

## Input schema

```
input:
  required:
    domain:
      type: string | document_reference
  optional:
    structure_type:
      type: string
      enum: [hierarchical, flat, faceted, polyhierarchical]
    existing_vocabulary: list[string]
    user_research: string | document_reference
    use_cases: list[string]
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
Collect domain + structure preference + grounding.

### Phase 2 — Structure selection
Simplest fit; faceted beats hierarchical for most e-commerce/search.

### Phase 3 — Term definition
Full term spec with scope, exclusions, relationships, examples.

### Phase 4 — Relationship types
BT / NT / RT / UF / USE.

### Phase 5 — Faceted design (if applicable)
Orthogonal facets + cardinality.

### Phase 6 — Governance
Owner + change process + deprecation + versioning.

### Phase 7 — Usability validation
Findability, coverage, balance, depth, breadth.

### Phase 8 — Versioning
Semver + CHANGELOG.

### Phase 9 — Diagrams
Hierarchy tree + facet overview + usage heatmap.

### Phase 10 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 11 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Taxonomy Design: [Domain]

**Date**: [date]
**Domain**: [name]
**Structure**: [type]
**Version**: [version]
**Term count**: [N]

## Scope
[Domain, structure, use cases, grounding]

## Structure
[Chosen + rationale]

## Terms
[Full table]

## Facets (if faceted)
[Facet × values × cardinality]

## Relationships
[Hierarchy + RT]

## Governance
[Owner + process + deprecation + review + versioning]

## Usability Validation
[Findability / coverage / balance / depth / breadth]

## Versioning & CHANGELOG
[Version + migration]

## Diagrams
[Tree + facets + usage]

## Assumptions & Limitations
[`[Assumed user vocabulary]`, research gaps]
```

### Diagrams

- **Hierarchy tree** — Mermaid `flowchart`
- **Facets** — Mermaid `flowchart` (if faceted)
- **Term usage** — Mermaid `xychart-beta` (if data)

---

## Generation and planning policy

- Scope note mandatory per term
- Relationships typed
- Governance declared
- Versioned from day 1
- No fabricated terms
- User vocabulary grounded

---

## Self-check

```
[] Structure declared + rationale
[] Every term defined (scope, exclusions, BT/NT/RT/UF)
[] Usage rules per term
[] Facets orthogonal (if faceted)
[] Governance complete
[] Usability validation done
[] Versioned + CHANGELOG
[] Diagrams valid
[] `[Assumed]` on user-vocab gaps
[] No fabricated terms
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No domain | Interview mode (§7) |
| No user research | `[Assumed]` flag + recommend card-sort |
| Structure mismatch detected | Surface + propose alternative |
| Term overlap | Merge via UF |
| Deep/broad hierarchy | Flag + re-partition |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out-of-scope |

---

## Quality checks

- [ ] Structure fit
- [ ] Per-term completeness
- [ ] Governance
- [ ] Usability validation
- [ ] Versioning
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. E-commerce faceted**
- Input: DTC e-commerce catalog, 1200 products
- Expected: Faceted — Category / Brand / Price / Color / Size / Feature; cardinality 1/1/1/1-2/1/many. Facet order by usage frequency.

**2. Help center hierarchical**
- Input: Support articles for SaaS
- Expected: Hierarchical — Getting started / Core features / Integrations / Billing / Troubleshooting; depth 3; breadth ≤10 per parent.

**3. Content taxonomy with existing tags**
- Input: 400 legacy free tags from blog CMS
- Expected: Tag cleanup → controlled vocab of ~60 terms with UF relationships preserving SEO value of old tags; governance for future tag adds.

**4. Polyhierarchical research catalog**
- Input: University research papers
- Expected: Polyhierarchical — e.g., "computational biology" under both "biology" and "computer science"; max 2 parents; rationale per polyhierarchy.

**5. Product taxonomy migration**
- Input: Moving from flat category tags to faceted
- Expected: Migration map old→new; transition period for both; deprecation plan for flat tags.

### Edge cases

**6. Terms that look alike**
- Input: "Email" vs "Email address" vs "E-mail"
- Expected: One preferred term ("Email address" for the field; "Email" for the communication); UF relationships to prevent drift.

**7. Unbalanced hierarchy**
- Input: "Electronics" has 8 children, one ("Phones") has 400 children
- Expected: Flag Phones as needing intermediate groupings (by OS / size / price band); recommend re-partition.

**8. No user vocabulary evidence**
- Input: Taxonomy designed without user research
- Expected: All terms `[Assumed user vocabulary]`; report flagged as draft; recommend card-sort before publishing.

### Failure cases

**9. No domain**
- Input: "Design a taxonomy"
- Expected: Interview — "Which domain / content scope?"

**10. Implementation request**
- Input: "Design + implement in our CMS"
- Expected: "Design only. CMS implementation is engineering."
