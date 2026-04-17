# Dependency Mapping — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | dependency-mapping |
| **Version** | 1.0.0 |
| **Purpose** | Identifies and visualizes dependencies between nodes (components, teams, deliverables, systems, or tasks) for a subject. Every edge carries direction and type (`hard-blocking`, `soft-blocking`, `enabling`, `data`) plus confidence. Runs cycle detection (with classification: real cycle vs modeling error vs scope issue), computes in/out-degree to surface hubs/bottlenecks/sources/sinks, identifies single points of failure with blast radius and mitigation options, and — if durations are supplied — computes critical path, near-critical nodes, and buffer recommendations. Produces a primary Mermaid flowchart with critical path + SPOFs highlighted, an optional Gantt view for critical path, and an optional node-degree quadrant with optional PNG export. |
| **Primary category** | `extraction` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Planning a project or release and needing to surface blocking dependencies
- Mapping system architecture dependencies (upstream/downstream services)
- Identifying cross-team hand-offs in a deliverable plan
- Detecting single points of failure in a process or system
- Computing critical path from task + duration inputs
- Surfacing cycles in a mental model of how something works

## When not to use

- Full project scheduling / WBS → future `wbs-creation` skill
- Work breakdown decomposition → future planning skills
- Architectural deep-dive (system decomposition) → future `c4-modeling` skill (Phase 5)
- Stakeholder dependency → `stakeholder-mapping`
- Risk assessment in isolation → future risk skills
- Team / RACI mapping → `raci-matrix`

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Project, system, release, or process being mapped |
| **Nodes** | ≥5 named components / teams / deliverables / systems / tasks |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Known dependencies** | Explicit edges with direction and type | Inferred + `[Assumed]` |
| **Node type** | component / team / deliverable / system / task | `deliverable` |
| **Durations per node** | Required for critical path | None |
| **Granularity** | Level of decomposition | Match subject level |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/dependency-mapping/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    nodes:
      type: list[object]
      min: 5
      properties:
        name: string
        type: string
        owner: string
        duration: string (optional)
  optional:
    dependencies:
      type: list[object]
      properties:
        from: node_id
        to: node_id
        type: string
          enum: [hard-blocking, soft-blocking, enabling, data]
        confidence: string
    node_type:
      type: string
      enum: [component, team, deliverable, system, task]
      default: deliverable
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

1. Collect subject and nodes; interview mode (§7) if <5 nodes
2. Detect node type, durations availability
3. Confirm scope
4. Ask render mode and output path

### Phase 2 — Node normalization

IDs, deduplication, noun naming, metadata preservation.

### Phase 3 — Dependency elicitation

Per node: upstream, downstream, per-edge type and confidence. Label inferences `[Assumed]`.

### Phase 4 — Cycle detection

Run cycle check. Per cycle: classify (real / modeling error / scope issue), recommend resolution.

### Phase 5 — Degree analysis

In-degree, out-degree. Surface hubs, sources, sinks.

### Phase 6 — Critical path (conditional)

If durations supplied for enough nodes: topological sort → forward/backward pass → slack per node → critical path. Near-critical: slack ≤ 20% of project duration.

### Phase 7 — SPOFs

Node failure blocks ≥3 downstream nodes via hard-blocking edges. Per SPOF: blast radius, risk type, mitigation.

### Phase 8 — Diagrams

1. Dependency graph (flowchart) — critical path and SPOFs highlighted
2. Gantt (conditional on durations)
3. Node-degree quadrant (optional)

### Phase 9 — Diagram rendering

Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval

Full report; present for approval; save only after confirmation.

---

## Output contract

### Report structure

```markdown
# Dependency Mapping: [Subject]

**Date**: [date]
**Node type**: [type]
**Nodes**: [N]
**Dependencies**: [M]
**Durations supplied**: [yes / no]

## Scope
[Subject + node type + granularity]

## Nodes
[Table: ID, name, owner, duration, metadata, status]

## Dependency Graph
[Primary diagram]

## Dependencies
[Table: from → to, type, confidence, rationale / `[Assumed]`]

## Cycles
[Per cycle: nodes, classification, resolution]

## Bottlenecks & Sources / Sinks
[Hubs, sources, sinks, degree analysis]

## Critical Path
[If durations: nodes, total duration, near-critical, buffer recommendations]
[Gantt diagram]

## Single Points of Failure
[Per SPOF: node, blast radius, risk type, mitigation]

## Evidence & Assumptions
[`[Assumed]` edges and durations with rationale]

## Limitations
[What's missing, how to sharpen]
```

