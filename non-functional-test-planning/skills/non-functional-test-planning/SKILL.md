---
name: non-functional-test-planning
description: Performance + security test plan — load/stress/soak/spike/scalability profiles, SLO-aligned thresholds, SAST/SCA/DAST/IAST/container/IaC scanning, pen-test cadence, authN/authZ tests, threat-model coverage.
argument-hint: "[product + SLOs + risk profile]"
---

# Non-Functional Test Planning (Performance + Security)

You plan how the product's performance + security characteristics are verified. Performance tests prove SLO-related behaviors; security tests prove the system is free of known classes of vulnerability (not "secure" — that's unfalsifiable).

## Core rules

- **Tests align to SLOs / threat model** — not vanity numbers or kitchen-sink scans
- **Workload modeling comes before tool choice** — shape dictates tool
- **Baselines + trending** — single runs prove little; trends reveal regressions
- **Shift-left where possible, shift-right where necessary** — SAST in CI, DAST against running env
- **Not a certified audit / penetration report** — engineering evidence, not assurance
- **Hand off threat modeling proper** to `threat-modeling`
- **No fabricated SLOs / threats** — work from supplied context

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Product + critical flows** | Yes | — |
| **SLO / SLA targets** (latency, availability) | Yes | — |
| **Threat model or security risk profile** | Yes | — |
| **Compliance needs** | No | Asked |
| **Existing tooling** | No | Asked |

## Phase 1 — Setup

```
**Product**: [name]
**Critical flows**: [P0 journeys]
**SLOs**: [e.g., p99 < 300 ms for checkout; 99.9% availability]
**Expected scale**: [req/s baseline + peak + growth forecast]
**Threat model**: [STRIDE / OCTAVE / known assets + actors] (hand off to `threat-modeling`)
**Compliance**: [GDPR / SOC2 / PCI / HIPAA]
**Existing tooling**: [k6 / Gatling / ZAP / Snyk / Semgrep / Trivy / ...]
```

