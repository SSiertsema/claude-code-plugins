# Cost Estimation — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | cost-estimation |
| **Version** | 1.0.0 |
| **Purpose** | Produces a defensible cost estimate for a project, initiative, or feature using multiple techniques: bottom-up (cost per work item), analogous (comparison to past projects), parametric (per-unit × count), and three-point / PERT (`(O + 4M + P) / 6`). Reports optimistic / most-likely / pessimistic ranges per item and aggregates by category (development, design, PM, infrastructure, vendor, people, one-off, contingency). Applies risk-based contingency (10–40%), labels confidence (`high` / `medium` / `low`) against technique diversity and cross-check divergence, and runs sensitivity analysis on the top 3 cost drivers. Mermaid diagrams for cost breakdown (pie), cost range (xychart), and optional sensitivity with PNG export. Feeds `roi-modeling`, `business-case-management`, and `timeline-estimation`. |
| **Primary category** | `generation` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Estimating cost for a project, initiative, or feature as input to a business case, ROI model, or funding decision
- Producing a defensible range (not a single number) with labeled confidence
- Sensitivity analysis on top cost drivers to prioritize scope refinement
- Cross-checking a bottom-up estimate against analogous or parametric references

## When not to use

- ROI / NPV / payback calculation → `roi-modeling`
- Timeline estimation → `timeline-estimation`
- Full business case → `business-case-management`
- TCO for a build-vs-buy decision → `build-vs-buy-analysis` (uses this skill's outputs)
- Financial forecasting → `financial-forecasting`

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Project, initiative, or feature to estimate |
| **Scope** | What is in and out of scope |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Estimation techniques** | `bottom-up` / `analogous` / `parametric` / `three-point` | `bottom-up` + `analogous` cross-check |
| **Cost categories** | Custom category set | Default set |
| **Currency & unit** | EUR/USD; person-month/day/hour | EUR; person-month |
| **Time horizon** | Period covered | 1-year project; 3-year product TCO |
| **Known unit rates** | Loaded cost per role, vendor rates, infra costs | `[Assumed]` |
| **Risk level for contingency** | low / medium / high / very-high | medium (20%) |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/cost-estimation/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    scope:
      type: object
      properties:
        in_scope: list[string]
        out_of_scope: list[string]
  optional:
    techniques:
      type: list[string]
      enum_values: [bottom-up, analogous, parametric, three-point]
      default: [bottom-up, analogous]
    cost_categories:
      type: list[string]
    currency:
      type: string
      default: EUR
    effort_unit:
      type: string
      enum: [person-month, person-day, person-hour]
      default: person-month
    time_horizon:
      type: string
    unit_rates:
      type: object
    risk_level:
      type: string
      enum: [low, medium, high, very-high]
      default: medium
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

Collect subject + scope; interview mode (§7) if missing. Detect techniques, currency, horizon, rates, risk level. Confirm scope.

### Phase 2 — Cost category selection

Default: development, design, PM, infrastructure, vendor, people (non-dev), one-off, contingency. Adjust per subject.

### Phase 3 — Bottom-up

Per work item: O/M/P effort × rate = O/M/P cost. PERT expected = (O + 4M + P) / 6.

### Phase 4 — Analogous cross-check

≥1 reference if available. Scale factor + adjusted estimate. Compare to bottom-up:
- Within ±20%: confidence up
- ±20–50%: investigate
- >50%: flag, do not hide

### Phase 5 — Parametric (optional)

For homogeneous items: parameter × count × per-unit cost. Compare to bottom-up.

### Phase 6 — Aggregate

Category totals with O/M/P/PERT. Apply contingency (10/20/30/40% by risk level). Total.

### Phase 7 — Confidence

- `high`: multi-technique within ±20%
- `medium`: single technique or cross-check within ±50%
- `low`: heavy `[Assumed]` inputs or parametric-only

### Phase 8 — Sensitivity

Top 3 drivers × ±20%. Identify most sensitive.

### Phase 9 — Recommendations

Point estimate + range + contingency + top drivers + refinement priority + downstream skill pointers.

### Phase 10 — Diagrams

Cost breakdown (pie), cost range (xychart), optional sensitivity (xychart).

### Phase 11 — Diagram rendering

Per `diagram-rendering` mixin.

### Phase 12 — Report assembly and approval

Full report; present for approval; save only after confirmation.

---

## Output contract

### Report structure

```markdown
# Cost Estimation: [Subject]

**Date**: [date]
**Currency**: [EUR / USD]
**Time horizon**: [period]
**Techniques**: [list]
**Confidence**: [high / medium / low]

## Scope
[In / out of scope]

## Techniques
[Per technique: description, rationale]

## Bottom-up Estimate
[Per-item table with O/M/P and rates]

## Analogous Cross-check
[Reference + scale factor + adjusted + divergence]

## Parametric Check (optional)
[Parameter / count / per-unit / total / divergence]

## Aggregate
[Category totals with O/M/P/PERT + contingency + total]

## Diagrams
[Cost breakdown + cost range + optional sensitivity]

## Confidence
[Justification]

## Sensitivity Analysis
[Top 3 drivers with ±20% impact]

## Recommendations
[Point estimate + refinement priority + downstream skills]

## Evidence & Assumptions
[`[Assumed]` rates / values with rationale]

## Limitations
[Data gaps, scope sensitivity]
```

### Diagrams

- **Cost breakdown** — Mermaid `pie`
- **Cost range** — Mermaid `xychart-beta`
- **Sensitivity** — Mermaid `xychart-beta` (optional)

In `code` mode: Mermaid code blocks. In `image` mode: PNG via `mmdc`.

---

## Generation and assessment policy

**Generation (primary)**:
- Estimates may be inferred when sparse, but every inference `[Assumed]` with rationale
- Never fabricate vendor prices or industry benchmarks

**Assessment (secondary)** — range bounds, confidence, sensitivity:
- Confidence calibrated against technique diversity and cross-check divergence
- Sensitivity deterministic

---

## Self-check

```
[] Scope (in / out) stated explicitly
[] ≥1 technique applied; ≥2 where feasible
[] Every item has O/M/P with rate (or parametric)
[] PERT expected computed
[] Analogous or parametric cross-check performed (or absence explained)
[] Category breakdown present
[] Contingency applied with rationale
[] Confidence labeled and justified
[] Sensitivity on top 3 drivers
[] `[Assumed]` labels on inferred rates and values
[] All Mermaid diagrams valid
[] Range (not single number) reported
[] No fabricated vendor rates or benchmarks
[] Recommendations point to downstream skills
[] Report follows output contract
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject or scope | Interview mode (§7) |
| Scope is a single line item | Simple estimate with minimal breakdown; flag limitations |
| No rates supplied | Use `[Assumed]` rates with rationale; flag confidence low |
| Analogous divergence >50% | Flag, investigate outliers, do not hide |
| Bottom-up items >30 | Offer grouping by feature / epic |
| Contingency too low for uncertainty | Propose higher contingency |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill (`roi-modeling`, `timeline-estimation`, etc.) |

---

## Quality checks

- [ ] Scope declared
- [ ] Multiple techniques where possible
- [ ] O/M/P per item
- [ ] PERT computed
- [ ] Cross-check performed
- [ ] Category totals
- [ ] Contingency justified
- [ ] Confidence labeled
- [ ] Sensitivity on top 3
- [ ] No fabricated rates

---

## Examples

### Normal cases

**1. Software feature**
- Input: "Add an onboarding checklist to the signup flow"
- Expected: 6 work items (design, backend API, frontend, QA, analytics, PM), O/M/P each, bottom-up + analogous (compared to past onboarding feature), category totals, 20% contingency, confidence medium, sensitivity flags "Design effort" as top driver.

**2. Infrastructure migration**
- Input: "Migrate monolith to microservices (8 services)"
- Expected: Parametric (€X per service × 8) + bottom-up cross-check, diverge >20%, investigated, adjusted per-service rate for most complex service, 30% contingency (high risk), 12-month horizon.

**3. Vendor-heavy project**
- Input: Integration with 3 SaaS APIs
- Expected: Categories dominated by vendor fees + integration effort, analogous to past integrations, clear per-vendor cost line, sensitivity flags "Vendor license tier" as top driver.

**4. Full product build**
- Input: "New mobile app, 4-person team, 6-month horizon"
- Expected: Team-based bottom-up (FTE × 6 months × loaded cost) + analogous to past greenfield app, 20% contingency, confidence medium, recommendation: "Refine [Discovery scope] first — drives ±35% of total."

**5. Scope trimming scenario**
- Input: Same as #4 but with "Budget ceiling: €X"
- Expected: Estimate shows budget exceeded in realistic scenario; recommendations include scope trim options per category.

### Edge cases

**6. No rates**
- Input: No cost rates supplied, no vendor context
- Expected: Use `[Assumed]` rates labeled with typical ranges (e.g., "Senior engineer loaded cost: €10–15k / month `[Assumed]` — typical Western Europe"); confidence low; strong recommendation to get rates.

**7. Scope still evolving**
- Input: "This is our rough plan, scope might grow 30%"
- Expected: Produce base estimate + scope-growth scenarios (15% / 30% / 50%); recommend locking scope before committing budget.

**8. One-item estimate**
- Input: "How much would adding OAuth cost?"
- Expected: Single-item estimate, O/M/P, analogous-only cross-check (past SSO integration), no category breakdown, confidence medium.

### Failure cases

**9. No subject or scope**
- Input: "Estimate the cost"
- Expected: Interview mode — "What are you estimating? What's in scope?"

**10. Out of scope**
- Input: "Estimate cost AND ROI AND timeline"
- Expected: "This skill estimates cost. For timeline: `timeline-estimation`. For ROI: `roi-modeling`. I'll produce the cost estimate — it plugs directly into both."
