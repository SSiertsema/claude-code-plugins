# Onboarding Plan — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | onboarding-plan |
| **Version** | 1.0.0 |
| **Purpose** | Designs an onboarding plan for new hires (engineer / designer / PM / SRE / QA). Structured phases: pre-day-1 (laptops + accounts provisioned + calendar + welcome + reading pack + first-ticket identified), day-1 (welcome + manager 1:1 + buddy intro + env up + first small accomplishment), week-1 (shadow meetings + architecture walk + first PR merged + accessibility + security awareness training), month-1 (first feature-sized story + pair with ≥ 3 teammates + test + deployment understanding + 30-day check-in), month-3 (independent ownership + design participation + on-call shadow→primary + 90-day check-in). Separates roles: manager (expectations + career + blockers + performance), buddy (peer day-to-day navigator first 2–4 weeks — NOT the manager), mentor (longer-term technical/career, separate from manager), team (welcoming + context sharing + careful PR review), new hire (asks questions + documents surprises for reverse-feedback). Knowledge scope covers technical (codebase + dev env + test strategy + CI/CD + observability + on-call + security + ADRs), product + customer (who pays + key metrics + recent feedback + roadmap), process + people (cadence + DoR/DoD + on-call + key people + company processes), domain (glossary + invariants + regulatory). First contributions graduated (doc fix → bug → small feature → independent story → owned shipped feature). Feedback loops (buddy check-ins frequent→weekly, manager 1:1 weekly→bi-weekly, 30/60/90 surveys, reverse-onboarding surprises doc shared to team, celebration at onboarding exit). DEI + accessibility (accessible docs/tooling/meetings, plain language, pronunciation + pronouns, inclusive rituals, accommodations honored). Health metrics (time to first PR, time to independent story, time to on-call, 30/60/90 survey scores on confidence/clarity/belonging, retention 6/12mo, buddy participation). Anti-patterns flagged (dropped at desk, unready accounts, hardest-problem-first, buddy=manager, no reverse feedback, no 30/60/90 rhythm, stale wiki). Produces two artifacts: reusable template + per-hire plan. Mermaid timeline + roles-graph with PNG export. Hand-offs to `team-topology-design`, `raci-responsibility-definition`. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `professional` |
| **Audience** | `mixed` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Establishing onboarding for a team with none
- Improving an ad-hoc process
- New hire joining a team within days (per-hire plan)
- Role-specific variant needed (SRE, QA, Designer)

## When not to use

- Team structure itself → `team-topology-design`
- RACI / responsibility matrix → `raci-responsibility-definition`
- Company-level HR policy → HR scope
- Specific training course design → L&D scope

---

## Required input

| Field | Description |
|---|---|
| **Team** | Identifier |
| **Role** | Engineer / designer / PM / SRE / QA |
| **Current onboarding state** | None / ad-hoc / documented |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Hire level** | Junior / mid / senior / staff / manager | Mid (asked) |
| **Work mode** | Remote / hybrid / on-site | Asked |
| **Regulatory context** | HIPAA / SOC2 training | Asked |
| **First project area** | Where they'll contribute | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/onboarding-plan/[role]/` |

## Input schema

```
input:
  required:
    team: string
    role: string
    current_state: string
  optional:
    hire_level: string
    work_mode: string
    regulatory_context: array[string]
    first_project_area: string
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
Team, role, level, mode, current state, regulatory, first area.

### Phase 2 — Timeline phases
Pre-day-1 / day 1 / week 1 / month 1 / month 3.

### Phase 3 — Roles
Manager / buddy / mentor / team / new hire.

### Phase 4 — Knowledge scope
Technical / product / process / domain.

### Phase 5 — First contributions
Graduated difficulty.

### Phase 6 — Checkpoints
Observable evidence.

### Phase 7 — Feedback loops
Buddy / manager / 30-60-90 / reverse.

### Phase 8 — DEI + accessibility
Inclusive by default.

### Phase 9 — Templates
Reusable + per-hire.

### Phase 10 — Health metrics
Time-to-first-PR etc.

### Phase 11 — Anti-patterns
Catalog + fixes.

### Phase 12 — Diagrams
Timeline + roles.

### Phase 13 — Diagram rendering
Per mixin.

### Phase 14 — Report assembly and approval
Two outputs; approval before save.

---

## Output contract

**Two artifacts**:

**A. Reusable template**

```markdown
# Onboarding Template: [Role] on [Team]
v1.0 · Owner: [...]

## Pre-Day-1 Checklist
## Day 1 Agenda
## Week 1 Agenda
## Month 1 Milestones
## Month 3 Milestones
## Roles
## Knowledge Scope
## First-Contribution Graduation
## Feedback Loops
## DEI + Accessibility
## Metrics
## Anti-Patterns
```

**B. Per-hire plan**

```markdown
# Onboarding Plan: [Name] · [Role] · Start [date]

## Pre-Day-1
## Day 1 Schedule
## Week 1
## Month 1 Goals
## Month 3 Goals
## Reading Pack
## Check-in Cadence
## Accommodations
```

### Diagrams
- **Timeline** — Mermaid `timeline`
- **Roles** — Mermaid `graph TD`

---

## Assessment and planning policy

- Phased timeline
- Roles distinct
- Graduated contributions
- 30/60/90 cadence
- DEI + accessibility
- Metrics tracked
- Template + per-hire
- No fabricated norms

---

## Self-check

```
[] Phased timeline pre-day-1 → month-3
[] Manager / buddy / mentor separate
[] Graduated first contributions
[] Knowledge scope 4-dimensional
[] 30/60/90 + reverse-feedback
[] DEI + accessibility
[] Metrics
[] Template + per-hire plan
[] Anti-patterns
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No team / role | Interview mode (§7) |
| "Just give checklist" | Deliver + flag human elements |
| Buddy = manager | Challenge |
| Hardest ticket first | Graduated |
| No checkpoints | Add 30/60/90 |
| Team topology | Redirect |
| RACI | Redirect |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Pre-day-1 IT checklist
- [ ] Observable checkpoints
- [ ] Buddy / mentor / manager clear
- [ ] Graduated first-contributions
- [ ] Reverse-feedback loop
- [ ] Metrics feasible
- [ ] Accommodations process

---

## Examples

### Normal cases

**1. Senior engineer joining growing team**
- Input: Senior, remote, established team
- Expected: Template with emphasis on architecture walk + on-call ramp + design leadership month 3

**2. Junior engineer, first job**
- Input: Junior, hybrid
- Expected: Heavier pair time, longer week-1 doc work, mentor role prominent, pace adjusted

**3. Designer onboarding**
- Input: Designer, existing design system
- Expected: Design-system walk + stakeholder map + Figma access + review norms + DesignOps rituals

**4. PM onboarding**
- Input: PM for a product area
- Expected: Customer research access + roadmap + metrics dashboards + cross-team relationships

**5. Regulated-industry hire**
- Input: Fintech, SOC 2 + anti-fraud training required
- Expected: Regulatory training scheduled week 1; access scoped + audited

### Edge cases

**6. Fully async remote hire in different TZ**
- Expected: Async-first onboarding docs; time-shifted pair sessions; recorded walks

**7. Hire with accessibility need**
- Expected: Accommodations early-captured + honored; accessible doc formats; captioned meetings

**8. Hire inheriting under-documented codebase**
- Expected: Characterization + walk + buddy + pair-heavy first month; update docs as part of onboarding

### Failure cases

**9. No role specified**
- Input: "Create an onboarding plan"
- Expected: Interview — team + role + state

**10. Team-topology question**
- Input: "Design our teams"
- Expected: Redirect to `team-topology-design`
