# Affinity Diagramming — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | affinity-diagramming |
| **Version** | 1.0.0 |
| **Purpose** | Performs bottom-up thematic clustering of an unstructured set of items (research notes, interview quotes, brainstorm ideas, feedback, observations) using the KJ method. Themes are emergent from the items, not imposed. Normalizes items (dedup, split, rewrite) while preserving originals, clusters into 3–10 named groups with rationale and member IDs, optionally aggregates into meta-themes when >10 clusters, identifies patterns/tensions/gaps with evidence references, flags outliers, and prioritizes clusters on frequency, source spread, and specificity. Produces a Mermaid affinity diagram and an optional priority matrix with optional PNG export. Works on user-supplied items only — never generates new items. |
| **Primary category** | `extraction` |
| **Secondary category** | `classification` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- User has a set of raw items and wants to discover emergent themes
- Research synthesis after interviews, observations, or diary studies
- Structuring large brainstorm outputs (follow-up to `brainstorming`)
- Retrospective feedback or open-text survey answers
- Finding patterns in support tickets, user feedback, reviews
- Any situation where themes must emerge bottom-up rather than be imposed top-down

## When not to use

- Idea generation from scratch → `brainstorming`
- Hierarchical decomposition of a single topic → `mind-mapping`
- Classification with predefined labels → future tagging/classification skill
- Quantitative data analysis → future data-analysis skill
- Conducting the user research itself (interviews, observations) → Phase 2/3 user research skills
- Quantitative survey analysis (closed questions) → `survey-design`

---

## Required input

| Field | Description |
|---|---|
| **Items** | List of ≥10 text items (strings, quotes, notes, observations, ideas) |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Domain context** | Project, product, or research topic | Inferred |
| **Clustering hint** | Dimension to emphasize (e.g., "by pain point", "by journey stage") | None (fully emergent) |
| **Target cluster count** | User-specified 3–10 | Emergent |
| **Meta-theme threshold** | Cluster count above which meta-themes are produced | 10 |
| **Item metadata** | Source, timestamp, participant per item | Preserved if supplied |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/affinity-diagramming/` |

## Input schema

```
input:
  required:
    items:
      type: list[string] | document_reference
      min: 10
      description: "Text items to cluster"
  optional:
    domain_context:
      type: string
    clustering_hint:
      type: string
      description: "Dimension to emphasize (soft constraint)"
    target_cluster_count:
      type: integer
      min: 3
      max: 10
    meta_theme_threshold:
      type: integer
      default: 10
    item_metadata:
      type: list[object]
      description: "Parallel list with fields source, timestamp, participant"
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

1. Collect items; interview mode (§7) if fewer than 10
2. Detect domain, clustering hint, target count
3. Confirm scope
4. Ask render mode (per `diagram-rendering` mixin) and output path

### Phase 2 — Item normalization

1. Assign IDs (`I-01`, `I-02`, …)
2. Deduplicate near-identical items (retain originals in `merged_from`)
3. Split compound items (`I-12a`, `I-12b`); preserve in `split_from`
4. Rewrite unclear items to ≤20 words; preserve in `original_text`
5. Preserve metadata (source, timestamp, participant) if supplied
6. Never delete — mark status as `original`, `merged`, `split`, or `rewritten`

### Phase 3 — Initial clustering

- Group by semantic similarity
- 3–10 clusters emergent (or honor user-specified target)
- Honor clustering hint as soft constraint where items support it
- Items that don't fit go to candidate-outliers

### Phase 4 — Cluster labeling

Per cluster: name (3–6 words, descriptive, distinct), 1-sentence rationale, item count, member IDs, 2–3 sample items.

Label test: if two names are interchangeable, merge the clusters.

### Phase 5 — Outliers

- Keep items that don't fit any cluster as outliers (max 10% of total)
- If outliers exceed 10%, revisit clustering
- Per outlier: ID, text, reason

### Phase 6 — Meta-clustering (conditional)