> **Disclaimer**: Not a certified audit or pentest report. Engineering evidence.

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/non-functional-test-planning/`).

---

## Part A — Performance testing

## A.1 Test types

| Type | Purpose | Key question |
|---|---|---|
| **Load** | expected traffic | "does the system meet SLOs under expected load?" |
| **Stress** | beyond capacity | "where does it break? how?" |
| **Soak / endurance** | sustained over time | "does it leak / degrade over hours?" |
| **Spike** | sudden traffic surge | "does it absorb + recover?" |
| **Scalability** | horizontal/vertical scale | "does it scale linearly? where does it stop?" |
| **Volume** | large data | "does it handle large payloads + long lists?" |
| **Breakpoint / capacity** | find max sustainable | "what's the capacity envelope?" |

## A.2 Workload modeling

Build a model from data (analytics, production traces) not assumption:

- **Virtual users / arrival rate** — realistic arrival patterns
- **Scenarios**: weighted by business traffic shares (e.g., 70% browse, 20% add-to-cart, 10% checkout)
- **Think times**: realistic human pauses, not zero
- **Data distribution**: unique vs returning users; warm vs cold cache
- **Ramp-up**: gradual, not instant, unless testing spike
- **Steady state**: time to assert on (e.g., 15 min)
- **Cool-down**: clean shutdown

## A.3 SLO-aligned thresholds

Thresholds derived from SLOs:

| Metric | Threshold |
|---|---|
| p50 latency | < 100 ms |
| p99 latency | < 300 ms |
| Error rate | < 0.1% |
| Throughput | sustained 500 req/s |
| Saturation | CPU < 70%, memory < 80%, connections < 80% |

Tests `pass` when SLO-aligned thresholds hold in steady state.

## A.4 Baseline + trending

- Run baseline on known-good build; record results + config
- Subsequent runs compare vs baseline (± tolerance)
- Graph trends over time in dashboard
- Alert on regression beyond tolerance

## A.5 Tooling

| Tool | When |
|---|---|
| **k6** | Dev-friendly, scripts-as-code, OSS + Grafana Cloud |
| **Gatling** | JVM shops, Scala scripts, strong reporting |
| **Locust** | Python scripts, easy distributed runs |
| **JMeter** | Protocol breadth, non-code teams |
| **Artillery** | Node.js scripts, quick starts |
| **Vegeta** | CLI, API load |
| **Cloud-based** | Azure Load Testing / BlazeMeter / LoadNinja for scale |

Pick one primary for the org. Scripts live in repo + versioned.

## A.6 Environment + data

- **Perf env** separate from staging (hand off to `test-data-management-strategy` for data)
- **Prod-like** — same infra class + region
- **Isolated** — no other load tests running simultaneously
- **Warm caches** before measurement
- **Observability on** — collect metrics + traces during runs

## A.7 Chaos + resilience

- Chaos engineering for resilience (latency injection, pod kill)
- Tools: Gremlin, Chaos Mesh, Litmus, AWS FIS
- Run in staging or prod with blast-radius containment
- Game-day exercises scheduled

Hand off deep chaos design to `disaster-recovery-planning`.

---

## Part B — Security testing

## B.1 Test types + where in the pipeline

| Type | What | Where |
|---|---|---|
| **SAST** | static code analysis | CI on PR |
| **SCA** | vulnerable + license deps | CI on PR + scheduled |
| **Secret scanning** | committed secrets | pre-commit + CI |
| **Container scanning** | base image + packages | build pipeline |
| **IaC scanning** | Terraform / Helm / Kubernetes misconfig | CI on IaC changes |
| **DAST** | dynamic runtime scans | nightly against staging |
| **IAST** | instrumented runtime | within test runs |
| **Fuzzing** | randomized input | continuous on critical surfaces |
| **Penetration testing** | human-led | quarterly / annually / on major change |
| **Red team** | adversarial engagement | annually for high-value targets |

## B.2 Tooling

| Need | Tools |
|---|---|
| SAST | Semgrep / Snyk Code / SonarQube / CodeQL |
| SCA | Snyk / Dependabot / Mend / GitHub Advanced Security |
| Secret | GitLeaks / TruffleHog / GitHub secret scanning |
| Container | Trivy / Snyk / Anchore / Docker Scout |
| IaC | Checkov / tfsec / Kics / Trivy Config |
| DAST | OWASP ZAP / Burp Suite / StackHawk |
| IAST | Contrast / Seeker |
| Fuzzing | libFuzzer / go-fuzz / AFL++ / OSS-Fuzz |
| AuthN/Z | custom tests + OWASP Authorization tests |

## B.3 AuthN / AuthZ testing

- Authentication flows: login + MFA + session timeout + logout + account recovery
- Authorization: RBAC / ABAC matrix validated via test cases per role × resource
- Negative tests: unauthorized access returns 401/403 with no info leak
- Session management: cookie flags (HttpOnly, Secure, SameSite), rotation, revocation

## B.4 Threat-model coverage

For every threat identified in the model, map a test:

| Threat | Test |
|---|---|
| SQL injection | parameterized queries + SAST rules + DAST probes |
| XSS | escape audits + DAST probes |
| CSRF | token presence + automated probes |
| SSRF | allowlist + DAST + manual test |
| Broken auth | AuthN test suite |
| Sensitive data exposure | encryption at rest + in transit audits |
| XXE | SAST rules + fuzzing |
| Deserialization | SAST + fuzzing |
| Known vulns | SCA |
| Insufficient logging | observability + audit-log coverage tests |

Gap: threat without a test → either add test, mitigate by design, or accept with waiver.

## B.5 Dependency risk management

- SCA in CI + scheduled
- Vulnerability SLA (e.g., critical < 7 days, high < 30 days, medium < 90 days)
- License compliance (hand off to `license-compatibility-analysis`)
- Update cadence + automation (Renovate / Dependabot)

## B.6 Penetration testing

- Scope defined (network / application / cloud / social)
- Vendor qualified + NDA in place
- Cadence (annual / on major change)
- Remediation SLAs post-finding
- Retest after fixes

Hand off vendor selection to `vendor-evaluation-matrix`.

## B.7 Bug bounty / responsible disclosure

- security.txt published
- Disclosure policy
- Triage SLA
- Scope + out-of-scope list
- Reward structure if bounty

## B.8 Compliance-aligned testing

Match tests to compliance frameworks:

| Framework | Relevant tests |
|---|---|
| SOC 2 | access control tests, change management evidence, logging + monitoring |
| PCI DSS | cardholder data flow tests, segmentation, quarterly scans |
| HIPAA | PHI access audit, encryption, BAAs |
| GDPR | data subject rights tests (erase / export / rectify), cross-border transfer |
| ISO 27001 | control tests aligned to Annex A |

Evidence capture automated where possible.

---

## Phase C — Combined output

## C.1 Metrics + dashboards

- Perf: p50/p95/p99 per critical flow, error rate, saturation
- Sec: new findings by severity, time-to-remediate, SCA risk score, pentest finding count + age
- Shared: SLO burn dashboard, defect trend

## C.2 Cadence

- Perf: baseline per release; trend weekly; regression on PR for critical flows
- Sec: SAST/SCA/secret/IaC on every PR; DAST nightly; pentest quarterly / annually

## C.3 Roles

- Engineer: writes + maintains tests; triages findings
- Security engineer: tooling + policy + pentest coordination
- SRE / platform: perf env + observability
- PO: prioritizes fixes

## C.4 Diagrams

### Perf test types

```mermaid
xychart-beta
    title "Perf test types (time on X, load on Y — illustrative)"
    x-axis ["Ramp", "Steady", "Peak", "Cool"]
    y-axis "Users" 0 --> 2000
    line [100, 500, 500, 0]
    line [100, 500, 2000, 0]
    line [100, 500, 500, 500]
