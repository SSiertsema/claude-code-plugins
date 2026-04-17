# Heuristic Evaluation — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | heuristic-evaluation |
| **Version** | 1.0.0 |
| **Purpose** | Evaluates a UI (wireframe / product surface / prototype described in text) against a declared heuristic set — Nielsen's 10 by default, alternates supported (Norman, Shneiderman, mobile-specific, accessibility-derived, conversational UI, custom). For every heuristic, produces either a finding (violation, insufficient-detail, or no-issue) or a "no issue" verdict with rationale. Per finding: stable ID, heuristic violated, precise location, observation, Nielsen severity (0–4: not-a-problem / cosmetic / minor / major / catastrophic), impact on user experience, evidence quoted from description, concrete recommendation, and effort estimate. Supports single-evaluator autonomous mode (default) and multi-evaluator aggregation (user supplies N evaluator outputs; skill deduplicates, reconciles severity via configurable mode, computes confidence). Prioritizes findings across top-10 / quick-wins / strategic / parking-lot lists. Mermaid severity distribution, findings-by-heuristic bar chart, and severity × effort priority quadrant with PNG export. |
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

- Formal usability review before user testing (cheaper screen for known issues)
- Audit of an existing UI against usability principles
- Input to prioritization / roadmap for UX debt reduction
- Pre-handoff check (design → engineering)
- Multi-evaluator aggregation in a team review

## When not to use

- Gestalt perceptual evaluation only → `gestalt-principle-application`
- Task-based walkthrough (novice user simulation) → `cognitive-walkthrough`
- Accessibility conformance audit → `accessibility-requirements`
- User research with real users → future user-testing skills
- Visual design review only — use in combination with visual/UI skills

---

## Required input

| Field | Description |
|---|---|
| **Subject** | UI / wireframe / product surface |
| **Description** | Text description, wireframe, or structured UI spec |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Heuristic set** | Nielsen / Norman / Shneiderman / mobile / a11y / custom | Nielsen's 10 |
| **Mode** | single-evaluator / multi-evaluator-aggregation | single-evaluator |
| **Evaluator inputs** | Required if mode = multi-evaluator | — |
| **Reconciliation mode** | median / max / consensus | median |
| **Context** | User segment, platform, task | Elicit |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/heuristic-evaluation/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    description:
      type: string | document_reference
  optional:
    heuristic_set:
      type: string
      enum: [nielsen-10, norman, shneiderman-8, mobile, a11y, conversational, custom]
      default: nielsen-10
    mode:
      type: string
      enum: [single-evaluator, multi-evaluator-aggregation]
      default: single-evaluator
    evaluator_inputs: list[document_reference]
    reconciliation_mode:
      type: string
      enum: [median, max, consensus]
      default: median
    context:
      type: object
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
Collect subject + description + heuristic set + mode.

### Phase 2 — Heuristic set selection
Load selected set; custom sets accept user-supplied rules.

### Phase 3 — Per-heuristic review
Finding or no-issue or insufficient-detail per heuristic.

### Phase 4 — Nielsen severity
0–4 scale, applied strictly.

### Phase 5 — Multi-evaluator aggregation (conditional)
Deduplicate, reconcile severity, compute confidence.

### Phase 6 — Prioritization
Top 10 / quick wins / strategic / parking lot.

### Phase 7 — Summary by heuristic
Coverage matrix + worst-severity.

### Phase 8 — Diagrams
Severity distribution pie, findings-per-heuristic bar, priority quadrant.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Heuristic Evaluation: [Subject]

**Date**: [date]
**Heuristic set**: [set]
**Mode**: [mode]
**Context**: [context]

## Scope
[Subject, description source, heuristic set, mode, context]

## Heuristic Set
[Applied heuristics]

## Findings
[Full table]

## Summary by Heuristic
[Coverage matrix]

## Severity Distribution
[Diagram + counts]

## Prioritization
[Top 10 / Quick wins / Strategic / Parking lot]

## Multi-evaluator Aggregation
[If applicable: dedup + reconciliation + confidence]

## Diagrams
[Severity + per-heuristic + priority]

