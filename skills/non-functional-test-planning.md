# Non-Functional Test Planning — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | non-functional-test-planning |
| **Version** | 1.0.0 |
| **Purpose** | Plans non-functional tests: performance + security. Performance covers test types (load / stress / soak-endurance / spike / scalability / volume / breakpoint-capacity) with workload modeling from actual analytics (virtual users + arrival rate + scenarios weighted by business traffic + realistic think times + data distribution + ramp-up + steady-state assertion window + cool-down). SLO-aligned thresholds (p50/p99 latency, error rate, throughput, saturation). Baselines + trending with regression alerts. Tool selection (k6 / Gatling / Locust / JMeter / Artillery / Vegeta / cloud-based). Isolated prod-like perf environment; warm caches; observability on. Optional chaos engineering (latency injection / pod kill via Gremlin / Chaos Mesh / Litmus / AWS FIS) with blast-radius containment; hand-off to `disaster-recovery-planning`. Security covers SAST + SCA + secret scanning + container + IaC scanning at CI (shift-left), DAST + IAST against running env (shift-right), fuzzing on critical surfaces, penetration testing quarterly / on major change, red-team annually for high-value targets. Tool-per-need (Semgrep / Snyk Code / CodeQL SAST; Snyk / Dependabot SCA; GitLeaks / TruffleHog secrets; Trivy container + IaC; ZAP / Burp / StackHawk DAST; Contrast IAST; libFuzzer / OSS-Fuzz; custom + OWASP authorization tests). AuthN/Z tests (login + MFA + session + logout + recovery; RBAC/ABAC role×resource matrix with negative tests + session management). Threat-model coverage check (per STRIDE threat: map a test or mitigate-by-design or waiver). Dependency risk (SCA with vulnerability SLA — critical 7d, high 30d, medium 90d + license hand-off to `license-compatibility-analysis`). Pen-test scope + vendor qualification + remediation SLA + retest. Bug bounty / responsible disclosure (security.txt + scope + triage SLA + rewards). Compliance-aligned tests (SOC 2 access control + change management; PCI cardholder flow + segmentation + quarterly scans; HIPAA PHI + BAA; GDPR data subject rights; ISO 27001 Annex A controls). Metrics (perf p50/p99/error/saturation; sec new findings + time-to-remediate + pentest age). Cadence (perf baseline per release + trend weekly + regression on PR; sec SAST/SCA/secret/IaC per PR + DAST nightly + pentest quarterly/annual). Includes disclaimer: not a certified audit / pentest report. Mermaid perf-types chart + security-in-pipeline with PNG export. Hand-offs to `test-strategy-plan`, `test-data-management-strategy`, `threat-modeling`, `disaster-recovery-planning`, `license-compatibility-analysis`, `vendor-evaluation-matrix`. |
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

- New product with SLO + threat-model ready
- Performance regression prevention setup
- Security testing uplift / compliance driver
- Pre-pentest scoping
- Pre-release readiness

## When not to use

- Overall test strategy → `test-strategy-plan`
- Automation → `test-automation-strategy`
- Test data → `test-data-management-strategy`
- Threat modeling itself → `threat-modeling`
- DR plan → `disaster-recovery-planning`

---

## Required input

| Field | Description |
|---|---|
| **Product + critical flows** | P0 journeys |
| **SLOs / SLAs** | Latency + availability |
| **Threat model / security risk profile** | Assets + actors + threats |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Compliance** | SOC2 / PCI / HIPAA / GDPR | Asked |
| **Existing tooling** | k6 / Snyk / ZAP | Asked |
| **Scale forecast** | Baseline + peak + growth | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/non-functional-test-planning/` |

## Input schema

```
input:
  required:
    product: string
    critical_flows: array[string]
    slos: object
    threat_model_ref: string
  optional:
    compliance: array[string]
    existing_tooling: array[string]
    scale_forecast: object
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
Product, flows, SLOs, threat model, compliance, tooling, scale.

### Phase A — Performance

A.1 Test types / A.2 Workload modeling / A.3 Thresholds / A.4 Baseline+trending / A.5 Tooling / A.6 Env+data / A.7 Chaos+resilience.

