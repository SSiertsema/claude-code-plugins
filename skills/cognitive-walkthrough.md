# Cognitive Walkthrough — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | cognitive-walkthrough |
| **Version** | 1.0.0 |
| **Purpose** | Performs a cognitive walkthrough — simulates a novice / first-time user attempting to complete a specific task through the UI step by step. Per step answers the four CW questions (Q1 goal match, Q2 action visibility, Q3 action-effect link, Q4 progress feedback) with Yes / No / `[Assumed]` + ≤20-word rationale grounded in the declared persona's knowledge. Every "No" becomes a finding with severity (critical / major / minor / insight), concrete recommendation, and step reference. Produces a task-completion prediction (complete / partial / no), identifies the rate-limiting step, estimates support need and relative time-to-complete. Optional multi-persona comparison (novice / intermediate / expert) to surface personalization or progressive-disclosure opportunities. Prioritizes recommendations across critical / quick-wins / structural / cross-step-pattern categories. Mermaid step-level "No" heat map and per-question pass-rate pie with PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Pre-release evaluation of a critical task (signup, checkout, first-run, recovery)
- Novice-user focus when heuristic evaluation alone isn't task-specific enough
- Onboarding / first-run design review
- Pairing with `heuristic-evaluation` for fuller coverage
- Input to `progressive-disclosure-planning` (where the novice struggles = where disclosure helps)

## When not to use

- Heuristic-set audit (not task-based) → `heuristic-evaluation`
- Gestalt perceptual review → `gestalt-principle-application`
- Accessibility conformance → `accessibility-requirements`
- Real-user usability testing → future user-testing skills
- Multi-task journey at strategic level → `user-journey-management`

---

## Required input

| Field | Description |
|---|---|
| **Task** | One-sentence task with action verb |
| **Persona** | User type with background |
| **Path** | Ordered step sequence the user takes |
| **UI description** | Text / wireframe / spec |

## Optional input

| Field | Description | Default |
|---|---|---|
| **User background** | Domain knowledge / prior tool experience | Asked if relevant |
| **Entry state** | Where the user starts | Explicit in task |
| **Success state** | What "done" looks like | Explicit in task |
| **Multi-persona** | Variants (novice / intermediate / expert) | Single persona default |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/cognitive-walkthrough/` |

## Input schema

```
input:
  required:
    task:
      type: string
    persona:
      type: object
      properties:
        name: string
        background: string
        domain_knowledge: string
    path:
      type: list[string]
    ui_description:
      type: string | document_reference
  optional:
    entry_state: string
    success_state: string
    personas_additional: list[object]
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
Collect task + persona + path + UI description.

### Phase 2 — Four CW questions per step
Yes / No / `[Assumed]` + rationale.

### Phase 3 — Issues from "No"
Finding per No: severity + recommendation.

### Phase 4 — Task-completion prediction
Complete / partial / no + rate-limiting step + support + time.

### Phase 5 — Persona-dependency
Compare across variants if multi-persona.

### Phase 6 — Recommendations
Critical / quick wins / structural / cross-step.

### Phase 7 — Diagrams
Step heat map + pass-rate pie.

### Phase 8 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 9 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Cognitive Walkthrough: [Task]

**Date**: [date]
**Task**: [sentence]
**Persona**: [user type]
**Entry → Success**: [from → to]
**Steps**: [count]

## Scope
[Task, persona, goal, entry, success, path]

## Per-step Walkthrough
[Q1 / Q2 / Q3 / Q4 per step]

## Findings
[Table: ID / step / question / issue / severity / recommendation]

## Task-completion Prediction
[Complete / Partial / No + rate-limiting step + support + time]

## Persona-dependency (if applicable)
[Comparison across variants]

## Recommendations
[Critical / quick wins / structural / cross-step patterns]

## Diagrams
[Step heat map + pass-rate pie]

