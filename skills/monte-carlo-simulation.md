# Monte Carlo Simulation — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | monte-carlo-simulation |
| **Version** | 1.0.0 |
| **Purpose** | Structures and runs a Monte Carlo simulation over user-supplied input variables with distributions (triangular, PERT, uniform, normal, log-normal, discrete). Computes percentile outputs (P10 / P25 / P50 / P75 / P80 / P90 / P95), mean, standard deviation, probability of meeting a supplied threshold with qualitative label, sensitivity tornado ranking input variables by their impact on the target, and a contingency recommendation tied to a target percentile (P50 / P80 / P90 / P95). When code execution is available, runs 10,000 iterations with a noted seed; otherwise produces a complete spec with `[Illustrative]` figures for downstream execution. Mermaid diagrams for percentile curve, sensitivity tornado, and optional histogram with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Cost or schedule uncertainty where multiple variables compound
- Capacity or demand planning with probabilistic inputs
- Risk quantification when qualitative matrices are insufficient
- Decision support when a target/threshold must be met with known confidence
- Sensitivity analysis to prioritize refinement of the most impactful inputs

## When not to use

- Qualitative risk scoring → `risk-matrix`
- Failure-mode analysis → `fmea`
- Persistent risk inventory → `risk-register`
- Mitigation action planning → `mitigation-strategy-planning`
- Prospective failure brainstorm → `pre-mortem`

---

## Required input

| Field | Description |
|---|---|
| **Target quantity** | What is being simulated (e.g., "project cost", "delivery date", "annual revenue") |
| **Output formula** | How inputs combine into the target |
| **Input variables** | ≥3 variables with distribution type + parameters |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Target threshold** | Value to compare probability against | None |
| **Iterations** | Number of samples | 10,000 |
| **Random seed** | Seed for reproducibility | 42 |
| **Correlations** | Pairs of correlated variables | Assumed independent |
| **Risk tolerance** | For contingency recommendation | P80 |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/monte-carlo/` |

## Input schema

```
input:
  required:
    target_quantity:
      type: string
    formula:
      type: string
    variables:
      type: list[object]
      min: 3
      properties:
        id: string
        name: string
        distribution:
          enum: [triangular, pert, uniform, normal, log-normal, discrete]
        parameters: object
  optional:
    threshold: number
    iterations:
      type: integer
      default: 10000
    seed:
      type: integer
      default: 42
    correlations: list[object]
    risk_tolerance:
      type: string
      enum: [P50, P80, P90, P95]
      default: P80
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
Collect target, formula, variables; interview mode (§7) if missing.

### Phase 2 — Input variable spec
Per variable: distribution + parameters + evidence or `[Assumed]`.

### Phase 3 — Formula
Expression combining variables with consistent units.

### Phase 4 — Simulation run
Iterations (default 10k). If executable, run; else produce spec with `[Illustrative]` figures.

### Phase 5 — Percentiles
P10 / P25 / P50 / P75 / P80 / P90 / P95 + mean + std-dev.

### Phase 6 — Sensitivity tornado
Per variable: delta at P10 vs P90, ranked by absolute impact.

### Phase 7 — Probability of meeting target
Count iterations ≤ threshold / N. Qualitative label (very likely / likely / uncertain / unlikely / very unlikely).

### Phase 8 — Contingency recommendation
Recommend percentile based on risk tolerance.

### Phase 9 — Diagrams
Percentiles line chart, sensitivity tornado, optional histogram.

### Phase 10 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 11 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Monte Carlo Simulation: [Target]

**Date**: [date]
**Iterations**: [N]
**Seed**: [seed]
**Target quantity**: [name + unit]
**Threshold**: [value or "none"]

## Scope
[Target, formula, variables, iterations, threshold]

## Input Variables
[Per variable: distribution, parameters, evidence or `[Assumed]`]

## Formula
[Expression]

## Percentiles
[P10 – P95 + mean + std-dev]

## Probability of Meeting Target
[If threshold: probability + label + action recommendation]

## Sensitivity Tornado
[Ranked drivers]

## Contingency Recommendation
[Percentile + justification]

