# Technology Evaluation Matrix — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | technology-evaluation-matrix |
| **Version** | 1.0.0 |
| **Purpose** | Evaluates ≥3 technology options (frameworks / databases / languages / SaaS tools / libraries / infrastructure components, typically including "keep current") using a weighted scoring matrix. Default 10 criteria with adjustable weights: fit for requirement, maturity, community + ecosystem, TCO over horizon, learning curve, integration, licensing, vendor risk, performance, security posture. Additional context-specific criteria added when relevant (compliance support, scalability envelope, data residency, latency distribution). Per option × criterion cell: score 1–5, 1–2 sentence rationale, confidence (high / medium / low), source (docs / benchmarks / past experience / `[Assumed]`). Same evidence standard applied across all options (apples-to-apples). Runs sensitivity analysis varying top-2 weights ±20%; flags when recommendation changes. Produces recommendation with runner-up, accepted trade-off, top risk + mitigation, and 3–5 concrete reversal conditions. Distinct from `build-vs-buy-analysis` (compares build / buy / non-consumption); this picks between comparable options of same class. Mermaid per-criterion bar chart + weighted-totals diagram with PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Choosing between comparable technologies (frameworks, DBs, monitoring tools, cloud services)
- Stack selection for new project
- Migration-target decision (React vs Vue vs Svelte, Postgres vs MongoDB, AWS vs GCP)
- Vendor shortlist evaluation
- Input to `adr-writing` (feed the decision + rationale into an ADR)

## When not to use

- Build vs buy vs non-consumption → `build-vs-buy-analysis`
- Cost modeling only → `cost-estimation`
- Scalability fit → `scalability-modeling`
- Security posture audit → `security-requirements-classification` / `control-framework-mapping`
- Architecture pattern choice → `architecture-pattern-selection`

---

## Required input

| Field | Description |
|---|---|
| **Decision scope** | What's being chosen |
| **Options** | ≥3 candidates |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Use-case requirements** | Priorities | Elicit |
| **Criteria weights** | Per criterion | Default (equal) |
| **Time horizon** | For TCO | 3 years |
| **Constraints** | Budget / timeline / compliance / team | None |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/technology-evaluation-matrix/` |

## Input schema

```
input:
  required:
    decision_scope:
      type: string
    options:
      type: list[string]
      min: 3
  optional:
    use_case_requirements: list[string]
    criteria_weights: object
    time_horizon_years:
      type: integer
      default: 3
    constraints: object
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
Collect decision + options + requirements.

### Phase 2 — Criteria set
Default 10 + context-specific additions.

### Phase 3 — Weighting
Default equal; adjust per use-case priorities.

### Phase 4 — Scoring
Per cell: score + rationale + confidence + source.

### Phase 5 — Weighted totals
Sum(score × weight) per option; show breakdown not just number.

### Phase 6 — Sensitivity analysis
Top-2 weights ±20%; flag if recommendation changes.

### Phase 7 — Recommendation
Chosen + runner-up + trade-off + risk + mitigation + disqualified.

### Phase 8 — Reversal conditions
3–5 concrete triggers.

### Phase 9 — Diagrams
Scoring matrix + per-criterion bars + weighted totals.

### Phase 10 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 11 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Technology Evaluation: [Decision]

**Date**: [date]
**Options evaluated**: [N]
**Criteria**: [list]
**Time horizon**: [years]

## Scope
[Decision, options, use-case, constraints]

## Criteria & Weights
[Per criterion + weight + rationale]

## Scoring Matrix
[Options × criteria with score + rationale per cell]

## Weighted Totals
[Per option]

## Sensitivity Analysis
[Top-2 weights ±20% — does recommendation change?]

## Recommendation
[Chosen + runner-up + trade-off + risk + mitigation + disqualified]

## Reversal Conditions
[Triggers]

## Evidence & Assumptions
[`[Assumed]` cells; verified sources cited]

## Diagrams
[Matrix + per-criterion + totals]

## Assumptions & Limitations
[Benchmark gaps]
```

### Diagrams

- **Scoring matrix** — Markdown table
- **Per-criterion scores** — Mermaid `xychart-beta` (multi-bar per option)
- **Weighted totals** — Mermaid `xychart-beta` (single-bar per option)

---

## Assessment and planning policy

- Per-cell rationale + confidence + source
- Same evidence standard across options
- Sensitivity analysis
- Reversal conditions concrete
- No fabricated benchmarks

---

## Self-check

```
[] ≥3 options
[] Criteria + weights declared
[] Per-cell complete
[] Weighted totals computed
[] Sensitivity analysis
[] Recommendation with trade-off + risk + mitigation
[] Reversal conditions
[] `[Assumed]` labeled
[] Diagrams valid
[] Equal evidence standard across options
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| <3 options | Interview or propose "keep current" as third |
| No use-case | Ask |
| One weight dominates | Flag trade-off |
| Ties | Sensitivity + stakeholder choice |
| All options low | Criteria too demanding or pool too small |
| mmdc failure | See `diagram-rendering` mixin |
| Build-vs-buy question | Pointer to `build-vs-buy-analysis` |

---

## Quality checks

- [ ] Options + criteria + weights
- [ ] Per-cell rationale
- [ ] Weighted totals
- [ ] Sensitivity
- [ ] Recommendation with trade-off
- [ ] Reversal conditions
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Database choice**
- Input: Postgres vs MongoDB vs DynamoDB, B2B SaaS
- Expected: Postgres wins on fit + maturity + licensing; MongoDB stronger on schemaless flex; DynamoDB on serverless ops. Sensitivity: if operational simplicity doubled, DynamoDB catches up. Recommendation: Postgres; reversal if serverless-first requirement emerges.

**2. Frontend framework**
- Input: React vs Vue vs Svelte for new product
- Expected: React wins on community + hiring pool; Vue strong on DX; Svelte on bundle size. Sensitivity: for team-of-2 startup, learning-curve weight could shift to Vue. Recommendation with hiring-rationale risk.

**3. Monitoring tool**
- Input: Datadog vs New Relic vs Grafana Cloud
- Expected: Datadog strongest feature set; cost sensitivity makes Grafana Cloud competitive; New Relic weak on integration breadth. Reversal: if cost exceeds €X/month.

**4. Language for new service**
- Input: Go vs Rust vs Node.js
- Expected: Go wins on team familiarity + deployment; Rust strongest on perf + safety but steep learning; Node on ecosystem. Recommendation: Go for current team, but flag Rust as candidate for performance-critical future service.

**5. Cloud provider**
- Input: AWS vs GCP vs Azure
- Expected: Weights reflect enterprise compliance + existing Azure footprint; Azure wins on lock-in low; AWS on ecosystem; GCP on ML. Disqualify Azure if hybrid-cloud not viable.

### Edge cases

**6. All options very similar**
- Input: Three DBs of same class
- Expected: Scores converge; sensitivity shows small shifts swing recommendation; surface as "low-stakes choice — pick based on operational preference".

**7. Top option has disqualifying flaw**
- Input: Tech scores highest but license forbids commercial use
- Expected: Disqualified on licensing (hard constraint); runner-up promoted; trade-off accepted.

**8. Biased evaluation**
- Input: Team has clear favorite; scoring inflated
- Expected: Flag equal-evidence violation; rescore with explicit criteria; surface bias for discussion.

### Failure cases

**9. Only 1 option considered**
- Input: "Evaluate Postgres"
- Expected: Interview — "Need ≥3 options for comparison. Include 'keep current' if applicable."

**10. Out of scope**
- Input: "Evaluate + buy + implement"
- Expected: "Evaluation only. Purchasing is procurement; implementation is engineering."
