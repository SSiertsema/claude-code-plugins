# Test Data Management Strategy — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | test-data-management-strategy |
| **Version** | 1.0.0 |
| **Purpose** | Designs how test data is sourced, protected, flowed between environments, and kept reproducible. Data source strategies: synthetic (factories / faker / domain constraints — preferred default for lower envs), masked/pseudonymized from prod (redact / tokenize / pseudonymize / generalize / noise / synthesis — requires DPA + DPO), curated subset, frozen golden datasets (ML eval / compiler / billing invariants), live third-party sandbox (vendor test keys + recorded fixtures). Core rule: never raw prod PII in any lower environment. Per-environment data matrix across dev / CI / integration / staging / perf / UAT with primary + secondary sources + cadence. Masking techniques per PII class: direct PII pseudonymize/tokenize (email format-preserving, phone), quasi-identifiers generalize (DOB to decade, ZIP truncated), regulated PCI/SSN tokenize via vault (card numbers never leave prod; use test card numbers). Re-identification risk analysis via k-anonymity / l-diversity / differential privacy; documented in DPIA when required. Lifecycle (factory generation with composable overrides, deterministic seeding, idempotent seed scripts, reset via truncate/reseed or transactional rollback, staging refresh pipeline extract→mask→load→smoke). Scale needs for perf testing (deterministic generation at size with seed = config + commit-sha, parallel generators, separate perf env). Reference / master data in repo + migrations. Third-party sandbox policy (recorded fixtures vs live, never prod keys). Tooling options (factory_bot / factory-boy / fishery / Bogus; Delphix / Tonic.ai / Gretel.ai for masking + synthesis; HashiCorp Vault for tokens). Governance (owner + quarterly review + incident process for prod-data-in-lower-env detection). Anti-patterns flagged (raw prod dump, shared mutable test DB, hidden seeds, monolithic golden, eye-masking, perf-in-staging). Metrics (seed time, data-caused flakes, PII incidents target 0, refresh pipeline success + duration, re-id risk score). Disclaimer: not legal advice. Mermaid data-flow + masking-selection with PNG export. Hand-offs to `data-governance-policy`, `non-functional-test-planning`, `test-automation-strategy`. |
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

- New product / feature test-data strategy
- Compliance uplift (GDPR / HIPAA / PCI)
- Incident: PII in lower env detected
- Adopting masking / synthesis tooling

## When not to use

- Overall test strategy → `test-strategy-plan`
- Automation framework → `test-automation-strategy`
- Performance / security test plan → `non-functional-test-planning`
- Data governance policy → `data-governance-policy`

---

## Required input

| Field | Description |
|---|---|
| **Environments** | Dev / CI / integration / staging / perf / UAT |
| **Data classes** | PII / health / financial / proprietary / non-sensitive |
| **Compliance** | GDPR / HIPAA / PCI / sector |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Test levels** | Unit / component / integration / E2E / perf / UAT | Asked |
| **Scale needs** | Baseline + perf sizing | Asked |
| **Existing tooling** | Factories / snapshots / masking | Asked |
| **Current pain** | Flake / leak / slow | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/test-data-management-strategy/` |

## Input schema

```
input:
  required:
    environments: array[string]
    data_classes: array[string]
    compliance: array[string]
  optional:
    test_levels: array[string]
    scale: object
    existing_tooling: array[string]
    current_pain: string
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
Envs, classes, compliance, levels, scale, tooling, pain.

### Phase 2 — Data source strategies
Synthetic / masked / subset / golden / third-party.

### Phase 3 — Per-env data matrix
Primary + secondary per env.

### Phase 4 — Masking techniques
Per field class.

### Phase 5 — Re-identification risk
k-anonymity / l-diversity / DP.

### Phase 6 — Lifecycle
Generate / seed / reset / refresh.

### Phase 7 — Scale
Deterministic perf generation.

### Phase 8 — Reference / master data
Migrations + repo.

### Phase 9 — Third-party sandboxes
Policy + fixtures.

### Phase 10 — Tooling
Options per need.

### Phase 11 — Governance
Owner + review + incident.

### Phase 12 — Anti-patterns
Catalog + fixes.

### Phase 13 — Metrics
Seed time / flakes / incidents / refresh / re-id score.

### Phase 14 — Diagrams
Flow + masking selection.

### Phase 15 — Diagram rendering
Per mixin.

### Phase 16 — Report assembly and approval
Approval before save. Disclaimer included.

---

## Output contract

```markdown
# Test Data Management Strategy: [Product]

**Date**: [date]
**Environments**: [...]
**Data classes**: [...]
**Compliance**: [...]

> Disclaimer: Not legal advice.

## Scope
## Data Source Strategies
## Per-Environment Data Matrix
## Masking Techniques
## Re-Identification Risk
## Lifecycle
## Scale Needs
## Reference / Master Data
## Third-Party Sandboxes
## Tooling
## Governance
## Anti-Patterns to Avoid
## Metrics
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Data flow** — Mermaid `flowchart LR`
- **Masking selection** — Mermaid `flowchart TD`

---

## Assessment and planning policy

- Synthetic-first
- Never raw prod PII in lower envs
- Determinism via seeds
- Re-id risk evaluated
- Reset strategy
- Disclaimer present
- No fabricated claims

---

## Self-check

```
[] Synthetic-first
[] No raw prod PII in lower envs
[] Masking per field class
[] Re-id risk addressed
[] Deterministic seeds
[] Reset per test
[] Refresh pipeline
[] Sandbox policy
[] Tooling chosen
[] Governance
[] Metrics + 0-incidents target
[] Disclaimer
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No compliance context | Interview mode (§7) |
| "Copy prod to staging" | Reject; mask pipeline |
| No PII classification | Require first |
| Re-id risk ignored | Add analysis |
| Legal / DPIA request | Redirect |
| Perf in staging | Separate envs |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Every env has a stated primary source
- [ ] Masking policy per PII class
- [ ] Re-id risk evaluated + documented
- [ ] Seeding deterministic
- [ ] Reset strategy per test level
- [ ] Refresh pipeline monitored
- [ ] Governance ownership named

---

## Examples

### Normal cases

**1. E-commerce product**
- Input: GDPR, PII + card data
- Expected: Synthetic for lower envs; PCI — card numbers never in lower envs, use test numbers; staging masked subset with tokenized emails

**2. Healthcare SaaS**
- Input: HIPAA, PHI
- Expected: Synthetic generation; no masked prod in lower envs beyond tightly-controlled research env; BAA required for any vendor tooling

**3. ML eval**
- Input: Model + golden eval sets
- Expected: Versioned golden datasets; separate train/eval/holdout; seed stability; no PII in eval if present upstream

**4. Perf environment setup**
- Input: 10M-row DB
- Expected: Generated synthetic at size; deterministic seed; separate from staging; index warm-up before measurement

**5. Flake reduction**
- Input: Flaky E2E due to data
- Expected: Per-test transactional isolation; factories with composable overrides; remove shared mutable state

### Edge cases

**6. Refresh pipeline fails masking**
- Expected: Incident response — remove data; rebuild pipeline; DPO informed

**7. AI-synthesized data**
- Input: Using Gretel.ai
- Expected: Evaluate re-id risk + distribution fidelity; document in DPIA

**8. Third-party sandbox rate-limited**
- Expected: Recorded fixtures + contract; fall back to replay when sandbox down

### Failure cases

**9. No PII classification**
- Input: "Mask all strings"
- Expected: Require classification first

**10. Prod dump request**
- Input: "Copy prod DB to dev"
- Expected: Reject; explain risk; propose masked subset pipeline
