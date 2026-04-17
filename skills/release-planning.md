# Release Planning — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | release-planning |
| **Version** | 1.0.0 |
| **Purpose** | Produces a release plan from WBS + estimates + target dates. Selects cadence (continuous / weekly / monthly / release-train / milestone-based / hybrid) driven by risk, user impact, and ops maturity. Allocates WBS work packages to releases with principles: smallest release that makes sense, dependencies respected, risk front-loaded, no all-easy releases when big risks remain. Computes critical path (longest chain of dependent work driving earliest finish), names it, communicates slack for off-CP packages. Buffers explicit (project buffer 15–30% of CP, feeding buffer 10–20%, per-package contingency 30–50% on high-risk, holiday capacity pre-subtracted) with rationale per buffer — no hidden padding. External dependencies + constraints (vendor / legal / partner / change-freeze windows / shared-team availability / launch-day restrictions) listed with owner + needed-by + status. Versioning choice (SemVer library/SDK vs CalVer product) + pre-release + build metadata rules. Freeze calendar (feature freeze / code freeze / release freeze window / dress rehearsal / release day / post-release monitoring). Risk-adjusted scheduling pulls spikes forward to reduce uncertainty on high-risk packages. Mermaid Gantt (with `crit` on CP) + dependency network + milestone timeline with PNG export. Hand-offs to `work-breakdown-structure`, Phase-3 estimation, `api-versioning-strategy`, `support-rollback-planning`, `change-impact-assessment`. |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `professional` |
| **Audience** | `mixed` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Project kickoff scheduling after WBS + estimates
- Re-baselining after scope change
- Quarterly / PI planning input
- Release train planning coordination

## When not to use

- Estimation itself → Phase 3 estimation skills
- WBS → `work-breakdown-structure`
- API versioning policy → `api-versioning-strategy`
- CI/CD pipeline design → `cicd-pipeline-design`
- Risk register → Phase 2 risk skills

---

## Required input

| Field | Description |
|---|---|
| **WBS reference** | Output of `work-breakdown-structure` or package list |
| **Estimates** | Per package |
| **Target dates** | Hard / soft |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Resources** | Team + skills + holidays | Asked |
| **External deps** | Vendor / legal / partner | Asked |
| **Cadence preference** | Continuous / train / milestone | Asked |
| **Versioning** | SemVer / CalVer | Asked |
| **Freeze needs** | Regulated / seasonal | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/release-planning/` |

## Input schema

```
input:
  required:
    wbs_reference: string
    estimates: array[object]
    target_dates: object
  optional:
    resources: object
    external_deps: array[object]
    cadence_preference: string
    versioning:
      type: string
      enum: [semver, calver, hybrid]
    freeze_needs: array[string]
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
WBS, estimates, dates, resources, external deps, cadence preference.

### Phase 2 — Cadence selection
Continuous / weekly / monthly / train / milestone / hybrid.

### Phase 3 — Release allocation
WBS → release with principles.

### Phase 4 — Critical path
Longest dependent chain; slack per off-CP.

### Phase 5 — Buffers + risk
Project / feeding / contingency / leave.

### Phase 6 — Dependencies + constraints
External + freeze windows + shared resources.

### Phase 7 — Versioning
SemVer / CalVer rules.

### Phase 8 — Freezes + dress rehearsals
Calendar.

### Phase 9 — Risk-adjusted scheduling
Spike-to-reduce-uncertainty pattern.

### Phase 10 — Gantt diagram
CP marked `crit`.

### Phase 11 — Dependency network

### Phase 12 — Milestones timeline

### Phase 13 — Diagram rendering
Per mixin.

### Phase 14 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Release Plan: [Project]

**Date**: [date]
**Project**: [...]
**Cadence**: [...]
**Versioning**: [...]
**Horizon**: [next N releases]

## Scope
## Cadence
## Release Allocation
## Critical Path
## Buffers + Risk Adjustment
## External Dependencies + Constraints
## Versioning
## Freezes + Dress Rehearsals
## Risk-Adjusted Scheduling
## Gantt
## Dependency Network
## Milestones Timeline
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Gantt** — Mermaid `gantt` (CP marked `crit`)
- **Dependency network** — Mermaid `graph LR`
- **Milestones** — Mermaid `timeline`

---

## Assessment and planning policy

- Cadence justified
- CP named
- Buffers explicit
- Dependencies listed
- Versioning stated
- Freezes in calendar
- Risk mitigations in schedule
- No fabricated milestones

---

## Self-check

```
[] Cadence chosen + justified
[] WBS → release allocation
[] CP named + slack noted
[] Buffers explicit
[] Dependencies + constraints listed
[] Versioning scheme stated
[] Freezes + dress rehearsals calendar
[] Risk mitigations in schedule
[] Gantt + dependency + milestone diagrams
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No WBS / estimates | Interview mode (§7) or recommend prerequisites |
| Hidden padding | Extract buffers |
| Resource overbooking | Flag + smooth |
| Hard deadline infeasible | Call it out |
| Low-risk-heavy release | Re-sequence |
| API versioning deep-dive | Redirect |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] CP actually longest chain (not approximated)
- [ ] Buffers sized with rationale
- [ ] Resource calendar reflects leave + on-call
- [ ] External deps have owners
- [ ] Freeze windows match product / regulatory reality
- [ ] Versioning choice matches artifact kind

---

## Examples

### Normal cases

**1. Quarterly PI plan for SAFe tribe**
- Input: WBS + estimates + PI dates
- Expected: Release-train cadence; 2-week iterations; hardening sprint; CP across teams

**2. Continuous SaaS with monthly prod cut**
- Input: Trunk-based + monthly regulated release
- Expected: Hybrid cadence; weekly to staging + monthly to prod; freezes for month-end

**3. Mobile app release train**
- Input: Apple / Google review latency
- Expected: Store review buffer; phased rollout; CalVer naming

**4. Regulated product with audit window**
- Input: Year-end audit freeze
- Expected: Freeze calendar dominant; dress rehearsals documented; post-release monitoring window extended

**5. SDK library with SemVer**
- Input: Breaking / additive / patch mix
- Expected: SemVer rules + parallel-support window for consumers; hand-off to `api-versioning-strategy`

### Edge cases

**6. Critical path infeasible for deadline**
- Expected: Call out; propose scope cut + alternatives; refuse to paper over

**7. Resource singleton on CP**
- Input: One specialist holds CP package
- Expected: Flag as risk; recommend knowledge transfer or pair; buffer inflated

**8. External vendor delay**
- Input: Stripe changes delayed
- Expected: Recompute CP; surface risk; buffer proposal or fallback

### Failure cases

**9. No estimates**
- Input: "Plan releases"
- Expected: Interview or recommend estimation first

**10. Implementation request**
- Input: "Plan + execute"
- Expected: "Plan only."
