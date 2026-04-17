# A/B Hypothesis Framing — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | ab-hypothesis-framing |
| **Version** | 1.0.0 |
| **Purpose** | Frames an A/B test or multi-variant experiment rigorously before it runs. Produces a falsifiable hypothesis ("We believe X will cause Y for population P because mechanism Z"), variant specification (control + treatment(s), differing on a single dimension), pre-committed primary metric with definition, 2–5 secondary interpretive metrics, 2–5 guardrail metrics with regression tolerances, minimum detectable effect (MDE), sample size estimate with the formula shown, duration estimate spanning at least one weekly cycle, peek policy (default no early peeking; sequential method required if peeks allowed), pre-committed decision rule (ship / investigate / don't-ship / rollback / inconclusive), risks to validity (novelty, primacy, SUTVA, multiple comparisons, heterogeneous effects, selection bias) with mitigations, and ethics/user-harm review. Mermaid diagrams for variant flow, sample-size-vs-MDE curve, and decision tree with PNG export. |
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

- Before running an A/B test — produce a rigorous experiment plan
- Pre-registration document for experimentation reviews
- Teams with maturity expectations: pre-committed metrics, MDE, decision rule
- Evaluating whether an experiment is worth running (sample size / duration / risk)

## When not to use

- Non-experimentation validation → `rapid-prototyping`
- Metric design across a program → `metric-definition`
- Post-experiment analysis → dedicated analysis skill
- Qualitative research design → future user-research skills

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Product / feature / surface |
| **Intended change** | Concrete variant change |
| **Primary metric** | Single metric |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Baseline** | Current rate/value of primary | `[Assumed]` |
| **MDE** | Minimum detectable effect | Asked |
| **Traffic** | Eligible users per unit time | Asked |
| **Randomization unit** | user / session / account | user |
| **α, 1−β** | Significance, power | 0.05, 0.80 |
| **Secondary metrics** | Interpretive metrics | Proposed |
| **Guardrail metrics** | Non-regression metrics | Proposed |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/ab-hypothesis/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    intended_change:
      type: string
    primary_metric:
      type: string
  optional:
    baseline: number | string
    mde: number | string
    traffic: object
    randomization_unit:
      type: string
      default: user
    alpha:
      type: number
      default: 0.05
    power:
      type: number
      default: 0.80
    secondary_metrics: list[string]
    guardrail_metrics: list[object]
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
Collect subject, change, primary metric; interview mode (§7) if missing.

### Phase 2 — Hypothesis
Falsifiable statement with mechanism.

### Phase 3 — Variants
Control + treatment(s); single-dimension difference; flag confounding.

### Phase 4 — Metrics
Primary (one), secondary (2–5), guardrail (2–5 with tolerances).

### Phase 5 — Sample size
Formula + compute n per variant.

### Phase 6 — Duration
≥ one weekly cycle.

### Phase 7 — Peek policy & decision rule
Pre-committed.

### Phase 8 — Risks to validity
Novelty / primacy / SUTVA / multiple comparisons / heterogeneity / selection bias + mitigations.

### Phase 9 — Ethics & user harm
Explicit consideration.

### Phase 10 — Diagrams
Variant flow, sample-size-vs-MDE curve, decision tree.

### Phase 11 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 12 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# A/B Experiment Plan: [Subject]

**Date**: [date]
**Primary metric**: [metric]
**Baseline**: [value or `[Assumed]`]
**MDE**: [value]
**α, 1−β**: [0.05, 0.80]

## Hypothesis
[Falsifiable statement]

## Variants
[A / B / optional C]

## Metrics
[Primary / Secondary / Guardrail]

## Sample Size
[n per variant + total + formula; `[Illustrative]` if baseline assumed]

## Duration
[Days / weeks]

## Peek Policy & Decision Rule
[Policy + decision table]

## Risks to Validity
[Risks + mitigations]

## Ethics & User Harm
[Explicit]

## Diagrams
[Variant flow + sample-size curve + decision tree]

## Assumptions & Limitations
[Baseline confidence, randomization rationale]
```

### Diagrams

- **Variant flow** — Mermaid `flowchart`
- **Sample size vs MDE** — Mermaid `xychart-beta`
- **Decision tree** — Mermaid `flowchart`

---

## Generation and planning policy

- Hypothesis falsifiable; mechanism named
- Baseline + MDE justified or `[Assumed]`
- Sample size formula shown
- Decision rule pre-committed
- Peek policy explicit
- No outcome prediction

---

## Self-check

```
[] Falsifiable hypothesis + mechanism
[] Primary metric pre-committed
[] Baseline + MDE declared or `[Assumed]`
[] Single-dimension variants (or confound flagged)
[] Secondary + guardrail pre-committed
[] Sample size formula + n
[] Duration ≥1 weekly cycle
[] Peek policy explicit
[] Pre-committed decision rule
[] Validity risks + mitigations
[] Ethics & harm
[] Diagrams valid
[] No outcome prediction
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No hypothesis | Interview mode (§7) |
| No primary metric | Block progress until declared |
| Baseline / MDE missing | `[Assumed]`; flag confidence |
| Sample size infeasible | Recommend loosening MDE, extending duration, or deferring |
| Guardrail vs primary conflict | Surface, decide in advance |
| Multi-dimension variant | Flag confounding, recommend split |
| Ethical harm plausible | Flag; require mitigation or recommend against |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] Falsifiable hypothesis
- [ ] Single primary metric
- [ ] Pre-committed metric set
- [ ] Sample size with formula
- [ ] Duration spans weekly cycle
- [ ] Peek policy
- [ ] Decision rule
- [ ] Validity risks
- [ ] Ethics considered
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Pricing test**
- Input: Change checkout CTA from "Buy now" to "Start 14-day trial", primary = conversion rate, baseline 3%, MDE +0.5pp, traffic 50k/week
- Expected: n ≈ 11.8k per variant, duration ≈ 2 weeks, guardrails revenue and refund rate, decision rule includes "guardrail breach → no ship even if primary wins".

