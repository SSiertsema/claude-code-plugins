# Impact Analysis — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | impact-analysis |
| **Version** | 1.0.0 |
| **Purpose** | Analyzes the impact of a proposed change across a traceability graph. Takes the change (with type: remove / modify / split / merge / deprecate / rename / reinterpret) and source artifact IDs, walks upstream and downstream through the graph, and produces: explicitly named affected artifacts (no "many") with direction / distance / link type / effect / effort / risk / owner per artifact, blast-radius classification (local / cross-team / external / enterprise), change-level risk with per-factor rationale (reversibility / detection / blast / schedule / compliance), effort estimate per team and artifact type, phasing recommendation with decision gates and rollback plan per phase, communication plan per audience (internal teams / external consumers / leadership / compliance) with message / channel / when, and residual uncertainties requiring discovery before committing. Consumes `traceability-matrix` output. Mermaid blast-radius graph and impact-by-team diagrams with PNG export. |
| **Primary category** | `extraction` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Before committing to a requirement change, API deprecation, or ADR reversal
- Pre-decision risk surface for a proposed refactor
- Regulatory change analysis where artifacts must be re-validated
- Release / rollout planning for a high-impact change

## When not to use

- Baseline RTM construction → `traceability-matrix`
- Coverage analysis → `coverage-analysis`
- Release rollout planning in depth → future planning skills
- Mitigation design for identified risks → `mitigation-strategy-planning`

---

## Required input

| Field | Description |
|---|---|
| **Change** | Description + type |
| **Source artifact IDs** | One or more |
| **Traceability graph** | `traceability-matrix` output or supplied links |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Change deadline** | Date | None |
| **Stakeholders / teams** | For communication plan | Inferred |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/impact-analysis/` |

## Input schema

```
input:
  required:
    change:
      type: object
      properties:
        description: string
        type:
          enum: [remove, modify, split, merge, deprecate, rename, reinterpret]
    source_artifact_ids:
      type: list[string]
    graph_source:
      type: string | document_reference
  optional:
    deadline: string
    stakeholders: list[string]
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
Collect change + sources + graph.

### Phase 2 — Graph walk
Downstream + upstream.

### Phase 3 — Affected artifact list
Named explicitly with per-artifact detail.

### Phase 4 — Blast radius
Local / cross-team / external / enterprise.

### Phase 5 — Risk assessment
Per-factor with aggregate.

### Phase 6 — Effort estimate
Per team + per type + totals.

### Phase 7 — Phasing recommendation
Gates + rollback.

### Phase 8 — Communication plan
Audience × message × channel × timing.

### Phase 9 — Residual uncertainties
Discovery actions.

### Phase 10 — Diagrams
Blast radius + impact-by-team.

### Phase 11 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 12 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Impact Analysis: [Change title]

**Date**: [date]
**Change**: [description]
**Change type**: [type]
**Source artifacts**: [IDs]
**Blast radius**: [classification]
**Overall risk**: [level]

## Scope
[Change + source + graph source + deadline]

## Affected Artifacts
[Table]

## Blast Radius
[Counts + cross-team + external + compliance]

## Risk Assessment
[Per-factor + aggregate]

## Effort Estimate
[Per team + per type]

## Phasing Recommendation
[Phases + gates + rollback]

## Communication Plan
[Per audience]

## Residual Uncertainties
[Discovery actions]

## Diagrams
[Blast radius + impact-by-team]

## Assumptions & Limitations
[Graph gaps, confidence]
```

### Diagrams

- **Blast radius graph** — Mermaid `flowchart` with color-coded source and high-risk nodes
- **Impact by team** — Mermaid `xychart-beta`

---

## Extraction and assessment policy

- Follow graph, no inventions
- Named artifacts
- Honest risk aggregation
- Residual uncertainties surfaced

---

## Self-check

```
[] Change described with type
[] Source IDs named
[] Upstream + downstream walks
[] Affected artifacts named explicitly
[] Per-artifact detail complete
[] Blast radius classified
[] Change-level risk with per-factor rationale
[] Effort per team + type
[] Phasing with gates + rollback
[] Communication plan
[] Residual uncertainties
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No change | Interview mode (§7) |
| No graph | Require RTM or ask for links |
| Graph gaps | Flag, proceed on what's available |
| Unknown external consumers | Residual uncertainty → discovery required |
| Change type unclear | Ask |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope (detailed rollout) | Pointer to planning skills |

---

## Quality checks

- [ ] Change + type
- [ ] Sources named
- [ ] Artifacts named
- [ ] Per-artifact detail
- [ ] Risk per factor
- [ ] Effort per team + type
- [ ] Phasing
- [ ] Communication plan
- [ ] Residual uncertainties
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Deprecate public API endpoint**
- Input: Remove `POST /v1/legacy-signup`
- Expected: Downstream: 3 internal stories, 12 tests, 2 deployed services, 4 external partners. 4-phase rollout (shim → internal migration → external migration → removal). Communication plan with 3-month external notice.

**2. Modify requirement in regulated product**
- Input: Change session-timeout requirement
- Expected: Traceability walk surfaces 18 tests (must re-run for validation), 1 ADR revision, audit-log retention implication. Risk High due to compliance scope.

**3. Split a requirement**
- Input: R-042 split into R-042a (backend) + R-042b (UI)
- Expected: Stories and tests re-linked; coverage recomputed; minimal external impact if both halves stay in product.

**4. Rename a core concept**
- Input: Rename "user" to "member" across product
- Expected: Wide blast radius (UI + docs + API + analytics + emails); phased rollout with aliases; external documentation update.

**5. Change ADR (architectural)**
- Input: Move from JWT to session cookies
- Expected: Upstream to requirements + goals; downstream to 6 services and test suite; risk High due to auth; 6-phase rollout with feature flag + gradual traffic migration.

### Edge cases

**6. Change with unknown external consumers**
- Input: Public API change, no consumer inventory
- Expected: Residual uncertainty high; recommend telemetry + email survey to enumerate consumers before deciding; flag can't commit without discovery.

**7. Tiny scope hidden blast**
- Input: "Just rename a config key"
- Expected: Graph walk reveals deployment configs, secrets, docs, runbooks affected; not tiny — flag realistic scope.

**8. Reversing an ADR**
- Input: Unwind a past decision
- Expected: Map affected artifacts, flag historical context in ADR log, recommend explicit decision log (why reversal).

### Failure cases

**9. No change or source**
- Input: "Analyze impact"
- Expected: Interview — "What change, and which source artifact(s)?"

**10. Out of scope**
- Input: "Do impact analysis + execute the change"
- Expected: "Analysis only; execution is engineering work."