```

Lines = Load / Spike / Soak (illustrative).

### Security testing in pipeline

```mermaid
flowchart LR
    Dev[Dev] --> PC[pre-commit: secrets]
    PC --> CI[CI: SAST + SCA + IaC]
    CI --> Build[Build + container scan]
    Build --> Stg[Staging]
    Stg --> DAST[Nightly DAST]
    DAST --> Prod[Prod]
    Prod -.quarterly.-> Pen[Pentest]
    Prod -.continuous.-> Fuzz[Fuzzing]
    Prod -.continuous.-> Bug[Bug bounty]
```

## C.5 Diagram rendering

Per `diagram-rendering` mixin.

## C.6 Report assembly and approval

```markdown
# Non-Functional Test Plan: [Product]

**Date**: [date]
**Product**: [...]
**SLOs**: [...]

> Disclaimer: Not a certified audit / pentest report. Engineering evidence.

## Scope

## Performance Testing
### Test Types
### Workload Modeling
### SLO-Aligned Thresholds
### Baseline + Trending
### Tooling
### Environment + Data
### Chaos + Resilience

## Security Testing
### Test Types + Pipeline Placement
### Tooling
### AuthN / AuthZ Tests
### Threat-Model Coverage
### Dependency Risk Management
### Penetration Testing
### Bug Bounty / Responsible Disclosure
### Compliance-Aligned Testing

## Combined Concerns
### Metrics + Dashboards
### Cadence
### Roles

## Diagrams

## Hand-offs
[test-strategy-plan, test-data-management-strategy, threat-modeling, disaster-recovery-planning, license-compatibility-analysis]

## Assumptions & Limitations
```

Present for user approval. Save only after confirmation.

## Assessment + planning rules

- SLOs / threat model drive scope
- Workload modeling before tool
- Baselines + trends
- Pipeline placement per tool type
- Threat-model coverage checked
- Compliance mapped
- Cadence explicit
- Disclaimer present
- Hand-offs listed
- No fabricated SLOs / threats

## Failure behavior

| Situation | Behavior |
|---|---|
| No SLOs / threats | Interview mode (§7) |
| Perf without workload model | Require modeling first |
| "Scan everything" without SLA | Propose vulnerability SLA |
| Threat-model coverage gaps | Flag + recommend `threat-modeling` |
| Pen-test deep-dive | Hand off to vendor selection |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

## Self-check

```
[] SLOs + threat model cited
[] Perf types + workload modeling
[] Thresholds SLO-aligned
[] Baseline + trending
[] Perf tool chosen
[] Security types + pipeline placement
[] Security tools chosen
[] AuthN / AuthZ + threat-model tests mapped
[] Dependency SLA
[] Pen-test cadence
[] Bug-bounty policy
[] Compliance mapped
[] Metrics + dashboards
[] Cadence + roles
[] Disclaimer present
[] Diagrams valid
[] No fabricated SLOs
[] Report follows output contract
```
