# Coverage Analysis — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | coverage-analysis |
| **Version** | 1.0.0 |
| **Purpose** | Computes multi-dimensional coverage over a traceability graph (Requirements → Tests, Goals → E2E, Requirements → Stories, Stories → Tests, Risks → Controls, NFR → Implementation evidence, Regulatory clauses → Controls, Abuse cases → Controls), reports per-dimension coverage with uncovered items named explicitly, surfaces false-coverage candidates using heuristic detection (tests without assertions, trivial assertions, tests mocking the system-under-test, commented-out assertions, skipped tests with `.only` inverted, executed-but-unasserted lines) flagged for human review, identifies duplicated coverage where effort can be redistributed to uncovered risks, computes risk-weighted coverage (using `risk-register` / classification tiers / custom weights or uniform `[Assumed]`), and produces a prioritized gap-analysis action list sequenced by high-risk / regulatory / medium-risk / consolidation / low-risk. Mermaid coverage-vs-risk quadrant and optional coverage trend line with PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `extraction` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Release-readiness review: is everything that matters covered?
- Audit preparation with regulatory scope
- Tech debt program scoping — where is effort best spent?
- Post-incident coverage audit — why wasn't this caught?

## When not to use

- Building the traceability graph → `traceability-matrix`
- Change-impact analysis → `impact-analysis`
- Baseline snapshots → `baseline-management`
- Writing new tests → engineering work

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Program / product / release |
| **Traceability source** | RTM output or graph |
| **Coverage dimensions in scope** | ≥ 2 dimensions |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Risk weights** | Per-artifact or per-category | Uniform `[Assumed]` |
| **Regulatory context** | ISO / IEC / FDA / SOC 2 | None |
| **Prior coverage data** | Time series for trend | None |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/coverage-analysis/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    traceability_source:
      type: string | document_reference
    dimensions:
      type: list[string]
      min: 2
  optional:
    risk_weights: object
    regulatory_context: list[string]
    prior_data: object
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
Collect subject + source + dimensions.

### Phase 2 — Dimensions
Apply selected dimensions.

### Phase 3 — Compute coverage
Per dimension: covered / uncovered / %.

### Phase 4 — False-coverage detection
Flag candidates with pattern.

### Phase 5 — Duplicated coverage
Name redundancy + consolidation opportunity.

### Phase 6 — Risk-weighted coverage
Weighted % + show divergence from raw %.

### Phase 7 — Gap analysis
Prioritized by risk.

### Phase 8 — Heat map + optional trend
Mermaid diagrams.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Coverage Analysis: [Subject]

**Date**: [date]
**Dimensions**: [list]
**Risk weights**: [supplied / uniform]

## Scope
[Subject, source, dimensions, regulatory]

## Coverage per Dimension
[Table with raw + risk-weighted %]

## Uncovered Artifacts
[Per dimension with risk, reason, action, effort, owner]

## False-coverage Candidates
[Tests + pattern, flagged for review]

## Duplicated Coverage
[Redundancy + consolidation]

## Gap Analysis
[Prioritized action list]

## Diagrams
[Coverage vs risk + optional trend]

## Assumptions & Limitations
[Risk weights, heuristic bounds, scope]
```

### Diagrams

- **Coverage vs Risk** — Mermaid `quadrantChart`
- **Coverage trend** — Mermaid `xychart-beta` (optional)

---

## Assessment and extraction policy

- Coverage computed from graph
- False-coverage flagged not removed
- Duplicated coverage named specifically
- No fabricated claims

---

## Self-check

```
[] ≥2 dimensions
[] Coverage per dimension
[] Uncovered items named
[] False-coverage with pattern
[] Duplicated coverage identified
[] Risk-weighted computed
[] Gap analysis prioritized
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No traceability source | Require RTM |
| No dimensions | Default req→test + goal→E2E |
| No risk weights | Uniform + `[Assumed]` |
| High false-coverage rate | Flag — metrics unreliable |
| Regulatory coverage < 100% | Audit risk |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | "Analysis only; gap-fixing is engineering work." |

---

## Quality checks

- [ ] ≥2 dimensions
- [ ] Covered/uncovered named
- [ ] False-coverage flagged
- [ ] Duplicated coverage named
- [ ] Risk-weighted coverage
- [ ] Prioritized gaps
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Release readiness**
- Input: 40 requirements, RTM provided
- Expected: Req→Test 85%, Goal→E2E 67%, 6 high-risk uncovered requirements named, 3 false-coverage candidates, 2 duplicated tests, gap action list.

**2. Regulated product**
- Input: IEC 62304 Class B, medical
- Expected: Regulatory clause-to-control at 92%, 3 clauses uncovered (audit risk); prioritize clause closures before release.

**3. Post-incident**
- Input: Incident revealed uncovered path
- Expected: Coverage analysis pre-incident shows it was uncovered; report proposes test + monitoring + assertion; feed into gap list.

**4. Tech debt program scoping**
- Input: "Where should we invest in tests?"
- Expected: Risk-weighted coverage surfaces under-covered high-risk areas; duplicated coverage elsewhere suggests redistribution path.

**5. Trend view**
- Input: Prior coverage data supplied
- Expected: Trend line per dimension; highlight improving vs regressing dimensions.

### Edge cases

**6. 100% raw coverage, big false-coverage rate**
- Input: Coverage 95% but many tests trivial
- Expected: Flag loudly; real coverage likely much lower; prioritize real assertion audit.

**7. Small artifact set**
- Input: Only 10 requirements
- Expected: Percentages noisy; report absolute counts alongside %.

**8. Risk weights reveal opposite picture**
- Input: Raw 80%, risk-weighted 55%
- Expected: High-risk items are under-covered; headline flipped.

### Failure cases

**9. No traceability source**
- Input: "Compute coverage"
- Expected: Require RTM or graph.

**10. Out of scope**
- Input: "Coverage analysis + write missing tests"
- Expected: "Analysis only; test-writing is engineering work."