### Phase B — Security

B.1 Types+pipeline / B.2 Tooling / B.3 AuthN/Z / B.4 Threat-model coverage / B.5 Dependency risk / B.6 Pentest / B.7 Bug bounty / B.8 Compliance-aligned.

### Phase C — Combined

C.1 Metrics / C.2 Cadence / C.3 Roles / C.4 Diagrams / C.5 Diagram rendering / C.6 Report assembly + approval.

---

## Output contract

```markdown
# Non-Functional Test Plan: [Product]

**Date**: [date]
**Product**: [...]
**SLOs**: [...]

> Disclaimer: Not a certified audit or pentest report.

## Scope

## Performance Testing
### Test Types / Workload Modeling / Thresholds / Baseline + Trending / Tooling / Env / Chaos

## Security Testing
### Test Types + Pipeline / Tooling / AuthN-Z / Threat-Model Coverage / Dependency Risk / Pentest / Bug Bounty / Compliance

## Combined
### Metrics / Cadence / Roles

## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Perf test types** — Mermaid `xychart-beta`
- **Security in pipeline** — Mermaid `flowchart LR`

---

## Assessment and planning policy

- SLOs / threats drive scope
- Workload before tool
- Baselines + trends
- Pipeline placement per tool
- Threat-model coverage
- Compliance mapped
- Cadence explicit
- Disclaimer
- Hand-offs
- No fabricated SLOs / threats

---

## Self-check

```
[] SLOs + threat model cited
[] Perf types + workload
[] Thresholds SLO-aligned
[] Baseline + trending
[] Perf tool
[] Security types + pipeline
[] Security tools
[] AuthN/Z tests
[] Threat-model coverage
[] Dep SLA
[] Pen-test cadence
[] Bug-bounty
[] Compliance mapped
[] Cadence + roles
[] Disclaimer
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No SLOs / threats | Interview mode (§7) |
| Perf without workload | Require modeling |
| "Scan everything" | Propose vuln SLA |
| Threat-model gaps | Hand off to `threat-modeling` |
| Pen-test deep-dive | Hand off to vendor selection |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation | Out of scope |

---

## Quality checks

- [ ] Thresholds trace to SLOs
- [ ] Workload model based on data
- [ ] Trend dashboards exist
- [ ] Every threat has a test (or waiver)
- [ ] Vuln SLA per severity
- [ ] Pen-test scope + vendor process defined
- [ ] Compliance tests mapped per framework

---

## Examples

### Normal cases

**1. B2C SaaS performance**
- Input: 500 rps baseline, 99.9% availability
- Expected: k6 scripts in repo; workload model from analytics; soak + spike + load; trend dashboards

**2. Payments compliance**
- Input: PCI DSS
- Expected: SAST + SCA + secret + IaC + DAST nightly; quarterly ASV + annual pentest; segmentation tests; cardholder data tests

**3. Healthcare SaaS**
- Input: HIPAA
- Expected: PHI access tests; BAA checked; encryption audits; annual pentest with HIPAA-aware scope

**4. Spike-readiness**
- Input: Upcoming Black Friday
- Expected: Spike tests + autoscale verification; capacity headroom; chaos dress rehearsal

**5. New product gate before GA**
- Input: Launch-readiness
- Expected: All perf + sec gates green; baselines set; exit criteria defined

### Edge cases

**6. Chaos in production**
- Input: Want game-day
- Expected: Blast-radius-limited; kill-switch; hand-off to `disaster-recovery-planning`

**7. Legacy app with no SLOs**
- Expected: Derive working SLOs from current behavior + stakeholder interviews; baseline first

**8. AI-assisted testing**
- Input: Using AI fuzzer
- Expected: Deterministic seed; human review of findings; avoid false-positive explosion

### Failure cases

**9. No SLOs / threats**
- Input: "Add perf + security tests"
- Expected: Interview — SLOs + threat model needed

**10. Certified audit claim**
- Input: "Write our audit report"
- Expected: Decline — engineering evidence only; audit assurance requires qualified auditor