### Diagrams

- **Dependency graph** — Mermaid `flowchart` with critical path + SPOFs highlighted
- **Gantt** — Mermaid `gantt` (conditional)
- **Node-degree quadrant** — Mermaid `quadrantChart` (optional)

---

## Evidence policy

- Every node and edge traceable or `[Assumed]`
- Source references preserved
- Confidence per edge
- Deterministic on same input
- No fabricated technical dependencies to inflate analysis

---

## Self-check

```
[] ≥5 nodes with unique IDs
[] Node type consistent
[] Every edge has direction, type, confidence
[] `[Assumed]` labels on inferred edges
[] Cycle detection run and reported
[] Hubs/sources/sinks identified
[] SPOFs with blast radius
[] Critical path computed if durations supplied
[] Near-critical nodes flagged
[] Buffer recommendations when critical path present
[] All Mermaid diagrams valid
[] Primary diagram highlights critical path and SPOFs
[] No fabricated dependencies
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject or <5 nodes | Interview mode (§7) |
| Node type inconsistent | Ask to normalize before proceeding |
| Graph fully disconnected | Recommend scope narrowing |
| Cycles present | Resolve with user before critical path |
| Durations partial | Compute partial critical path, label `[Assumed]` durations |
| Too many nodes (>50) | Offer cluster/layer grouping |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope (full project planning) | "This skill maps dependencies. For scheduling / WBS, see future planning skills." |

---

## Quality checks

- [ ] ≥5 nodes
- [ ] Consistent node type
- [ ] Every edge typed and direction-marked
- [ ] Cycle check performed
- [ ] Degree analysis reported
- [ ] SPOFs identified
- [ ] Critical path if durations
- [ ] Diagrams valid
- [ ] No fabricated dependencies

---

## Examples

### Normal cases

**1. Release plan**
- Input: Release with 12 deliverables, explicit dependencies, 3-sprint durations supplied
- Expected: Full map, no cycles, critical path through 5 nodes spanning 3 sprints, 2 SPOFs (one team-resource, one vendor API), buffer recommendation for near-critical nodes.

**2. System architecture**
- Input: 8 microservices + known service-to-service dependencies
- Expected: Flowchart with service-to-service edges, 3 `data` edges, 1 `hard-blocking` (auth service), 1 SPOF (auth), mitigation: "Cache tokens; degrade gracefully on auth outage."

**3. Cross-team deliverable**
- Input: Team A, B, C, D each owning 2–3 deliverables; explicit hand-offs
- Expected: Map by team swim-lane (use subgraphs), hand-off edges highlighted, 1 cycle detected (Team A deliverable depends on Team D which depends back on Team A); classified as scope issue; resolution: split Team A deliverable into prerequisite and follow-on halves.

**4. Process mapping**
- Input: 7 process steps in a procurement workflow
- Expected: Flowchart with `hard-blocking` edges, 2 process bottlenecks (high in-degree nodes), no durations so no critical path, recommendations for parallelization.

**5. Partial durations**
- Input: 10 nodes, durations for 6, unknown for 4
- Expected: Critical path computed with `[Assumed]` durations for the 4, confidence labeled low, sensitivity note: "If [N-07] duration is actually >X, critical path shifts to alternative route."

### Edge cases

**6. Cycle detected**
- Input: Graph where A → B → C → A
- Expected: Cycle listed; classified; resolution recommended. Critical path computation blocked until resolution.

**7. Fully disconnected graph**
- Input: 12 nodes, no dependencies provided
- Expected: Report: "Graph has no edges. Either dependencies are truly absent (unusual) or not yet captured. Recommend interview mode to elicit dependencies before proceeding."

**8. Very large graph (>50 nodes)**
- Input: 75-node project plan
- Expected: Offer grouping by cluster/layer; produce summary view (layers/clusters) + detail views per cluster. Do not produce an unreadable 75-node single diagram.

### Failure cases

**9. <5 nodes**
- Input: 3 tasks and their dependencies
- Expected: Interview — "Dependency mapping is most useful with ≥5 nodes. Would you like to expand the scope, or proceed with a simpler sequence view?"

**10. Out of scope**
- Input: "Map dependencies and then estimate effort for all of them"
- Expected: "This skill maps dependencies. For effort estimation, see `cost-estimation` or `timeline-estimation`. I can complete the dependency map and hand off nodes to those skills."
