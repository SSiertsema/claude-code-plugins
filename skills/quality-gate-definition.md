# Quality Gate Definition — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | quality-gate-definition |
| **Version** | 1.0.0 |
| **Purpose** | Defines enforceable quality gates across the delivery pipeline. Gate stages cover pre-commit, CI on PR (lint + unit + integration + coverage + SAST + SCA), code review (CODEOWNERS + checklist + approver rules + timeliness), security review (for significant or regulated changes), design review (ADR / architecture lead), build + artifact (deterministic + signed + SBOM), staging deploy (smoke + contract), canary (SLO burn + latency), full prod (manual approval for high-risk), post-release verify (+30m / +2h / +24h). Per-gate spec: purpose, trigger, objective pass criteria, fail behavior (block by default — fail closed), automation (full / hybrid / manual), reviewer role (named, not "someone"), timeouts + SLAs, waiver (who + scope + expiry), evidence captured for audit. Risk-profile-aware tightening: low → CI + review + trust-based; medium → add canary + prod manual for riskier; high (payments / auth / regulated) → all gates + explicit approvals + automated audit evidence. Waiver process: written request + rationale, named approver per gate type, ticket + artifact annotation, time-bound expiry, revisit task, periodic volume review as process indicator. Metrics: pass rate / time-in-gate / waiver volume / escape count / flake rate surfaced on dashboards. Sprint exit criteria (distinct from CI gates) for cadence-based delivery. Anti-patterns flagged (approve-what-looks-green reviews, orphaned gates, unbounded waivers, bundled gates, manual spreadsheet gates, hardcoded-single-approver, skip-when-broken). Mermaid pipeline flowchart + waiver state with PNG export. Distinct from DoR/DoD (team agreement) vs gates (enforceable machinery). |
| **Primary category** | `planning` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- New pipeline with gate design
- Existing pipeline audit for gaps or over-gating
- Regulatory uplift requires enforceable gates
- Incident retro pointing to missing gates

## When not to use

- Full CI/CD pipeline design → `cicd-pipeline-design`
- Test strategy → `test-strategy-plan`
- DoR/DoD definition → `definition-of-ready-done`
- Review process mechanics standalone → part of this skill

---

## Required input

| Field | Description |
|---|---|
| **Team / product** | Identifier |
| **Delivery pipeline** | Tooling |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Delivery model** | Trunk / release branch / GitOps / canary | Asked |
| **Risk profile** | Low / medium / high | Asked |
| **Existing gates** | Attach or none | None |
| **Speed vs safety** | Balanced / faster / safer | Balanced |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/quality-gate-definition/` |

## Input schema

```
input:
  required:
    team_product: string
    pipeline: string
  optional:
    delivery_model: string
    risk_profile:
      type: string
      enum: [low, medium, high]
    existing_gates: object
    speed_vs_safety:
      type: string
      enum: [faster, balanced, safer]
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path: string
```

---

## Processing rules

### Phase 1 — Setup
Team, pipeline, model, risk, existing, preference.

### Phase 2 — Gate stages
Map stages to gates.

### Phase 3 — Per-gate spec
Purpose / trigger / criteria / automation / reviewer / waiver / evidence.

### Phase 4 — Typical gate catalog
Reference table.

### Phase 5 — Code review gate
Checklist + approvers + timeliness.

### Phase 6 — Sprint exit criteria
Cadence-based delivery.

### Phase 7 — Risk-profile-aware gating
Tighten or loosen per risk.

### Phase 8 — Waiver process
Request → approve → log → expire → revisit.

### Phase 9 — Metrics + visibility
Pass rate / time-in-gate / waivers / escapes / flakes.

### Phase 10 — Anti-patterns
Catalog + fixes.

### Phase 11 — Diagrams
Pipeline + waiver state.

### Phase 12 — Diagram rendering
Per mixin.

### Phase 13 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Quality Gate Definition: [Team / Product]

**Date**: [date]
**Team**: [...]
**Pipeline**: [...]
**Risk profile**: [...]
**Version**: v1.0

## Scope
## Gate Map
## Per-Gate Specs
## Code Review Process
## Sprint Exit Criteria
## Risk-Profile-Aware Gating
## Waiver Process
## Metrics + Visibility
## Anti-Patterns to Avoid
## Diagrams
## Hand-offs
```

### Diagrams
- **Pipeline gates** — Mermaid `flowchart LR`
- **Waiver flow** — Mermaid `stateDiagram-v2`

---

## Assessment and planning policy

- Per-stage gate justified
- Objective criteria
- Automated where possible
- Manual reviewer role named
- Waiver process traceable + time-bound
- Risk-appropriate tightening
- Metrics in place
- No fabricated policies

---

## Self-check

```
[] Gate per adopted stage
[] Objective criteria
[] Automation vs manual
[] Reviewer role for manual
[] Waiver with expiry
[] Sprint exit (if applicable)
[] Risk-profile tightening
[] Metrics + dashboards
[] Anti-patterns addressed
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No pipeline | Interview mode (§7) |
| Subjective criteria | Replace with objective |
| Unbounded waivers | Require expiry |
| Bundled gate | Split |
| DoR/DoD overlap | Clarify boundary |
| Full pipeline design request | Redirect to `cicd-pipeline-design` |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Every gate has single purpose
- [ ] Criteria programmatically checkable where automated
- [ ] Reviewer role named (not "someone")
- [ ] Waiver chain + evidence captured
- [ ] Risk profile dictates gate density
- [ ] Metrics surfaced + reviewed

---

## Examples

### Normal cases

**1. New team adopting gates**
- Input: Scrum team, GitHub Actions, medium risk
- Expected: Pre-commit + CI on PR + review + staging + canary + prod manual for risky; waiver protocol; review checklist

**2. Regulated product**
- Input: Payments, high risk, auditable
- Expected: All gates + security review + design review for system changes + evidence capture into artifact registry; named approvers per gate

**3. Release-branch delivery**
- Input: Monthly release branch
- Expected: Gates on branch-cut + hotfix exceptions + sprint exit criteria aligned to release cadence

**4. GitOps canary-heavy pipeline**
- Input: Progressive delivery with ArgoCD Rollouts
- Expected: Canary gate on SLO burn; automatic rollback; manual approval only for breaking or regulated releases

**5. Existing gates audit**
- Input: Legacy pipeline with over-gating
- Expected: Bottleneck analysis; propose removals / consolidations; metrics baseline

### Edge cases

**6. Tiny team, low-risk product**
- Expected: Minimal gates (CI + review); explain trade-off; revisit as team grows

**7. Monorepo with varied risk**
- Input: Some services critical, some experimental
- Expected: Per-path CODEOWNERS + gate tightening; not uniform across tree

**8. Incident-driven gate add**
- Input: Retro reveals missing regression gate
- Expected: Add specific gate with pass criteria; attach to RCA follow-up; review effectiveness at 30 days

### Failure cases

**9. No pipeline**
- Input: "Design gates"
- Expected: Interview — pipeline tooling + model

**10. Full pipeline request**
- Input: "Design our CI/CD"
- Expected: Redirect to `cicd-pipeline-design`
