# Rapid Prototyping — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | rapid-prototyping |
| **Version** | 1.0.0 |
| **Purpose** | Plans a focused, time-boxed prototype designed to validate one specific assumption. Classifies the assumption (desirability / feasibility / viability / usability / technical / data), rewrites it in falsifiable form, selects the cheapest technique that can falsify it (paper sketch, wireflow / clickable mock, Wizard of Oz, concierge MVP, landing-page / fake-door test, technical spike, data spike, pretotype), defines happy-path-only scope with explicit out-of-scope, pre-commits success / kill / ambiguous criteria before building, names 3–5 things the prototype will NOT prove, fixes a timebox with concrete days, sequences follow-on work under each outcome, and flags risks to validity (small-sample, Hawthorne, novelty, selection bias, demand artifact) with mitigations. Mermaid diagrams for technique decision tree, outcome tree, and Gantt timeline with PNG export. |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Before committing to build: validate a risky assumption cheaply
- Early product/market fit experiments
- Technical or data feasibility check before architectural investment
- Pricing / willingness-to-pay validation
- Pre-launch demand testing

## When not to use

- Experimentation with variants at scale → `ab-hypothesis-framing`
- Defining metrics and success criteria across a program → `metric-definition`
- Full product build → development skills (Phase 5+)
- User research interviews → future interview skill

---

## Required input

| Field | Description |
|---|---|
| **Assumption** | The single assumption to validate |
| **Context** | Product / market / persona |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Risk level** | If wrong, what breaks | Asked |
| **Resources** | People, budget, tools | Asked |
| **Timebox** | Fixed end-date | 1–2 weeks |
| **Technique preference** | User-forced technique | Auto-select |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/rapid-prototyping/` |

## Input schema

```
input:
  required:
    assumption:
      type: string
    context:
      type: string
  optional:
    risk_level:
      type: string
    resources:
      type: object
    timebox_weeks:
      type: number
      default: 1.5
    technique_preference:
      type: string
      enum: [paper, wireflow, wizard-of-oz, concierge, landing-page, technical-spike, data-spike, pretotype]
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
Collect assumption + context; interview mode (§7) if missing.

### Phase 2 — Assumption deconstruction
Classify type; rewrite as falsifiable.

### Phase 3 — Technique selection
Match to type; cheapest-fidelity principle.

### Phase 4 — Prototype scope
Happy path only; explicit out-of-scope; participants; instrumentation.

### Phase 5 — Success & kill criteria
Pre-committed, concrete, measurable.

### Phase 6 — What will NOT be proven
3–5 items.

### Phase 7 — Plan & timebox
Day-by-day plan; timebox fixed.

### Phase 8 — Sequencing
Per-outcome next steps.

### Phase 9 — Risks to validity
Biases + mitigations.

### Phase 10 — Diagrams
Technique tree, outcome tree, Gantt.

### Phase 11 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 12 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Rapid Prototype Plan: [Assumption]

**Date**: [date]
**Timebox**: [N days]
**Technique**: [selected]
**Assumption type**: [type]

## Scope
[Context, assumption, risk, resources]

## Assumption (Falsifiable)
[Rewrite]

## Technique Selection
[Chosen + rationale]

## Prototype Scope
[What / happy path / out-of-scope / participants / instrumentation]

## Success & Kill Criteria
[Table]

## What This Will NOT Prove
[3–5 items]

## Timeline
[Gantt + table]

## Sequencing
[Success / kill / ambiguous branches]

## Risks to Validity
[Biases + mitigations]

## Diagrams
[Technique tree + outcome tree + timeline]

## Assumptions & Limitations
[Participant pool, tooling, scope constraints]
```

### Diagrams

- **Technique decision tree** — Mermaid `flowchart`
- **Outcome decision tree** — Mermaid `flowchart`
- **Timeline** — Mermaid `gantt`

---

## Planning and generation policy

- Technique grounded in assumption type
- Success/kill pre-committed
- Non-coverage explicit
- No outcome prediction
- Timebox fixed

---

## Self-check

```
[] Falsifiable assumption
[] Type classified
[] Technique matches type
[] Cheapest-fidelity applied
[] Happy-path-only scope
[] Success + kill + ambiguous pre-committed
[] NOT-proven list (3–5)
[] Fixed timebox
[] Per-outcome sequencing
[] Validity risks + mitigations
[] Diagrams valid
[] No outcome prediction
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No assumption | Interview mode (§7) |
| Multiple assumptions | Split into separate prototypes |
| Not falsifiable | Rewrite with user |
| Cheapest technique infeasible | Next-cheapest + trade-off note |
| No audience access | Recruiting phase first |
| Timebox too short | Smaller scope or shorter technique |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | "Plan-only — full build belongs to later phases." |

---

## Quality checks

- [ ] Falsifiable assumption
- [ ] Technique matches type
- [ ] Pre-committed criteria
- [ ] NOT-proven list
- [ ] Timebox
- [ ] Sequencing
- [ ] Validity risks
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Landing-page demand test**
- Input: "Users will pay €10/month for X feature"
- Expected: Viability type; landing-page test (capture email + simulated pricing page); success = ≥5% signup rate from 500 visitors; kill = <1%; NOT proven = actual payment behavior (next prototype = paywall).

**2. Wizard of Oz for AI feature**
- Input: "Users will trust automated recommendations in context C"
- Expected: Desirability; Wizard of Oz (human curates recommendations behind the scenes); 10 participants; success = ≥7 engage with recommendations, ≥5 say they'd use again; 2-week timebox.

**3. Technical spike**
- Input: "We can meet <100ms P95 latency at 10k RPS on stack X"
- Expected: Feasibility; technical spike (skeleton service + load test); success = sustained <100ms at 10k RPS for 1 hour; kill = >200ms or errors; NOT proven = production stability beyond timebox.

**4. Concierge MVP**
- Input: "Busy executives will delegate inbox triage to a person-assisted service"
- Expected: Viability + desirability; concierge MVP (manual triage by an operator for 10 users); success = retention ≥7 of 10 after 2 weeks; NOT proven = automation scalability.

**5. Data spike**
- Input: "Our event data supports a churn-prediction model"
- Expected: Data; 3-day spike querying event history, building baseline features, running a simple model; success = AUC ≥0.7 on holdout; kill = AUC <0.55.

### Edge cases

**6. Assumption rolled up too high**
- Input: "Users will love our product"
- Expected: Ask to narrow; pick one specific behavior/mechanism; rewrite.

**7. Multiple assumptions**
- Input: "Users want X + will pay for X + we can scale X"
- Expected: Split into 3 prototypes; sequence desirability → viability → feasibility.

**8. Cheapest technique blocked**
- Input: Landing-page test ideal but legal / compliance forbids pre-release marketing
- Expected: Recommend Wizard of Oz or concierge as next-cheapest; note trade-off.

### Failure cases

**9. No assumption**
- Input: "Plan a prototype"
- Expected: Interview — "What assumption do you want to validate?"

**10. Out of scope**
- Input: "Plan the prototype and build it"
- Expected: "This skill plans. Build belongs in later phases. I can hand the plan off to a dev workflow."