## Limitations
[Description gaps, `Insufficient-detail`, blindspots]
```

### Diagrams

- **Severity distribution** — Mermaid `pie`
- **Findings per heuristic** — Mermaid `xychart-beta`
- **Priority matrix (severity × effort)** — Mermaid `quadrantChart`

---

## Assessment + extraction policy

- Per-heuristic verdict (violation / no-issue / insufficient-detail)
- Nielsen 0–4 severity strict
- Every finding cites location + evidence
- Concrete recommendations
- Deterministic

---

## Self-check

```
[] Heuristic set declared
[] Every heuristic addressed
[] Findings have ID / location / severity / evidence / recommendation / effort
[] Severity from 0–4 scale, not inflated
[] Concrete recommendations
[] Summary by heuristic
[] Prioritization with 4 buckets
[] Multi-evaluator reconciliation if applicable
[] Diagrams valid
[] No fabricated findings
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No description | Interview mode (§7) |
| Description sparse | Per heuristic: `Insufficient-detail` + what's needed |
| Image-only input | Decline — text only |
| Custom set | Accept user-supplied rules |
| Multi-evaluator conflicts | Surface, use reconciliation mode |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope ("fix it") | "Evaluation only; fixing is implementation." |

---

## Quality checks

- [ ] Heuristic set declared
- [ ] Per-heuristic verdict
- [ ] Complete finding metadata
- [ ] Severity strict
- [ ] Prioritization buckets
- [ ] Diagrams valid
- [ ] No fabrication

---

## Examples

### Normal cases

**1. E-commerce checkout review**
- Input: Checkout flow described in text
- Expected: H5 (error prevention) finds missing inline validation — Severity 3; H9 (error recovery) finds cryptic error copy — Severity 3; H4 (consistency) finds inconsistent button labels — Severity 2; H1 (status visibility) finds no progress indicator between pages — Severity 3. Top 10 lists all. Quick wins: inline validation + copy rewrite.

**2. Dashboard UI**
- Input: B2B analytics dashboard
- Expected: H8 (minimalist) finds cluttered sidebar — Severity 2; H6 (recognition) finds abbreviations without tooltips — Severity 3; H7 (flexibility) finds no keyboard shortcuts — Severity 2. Multiple H-heuristics addressable via settings panel refactor.

**3. Mobile app with mobile set**
- Input: Mobile expense app + mobile heuristic set
- Expected: Thumb-reachability violated on primary CTA placement — Severity 3; gesture discoverability issue on swipe-to-delete — Severity 2; offline grace not addressed — Severity 3.

**4. Multi-evaluator aggregation**
- Input: 4 evaluators' findings for a signup flow
- Expected: 23 unique findings after dedup; 8 confirmed by ≥3 evaluators (high confidence); median severity applied; coverage = 6/10 heuristics with ≥2 evaluator overlap.

**5. Accessibility-heuristic cross-check**
- Input: Product page with a11y heuristic set
- Expected: Perceivable violations (contrast, missing alt text); operable (keyboard trap); understandable (jargon in labels); robust (invalid HTML). Cross-ref to `accessibility-requirements` for WCAG conformance.

### Edge cases

**6. All heuristics "no issue"**
- Input: Well-designed, detailed spec
- Expected: Report each heuristic with "No issue found — [rationale]"; 0 findings is valid output; recommendation: proceed to user testing.

**7. Description mostly insufficient**
- Input: 2-sentence description
- Expected: 8 of 10 heuristics `Insufficient-detail`; list what specific info is needed; recommend richer description or wireframe.

**8. Expert accelerator conflict with novice usability**
- Input: Power-user dashboard with many keyboard shortcuts, little visual affordance
- Expected: H7 (flexibility) well-satisfied; H6 (recognition) violated — Severity 3 for new users, acceptable for experts. Recommend progressive disclosure (link to `progressive-disclosure-planning`).

### Failure cases

**9. No subject / description**
- Input: "Do a heuristic eval"
- Expected: Interview — "Which subject, and what's the description?"

**10. Out of scope**
- Input: "Evaluate and implement the fixes"
- Expected: "Evaluation only; fixes are engineering / design work."