If cluster count > meta-theme threshold (default 10):
- Group clusters into 3–5 meta-themes
- Each meta-theme: name, member clusters, rationale
- Skip if threshold not met

### Phase 7 — Pattern identification

3–7 insights. Each: statement, evidence (≥2 item IDs), confidence (`high`/`medium`/`low`), type (`pattern` / `tension` / `gap`).

### Phase 8 — Prioritization

Score each cluster on Frequency, Source spread, Specificity (1–5 each). Composite max 15.
- High (≥11): act / investigate
- Medium (7–10): monitor
- Low (≤6): note

Recommend a next action per high-priority cluster.

### Phase 9 — Diagrams

1. **Affinity diagram** — Mermaid `flowchart`: domain → (meta-themes →) clusters → sample items (top 2 per cluster)
2. **Priority matrix** — Mermaid `quadrantChart` (frequency vs source spread), if prioritization performed

### Phase 10 — Diagram rendering

Per `diagram-rendering` mixin. File names:
- `affinity-diagram.mmd` / `.png`
- `cluster-priority.mmd` / `.png` (if prioritization)

### Phase 11 — Report assembly and approval

Full report; present for approval; save only after confirmation.

---

## Output contract

### Report structure

```markdown
# Affinity Diagram: [Domain]

**Date**: [date]
**Items provided**: [N]
**Items after normalization**: [N]
**Clusters identified**: [N]
**Meta-themes**: [N or "none"]
**Outliers**: [N]

## Input Summary
[Count, sources, normalization stats, clustering hint]

## Affinity Diagram
[Primary Mermaid flowchart]

## Clusters
[Per cluster: name, rationale, item count, member IDs, 2–3 sample items]

## Meta-themes
[Only if > threshold]

## Patterns & Insights
[3–7 insights: statement, evidence IDs, confidence, type]

## Outliers
[List with ID, item text, reason]

## Prioritization
[Ranking table + priority matrix diagram + next action per high-priority cluster]

## Item Log
[Full table: ID, normalized item, cluster, source reference, status]

## Assumptions & Limitations
[Explicit list]
```

### Diagrams

- **Affinity diagram** — Mermaid `flowchart`
- **Priority matrix** — Mermaid `quadrantChart` (optional, when prioritization done)

In `code` mode: Mermaid code blocks. In `image` mode: PNG via `mmdc` per `diagram-rendering` mixin.

---

## Evidence and extraction policy

- **Evidence**: every cluster, insight, and outlier cites item IDs
- **Source traceability**: every normalized item retains pointer to original text and supplied metadata
- **Confidence**: insights include `high` / `medium` / `low` based on item count and source spread
- **Uncertain memberships**: items that plausibly fit two clusters go to one, with alternative noted in item log
- **No fabrication**: never add items, quotes, or sources not in the input

---

## Self-check

