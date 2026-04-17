# Third-Party API Evaluation — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | third-party-api-evaluation |
| **Version** | 1.0.0 |
| **Purpose** | Evaluates a third-party API against 11 dimensions for integration fit: functional coverage (feature-by-feature vs must-haves), contract stability (versioning policy, deprecation notice, breaking-change history, sandbox), reliability (SLA uptime + scope + credits, public status page, incident RCA quality, MTTR), security (auth model, TLS, SOC 2 Type II / ISO 27001 / PCI DSS / HIPAA BAA / GDPR DPA, pentest availability), rate limits + quotas (per-minute/day/account, burst, 429 + Retry-After), pricing + cost scaling (model, cost at projected volume, cost curve, hidden costs, overage), data residency + GDPR (region, DPA, sub-processors, erasure + export mechanisms, retention), support + docs (quality, SDK coverage, ticket SLA, community), lock-in risk (portability, proprietary features, SDK idioms, contract), exit strategy (migration time + alternatives + abstraction layer), operational fit (timezone, escalation, roadmap transparency). Produces weighted scoring matrix against alternatives (including "build in-house"), risk register with mitigations, proof-of-concept plan (scope + duration + success + exit criteria + cost cap). Hands off to `build-vs-buy-analysis` for TCO when in-house is a serious option. Includes disclaimer: engineering evaluation, not legal/contractual advice. Marks unknowns as `[unknown]` rather than fabricating. Mermaid dimension radar + cost curve with PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `classification` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |
| **Evidence mode** | `required` |

---

## When to use

- Shortlist / final vendor evaluation for an API integration
- Re-evaluating incumbent vendor at renewal
- Build-vs-buy evidence gathering (as input to `build-vs-buy-analysis`)
- PoC scoping

## When not to use

- Broker selection → `message-broker-selection`
- API style selection → `api-design`
- Full TCO build-vs-buy → `build-vs-buy-analysis`
- Legal / contractual advice → out of scope

---

## Required input

| Field | Description |
|---|---|
| **API / vendor** | Name + product |
| **Use case** | What we need it for |
| **Volume forecast** | Req/month + data volume |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Alternatives** | Competing options | Asked |
| **Must-have features** | Functional non-negotiables | Asked |
| **Regulatory context** | GDPR / HIPAA / PCI / sector | Asked |
| **Budget envelope** | Monthly ballpark | Asked |
| **Decision timeframe** | When | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/third-party-api-evaluation/` |

## Input schema

```
input:
  required:
    vendor: string
    use_case: string
    volume_forecast: object
  optional:
    alternatives: array[string]
    must_have_features: array[string]
    regulatory_context: array[string]
    budget_envelope: string
    decision_timeframe: string
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
Vendor, use case, volume, alternatives, regulatory, budget, timeframe.

### Phase 2 — Evaluation dimensions
11 dimensions covered with evidence.

### Phase 3 — Scoring matrix
1–5 per dimension per candidate, weighted.

### Phase 4 — Risk register
Likelihood / impact / mitigation.

### Phase 5 — PoC plan
Scope + duration + success + exit + cost cap.

### Phase 6 — Build-vs-buy handoff
If applicable.

### Phase 7 — Recommendation
Choice + rationale + trade-offs + top risks + exit.

### Phase 8 — Diagrams
Dimension radar + cost curve.

### Phase 9 — Diagram rendering
Per mixin.

### Phase 10 — Report assembly and approval
Approval before save. Disclaimer included.

---

## Output contract

```markdown
# Third-Party API Evaluation: [Vendor(s)]

**Date**: [date]
**Use case**: [...]
**Recommended**: [...]

> Not legal or contractual advice.

## Scope
## Evaluation Dimensions
## Scoring Matrix
## Risk Register
## Proof-of-Concept Plan
## Recommendation
## Diagrams
## Assumptions & Limitations
```

### Diagrams
- **Dimension radar** — Mermaid `xychart-beta`
- **Cost curve** — Mermaid `xychart-beta`

---

## Assessment and planning policy

- Use case drives evaluation
- Every dimension scored or `[unknown]`
- Lock-in + exit explicit
- Risks with mitigations
- PoC plan if pending
- Not legal advice
- No fabricated data

---

## Self-check

```
[] Use case + volume declared
[] 11 dimensions covered or [unknown]
[] Scoring matrix with weights
[] Risk register with mitigations
[] PoC plan if applicable
[] Exit strategy explicit
[] Disclaimer present
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No use case | Interview mode (§7) |
| Vendor marketing as fact | Replace with evidence or `[unknown]` |
| Missing alternatives | Ask before scoring |
| Regulatory context unknown | Ask — critical for DPA |
| Legal advice request | Out of scope — engineering only |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Every claim cites evidence or is marked `[unknown]`
- [ ] Dimensions all covered
- [ ] Weights justified
- [ ] Risks have mitigations
- [ ] Exit strategy has migration time estimate
- [ ] Disclaimer present

---

## Examples

### Normal cases

**1. Payment gateway evaluation (Stripe vs Adyen)**
- Input: Payments use case, 500k txn/mo, EU
- Expected: Functional parity + pricing-at-volume comparison; PCI coverage + DPA + EU residency details; lock-in notes; PoC on checkout flow

**2. Identity provider (Auth0 vs Okta vs Cognito)**
- Input: Auth for SaaS, 50k MAU
- Expected: Per-MAU cost curve; SDK coverage; migration path if leaving (user export fidelity); SOC 2 + GDPR DPA

**3. Email delivery (SendGrid vs Postmark vs SES)**
- Input: 10M emails/mo, EU residency
- Expected: Deliverability benchmarks; regional IP options; bounce/complaint webhook quality; lock-in low (SMTP portable)

**4. Geocoding API (Google vs Mapbox vs HERE)**
- Input: 2M requests/mo, global
- Expected: Coverage differences per region; TOS restrictions; pricing tiers; caching constraints

**5. Search-as-a-service (Algolia vs Elastic Cloud vs Meilisearch Cloud)**
- Input: Product catalog search, 1M records
- Expected: Index + query model fit; per-record pricing; lock-in of ranking features; exit = re-index to alternative

### Edge cases

**6. Vendor claims 99.99% but no status page**
- Expected: Mark reliability `[unverified]`; surface as risk

**7. Regulatory mismatch (US-only vendor for EU data)**
- Expected: Flag data residency as blocker; recommend EU-region alternative or DPO review

**8. Build-in-house emerges as serious option**
- Expected: Hand off to `build-vs-buy-analysis` for full TCO

### Failure cases

**9. No use case**
- Input: "Evaluate this API"
- Expected: Interview — what's it for, volume, alternatives

**10. Legal advice request**
- Input: "Is the contract enforceable?"
- Expected: "Engineering evaluation only; legal review separate."
