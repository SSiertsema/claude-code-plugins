# Mind Mapping — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | mind-mapping |
| **Version** | 1.0.0 |
| **Purpose** | Produces a hierarchical mind map around a central topic with 5–8 main branches and configurable depth (default 3, max 5). Operates in three modes: `autonomous` (generate from a topic), `transformation` (restructure source notes/transcript/document into a map), or `expansion` (extend a partial map). Supports three styles: `classic` (radial hierarchy), `concept-map` (hierarchy + cross-links), `tree` (strict hierarchy). Outputs a Mermaid `mindmap` diagram (primary), a synced nested-bullet outline, a per-branch keyword index, and — in concept-map style — a secondary `flowchart` diagram for cross-links. Optional PNG export via `mmdc`. |
| **Primary category** | `generation` |
| **Secondary category** | `transformation` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `medium` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- User wants to hierarchically explore or decompose a central topic
- User wants to convert raw notes, a transcript, or a document into a structured mind map
- User has a partial map/outline and wants it extended
- User wants a study, meeting, or concept summary in mind-map form
- Upstream of brainstorming or concept development — mind-mapping scopes the space first

## When not to use

- Idea generation against a problem → `brainstorming`
- Cause-effect analysis → future fishbone / root-cause skill
- Affinity clustering of existing ideas → `affinity-diagramming` (future)
- Site map / IA tree for a product → `site-mapping` (Phase 4)
- Detailed process decomposition → `business-process-modeling` (Phase 3)
- Evaluation, scoring, or validation of nodes — out of scope

---

## Required input

| Field | Description |
|---|---|
| **Central topic** | The topic, concept, or HMW question to map |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Mode** | `autonomous` / `transformation` / `expansion` | `autonomous` |
| **Style** | `classic` / `concept-map` / `tree` | `classic` |
| **Max depth** | Integer 2–5 | 3 |
| **Target main branches** | Integer 3–10 | 5–8 |
| **Focus dimensions** | Angles to cover (e.g., user, tech, market, risk) | Inferred from topic |
| **Source material** | Notes, transcript, or document (transformation mode) | — |
| **Partial map** | Existing map or outline (expansion mode) | — |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/mind-mapping/` |

## Input schema

```
input:
  required:
    central_topic:
      type: string | document_reference
  optional:
    mode:
      type: string
      enum: [autonomous, transformation, expansion]
      default: autonomous
    style:
      type: string
      enum: [classic, concept-map, tree]
      default: classic
    max_depth:
      type: integer
      min: 2
      max: 5
      default: 3
    target_main_branches:
      type: integer
      min: 3
      max: 10
      default: 7
    focus_dimensions:
      type: list[string]
    source_material:
      type: string | document_reference
      description: "Required if mode = transformation"
    partial_map:
      type: string | outline
      description: "Required if mode = expansion"
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

1. Collect central topic; enter interview mode (§7) if missing or vague
2. Detect mode, style, depth, breadth, focus dimensions
3. Confirm scope with user
4. Ask render mode (per `diagram-rendering` mixin) and output path

### Phase 2 — Level 1: main branches

- Produce 5–8 main branches; short noun phrases (≤5 words); mutually exclusive
- Autonomous mode: derive from topic + focus dimensions
- Transformation mode: derive from dominant themes in source; every branch traceable to source
- Expansion mode: preserve all existing branches; add new ones only for evident gaps
- If fewer than 5 distinct branches: produce 3–4 with explicit rationale

### Phase 3 — Expansion

- Expand each branch to `max_depth`
- Every sub-node is ≤7 words
- Sub-nodes must logically belong under their parent
- Branches may have different final depths — do not pad to uniform depth
- Transformation mode: every sub-node references source origin (kept in keyword index)

### Phase 4 — Dedup and normalization

- Remove duplicates across branches
- For concepts fitting two branches: place under more specific, note connection
- Normalize phrasing within a level (consistent noun/verb form, tense)

### Phase 5 — Cross-links (concept-map style only)

- Identify non-hierarchical relationships
- Max 10 cross-links
- Each: from node, to node, 1–3 word relationship label
- Skip for `classic` and `tree`

### Phase 6 — Keyword index

Per main branch: name, direct sub-nodes, flattened keyword list, source references (transformation mode).

### Phase 7 — Diagrams

1. **Primary**: Mermaid `mindmap` of the full hierarchy
2. **Secondary** (concept-map only): Mermaid `flowchart` of cross-links

### Phase 8 — Diagram rendering

Per `diagram-rendering` mixin. File names:
- `mind-map.mmd` / `.png`
- `concept-cross-links.mmd` / `.png` (concept-map only)

### Phase 9 — Outline generation

Nested-bullet outline that exactly mirrors the diagram hierarchy — same nodes, same labels, same order.

### Phase 10 — Report assembly and approval

Full report, present for user approval. Save only after confirmation.

---

## Output contract

### Report structure

```markdown
# Mind Map: [Central Topic]

**Date**: [date]
**Mode**: [autonomous / transformation / expansion]
**Style**: [classic / concept-map / tree]
**Main branches**: [N]
**Max depth**: [N]
**Total nodes**: [N]

## Framing
[Topic + focus dimensions]

## Mind Map
[Primary Mermaid mindmap diagram]

## Concept Cross-links
[Only if style = concept-map — secondary flowchart]

## Outline
[Nested-bullet outline matching diagram]

## Keyword Index
[Per main branch: name, direct sub-nodes, flattened keyword list, source references if applicable]

## Assumptions & Limitations
[Explicit list — transformation coverage %, any sections omitted, [Assumed] items]
```

