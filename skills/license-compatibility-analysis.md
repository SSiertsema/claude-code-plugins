# License Compatibility Analysis — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | license-compatibility-analysis |
| **Version** | 1.0.0 |
| **Purpose** | Produces an engineering/compliance artifact analyzing open-source + third-party licenses in a codebase for compatibility with the intended distribution model (SaaS / on-prem binary / SDK / CLI / mobile app / AI model weights). Inventories direct + transitive dependencies via ecosystem-appropriate tools (npm+licensee, pip-licenses, go-licenses, mvn license plugin, cargo-deny, nuget-license, Syft for multi-ecosystem SBOM). Classifies licenses into categories: permissive (MIT / BSD / Apache-2.0 / ISC), weak copyleft (LGPL / MPL-2.0 / EPL-2.0), strong copyleft (GPL-2.0/3.0), network copyleft (AGPL-3.0 / SSPL), source-available non-OSS (BSL 1.1 / Elastic v2), Creative Commons, public-domain/CC0, proprietary EULAs, dual/multi-licensed, unknown/missing. Uses SPDX identifiers. Applies a simplified compatibility matrix against project license + distribution reach. AGPL/SSPL distinguished from GPL (network trigger). Documents attribution + NOTICE obligations per license. AI model + data license specifics (Llama Community License, Gemma Terms, OpenRAIL, CC-BY-NC datasets) when weights/datasets ship. Patent grant differences (Apache patent grant + retaliation; MIT/BSD silent). Commercial + redistribution restrictions (BSL competitive use, SSPL service offering, trademark clauses). Per-finding risk rating (Clear / Obligation / Review / Block) with remediation options (replace, isolate via process boundary, commercial license, accept copyleft, remove). SBOM (CycloneDX / SPDX) referenced for audit. Includes prominent "Not legal advice — counsel review required" disclaimer. Mermaid class-distribution pie + ratings chart with PNG export. |
| **Primary category** | `assessment` |
| **Secondary category** | `classification` |
| **Output mode** | `human_readable` |
| **Tone** | `professional` |
| **Audience** | `mixed` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |
| **Evidence mode** | `required` |

---

## When to use

- Pre-release license audit
- Dependency-update review
- New dependency adoption review
- SBOM generation + compliance preparation
- Build-vs-buy vs OSS-use decisions

## When not to use

- Legal contractual interpretation → counsel
- Security vulnerability scanning → security skills / SCA tools
- Full procurement process → vendor / procurement skills
- Trademark / brand usage → legal counsel

---

## Required input

| Field | Description |
|---|---|
| **Codebase / project** | Repo or artifact |
| **Distribution model** | SaaS / on-prem / SDK / CLI / app / model weights |
| **Intended project license** | MIT / Apache / BSL / proprietary / ... |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Commercial use** | Yes / no | Commercial (asked) |
| **SBOM / manifest** | Existing file reference | Discover |
| **Ecosystems** | Languages / package managers | Discover |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/license-compatibility/` |

## Input schema

```
input:
  required:
    codebase: string
    distribution_model:
      type: string
      enum: [saas, on-prem-binary, sdk-library, cli, mobile-app, model-weights, mixed]
    project_license: string
  optional:
    commercial_use: boolean
    sbom: string
    ecosystems: array[string]
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
Codebase, distribution, commercial, target audience, reach, SBOM.

### Phase 2 — Dependency inventory
Ecosystem-appropriate tooling; or use supplied SBOM.

### Phase 3 — License classification
SPDX identifiers; 10 classes.

### Phase 4 — Compatibility matrix
Simplified; project license × distribution × dep license.

### Phase 5 — Per-dep findings
Risk rating + action.

### Phase 6 — AI model + data licenses
When applicable.

### Phase 7 — Attribution + NOTICE
Obligations per license.

### Phase 8 — Patent grants
Per license.

### Phase 9 — Commercial / redistribution restrictions
Per license.

### Phase 10 — Risk rating
Block / Review / Obligation / Clear.

### Phase 11 — Remediation options
Per blocking finding.

### Phase 12 — SBOM + audit trail
CycloneDX / SPDX.

### Phase 13 — Diagrams
Class distribution + ratings.

### Phase 14 — Diagram rendering
Per mixin.

### Phase 15 — Report assembly and approval
Approval before save. Disclaimer included.

---

## Output contract

```markdown
# License Compatibility Analysis: [Project]

**Date**: [date]
**Distribution model**: [...]
**Project license**: [...]

> Disclaimer: Not legal advice.

## Scope
## Methodology
## Dependency Inventory
## License Classification Summary
## Per-Dependency Findings
## Obligations
## AI Model / Data Licenses
## Patent-Relevant Findings
## Commercial / Redistribution Restrictions
## Risk Ratings
## Remediation Plan
## SBOM Reference
## Diagrams
## Assumptions & Limitations
## Hand-offs
```

### Diagrams
- **Class distribution** — Mermaid `pie`
- **Findings by rating** — Mermaid `xychart-beta`

---

## Assessment and planning policy

- Evidence per dep
- Distribution model drives answer
- AGPL / SSPL distinct
- Unknown = finding
- SBOM referenced
- Obligations enumerated
- Disclaimer present
- No fabricated licenses

---

## Self-check

```
[] Distribution model stated
[] Disclaimer prominent
[] SBOM or manifest referenced
[] Every dep has SPDX id or marked unknown
[] Classification per dep
[] Compatibility matrix applied
[] Per-finding action
[] Obligations enumerated
[] AI/data licenses if applicable
[] Remediation plan for blocking
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No distribution model | Interview mode (§7) |
| No manifest | Recommend Syft / ecosystem tool |
| License missing | Mark unknown + flag |
| Legal-advice request | Decline; redirect to counsel |
| Contract interpretation | Decline |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Disclaimer present
- [ ] Distribution model + project license captured
- [ ] Transitive deps included
- [ ] Per-finding SPDX identifier
- [ ] Obligations aligned with license text
- [ ] Patent-relevant deps flagged
- [ ] Remediation realistic per case

---

## Examples

### Normal cases

**1. SaaS product, mostly MIT/Apache**
- Expected: Mostly Clear + Obligation; NOTICE file plan; scan for stray AGPL

**2. On-prem binary for enterprise**
- Expected: Stricter copyleft treatment; LGPL relink obligations flagged; GPL findings block or isolate

**3. Mobile SDK distributed to third parties**
- Expected: Strong-copyleft findings mostly block; MIT/Apache OK with aggregated third-party screen

**4. AI product with model weights**
- Expected: Llama/Gemma/OpenRAIL terms reviewed; data-set licenses checked; commercial usage clauses flagged

**5. Re-audit post dep update**
- Expected: Diff new licenses vs last audit; SBOM diff; regression findings

### Edge cases

**6. Dual-licensed project**
- Input: Qt (LGPL-3.0 or commercial)
- Expected: Choose branch; note commercial path if LGPL problematic

**7. Unknown license package**
- Expected: Block; request upstream clarification; potentially replace

**8. BSL package in production**
- Input: Product relying on a BSL'd DB
- Expected: Read clause; check competitive-use + time-to-open conversion; legal review

### Failure cases

**9. Legal-advice request**
- Input: "Can we ship this?"
- Expected: "Engineering artifact; counsel decides. Here are the facts + ratings."

**10. No distribution model**
- Input: Missing context
- Expected: Interview — distribution model mandatory
