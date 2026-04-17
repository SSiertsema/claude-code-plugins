# Communication Plan — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | communication-plan |
| **Version** | 1.0.0 |
| **Purpose** | Produces a stakeholder communication plan. Communication matrix specifying per audience (exec sponsor / leadership / delivery team / customer-facing teams / external customers beta + GA / partners / regulators / legal + compliance) the purpose + topic + cadence + channel + owner + template. Audience-tailored style + tone (executives: outcomes + risks + asks; leadership: trade-offs + dependencies; team: concrete + actionable; customer: benefits + how-to; regulator: precise + evidenced; partner: technical + predictable). Reporting cadence per audience (daily team standup, weekly team + leadership, biweekly exec 1-pager + customer enablement, monthly program review, quarterly business review). Status-report templates: exec 1-pager (RAG + executive summary + highlights + top risks + asks + metrics snapshot), leadership update (adds scope + deps + decisions), team (daily yesterday/today/blockers + weekly retro theme), customer release notes (what's new + why + how + known issues), regulator report (per regulation via Legal). Dashboard design principles per audience (5–8 metrics exec, SLO + error + queues + on-call for ops, status + uptime + upcoming for customer, four-corners program). Named escalation routes per trigger (S1 on-call → eng lead → exec → customer comms in minutes; schedule slip > 2w PM → leadership → sponsor in 3bd; budget overrun > 10% PM → finance → sponsor in 5bd; scope change PM → sponsor via change-impact; security finding critical → CTO → legal if breach in 24h; regulatory → CEO + board per regulation). Bidirectional feedback loops (office hours, retros, quarterly pulse surveys, listening channels, 1:1 cadence, customer advisory boards, post-incident reviews) with close-the-loop discipline. Crisis / incident comms (speed over polish, single source of truth, named incident commander, regular updates including "no new info", public post-mortem). Tone guidance for sensitive topics (layoffs / reorgs humanely with FAQ + 1:1; security incidents factually + specific; breaking changes with runway + migration; bad news delivered before rumors with path forward). Anti-patterns flagged (narrative essays, one-report-for-all, no-ask-in-exec-update, 30-metric dashboard, escalation-as-failure, solicit-ignore feedback, silent bad news). Mermaid communication flow + S1 escalation tree with PNG export. Hand-offs to `stakeholder-mapping`, `demo-showcase-planning`, `change-impact-assessment`, `training-adoption-planning`, `support-rollback-planning`. |
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

- New project / program comms design
- Incident / crisis comms framework
- Exec reporting setup
- Customer-facing comms structure
- Cross-team coordination establishment

## When not to use

- Stakeholder mapping itself → `stakeholder-mapping`
- Demo / showcase planning → `demo-showcase-planning`
- Training / adoption comms → `training-adoption-planning`
- Support / rollback comms → `support-rollback-planning`

---

## Required input

| Field | Description |
|---|---|
| **Project / program** | Identifier |
| **Stakeholders** | Groups + key individuals |
| **Phase** | Discovery / build / launch / hypercare / run |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Existing practice** | None / ad-hoc / documented | Asked |
| **Constraints** | Regulatory / NDA / tooling | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/communication-plan/` |

## Input schema

```
input:
  required:
    project: string
    stakeholders: array[object]
    phase: string
  optional:
    existing_practice: string
    constraints: array[string]
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
Project, phase, stakeholders, existing, constraints.

### Phase 2 — Communication matrix
Per audience: purpose / topic / cadence / channel / owner / template.

### Phase 3 — Style + tone
Audience-tailored.

### Phase 4 — Reporting cadence
Daily / weekly / biweekly / monthly / quarterly.

### Phase 5 — Status templates
Exec / leadership / team / customer / regulator.

### Phase 6 — Dashboards
5–8 metrics per audience.

### Phase 7 — Escalation
Named routes per trigger.

### Phase 8 — Feedback loops
Bidirectional + close-the-loop.

### Phase 9 — Crisis / incident
Speed + single source + IC + updates + post-mortem.

### Phase 10 — Sensitive topics
Humane + specific + path forward.

### Phase 11 — Anti-patterns
Catalog + fixes.

### Phase 12 — Diagrams
Comm flow + S1 escalation tree.

### Phase 13 — Diagram rendering
Per mixin.

### Phase 14 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Communication Plan: [Project]

**Date**: [date]
**Project**: [...]
**Phase**: [...]
**Version**: v1.0

## Scope
## Communication Matrix
## Per-Audience Style + Tone
## Reporting Cadence
## Status-Report Templates
## Dashboard Design Principles
## Escalation Routes
## Feedback Loops
## Crisis / Incident Communication
## Tone for Sensitive Topics
## Anti-Patterns to Avoid
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Comm flow** — Mermaid `flowchart LR`
- **S1 escalation** — Mermaid `flowchart TD`

---

## Assessment and planning policy

- Audience-first
- Cadence + channel matched
- Templates structured (RAG + highlights + risks + asks)
- Dashboards focused
- Escalation named
- Feedback bidirectional
- Crisis comms preconfigured
- No fabricated stakeholders

---

## Self-check

```
[] Communication matrix
[] Style per audience
[] Cadence matches decision pace
[] Templates per audience
[] Focused dashboards
[] Named escalation
[] Feedback loops closed
[] Crisis comms plan
[] Anti-patterns
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No stakeholders | Interview or `stakeholder-mapping` |
| One-size-fits-all report | Tailor |
| No escalation | Add |
| No feedback loop | Add |
| Demo detail | Redirect |
| Change comms detail | Redirect |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Matrix covers all distinct audiences
- [ ] Cadence calibrated to decision pace
- [ ] Templates ship with example content
- [ ] Escalations have SLA
- [ ] Feedback includes close-the-loop mechanism
- [ ] Dashboards tie to decisions

---

## Examples

### Normal cases

**1. New product launch**
- Expected: 10-row matrix, exec biweekly, customer beta, enablement for support, escalation for launch issues

**2. Multi-team program**
- Expected: Cross-team weekly; program monthly; exec biweekly; RAG + top risks

**3. Regulated product**
- Expected: Regulator reporting cadence per regulation; evidence capture; legal approval chain

**4. Incident comms establishment**
- Expected: S1 tree + status-page + IC role + post-mortem publication policy

**5. Crisis (layoff / reorg)**
- Expected: Humane comms + FAQ + 1:1 slots + path-forward + repeat check-ins

### Edge cases

**6. Remote-only distributed team**
- Expected: Async-first comms + recorded updates + time-zone-aware cadence

**7. External-only audience**
- Input: Largely customer-facing plan
- Expected: Release notes + status page + support + advisory board

**8. Small team, many stakeholders**
- Expected: Consolidated updates; no duplicate reports; calendar hygiene

### Failure cases

**9. No stakeholders**
- Input: "Plan our comms"
- Expected: Interview or hand-off

**10. Demo detail**
- Input: "Plan our demo-day"
- Expected: Redirect to `demo-showcase-planning`