### Diagrams

1. **Mind map** — Mermaid `mindmap` syntax, `root((...))` at center, nested parentheses for nodes
2. **Concept cross-links** — Mermaid `flowchart` (concept-map style only)

In `code` mode: Mermaid code blocks. In `image` mode: PNG via `mmdc` per `diagram-rendering` mixin.

---

## Generation policy

| Aspect | Declaration |
|---|---|
| **What may be invented** | Branch names, sub-node keywords, cross-link relationship labels, illustrative sub-nodes labeled `[Example]` |
| **What must be grounded** | Central topic always; source material in transformation mode; existing nodes in expansion mode |
| **What assumptions are allowed** | Domain/framing assumptions labeled `[Assumed]` |
| **What must never be fabricated** | Statistics, quotes, citations, product names, person names presented as sources |

---

## Self-check

```
[] Central topic clearly stated
[] 5–8 main branches (or 3–4 with rationale)
[] Main branches mutually exclusive
[] Max depth ≤ 5, default 3
[] Every node ≤7 words
[] No duplicate keywords across branches
[] Outline matches diagram exactly
[] Keyword index covers every branch
[] Cross-links only in concept-map style (max 10)
[] Transformation mode: every node traceable to source
[] Expansion mode: all existing nodes preserved
[] Mermaid mindmap renders valid syntax (per diagram-rendering mixin)
[] Illustrative content labeled `[Example]` or `[Assumed]`
[] No fabricated statistics, quotes, sources, or product names
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No central topic | Interview mode (§7) |
| Topic too vague | Interview — domain, audience, purpose |
| Transformation mode, no source | Ask for source material |
| Expansion mode, no partial map | Ask for existing map/outline |
| Source material too long (>10k words) | Summarize to main themes, flag sections omitted |
| Cannot find 5 distinct main branches | 3–4 with explicit rationale |
| Branches overlap significantly | Merge, report the merge |
| Max depth not meaningfully reachable | Stop early per branch, no padding |
| mmdc rendering fails | See `diagram-rendering` mixin |
| Out-of-scope request | "This skill structures a topic as a mind map. [Request] is outside scope." |

---

## Quality checks

- [ ] 5–8 main branches (or 3–4 with rationale)
- [ ] Main branches MECE
- [ ] Max depth ≤ 5
- [ ] Every node ≤7 words
- [ ] No cross-branch duplicates
- [ ] Outline in sync with diagram
- [ ] Keyword index per branch
- [ ] Cross-links max 10 (concept-map only)
- [ ] Source references captured (transformation mode)
- [ ] All diagrams render valid Mermaid
- [ ] No fabricated data
- [ ] Illustrative content labeled

---

## Examples

### Normal cases

**1. Autonomous, classic style — strategy topic**
- Input: "Sustainable packaging transition for our CPG brand"
- Expected: 6 main branches (e.g., Materials, Supply chain, Regulation, Consumer perception, Cost, Metrics), depth 3, ~40 total nodes, clean radial mindmap, matching outline, keyword index.

**2. Autonomous, classic — product topic**
- Input: "Developer onboarding for our open-source SDK"
- Expected: 5 main branches (e.g., Install, First API call, Docs, Examples, Community), depth 3, illustrative sub-nodes labeled `[Example]`, outline synced.

**3. Transformation — meeting notes**
- Input: 3 pages of stakeholder interview notes on procurement pain points
- Expected: 5–7 branches derived from themes in the notes (e.g., Vendor selection, Contract management, Invoice processing, Compliance, System integration), each sub-node referenced to the source paragraph. Coverage % reported.

**4. Expansion — partial map**
- Input: Existing 3-branch outline on "AI governance" (Ethics, Legal, Technical); expand to 6 branches and depth 3
- Expected: All 3 original branches preserved, 3 new branches added (e.g., Organizational, Stakeholder, Operations), full depth-3 expansion, original nodes untouched.

**5. Concept-map style**
- Input: "Knowledge management at a consulting firm", style = concept-map
- Expected: Hierarchy plus 6–8 cross-links (e.g., "Communities of practice" — enables — "Tacit knowledge capture"), rendered as secondary flowchart diagram.

### Edge cases

**6. Very narrow topic**
- Input: "Our quarterly team offsite agenda"
- Expected: 4 main branches (e.g., Logistics, Sessions, Social, Outcomes) with shallow depth (2), explicit rationale for fewer-than-5 branches.

**7. Extremely broad topic**
- Input: "The future of work"
- Expected: Scope-confirmation step before generation — model asks which angle/domain. Proceeds with narrowed scope labeled `[Assumed]`.

**8. Overlapping branches detected**
- Input: Autonomous generation produces branches "User experience" and "Customer satisfaction" with high overlap
- Expected: Merge into "User experience & satisfaction"; merge noted; total branches reduced accordingly.

### Failure cases

**9. No topic**
- Input: "Make me a mind map"
- Expected: Interview mode — "What is the central topic?"

**10. Out of scope**
- Input: "Map these ideas and score which ones are best"
- Expected: "This skill structures a topic as a mind map. Scoring and evaluation are outside scope — see `brainstorming` or `prioritization` for that. I can proceed with the mind map portion."