```
[] ≥10 items provided (or honest failure reported)
[] Every item has unique ID
[] Normalization stats reported
[] 3–10 clusters (or honest deviation explained)
[] No "Other" / "Misc" / generic labels
[] Every cluster: name + rationale + members + samples
[] Every cluster ≥2 items (solo → outliers)
[] Meta-themes only if > threshold
[] 3–7 insights with item-ID evidence
[] Insights include pattern / tension / gap where present
[] Outliers listed with reasons (≤10% of total)
[] Prioritization scoring consistent across clusters
[] Priority matrix accompanies ranking
[] Full item log traceable to source
[] No fabricated items or sources
[] All Mermaid diagrams render valid syntax
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| Fewer than 10 items | Interview — ask for more items, or reject ("need ≥10 items for meaningful clustering") |
| Items too homogeneous | Force 2 clusters with honest note, or report no meaningful differentiation |
| Items too diverse (each its own cluster) | Raise abstraction level, re-cluster; report as "high dispersion" pattern |
| Clustering hint incompatible with items | Honor hint, place mismatches as outliers, flag mismatch rate |
| Clustering hint ambiguous | Ask for clarification |
| User-specified target forces bad fits | Honor target, note forced merges/splits |
| mmdc render failure | See `diagram-rendering` mixin |
| User asks to generate new items | "This skill organizes items you provide. For generating new ideas, see `brainstorming`." |

---

## Quality checks

- [ ] ≥10 items
- [ ] Unique IDs assigned
- [ ] Normalization preserved originals
- [ ] 3–10 clusters with distinct names
- [ ] Each cluster has ≥2 items
- [ ] Rationale present per cluster
- [ ] Meta-themes only when threshold exceeded
- [ ] Insights cite ≥2 item IDs with confidence
- [ ] Outliers listed with reasons
- [ ] Prioritization uses Frequency / Source spread / Specificity
- [ ] Next action stated per high-priority cluster
- [ ] Full item log traceable
- [ ] No fabricated items or sources
- [ ] Diagrams render valid Mermaid

---

## Examples

### Normal cases

**1. Research synthesis from interviews**
- Input: 42 quotes from 8 interviews about onboarding pain points
- Expected: 6 clusters (e.g., "Confusing first screen", "Unclear value prop", "Too much upfront input", "Missing guidance", "Account-creation friction", "Email verification delays"), rationale per cluster, 5 insights (including 1 tension: some want guidance, others want autonomy), 3 outliers, prioritization highlighting "Unclear value prop" as high priority across 7 of 8 interviews.

**2. Brainstorm follow-up**
- Input: 50 ideas from a brainstorming session for reducing churn
- Expected: 7 clusters on solution direction (proactive success, pricing optionality, value reinforcement, community, exit friction, reactivation, product-led), meta-theme not triggered (threshold 10), 4 insights (including 1 gap: no ideas address reactivation), prioritization by signal strength across brainstorm techniques.

**3. Open-text survey**
- Input: 120 open-text answers to "What would you improve?"
- Expected: 9 clusters, meta-themes not triggered, 6 insights (pattern: performance mentions strongest; tension: some want more features, others want simpler UI; gap: nobody mentions accessibility), outliers ≤10%.

**4. Retro feedback**
- Input: 28 sticky-note items from a team retro
- Expected: 5 clusters (e.g., "Planning accuracy", "PR review bottleneck", "Cross-team handoffs", "Team cohesion", "Tooling gaps"), 3 insights, prioritization surfacing PR review as highest signal (mentioned by 6 of 8 team members).

**5. With clustering hint**
- Input: 35 user feedback items + hint "cluster by journey stage"
- Expected: Clusters align with journey stages (Awareness, Signup, First use, Regular use, Exit); items that don't fit journey stages go to outliers (e.g., general brand feedback). Hint honored with mismatch rate reported.

### Edge cases

**6. Very homogeneous input**
- Input: 15 items all about slow page load
- Expected: Report that no meaningful differentiation exists; produce 2 clusters (e.g., "Perceived slowness on specific pages" vs "General performance concerns") with honest note, or produce single cluster with rationale.

**7. Very high-dispersion input**
- Input: 30 items each on a different topic
- Expected: Raise abstraction level (e.g., cluster by category: UX / technical / business / content / support); report "high dispersion — recommend more items or narrower scope"; confidence on insights = low.

**8. Cluster-count mismatch with user target**
- Input: 60 items, user requests 4 clusters
- Expected: Honor 4 clusters, note that natural emergence suggested 7; flag forced merges explicitly; insights account for within-cluster heterogeneity.

### Failure cases

**9. Too few items**
- Input: 6 items
- Expected: Interview or reject — "Affinity diagramming needs ≥10 items for meaningful clustering. 6 items provided. Add more items, or use another analysis method."

**10. Out of scope**
- Input: "Generate 30 new ideas and then cluster them"
- Expected: "This skill organizes items you provide. For generating new ideas, see `brainstorming`. After that, pipe the output here for clustering."