## Diagrams
[Percentiles + tornado + optional histogram]

## Assumptions & Limitations
[Independence assumption, `[Assumed]` parameters, `[Illustrative]` if not executed]
```

### Diagrams

- **Percentile curve** — Mermaid `xychart-beta`
- **Sensitivity tornado** — Mermaid `xychart-beta`
- **Histogram** — Mermaid `xychart-beta` (optional, binned)

---

## Generation and assessment policy

- Distribution parameters traceable or `[Assumed]`
- No fabricated statistics
- `[Illustrative]` when not executed
- Sensitivity ranking deterministic
- Confidence tied to input-distribution evidence

---

## Self-check

```
[] Target + unit declared
[] Formula specified
[] ≥3 variables with distributions
[] Evidence or `[Assumed]` per variable
[] Iterations ≥1,000
[] Seed noted
[] Percentiles reported
[] Threshold probability (if supplied)
[] Tornado with top drivers ranked
[] Contingency justified
[] `[Illustrative]` if not executed
[] Independence stated
[] Diagrams valid
[] No fabricated parameters
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No target or formula | Interview mode (§7) |
| <3 variables | Ask to expand |
| Distribution parameters missing | Ask; do not invent |
| Formula ambiguous | Ask to clarify |
| Correlations suspected | Ask; state independence assumption otherwise |
| Execution unavailable | Produce spec + `[Illustrative]` figures |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] Target + formula declared
- [ ] ≥3 variables with distributions + parameters
- [ ] Percentiles reported
- [ ] Threshold probability if supplied
- [ ] Tornado ranking
- [ ] Contingency recommendation
- [ ] `[Illustrative]` label when appropriate
- [ ] Independence assumption stated
- [ ] Diagrams valid
- [ ] No fabricated parameters

---

## Examples

### Normal cases

**1. Project cost**
- Input: target = cost, 6 variables (engineering effort, design effort, QA effort, infra, vendor, contingency), PERT distributions, threshold = €400k
- Expected: P50 = €310k, P80 = €380k, P90 = €420k, probability ≤ €400k = 0.82 (`likely`), tornado: engineering effort dominant, recommend budget at P80.

**2. Schedule**
- Input: target = end-date, 8 task durations with triangular distributions, threshold = +90 working days
- Expected: P50 = 85 days, P80 = 102 days, P90 = 118 days, probability ≤ 90 = 0.60 (`uncertain — skewed toward meeting`), tornado: integration task dominant.

**3. Revenue forecast**
- Input: target = annual revenue, 4 variables (customers acquired, ARPU, churn, expansion), normal + triangular mix
- Expected: Percentile distribution skewed long right, P50 = €2.1M, P90 = €3.2M, tornado: customers acquired dominant, sensitivity recommends sales capacity investment.

**4. With correlations**
- Input: Project cost where engineering effort and design effort both increase in complex-scope scenarios
- Expected: User provides correlation coefficient; simulation accounts for joint moves; percentile spread wider than under independence assumption.

**5. Not executed — spec only**
- Input: Full spec but no execution tooling
- Expected: Produce full spec, compute percentiles algebraically where possible, label all figures `[Illustrative]`, recommend running in Python/R notebook.

### Edge cases

**6. Single dominant variable**
- Input: Tornado shows 1 variable at 80% of total impact
- Expected: Flag this as concentrated uncertainty; recommend refining that variable's distribution before committing to the full model.

**7. Heavy-tailed distribution**
- Input: Log-normal on a key cost variable
- Expected: P95 significantly above P80; note that tail risk matters; recommend considering P95 for commitments.

**8. Target clearly unreachable**
- Input: Threshold below P10
- Expected: Probability ≈ 0; flag unreachable under current inputs; recommend renegotiating scope or accepting lower confidence.

### Failure cases

**9. No target or formula**
- Input: "Run a Monte Carlo"
- Expected: Interview — "What quantity, what formula, what variables?"

**10. Out of scope**
- Input: "Run Monte Carlo and also give me a risk register"
- Expected: "This skill produces probabilistic output. Risk inventory belongs in `risk-register` — the simulation sensitivities feed into it."