**2. Landing-page redesign**
- Input: Full redesign, primary = signup rate
- Expected: Flag confounded variant (many things change); recommend splitting into sub-tests OR accept reduced interpretability; MDE larger to compensate.

**3. Algorithm change (ranking)**
- Input: New ranking model, primary = CTR
- Expected: User-level randomization; guardrails: session length, query abandonment, support tickets; peek policy via sequential testing for interim safety reads only.

**4. Pricing experiment**
- Input: Change price from €10 to €12, primary = revenue per user
- Expected: Ethical review flag — price discrimination concerns; recommend randomization at market or cohort level with documented justification; guardrails: churn, NPS.

**5. Onboarding flow**
- Input: Add progress indicator, primary = activation rate
- Expected: Power calculated; secondary = time-to-activation, completion-rate per step; guardrails: error rate, support tickets.

### Edge cases

**6. Low traffic**
- Input: Surface sees 300 users/week; MDE 5% relative
- Expected: Required n far exceeds feasible duration; recommend MDE relaxation, cohort rollout analysis, or qualitative alternative.

**7. Holiday seasonality**
- Input: Experiment window includes major holiday
- Expected: Flag seasonality, recommend delayed start or extended duration to cover non-holiday baseline.

**8. Multi-variant (A/B/C/D)**
- Input: 4 variants
- Expected: Power cost × 4; recommend reducing variants OR increasing traffic / duration; multiple-comparisons correction per secondary metric set.

### Failure cases

**9. No primary metric**
- Input: "Run an A/B on the homepage"
- Expected: Block — "Which single metric decides this experiment?"

**10. Out of scope**
- Input: "Frame it and also define our North Star metric"
- Expected: "This skill frames experiments. For metric design, see `metric-definition`."
