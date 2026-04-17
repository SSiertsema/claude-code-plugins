---
name: mind-mapping
description: Generate a hierarchical mind map around a central topic with 5-8 main branches and configurable depth. Operates in autonomous mode (from a topic), transformation mode (from notes/transcript), or expansion mode (extend a partial map). Produces Mermaid mindmap diagrams with optional PNG export, a synced nested outline, and a keyword index per main branch.
argument-hint: "[central topic or source file path]"
---

# Mind Mapping

You produce a hierarchical mind map around a central topic. The output is a Mermaid `mindmap` diagram paired with a nested-bullet outline and a per-branch keyword index. You operate in three modes:

- `autonomous` — generate the map from a topic alone
- `transformation` — restructure source material (notes, transcript, document) into a map
- `expansion` — extend a user-supplied partial map

## Core rules

- **Keywords, not sentences** — every node is ≤7 words
- **Hierarchical clarity** — child nodes logically belong under their parent
- **No duplication** — the same keyword must not appear on multiple branches
- **Breadth before depth** — finish level 1 (5–8 main branches) before expanding
- **Label illustrative content** — `[Example]` or `[Assumed]`
- **No fabricated facts** — no invented statistics, quotes, sources, or named products

## Input handling

Follow shared foundation §7 — interview mode. Gather at minimum:

| Dimension | Required | Default |
|---|---|---|
| **Central topic** | Yes | — |
| **Mode** (autonomous / transformation / expansion) | No | `autonomous` |
| **Style** (classic / concept-map / tree) | No | `classic` |
| **Max depth** (2–5) | No | 3 |
| **Target main branches** | No | 5–8 |
| **Focus dimensions** | No | Inferred from topic |
| **Source material** (transformation mode) | Only in transformation mode | — |
| **Partial map** (expansion mode) | Only in expansion mode | — |

**Exit interview when**: central topic is clear (plus source or partial map if those modes).

## Phase 1 — Setup

### 1. Collect input

Accept:
- A central topic (string, HMW question, concept name, business case reference)
- A source file/document (transformation mode)
- A partial map or outline (expansion mode)
- No / vague input → interview mode (§7)

### 2. Detect scope

- **Central topic**
- **Mode**
- **Style**: `classic` (radial hierarchy), `concept-map` (hierarchy + cross-links), `tree` (strict hierarchy, no cross-links)
- **Max depth** (default 3)
- **Target main branches** (default 5–8)
- **Focus dimensions** — either user-supplied or inferred. Examples:
  - Product topic → user, features, tech, market, risks, metrics
  - Strategy topic → vision, market, capabilities, execution, financials, risks
  - Learning topic → core concepts, subtopics, examples, applications, prerequisites

### 3. Confirm scope

Present:

```
**Central topic**: [topic]
**Mode**: [autonomous / transformation / expansion]
**Style**: [classic / concept-map / tree]
**Max depth**: [N]
**Target main branches**: [N]
**Focus dimensions**: [list]
```

Ask for confirmation or adjustments. Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/mind-mapping/`).

## Phase 2 — Level 1: main branches

Produce 5–8 main branches. Rules:
- Mutually exclusive, collectively exhaustive (MECE) where possible
- Each is a short noun or noun phrase (≤5 words)
- No overlap between branches
- If you cannot find 5 distinctly differentiated branches, produce 3–4 with an explicit note

For the three modes:

- **Autonomous**: derive branches from the topic and focus dimensions
- **Transformation**: derive branches from the dominant themes in the source; every branch must be traceable to source content
- **Expansion**: keep all existing branches; add new ones only if gaps are evident

## Phase 3 — Expansion

Expand each branch to `max_depth`. Rules:
- Each sub-node is a keyword or short phrase (≤7 words)
- Sub-nodes must logically belong under the parent
- Stop expanding a branch when it reaches the depth limit OR no further meaningful decomposition exists
- Do not pad with filler to reach uniform depth — branches may have different depths

For **transformation mode**: every sub-node must reference its origin in the source (section heading, paragraph, timestamp). Keep the reference internal; it does not appear in the diagram but appears in the keyword index.

## Phase 4 — Dedup and normalization

- Remove duplicate keywords across branches
- If a concept fits two branches, place it under the more specific one and note the connection in the keyword index (or as a cross-link if style = `concept-map`)
- Normalize phrasing: consistent tense, consistent noun vs verb form within a level

## Phase 5 — Cross-links (concept-map style only)

If `style = concept-map`, identify non-hierarchical relationships between nodes on different branches. For each cross-link:
- **From node**, **to node**, **relationship label** (1–3 words, e.g., "enables", "conflicts with", "depends on")
- Maximum 10 cross-links — more creates visual noise

Cross-links render in a secondary Mermaid `flowchart` diagram (Mermaid's native `mindmap` syntax does not support cross-links).

Skip this phase for `classic` and `tree` styles.

## Phase 6 — Keyword index

For each main branch, produce:
- **Branch name**
- **Direct sub-nodes** (level 2)
- **All keywords** in the branch (flattened list)
- **Source references** (transformation mode only)

## Phase 7 — Diagrams

### 1. Primary — Mermaid mindmap

```mermaid
mindmap
  root(("[Central Topic]"))
    ("Branch 1")
      ("Sub 1.1")
        ("Sub 1.1.1")
      ("Sub 1.2")
    ("Branch 2")
      ("Sub 2.1")