## Assumptions & Limitations
[`[Assumed]` persona knowledge, description gaps]
```

### Diagrams

- **Steps "No" heat map** — Mermaid `xychart-beta` (bars = count of "No" per step)
- **Per-question pass rate** — Mermaid `pie`

---

## Assessment and generation policy

- All 4 questions every step (no skipping)
- Severity from controlled scale
- Recommendations concrete
- `[Assumed]` on persona-knowledge ambiguity
- No fabricated persona knowledge
- No blame language
- Deterministic

---

## Self-check

```
[] One task scoped
[] Persona declared with background
[] Entry / success / path explicit
[] All 4 questions per step
[] "No" → finding with severity + recommendation
[] Severity from controlled scale
[] Task-completion prediction
[] Persona-dependency if multi-persona
[] Prioritized recommendations
[] `[Assumed]` labeled
[] Diagrams valid
[] No blame language
[] No fabricated persona knowledge
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No task / persona / path | Interview mode (§7) |
| Path vague | Require explicit steps |
| Persona vague | Ask for background + domain |
| Multiple tasks conflated | Split into multiple walkthroughs |
| UI description insufficient for a step | `[Assumed]` on affected Q's |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope (real user test) | "CW is analytical; real-user testing is future skill." |

---

## Quality checks

- [ ] Task scoped
- [ ] Persona + background
- [ ] Full path
- [ ] All 4 questions every step
- [ ] Findings from "No" answers
- [ ] Task-completion prediction
- [ ] Recommendations prioritized
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Signup flow for non-technical novice**
- Input: Task = "Create an account on [product]", persona = non-technical first-time user, 5-step path
- Expected: Q1 mostly pass; Q2 fails on step 3 (SSO button hidden below fold — major); Q3 fails on step 4 (label "Verify" ambiguous — minor); Q4 fails on step 5 (no success confirmation — major). Rate-limiting step = 3. Prediction: partial; 30% likely to abandon at step 3.

**2. Checkout**
- Input: Task = "Complete purchase", persona = returning customer
- Expected: Most Q's pass (familiar pattern); Q4 fails on step 4 (no order-confirmation feedback — major). Task completion = yes with minor friction. Fix: add loading + confirmation toast.

**3. Password reset**
- Input: Task = "Reset password from email link", persona = confused user
- Expected: Q2 fails at email click (link buried in marketing email — critical), Q3 fails at new-password step (requirements unclear — major). Rate-limiting = email discoverability; recommendation: restructure email + inline password requirements.

**4. First-run onboarding**
- Input: Task = "Complete first-time setup", persona = new user with no prior context
- Expected: Multi-step with Q2 failures on progressive-disclosure issues; recommendation to feed into `progressive-disclosure-planning`.

**5. Multi-persona comparison**
- Input: Same task, 3 personas (novice / intermediate / expert)
- Expected: Novice fails at step 3 Q2; intermediate passes; expert passes. Recommendation: progressive disclosure — hide advanced controls by default, expose for experts.

### Edge cases

**6. Task fully pass**
- Input: Well-designed, mature task
- Expected: All Q's pass; no findings; note "UI meets cognitive walkthrough expectations for this persona — consider testing with more challenging persona or edge scenarios."

**7. Path branches**
- Input: Task with conditional path (if X then A, else B)
- Expected: Walkthrough both branches; identify per-branch findings; note branch-selection as a step itself.

**8. Persona knowledge unclear**
- Input: Persona = "B2B admin" — domain knowledge about role-based permissions unclear
- Expected: `[Assumed]` on Q3 when answering requires permission-model knowledge; recommend validating with real admins.

### Failure cases

**9. No task or path**
- Input: "Do a walkthrough"
- Expected: Interview — "Which task, which persona, what's the path?"

**10. Out of scope**
- Input: "Walkthrough + test with 10 real users"
- Expected: "CW is analytical simulation. Real-user testing is different methodology — future user-testing skill."
