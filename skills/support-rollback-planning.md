# Support + Rollback Planning — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | support-rollback-planning |
| **Version** | 1.0.0 |
| **Purpose** | Plans two tightly-linked post-launch capabilities. Support model: tiers L1/L2/L3 with distinct scope + tools + entry/exit criteria + backup + training; coverage (business hours vs 24x5 follow-the-sun vs 24x7) with humane rotation (≤1 week, shadow before primary, fair rotation, compensation, PagerDuty ack-or-escalate); escalation paths L1→L2→L3→Eng lead→CTO with severity × SLA matrix (S1 <15min/<4h + exec + status page; S2 <1bd/<5bd; S3 <3bd/next release; S4 backlog); hypercare window (1–4 weeks per risk, dedicated rotation + named DRI, tightened SLAs, daily stand-ups, explicit exit criteria); runbook coverage per alert (symptom + detection + triage + mitigations + escalation + rollback guidance) as launch-readiness gate; customer comms via status page + in-product banners + proactive email + post-incident review. Rollback strategy: path per deployment model (feature flag flip fastest, canary halt+reverse, blue-green swap, rolling redeploy, big-bang slowest, data migration compensating actions); automated triggers (SLO burn > threshold, latency regression > X%, canary health failure, feature-flag kill switch) + manual (customer impact escalation, executive call for regulatory/reputational); rehearsal end-to-end in staging with MTTR measurement + data consistency verification; rollback communication within 5 min of decision (status page + incident channel + customer + exec); post-rollback actions (verify → blameless RCA → fix-forward vs abandon → runbook update → PIR → customer post-mortem for S1). Progressive delivery integration with health gates + auto-halt + targeted flag rollback (segment/region). Non-reversible changes (published comms, destroying migrations, contracts) flagged with compensating controls + Plan B written pre-launch + longer hypercare. Launch-readiness checklist + roles matrix across pre-launch / hypercare / steady-state. Distinct from `disaster-recovery-planning` (infra / data loss) and `system-error-handling-strategy` (runtime error classes). Mermaid support escalation + rollback decision-flow with PNG export. Hand-offs to `cicd-pipeline-design`, `disaster-recovery-planning`, `change-impact-assessment`, `communication-plan`. |
| **Primary category** | `planning` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `professional` |
| **Audience** | `mixed` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Pre-launch readiness for a significant change
- Support model establishment post-growth
- Hypercare framework for high-risk release
- Rollback capability uplift

## When not to use

- Infrastructure DR → `disaster-recovery-planning`
- Runtime error strategy → `system-error-handling-strategy`
- Change impact analysis → `change-impact-assessment`
- Communication detail → `communication-plan`

---

## Required input

| Field | Description |
|---|---|
| **Launch** | Feature / change |
| **SLOs** | Availability + latency + business |
| **Risk profile** | Low / medium / high |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Deployment strategy** | Canary / blue-green / rolling / big-bang / feature-flag | Asked |
| **Existing support** | Structure + on-call | Asked |
| **Hypercare window** | Expected duration | Asked |
| **Regulatory** | GDPR / SOC2 / PCI | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/support-rollback-planning/` |

## Input schema

```
input:
  required:
    launch: string
    slos: object
    risk_profile:
      type: string
      enum: [low, medium, high]
  optional:
    deployment_strategy: string
    existing_support: object
    hypercare_window: string
    regulatory: array[string]
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
Launch, strategy, SLOs, risk, existing, hypercare, regulatory.

### Phase A — Support model

A.1 Tiers / A.2 Coverage + rotation / A.3 Escalation + SLAs / A.4 Hypercare / A.5 Runbooks / A.6 Customer comms.

### Phase B — Rollback

B.1 Path per model / B.2 Triggers / B.3 Rehearsal / B.4 Communication / B.5 Post-rollback / B.6 Progressive delivery / B.7 Non-reversible.

### Phase C — Combined

C.1 Launch-readiness / C.2 Roles / C.3 Diagrams / C.4 Rendering / C.5 Assembly + approval.

---

## Output contract

```markdown
# Support + Rollback Plan: [Launch]

**Date**: [date]
**Launch**: [...]
**Deployment strategy**: [...]
**Risk**: [...]

## Scope

## Support Model
### Tiers + Coverage + Rotation
### Escalation + SLAs
### Hypercare Window
### Runbook Coverage
### Customer Comms in Support

## Rollback Strategy
### Path per Deployment Model
### Triggers
### Rehearsal
### Rollback Communication
### Post-Rollback Actions
### Progressive Delivery
### Non-Reversible + Compensating

## Combined
### Launch-Readiness Checklist
### Roles
### Diagrams
### Hand-offs
### Assumptions & Limitations
```

### Diagrams
- **Support escalation** — Mermaid `flowchart LR`
- **Rollback decision** — Mermaid `flowchart TD`

---

## Assessment and planning policy

- Rollback rehearsed
- Triggers explicit + automated
- Runbooks per alert
- Tiers distinct
- Hypercare staffed + time-boxed
- Non-reversible flagged
- Distinct from DR
- No fabricated SLAs

---

## Self-check

```
[] Deployment strategy + rollback path
[] Triggers defined
[] Rehearsed + MTTR measured
[] Runbook per alert
[] Tiers + coverage + SLAs
[] On-call rotation
[] Hypercare + DRI + exit
[] Comms templates
[] Non-reversible flagged
[] Roles documented
[] Launch-readiness checklist
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No SLOs | Interview mode (§7) |
| No rehearsal | Require before launch |
| Assumed one-click not wired | Require wiring |
| Tiers collapsed | Require separation |
| DR scope | Redirect |
| System errors | Redirect |
| Change impact | Redirect |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Rollback MTTR measured in rehearsal
- [ ] Triggers automated where possible
- [ ] Runbook per alert linked
- [ ] SLA bands realistic
- [ ] On-call rotation humane
- [ ] Hypercare exit criteria measurable
- [ ] Non-reversible compensating plan written

---

## Examples

### Normal cases

**1. Canary rollout of payment flow**
- Expected: Auto-halt on error-rate; 2-week hypercare; runbooks; status-page templates; MTTR < 5 min rehearsed

**2. Feature flag rollout**
- Expected: Flag off = instant rollback; segment-targeted; monitoring gates between %

**3. Data migration**
- Expected: Dual-write + parallel run + compensating actions; plan B written; extended hypercare

**4. Big-bang release (legacy)**
- Expected: Blue-green preferred; redeploy-previous rehearsed; hypercare 4 weeks; exec escalation path clear

**5. Mobile-app release**
- Expected: Phased store rollout; server-side kill switches; feature flags for client-gated; staged rollback

### Edge cases

**6. Non-reversible publication**
- Input: API deprecation announcement already sent
- Expected: Compensating comms + plan B; longer hypercare

**7. On-call fatigue**
- Input: Existing team overloaded
- Expected: Flag capacity; augment with hypercare rotation; avoid 24x7 where 24x5 sufficient

**8. Multi-region rollback complexity**
- Expected: Regional feature flags + per-region canary; regional comms

### Failure cases

**9. No SLOs**
- Input: "Plan support"
- Expected: Interview — SLOs + risk + launch

**10. DR request**
- Input: "Plan disaster recovery"
- Expected: Redirect