```

Rules:
- Use `root((...))` for the center
- Use parentheses `(...)` for soft/rounded shape on nodes (Mermaid mindmap default)
- Indentation defines hierarchy — 2 spaces per level
- Keep node text concise; long text breaks rendering

### 2. Secondary — concept-map cross-links (concept-map style only)

```mermaid
flowchart LR
    A["Node A"]
    B["Node B"]
    A -- "enables" --> B
```

Include only cross-links, not the full hierarchy (that's in diagram 1).

## Phase 8 — Diagram rendering

Render per the `diagram-rendering` mixin.

File naming:
- `mind-map.mmd` / `.png` (always)
- `concept-cross-links.mmd` / `.png` (concept-map style only)

## Phase 9 — Outline generation

Produce a nested-bullet outline that exactly mirrors the diagram:

```markdown
- **[Central Topic]**
  - Branch 1
    - Sub 1.1
      - Sub 1.1.1
    - Sub 1.2
  - Branch 2
    - Sub 2.1
```

Outline and diagram must stay in sync — same nodes, same hierarchy, same labels.

## Phase 10 — Report assembly and approval

Assemble:

```markdown
# Mind Map: [Central Topic]

**Date**: [date]
**Mode**: [autonomous / transformation / expansion]
**Style**: [classic / concept-map / tree]
**Main branches**: [N]
**Max depth**: [N]
**Total nodes**: [N]

## Framing
[1–2 sentences on the topic and focus dimensions]

## Mind Map
[Primary Mermaid mindmap diagram]

## Concept Cross-links
[Only if style = concept-map — secondary flowchart diagram]

## Outline
[Nested-bullet outline matching the diagram]

## Keyword Index
[Per main branch: name, direct sub-nodes, flattened keyword list, source references if applicable]

## Assumptions & Limitations
- Mind map structures the topic; it does not validate or evaluate
- [Any `[Assumed]` items]
- Transformation mode: coverage of source material (%) / any sections omitted
```

Present for user approval. Save only after explicit confirmation.

## Generation rules

- **May invent**: branch names, sub-node keywords, cross-link relationship labels, illustrative sub-nodes (labeled `[Example]`)
- **Must be grounded**: central topic always; source material in transformation mode; existing nodes in expansion mode
- **Assumptions allowed**: domain/framing assumptions — label `[Assumed]`
- **Never fabricate**: statistics, quotes, citations, product names, person names as sources
- **Creativity level**: `medium`

## Failure behavior

| Situation | Behavior |
|---|---|
| No central topic | Interview mode (§7) |
| Topic too vague | Interview — ask for domain, audience, purpose |
| Transformation mode, no source material | Ask for the source |
| Expansion mode, no partial map | Ask for the existing map/outline |
| Source material too long (>10k words) | Summarize to main themes, flag sections omitted |
| Cannot find 5 distinct main branches | Produce 3–4 with explicit rationale |
| Branches overlap significantly | Merge overlapping branches, report the merge |
| Max depth cannot be reached meaningfully | Stop early per branch, do not pad |
| Mermaid `mindmap` rendering fails | See `diagram-rendering` mixin |
| Out-of-scope request (e.g., "evaluate these branches") | "This skill structures a topic as a mind map. Evaluation is outside scope." |

## Self-check

```
[] Central topic clearly stated
[] 5–8 main branches (or 3–4 with rationale)
[] Main branches are mutually exclusive
[] Max depth ≤ 5, default 3, respected
[] Every node is a keyword or short phrase (≤7 words)
[] No duplicate keywords across branches
[] Outline matches diagram exactly (same nodes, same hierarchy)
[] Keyword index covers every branch
[] Cross-links only if style = concept-map (max 10)
[] Transformation mode: every node traceable to source
[] Expansion mode: all existing nodes preserved
[] Mermaid mindmap renders valid syntax (per diagram-rendering mixin)
[] Illustrative content labeled `[Example]` or `[Assumed]`
[] No fabricated statistics, quotes, sources, or product names
[] Report follows output contract
```
